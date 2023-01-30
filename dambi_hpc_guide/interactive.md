# Interactive sessions

```{important}
Read [Chapter 8 "Using the HPC-UGent web portal"](https://www.ugent.be/hpc/en/support/documentation.htm) of the HPC Documentation first, as this gives a general introduction to Open OnDemand.
```

## Interactive RStudio

- Login at https://login.hpc.ugent.be
- Select Interactive Apps > RStudio Server
    - cluster: `slaking`
    - 1 node
    - max. of 8 cores per node
    - select latest RStudio and R version
    - Launch

```{note}
For cluster `slaking` strict limits are in place per user: max. 5 jobs in queue, max. 3 jobs running, max. of 8 cores and **27GB of memory in total** for running jobs.
```

- Wait some time (usually <1 min)
- Connect to R Studio Server
- Paste the script you want to run, which should also install all dependencies with e.g. `BiocManager`
- Use the Files interface at the Dashboard to upload your data and download the output files

### I need more than 27GB of RAM
You can't go over the 27GB limit for the `slaking` cluster and only work on a subset of your data to create/debug a script without waiting too long.

There are 2 alternatives:

- Start an interactive session on a different cluster
    - Good: You can go up to 738 GiB of RAM on a `kirlia` node
    - Bad: The waiting time is longer. You can check the queue at the Dashboard.

- Launch your script as a job via the Job Composer
    - Good: You can launch multiple jobs and don't have to interact with them while they are running
    - Bad: It can take a while to debug your job submission script and get a correct job submission.

```{note}
You can view the maximum memory of a node at https://www.ugent.be/hpc/en/infrastructure. You can determine your required memory using the [RStudio memory widget](https://support.posit.co/hc/en-us/articles/1500005616261-Understanding-Memory-Usage-in-the-RStudio-IDE) when analyzing a subset of your total data.
```

Ideally, you don't active wait on queued jobs, but further improve your script on the debugging cluster using a subset of your total data.

## Using the Job Composer
If the waiting time is too long or you need more resources, you can launch your script as a job via the [Job Composer](https://login.hpc.ugent.be/pun/sys/myjobs).


## Links with further documentation
- [Open OnDemand Documentation](https://osc.github.io/ood-documentation/master/)
- [A video walkthrough](https://www.youtube.com/watch?v=4-w-4wjlnPk)