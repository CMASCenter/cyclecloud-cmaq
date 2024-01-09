### Copy the run scripts from the CycleCloud repo
Note, the run scripts are tailored to the Compute Node. This assumes the cluster was built with HC44rs compute nodes.

Change directories to where the run scripts are available from the git repo.

```
cd /shared/cyclecloud-cmaq/run_scripts/HB120v3_12US1_CMAQv54plus
```

Copy the run scripts to the run directory

```
cp *.csh /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/`
```


### Run the CONUS Domain on 176 pes

```
cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/
```

```
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.1x176.ncclassic.csh
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
                 2       hpc     CMAQ lizadams CF       0:02      1 CycleCloud8-5-hpc-1

```
After 5 minutes the status will change once the compute nodes have been created and the job is running

`squeue `

output:

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 6       hpc     CMAQ lizadams  R       0:37      5 cmaqslurmhc44rsalmalinux-hpc-pg0-[1-5]
```

The 176 pe job should take 85 minutes to run (42 minutes per day)

Note, if the job does not get scheduled, examine the slurm logs

```
sudo vi /var/log/slurmctld/slurmctld.log
sudo vi //var/log/slurmctld/resume.log
```


### check the timings while the job is still running using the following command

```
grep 'Processing completed' CTM_LOG_001*
```

output:

```
            Processing completed...      29.9047 seconds
            Processing completed...       4.7678 seconds
            Processing completed...       4.8123 seconds
            Processing completed...       4.7888 seconds
            Processing completed...       4.7633 seconds
            Processing completed...       4.8243 seconds


```

### When the job has completed, use tail to view the timing from the log file.

```
tail -n 30 /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.176.16x11pe.2day.20171222start.1x176.log
```

output:

```

```


### Check whether the scheduler thinks there are cpus or vcpus

```
sinfo -lN
```

output:

```
Tue Jan 09 19:11:04 2024
NODELIST             NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
CycleCloud8-5-hpc-1      1      hpc*  allocated# 176   176:1:1 747110        0      1    cloud none                
CycleCloud8-5-hpc-2      1      hpc*       idle~ 176   176:1:1 747110        0      1    cloud none                
CycleCloud8-5-hpc-3      1      hpc*       idle~ 176   176:1:1 747110        0      1    cloud none                
CycleCloud8-5-hpc-4      1      hpc*       idle~ 176   176:1:1 747110        0      1    cloud none                
CycleCloud8-5-htc-1      1       htc       idle~ 2       2:1:1   3072        0      1    cloud none                
CycleCloud8-5-htc-2      1       htc       idle~ 2       2:1:1   3072        0      1    cloud none     
```
