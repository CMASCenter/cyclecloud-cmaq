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

```
ssh -Y username@IP-address
```

## Verify Software

The software is pre-loaded on the /lustre volume of the CycleCloud.  

```
ls /lustre/build
```


Load the modules

```
module avail
```

Output:

```
---------------------------------------------------------- /usr/share/Modules/modulefiles ----------------------------------------------------------
amd/aocl        dot        module-git   modules   mpi/hpcx-v2.9.0  mpi/impi_2021.2.0  mpi/mvapich2-2.3.6  mpi/openmpi-4.1.1  use.own  
amd/aocl-2.2.1  gcc-9.2.1  module-info  mpi/hpcx  mpi/impi-2021    mpi/mvapich2       mpi/openmpi         null               

-------------------------------------------------------- /shared/build/Modules/modulefiles ---------------------------------------------------------
hdf5-1.10.5/gcc-9.2.1  ioapi-3.2_20200828/gcc-9.2.1-hdf5  ioapi-3.2_20200828/gcc-9.2.1-netcdf  netcdf-4.8.1/gcc-9.2.1  
```

Load the modules for the netCDF-4 compressed libraries.

```
module load ioapi-3.2_20200828/gcc-9.2.1-hdf5
```

output:
```

```

Change the group and ownership permissions on the /lustre/data directory

```
sudo chown ubuntu /lustre/data
sudo chgrp ubuntu /lustre/data
```

Create the output directory

```
mkdir -p /lustre/data/output
```


## Download the input data from the AWS Open Data CMAS Data Warehouse.

Do a git pull to obtain the latest scripts in the cyclecloud-cmaq repo.

```
cd /lustre/cyclecloud-cmaq
git pull
```

```
cd /shared/cyclecloud-cmaq/s3_scripts
./s3_copy_nosign_2018_12US1_conus_cmas_opendata_to_lustre_20171222_cb6r3.csh
```

## Verify Input Data

```
cd /lustre/data_lim/CMAQ_Modeling_Platform_2018/2018_12US1
du -h
```

Output

```
40K	./CMAQ_v54+_cb6r5_scripts
44K	./CMAQ_v54+_cracmm_scripts
1.6G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/cmv_c1c2_12
2.4G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/cmv_c3_12
5.1G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/merged_nobeis_norwc
1.4G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/othpt
1.3G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/pt_oilgas
6.7M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptagfire
255M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptegu
19M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptfire
2.9M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptfire_grass
3.0M	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptfire_othna
5.9G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready/ptnonipm
18G	./emis/cb6r3_ae6_20200131_MYR/cmaq_ready
3.5G	./emis/cb6r3_ae6_20200131_MYR/premerged/rwc
3.5G	./emis/cb6r3_ae6_20200131_MYR/premerged
22G	./emis/cb6r3_ae6_20200131_MYR
60K	./emis/emis_dates
22G	./emis
2.3G	./epic
13G	./icbc/CMAQv54_2018_108NHEMI_M3DRY
17G	./icbc
41G	./met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed
41G	./met
4.0G	./misc
697M	./surface
85G	.

```


## Examine CMAQ Run Scripts

The run scripts are available in two locations, one in the CMAQ scripts directory. 

Another copy is available in the cyclecloud-cmaq repo.

Copy the run scripts from the repo.
Note, there are different run scripts depending on what compute node is used. This tutorial assumes hpc6a-48xlarge is the compute node.

```
cp   /shared/cyclecloud-cmaq/run_scripts/2018_12US1_CMAQv54plus/run_cctm_2018_12US1_v54_cb6r3_ae6.20171222.csh /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/
```

```{note}
The time that it takes the 2 day CONUS benchmark to run will vary based on the number of CPUs used, and the compute node that is being used, and what disks are used for the I/O (shared or lustre).
The Benchmark Scaling Plot for hbv3_120 on lustre and shared (include here).
```

Examine how the run script is configured

