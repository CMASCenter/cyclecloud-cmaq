#!/bin/csh
## For Parallel Cluster 96pe
## data on /beeond data directory
#SBATCH -J 1_node_MPI_Test
#SBATCH -N 1
#SBATCH --ntasks-per-node=120
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err
 
module load mpi/openmpi-4.1.5

mkdir -p ~/test_dir
echo 'test contents to transfer' > ~/test_dir/test
beeond-cp stagein -n ~/nodefile-$SLURM_JOB_ID -g ~/test_dir -l /mnt/beeond/

mpicc mpitest.c -o mpitest

echo 'Start mpirun at ' `date`
mpirun -nolocal -vv  --mca oob_tcp_base_verbose 100 -np 120 ./mpitest
