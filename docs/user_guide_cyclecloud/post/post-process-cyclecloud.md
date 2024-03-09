## Scripts to run combine and post processing 

### Build the POST processing routines

Run the bldit script for combine.

```
cd /shared/build/openmpi_gcc/CMAQ_v54/POST/combine/scripts
./bldit_combine.csh gcc |& tee ./bldit_combine.gcc.log
```

Run the bldit script for calc_tmetric

```
cd /shared/build/openmpi_gcc/CMAQ_v54/POST/calc_tmetric/scripts
./bldit_calc_tmetric.csh gcc |& tee ./bldit_calc_tmetric.gcc.log
```

Run the bldit script for hr2day

```
cd /shared/build/openmpi_gcc/CMAQ_v54/POST/hr2day/scripts
./bldit_hr2day.csh gcc |& tee ./bldit_hr2day.gcc.log
```

# Scripts to post-process CMAQ output

### Note, the post-processing analysis should be done on the head node 

Ideally the post-processing would be done on the HTC queue, but the R packages were installed to the head node system library and were not acccessible to the compute nodes. Installing the R software and packages to the /shared volume will be investigated in future work.

Verify that the compute nodes are no longer running if you have completed all of the benchmark runs

`squeue`

You should see that no jobs are running.

Show compute nodes

`scontrol show nodes`


### Edit, Build and Run the POST processing routines

You need to run the post processing scripts for every benchmark case.

```
cd /shared/build/openmpi_gcc/CMAQ_v54/POST/combine/scripts
cp /shared/cyclecloud-cmaq/run_scripts/run_combine_conus.csh .
```

Examine the run script

`cat run_combine_conus.csh`

The post processing scripts are set up for a specific case, example:

setenv APPL Bench_2016_12SE1

note, you will need to change the sed command to a different configuration if you ran another case, example:

setenv APPL 2018_12US1_3x96

Modify the scripts using the instructions below.

```
setenv DIR /shared/build/openmpi_gcc/CMAQ_v54/

cd $DIR/POST/combine/scripts
cp run_combine.csh run_combine_conus.csh
sed -i 's/Bench_2016_12SE1/2018_12US1_3x96/g' run_combine_conus.csh
sed -i 's/intel/gcc/g' run_combine_conus.csh
sed -i 's/2016-07-01/2017-12-22/g' run_combine_conus.csh
sed -i 's/2016-07-14/2017-12-23/g' run_combine_conus.csh
sed -i 's/cb6r3_ae7_aq/cb6r5_ae7_aq/g' run_combine_conus.csh
sed -i 's/METCRO3D_$YY$MM$DD.nc/METCRO3D_$YYYY$MM$DD.nc/g' run_combine_conus.csh
sed -i 's/METCRO2D_$YY$MM$DD.nc/METCRO2D_$YYYY$MM$DD.nc/g' run_combine_conus.csh
setenv METDIR /shared/data/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed/
setenv CMAQ_DATA /shared/data/output
./run_combine_conus.csh

cd $DIR/POST/calc_tmetric/scripts
./bldit_calc_tmetric.csh gcc |& tee ./bldit_calc_tmetric.gcc.log
cp run_calc_tmetric.csh run_calc_tmetric_conus.csh
sed -i 's/Bench_2016_12SE1/2018_12US1_3x96/g' run_calc_tmetric_conus.csh
sed -i 's/intel/gcc/g' run_calc_tmetric_conus.csh
sed -i 's/201607/201712/g' run_calc_tmetric_conus.csh
setenv METDIR /shared/data/2018_12US1/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed/
setenv CMAQ_DATA /shared/data/output
./run_calc_tmetric_conus.csh

cd $DIR/POST/hr2day/scripts
sed -i 's/v532/v533/g' bldit_hr2day.csh
./bldit_hr2day.csh gcc |& tee ./bldit_hr2day.gcc.log
cp run_hr2day.csh run_hr2day_conus.csh
sed -i 's/Bench_2016_12SE1/2018_12US1_3x96/g' run_hr2day_conus.csh
sed -i 's/intel/gcc/g' run_hr2day_conus.csh
sed -i 's/2016182/2017356/g' run_hr2day_conus.csh
sed -i 's/2016195/2017357/g' run_hr2day_conus.csh
sed -i 's/201607/201712/g' run_hr2day_conus.csh
setenv CMAQ_DATA /shared/data/output
./run_hr2day_conus.csh


```

