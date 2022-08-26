#!/bin/csh

#SBATCH -J StorageTestSuite
#SBATCH -t 1:00:00
# #SBATCH -p debug
# #SBATCH -t 4:00:00
#SBATCH --nodes=5
#SBATCH --ntasks-per-node=120
#SBATCH --exclusive
##SBATCH -n 144
#SBATCH -o /shared/build/liz/run-conus-test-shared.log3
#SBATCH -e /shared/build/liz/run-conus-test-shared.log3

# Define code and workpaths
set code_path = /shared/build/liz
set work_path = $code_path/output

if (! -d $work_path) then
   mkdir $work_path
endif

echo "Tests performed under $work_path"

# Domain option
#foreach domain_name (12CONUS 12CONUSmax 4CONUS 4CONUSmax)
foreach domain_name (12CONUS)
# Domain decomposition 4x4 16 8x8 64 12x12 144 20x20 30x30   

# foreach npcol (4 8 12 20 30)
#  foreach nprow (4 8 12 20 30)
 foreach npcol (12 16 20 30)
  foreach nprow (12 16 20)

if ( $domain_name == "12CONUS" ) then

	# Domain dimension definitions 12CONUS
	setenv nlays 35
	setenv nvars 146
	setenv ncols 459
	setenv nrows 299

else if ( $domain_name == "12CONUSmax" ) then
	
	# Domain dimension definition 12CONUSmax
	setenv nlays 35
	setenv nvars 215
	setenv ncols 459
	setenv nrows 299

else if ( $domain_name == "4CONUS" ) then

	# Domain dimension definition 4CONUS
	setenv nlays 35
	setenv nvars 146
	setenv ncols 1377
	setenv nrows 897

else if ( $domain_name == "4CONUSmax" ) then

	# Domain definition 4CONUSmax
	setenv nlays 35
	setenv nvars 215
	setenv ncols 1377
	setenv nrows 897
else 
	echo "No more domains to test"
endif

# Parallel and reg netcdf switches

setenv o_pnetcdf          .true.
setenv o_reg_netcdf       .true.
setenv ncd_64bit_offset T

# Main body
#
setenv npcol_row "$npcol $nprow"

# set ext = `printf "%2.2dx%2.2d\n" $npcol $nprow`

# rm -f data*$ext

@ nprocs = $npcol * $nprow

# foreach numtarget (1 4 6 8)
#   foreach stripesize (256 512 1024 2048)

	foreach numtarget (1)
	  foreach stripesize (256 512 1024 2048)
	    set nt = `printf "%2.2d \n" $numtarget `
    
	    cd $work_path

	    rm -f data*
            echo "Domain: $domain_name"
	    echo " ==d== $npcol $nprow $numtarget $stripesize"

	    date
	    time mpirun -np $nprocs $code_path/d.x
	    date
	  end
        end
  end
 end	
end
