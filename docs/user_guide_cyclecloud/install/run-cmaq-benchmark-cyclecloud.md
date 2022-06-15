### Copy the run scripts from the CycleCloud repo
Note, the run scripts are tailored to the Compute Node. This assumes the cluster was built with HC44rs compute nodes.

Change directories to where the run scripts are available from the git repo.

`cd /shared/cyclecloud-cmaq/run_scripts/HC44rs`

Copy the run scripts to the run directory

`cp * /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`


### Run the CONUS Domain on 180 pes

`cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/`

`sbatch run_cctm_2016_12US2.180pe.csh`

Note, it will take about 3-5 minutes for the compute notes to start up This is reflected in the Status (ST) of PD (pending), with the NODELIST reason being that it is configuring the partitions for the cluster

### Check the status in the queue

`squeue `

output:

```
[lizadams@CMAQSlurmHC44rsAlmaLinux-scheduler scripts]$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 6       hpc     CMAQ lizadams CF       5:03      5 cmaqslurmhc44rsalmalinux-hpc-pg0-[1-5]
```
After 5 minutes the status will change once the compute nodes have been created and the job is running

`squeue `

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 6       hpc     CMAQ lizadams  R       0:37      5 cmaqslurmhc44rsalmalinux-hpc-pg0-[1-5]
```

The 180 pe job should take 60 minutes to run (30 minutes per day)

Note, if the job does not get scheduled, examine the slurm logs

`sudo vi /var/log/slurmctld/slurmctld.log`

`sudo vi //var/log/slurmctld/resume.log` 


### check the timings while the job is still running using the following command

`grep 'Processing completed' CTM_LOG_001*`

output:

```
   Processing completed...    4.6 seconds
            Processing completed...    4.8 seconds
            Processing completed...    4.8 seconds
            Processing completed...    5.2 seconds
            Processing completed...    4.4 seconds
            Processing completed...    5.0 seconds
            Processing completed...    4.6 seconds
            Processing completed...    4.7 seconds
            Processing completed...    4.7 seconds
            Processing completed...    5.1 seconds

```

### When the job has completed, use tail to view the timing from the log file.

`tail /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/run_cctmv5.3.3_Bench_2016_12US2.2x90.10x18pe.2day.log `

output:

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
Number of Processes:       180
   All times are in seconds.

Num  Day        Wall Time
01   2015-12-22   2097.37
02   2015-12-23   1809.84
     Total Time = 3907.21
      Avg. Time = 1953.60

```


### Check whether the scheduler thinks there are cpus or vcpus

`sinfo -lN`

output:

```
Thu Feb 17 14:53:19 2022
NODELIST             NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
cmaq-hbv3-hpc-pg0-1      1      hpc*       idle% 120   120:1:1 435814        0      1    cloud none                
cmaq-hbv3-hpc-pg0-2      1      hpc*       idle% 120   120:1:1 435814        0      1    cloud none                
cmaq-hbv3-hpc-pg0-3      1      hpc*       idle% 120   120:1:1 435814        0      1    cloud none                
cmaq-hbv3-htc-1          1       htc       idle~ 1       1:1:2   3072        0      1    cloud none           
```
