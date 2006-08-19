% TPV3
  faultnormal = 3;
  vrup = -1.;
  vp  = 6000.;
  vs  = 3464.;
  rho = 2670.;
  dc  = 0.4;
  mud = .525;
  mus = 10000.;
  mus = { .677    'cube' -15001. -7501. -1.  15001. 7501. 1. };
  tn  = -120e6;
  td  = 0.;
  th  = -70e6;
  th  = { -81.6e6 'cube'  -1501. -1501. -1.   1501. 1501. 1. };
  viscosity = [ .1 .7 ];
  origin = 0;
  dx  = 100;
  dt  = .008;
  nt = 20;
  bc1      = [   0   0   0 ];
  bc2      = [  -3   3  -2 ];
  n1expand = [  50  50  50 ];
  n1expand = [   0   0   0 ];
  n2expand = [   0   0   0 ];
  itcheck = 0;
  np = [ 4 4 2 ];
  affine = [ 1. 0. 0.  0. 1. 0.  0. 0. 1.  1. ];
  nn       = [ 211 136 101 ];
  ihypo    = [  -1  -1  -1 ];
return

  out = { 'x'    1      1 1 1   -1 -1 -1 };
  out = { 'mr'   1      1 1 1   -1 -1 -1 };
  out = { 'mu'   1      1 1 1   -1 -1 -1 };
  out = { 'lam'  1      1 1 1   -1 -1 -1 };
  out = { 'y'    1      1 1 1   -1 -1 -1 };
  out = { 'a'    1      1 1 1   -1 -1 -1 };
  out = { 'v'    1      1 1 1   -1 -1 -1 };
  out = { 'u'    1      1 1 1   -1 -1 -1 };
  out = { 'w'    1      1 1 1   -1 -1 -1 };
  out = { 'am'   1      1 1 1   -1 -1 -1 };
  out = { 'vm'   1      1 1 1   -1 -1 -1 };
  out = { 'um'   1      1 1 1   -1 -1 -1 };
  out = { 'wm'   1      1 1 1   -1 -1 -1 };
  out = { 'pv'   1      1 1 1   -1 -1 -1 };
  out = { 'nhat' 1      1 1 1   -1 -1 -1 };
  out = { 'ts0'  1      1 1 1   -1 -1 -1 };
  out = { 'tsm0' 1      1 1 1   -1 -1 -1 };
  out = { 'tn0'  1      1 1 1   -1 -1 -1 };
  out = { 'mus'  1      1 1 1   -1 -1 -1 };
  out = { 'mud'  1      1 1 1   -1 -1 -1 };
  out = { 'dc'   1      1 1 1   -1 -1 -1 };
  out = { 'co'   1      1 1 1   -1 -1 -1 };
  out = { 'sa'   1      1 1 1   -1 -1 -1 };
  out = { 'sv'   1      1 1 1   -1 -1 -1 };
  out = { 'su'   1      1 1 1   -1 -1 -1 };
  out = { 'ts'   1      1 1 1   -1 -1 -1 };
  out = { 'sam'  1      1 1 1   -1 -1 -1 };
  out = { 'svm'  1      1 1 1   -1 -1 -1 };
  out = { 'sum'  1      1 1 1   -1 -1 -1 };
  out = { 'tsm'  1      1 1 1   -1 -1 -1 };
  out = { 'tn'   1      1 1 1   -1 -1 -1 };
  out = { 'sl'   1      1 1 1   -1 -1 -1 };
  out = { 'psv'  1      1 1 1   -1 -1 -1 };
  out = { 'trup' 1      1 1 1   -1 -1 -1 };
  out = { 'tarr' 1      1 1 1   -1 -1 -1 };

