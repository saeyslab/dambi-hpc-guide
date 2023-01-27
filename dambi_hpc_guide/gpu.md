# GPU

Documentation for using the GPU cluster joltik or accelgor is provided in the manual under Chapter 21 "HPC-UGent GPU cluster".

When using a GPU cluster, first try a simple test script to see if your GPU is properly requested. This can usually be done using a single line of Python, e.g. `torch.cuda.is available()` in Pytorch.

### PyTorch

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

## GPU Usage

For seeing the GPU Usage, you can use `nvidia-smi`, `nvtop`, `nvitop`.