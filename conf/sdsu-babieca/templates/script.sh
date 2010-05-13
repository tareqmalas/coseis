#!/bin/bash -e

#PBS -N %(name)s
#PBS -M %(email)s
#PBS -q %(queue)s
#PBS -l nodes=%(nodes)s:ppn=%(ppn)s:mpi
#PBS -l walltime=%(walltime)s
#PBS -e %(rundir)s/stderr
#PBS -o %(rundir)s/stdout
#PBS -m abe
#PBS -V

cd "%(rundir)s"

echo "$( date ): %(name)s started" >> log
%(pre)s
mpiexec -n %(nproc)s %(bin)s
%(post)s
echo "$( date ): %(name)s finished" >> log

