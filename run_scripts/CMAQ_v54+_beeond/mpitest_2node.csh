#!/bin/csh
## For Parallel Cluster 96pe
## data on /beeond data directory
#SBATCH -J 2_node_MPI_Test
#SBATCH -N 2
#SBATCH --ntasks-per-node=120
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err

## output log files

cat  /sched/beeondtest2/log/slurm_prolog.log

echo 'after starting slurm job'
cd /mnt/resource/beeond_logs/beegfs/
find ./ -type f | xargs tail -n +1
cat  /tmp/beeond.tmp
cat /tmp/beeond-connauthfile.sh 
cat /etc/beegfs/beegfs-meta.conf 
cat /var/log/beeond-config.log  
cat /var/log/beeond-connauthfile.log

echo 'test contents to transfer' > ~/test_dir/test.txt
#beeond-cp stagein -n ~/nodefile-$SLURM_JOB_ID -g ~/test_dir -l /mnt/beeond/
beeond-cp copy  -n ~/nodefile-$SLURM_JOB_ID ~/test_dir /mnt/beeond/
sleep 120
echo 'after sleep'

cd /mnt/resource/beeond_logs/beegfs/
find ./ -type f | xargs tail -n +1
cat  /tmp/beeond.tmp
cat /tmp/beeond-connauthfile.sh
cat /etc/beegfs/beegfs-meta.conf
cat /var/log/beeond-config.log
cat /var/log/beeond-connauthfile.log



cd /shared/build/openmpi_gcc/CMAQ_v54/CCTM/scripts
mpicc mpitest.c -o mpitest

echo 'after mpicc compile'

echo 'Start exec at ' `date`

mpirun -nolocal -vv --mca oob_tcp_base_verbose 100 ./mpitest

echo 'after mpirun '

cd /mnt/resource/beeond_logs/beegfs/
cat  /tmp/beeond.tmp
cat /tmp/beeond-connauthfile.sh
cat /etc/beegfs/beegfs-meta.conf
cat /var/log/beeond-config.log
cat /var/log/beeond-connauthfile.log

cat  /sched/beeondtest2/log/slurm_prolog.log


#cat /etc/beegfs/beegfs-client.conf

beegfs-ctl --listnodes --nodetype=storage
beegfs-ctl --listnodes --nodetype=meta
beegfs-ctl --listtargets --nodetype=meta --state
beegfs-ctl --listtargets --nodetype=storage --state
cat /tmp/beeond-config.sh

cat  /sched/beeondtest2/keep_alive.conf
