#!/bin/bash
set -x
exec 1>/var/log/beeond-config.log 2>&1

yum install -y epel-release

. /etc/os-release
if [[ "$PLATFORM_ID" == "platform:el8" ]]; then
  cat << EOF>>/tmp/beeond-connauthfile.sh
#!/bin/bash
set -x
exec 1>/var/log/beeond-connauthfile.log 2>&1

CLUSTER=\$(sudo -i jetpack config cyclecloud.cluster.name)
while [[ -z "\$CLUSTER" ]]; do
  sleep 15
  CLUSTER=\$(sudo -i jetpack config cyclecloud.cluster.name)
done

# configure the connauthfile for BeeOND auth
if grep -q beeond-connauthfile /etc/beegfs/beegfs-meta.conf; then
  echo "connAuthFile already configured...skipping"
else
  echo "connAuthFile not configured...configuring"
  sed -i '0,/connAuthFile/s//#connAuthFile/g' /etc/beegfs/beegfs-*.conf
  #sed -i "s/#connAuthFile/a \connAuthFile = /sched/\$CLUSTER/beeond-connauthfile" /etc/beegfs/beegfs-*.conf
  echo "connAuthFile = /sched/\$CLUSTER/beeond-connauthfile" | tee -a /etc/beegfs/beegfs-*.conf
fi
EOF
  wget -O /etc/yum.repos.d/beegfs_alma8.repo https://www.beegfs.io/release/beegfs_7.4.2/dists/beegfs-rhel8.repo
  # schedule the beeond-config.sh script to run in 1 minute
  at now + 1 minute -f /tmp/beeond-connauthfile.sh
elif [[ "$VERSION_ID" == "7" ]]; then
  wget -O /etc/yum.repos.d/beegfs_rhel7.repo https://www.beegfs.io/release/beegfs_7.2.4/dists/beegfs-rhel7.repo
else
  echo "This OS is not supported...please use RHEL clone instead"
  exit 255
fi

# Install and configure BeeOND
systemctl enable --now atd.service
yum install -y pdsh beeond libbeegfs-ib
sed -i 's/^buildArgs=.*/buildArgs=-j8 BEEGFS_OPENTK_IBVERBS=1 OFED_INCLUDE_PATH=\/usr\/src\/ofa_kernel\/default\/include\//' /etc/beegfs/beegfs-client-autobuild.conf
/etc/init.d/beegfs-client rebuild &
mkdir -p /mnt/nvme
mdadm --create /dev/md10 --level 0 --raid-devices 2 /dev/nvme0n1 /dev/nvme1n1
mkfs.xfs /dev/md10
mount /dev/md10 /mnt/nvme
chmod 1777 /mnt/nvme
mkdir -p /mnt/resource
chmod 1777 /mnt/resource
mkdir -p /mnt/beeond
chmod 1777 /mnt/beeond
wget -O /opt/beegfs/sbin/beeond https://raw.githubusercontent.com/Azure/cyclecloud-beegfs/master/specs/default/chef/site-cookbooks/beegfs/files/default/beeond
