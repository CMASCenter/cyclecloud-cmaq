# start .cshrc

umask 002

limit stacksize unlimited

if ( ! $?LD_LIBRARY_PATH ) then
    setenv LD_LIBRARY_PATH /shared/build-hdf5/install/lib
else
    setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/shared/build-hdf5/install/lib:/shared/build-hdf5/install/lib
endif

set path = ($path /shared/build/netcdf/bin /shared/build-hdf5/ioapi-3.2_branch_20200828/Linux2_x86_64gfortmpi /opt/slurm/bin/ /usr/local/bin )

module load gcc-9.2.1
module load mpi/openmpi-4.1.1

alias SCR 'cd /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts'

