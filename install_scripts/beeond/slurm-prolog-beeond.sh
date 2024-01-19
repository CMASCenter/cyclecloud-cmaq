#!/bin/bash
set -x

CLUSTER=$(sudo -i jetpack config cyclecloud.cluster.name)

logdir="/sched/$CLUSTER/log"
logfile=$logdir/slurm_prolog.log
exec 1>$logfile 2>&1

if [ "$(/opt/cycle/jetpack/bin/jetpack config slurm.hpc)" == "True" ]; then
  echo ""
  echo "-------------------------------------------------------------------------------------------"
  echo "$(date)...creating Slurm Job $SLURM_JOB_ID nodefile and starting Beeond"

  # create the nodelist by asking slurm what nodes are allocated to this job
  scontrol show hostnames $SLURM_JOB_NODELIST > /shared/home/$SLURM_JOB_USER/tmp-nodefile-$SLURM_JOB_ID

  # create a hostfile using IP addresses
  echo "...create the nodefile of IP addresses"
  while IFS= read -r line
  do
    scontrol show node "$line" | grep -oE "\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b" >> /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID-tmp
  done < "/shared/home/$SLURM_JOB_USER/tmp-nodefile-$SLURM_JOB_ID"

  uniq /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID-tmp /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID
  rm /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID-tmp /shared/home/$SLURM_JOB_USER/tmp-nodefile-$SLURM_JOB_ID
  cat /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID

  chown $SLURM_JOB_USER /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID
  chmod 775 /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID

  # Stop any running BeeOND instances and delete data
   sudo -u $SLURM_JOB_USER beeond stop -n /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID -L -d
  # Start Beeond as $SLURM_JOB_USER
  if (( $SLURM_JOB_NUM_NODES > 1 )); then
    sudo -u $SLURM_JOB_USER beeond start -P -m 2 -n /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID  -d /mnt/nvme -c /mnt/beeond -f /etc/beegfs
  else
    sudo -u $SLURM_JOB_USER beeond start -P -n /shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID  -d /mnt/nvme -c /mnt/beeond -f /etc/beegfs
  fi
#else
#  echo "Skipping Beeond start since this is not an HPC partition..."
fi
