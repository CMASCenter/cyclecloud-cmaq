## Install R, Rscript and Packages

<a href="https://linuxize.com/post/how-to-install-r-on-centos-7/">How to install R on Centos7</a>

May need to install on head node into a local mylibs directory, and then copy to the compute nodes, in order to run post processing R scripts on HTC node using slurm..
Currently, I seem to need to install as sudo, otherwise the packages are missing dependencies.
The issue is that if I need to terminate the cluster, then anything in the root or default install directory is deleted. Only the /shared files are retained.

<a href="https://researchcomputing.princeton.edu/support/knowledge-base/rrstudio">Using R on HPC Clusters</a>

Use the following commands, and also install packages - note, see website above for full details:

Install R

cd /shared/build/

```
setenv R_VERSION 4.3.3
curl -O https://cran.rstudio.com/src/base/R-4/R-${R_VERSION}.tar.gz
tar -xzvf R-${R_VERSION}.tar.gz
cd R-${R_VERSION}
```

<a href="https://docs.posit.co/resources/install-r-source/">Installing R from source</a>

Install packages required.

```
sudo yum install readline-devel
sudo yum install libX11-devel libXt-devel -y
sudo yum install bzip2-devel -y
sudo yum install pcre2-devel -y
sudo yum install libcurl-devel -y
```

Install ImageMagick to allow display back to your local computer.

```
sudo yum groupinstall "Development Tools" -y
sudo yum install ImageMagick
sudo yum install ImageMagick-devel
sudo yum install xauth
```

Install R in /shared/build directory

```
./configure --prefix=/shared/build/R/${R_VERSION} --enable-R-shlib --enable-memory-profiling
make
make install
```

Verify that R is working

```
/shared/build/R/${R_VERSION}/bin/R --version
```




Logout and then log back in using the ssh -option -Y




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
install.packages("dplyr")
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

or to install to local directory

`R CMD INSTALL ncdf4_1.13.tar.gz --configure-args="--with-nc-config=/shared/build-hdf5/install/bin/nc-config" -l "/shared/build/R_libs"`


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
install.packages("sp")
```

```
cd /shared/cyclecloud-cmaq/qa_scripts/R_packages
sudo R CMD INSTALL rgdal_1.6-7.tar.gz
```

```
sudo -i R
install.packages("ggplot2")
```


`sudo R CMD INSTALL M3_0.3.tar.gz`

Install ImageMagick to allow display back to your local computer.

To view the script, install imagemagick 


```
sudo yum groupinstall "Development Tools" -y
sudo yum install ImageMagick
sudo yum install ImageMagick-devel
sudo yum install xauth
```

Logout and then log back in using the ssh -option -Y 

```
 ssh -Y $USER@IP-address
```

Other ideas for fixing display back to local host. <a href="https://www.cyberciti.biz/faq/how-to-fix-x11-forwarding-request-failed-on-channel-0/">how-to-fix-x11-forwarding-request-failed-on-channel-0</a>

Make sure that you have Xquartz running on your local machine, and that you have given permission to display back from the cyclecloud server.

On your local terminal:
`host +`

Test the display

```
display
```

