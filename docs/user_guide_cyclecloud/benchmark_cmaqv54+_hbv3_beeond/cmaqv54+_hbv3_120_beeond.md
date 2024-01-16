CMAQv4+ CONUS Benchmark Tutorial using 12US1 Domain

## Use Cycle Cloud pre-installed with CMAQv5.4+ software and 12US1 Benchmark data.

Step by step instructions for running the CMAQ 12US1 Benchmark for 2 days on a Cycle Cloud using beeond parallel filesystem for input data.

Input files are *.nc (uncompressed netCDF)

### Install software and input data

See instructions in the Advanced Tutorial.


### Use the files under the following directory to set up the CycleCloud Cluster to use beeond.

Using a modified version of the instructions available on this ![blog](https://techcommunity.microsoft.com/t5/azure-high-performance-computing/automate-beeond-filesystem-on-azure-cyclecloud-slurm-cluster/ba-p/3625544), updated for the new CycleCloud version 8.5 and slurm 22.05.10.

Full Beeond: BeeGFS on Demand ![User Manual](https://doc.beegfs.io/latest/advanced_topics/beeond.html)

```
cd install_scripts/beeond
```

Edit the cluster and use the Cloud-init option for your CycleCloud to install the code in the file: beeond-cloud-init-almalinux8.5-HBv3

Use the Apply to all option, so that the code is installed on both the scheduler and the compute nodes.

Save this setting, and then terminate and then restart the cluster.


## Log into the new cluster
```{note}
Use your username and credentials to login
```

```
ssh -Y username@IP-address
```

Change the group and ownership permissions on the /shared/data directory

```
sudo chown azureuser /shared/data
sudo chgrp azureuser /shared/data
```

Create the output directory

```
mkdir -p /shared/data/output
```

## Change directories to the Cyclecloud software and run the download_sched.csh to update the slurm scheduler to use the slurm-prolog-beeond.sh and slurm-epilog-beeond.sh

```
cd /shared/cyclecloud-cmaq/install_scripts/beeond
./download_sched.sh
```

## Validate the setup

```
wget https://raw.githubusercontent.com/themorey/cyclecloud-scripts/main/slurm-beeond/beeond-test.sbatch
```

## Submit the test job

```
sbatch beeond-test.sbatch
```

Note, we did not get the same results as in the blog post

beegfs_ondemand    3.5T  103M  3.5T   1% /mnt/beeond




## Download the input data from the AWS Open Data CMAS Data Warehouse.

Do a git pull to obtain the latest scripts in the cyclecloud-cmaq repo.

```
cd /shared/cyclecloud-cmaq
git pull
```

## Verify Input Data

```
cd /shared/data/CMAQ_Modeling_Platform_2018/2018_12US1
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
cp /shared/data/CMAQ_Modeling_Platform_2018/2018_12US1/CMAQ_v54+_cb6r5_scripts/* /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/
```

```{note}
The time that it takes the 2 day CONUS benchmark to run will vary based on the number of CPUs used, and the compute node that is being used, and what disks are used for the I/O (shared, beeond or lustre).
The Benchmark Scaling Plot for hbv3_120 on lustre, beeond, and shared (include here).
```

Examine how the run script is configured

```
head -n 30 /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/run_cctm_2018_12US1_v54_cb6r3_ae6.20171222.csh
```

```
#!/bin/csh -f

## For CycleCloud 120pe
## input data on /mnt/beeond directory on each compute node
## output data saved to /shared/data/output/
## https://dataverse.unc.edu/dataset.xhtml?persistentId=doi:10.15139/S3/LDTWKH
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=96
#SBATCH --exclusive
#SBATCH -J CMAQ
#SBATCH -o /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2day.20171222start.2x96.log
#SBATCH -e /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2day.20171222start.2x96.log


###Copy data

#beeond-cp copy -n /shared/home/$SLURM_JOB_USER/nodefile-1  /shared/data/CMAQ_Modeling_Platform_2018 /mnt/beeond

#sleep 1000

# ===================== CCTMv5.4.X Run Script ========================= 
# Usage: run.cctm >&! cctm_2018_12US1.log &                                
#
# To report problems or request help with this script/program:
#             http://www.epa.gov/cmaq    (EPA CMAQ Website)
#             http://www.cmascenter.org  (CMAS Website)
# ===================================================================  

# ===================================================================
#> Runtime Environment Options
```

```{note}
In this run script, slurm or SBATCH requests 2 nodes, each node with 96 pes, or 2x96 = 192 pes
```

Verify that the NPCOL and NPROW settings in the script are configured to match what is being requested in the SBATCH commands that tell slurm how many compute nodes to  provision. 
In this case, to run CMAQ using on  192 cpus (SBATCH --nodes=2 and --ntasks-per-node=96), use NPCOL=16 and NPROW=12.

```
grep NPCOL run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh
```

Output:

```
#> Horizontal domain decomposition
   setenv NPCOL_NPROW "1 1"; set NPROCS   = 1 # single processor setting
   @ NPCOL  =  16; @ NPROW =  12
   @ NPROCS = $NPCOL * $NPROW
   setenv NPCOL_NPROW "$NPCOL $NPROW"; 

```

```
module list
```

```
Currently Loaded Modulefiles:
 1) gcc-9.2.0   2) mpi/openmpi-4.1.5  
```


## Submit Job to Slurm Queue to run CMAQ on beeond

```
cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh
```


### Check status of run

`squeue `

Output:

```

```

It takes about 5-8 minutes for the compute nodes to spin up, after the nodes are available, the status will change from CF to R.


### Successfully started run

`squeue`

```
            JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                25       hpc     CMAQ lizadams  R      56:26      2 CycleCloud8-5Beond-hpc-[3-4]
```

### Copying the input data to the /mnt/beeond doesn't seem to be working.

Added the following to the run script at the top of the script:

```
###Copy data

beeond-cp copy -n /shared/home/$SLURM_JOB_USER/nodefile-1  /shared/data/CMAQ_Modeling_Platform_2018 /mnt/beeond

sleep 500
```

## note the beeond-cp copy command doesn't seem to be working. I am logging into each compute node and using recursive copy to copy the input data to /mnt/beeond



### Once the job is successfully running 

Check on the log file status

```
grep -i 'Processing completed.' run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2day.20171222start.2x96.log
```

Output:


```
            Processing completed...       5.8654 seconds
            Processing completed...       5.8665 seconds
            Processing completed...       5.8610 seconds
            Processing completed...       5.8422 seconds
            Processing completed...       5.8657 seconds
            Processing completed...       5.8616 seconds
            Processing completed...       5.8824 seconds
            Processing completed...       5.8581 seconds
            Processing completed...       5.8653 seconds
            Processing completed...       5.8961 seconds
            Processing completed...       7.9473 seconds
            Processing completed...       5.4089 seconds
            Processing completed...       5.8996 seconds
            Processing completed...       5.9659 seconds
            Processing completed...       5.9462 seconds
            Processing completed...       5.8966 seconds
            Processing completed...       5.9326 seconds

```

Once the job has completed running the two day benchmark check the log file for the timings.

```
tail -n 18 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2day.20171222start.2x96.log
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
Number of Processes:       192
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   1700.4
02   2017-12-23   2314.8
     Total Time = 4015.20
      Avg. Time = 2007.60

```

## submit job to run on 1 node x 96 processors

```
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.1x96.ncclassic.csh
```

Check result after job has finished

```

tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.96.8x12pe.2day.20171222start.1x96.log
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
01   2017-12-22   3124.4
02   2017-12-23   3629.7
     Total Time = 6754.10
      Avg. Time = 3377.05

```


## Submit job to run on 3 nodes 

```
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x96.ncclassic.csh
```

Login to each node and copy the data from /shared/data to /mnt/beeond

## Check how quickly the processing is being completed

```
grep -i 'Processing completed' run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.288.16x24pe.2day.20171222start.3x96.log
```

Output

```
            Processing completed...       7.4152 seconds
            Processing completed...       5.7284 seconds
            Processing completed...       5.6439 seconds
            Processing completed...       5.5742 seconds
            Processing completed...       5.6011 seconds
            Processing completed...       5.5687 seconds
            Processing completed...       5.5505 seconds
            Processing completed...       5.5686 seconds
            Processing completed...       5.5193 seconds
            Processing completed...       5.5192 seconds
            Processing completed...       5.4985 seconds
            Processing completed...       6.7259 seconds
            Processing completed...       6.3606 seconds
            Processing completed...       5.5312 seconds

```

## Check results when job has completed successfully

```
tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.288.16x24pe.2day.20171222start.3x96.log
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
01   2017-12-22   1966.4
02   2017-12-23   2176.8
     Total Time = 4143.20
      Avg. Time = 2071.60
```



I am getting this error

sbatch beeond-test.sbatch

cat slurm-30.out

```

#####################################################################################
df -h:
Filesystem          Size  Used Avail Use% Mounted on
devtmpfs            225G     0  225G   0% /dev
tmpfs               225G     0  225G   0% /dev/shm
tmpfs               225G   18M  225G   1% /run
tmpfs               225G     0  225G   0% /sys/fs/cgroup
/dev/sda2            59G   27G   33G  45% /
/dev/sda1           994M  209M  786M  21% /boot
/dev/sda15          495M  5.9M  489M   2% /boot/efi
/dev/sdb1           472G  176K  448G   1% /mnt
/dev/md10           1.8T   13G  1.8T   1% /mnt/nvme
10.10.0.10:/sched    30G  247M   30G   1% /sched
10.10.0.10:/shared 1000G  114G  886G  12% /shared
tmpfs                45G     0   45G   0% /run/user/0
#####################################################################################
#####################################################################################

beegfs-ctl --mount=/mnt/beeond --listnodes --nodetype=storage:

Error: Given mountpoint is invalid: /mnt/beeond

[BeeGFS Control Tool Version: 7.2.4
Refer to the default config file (/etc/beegfs/beegfs-client.conf)
or visit http://www.beegfs.com to find out about configuration options.]

#####################################################################################
#####################################################################################

beegfs-ctl --mount=/mnt/beeond --listnodes --nodetype=metadata:

Error: Given mountpoint is invalid: /mnt/beeond

[BeeGFS Control Tool Version: 7.2.4
Refer to the default config file (/etc/beegfs/beegfs-client.conf)
or visit http://www.beegfs.com to find out about configuration options.]

#####################################################################################
#####################################################################################

beegfs-ctl --mount=/mnt/beeond --getentryinfo:

Error: Given mountpoint is invalid: /mnt/beeond

[BeeGFS Control Tool Version: 7.2.4
Refer to the default config file (/etc/beegfs/beegfs-client.conf)
or visit http://www.beegfs.com to find out about configuration options.]

#####################################################################################
#####################################################################################

beegfs-net:
df: no file systems processed
No active BeeGFS mounts found.
```

But when I login to the ssh lizadams@10.10.0.5 or compute node, I see this:

df -h
Filesystem          Size  Used Avail Use% Mounted on
devtmpfs            225G     0  225G   0% /dev
tmpfs               225G     0  225G   0% /dev/shm
tmpfs               225G   26M  225G   1% /run
tmpfs               225G     0  225G   0% /sys/fs/cgroup
/dev/sda2            59G   27G   33G  45% /
/dev/sda1           994M  209M  786M  21% /boot
/dev/sda15          495M  5.9M  489M   2% /boot/efi
/dev/sdb1           472G   68G  380G  16% /mnt
/dev/md10           1.8T   13G  1.8T   1% /mnt/nvme
10.10.0.10:/sched    30G  247M   30G   1% /sched
10.10.0.10:/shared 1000G  114G  886G  12% /shared
tmpfs                45G     0   45G   0% /run/user/20001
[lizadams@cyclecloud8-5beond-hpc-5 ~]$ ls /mnt
beeond  cluster-init  DATALOSS_WARNING_README.txt  lost+found  nvme  resource  scratch
[lizadams@cyclecloud8-5beond-hpc-5 ~]$ ls /mnt/beeond
CMAQ_Modeling_Platform_2018
[lizadams@cyclecloud8-5beond-hpc-5 ~]$ ls -rlt /mnt/beeond
total 4
drwxrwxr-x. 5 lizadams lizadams 4096 Jan 12 23:30 CMAQ_Modeling_Platform_2018
[lizadams@cyclecloud8-5beond-hpc-5 ~]$ du -sh /mnt/beeond
76G	/mnt/beeond

Note the above is the result obtained when running on 1 compute node.
