# Install CMAQ and pre-requisite libraries on linux

### Login to updated cluster
(note, replace the centos.pem with your Key Pair)

`ssh -v -Y -i ~/[your_azure].pem [scheduler-node-ip-address]`


### Change shell to use .tcsh

`sudo usermod -s /bin/tcsh azureuser`

### Log out and then log back in to activate the tcsh shell


### Optional Step to allow multiple users to run on the CycleCloud Cluster

Add group name to users
`sudo groupadd cmaq`

Add the new group for each user

`sudo usermod -a -G cmaq azureuser`


Logout and log back in to reset the new group 


Set the group to be default group for files created by the user

`sudo usermod -g cmaq azureuser`

logout and log back in to have it take effect

### Check to see if the group is added to your user ID

`id`

## Make the /shared/build directory

`sudo mkdir /shared/build`

## Change ownership to your username

`sudo chown azureuser /shared/build`

## Make the /shared/cyclecloud-cmaq directory

`sudo mkdir /shared/cyclecloud-cmaq`

## Change ownership to your username

`sudo chown azureuser /shared/cyclecloud-cmaq`

## Install git

sudo yum install git


### Install the cluster-cmaq git repo to the /shared directory

`cd /shared`

`git clone -b main https://github.com/CMASCenter/cyclecloud-cmaq.git cyclecloud-cmaq`

`cd cyclecloud-cmaq`

### Optional - Change the group to cmaq recursively for the /shared directory/build

    `sudo chgrp -R cmaq /shared/build`

### Check what modules are available on the cluster

`module avail`

### Load the openmpi module

`module load mpi/openmpi-4.1.0`

### Load the gcc copiler - note, this may have been automatically loaded by the openmpi module

`module load gcc-9.2.0`

### Verify the gcc compiler version is greater than 8.0

`gcc --version`

output:

```
gcc (GCC) 9.2.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### Change directories to install and build the libraries and CMAQ

`cd /shared/cyclecloud-cmaq`

### Build netcdf C and netcdf F libraries - these scripts work for the gcc 8+ compiler

`./gcc_netcdf_cluster.csh`

### A .cshrc script with LD_LIBRARY_PATH was copied to your home directory, enter the shell again and check environment variables that were set using

`cat ~/.cshrc`

### If the .cshrc wasn't created use the following command to create it

`cp dot.cshrc.cyclecloud  ~/.cshrc`

### Execute the shell to activate it

`csh`

`env`

### Verify that you see the following setting

```
echo $LD_LIBRARY_PATH
```

output:

```
/opt/openmpi-4.1.0/lib:/opt/gcc-9.2.0/lib64
```

### Build I/O API library

`./gcc_ioapi_cluster.csh`

### Build CMAQ
note, the primary difference is the location of the openmpi libraries on cyclecloud, /opt/openmpi-4.1.0/lib and include, /opt/openmpi-4.1.0/include

`./gcc_cmaq_cyclecloud.csh`


Check to see that the cmaq executable has been built

`ls /shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc/*.exe`

If it fails due to an issue with finding mpi, you will need to edit the gcc_cmaq_cyclecloud.csh script to point to the location of the mpi library and bin directory.

The following path is specified in the config_cmaq_cyclecloud.csh script, and may need to be updated.
To find the mpi paths, use the command:

`which mpirun`

```
        setenv MPI_INCL_DIR     /opt/openmpi-4.1.0/include              #> MPI Include directory path
        setenv MPI_LIB_DIR      /opt/openmpi-4.1.0/lib             #> MPI Lib directory path
```

