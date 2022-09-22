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
   cd /mnt/build
   git clone https://github.com/cjcoats/ioapi-3.2
   cd ioapi-3.2
   git checkout -b 20200828
   setenv BASEDIR /mnt/build/ioapi-3.2
   setenv BIN Linux2_x86_64gfort
   mkdir $BIN
   setenv CPLMODE nocpl
   cd ioapi 
   # need to copy Makefile to fix BASEDIR setting from HOME to /shared/build/ioapi-3.2
   cp /mnt/cyclecloud-cmaq/Makefile.basedir_fix_mnt $BASEDIR/ioapi/Makefile
   # need updated Makefile to include ‘-DIOAPI_NCF4=1’ to the MFLAGS make-variable to avoid multiple definition of `nf_get_vara_int64_’
   cp /mnt/cyclecloud-cmaq/Makeinclude.Linux2_x86_64gfort $BASEDIR/ioapi/
   make |& tee make.log
   cd $BASEDIR/m3tools
   cp /mnt/cyclecloud-cmaq/Makefile.fix_ioapi_lib_path_mnt Makefile
   make HOME=/mnt/build
