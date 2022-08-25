#   To compile on Kraken:
#
#   module load netcdf/3.6.3
#   module load p-netcdf
#   make

 FC    = mpifort
 FPP   = $FC

 lib_path  = /data/build-hdf5

 mod_path = \
            -I /opt/hpcx-v2.9.0-gcc-MLNX_OFED_LINUX-5.4-1.0.3.0-redhat8.4-x86_64/ompi/include \
            -I $(lib_path)/netcdf/include

 add_flags  = # -check all -traceback
 # CMAQ compile flags: -O3 -fno-alias -mp1 -fp-model source -ftz -simd -align all -xHost -vec-guard-write -unroll-aggressive
 # -ffixed-form -ffixed-line-length-132 -funroll-loops -finit-character=32
 F_FLAGS    = $(add_flags) -O3 -ffixed-form -ffixed-line-length-132 -funroll-loops -finit-character=32 $(mod_path) -I .
 FR_FLAGS   = $(add_flags) -free -O3       $(mod_path) -I .
 LINK_FLAGS = 

EXECUTABLE = d.x

OBJS = \
general_mod.o \
get_env.o \
util.o \
subhdomain.o \
d.o

SRC1 = d.F subhdomain.F get_env.f90

  LIBS = \
 -L$(lib_path)/netcdf/lib -lnetcdf -lnetcdff

.SUFFIXES: .F .f .c .F90 .f90

$(EXECUTABLE) : $(OBJS)
	$(FC) $(OBJS) -o $(EXECUTABLE) $(LIBS)

.F.o:
	$(FC) -c $(F_FLAGS) $<

.f90.o:
	$(FC) -c $(FFR_FLAGS) $<

clean :
	-rm -f $(EXECUTABLE) *.o 
