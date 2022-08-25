        module util_module

        implicit none

        contains

! ----------------------------------------------------------------------
        subroutine setup (ncols8, nrows8, nlays8, nvars8)

        use get_env_module
        use general_module

        integer*8, intent(out) :: ncols8, nrows8, nlays8, nvars8

        integer :: k, stat
        character (len = 16) :: npcol_row

        include 'mpif.h'

        call mpi_init (stat)
        call mpi_comm_size (mpi_comm_world, nprocs, stat)
        call mpi_comm_rank (mpi_comm_world, mype, stat)

        call get_env (ncols, 'ncols',  1)
        call get_env (nrows, 'nrows',  1)
        call get_env (nlays, 'nlays',  1)
        call get_env (nvars, 'nvars',  1)

        call get_env (npcol_row, 'npcol_row',  '1 1')
        call get_env (ncd_64bit_offset, 'ncd_64bit_offset',  .false.)

        ncols8 = ncols
        nrows8 = nrows
        nlays8 = nlays
        nvars8 = nvars

        read (npcol_row, *) npcol, nprow

        if (mype == 0) then
           print *, ' ==d== npcol nprow ', npcol, nprow
        end if

        if (nprocs .ne. npcol * nprow) then
           print *, ' Error: npcol * nprow /= nprocs'
           stop
        end if

        do k = 1, n_cases
           write (outfname(k), '(a4, i1, a1, i2.2, a1, i2.2)') 'data', k, 
     &            '_', npcol, 'x', nprow
        end do

        glsize(1) = ncols
        glsize(2) = nrows
        glsize(3) = nlays
        glsize(4) = nvars

        allocate (ncols_pe(nprocs), nrows_pe(nprocs),
     $            colsx_pe(2, nprocs), rowsx_pe(2, nprocs),
     $            colr_ncols_pe(nprow), colr_nrows_pe(nprow),
     $            colr_colsx_pe(2, nprow), colr_rowsx_pe(2, nprow),
     $            colc_ncols_pe(npcol), colc_nrows_pe(npcol),
     $            colc_colsx_pe(2, npcol), colc_rowsx_pe(2, npcol),
     $            var_id(nvars), var_name(nvars),
     $            stat=stat)

        if (stat .ne. 0) then
           print *, 'Error: Allocating memory'
           stop
        end if

        do k = 1, nvars
           write (var_name(k), '(a4, i3.3)') 'var_', k
        end do

        end subroutine setup

! ----------------------------------------------------------------------
        subroutine work (data)

        real, intent(inout) :: data(:,:,:,:)

        real, allocatable :: loc_data(:,:,:,:)
        integer :: stat, i, j, k, m, h
        real    :: temp

        allocate (loc_data(size(data,1), size(data,2),
     $            size(data,3), size(data,4)), stat=stat)

        temp = data(1,1,1,1)
        loc_data = data
        do m = 1, size(data,4)
           do k = 1, size(data,3)
              do j = 1, size(data,2)
                 do i = 1, size(data,1)
                    do h = 1, 100
                       loc_data(i,j,k,m) = sqrt(loc_data(i,j,k,m))
                    end do
                    do h = 1, 20
                       loc_data(i,j,k,m) = sin(loc_data(i,j,k,m))
                       loc_data(i,j,k,m) = exp(loc_data(i,j,k,m))
                    end do
                 end do
              end do
           end do
        end do

        k = size(loc_data, 3)
        m = size(loc_data, 4)

        if (data(1,1,1,1) .ne. loc_data(1,2,k,m)) then
           data(1,1,1,1) = temp
        end if

        deallocate (loc_data)

        end subroutine work

