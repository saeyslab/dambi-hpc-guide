# Your HPC setup

- Clone repo to HPC with git
- Install dependencies (also conda, maybe easybuild if needed and present)

The standard workflow for using the HPC is as follows:

1. Connect to login node
    -  Using SSH: login.hpc.ugent.be
    - Using the HPC-UGent web portal: https://login.hpc.ugent.be
2. Transfer files: either using the HPC-UGent web portal, or a tool like scp or rsync
3. Create a job script
4. Submit the job
5. Be patient: the job (usually) first enters the queue, after which it will run and finish.
6. Inspect and/or move results

## Access
To get access to the UGent HPC, you can follow the instructions on this website: https://www.ugent.be/hpc/en/access/faq/access. Detailed information on how to use and add SSH keys to your account is also available in the VSC HPC tutorial.

## HPC Infrastructure
The HPC is built up of a number of different clusters. Each cluster consists again of a number of servers, which are called worker nodes. This is where the actual computations happen. Each worker node has a number of processors, which again have multiple cores. Note that you never directly connect to a worker node. Instead, you connect to a login node, a specific server that only exists for logging into the HPC. You should avoid doing large computations or storing lots of data on a login node. Once logged into the login node, you create a job script, which is a bash script describing the resources you need (number of cores, amount of RAM, number of GPUs, amount of time, ...), and contains the instructions to run the actual computations.

## The HPC file system
The HPC file system is a bit different than what you might be used to. Every user gets not only a home directory, but also a data and scratch directory. You will usually never use the actual paths to these directories. Instead, the HPC provides you with environment variables that point to each location:
- `$VSC_HOME`: only for limited number of small files and scripts. Note that even your project might already be too big for the home directory (especially if it includes any datasets).
- `$VSC_DATA`: used for ‘long-term’ storage of (relatively) large files.
- `$VSC_SCRATCH`: used for ‘live’ input/output data in jobs. Scratch is generally much faster than data or home. Always remove data from this directory once your jobs have finished: there are no guarantees about the time your data will be stored on this system.

The HPC also provides a few useful environment variables for use in job scripts:
- `$PBS_JOBID`: the ID of the currently running job.
- `$PBS_O_WORKDIR`: directory from which job was submitted on the login node. It is common to use `cd $PBS_O_WORKDIR` at the beginning of a job script.
- `$TMPDIR`: a local unique directory specific to the running job. This directory is cleaned up automatically when the job is done, so make sure to move any result files stored here.
