# Multi-node computing

Multi-node computing involves the distribution of workload over more than one compute node. This can be required for
memory intensive computations that require more memory than available in a single node. Also for CPU intensive
workloads, parallelizing across multiple nodes can be required if the compute power of a single node is insufficient.
Furthermore, multi-node computing allows you to potentially spend less time in the job queue. By requesting a smaller
amount of resources on multiple nodes instead of requesting all resources of one node, the job scheduler can fill in
resource gaps on partially used nodes and schedule your jobs quicker.

Not any program or script can take advantage of multi-node computing. Generally, there are two ways to adapt or write
a program for multi-node computing:
1. Write the program using a framework capable of distributed computing, such as [Dask](https://www.dask.org/) for
   Python or [Nextflow](https://www.nextflow.io/docs/latest/index.html).
2. Using the split-apply-combine approach: partition the data, process each partition separately and merge the processed
   partitions.

The first approach is more involved as code likely needs to be updated, but it is also very powerful and flexible. The
second approach requires only a bash script to submit jobs to the queue for every partition of the dataset, but can only
be applied if each part of the dataset can be processed independently.

## Using a framework

Frameworks such as Dask and Nextflow can take advantage of multi-node computing. Nextflow implements this through
[executors](https://www.nextflow.io/docs/latest/executor.html). Because the UGhent HPC uses the SLURM resource manager,
we need the Nextflow SLURM executor. 

Dask has a few possibilities for setting up a multi-node cluster:
- `dask-mpi` is the most straightforward option for a
   non-interactive processing script, such as script that takes in a large input, performs an operation on it, and writes
   the output to disk. 
- `dask-jobqueue` is interesting for interactive applications which might require scaling up or down
   the available compute power during the course of a session. For example, when using Dask for data exploration in a
   jupyter notebook.
- The most flexible/customizable option is to set up the different parts of a Dask cluster with job scripts. This allows
  you to fully customize the resources for each part of the Dask application. 
  
All of these, and more options are discussed in the [Dask
documentation](https://docs.dask.org/en/latest/deploying-hpc.html). Here we focus on how this can be implemented on the
UGhent HPC.

### `dask-mpi`

Dask can be executed on multiple nodes using the [`dask-mpi`](http://mpi.dask.org/en/latest/), which allows for an easy
setup of a Dask cluster in an existing MPI environment. The HPC provides an MPI environment that can be used
through the [mympirun](https://github.com/hpcugent/vsc-mympirun) module.

`dask-mpi` can be used in Dask by including the following code at the top of your Dask client script
```
from dask_mpi import initialize
initialize()

from dask.distributed import Client
client = Client()  # Connect this local process to remote workers
```
The `initialize` function will look at the MPI rank of the current process to determine whether the current process
will be the Dask scheduler (rank 0), the client executing the script's logic (rank 1), or a worker (all ranks larger
then one). To run a Dask program with this method, we need to spawn at least 3 processes using MPI.

We can launch MPI processes on the HPC with the following job submission script
```
#!/bin/bash

#PBS -m abe
#PBS -M youremail@ugent.be
#PBS -l walltime=1:00:00
#PBS -l nodes=6:ppn=8
#PBS -l mem=32gb

module load Python
module load vsc-mympirun

mympirun --hybrid 8 python client_script.py
```
This example script spawns 8 processes (`ppn=8`) over 6 nodes (`nodes=6`). Note that the `--hybrid` setting of
`mympirun` has to be equal to the `ppn` setting so that `mympirun` knows how many processes per node it can spawn. Keep
in mind that it is not guaranteed that each group of 8 processes runs on a separate node. The HPC job scheduler decides
what is the optimal configuration to provide you with 8*6 processes on a maximum of 6 nodes. The `mem=32gb` setting
tells the scheduler to reserve 32GB of RAM memory **per node**. This memory is then divided over the 8 processes we
request on each node.

### `dask-jobqueue`

[`dask-jobqueue`](https://jobqueue.dask.org/en/latest/) directly uses the job queue system (SLURM) to setup a Dask
cluster. It autonomously submits jobs to the queue to set up a cluster and to scale it up or down. It can be setup by
including the following snippet at the beginning of the Dask client script:

```
from dask_jobqueue import SLURMCluster
cluster = SLURMCluster()
cluster.scale(jobs=10)    # Deploy ten single-node jobs

from dask.distributed import Client
client = Client(cluster)  # Connect the client to the cluster
```
At the moment when the line `cluster.scale(jobs=10)` is executed `dask-jobqueue` will submit ten jobs to the HPC cluster
that will each run a worker. Since, `dask-jobqueue` submits jobs to the queue, you might be tempted to run the client
script on the HPC login node, however, this is a misuse of the login node as the client script is a long running script
that requires resources. Instead, the client script must be submitted to the HPC queue, and `dask-jobqueue` can then
submit jobs from within the client job.

### Setup a Dask cluster using separate job scripts

A Dask cluster consists of three components:
1. The client, which contains all the processing logic that needs to be executed.
2. The scheduler, which orchestrates all the work that is submitted to be executed by the client.
3. The workers, which execute tasks as demanded by the scheduler.

Each of these components can  be submitted individually to the HPC job queue system. The client script contains a Dask
`Client` object which connects to the Dask cluster. Then, Dask provides two self-explanatory command line programs
`dask-scheduler` and `dask-worker`, which can be submitted to setup the scheduler and workers.

## Split-apply-combine

In the split-apply-combine approach, the dataset is explicitly divided into smaller chunks, each chunk is processed
separately, and the results are combined again. For example, a CSV of 100,000 rows can be processed by 100 jobs that
each process 1000 rows. This approach has the benefit that it can be used to distribute any program or script over
multiple nodes as you simply run the same program or script on smaller chunks of the input data.

On the HPC, this can be achieved using job arrays, which are submitted like so:
```
#!/bin/bash

#PBS -t 1-100

script.sh $PBS_ARRAYID
```
When submitting this script with `qsub`, it will be executed 100 times and the $PBS_ARRAYID will contain the ID of the
current execution (from 1 to 100). `script.sh` can then use the ID to determine which chunk of the dataset it should
process.

