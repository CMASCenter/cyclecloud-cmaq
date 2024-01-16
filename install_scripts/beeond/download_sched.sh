# Download Prolog/Epilog scripts to /sched
sudo wget -O /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm_prolog.sh https://raw.githubusercontent.com/themorey/cyclecloud-scripts/main/slurm-beeond/slurm-prolog-beeond.sh
sudo wget -O /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm_epilog.sh https://raw.githubusercontent.com/themorey/cyclecloud-scripts/main/slurm-beeond/slurm-epilog-beeond.sh

# Make the scripts executable
sudo chmod +x /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm_*.sh

# Add the logs directory if it doesn't exist
[ -d /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/log ] || sudo mkdir /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/log

# add Prolog/Epilog configs to slurm.conf
sudo cat <<EOF >>/sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm.conf
Prolog=/sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm_prolog.sh
Epilog=/sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm_epilog.sh
EOF

# force cluster nodes to re-read the slurm.conf
sudo scontrol reconfig


Note, I was getting an error
./download_sched.sh: line 12: /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm.conf: Permission denied
scontrol: error: Parse error in file /etc/slurm/slurm.conf line 53: " -i jetpack config cyclecloud.cluster.name)/slurm_prolog.sh"
scontrol: error: Parse error in file /etc/slurm/slurm.conf line 54: " -i jetpack config cyclecloud.cluster.name)/slurm_epilog.sh"


So, I hardcoded the clustername in the /sched/beyondtest/slurm.conf

tail /sched/beyondtest/slurm.conf
# If slurm.accounting.enabled=true this will setup slurmdbd
# otherwise it will just define accounting_storage/none as the plugin
Include accounting.conf
# SuspendExcNodes is managed in /etc/slurm/keep_alive.conf
# see azslurm keep_alive for more information.
# you can also remove this import to remove support for azslurm keep_alive
Include keep_alive.conf
Prolog=/sched/slurmtest/slurm_prolog.sh
Epilog=/sched/slurmtest/slurm_epilog.sh
SlurmCtldHost=beyondtest-scheduler



