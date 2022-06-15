# Scripts to run combine and post processing 


### Build the POST processing routines

Copy the buildit script from the repo, as it was corrected to use CMAQv533 rather than CMAQv532

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/combine/scripts
cp /shared/cyclecloud-cmaq/run_scripts/bldit_combine.csh .
```

Run the bldit script for combine.

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/combine/scripts
./bldit_combine.csh gcc |& tee ./bldit_combine.gcc.log
```

Copy the bldit script from the repo.

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/calc_tmetric/scripts
cp /shared/cyclecloud-cmaq/run_scripts/bldit_calc_tmetric.csh .
```

Run the bldit script for calc_tmetric

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/calc_tmetric/scripts
./bldit_calc_tmetric.csh gcc |& tee ./bldit_calc_tmetric.gcc.log
```

Copy the bldit script from the repo.

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/hr2day/scripts
cp /shared/cyclecloud-cmaq/run_scripts/bldit_hr2day.csh .
```
Run the bldit script for hr2day

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/hr2day/scripts
./bldit_hr2day.csh gcc |& tee ./bldit_hr2day.gcc.log
```

Copy the bldit script from the repo.

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/bldoverlay/scripts
cp /shared/cyclecloud-cmaq/run_scripts/bldit_bldoverlay.csh .
```

Run the bldit script for  bldoverlay.

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/bldoverlay/scripts
./bldit_bldoverlay.csh gcc |& tee ./bldit_bldoverlay.gcc.log
```


# Scripts to post-process CMAQ output

### Note, the post-processing analysis should be done on the head node 

Ideally the post-processing would be done on the HTC queue, but the R packages were installed to the head node system library and were not acccessible to the compute nodes. Future work on installing the R software and packages to the /shared volume.

Verify that the compute nodes are no longer running if you have completed all of the benchmark runs

`squeue`

You should see that no jobs are running.

Show compute nodes

`scontrol show nodes`


### Edit, Build and Run the POST processing routines

You need to run the post processing scripts for every benchmark case.

`cp /shared/cyclecloud-cmaq/run_scripts/run_combine_conus.csh .`

Examine the run script

`cat run_combine_conus.csh`

The post processing scripts are set up for a specific case, example:

setenv APPL 2016_CONUS_10x18pe

note, you will need to change the sed command to a different configuration if you ran another case, example:

setenv APPL 2016_CONUS_12x9pe

If you used the CMAQ Benchmark Option 1, with the pre-loaded software, then these scripts have already been modified.

Run the following scripts

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/combine/scripts
sbatch run_combine_conus.csh
```

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/calc_tmetric/scripts
sbatch run_calc_tmetric_conus.csh 
```

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/hr2day/scripts
sbatch run_hr2day_conus.csh 
```

```
cd /shared/build/openmpi_gcc/CMAQ_v533/POST/bldoverlay/scripts
sbatch run_bldoverlay_conus.csh
```

If you used the CMAQ Bechmark Option 2 to install CMAQ yourself, you will need to save and modify the scripts using the instructions below.

```
setenv DIR /shared/build/openmpi_gcc/CMAQ_v533/

cd $DIR/POST/combine/scripts
sed -i 's/v532/v533/g' bldit_combine.csh
cp run_combine.csh run_combine_conus.csh
sed -i 's/v532/v533/g' run_combine_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_10x18pe/g' run_combine_conus.csh
sed -i 's/intel/gcc/g' run_combine_conus.csh
./bldit_combine.csh gcc |& tee ./bldit_combine.gcc.log
sed -i 's/2016-07-01/2015-12-22/g' run_combine_conus.csh
sed -i 's/2016-07-14/2015-12-23/g' run_combine_conus.csh
setenv CMAQ_DATA /shared/data
./run_combine_conus.csh

cd $DIR/POST/calc_tmetric/scripts
./bldit_calc_tmetric.csh gcc |& tee ./bldit_calc_tmetric.gcc.log
cp run_calc_tmetric.csh run_calc_tmetric_conus.csh
sed -i 's/v532/v533/g' run_calc_tmetric_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_10x18pe/g' run_calc_tmetric_conus.csh
sed -i 's/intel/gcc/g' run_calc_tmetric_conus.csh
sed -i 's/201607/201512/g' run_calc_tmetric_conus.csh
setenv CMAQ_DATA /shared/data
./run_calc_tmetric_conus.csh

cd $DIR/POST/hr2day/scripts
sed -i 's/v532/v533/g' bldit_hr2day.csh
./bldit_hr2day.csh gcc |& tee ./bldit_hr2day.gcc.log
cp run_hr2day.csh run_hr2day_conus.csh
sed -i 's/v532/v533/g' run_hr2day_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_10x18pe/g' run_hr2day_conus.csh
sed -i 's/intel/gcc/g' run_hr2day_conus.csh
sed -i 's/2016182/2015356/g' run_hr2day_conus.csh
sed -i 's/2016195/2015357/g' run_hr2day_conus.csh
sed -i 's/201607/201512/g' run_hr2day_conus.csh
setenv CMAQ_DATA /shared/data
./run_hr2day_conus.csh

cd $DIR/POST/bldoverlay/scripts
sed -i 's/v532/v533/g' bldit_bldoverlay.csh
./bldit_bldoverlay.csh gcc |& tee ./bldit_bldoverlay.gcc.log
cp run_bldoverlay.csh run_bldoverlay_conus.csh
sed -i 's/v532/v533/g' run_bldoverlay_conus.csh
sed -i 's/Bench_2016_12SE1/2016_CONUS_10x18pe/g' run_bldoverlay_conus.csh
sed -i 's/intel/gcc/g' run_bldoverlay_conus.csh
sed -i 's/2016-07-01/2015-12-22/g' run_bldoverlay_conus.csh
sed -i 's/2016-07-02/2015-12-23/g' run_bldoverlay_conus.csh
setenv CMAQ_DATA /shared/data
./run_bldoverlay_conus.csh

```

