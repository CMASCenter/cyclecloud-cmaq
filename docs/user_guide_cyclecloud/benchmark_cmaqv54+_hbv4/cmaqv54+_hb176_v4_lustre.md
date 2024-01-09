CMAQv4+ CONUS Benchmark Tutorial using 12US1 Domain

## Use Cycle Cloud pre-installed with CMAQv5.4+ software and 12US1 Benchmark data.

Step by step instructions for running the CMAQ 12US1 Benchmark for 2 days on a Cycle Cloud
The input files are *.nc4, which requires the netCDF-4 compressed libraries. Instructions are provided below on how to use load module command to obtain the correct version of the I/O API, netCDF-C, netCDF-Fortran libraries.


## Log into the new cluster
```{note}
Use your username and credentials to login
```

`ssh -Y username@IP-address``

Load the modules

`module avail`

Output:

```
---------------------------------------------------------- /usr/share/Modules/modulefiles ----------------------------------------------------------
amd/aocl      dot        module-git   modules   mpi/hpcx-v2.16  mpi/impi_2021.9.0  mpi/mvapich2-2.3.7-1  mpi/openmpi-4.1.5  use.own  
amd/aocl-4.0  gcc-9.2.0  module-info  mpi/hpcx  mpi/impi-2021   mpi/mvapich2       mpi/openmpi           null               

```

## Download the input data from the AWS Open Data CMAS Data Warehouse.

Do a git pull to obtain the latest scripts in the cyclecloud-cmaq repo.

```
cd /shared/data
aws s3 --no-sign-request --region=us-east-1 cp --recursive s3://cmas-cmaq/CMAQv5.4_2018_12US1_Benchmark_2Day_Input .
```

## Verify Input Data

```
cd /shared/data
mkdir /shared/data/CMAQ_Modeling_Platform_2018
cd /shared/data/CMAQ_Modeling_Platform_2018
ln -s ../2018_12US1 .
cd /shared/data/CMAQ_Modeling_Platform_2018/2018_12US1`
```


`du -h`

Output

```
44K	./CMAQ_v54+_cracmm_scripts
40K	./CMAQ_v54+_cb6r5_scripts
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

Copy the run scripts.
Note, there are different run scripts depending on what compute node is used. This tutorial assumes hpc6a-48xlarge is the compute node.

```
cd /shared/cyclecloud-cmaq/run_scripts/HB176v4 
cp  *.csh /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/
```

```{note}
The time that it takes the 2 day CONUS benchmark to run will vary based on the number of CPUs used, and the compute node that is being used, and what disks are used for the I/O (shared or lustre).
The Benchmark Scaling Plot for hbv176_v4 on shared (include here).
```

Examine how the run script is configured

```
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/
head -n 30 run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.1x176.ncclassic.csh
```

```
#!/bin/csh -f

## For CycleCloud 176pe
## data on /shared data directory
## https://dataverse.unc.edu/dataset.xhtml?persistentId=doi:10.15139/S3/LDTWKH
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=176
#SBATCH --exclusive
#SBATCH -J CMAQ
#SBATCH -o /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.176.16x11pe.2day.20171222start.1x176.log
#SBATCH -e /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.176.16x11pe.2day.20171222start.1x176.log


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
In this run script, slurm or SBATCH requests 1 node, each node with 176 pes
```

Verify that the NPCOL and NPROW settings in the script are configured to match what is being requested in the SBATCH commands that tell slurm how many compute nodes to  provision. 
In this case, to run CMAQ using on 176 cpus (SBATCH --nodes=1 and --ntasks-per-node=176), use NPCOL=16 and NPROW=11.

```
grep NPCOL run_cctm_2018_12US1_v54_cb6r3_ae6.20171222.csh
```

Output:

```
 setenv NPCOL_NPROW "1 1"; set NPROCS   = 1 # single processor setting
   @ NPCOL  =  16; @ NPROW =  11
   @ NPROCS = $NPCOL * $NPROW
   setenv NPCOL_NPROW "$NPCOL $NPROW"; 

```



## Submit Job to Slurm Queue to run CMAQ on 2 nodes

```
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x176.ncclassic.csh
```


### Check status of run

```
squeue 
```

Output:

```
       JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)

```

It takes about 5-8 minutes for the compute nodes to spin up, after the nodes are available, the status will change from CF to R.


### Successfully started run

```
squeue
```

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
               10       hpc     CMAQ lizadams  R    1:08:04      2 CycleCloud8-5-hpc-[3-4]

```

### Once the job is successfully running 

Check on the log file status

```
cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts
grep -i 'Processing completed.' run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.352.16x22pe.2day.20171222start.2x176.log`

Output:


```
          Processing completed...      38.3631 seconds
            Processing completed...       2.2522 seconds
            Processing completed...       2.2842 seconds
            Processing completed...       2.2733 seconds
            Processing completed...       2.2939 seconds
            Processing completed...       2.2799 seconds
            Processing completed...       2.2699 seconds
            Processing completed...       2.2948 seconds
            Processing completed...       2.2759 seconds
            Processing completed...       2.2810 seconds
            Processing completed...       2.2850 seconds
            Processing completed...       2.2935 seconds
            Processing completed...       2.3114 seconds
            Processing completed...       2.2939 seconds
            Processing completed...       3.2520 seconds


```

Once the job has completed running the two day benchmark check the log file for the timings.

```
tail -n 18 run_cctm5.4+_Bench_2018_12US1_M3DRY_cb6r3_ae6_20200131_MYR.256.16x16pe.2day.20171222start.log`
```

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
Number of Processes:       352
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   2103.6
02   2017-12-23   2183.0
     Total Time = 4286.60
      Avg. Time = 2143.30

```

## Submit a run script to run on the shared volume


### Submit a 176 pe job 1 nodes x 176 cpus on the EBS volume /shared

```
cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts
sbatch  run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.1x176.ncclassic.csh
```

### The per-processor log files are being sent to the output directory

```
cd /shared/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176
grep -i 'Processing completed.' CTM_LOG_000*
```


Output:

```
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...      33.6960 seconds
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...       3.8317 seconds
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...       3.9250 seconds
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...       3.9163 seconds
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...       3.9316 seconds
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...       3.9393 seconds
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...       3.9570 seconds
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...       3.9355 seconds
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...       3.9535 seconds
CTM_LOG_000.v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_1x176_20171223:            Processing completed...       3.9619 seconds
```

```
cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts
tail -n 18 

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
Number of Processes:       176
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   2573.5
02   2017-12-23   2720.5
     Total Time = 5294.00
      Avg. Time = 2647.00

```
