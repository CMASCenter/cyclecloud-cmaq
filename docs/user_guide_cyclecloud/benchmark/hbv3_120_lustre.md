CMAQv5.3.3 CONUS 2 Benchmark Tutorial using 12US2 Domain

## Use Cycle Cloud pre-installed with CMAQv5.3.3 software and 12US2 Benchmark data.

Step by step instructions for running the CMAQ 12US2 Benchmark for 2 days on a Cycle Cloud


## This method relies on obtaining the code and data from blob storage.

```{note} 
Information about how to share a snapshot of a Blob Storage account:
<a href="https://learn.microsoft.com/en-us/azure/data-share/how-to-share-from-storage">Share from Blob Storage Account"</a>
```

You will need to copy the snapshot and create a new blob storage, and then use your Blob Storage as the backup to your Lustre Filesystem.

#### Use a configuration file from the github by cloning the repo to your local machine 

```
cd /lustre
sudo mkdir cyclecloud-cmaq
sudo chown username cyclecloud-cmaq
git clone -b main https://github.com/CMASCenter/cyclecloud-cmaq
```


`cd cyclecloud-cmaq`


### Lustre -  Request Public Preview

```{note} Information about the Public Preview for Azure Managed Lustre see:
<a href="https://azure.microsoft.com/en-ca/blog/azure-managed-lustre-parallel-file-system-for-hpc-and-ai-workloads/">Azure Managed Lustre</a>
<a href="https://techcommunity.microsoft.com/t5/azure-high-performance-computing/azure-managed-lustre-benchmarking-our-new-azure-storage-solution/ba-p/3743889">Benchmarking Lustre</a>
```


See information on how to join: <a href="https://learn.microsoft.com/en-us/azure/azure-managed-lustre/amlfs-overview">Azure Managed Lustre - Registration form link</a>

### Create Lustre Server 


### Blob Storage - Lustre hierarchical storage management 


## Update Cycle Cloud 



## Log into the new cluster
```{note}
Use your username and credentials to login
```

`ssh -Y username@IP-address``

## Verify Software

The software is pre-loaded on the /lustre volume of the CycleCloud.  

`ls /lustre/build`

Load the modules

`module avail`

Output:

```
---------------------------------------------------------- /usr/share/Modules/modulefiles ----------------------------------------------------------
amd/aocl        dot        module-git   modules   mpi/hpcx-v2.9.0  mpi/impi_2021.2.0  mpi/mvapich2-2.3.6  mpi/openmpi-4.1.1  use.own  
amd/aocl-2.2.1  gcc-9.2.1  module-info  mpi/hpcx  mpi/impi-2021    mpi/mvapich2       mpi/openmpi         null               

-------------------------------------------------------- /shared/build/Modules/modulefiles ---------------------------------------------------------
hdf5-1.10.5/gcc-9.2.1  ioapi-3.2_20200828/gcc-9.2.1-hdf5  ioapi-3.2_20200828/gcc-9.2.1-netcdf  netcdf-4.8.1/gcc-9.2.1  
```

Load the modules for the classic-netCDF libraries.

`module load ioapi-3.2_20200828/gcc-9.2.1-netcdf`

output:
```
Loading ioapi-3.2_20200828/gcc-9.2.1-netcdf
  Loading requirement: gcc-9.2.1 mpi/openmpi-4.1.1 netcdf-4.8.1/gcc-9.2.1
