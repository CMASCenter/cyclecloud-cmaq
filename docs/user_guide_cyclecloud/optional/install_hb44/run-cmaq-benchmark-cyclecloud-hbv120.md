### Copy the run scripts from the CycleCloud repo to run on HBv120
Note, the run scripts are tailored to the Compute Node. This assumes the cluster was built with HC44rs compute nodes.

Change directories to where the run scripts are available from the git repo.

```
cd /shared/data/2018_12US1/CMAQ_v54+_cb6r5_scripts
```

Copy the run scripts to the run directory

```
cp *.csh /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/`
```


### Edit the run script to run on 192 pes

```
cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/
```

```
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh
```

Note, it will take about 3-5 minutes for the compute notes to start up This is reflected in the Status (ST) of PD (pending), with the NODELIST reason being that it is configuring the partitions for the cluster

### Check the status in the queue

```
squeue 
```

output:

```
[lizadams@CMAQSlurmHC44rsAlmaLinux-scheduler scripts]$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2       hpc     CMAQ lizadams CF       0:02      2 CycleCloud8-5-hpc-[1-2]

```
After 5 minutes the status will change once the compute nodes have been created and the job is running

`squeue `

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 6       hpc     CMAQ lizadams  R       0:37      2 CycleCloud8-5-hpc-[1-2]
```

The 192 pe job should take 85 minutes to run (42 minutes per day)

Note, if the job does not get scheduled, examine the slurm logs

```
sudo vi /var/log/slurmctld/slurmctld.log
sudo vi //var/log/slurmctld/resume.log
```


### check the timings while the job is still running using the following command

```
cd /shared/data/output/output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_2x96_classic_shared
grep 'Processing completed' CTM_LOG_001*
```

output:

```
           Processing completed...      27.3354 seconds
            Processing completed...       5.3785 seconds
            Processing completed...       5.4735 seconds
            Processing completed...       5.4295 seconds
            Processing completed...       5.4600 seconds
            Processing completed...       5.5127 seconds
            Processing completed...       5.4453 seconds
            Processing completed...       5.4866 seconds
            Processing completed...       5.4551 seconds
            Processing completed...       5.4535 seconds
            Processing completed...       5.4729 seconds
            Processing completed...       7.7710 seconds


```

### When the job has completed, use tail to view the timing from the log file.

```
tail -n 30 /shared/build/openmpi_gcc/CMAQ_v54+_classic/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2day.20171222start.2x96.shared.log
```

output:

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


### Check whether the scheduler thinks there are cpus or vcpus

```
sinfo -lN
```

output:

```
Wed Jan 10 19:24:35 2024
NODELIST                      NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
cyclecloudlizadams-hpc-pg0-1      1      hpc*   allocated 96     96:1:1 443596        0      1    cloud none                
cyclecloudlizadams-hpc-pg0-2      1      hpc*       idle~ 96     96:1:1 443596        0      1    cloud none                
cyclecloudlizadams-hpc-pg0-3      1      hpc*       idle~ 96     96:1:1 443596        0      1    cloud none                
cyclecloudlizadams-hpc-pg0-4      1      hpc*       idle~ 96     96:1:1 443596        0      1    cloud none                
cyclecloudlizadams-hpc-pg1-1      1      hpc*       idle~ 96     96:1:1 443596        0      1    cloud none                
cyclecloudlizadams-htc-1          1       htc       idle~ 2       2:1:1   3072        0      1    cloud none                
cyclecloudlizadams-htc-2          1       htc       idle~ 2       2:1:1   3072        0      1    cloud none                
cyclecloudlizadams-htc-3          1       htc       idle~ 2       2:1:1   3072        0      1    cloud none                
cyclecloudlizadams-htc-4          1       htc       idle~ 2       2:1:1   3072        0      1    cloud none                
cyclecloudlizadams-htc-5          1       htc       idle~ 2       2:1:1   3072        0      1    cloud none    
```

### Edit the run script to run on 96 pes

```
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.1x96.ncclassic.retest.shared.csh
```

### Check the timing after run completed

```
tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.96.8x12pe.2day.20171222start.1x96.shared.log
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
Number of Processes:       96
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   3744.5
02   2017-12-23   4184.8
     Total Time = 7929.30
      Avg. Time = 3964.65
```
