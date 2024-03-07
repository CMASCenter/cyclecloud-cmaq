CMAQv4+ CONUS Benchmark Tutorial using 12US1 Domain

## Use Cycle Cloud with CMAQv5.4+ software and 12US1 Benchmark data.

Step by step instructions for running the CMAQ 12US1 Benchmark for 2 days on a Cycle Cloud using beeond parallel filesystem for input data.

Input files are *.nc (uncompressed netCDF)

### Use the files under the following directory to set up the CycleCloud Cluster to use beeond.

Using a modified version of the instructions available on this <a href="https://techcommunity.microsoft.com/t5/azure-high-performance-computing/automate-beeond-filesystem-on-azure-cyclecloud-slurm-cluster/ba-p/3625544">Blog Post</a>, updated for the new CycleCloud version 8.5 and slurm 22.05.10.

Full Beeond: BeeGFS on Demand <a href="https://doc.beegfs.io/latest/advanced_topics/beeond.html">User Manual</a>

Use the files in the cyclecloud-cmaq github repository from your local computer.

To get this repo, if you don't already have it use the command;

```
git clone -b main https://github.com/CMASCenter/cyclecloud-cmaq.git
```

Change directories to the following location:

```
cd cyclecloud-cmaq/install_scripts/beeond
```

Edit the cluster and use the Cloud-init option for your CycleCloud to install the code in the file: beeond-cloud-init-almalinux8.5-HBv3

Do not use the Apply to all option. 
Select Scheduler and copy and paste the contents of scheduler-cloud-init.sh

```
cat scheduler-cloud-init.sh 
```
Select hpc and copy and paste the contents of hpc-cloud-init.sh into the shell

```
cat hpc-cloud-init.sh
```

Save this setting, and then terminate and then restart the cluster.


## Log into the new cluster
```{note}
Use your username and credentials to login
```

```
ssh -Y username@IP-address
```

Make the /shared/build directory and change ownership from root to your account.

```
sudo mkdir /shared/build
sudo chown $USER /shared/build
``` 

Make the /shared/cyclecloud directory and change ownership from root to your account.

```
sudo mkdir /shared/cyclecloud-cmaq
sudo chown $USER /shared/cyclecloud-cmaq
```

Install the cyclecloud-cmaq repo

```
cd /shared
git clone -b main https://github.com/CMASCenter/cyclecloud-cmaq.git cyclecloud-cmaq
```

Make the /shared/data directory and change ownership to your account

```
sudo mkdir /shared/data
sudo chown $USER /shared/data
```

Create the output directory

```
mkdir -p /shared/data/output
```

The beeond filesystem will be created using the 1.8 T nvme disks that are on the compute nodes when the run script is submitted. 
If you use two nodes, the shared beeond filesysetm will be a size of 3.5 T.

beegfs_ondemand    3.5T  103M  3.5T   1% /mnt/beeond


## Download the input data from the AWS Open Data CMAS Data Warehouse using the aws copy command.

Install AWS CLI to obtain data from AWS S3 Bucket

```
cd /shared/build
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Download the data

```
cd /shared/cyclecloud-cmaq/s3_scripts/
./s3_copy_nosign_2018_12US1_conus_cmas_opendata_to_shared_20171222_cb6r5_uncompressed.csh
```

## Verify Input Data

```
cd /shared/data/2018_12US1
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

## Install CMAQv5.4+

Change directories to install and build the libraries and CMAQ


Install netCDF C and Fortran Libraries

```
cd /shared/cyclecloud-cmaq
./gcc_netcdf_cluster.csh
cp dot.cshrc  ~/.cshrc
```

Execute the .cshrc shell

```
csh
env
```

Verify the LD_LIBRARY_PATH environment variable

```
echo $LD_LIBRARY_PATH
```

Output

```
/opt/openmpi-4.1.5/lib:/opt/gcc-9.2.0/lib64:/shared/build/netcdf/lib
```

Install I/O API Library

```
cd /shared/cyclecloud-cmaq
./gcc_ioapi_cluster.csh
```

Build CMAQ

```
./gcc_cmaqv54+.csh
```

## Copy and Examine CMAQ Run Scripts

Obtain a copy of the CMAQ run script that has been edited to use the /mnt/beeond shared filesystem.

