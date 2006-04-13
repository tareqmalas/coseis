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
  nt  = 900;
  itcheck = -1;
  out = { 'x'      1   1 1 1   -1 -1 -1 };
  out = { 'vm'   100   1 1 1   -1 -1 -1 };
  out = { 'svm'  100   1 1 0   -1 -1  0 };
  out = { 'sl'   100   1 1 0   -1 -1  0 };
  out = { 'trup'  -1   1 1 0   -1 -1  0 };
  timeseries = { 'svm' -7500.     0. 0. };
  timeseries = { 'sl'  -7500.     0. 0. };
  timeseries = { 'ts'  -7500.     0. 0. };
  timeseries = { 'svm'     0. -6000. 0. };
  timeseries = { 'sl'      0. -6000. 0. };
  timeseries = { 'ts'      0. -6000. 0. };
  timeseries = { 'svm' -7500. -6000. 0. };
  timeseries = { 'sl'  -7500. -6000. 0. };
  timeseries = { 'ts'  -7500. -6000. 0. };
  bc1      = [   0   0   0 ];
  n1expand = [  50  50  50 ];

% 2b. xz-shear symmetric
  affine = [ 1. 0. 1.  0. 1. 0.  0. 0. 1. ] / 1.;
  nn       = [ 421 136 101 ];
  ihypo    = [   0  -1  -1 ];
  bc2      = [   0   3  -3 ];
  n2expand = [  50   0   0 ];
  timeseries = { 'svm'  7500.     0. 0. };
  timeseries = { 'sl'   7500.     0. 0. };
  timeseries = { 'ts'   7500.     0. 0. };
  timeseries = { 'svm'  7500. -6000. 0. };
  timeseries = { 'sl'   7500. -6000. 0. };
  timeseries = { 'ts'   7500. -6000. 0. };


