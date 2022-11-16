#!/bin/csh -f

#  -----------------------
#  Download and build CMAQ
#  -----------------------
# Set installation directory
setenv DIR /21dayscratch/scr/l/i/lizadams/build
# Set local directory for cyclecloud-cmaq
setenv CLOUD /proj/ie/proj/CMAS/CMAQ/cyclecloud-cmaq
setenv IOAPI_DIR $DIR/ioapi-3.2/Linux2_x86_64gfort
setenv NETCDF_DIR $DIR/netcdf/lib
setenv NETCDFF_DIR $DIR/netcdf/lib
cd $DIR
git clone -b main https://github.com/USEPA/CMAQ.git CMAQ_REPO_v54

echo "downloaded CMAQ"
cd CMAQ_REPO_v54
cp $CLOUD/bldit_project_v54_local.csh $DIR/CMAQ_REPO_v54
./bldit_project_v54_local.csh
#module load openmpi
cd $DIR/openmpi_gcc/CMAQ_v54/CCTM/scripts/
cp $CLOUD/config_cmaq_local.csh ../../config_cmaq.csh
./bldit_cctm.csh gcc |& tee ./bldit_cctm.log
#cp ./run_scripts/run* $DIR/openmpi_gcc/CMAQ_v54/CCTM/scripts/
cd $DIR/openmpi_gcc/CMAQ_v54/CCTM/scripts/

# submit job to the queue using 
# sbatch run_cctm_2016_12US2.256pe.csh
# if you get the following error it means the compute nodes are not running 
#sbatch: error: Batch job submission failed: Required partition not available (inactive or drain)

# if you get this error
# sbatch run_cctm_2016_12US2.256pe.csh
#sbatch: error: Batch job submission failed: More processors requested than permitted


# Check the number of processors on the machine, and whether you have hyperthreading turned off
#!/bin/csh -f
#SBATCH --nodes=16
#SBATCH --ntasks-per-node=16
#Model 	vCPU 	Memory (GiB) 	Instance Storage (GiB)
# c5.4xlarge 	16 	32 	EBS-Only

# created a run script to use only 8 cpu per node for 128 pe job
#sbatch run_cctm_2016_12US2.128pe.csh