! ----------------------------------------------------------------------
        subroutine process_netcdf_file (fname, mode, data, colsx_pe,
     &                                  rowsx_pe)

        use general_module, only : mype, nprocs, ncols_pe, n_tsteps,
     &                             nrows_pe, ncols, nrows, glsize,
     $                             nlays, nvars, var_name, var_id, bytes
        use netcdf

        character (len = 1000), intent(in) :: fname
        integer, intent(in) :: mode
        real, intent(inout) :: data(:,:,:,:)
        integer, intent(in) :: colsx_pe(:,:), rowsx_pe(:,:)

        include 'mpif.h'

        real, allocatable :: rbuf(:,:,:,:), tdata(:,:,:,:)
        integer :: dsize, status(MPI_STATUS_SIZE), vdimid(5), start(4),
     &             count(4), k, stat, fileid, t
        real*8 :: timeio(2), timeiomax, timeiomin, rate,
     &            tot_timeiomax, tot_timeiomin, 
     &            maxrate, minrate, begtime

        if (mype == 0) then
           allocate (tdata(glsize(1),glsize(2),nlays,nvars),
     $               stat=stat)
           if (stat .ne. 0) then
              print *, 'Error: Allocating memory'
              stop
           end if

           stat = nf90_create (fname, mode, fileid)
           stat = nf90_def_dim (fileid, 'cols', ncols, vdimid(1))
           stat = nf90_def_dim (fileid, 'rows', nrows, vdimid(2))
           stat = nf90_def_dim (fileid, 'lays', nlays, vdimid(3))
           stat = nf90_def_dim (fileid, 'time', nf90_unlimited, vdimid(4))
           stat = nf90_def_dim (fileid, 'vars', nvars, vdimid(5))

           do k = 1, nvars
              stat = nf90_def_var (fileid, var_name(k), nf90_float,
     &                             vdimid(1:4), var_id(k))
           end do
      
           stat = nf90_enddef (fileid) 
        end if

        start = 1
        count = 1
        count(3) = nlays
        count(2) = nrows
        count(1) = ncols

        timeio = 0.0
        do t = 1, n_tsteps
           if (mype == 0) then
              begtime = mpi_wtime()
              tdata(colsx_pe(1, mype+1):colsx_pe(2, mype+1),
     &              rowsx_pe(1, mype+1):rowsx_pe(2, mype+1),:,:) = data
              do k = 1, nprocs-1
                 dsize = ncols_pe(k+1) * nrows_pe(k+1) * nlays * nvars
                 allocate (rbuf(ncols_pe(k+1),nrows_pe(k+1),nlays,nvars),
     &                     stat=stat)
                 call mpi_recv (rbuf, dsize, mpi_real, k, k, mpi_comm_world
     &                          , status, stat)
                 tdata(colsx_pe(1, k+1):colsx_pe(2, k+1),
     &                 rowsx_pe(1, k+1):rowsx_pe(2, k+1),:,:) = rbuf
                 deallocate (rbuf)
              end do
              timeio(1) = timeio(1) + mpi_wtime() - begtime

              begtime = mpi_wtime()
              do k = 1, nvars
                 stat = nf90_put_var (fileid, var_id(k), tdata(:,:,:,k),
     &                                start, count)
              end do
              timeio(2) = timeio(2) + mpi_wtime() - begtime
           else
              dsize = ncols_pe(mype+1) * nrows_pe(mype+1) * nlays * nvars
              begtime = mpi_wtime()
              call mpi_send (data, dsize, mpi_real, 0, mype, mpi_comm_world
     &                       , stat)
              timeio(1) = timeio(1) + mpi_wtime() - begtime
           end if
           start(4) = start(4) + 1
           data = data + 100000.0
           call work (data)
        end do
        data = data - n_tsteps * 100000.0

        call mpi_reduce(timeio(1), timeiomax, 1, MPI_REAL8, MPI_MAX, 0,
     &                  mpi_comm_world, stat)
        call mpi_reduce(timeio(1), timeiomin, 1, MPI_REAL8, MPI_MIN, 0,
     &                  mpi_comm_world, stat)

        if (mype == 0) then
           stat = nf90_close (fileid)
           deallocate (tdata)
           WRITE(*,'(a,2e12.4)') "o_rnet: Min/Max Co time  =",timeiomin, timeiomax
        end if

        call mpi_reduce(timeio(2), timeiomax, 1, MPI_REAL8, MPI_MAX, 0,
     &                  mpi_comm_world, stat)

        rate  = n_tsteps * bytes / (timeio(2) * 1024 * 1024)

        call mpi_reduce(rate, minrate, 1, MPI_REAL8, MPI_MIN, 0,
     &                  mpi_comm_world, stat)

        call mpi_reduce(timeio(1)+timeio(2), tot_timeiomax, 1, MPI_REAL8, MPI_MAX, 0,
     &                  mpi_comm_world, stat)
        call mpi_reduce(timeio(1)+timeio(2), tot_timeiomin, 1, MPI_REAL8, MPI_MIN, 0,
     &                  mpi_comm_world, stat)

        if (mype == 0) then
           WRITE(*,'(a,2e12.4,a,i15,a,2e12.4,a)')
     &     "        Min/Max IO time  =",timeiomax, timeiomax,
     &     " sec  Data =", n_tsteps*bytes," Bytes   Bandwidth=", 
     &     minrate, minrate, " Mb/sec"

           WRITE(*,'(a,2e12.4,a,i15,a,2e12.4,a)')
     &     "        tot Min/Max time =", tot_timeiomin, tot_timeiomax

        end if

        end subroutine process_netcdf_file

        end module util_module