```
head -n 30 /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/run_cctm_2018_12US1_v54_cb6r3_ae6.20171222.csh
```

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

`sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.retest.csh`


### Check status of run

`squeue `

Output:

```

```

It takes about 5-8 minutes for the compute nodes to spin up, after the nodes are available, the status will change from CF to R.


### Successfully started run

`squeue`

```

```

### Once the job is successfully running 

Check on the log file status

`grep -i 'Processing completed.' run_cctm5.4+_Bench_2018_12US1_M3DRY_cb6r3_ae6_20200131_MYR.256.16x16pe.2day.20171222start.log`

Output:


```

```

Once the job has completed running the two day benchmark check the log file for the timings.

```
tail -n 18 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2day.20171222start.2x96.log
```

Output:

```
          OUTDIR  |  /lustre/data_lim/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_2x96_classic

==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2017-12-22
End Day:   2017-12-23
Number of Simulation Days: 2
Domain Name:               12US1
Number of Grid Cells:      4803435  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       192
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   1813.3
02   2017-12-23   2077.7
     Total Time = 3891.00
      Avg. Time = 1945.50


```

## Submit a run script to run on the shared volume

To run on the shared volume, you need to copy the input data from the s3 bucket to the /shared volume.
You don't want to copy directly from the /lustre volume, as this will copy more files than you need. The s3 copy script below copies only two days worth of data from the s3 bucket.
If you copy from /lustre directory, you would be copying all of the files on the s3 bucket.

```
cd /shared/data
aws s3 --no-sign-request --region=us-east-1 cp --recursive s3://cmas-cmaq/CMAQv5.4_2018_12US1_Benchmark_2Day_Input .
```

### Submit a 96 pe job 1 nodes x 96 cpus on the EBS volume /shared

```
cd /shared/build/openmpi_gcc/CMAQ_v54+_classic/CCTM/scripts
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.1x96.ncclassic.retest.shared.csh 
```

### The per-processor log files are beind sent to the output directory

```
cd /shared/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x96_classic_retest
grep -i 'Processing completed.' CTM_LOG_000*


Output:

```
            Processing completed...      11.1089 seconds
            Processing completed...       8.5691 seconds
            Processing completed...       8.5596 seconds
            Processing completed...       8.5419 seconds
            Processing completed...       8.4918 seconds
            Processing completed...       8.4257 seconds
            Processing completed...       8.3264 seconds
            Processing completed...       8.2567 seconds
            Processing completed...       8.3922 seconds
            Processing completed...       8.0141 seconds
            Processing completed...       8.2161 seconds
            Processing completed...      10.3496 seconds
```

tail -n 18 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.96.8x12pe.2day.20171222start.1x96.shared.log

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
Number of Processes:       96
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   3744.5
02   2017-12-23   4184.8
     Total Time = 7929.30
      Avg. Time = 3964.65

```

Going to test running on 96 cpu/node

`sbatch run_cctm_2018_12US1_v54_cb6r3_ae6.20171222.2x96.csh`

getting an error

