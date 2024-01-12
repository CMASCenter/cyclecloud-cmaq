#!/bin/bash

set -x

logdir="/sched/$(sudo -i jetpack config cyclecloud.cluster.name)/log"
logfile=$logdir/slurm_prolog.log
exec 1>$logfile 2>&1

if [ "$(/opt/cycle/jetpack/bin/jetpack config slurm.hpc)" == "True" ]; then
  echo ""
  echo "-------------------------------------------------------------------------------------------"
  echo "$(date)...creating Slurm Job $SLURM_JOB_ID nodefile and starting Beeond"

  # create the nodelist by asking slurm what nodes are allocated to this job
  scontrol show hostnames $SLURM_JOB_NODELIST > /shared/home/$SLURM_JOB_USER/tmp-nodefile-$SLURM_JOB_ID

  # if "Node as Hostname" is NOT enabled we need to create a hostfile
  if ! /opt/cycle/jetpack/bin/jetpack config slurm.use_nodename_as_hostname; then
    echo "Node as Hostname is NOT enabled...creating nodefile"
    while IFS= read -r line
    do
      scontrol show node "$line" | grep -oE "\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b" >> /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID-tmp
    done < "/shared/home/$SLURM_JOB_USER/tmp-nodefile-$SLURM_JOB_ID"

    uniq /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID-tmp /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID
    rm /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID-tmp /shared/home/$SLURM_JOB_USER/tmp-nodefile-$SLURM_JOB_ID
    cat /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID
  else
    echo "Node as Hostname is enabled...moving nodefile"
    mv /shared/home/$SLURM_JOB_USER/tmp-nodefile-$SLURM_JOB_ID /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID
  fi

  chown $SLURM_JOB_USER /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID
  chmod 775 /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID

  # Start Beeond as $SLURM_JOB_USER
  sudo -u $SLURM_JOB_USER beeond start -P -n /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID  -d /mnt/nvme -c /mnt/beeond
else
  echo "Skipping Beeond start since this is not an HPC partition..."
fi
