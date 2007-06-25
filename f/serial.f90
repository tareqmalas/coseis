! Collective routines - hooks for parallelization
module m_collective
implicit none
contains

! Initialize
subroutine initialize( ipout, np0, master )
integer, intent(out) :: ipout, np0
logical, intent(out) :: master
ipout = 0
np0 = 1
master = .true.
end subroutine

! Finalize
subroutine finalize
end subroutine

! Process rank
subroutine rank( ipout, ip3, np )
integer, intent(out) :: ipout, ip3(3)
integer, intent(in) :: np(3)
ip3 = np
ip3 = 0
ipout = 0
end subroutine

! Set master process
subroutine setmaster( ip3master )
integer, intent(in) :: ip3master(3)
integer :: i
i = ip3master(1)
end subroutine

! Broadcast real 1d
subroutine rbroadcast1( r )
real, intent(inout) :: r(:)
r = r
end subroutine

! Barrier
subroutine barrier
end subroutine

! Reduce integer
subroutine ireduce( ii, i, op, i2d )
integer, intent(out) :: ii
integer, intent(in) :: i, i2d
character(*), intent(in) :: op
character :: a
a = op(1:1)
ii = i2d
ii = i
end subroutine

! Reduce real
subroutine rreduce( rr, r, op, i2d )
real, intent(out) :: rr
real, intent(in) :: r
integer, intent(in) :: i2d
character(*), intent(in) :: op
character :: a
a = op(1:1)
rr = i2d
rr = r
end subroutine

! Reduce real 1d
subroutine rreduce1( rr, r, op, i2d )
real, intent(out) :: rr(:)
real, intent(in) :: r(:)
integer, intent(in) :: i2d
character(*), intent(in) :: op
character :: a
a = op(1:1)
rr = i2d
rr = r
end subroutine

! Reduce real 2d
subroutine rreduce2( rr, r, op, i2d )
real, intent(out) :: rr(:,:)
real, intent(in) :: r(:,:)
integer, intent(in) :: i2d
character(*), intent(in) :: op
character :: a
a = op(1:1)
rr = i2d
rr = r
end subroutine

! Reduce extrema location, real 3d
subroutine reduceloc( rr, ii, r, op, n, noff, i2d )
real, intent(out) :: rr
real, intent(in) :: r(:,:,:)
integer, intent(out) :: ii(3)
integer, intent(in) :: n(3), noff(3), i2d
character(*), intent(in) :: op
character :: a
a = op(1:1)
ii = n + noff + i2d
select case( op )
case( 'min', 'allmin' ); ii = minloc( r );
case( 'max', 'allmax' ); ii = maxloc( r );
case default; stop 'unknown op in reduceloc'
end select
rr = r(ii(1),ii(2),ii(3))
end subroutine

! Scalar swap halo
subroutine scalarswaphalo( f, n )
real, intent(inout) :: f(:,:,:)
integer, intent(in) :: n(3)
return
f(1,1,1) = f(1,1,1) - n(1) + n(1)
end subroutine

! Vector swap halo
subroutine vectorswaphalo( f, n )
real, intent(inout) :: f(:,:,:,:)
integer, intent(in) :: n(3)
return
f(1,1,1,1) = f(1,1,1,1) - n(1) + n(1)
end subroutine

! Scalar field input/output
subroutine scalario( id, mpio, r, str, s1, i1, i2, i3, i4, nr, ir )
use m_util
real, intent(inout) :: r, s1(:,:,:)
integer, intent(in) :: id, mpio, i1(3), i2(3), i3(3), i4(3), nr, ir
character(*), intent(in) :: str
integer :: i
if ( id == 0 ) return
if ( any( i1 /= i3 .or. i2 /= i4 .or. ir > nr ) ) then
  write( 0, * ) 'Error in scalario: ', id, str
  write( 0, * ) i1, i2
  write( 0, * ) i3, i4
  stop
end if
if ( id > 0 .and. all( i1 == i2 ) ) then
  r = s1(i1(1),i1(2),i1(3))
  return
end if
call rio3( id, str, s1, i1, i2, ir )
i = i3(1) + i4(1) + mpio
end subroutine

! Vector field component input/output
subroutine vectorio( id, mpio, r, str, w1, ic, i1, i2, i3, i4, nr, ir )
use m_util
real, intent(inout) :: r, w1(:,:,:,:)
integer, intent(in) :: id, mpio, ic, i1(3), i2(3), i3(3), i4(3), nr, ir
character(*), intent(in) :: str
integer :: i
if ( id == 0 ) return
if ( any( i1 /= i3 .or. i2 /= i4 .or. ir > nr ) ) then
  write( 0, * ) 'Error in vectorio: ', id, str
  write( 0, * ) i1, i2
  write( 0, * ) i3, i4
  stop
end if
if ( id > 0 .and. all( i1 == i2 ) ) then
  r = w1(i1(1),i1(2),i1(3),ic)
  return
end if
call rio4( id, str, w1, ic, i1, i2, ir )
i = i3(1) + i4(1) + mpio
end subroutine

end module

