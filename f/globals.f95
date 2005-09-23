!------------------------------------------------------------------------------!
! GLOBALS

module globals_m

implicit none

real, parameter :: &
  pi = 3.14159

integer, parameter :: &
  nz = 80,      & ! max number of input and output zones
  nhalo = 1       ! number of ghost nodes

! 3D vectors
real, allocatable, dimension(:,:,:,:) :: &
  x,            & ! node locations
  v,            & ! **velocity
  u,            & ! **displacement
  w1,           & ! temporary storage
  w2              ! temporary storage

! 3D scalars
real, allocatable, dimension(:,:,:) :: &
  mr,           & ! mass ratio
  lam,          & ! Lame parameter
  mu,           & ! Lame parameter
  y,            & ! hourglass constant
  s1,           & ! temporary storage
  s2              ! temporary storage

! PML state
real, allocatable, dimension(:,:,:,:) :: &
  p1,           & ! **j1 pml momentum
  p2,           & ! **k1 pml momentum
  p3,           & ! **l1 pml momentum
  p4,           & ! **j2 pml momentum
  p5,           & ! **k2 pml momentum
  p6,           & ! **l2 pml momentum
  g1,           & ! **j1 pml gradient
  g2,           & ! **k1 pml gradient
  g3,           & ! **l1 pml gradient
  g4,           & ! **j2 pml gradient
  g5,           & ! **k2 pml gradient
  g6              ! **l2 pml gradient

! PML damping
real, allocatable, dimension(:) :: &
  dn1,          & ! pml node damping -2*d     / (2+d*dt)
  dn2,          & ! pml node damping  2       / (2+d*dt)
  dc1,          & ! pml cell damping (2-d*dt) / (2+d*dt)
  dc2             ! pml cell damping  2*dt    / (2+d*dt)

! Fault vectors
real, allocatable, dimension(:,:,:,:) :: &
  nrm,          & ! fault surface normals
  t0,           & ! initial traction
  t1,           & ! temporary storage
  t2,           & ! temporary storage
  t3              ! temporary storage

! Fault scalars
real, allocatable, dimension(:,:,:) :: &
  mus,          & ! coef of static friction
  mud,          & ! coef of dynamic friction
  dc,           & ! slip weakening distance
  co,           & ! cohesion
  area,         & ! fault element area
  r,            & ! radius to hypocenter
  sv,           & ! **slip velocity mangitude
  sl,           & ! **slip path length
  trup,         & ! **rupture time
  tn,           & ! temporary storage
  ts,           & ! temporary storage
  f1,           & ! temporary storage
  f2              ! temporary storage

real :: &
  t,            & ! **time
  dt,           & ! time step
  dx,           & ! spatial step
  inval(nz),    & ! input value
  rho1,         & ! minimum density
  vp1,          & ! minimum P-wave speed
  vs1,          & ! minimum S-wave speed
  rho2,         & ! maximum density
  vp2,          & ! maximum P-wave speed
  vs2,          & ! maximum S-wave speed
  rho,          & ! hypocenter density
  vp,           & ! hypocenter S-wave speed
  vs,           & ! hypocenter P-wave speed
  viscosity(2), & ! viscocity for (1) stress & (2) hourglass corrections
  xhypo(3),     & ! hypocenter location
  tsource,      & ! dominant period
  rsource,      & ! source radius
  moment1(3),   & ! moment source normal components
  moment2(3),   & ! moment source shear components
  vrup,         & ! nucleation rupture velocity
  rcrit,        & ! nucleation critical radius
  trelax,       & ! nucleation relaxation time
  truptol         ! min slip velocity to declare rupture

integer, dimension(3) :: &
  n,            & ! number of global nodes, double nodes counted once
  nn,           & ! number of global nodes, double nodes counted twice
  nm,           & ! size of local 3D arrays
  np,           & ! number of processors
  bc1,          & ! boundary conditions for j1 k1 l1
  bc2,          & ! boundary conditions for j2 k2 l2
  noff,         & ! offset between local and global indices single fault nodes
  nnoff,        & ! offset between local and global indices double fault nodes
  ihypo,        & ! hypocenter node
  i1node,       & ! node calculations start index
  i2node,       & ! node calculations end index
  i1cell,       & ! cell calculations start index
  i2cell,       & ! cell calculations end index
  i1pml,        & ! PML boundary
  i2pml           ! PML boundary

integer :: &
  upward,       & ! upward direction
  nt,           & ! number of time steps
  npml,         & ! number of PML damping nodes
  ifn,          & ! fault normal direction
  it,           & ! current time step
  itcheck,      & ! interval for checkpointing
  wt(6),        & ! wall clock timing array
  noper,        & ! number of zones for spatial derivative operators
  i1oper(2,3),  & ! j1 k1 l1 operator zone start index
  i2oper(2,3),  & ! j2 k2 l2 operator zone end index
  nin,          & ! number of zones for input
  i1in(nz,3),   & ! j1 k1 l1 input start index
  i2in(nz,3),   & ! j1 k1 l1 input end index
  nlock,        & ! number of zones for locking velocity
  i1lock(nz,3), & ! j1 k1 l1 lock zone start index
  i2lock(nz,3), & ! j2 k2 l2 lock zone end index
  lock(nz,3),   & ! flag for locking v1 v2 v3
  nout,         & ! number of zones for output
  i1out(nz,3),  & ! j1 k1 l1 input zone start index
  i2out(nz,3),  & ! j2 k2 l2 input zone end index
  ditout(nz)      ! interval for writing output

character :: &
  oper(2)         ! spatial derivative operators

character(8) :: &
  fieldin(nz),  & ! input variable
  fieldout(nz)    ! output variable

character(16) :: &
  model,        & ! model ID
  grid,         & ! grid generation scheme
  rfunc,        & ! moment source space function
  tfunc           ! moment source fime function

logical :: &
  readfile(nz)    ! read input file

end module

