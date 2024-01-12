#!/bin/bash
set -x

if [ "$(/opt/cycle/jetpack/bin/jetpack slurm.hpc)" == "True" ]; then
  nodefile=/shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID
  if [ -e $nodefile ] ; then

    logdir="/sched/$(sudo -i jetpack config cyclecloud.cluster.name)/log"
    logfile=$logdir/slurm_epilog.log
    exec 1>$logfile 2>&1

    # Workaround Beeond stop umount issue
    while read host; do
      sudo -u $SLURM_JOB_USER ssh -t $host 'sudo umount -l /mnt/beeond && df -h |grep beeond '
    done < $nodefile

    echo "$(date).... Stopping beeond"
    sudo -u $SLURM_JOB_USER beeond stop -n $nodefile -L -d -P -c

    # Workaround Beeond stop umount issue
    while read host; do
      sudo -u $SLURM_JOB_USER ssh -t $host 'sudo umount -l /mnt/beeond && df -h |grep beeond '
    done < $nodefile

    #rm $nodefile
  fi
fi