```
     Processing Day/Time [YYYYDDD:HHMMSS]: 2017356:095500
       Which is Equivalent to (UTC): 9:55:00  Friday,  Dec. 22, 2017
       Time-Step Length (HHMMSS): 000500
                 VDIFF completed...       2.5918 seconds
                COUPLE completed...       0.1093 seconds
                  HADV completed...       1.7682 seconds
                  ZADV completed...       0.1838 seconds
                 HDIFF completed...       0.1922 seconds
              DECOUPLE completed...       0.0270 seconds
                  PHOT completed...       0.1236 seconds
               CLDPROC completed...       1.2388 seconds
                  CHEM completed...       0.6030 seconds
                  AERO completed...       0.7680 seconds
            Master Time Step
            Processing completed...       7.6066 seconds

      =--> Data Output completed...       1.9993 seconds

     Processing Day/Time [YYYYDDD:HHMMSS]: 2017356:100000
       Which is Equivalent to (UTC): 10:00:00 Friday,  Dec. 22, 2017
       Time-Step Length (HHMMSS): 000500
--------------------------------------------------------------------------
Primary job  terminated normally, but 1 process returned
a non-zero exit code. Per user-direction, the job has been aborted.
--------------------------------------------------------------------------
--------------------------------------------------------------------------
mpirun noticed that process rank 7 with PID 0 on node cyclecloudlizadams-hpc-pg0-1 exited on signal 9 (Killed).
--------------------------------------------------------------------------
30348.546u 996.456s 12:12.83 4277.2%	0+0k 9708555+14629912io 1223pf+0w

**************************************************************
** Runscript Detected an Error: CGRID file was not written. **
**   This indicates that CMAQ was interrupted or an issue   **
**   exists with writing output. The runscript will now     **
**   abort rather than proceeding to subsequent days.       **
**************************************************************

==================================
  ***** CMAQ TIMING REPORT *****
==================================
Start Day: 2017-12-22
End Day:   2017-12-23
Number of Simulation Days: 1
Domain Name:               12US1
Number of Grid Cells:      4803435  (ROW x COL x LAY)
Number of Layers:          35
Number of Processes:       192
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   7
     Total Time = 7.00
      Avg. Time = 7.00
slurmstepd: error: Detected 2 oom-kill event(s) in StepId=47.batch cgroup. Some of your processes may have been killed by the cgroup out-of-memory handler.

```

Trying a run after converting the nc4 files to nc classic compressed files to see if the out-of-memory is due to a memory leak in the nc4 compressed libraries.

steps: 

1. rebuild the CMAQv5.4+ code with uncompressed libraries <br>

```
module load ioapi-3.2_20200828/gcc-9.2.1-netcdf 
```

2. create a new project directory to compile the code

```
cd /shared/build/CMAQ_REPO_v54+
git pull
```

edit bldit_project.csh to use

```
 set CMAQ_HOME =  /shared/build/openmpi_gcc/CMAQ_v54+_classic
```

Run bldit_project.csh

```
./bldit_project.csh
```

Change directories to the new build location.

```
cd /shared/build/openmpi_gcc/CMAQ_v54+_classic
```

Copy the config_cmaq.csh script from the  v533 version, as that has the paths specified for the netCDF classic and I/O API libraries

```
cp /shared/build/openmpi_gcc/CMAQ_v533/config_cmaq.csh .
```

Edit to specify repo.

```
 setenv CMAQ_REPO $BUILD/CMAQ_REPO_v54+
```

Run the bldit_cctm.csh script

```
cd /shared/build/openmpi_gcc/CMAQ_v54+_classic/CCTM/scripts
./bldit_cctm.csh gcc |& tee bldit_cctm.log
```

Verify that the executable was created

```
ls -rlt */*.exe
```

Output:

```
-rwxrwxr-x. 1 lizadams lizadams 152894280 Mar 10 20:12 BLD_CCTM_v54+_gcc/CCTM_v54+.exe
```


Modify the run script to change the .nc4 extension to .nc and submit job

```
sbatch run_cctm_2018_12US1_v54_cb6r3_ae6.20171222.2x96.ncclassic.csh
```

This ran succesfully to completion without getting a memory leak error.

Output

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
Number of Processes:       192
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   1767.5
02   2017-12-23   1991.3
     Total Time = 3758.80
      Avg. Time = 1879.40

```





## Submit a minimum of 2 benchmark runs

NOTE, trying to reproduce this run on HBv120 Cluster am getting slower times.

```
tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2day.20171222start.2x96.shared.log
```

Output

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
Number of Processes:       192
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   2549.7
02   2017-12-23   2752.4
     Total Time = 5302.10
      Avg. Time = 2651.05
```

Ideally, two CMAQ runs should be submitted to the slurm queue, using two different NPCOLxNPROW configurations, to create output needed for the QA and Post Processing Sections in Chapter 6.
