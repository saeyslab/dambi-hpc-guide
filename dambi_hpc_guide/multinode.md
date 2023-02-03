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
   Python or [NextFlow](https://www.nextflow.io/docs/latest/index.html).
2. Using the split-apply-combine approach: partition the data, process each partition separately and merge the processed
   partitions.

The first approach is more involved as code likely needs to be updated, but it is also very powerful and flexible. The
second approach requires only a bash script to submit jobs to the queue for every partition of the dataset, but can only
be applied if each part of the dataset can be processed independently.

## Using a framework

Dask can be executed on multiple nodes using the [`dask-mpi`](http://mpi.dask.org/en/latest/), which allows for an easy
setup of a Dask cluster in an existing MPI environment. The HPC provides an existing MPI environment that can be used
through the [mympirun](https://github.com/hpcugent/vsc-mympirun) module.

`dask-mpi` can be used in Dask by including the following code at the top of your Dask script
```
from dask_mpi import initialize
initialize()
```
The `initialize` function will look at the MPI rank of the current process to determine whether the current execution
will be the Dask scheduler (rank 0), the client executing the script's logic (rank 1), or a worker (all ranks larger
then one). To run a Dask program with this method, we need to spawn at least 3 processes using MPI.

We can launch MPI processes on the HPC with the following job submission script
```

```
By setting `nodes` larger than 1, we can run the application in a multinode setting. Keep in mind that it is not
guaranteed that each process runs on a separate node, the HPC job scheduler decides what is optimal.

## Split-apply-combine
