#!/bin/csh

#SBATCH -J test
#SBATCH -t 1:00:00
# #SBATCH -p debug
# #SBATCH -t 4:00:00
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=120
#SBATCH -n 300
#SBATCH -o /data/build/liz/run-conus-15x20.log3
#SBATCH -e /data/build/liz/run-conus-15x20.log3

# here are the only two parameters that you need to adjust
setenv npcol 15
setenv nprow 20

set domain_name = conus

setenv o_pnetcdf          .true.
setenv o_reg_netcdf       .true.

set code_path = /data/build/liz
echo 'code_path=',$code_path 

set work_path = $code_path/output

if (! -d $work_path) then
   mkdir $work_path
endif

setenv ncd_64bit_offset T

setenv nlays 35
setenv nvars 146

setenv ncols 459
setenv nrows 299
echo 'nlays=',$nlays
echo 'nvars=',$nvars
echo 'ncols=',$ncols
echo 'nrows=',$nrows

setenv npcol_row "$npcol $nprow"

# set ext = `printf "%2.2dx%2.2d\n" $npcol $nprow`

# rm -f data*$ext

@ nprocs = $npcol * $nprow

#foreach numtarget (4 6 8)
 foreach stripesize (256 512 1024 2048)
foreach numtarget (1)
#  foreach stripesize (1)
    set nt = `printf "%2.2d \n" $numtarget `
    
    cd $work_path

    rm -f data*

    echo " ==d== $npcol $nprow $numtarget $stripesize"

    date
    time mpirun -np $nprocs $code_path/d.x
    date
  end
end
