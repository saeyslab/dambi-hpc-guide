# GPU

GPU acceleration can greatly speedup workloads that are compute-bound, like computer vision and deep learning. The HPC-UGent provides a GPU cluster for this purpose.
Usually it is best to develop your code or job submission on an interactive debugging CPU cluster (slaking) with a small data subset and submit larger non-interactive jobs on the GPU clusters.

Documentation for using the GPU cluster joltik or accelgor is provided in the manual under Chapter 21 "HPC-UGent GPU cluster". General information for GPU SLURM job submissions is also provided [at the VUB HPC documentation](https://hpc.vub.be/docs/job-submission/gpu-job-types/).

When using a GPU cluster, first try a simple test script to see if your GPU is properly requested. This can usually be done using a single line of Python, e.g. `torch.cuda.is available()` in Pytorch.

```{note}
First setup CPU job submissions before you start with GPU jobs.
```

## SLURM

The differences between a CPU and GPU cluster submission are:
- the choice of cluster
- parameters in your script to use the GPU
- installation of a GPU driver and framework like CUDA.

First see which GPU cluster is the least occupied. Note that nodes can have multiple GPU's (4 GPU's per node for joltik and accelgor), so for any partially free node there is probably at least 1 GPU fully available.

Switch to a GPU cluster
```
cat /etc/motd
ml switch cluster/joltik
```

Install CUDA
```
ml load CUDA
```

As an example, here we use [Hydra](./frameworks.md) and the [submitit_slurm plugin](https://hydra.cc/docs/plugins/submitit_launcher/) to submit the jobs to SLURM.
Run a SLURM job with 1 GPU, 5 CPUs and 5GB of RAM in the background, given we run 1 task per node.
```
HYDRA_FULL_ERROR=1 hydra my_script.py hydra/launcher=submitit_slurm hydra.launcher.nodes=1 hydra.launcher.gpus-per-node=1 hydra.launcher.cpus-per-gpu=5 hydra.launcher.mem-per-gpu=5GB device=cuda -m &
```

```{note}
`gpus-per-node` is preferred over `gpus-per-task` and `gpus` because of [GPU and CPU locality](https://hpc.vub.be/docs/job-submission/gpu-job-types/#gpu-job-types). Use `cpus-per-gpu` and `ntasks-per-gpu` to set number of CPUs and tasks.
```

```{note}
If you get a resource error like this, make sure you're switched to a GPU cluster:
`
submitit.core.utils.FailedJobError: sbatch: error: Batch job submission failed: Invalid generic resource (gres) specification
`
```

## Memory

The total memory usage can be tricky to find and to allocate correctly. There are multiple directives for SLURM and `hydra.laucher`:
```
`mem_per_cpu`: memory per cpu
`mem_per_gpu`: memory per gpu
`mem_gb`: total memory per node
```
There is [no SLURM directive](https://hpc.vub.be/docs/job-submission/gpu-job-types/#memory-settings-of-gpu-jobs) for setting GPU memory usage of the job. You can only define the CPU memory.

```{note}
Make sure you request the right unit of memory. e.g. GigaBytes, not the default MegaBytes!
```

## PyTorch

A pre-built PyTorch module is provided on joltik. Loading this module sets up python, CUDA, and pytorch.

When using this module, you could run into some versioning issues. A solution can be switching to loading the python and CUDA module separately, and using a virtualenv with pytorch installed.

A qsub script for DL with pytorch could look like this:

```bash
#!/bin/bash

#PBS -l nodes=1:gpus=1
#PBS -l walltime=4:00:00

# load modules
module load Python
module load CUDA

# load virtualenv
source $VSC_HOME/dl/bin/activate

# run GPU-accelerated script
# NOTE: Specifically point to the python binary in the virtualenv.
# Module loading places the system-wide python before the virtualenv python.
$VSC_HOME/dl/bin/python $VSC_HOME/train.py
```

## Pytorch Lightning

PyTorch Lightning builds on top of PyTorch, removing a lot of boilerplate code.

It has [support for SLURM](https://pytorch-lightning.readthedocs.io/en/stable/clouds/cluster_advanced.html). You can also combine it with [Hydra and submitit](https://github.com/ashleve/lightning-hydra-template), a very powerful combination.

## GPU Usage

For seeing the GPU Usage, you can use `nvidia-smi`, `nvtop`, `nvitop`.