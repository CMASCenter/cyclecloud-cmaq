      SUBROUTINE SUBHDOMAIN ( NPROCS, NPCOL, NPROW, NCOLS, NROWS,
     &                        NCOLS_PE, NROWS_PE, COLSX_PE, ROWSX_PE )

C----------------------------------------------------------------------
C  Purpose:   Subroutine to construct the horizontal
C             processor-to-subdomain map.
 
C  Revision History: 
C       Original version  12/05 by J Young - modified from pario's SUBDMAP
 
C  Argument List Description:
C  In:
C        INTEGER    NPROCS                 ! Number of processors
C        INTEGER    NPCOL                  ! Number of PEs across grid cols
C        INTEGER    NPROW                  ! Number of PEs across grid rows
C        INTEGER    NCOLS                  ! Total number of columns in grid
C        INTEGER    NROWS                  ! Total number of rows in grid
C  Out:
C        INTEGER    NCOLS_PE( NPROCS )     ! Number of columns for each PE
C        INTEGER    NROWS_PE( NPROCS )     ! Number of rows for each PE
C        INTEGER    COLSX_PE( 2,NPROCS )   ! Column index range for each PE
C        INTEGER    ROWSX_PE( 2,NPROCS )   ! Row index range for each PE
 
C----------------------------------------------------------------------

      IMPLICIT  NONE

C Arguments:

      INTEGER NPROCS, NCOLS, NROWS, NPCOL, NPROW
      INTEGER NCOLS_PE( NPROCS ), NROWS_PE( NPROCS )
      INTEGER COLSX_PE( 2,NPROCS ), ROWSX_PE( 2,NPROCS )

C Local Variables: 

      INTEGER I                  ! Loop counter 
      INTEGER NDX                ! Temporary index for processors row, column 
      INTEGER NCOLX              ! Used for computing columns per domain 
      INTEGER NROWX              ! Used for computing rows per domain 
      CHARACTER( 80 ) :: XMSG    ! Message issued from M3EXIT routine 
      CHARACTER( 16 ) :: PNAME = 'SUBHDOMAIN'
      INTEGER ASTAT              ! allocate/deallocate error status

C Dynamic arrays.

      INTEGER, ALLOCATABLE :: NCOLS_WE( : ) ! No. columns in west-to-east subdomains
      INTEGER, ALLOCATABLE :: NROWS_SN( : ) ! No. rows in south-to-north subdomains
 
C----------------------------------------------------------------------

      ALLOCATE ( NCOLS_WE( NPCOL ),
     &           NROWS_SN( NPROW ), STAT=ASTAT )

C Construct the processor-to-subdomain map

      NCOLX = NCOLS / NPCOL
      NROWX = NROWS / NPROW

      DO I = 1 , NPCOL
         NCOLS_WE( I ) = NCOLX
      END DO

      DO I = 1 , NPROW
         NROWS_SN( I ) = NROWX
      END DO

      DO I = 1, NCOLS - NPCOL*NCOLX            ! Spread out remaining columns
         NCOLS_WE( I ) = NCOLS_WE( I ) + 1
      END DO

      DO I = 1, NROWS - NPROW*NROWX
         NROWS_SN( I ) = NROWS_SN( I ) + 1     ! Spread out remaining rows
      END DO
       
C Assign the number of rows and columns for each PE subdomain, 
C and calculate the index range into the global domain

C                                                    NPCOL
C  Example subdomain layout         _____________________________________
C  for 8 processors with           |         |         |        |        |
C  NPCOL=4, NPROW=2.               |         |         |        |        |
C                                  |    4    |    5    |    6   |    7   |
C                                  |         |         |        |        |
C                           NPROW  |_________|_________|________|________|
C                                  |         |         |        |        |
C                                  |         |         |        |        |
C                                  |    0    |    1    |    2   |    3   |
C                                  |         |         |        |        |
C                                  |         |         |        |        |
C                                  |_________|_________|________|________|

      DO I = 1, NPROCS

C Set NDX to the subdomain column index for processor I
         NDX = MOD ( I,NPCOL )
         IF ( NDX .EQ. 0 ) NDX = NPCOL

C Assign the number of columns in this PE
         NCOLS_PE( I ) = NCOLS_WE( NDX )

C Calculate column range of this PE in the global domain
         IF ( NDX .EQ. 1 ) THEN
            COLSX_PE( 1,I ) = 1
            COLSX_PE( 2,I ) = NCOLS_PE( I )
         ELSE
            COLSX_PE( 1,I ) = COLSX_PE( 2,I-1 ) + 1
            COLSX_PE( 2,I ) = COLSX_PE( 2,I-1 ) + NCOLS_PE( I ) 
         END IF

C Set NDX to the subdomain row number for processor I
         NDX = ( I - 1 ) / NPCOL + 1

C Calculate number of rows in this PE
         NROWS_PE( I ) = NROWS_SN( NDX )

C Calculate row range of this PE in the global domain
         IF ( I .LE. NPCOL ) THEN
            ROWSX_PE( 1,I ) = 1
            ROWSX_PE( 2,I ) = NROWS_PE( I )
         ELSE
            ROWSX_PE( 1,I ) = ROWSX_PE( 2,I-NPCOL ) + 1
            ROWSX_PE( 2,I ) = ROWSX_PE( 2,I-NPCOL ) + NROWS_PE( I ) 
         END IF

      END DO

      DEALLOCATE ( NCOLS_WE, NROWS_SN)

      RETURN
      END

