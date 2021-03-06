#!/usr/bin/env python
"""
SCEC Code Validation Workshop, Test Problem 12-2D
FIXME: prestress not correct
"""
import math
import numpy as np
import cst
prm = cst.sord.parameters()
s_ = cst.sord.s_

# number of processes
prm.nproc3 = 1, 1, 2

# model dimensions
prm.delta = 100.0, 100.0, 100.0, 100.0 / 12500.0
prm.shape = (
    2,
    int(16500.0 / prm.delta[1] +  21.5),
    int(12000.0 / prm.delta[2] + 120.5),
    int(    8.0 / prm.delta[3] +   1.5),
)

# boundary conditions
prm.bc1 = 1,  0, 0
prm.bc2 = 1, 10, 0

# mesh
alpha = math.sin(math.pi / 3.0)
prm.affine = (1.0, 0.0, 0.0), (0.0, alpha, 0.0), (0.0, 0.5, 1.0)
prm.n1expand = 0, 0, 50
prm.n2expand = 0, 0, 50

# hypocenter
j = 1
k = 12000.0 / prm.delta[1] + 1
l = prm.shape[2] // 2 + 1
prm.ihypo = j, k, l

# near-fault volume
j = 1.5
k = 1.5, 15000.0 / prm.delta[1] + 0.5
l = 3000.0 / prm.delta[2] + 0.5
l = prm.ihypo[2] - l, prm.ihypo[2] + l

# material properties
prm.hourglass = 1.0, 2.0
prm.fieldio = [
    ('=', 'rho', [], 2700.0),
    ('=', 'vp',  [], 5716.0),
    ('=', 'vs',  [], 3300.0),
    ('=', 'gam', [], 0.2),
    ('=', 'gam', [j,k,l,()], 0.02),
]

# fault parameters
k = 1, 15000.0 / prm.delta[1]
l = prm.ihypo[2]
prm.faultnormal = 3
prm.fieldio += [
    ('=',  'co',  [], 2e5),
    ('=',  'dc',  [], 0.5),
    ('=',  'mud', [], 0.1),
    ('=',  'mus', [], 1e4),
    ('=',  'mus', [(),k,l,()], 0.7),
    ('=R', 's11', [1,(),l,0], 's11.bin'),
    ('=R', 's22', [1,(),l,0], 's22.bin'),
    ('=R', 's33', [1,(),l,0], 's33.bin'),
]

# nucleation
i = 1500.0 / prm.delta[0]
j, k, l = prm.ihypo
prm.fieldio += [
    ('=', 'mus', s_[:,k-i-1:k+i+1,l,:], 0.62),
    ('=', 'mus', s_[:,k-i:k+i,    l,:], 0.54),
]

# fault time histories
x, j, l = 0, 1, prm.ihypo[2]
for y in 0, 15, 30, 45, 75, 120:
    k = y * 100.0 / prm.delta[1] + 1
    for f in 'su1', 'su2', 'su3', 'sv1', 'sv2', 'sv3', 'ts1', 'ts2', 'ts3', 'tnm':
        p = 'faultst%03ddp%03d-%s.bin' % (x, y, f)
        p = p.replace('fault-', 'fault-0')
        prm.fieldio += [('=w', f, [j,k,l,()], p)]

# body time histories
x, j = 0, 1
for y, z in [
    (0, -30),
    (0, -20),
    (0, -10),
    (0,  10),
    (0,  20),
    (0,  30),
    (3, -10),
    (3,  -5),
    (3,   5),
    (3,  10),
]:
    k = y * 100.0 / prm.delta[1] / alpha + 1
    l = z * 100.0 / prm.delta[2] + prm.ihypo[2]
    for f in 'u1', 'u2', 'u3', 'v1', 'v2', 'v3':
        p = 'body%03dst%03ddp%03d-%s.bin' % (z, x, y, f)
        p = p.replace('body-', 'body-0')
        prm.fieldio += [('=w', f, [j,k,l,()], p)]

# stage job
job = cst.sord.stage(prm)

# pre-stress
d = np.arange(prm.shape[1]) * alpha * prm.delta[1]
x = d * 9.8 * -1147.16
y = d * 9.8 * -1700.0
z = d * 9.8 * -594.32
k = int(13800.0 / prm.delta[1] + 1.5)
x[k:] = y[k:]
z[k:] = y[k:]
x.astype('f').tofile(job.rundir + '/s11.bin')
y.astype('f').tofile(job.rundir + '/s22.bin')
z.astype('f').tofile(job.rundir + '/s33.bin')

# launch job
cst.sord.launch(job)

