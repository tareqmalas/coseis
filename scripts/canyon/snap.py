#!/usr/bin/env python
"""
Snapshot plots
"""
import os, imp
import numpy as np
import matplotlib.pyplot as plt

# parameters
exp = 0.5
clim = 0.0, 0.000001
path = 'run' + os.sep

# metadata
meta = imp.load_source('meta', path + 'meta.py')
shape = meta.shapes['snap-v1.bin']
delta = meta.deltas['snap-v1.bin']
dtype = meta.dtype

# read mesh files
nn = shape[1], shape[0]
n = shape[0] * shape[1]
x = np.fromfile(path + 'x.bin', dtype).reshape(nn).T
y = np.fromfile(path + 'y.bin', dtype).reshape(nn).T

# open snapshot files
f1 = open(path + 'snap-v1.bin')
f2 = open(path + 'snap-v2.bin')

# setup figure
fig = plt.figure()

# loop over time steps
for it in range(shape[-1]):

    # read snapshot
    vx = np.fromfile(f1, dtype, n).reshape(nn).T
    vy = np.fromfile(f2, dtype, n).reshape(nn).T
    s = (vx * vx + vy * vy) ** exp

    # plot image
    fig.clf()
    ax = fig.add_subplot(111)
    ax.set_title(it * delta[-1])
    im = ax.pcolor(x, y, s)
    fig.colorbar(im)
    if clim:
        im.set_clim(*clim)

    # wait for mouse click
    fig.canvas.draw()
    fig.ginput(1, 0, False)

