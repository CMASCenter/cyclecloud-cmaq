## Install R, Rscript and Packages

<a href="https://linuxize.com/post/how-to-install-r-on-centos-7/">How to install R on Centos7</a>

May need to install on head node into a local mylibs directory, and then copy to the compute nodes, in order to run post processing R scripts on HTC node using slurm..

<a href="https://researchcomputing.princeton.edu/support/knowledge-base/rrstudio">Using R on HPC Clusters</a>

Use the following commands, and also install packages - note, see website above for full details:

Install R

```
sudo yum install epel-release
sudo yum config-manager --set-enabled powertools
sudo yum install R
R --version
```

Install packages as root - to make them available to all users

```
sudo -i R
install.packages("stringr")
install.packages("patchwork")
```

Had an issue installing ncdf4
see:
<ahref="https://cirrus.ucsd.edu/~pierce/ncdf/">install ncdf4</a>

ncdf4 REQUIRES the netcdf library be version 4 or above,
AND installed with HDF-5 support (i.e., the netcdf library must be
compiled with the --enable-netcdf-4 flag). If you do not want to install
the full version of netcdf-4 with HDF-5 support, then please install
the old, deprecated ncdf package instead.

ERROR: configuration failed for package ‘ncdf4’
* removing ‘/usr/lib64/R/library/ncdf4’


building netcdf with HDF5 support requires curl.

```
sudo yum install curl
sudo yum install libcurl-devel
```

Load the gcc and openmpi module before building the hdf5 enabled netcdf libraries.

```
module avail
module load mpi/openmpi-4.1.1
module load gcc-9.2.1
```

```
cd /shared/cyclecloud-cmaq
./gcc_install_hdf5.cyclecloud.csh
```
Need to specify the location of nc-config in your .cshrc

set path = ($path /shared/build/install/bin /shared/build/ioapi-3.2/Linux2_x86_64gfort /shared/build-hdf5/install/bin )

Run command to install ncdf4 package

`cd /shared/cyclecloud-cmaq/qa_scripts/R_packages`

`sudo R CMD INSTALL ncdf4_1.13.tar.gz --configure-args="--with-nc-config=/shared/build-hdf5/install/bin/nc-config"`


Install additional packages as root so that all users will have access.

```
sudo -i R
install.packages("fields")
install.packages("mapdata")
```

M3 package requires gdal

```
sudo yum install gdal
sudo yum install gdal-devel proj-devel
```

```
sudo -i R
install.packages("rgdal")
install.packages("ggplot2")
```

`sudo R CMD INSTALL M3_0.3.tar.gz`

