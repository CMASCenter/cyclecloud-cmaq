## Install R, Rscript and Packages

<a href="https://linuxize.com/post/how-to-install-r-on-centos-7/">How to install R on Centos7</a>

Install R from source on the scheduler node into a local mylibs directory (/shared/build/R-4.3.3)
If R is installed using yum install, then need to install R packages as sudo, otherwise the packages are missing dependencies.
If R is installed under /usr/bin, then when you terminate the cluster, anything in the root or default install directory is deleted. Only files on the /shared and /home directory are retained.

<a href="https://researchcomputing.princeton.edu/support/knowledge-base/rrstudio">Using R on HPC Clusters</a>

Use the following commands, and also install packages - note, see website above for full details:

Install R from source

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
sudo yum update -y
sudo yum install readline-devel -y
sudo yum install libX11-devel libXt-devel -y
sudo yum install bzip2-devel -y
sudo yum install pcre2-devel -y
sudo yum install libcurl-devel -y
sudo yum install java-1.8.0-openjdk -y
sudo yum install libjpeg libjpeg-devel -y
sudo yum install xorg-x11-server-Xvfb -y
```

Install ImageMagick to allow display back to your local computer.

```
sudo yum groupinstall "Development Tools" -y
sudo yum install ImageMagick -y
sudo yum install ImageMagick-devel -y
sudo yum install xauth -y
```

Logout and then log back in using the ssh -option -Y


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

Output:

```
/shared/build/R/${R_VERSION}/bin/R --version
R version 4.3.3 (2024-02-29) -- "Angel Food Cake"
Copyright (C) 2024 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under the terms of the
GNU General Public License versions 2 or 3.
For more information about these matters see
https://www.gnu.org/licenses/.
```

Install packages

```
sudo yum install epel-release -y 
sudo yum config-manager --set-enabled powertools -y
```

Alternatively, you can install as root, to the /bin directory, but then if you terminate the cluster, you will need to reinstall R

```
sudo yum install R
R --version
```

Install packages as root - to make them available to all users (if installed R as root) Otherwise, install without sudo

```
sudo -i R
#or
R

install.packages("stringr")
install.packages("patchwork")
install.packages("dplyr")
install.packages("jpeg")
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
sudo yum install curl -y
sudo yum install libcurl-devel -y
```

Load the gcc and openmpi module before building the hdf5 enabled netcdf libraries.

```
module avail
module load mpi/openmpi-4.1.5
module load gcc-9.2.0
```

```
cd /shared/cyclecloud-cmaq
./gcc_install_hdf5.cyclecloud.csh
```
Need to specify the location of nc-config in your .cshrc

set path = ($path /shared/build/install/bin /shared/build/ioapi-3.2/Linux2_x86_64gfort /shared/build-hdf5/install/bin )

Run command to install ncdf4 package

`cd /shared/cyclecloud-cmaq/qa_scripts/R_packages`

`R CMD INSTALL ncdf4_1.13.tar.gz --configure-args="--with-nc-config=/shared/build-hdf5/install/bin/nc-config"`

or to install to local directory

`R CMD INSTALL ncdf4_1.13.tar.gz --configure-args="--with-nc-config=/shared/build-hdf5/install/bin/nc-config" -l "/shared/build/R_libs"`


Install additional packages as root so that all users will have access.

```
R
install.packages("fields")
install.packages("mapdata")
```

M3 package requires gdal

```
sudo yum install gdal -y
sudo yum install gdal-devel proj-devel -y
```

```
R
install.packages("sp")
```

```
cd /shared/cyclecloud-cmaq/qa_scripts/R_packages
R CMD INSTALL rgdal_1.6-7.tar.gz
```

```
R
install.packages("ggplot2")
```

```
cd  /shared/cyclecloud-cmaq/qa_scripts/R_packages
R CMD INSTALL M3_0.3.tar.gz
```

If you hare having X11 display issues:

<a href="https://www.cyberciti.biz/faq/how-to-fix-x11-forwarding-request-failed-on-channel-0/">how-to-fix-x11-forwarding-request-failed-on-channel-0</a>

Make sure that you have Xquartz running on your local machine, and that you have given permission to display back from the cyclecloud server.

On your local terminal:
`host +`

Test the display

```
display
```

