# Multi-node computing

Multi-node computing involves the distribution of workload over more than one compute node. This can be required for
memory intensive computations that require more memory than is available in a single node. Also for CPU intensive
workloads, parallelizing across multiple nodes can be required if the compute power of a single node is insufficient.
Furthermore, multi-node computing allows you to potentially spend less time in the job queue. By requesting a smaller
amount of resources on multiple nodes instead of requesting all resources of one node, the job scheduler can fill in
resource gaps on partially used nodes.

Not any program or script can take advantage of multi-node computing. Generally, there are two ways to adapt
a program for multi-node computing:
1. Write the program using a framework capable of distributed computing, such as [Dask](https://www.dask.org/) for
   Python or [NextFlow](https://www.nextflow.io/docs/latest/index.html).
2. Using the split-apply-combine approach: partition the data, process each partition separately and merge the processed
   partitions.

The first approach is more involved as code likely needs to be updated, but it is also very powerful and flexible. The
second approach requires only a bash script to submit jobs to the queue for every partition of the dataset, but can only
be applied if each part of the dataset can be processed independently.

## Using a framework

## Split-apply-combine
