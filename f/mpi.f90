! MPI routines
module collective_m
use mpi
implicit none
integer :: c
integer, private :: ip, ipmaster
contains

! Initialize
subroutine initialize( ipout, master )
implicit none
logical, intent(out) :: master
integer, intent(out) :: ipout
integer :: e
call mpi_init( e )
call mpi_comm_rank( mpi_comm_world, ip, e  )
ipout = ip
master = .false.
if ( ip == 0 ) master = .true.
end subroutine

! Finalize
subroutine finalize
implicit none
integer :: e
call mpi_finalize( e )
end subroutine

! Processor rank
subroutine rank( np, ipout, ip3 )
implicit none
integer, intent(in) :: np(3)
integer, intent(out) :: ipout, ip3(3)
integer :: e
logical :: period(3) = .false.
call mpi_cart_create( mpi_comm_world, 3, np, period, .true., c, e )
if ( c == mpi_comm_null ) then
  call mpi_finalize( e )
  stop
end if
call mpi_comm_rank( c, ip, e  )
call mpi_cart_coords( c, ip, 3, ip3, e )
ipout = ip
end subroutine

! Set master processor
subroutine setmaster( ip3master )
implicit none
integer, intent(in) :: ip3master(3)
integer :: e
call mpi_cart_rank( c, ip3master, ipmaster, e )
end subroutine

! Broadcast
subroutine broadcast( r )
implicit none
real, intent(inout) :: r(:)
integer :: i, e
i = size(r)
call mpi_bcast( r, i, mpi_real, ipmaster, c, e )
end subroutine

! Integer minimum
subroutine pimin( i )
implicit none
integer, intent(inout) :: i
integer :: ii, e
call mpi_allreduce( i, ii, 1, mpi_integer, mpi_min, c, e )
i = ii
end subroutine

! Real sum
subroutine psum( r )
implicit none
real, intent(inout) :: r
real :: rr
integer :: e
call mpi_allreduce( r, rr, 1, mpi_real, mpi_sum, c, e )
r = rr
end subroutine

! Logical or
subroutine plor( l )
implicit none
logical, intent(inout) :: l
logical :: ll
integer :: e
call mpi_allreduce( l, ll, 1, mpi_logical, mpi_lor, c, e )
l = ll
end subroutine

! Real minimum
subroutine pmin( r )
implicit none
real, intent(inout) :: r
real :: rr
integer :: e
call mpi_allreduce( r, rr, 1, mpi_real, mpi_min, c, e )
r = rr
end subroutine

! Real maximum
subroutine pmax( r )
implicit none
real, intent(inout) :: r
real :: rr
integer :: e
call mpi_allreduce( r, rr, 1, mpi_real, mpi_max, c, e )
r = rr
end subroutine

! Real global maximum & location, send to master
subroutine pmaxloc( r, i, nnoff )
implicit none
real, intent(inout) :: r
integer, intent(inout) :: i(3)
integer, intent(in) :: nnoff(3)
integer :: e, iip
real :: local(2), global(2)
local(1) = r
local(2) = ip
call mpi_allreduce( local, global, 1, mpi_2real, mpi_maxloc, c, e )
r   = global(1)
iip = global(2)
if ( ( ip == ipmaster .or. ip == iip ) .and. iip /= ipmaster ) then
end if
if ( iip /= ipmaster ) then
call mpi_barrier( c, e )
open( 9, file='log', position='append' )
write( 9, * ) ip, ipmaster, iip, c
close( 9 )
  i = i - nnoff
  !call mpi_sendrecv_replace( i, 3, mpi_integer, ipmaster, 8, iip, 8, c, mpi_status_ignore, e )
  call mpi_sendrecv_replace( i, 3, mpi_integer, ipmaster, 8, iip, 8, mpi_comm_world, mpi_status_ignore, e )
  i = i + nnoff
open( 9, file='log', position='append' )
write( 9, * ) 'YES'
close( 9 )
end if
end subroutine

! Swap halo scalar
subroutine swaphaloscalar( f, nhalo )
implicit none
real, intent(inout) :: f(:,:,:)
integer, intent(in) :: nhalo
integer :: i, e, left, right, ng(3), nl(3), isend(4), irecv(4), tsend, trecv
ng = (/ size(f,1), size(f,2), size(f,3) /)
do i = 1, 3
  call mpi_cart_shift( c, i-1, 1, left, right, e )
  nl = ng
  nl(i) = nhalo
  isend = 0
  irecv = 0
  isend(i) = ng(i) - 2 * nhalo
  call mpi_type_create_subarray( 3, ng, nl, isend, mpi_order_fortran, mpi_real, tsend, e )
  call mpi_type_create_subarray( 3, ng, nl, irecv, mpi_order_fortran, mpi_real, trecv, e )
  call mpi_type_commit( tsend, e )
  call mpi_type_commit( trecv, e )
  call mpi_sendrecv( f, 1, tsend, right, 0, f, 1, trecv, left, 0, c, mpi_status_ignore, e )
  call mpi_type_free( tsend, e )
  call mpi_type_free( trecv, e )
  isend(i) = nhalo
  irecv(i) = ng(i) - nhalo
  call mpi_type_create_subarray( 3, ng, nl, isend, mpi_order_fortran, mpi_real, tsend, e )
  call mpi_type_create_subarray( 3, ng, nl, irecv, mpi_order_fortran, mpi_real, trecv, e )
  call mpi_type_commit( tsend, e )
  call mpi_type_commit( trecv, e )
  call mpi_sendrecv( f, 1, tsend, left, 1, f, 1, trecv, right, 1, c, mpi_status_ignore, e )
  call mpi_type_free( tsend, e )
  call mpi_type_free( trecv, e )
end do
end subroutine

! Swap halo vector
subroutine swaphalovector( f, nhalo )
implicit none
real, intent(inout) :: f(:,:,:,:)
integer, intent(in) :: nhalo
integer :: i, e, left, right, ng(4), nl(4), isend(4), irecv(4), tsend, trecv
ng = (/ size(f,1), size(f,2), size(f,3), size(f,4) /)
do i = 1, 3
  call mpi_cart_shift( c, i-1, 1, left, right, e )
  nl = ng
  nl(i) = nhalo
  isend = 0
  irecv = 0
  isend(i) = ng(i) - 2 * nhalo
  call mpi_type_create_subarray( 4, ng, nl, isend, mpi_order_fortran, mpi_real, tsend, e )
  call mpi_type_create_subarray( 4, ng, nl, irecv, mpi_order_fortran, mpi_real, trecv, e )
  call mpi_type_commit( tsend, e )
  call mpi_type_commit( trecv, e )
  call mpi_sendrecv( f, 1, tsend, right, 0, f, 1, trecv, left, 0, c, mpi_status_ignore, e )
  call mpi_type_free( tsend, e )
  call mpi_type_free( trecv, e )
  isend(i) = nhalo
  irecv(i) = ng(i) - nhalo
  call mpi_type_create_subarray( 4, ng, nl, isend, mpi_order_fortran, mpi_real, tsend, e )
  call mpi_type_create_subarray( 4, ng, nl, irecv, mpi_order_fortran, mpi_real, trecv, e )
  call mpi_type_commit( tsend, e )
  call mpi_type_commit( trecv, e )
  call mpi_sendrecv( f, 1, tsend, left, 1, f, 1, trecv, right, 1, c, mpi_status_ignore, e )
  call mpi_type_free( tsend, e )
  call mpi_type_free( trecv, e )
end do
end subroutine

end module

