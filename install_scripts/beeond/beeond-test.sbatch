#!/bin/bash
#SBATCH --job-name=beeond
#SBATCH -N 2
#SBATCH -n 100
#SBATCH -p hpc

logdir="/sched/beyondtest/log"
logfile=$logdir/slurm_beeond.log

echo "$DATE creating Slurm Job $SLURM_JOB_ID nodefile and starting Beeond" >> $logfile 2>&1
scontrol show hostnames $SLURM_JOB_NODELIST > nodefile-$SLURM_JOB_ID
beeond start -n /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID -d /mnt/nvme -c /mnt/beeond -P >> $logfile 2>&1

echo "#####################################################################################"
echo "df -h:   "
df -h
echo "#####################################################################################"
echo "#####################################################################################"
echo ""
echo "beegfs-ctl --mount=/mnt/beeond --listnodes --nodetype=storage:   "
beegfs-ctl --mount=/mnt/beeond --listnodes --nodetype=storage
echo "#####################################################################################"
echo "#####################################################################################"
echo ""
echo "beegfs-ctl --mount=/mnt/beeond --listnodes --nodetype=metadata:   "
beegfs-ctl --mount=/mnt/beeond --listnodes --nodetype=metadata
echo "#####################################################################################"
echo "#####################################################################################"
echo ""
echo "beegfs-ctl --mount=/mnt/beeond --getentryinfo:   "
beegfs-ctl --mount=/mnt/beeond --getentryinfo /mnt/beeond
echo "#####################################################################################"
echo "#####################################################################################"
echo ""
echo "beegfs-net:   "
beegfs-net
beeond stop -n /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID -L -d -P -c >> $logfile 2>&1
