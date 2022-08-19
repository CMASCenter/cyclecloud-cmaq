#!/bin/csh -f
set echo

#  -----------------------
#  Download and build HDF5
#  -----------------------
   mkdir /data/build-hdf5
   cd /data/build-hdf5
   wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
   tar xvf hdf5-1.10.5.tar.gz
   rm -f hdf5-1.10.5.tar.gz
   cd hdf5-1.10.5
   setenv CFLAGS "-O3"
   setenv FFLAGS "-O3"
   setenv CXXFLAGS "-O3"
   setenv FCFLAGS "-O3"
   ./configure --prefix=/shared/build-hdf5/install --enable-fortran --enable-cxx --enable-shared --with-pic
   make |& tee make.gcc9.log
##  make check > make.gcc9.check
   make install

