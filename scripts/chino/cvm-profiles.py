#!/usr/bin/env python
"""
CVM profiles
"""
import os
import numpy as np
import pyproj
import cst

# data directory
path = os.path.join('run', 'data') + os.sep

# mesh
y, x = np.loadtxt(path + 'station-list.txt', usecols=(1, 2)).T
z_ = np.linspace(0.0, 500.0, 501)
z, x = np.meshgrid(z_, x)
z, y = np.meshgrid(z_, y)

# cvms
r, p, s = cst.cvms.extract(x, y, z, ['rho', 'vp', 'vs'], rundir='run/cvms')
r.astype('f').tofile(path + 'cvms-rho.bin')
p.astype('f').tofile(path + 'cvms-vp.bin')
s.astype('f').tofile(path + 'cvms-vs.bin')

# project to cvm-h coordinates
proj = pyproj.Proj(**cst.cvmh.projection)
x, y = proj(x, y)

# cvmh
r, p, s = cst.cvmh.extract(x, y, z, ['rho', 'vp', 'vs'], False, vs30=None, no_data_value='nan')
r.astype('f').tofile(path + 'cvmh-rho.bin')
p.astype('f').tofile(path + 'cvmh-vp.bin')
s.astype('f').tofile(path + 'cvmh-vs.bin')

# cvmg
r, p, s = cst.cvmh.extract(x, y, z, ['rho', 'vp', 'vs'], False)
r.astype('f').tofile(path + 'cvmg-rho.bin')
p.astype('f').tofile(path + 'cvmg-vp.bin')
s.astype('f').tofile(path + 'cvmg-vs.bin')

