#!/usr/bin/env python
"""
Prepare output for uploading to the SCEC Code Validation Workshop website.
"""
import os, imp
import numpy as np

# parameters
path = 'run/'
meta = imp.load_source('meta', path + 'meta.py')
meta.dx = meta.delta[0]
meta.dt = meta.delta[3]
meta.nt = meta.shape[3]
dtype = meta.dtype
t = np.arange(meta.nt) * meta.dt

# output directory
if not os.path.exists(path + 'cvws'):
    os.mkdir(path + 'cvws')

# formats
fmt1 = '%20.12f' + 7 * ' %14.6f'
fmt2 = '%20.12f' + 6 * ' %14.6f'

# headers
header="""\
# problem=TPV12-2D
# author=Geoffrey Ely
# date={rundate}
# code=SORD
# element_size={dx}
# time_step={dt}
# num_time_steps={nt}
# location={sta}
"""
header1 = """\
# Column #1 = Time (s)
# Column #2 = horizontal slip (m)
# Column #3 = horizontal slip rate (m/s)
# Column #4 = horizonatl shear stress (MPa)
# Column #5 = vertical slip (m)
# Column #6 = vertical slip rate (m/s)
# Column #7 = vertical shear stress (MPa)
# Column #8 = normal stress (MPa)
t h-slip h-slip-rate h-shear-stress v-slip v-slip-rate v-shear-stress n-stress
"""
header2="""\
# Column #1 = Time (s)
# Column #2 = horizontal displacement (m)
# Column #3 = horizontal velocity (m/s)
# Column #4 = vertical displacement (m)
# Column #5 = vertical velocity (m/s)
# Column #6 = normal displacement (m)
# Column #7 = normal velocity (m/s)
t h-disp h-vel v-disp v-vel n-disp n-vel
"""

# fault stations
for sta in meta.deltas:
    if sta.startswith('fault') and sta.endswith('su1.bin'):
        sta = sta[:-8]
        meta.sta = sta
        f = path + sta + '-%s.bin'
        su1 = np.fromfile(f % 'su1', dtype)
        y   = np.fromfile(f % 'su2', dtype)
        z   = np.fromfile(f % 'su3', dtype)
        suv = np.sqrt(y * y + z * z)
        sv1 = np.fromfile(f % 'sv1', dtype)
        y   = np.fromfile(f % 'sv2', dtype)
        z   = np.fromfile(f % 'sv3', dtype)
        svv = np.sqrt(y * y + z * z)
        ts1 = np.fromfile(f % 'ts1', dtype) * 1e-6
        y   = np.fromfile(f % 'ts2', dtype)
        z   = np.fromfile(f % 'ts3', dtype)
        tsv = np.sqrt(y * y + z * z) * 1e-6
        tnm = np.fromfile(f % 'tnm', dtype) * 1e-6
        c   = np.array([t, su1, sv1, ts1, suv, svv, tsv, tnm]).T
        with open(path + 'cvws/' + sta + '.asc', 'w') as fh:
            fh.write(header % meta.__dict__)
            fh.write(header1)
            np.savetxt(fh, c, fmt1)

# body stations
for sta in meta.deltas:
    if sta.startswith('body') and sta.endswith('u1.bin'):
        sta = sta[:-7]
        meta.sta = sta
        f = path + sta + '-%s.bin'
        u1 = np.fromfile(f % 'u1', dtype)
        u2 = np.fromfile(f % 'u2', dtype)
        u3 = np.fromfile(f % 'u3', dtype)
        v1 = np.fromfile(f % 'v1', dtype)
        v2 = np.fromfile(f % 'v2', dtype)
        v3 = np.fromfile(f % 'v3', dtype)
        c   = np.array([t, u1, v1, u2, v2, u3, v3]).T
        with open(path + 'cvws/' + sta + '.asc', 'w') as fh:
            fh.write(header % meta.__dict__)
            fh.write(header2)
            np.savetxt(fh, c, fmt2)

