"""
ALCF Cetus

echo '+mpiwrapper-xl' >> .soft

Run from GPFS: /gpfs/veas-fs0/

Useful commands:
    qstat
    cbank
    partlist

debug/profile:
    bgq_stack <corefile>
    coreprocessor <corefile>
    VPROF_PROFILE=yes
    /home/morozov/fixes/libc.a
"""

login = 'cetus.alcf.anl.gov'
hostname = 'cetuslac1'
maxcores = 16
maxnodes = 1024
maxram = 15000
fortran_serial = 'bgxlf2008_r'
fortran_mpi = 'mpixlf2003_r'

fortran_flags = {
    'f': '-u -qlanglvl=2003pure',
    'g': '-C -qsmp=omp:noopts:noauto -qfloat=nofold -qflttrap -qsigtrap -g',
    'g': '-C -qsmp=omp:noopts:noauto -qfloat=nofold -qflttrap -g',
    't': '-C -qsmp=omp:noauto -qflttrap',
    'p': '-O -qsmp=omp:noauto -p /bgsys/drivers/ppcfloor/bgpm/lib/libbgpm.a /home/morozov/HPM/lib/libmpihpm.a',
    'O': '-O3 -qsmp=omp:noauto',
    '8': '-qrealsize=8',
}

launch = {
    's_exec':  '{command}',
    's_debug': 'gdb {command}',
    'm_exec':  'runjob -p {ppn} -n {nproc} --verbose=INFO --block $COBALT_PARTNAME --envs BG_SHAREDMEMSIZE=32MB --envs PAMI_VERBOSE=1 ${{COBALT_CORNER:+--corner}} $COBALT_CORNER ${{COBALT_SHAPE:+--shape}} $COBALT_SHAPE : {command}',
    'submit':  'qsub -O {name} -t {minutes} -n {nodes} --env BG_SHAREDMEMSIZE=32MB:PAMI_VERBOSE=1 --mode script "{name}.sh"',
    'submit2': 'qsub -O {name} -t {minutes} -n {nodes} --env BG_SHAREDMEMSIZE=32MB:PAMI_VERBOSE=1 --mode script --dependenices {depend} "{name}.sh"',
}

