# cyclecloud-cmaq

## Scripts and code to configure an Azure Cycle Cloud for CMAQ

### To obtain this code use the following command.

```
git clone -b main https://github.com/CMASCenter/cyclecloud-cmaq.git
```

Note, there are two sets of install scripts as the build path is sensitive to the mpi version!

For Single VM running AlmaLinux with module load gcc-9.2.1  and module load mpi/openmpi-4.1.1  install:

```
./gcc_install.csh
./gcc_ioapi.csh
./gcc_cmaq.csh
```

For Cycle Cloud running Centos with module load gcc-9.2.0 and module load mpi/openmpi-4.1.0 install:

```
./gcc_netcdf_cluster.csh
./gcc_ioapi_cluster.csh
./gcc_cmaq_cyclecloud.csh
```


