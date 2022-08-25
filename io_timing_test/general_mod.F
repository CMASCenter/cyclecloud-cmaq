       module general_module
               
       include "netcdf.inc"

       integer, parameter :: n_cases = 7
!               case 1 = pnetcdf
!               case 2 = pnetcdf
!               case 3 = reg netcdf
!               case 4 = time_aggregate
!               case 5 = colc pnetcdf
!               case 6 = dfio netcdf
!               case 7 = netcdf4
       integer, parameter :: n_tsteps = 3
!      integer, parameter :: nlays = 35, nvars = 146

       integer :: ncols, nrows, nlays, nvars, mype, nprocs, npcol, nprow
       integer :: dim_id(5), vdim_id(5)
       integer, allocatable ::      ncols_pe(:),      nrows_pe(:), 
     $                         colr_ncols_pe(:), colr_nrows_pe(:),
     $                         colc_ncols_pe(:), colc_nrows_pe(:)
       integer, allocatable ::      colsx_pe(:,:),      rowsx_pe(:,:), 
     $                         colr_colsx_pe(:,:), colr_rowsx_pe(:,:),
     $                         colc_colsx_pe(:,:), colc_rowsx_pe(:,:)
       integer, allocatable :: var_id(:)

       integer :: col_io_comm

       real, allocatable :: data(:,:,:,:)

       logical :: ncd_64bit_offset

       character (len = 7), allocatable :: var_name(:)
       character (len = 1000) :: outfname(n_cases)

       integer*8 :: bytes

!      NFMPI_OFFSET :: glsize(4)
       integer(8) :: glsize(4)

       end module general_module
