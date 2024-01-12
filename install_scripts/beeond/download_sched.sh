# Download Prolog/Epilog scripts to /sched
sudo wget -O /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm_prolog.sh https://raw.githubusercontent.com/themorey/cyclecloud-scripts/main/slurm-beeond/slurm-prolog-beeond.sh
sudo wget -O /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm_epilog.sh https://raw.githubusercontent.com/themorey/cyclecloud-scripts/main/slurm-beeond/slurm-epilog-beeond.sh

# Make the scripts executable
sudo chmod +x /sched/slurm_*.sh

# Add the logs directory if it doesn't exist
[ -d /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/log ] || sudo mkdir /sched/$(sudo -i jetpack config cyclecloud.cluster.name)/log

# add Prolog/Epilog configs to slurm.conf
sudo cat <<EOF >>/sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm.conf
Prolog=/sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm_prolog.sh
Epilog=/sched/$(sudo -i jetpack config cyclecloud.cluster.name)/slurm_epilog.sh
EOF

# force cluster nodes to re-read the slurm.conf
sudo scontrol reconfig