```

## Verify Input Data

The input data was imported from the S3 bucket to the lustre file system (/lustre).

`cd /lustre/data/CMAQ_Modeling_Platform_2016/CONUS/12US2/`

Notice that the data doesn't take up much space, only the objects are loaded, the datasets will not be loaded to the /lustre volume until they are used either by the run scripts or using the touch command.

```{note} More information about enhanced s3 integration for Lustre see:
<a href="https://aws.amazon.com/blogs/aws/enhanced-amazon-s3-integration-for-amazon-fsx-for-lustre/">Enhanced S3 integration with lustre</a>
```



`du -h`

Output:

```
27K     ./land
33K     ./MCIP
28K     ./emissions/ptegu
55K     ./emissions/ptagfire
27K     ./emissions/ptnonipm
55K     ./emissions/ptfire_othna
27K     ./emissions/pt_oilgas
26K     ./emissions/inln_point/stack_groups
51K     ./emissions/inln_point
28K     ./emissions/cmv_c1c2_12
28K     ./emissions/cmv_c3_12
28K     ./emissions/othpt
55K     ./emissions/ptfire
407K    ./emissions
27K     ./icbc
518K    .
```

Change the group and ownership permissions on the /lustre/data directory

`sudo chown ubuntu /lustre/data`

`sudo chgrp ubuntu /lustre/data`

Create the output directory

`mkdir -p /lustre/data/output`

## Examine CMAQ Run Scripts

The run scripts are available in two locations, one in the CMAQ scripts directory. 

Another copy is available in the cyclecloud-cmaq repo.
Do a git pull to obtain the latest scripts in the cyclecloud-cmaq repo.

`cd /lustre/cyclecloud-cmaq`

`git pull`

Copy the run scripts from the repo.
Note, there are different run scripts depending on what compute node is used. This tutorial assumes hpc6a-48xlarge is the compute node.

`cp   /lustre/cyclecloud-cmaq/run_scripts/CycleCloud_HB120v3_lustre3_250/* /lustre/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

```{note}
The time that it takes the 2 day CONUS benchmark to run will vary based on the number of CPUs used, and the compute node that is being used, and what disks are used for the I/O (shared or lustre).
The Benchmark Scaling Plot for hbv3_120 on lustre and shared (include here).
```

Examine how the run script is configured

`head -n 30 /lustre/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctm_2016_12US2.576.6x96.cyclecloud.hpcx.codemod.lustre3.precision.csh`

```
#!/bin/csh -f
## For CycleCloud 120pe 
## data on /lustre/data directory
#SBATCH --nodes=6
#SBATCH --ntasks-per-node=96
#SBATCH --exclusive
#SBATCH -J CMAQ
#SBATCH -o /lustre/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.lustre3.codemod.pin.precision.log
#SBATCH -e /lustre/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.lustre3.codemod.pin.precision.log
```

```{note}
In this run script, slurm or SBATCH requests 6 nodes, each node with 96 pes, or 6x96 = 576 pes
```

Verify that the NPCOL and NPROW settings in the script are configured to match what is being requested in the SBATCH commands that tell slurm how many compute nodes to  provision. 
In this case, to run CMAQ using on 108 cpus (SBATCH --nodes=6 and --ntasks-per-node=69), use NPCOL=24 and NPROW=24.

`grep NPCOL run_cctm_2016_12US2.576.6x96.cyclecloud.hpcx.codemod.lustre3.precision.csh`

Output:

```
   setenv NPCOL_NPROW "1 1"; set NPROCS   = 1 # single processor setting
   @ NPCOL  =  24; @ NPROW = 24
   @ NPROCS = $NPCOL * $NPROW
   setenv NPCOL_NPROW "$NPCOL $NPROW"; 
```


## To run on the Shared Volume a code modification is required. 
Note, we will use this modification when running on both lustre and shared.

Copy the BLD directory with a code modification to wr_conc.F and wr_aconc.F to your directory.

`cp -rp /shared/pcluster-cmaq/run_scripts/BLD_CCTM_v533_gcc_codemod /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

## Build the code by running the makefile

cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc_codemod

Check to see you have the modules loaded

`module list`

```
Currently Loaded Modulefiles:
 1) gcc-9.2.1   2) mpi/openmpi-4.1.1   3) netcdf-4.8.1/gcc-9.2.1   4) ioapi-3.2_20200828/gcc-9.2.1-netcdf  
```

Run the Make command

`make`

Verify that the executable has been created

`ls -lrt CCTM_v533.exe`


## Submit Job to Slurm Queue to run CMAQ on Lustre

`cd /lustre/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

`sbatch run_cctm_2016_12US2.576.6x96.cyclecloud.hpcx.codemod.lustre3.precision.csh`


### Check status of run

`squeue `

Output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                36       hpc     CMAQ lizadams CF       2:15      6 cyclecloudlizadams-hpc-pg0-[1-6]

```

### Successfully started run

`squeue`

```
            JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                36       hpc     CMAQ lizadams  R       0:47      6 cyclecloudlizadams-hpc-pg0-[1-6]
```

### Once the job is successfully running 

Check on the log file status

`grep -i 'Processing completed.' CTM_LOG_001*_gcc_2016*`

Output:


```
            Processing completed...  1.936 seconds
            Processing completed...  1.939 seconds
            Processing completed...  1.935 seconds
            Processing completed...  1.942 seconds
            Processing completed...  1.942 seconds
            Processing completed...  1.936 seconds
            Processing completed...  1.943 seconds
            Processing completed...  1.939 seconds
            Processing completed...  2.859 seconds

```

Once the job has completed running the two day benchmark check the log file for the timings.

`tail -n 5 run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.576.6x96.24x24pe.2day.pcluster.fsx.pin.codemod.2.log`

Output:

```
Num  Day        Wall Time
01   2015-12-22   1028.33
02   2015-12-23   916.31
     Total Time = 1944.64
      Avg. Time = 972.32
```

## Submit a run script to run on the shared volume

To run on the shared volume, you need to copy the input data from the s3 bucket to the /shared volume.
You don't want to copy directly from the /lustre volume, as this will copy more files than you need. The s3 copy script below copies only two days worth of data from the s3 bucket.
If you copy from /lustre directory, you would be copying all of the files on the s3 bucket.

```
cd /shared/pcluster-cmaq/s3_scripts
./s3_copy_nosign_conus_cmas_opendata_to_shared.csh
```

### Submit a 576 pe job 6 nodes x 96 cpus on the EBS volume /shared

`sbatch run_cctm_2016_12US2.576pe.6x96.24x24.pcluster.hpc6a.48xlarge.shared.pin.csh`

`grep -i 'Processing completed.' CTM_LOG_036.v533_gcc_2016_CONUS_6x12pe_20151223`

Output:

```
            Processing completed... 61.078 seconds
            Processing completed...  1.972 seconds
            Processing completed...  1.977 seconds
            Processing completed...  1.981 seconds
            Processing completed...  1.976 seconds
            Processing completed...  1.964 seconds
            Processing completed...  1.957 seconds
            Processing completed...  1.942 seconds
            Processing completed...  1.958 seconds
            Processing completed...  1.947 seconds
            Processing completed...  1.936 seconds

```


`tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.lustre3.codemod.pin.precision.log`

Output:

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2015-12-22
End Day:   2015-12-23
Number of Simulation Days: 2
Domain Name:               12US2
Number of Grid Cells:      3409560  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       576
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   1023.92
02   2015-12-23   825.48
     Total Time = 1849.40
      Avg. Time = 924.70

```

## Submit a minimum of 2 benchmark runs

Ideally, two CMAQ runs should be submitted to the slurm queue, using two different NPCOLxNPROW configurations, to create output needed for the QA and Post Processing Sections in Chapter 6.
