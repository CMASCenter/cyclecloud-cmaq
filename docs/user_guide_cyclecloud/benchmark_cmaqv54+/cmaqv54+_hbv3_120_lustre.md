CMAQv4+ CONUS Benchmark Tutorial using 12US1 Domain

## Use Cycle Cloud pre-installed with CMAQv5.4+ software and 12US1 Benchmark data.

Step by step instructions for running the CMAQ 12US1 Benchmark for 2 days on a Cycle Cloud
The input files are *.nc4, which requires the netCDF-4 compressed libraries. Instructions are provided below on how to use load module command to obtain the correct version of the I/O API, netCDF-C, netCDF-Fortran libraries.


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

Load the modules for the netCDF-4 compressed libraries.

`module load ioapi-3.2_20200828/gcc-9.2.1-hdf5`

output:
```

```

Change the group and ownership permissions on the /lustre/data directory

`sudo chown ubuntu /lustre/data`

`sudo chgrp ubuntu /lustre/data`

Create the output directory

`mkdir -p /lustre/data/output`


## Download the input data from the AWS Open Data CMAS Data Warehouse.

Do a git pull to obtain the latest scripts in the cyclecloud-cmaq repo.

`cd /lustre/cyclecloud-cmaq`

`git pull`

```
cd /shared/cyclecloud-cmaq/s3_scripts
./s3_copy_nosign_2018_12US1_conus_cmas_opendata_to_lustre_20171222_cb6r3.csh

## Verify Input Data


`cd /lustre/data_lim/CMAQ_Modeling_Platform_2018/2018_12US1`


`du -h`

Output

```
3.5G	./misc
16G	./met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed
16G	./met
13G	./icbc/CMAQv54_2018_108NHEMI_M3DRY
17G	./icbc
60K	./emis/emis_dates
581M	./emis/cb6r3_ae6_20200131_MYR/premerged/rwc
581M	./emis/cb6r3_ae6_20200131_MYR/premerged
2.0M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptfire_othna
1.3G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptnonipm
98M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/cmv_c3_12
1.9M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptfire_grass
1.8G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/merged_nobeis_norwc
272M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/pt_oilgas
2.3M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptagfire
510M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/othpt
5.4M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptfire
86M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/cmv_c1c2_12
50M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptegu
4.0G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready
4.6G	./emis/cb6r3_ae6_20200131_MYR
4.6G	./emis
694M	./surface
73M	./epic
41G	.

```


## Examine CMAQ Run Scripts

The run scripts are available in two locations, one in the CMAQ scripts directory. 

Another copy is available in the cyclecloud-cmaq repo.

Copy the run scripts from the repo.
Note, there are different run scripts depending on what compute node is used. This tutorial assumes hpc6a-48xlarge is the compute node.

`cp   /shared/cyclecloud-cmaq/run_scripts/2018_12US1_CMAQv54plus/run_cctm_2018_12US1_v54_cb6r3_ae6.20171222.csh /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/`

```{note}
The time that it takes the 2 day CONUS benchmark to run will vary based on the number of CPUs used, and the compute node that is being used, and what disks are used for the I/O (shared or lustre).
The Benchmark Scaling Plot for hbv3_120 on lustre and shared (include here).
```

Examine how the run script is configured

`head -n 30 /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/run_cctm_2018_12US1_v54_cb6r3_ae6.20171222.csh`

```
#!/bin/csh -f

## For CycleCloud 120pe
## data on /lustre data directory
## https://dataverse.unc.edu/dataset.xhtml?persistentId=doi:10.15139/S3/LDTWKH
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=64
#SBATCH --exclusive
#SBATCH -J CMAQ
#SBATCH -o /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_M3DRY_cb6r3_ae6_20200131_MYR.256.16x16pe.2day.20171222start.log
#SBATCH -e /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_M3DRY_cb6r3_ae6_20200131_MYR.256.16x16pe.2day.20171222start.log


# ===================== CCTMv5.4.X Run Script ========================= 
# Usage: run.cctm >&! cctm_2018_12US1.log &                                
#
# To report problems or request help with this script/program:
#             http://www.epa.gov/cmaq    (EPA CMAQ Website)
#             http://www.cmascenter.org  (CMAS Website)
# ===================================================================  

# ===================================================================
#> Runtime Environment Options
# ===================================================================

echo 'Start Model Run At ' `date`

#> Toggle Diagnostic Mode which will print verbose information to 
#> standard output
 setenv CTM_DIAG_LVL 0

```

```{note}
In this run script, slurm or SBATCH requests 4 nodes, each node with 64 pes, or 4x64 = 576 pes
```

Verify that the NPCOL and NPROW settings in the script are configured to match what is being requested in the SBATCH commands that tell slurm how many compute nodes to  provision. 
In this case, to run CMAQ using on 256 cpus (SBATCH --nodes=4 and --ntasks-per-node=64), use NPCOL=16 and NPROW=16.

`grep NPCOL run_cctm_2018_12US1_v54_cb6r3_ae6.20171222.csh`

Output:

```
#> Horizontal domain decomposition
if ( $PROC == serial ) then
   setenv NPCOL_NPROW "1 1"; set NPROCS   = 1 # single processor setting
