# cyclecloud-cmaq

## Scripts and code to configure an Azure Virtual Machine or Cycle Cloud Cluster to run CMAQ for 2 day CONUS2 Domain


[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10696798.svg)](https://doi.org/10.5281/zenodo.10696798)


### To obtain this code use the following command.

```
git clone -b main https://github.com/CMASCenter/cyclecloud-cmaq.git
```

Note, there are two sets of install scripts as the build path is sensitive to the mpi version!

For Single VM running AlmaLinux with module load gcc-9.2.0  and module load mpi/openmpi-4.1.5  install:

```
./gcc_install.csh
./gcc_ioapi.csh
./gcc_cmaq.csh
```

For Cycle Cloud running AlmaLinux with module load gcc-9.2.0 and module load mpi/openmpi-4.1.5 install:

```
./gcc_netcdf_cluster.csh
./gcc_ioapi_cluster.csh
./gcc_cmaq_cyclecloud.csh
```


