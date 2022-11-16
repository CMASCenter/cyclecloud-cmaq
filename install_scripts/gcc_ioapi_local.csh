#!/bin/csh -f
set echo

#  --------------------------------------
#  Add /usr/local/lib to the library path
#  --------------------------------------
#   if [ -z ${LD_LIBRARY_PATH} ]
#   then
#      export LD_LIBRARY_PATH=/usr/local/lib
#   else
#      export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
#   fi
#  ----------------------
#  Unpack and build IOAPI
#  ----------------------
#  Set local install directory for libraries
   setenv LDIR /21dayscratch/scr/l/i/lizadams/build
   cd $LDIR
#  Set Cloud Tutorial directory
   setenv CLOUD /proj/ie/proj/CMAS/CMAQ/cyclecloud-cmaq
   
   git clone https://github.com/cjcoats/ioapi-3.2
   cd ioapi-3.2
   git checkout -b 20200828
   setenv BASEDIR $LDIR/ioapi-3.2
   setenv BIN Linux2_x86_64gfort
   mkdir $BIN
   setenv CPLMODE nocpl
   cd ioapi 
   # need to copy Makefile to fix BASEDIR setting from HOME to /shared/build/ioapi-3.2
   cp $CLOUD/Makefile.basedir_fix_local $BASEDIR/ioapi/Makefile
   # need updated Makefile to include ‘-DIOAPI_NCF4=1’ to the MFLAGS make-variable to avoid multiple definition of `nf_get_vara_int64_’
   cp $CLOUD/Makeinclude.Linux2_x86_64gfort $BASEDIR/ioapi/
   make |& tee make.log
   cd $BASEDIR/m3tools
   cp $CLOUD/Makefile.fix_ioapi_lib_path_local Makefile
   make HOME=$BASEDIR/..
