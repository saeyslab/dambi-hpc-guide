# Running jobs

Job scripts specify three things: the computational resources being requested (memory, cores, walltime, etc.), the necessary software, and the actual computations. We illustrate this with an example job script.

```bash
#!/bin/bash
#PBS -N count_example # job name
#PBS -l nodes=1:ppn=1 # single-node job, single core
#PBS -l gpus=1 # single GPU (only on GPU clusters!) #PBS -l walltime=2:00:00 # max. 2h of wall time
module load Python /3.9.6 - GCCcore -11.2.0
# copy input data from location where job was submitted from
cp $PBS_O_WORKDIR/input.txt $TMPDIR
# go to temporary working directory (on local disk) & run Python code
cd $TMPDIR
python -c "print(len(open(’input.txt’).read()))" > output.txt
# copy back output data, ensure unique filename using $PBS_JOBID cp output.txt $VSC_DATA/output_${PBS_JOBID}.txt
```

We see that the job script is just a normal bash script, with some extra commands at the top. These are PBS commands that specify the requested resources. In this case, we request 1 node with a single core and a GPU. Note that only the joltik and accelgor clusters have GPUs, so in order for this to work, you will need to switch to one of these (see further). For more information on specifying requested resources, see chapter 13 of the VSC HPC tutorial. For more example job scripts, see chapter 17.

Below the PBS commands, we see a module load command. This command specifies the required software modules, in this case a specific version of Python. If you are using libraries like Numpy, Pytorch, Tensorflow, ..., you will have to load these modules as well. To see a list of available modules, use the module avail command. To search for modules, use module spider. For more information on the module command, see section 4.1 of the VSC HPC tutorial.

Finally, we have the actual computations. This is just a normal bash script. You can choose to have your code in this bash script as in the example, but it is a good practice to keep the bash script as simple as possible, and put your actual computations in a different file (e.g. a python script).
To submit this job to the cluster, we first have to choose a cluster to run it on. By default, jobs are submitted to the victini cluster. This cluster is fine for most jobs, but does not have GPUs. If you want to use a GPU, you will have to switch to either the joltik or accelgor clusters. You can do this using the module swap command: e.g. module swap cluster/joltik. For a list of available clusters, see https://www.ugent.be/hpc/en/infrastructure.

After the cluster has been specified, the job can be submitted using the qsub command: e.g. `qsub script.sh`. This command will return the job ID of the submitted job. To check on the status of a submitted job, use the `qstat` command. To delete a job that is currently in queue or running, use the qdel command with the appropriate job ID.
When the job is done, two files will be saved in the directory where the job was submitted from: and output file `(*.o*)` and an error file `(*.e*)`. These files contain the `STDOUT` and `STDERR` of the job, respectively. You can use standard output redirection to make sure your output gets saved somewhere else (as we do in the example).