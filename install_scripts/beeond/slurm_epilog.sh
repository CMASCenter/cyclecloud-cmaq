#!/bin/bash
set -x

logdir="/sched/$(sudo -i jetpack config cyclecloud.cluster.name)/log"
logfile=$logdir/slurm_epilog.log
exec 1>$logfile 2>&1

if [ "$(/opt/cycle/jetpack/bin/jetpack config slurm.hpc)" == "True" ]; then
  nodefile=/shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID
  if [ -e $nodefile ] ; then
    # should be stopped in the job script so this is a failsafe
    echo "$(date).... Stopping beeond"
    sudo -H -u $SLURM_JOB_USER bash -c "beeond stop -n $nodefile -L -d -P -c"

    # Workaround Beeond stop umount issue
    while read host; do
      sudo -u $SLURM_JOB_USER ssh -t $host 'sudo umount -l /mnt/beeond && sudo pkill beegfs* '
    done < $nodefile

    rm $nodefile || exit 0
  fi
fi