```
cp /shared/cyclecloud-cmaq/run_scripts/CMAQ_v54+_beeond/run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.*.ncclassic.csh /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/
```

```{note}
The time that it takes the 2 day CONUS benchmark to run will vary based on the number of CPUs used, and the compute node that is being used, and what disks are used for the I/O (shared, beeond or lustre). The timings reported below are from the beeond filesystem on HB120v3 compute nodes.
```

Examine how the run script is configured

```
cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/
head -n 30 /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.2x96.ncclassic.csh
```

```
#!/bin/csh -f

## For CycleCloud 120pe
## data on /lustre data directory
## https://dataverse.unc.edu/dataset.xhtml?persistentId=doi:10.15139/S3/LDTWKH
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=96
#SBATCH --exclusive
#SBATCH -J CMAQ
#SBATCH -o /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2days.20171222start.2x96.log
#SBATCH -e /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts/run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2days.20171222start.2x96.log
#SBATCH -p hpc
##SBATCH --constraint=BEEOND
###SBATCH --beeond

The “beeond start” command was added to the top of the job script, and “beeond stop” to the end. Note, the -m 2 option is specific to using two nodes, this should be modified to match the number of nodes specified in the `SBATCH --nodes=`  command above:

# ===================================================================

#> Start Beeond filesystem

# ===================================================================

beeond start -P -m 2 -n /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID  -d /mnt/nvme -c /mnt/beeond -f /etc/beegfs


## Copy files to /mnt/beeond, note, it may take 5 minutes to prepare the /mnt/beeond filesystem and to copy the data


beeond-cp stagein -n ~/nodefile-$SLURM_JOB_ID -g /shared/data/2018_12US1 -l /mnt/beeond/data/2018_12US1

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

Verify that the modules are loaded 

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


### Check that the /mnt/beeond filesystem has been created on the compute modes

Login to the compute node by getting the IP address of the compute node.
To find this IP address you need to go to the azure portal, to the cyclecloud.


[lizadams@ip-0A0A000B ~]$ df -h
Filesystem          Size  Used Avail Use% Mounted on
devtmpfs            225G     0  225G   0% /dev
tmpfs               225G     0  225G   0% /dev/shm
tmpfs               225G   18M  225G   1% /run
tmpfs               225G     0  225G   0% /sys/fs/cgroup
/dev/sda2            59G   27G   33G  45% /
/dev/sda1           994M  209M  786M  21% /boot
/dev/sda15          495M  5.9M  489M   2% /boot/efi
/dev/sdb1           472G  216K  448G   1% /mnt
/dev/md10           1.8T   16G  1.8T   1% /mnt/nvme
10.10.0.10:/sched    30G  247M   30G   1% /sched
10.10.0.10:/shared 1000G   95G  906G  10% /shared
tmpfs                45G     0   45G   0% /run/user/20001
beegfs_ondemand     3.5T   31G  3.5T   1% /mnt/beeond


### Check on the log file status

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
tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.192.16x12pe.2days.20171222start.2x96.log
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
01   2017-12-22   1966.4
02   2017-12-23   2170.2
     Total Time = 4136.60
      Avg. Time = 2068.30
INFO: Using status information file: /tmp/beeond.tmp
INFO: Checking reachability of host 10.10.0.5
INFO: Checking reachability of host 10.10.0.7
INFO: Unmounting file system on host: 10.10.0.5
sudo: do_stoplocal: command not found
INFO: Unmounting file system on host: 10.10.0.7
sudo: do_stoplocal: command not found
INFO: Stopping remaining processes on host: 10.10.0.5
INFO: Stopping remaining processes on host: 10.10.0.7
INFO: Deleting status file on host: 10.10.0.5
INFO: Deleting status file on host: 10.10.0.7

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
01   2017-12-22   3278.9
02   2017-12-23   3800.7
     Total Time = 7079.60
      Avg. Time = 3539.80

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
tail -n 30 run_cctm5.4+_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.384.16x24pe.2day.20171222start.3x96.log
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
Number of Processes:       288
   All times are in seconds.

Num  Day        Wall Time
01   2017-12-22   1588.4
02   2017-12-23   1721.8
     Total Time = 3310.20
      Avg. Time = 1655.10

```

