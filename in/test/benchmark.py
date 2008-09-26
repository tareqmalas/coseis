#!/usr/bin/env python
from sord import _

# Benchmark

dx = 100.
dt = 0.0075
faultnormal = 0
fixhypo = 2
rsource = 50.
debug = 0
bc1 = 0, 0, 0
npml = 0
hourglass = 1., 1.
oplevel = 2

# 4^3
nt = 4
nn = 16, 16, 16; np = 8, 8, 8
nn =  8,  8,  8; np = 4, 4, 4
nn =  4,  4,  4; np = 2, 2, 2
nn =  2,  2,  2; np = 1, 1, 1

# 128^3
nt = 128
nn = 1024, 1024, 1024; np = 8, 8, 8
nn =  512,  512,  512; np = 4, 4, 4
nn =  256,  256,  256; np = 2, 2, 2
nn =  128,  128,  128; np = 1, 1, 1

# 32^3
nt = 32
nn = 256, 256, 256; np = 8, 8, 8
nn = 128, 128, 128; np = 4, 4, 4
nn =  64,  64,  64; np = 2, 2, 2
nn =  32,  32,  32; np = 1, 1, 1

# 32^3
nt = 64
nn = 512, 512, 512; np = 8, 8, 8
nn = 256, 256, 256; np = 4, 4, 4
nn = 128, 128, 128; np = 2, 2, 2
nn =  64,  64,  64; np = 1, 1, 1

