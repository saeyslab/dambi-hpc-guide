# MPI multi-core

```bash
#!/bin/bash
#PBS -N mpi_hello            # job name
#PBS -l nodes=2:ppn=all      # 2 nodes, all cores per node
#PBS -l walltime=2:00:00     # max. 2h of wall time

module load intel/2021b
module load vsc-mympirun

# go to working directory, compile and run MPI hello world program
cd $PBS_O_WORKDIR
mpicc mpi_hello.c -o mpi_hello
mympirun ./mpi_hello
```