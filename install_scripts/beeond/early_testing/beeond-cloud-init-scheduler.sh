#!/bin/bash
set -x
exec 1>/var/log/beeond-config.log 2>&1

systemctl enable --now atd.service
cat << EOF>>/tmp/beeond-config.sh
#!/bin/bash
set -x
exec 1>/var/log/beeond-config.log 2>&1
while [[ ! -L /etc/slurm/slurm.conf ]]; do
  sleep 30
done

# Determine Slurm cluster name for sched path
CLUSTER=\$(sudo -i jetpack config cyclecloud.cluster.name)

# Download Prolog/Epilog scripts to /sched/$(sudo -i jetpack config cyclecloud.cluster.name)
sudo wget -O /sched/\$CLUSTER/slurm_prolog.sh https://raw.githubusercontent.com/themorey/cyclecloud-scripts/main/slurm-beeond/slurm-prolog-beeond.sh
sudo wget -O /sched/\$CLUSTER/slurm_epilog.sh https://raw.githubusercontent.com/themorey/cyclecloud-scripts/main/slurm-beeond/slurm-epilog-beeond.sh

#  Make the scripts executable
sudo chmod +x /sched/\$CLUSTER/slurm_*log.sh

# Add the logs directory if it doesn't exist
[[ -d /sched/\$CLUSTER/log ]] || sudo mkdir /sched/\$CLUSTER/log

# add Prolog/Epilog configs to slurm.conf
sudo bash -c "cat <<EOH >>/sched/\$CLUSTER/slurm.conf

Prolog=/sched/\$CLUSTER/slurm_prolog.sh
Epilog=/sched/\$CLUSTER/slurm_epilog.sh

EOH"
  
# force cluster nodes to re-read the slurm.conf
if scontrol ping |grep UP; then 
  sudo scontrol reconfig
fi

# create the BeeOND connection auth file required in BeeGFS 7.4
sudo dd if=/dev/random of=/sched/\$CLUSTER/beeond-connauthfile bs=128 count=1
sudo chmod 404 /sched/\$CLUSTER/beeond-connauthfile

# download BeeOND test job script
wget https://raw.githubusercontent.com/themorey/cyclecloud-scripts/main/slurm-beeond/beeond-test.sbatch

EOF

# schedule the beeond-config.sh script to run in 1 minute
at now + 1 minute -f /tmp/beeond-config.sh
