# Benchmarking
Benchmarking is keeping track of the resources your code uses while executing. This is mostly execution time, but can also be memory usage, disk access, network access...

Before you benchmark on the HPC, first have a working local setup with smaller resources and data subsets.

Local benchmarking tools:
- [hyperfine](https://github.com/sharkdp/hyperfine)
    - language agnostic
    - only execution time
    - easy to use
- [Bencher](https://salsa.debian.org/benchmarksgame-team/benchmarksgame/-/tree/master/bencher)
    - language agnostic
    - runtime and memory
    - generates sites
- [Scalene](https://github.com/plasma-umass/scalene)
    - Python specific
    - runtime, memory and GPU
    - very extensive and overall good support

## HPC Benchmarking
You can scale up these tools on a larger computing node, but they usually do not support benchmarking across multiple nodes. Certain frameworks like Dask or Apache Spark have support for benchmarking. You can also always `ssh` into the nodes to gather usage info, add resource info to your logging or [other means](https://support.ceci-hpc.be/doc/_contents/SubmittingJobs/JobEfficiency.html).

SLURM jobs also keep track of some resource usage.

- `sacct`
```
$ sacct -j 202232023 -o "User,JobID%20,ReqMem,ReqCPUS,TotalCPU,Elapsed,MaxRSS,State"
     User                JobID     ReqMem  ReqCPUS   TotalCPU    Elapsed     MaxRSS      State
--------- -------------------- ---------- -------- ---------- ---------- ---------- ----------
 ceciuser            202232023      132Mc        8  16:25.207   00:02:40             COMPLETED
               202232023.batch      132Mc        8  16:25.207   00:02:40   1080420K  COMPLETED

    MaxRSS/(ReqMem*ReqCPUS) gives the maximum of memory efficiency. In this example, (1080420)÷(132×8×1024)*100 = 99.91%
    TotalCPU/(Elapsed*ReqCPUS) gives the CPU efficiency. In this example, (16×60+25,207)÷((2×60+40)×8)×100 = 76.95%

Note

Slurm checks periodically for the memory usage to get the “Maximum resident set size” of all tasks in job. If your code has a short peak usage of memory slurm will not see it so the value will be underestimated.
```
- `slurm-jobinfo`
```
(base) [vsc43257@gligar07 ~]$ slurm_jobinfo 15451915
Name                : pipeline
User                : vsc43257
Partition           : victini
Nodes               : node3201.victini.os
Cores               : 2
State               : COMPLETED
Submit              : 2022-10-25T11:24:42
Start               : 2022-10-25T11:25:21
End                 : 2022-10-25T11:27:19
Reserved walltime   : 01:00:00
Used walltime       : 00:01:58
Used CPU time       : 00:00:20
% User (Computation): 83.60%
% System (I/O)      : 16.39%
Mem reserved        : 4G/node
Max Mem used        : 312.02M (node3201.victini.os)
Max Disk Write      : 61.44K (node3201.victini.os)
Max Disk Read       : 57.50M (node3201.victini.os)
Working directory   : /kyukon/home/gent/432/vsc43257/napari-spongepy
```
- `seff` (not always installed)
```bash
$ seff 202232023
Job ID: 202232023
Cluster: clusername
User/Group: ceciuser/ceciuser
State: COMPLETED (exit code 0)
Nodes: 1
Cores per node: 8
CPU Utilized: 00:16:25
CPU Efficiency: '76.95%' of 00:21:20 core-walltime
Job Wall-clock time: 00:02:40
Memory Utilized: 1.03 GB
Memory Efficiency: '99.91%' of 1.03 G
```