else
   @ NPCOL  =  16; @ NPROW =  16
   @ NPROCS = $NPCOL * $NPROW
   setenv NPCOL_NPROW "$NPCOL $NPROW";
endif

```


## To run on the Shared Volume a code modification is required. 
Note, we will use this modification when running on both lustre and shared.

Copy the BLD directory with a code modification to wr_conc.F, wr_aconc.F, and opaconc.F to your directory.

`cp -rp /shared/cyclecloud-cmaq/BLD_CCTM_v54+_gcc_codefix /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts``

## Build the code by running the makefile

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts`

Check to see you have the modules loaded

`module list`

```
Currently Loaded Modulefiles:
 1) gcc-9.2.1   2) mpi/openmpi-4.1.1   3) hdf5-1.10.5/gcc-9.2.1   4) ioapi-3.2_20200828/gcc-9.2.1-hdf5  
```

Run the Make command

`make`

Verify that the executable has been created

`ls -lrt CCTM_v54+.exe`


## Submit Job to Slurm Queue to run CMAQ on Lustre

`cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts`

`sbatch run_cctm_2016_12US2.576.6x96.cyclecloud.hpcx.codemod.lustre3.precision.csh`


### Check status of run

`squeue `

Output:

```
       JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                42       hpc     CMAQ lizadams CF       0:08      4 cyclecloudlizadams-hpc-pg0-[1-4]

```

It takes about 5-8 minutes for the compute nodes to spin up, after the nodes are available, the status will change from CF to R.


### Successfully started run

`squeue`

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                42       hpc     CMAQ lizadams  R       0:01      4 cyclecloudlizadams-hpc-pg0-[1-4]

```

### Once the job is successfully running 

Check on the log file status

`grep -i 'Processing completed.' run_cctm5.4+_Bench_2018_12US1_M3DRY_cb6r3_ae6_20200131_MYR.256.16x16pe.2day.20171222start.log`

Output:


```
            Processing completed...       5.0603 seconds
            Processing completed...       3.5109 seconds
            Processing completed...       3.5089 seconds
            Processing completed...       3.4871 seconds
            Processing completed...       3.5024 seconds
            Processing completed...       3.4826 seconds
            Processing completed...       3.5128 seconds
            Processing completed...       3.4915 seconds

```

Once the job has completed running the two day benchmark check the log file for the timings.
`tail -n 18 run_cctm5.4+_Bench_2018_12US1_M3DRY_cb6r3_ae6_20200131_MYR.256.16x16pe.2day.20171222start.log`

Output:

```
==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2017-12-22
End Day:   2017-12-23
Number of Simulation Days: 2
Domain Name:               12US1
Number of Grid Cells:      4803435  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       256
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   1253.8
02   2017-12-23   1401.1
     Total Time = 2654.90
      Avg. Time = 1327.45

```

## Submit a run script to run on the shared volume

To run on the shared volume, you need to copy the input data from the s3 bucket to the /shared volume.
You don't want to copy directly from the /lustre volume, as this will copy more files than you need. The s3 copy script below copies only two days worth of data from the s3 bucket.
If you copy from /lustre directory, you would be copying all of the files on the s3 bucket.

```
cd /lustre/cyclecloud-cmaq/s3_scripts
./s3_copy_nosign_conus_cmas_opendata_to_shared.csh
```

### Submit a 576 pe job 6 nodes x 96 cpus on the EBS volume /shared

```
cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts
sbatch  run_cctm_2016_12US2.576.6x96.cyclecloud.hpcx.codemod_liz.shared.pin.csh
```

### The per-processor log files are beind sent to the output directory

`cd /shared/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_shared_20171222start`


`grep -i 'Processing completed.' CTM_LOG_000*`


Output:

```
           Processing completed...       3.4807 seconds
            Processing completed...       3.5021 seconds
            Processing completed...       3.5022 seconds
            Processing completed...       3.4999 seconds
            Processing completed...       4.5920 seconds
            Processing completed...       8.4824 seconds
            Processing completed...       3.5537 seconds
            Processing completed...       3.5272 seconds

```

`tail -n 18 run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.shared.codemod_liz.pin.2nd.log`

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
01   2015-12-22   1597.27
02   2015-12-23   1516.56
     Total Time = 3113.83
      Avg. Time = 1556.91



```

## Submit a minimum of 2 benchmark runs

Ideally, two CMAQ runs should be submitted to the slurm queue, using two different NPCOLxNPROW configurations, to create output needed for the QA and Post Processing Sections in Chapter 6.
