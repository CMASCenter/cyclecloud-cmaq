        program driver

        use general_module
        use util_module
        use get_env_module
        use netcdf

        implicit none

        include 'mpif.h'

        integer*8 :: ncols8, nrows8, nlays8, nvars8
        character (len = 16) :: npcol_row
        integer :: stat, mode1, mode2, k, n, t
        logical :: o_reg_netcdf, o_pnetcdf, o_pe_colr,  o_pe_colc

        call get_env (o_reg_netcdf,     'o_reg_netcdf',     .false.)

        call setup (ncols8, nrows8, nlays8, nvars8)

        bytes = ncols8 * nrows8 * nlays8 * nvars8 * 4
 
        call subhdomain(nprocs, npcol, nprow, ncols, nrows, 
     $                  ncols_pe, nrows_pe, colsx_pe, rowsx_pe)

        call subhdomain(nprow, 1, nprow, ncols, nrows, 
     $                  colr_ncols_pe, colr_nrows_pe, colr_colsx_pe, 
     &                  colr_rowsx_pe)

        call subhdomain(npcol, npcol, 1, ncols, nrows, 
     $                  colc_ncols_pe, colc_nrows_pe, colc_colsx_pe, 
     &                  colc_rowsx_pe)

        allocate (data(ncols_pe(mype+1),nrows_pe(mype+1),nlays,nvars), stat=stat)

        do k = 1, nvars
           do n = 1, nlays
              data(:,:,n,k) = float(100000 + mod(n,10) * 10000 
     &                        + mod(k,10) * 1000 + mype)
           enddo
        end do

        if (ncd_64bit_offset) then
           mode1 = nf_64bit_offset
           mode2 = ior (nf90_noclobber, nf90_64bit_offset)
        else
           mode1 = nf_clobber
        end if

        if (o_reg_netcdf) then
! regular netcdf approach
           call process_netcdf_file (outfname(3), mode2, data, colsx_pe,
     &                               rowsx_pe)
        end if

        deallocate (data, ncols_pe, nrows_pe, colsx_pe, rowsx_pe,
     &              colr_ncols_pe, colr_nrows_pe, 
     &              colr_colsx_pe, colr_rowsx_pe,
     &              colc_ncols_pe, colc_nrows_pe, 
     &              colc_colsx_pe, colc_rowsx_pe)

        call mpi_finalize (stat)

        end program driver
