#!/bin/csh
## For Parallel Cluster 96pe
## data on /beeond data directory
#SBATCH -J 2_node_MPI_Test
#SBATCH -N 2
#SBATCH --ntasks-per-node=96
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err
 
module load mpi/openmpi-4.1.5

cd ~
echo 'test contents to transfer' > ~/test
beeond-cp stagein -n ~/nodefile-$SLURM_JOB_ID -g ~/test -l /mnt/beeond/

mpicc mpitest.c -o mpitest

mpirun ./mpitest
