# Python single core

```bash
#!/bin/bash
#PBS -N count_example        # job name
#PBS -l nodes=1:ppn=1        # single-node job, single core
#PBS -l walltime=00:01:00    # max. 1 minute of wall time

module load Python/3.10.4-GCCcore-11.3.0
# copy input data from location where job was submitted from
cp $PBS_O_WORKDIR/input.txt $TMPDIR
# go to temporary working directory (on local disk) & run Python code
cd $TMPDIR
python -c "print(len(open('input.txt').read()))" > output.txt
# copy back output data, ensure unique filename using $PBS_JOBID
cp output.txt $VSC_DATA/output_${PBS_JOBID}.txt
```