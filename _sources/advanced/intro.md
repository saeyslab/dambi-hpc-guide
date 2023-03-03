# Advanced topics

- Use of Singularity and Nextflow
    - https://www.nextflow.io/docs/latest/singularity.html
- Use of EasyBuild 
    - https://easybuild.io/tutorial/

## Tips

Try to estimate your required time and memory. If you request a lot of resources, your job will be waiting in the queue for longer. However, if you don’t request enough resources (e.g. the memory is exceeded or the walltime runs out), your job will automatically be terminated. Therefore, we advise to try to slightly overestimate your required resources. For example, if you expect your job to take 1 hour of walltime, request 2 hours. There is no standard way of estimating resources except for trial and error: just try some settings to see what works and how many resources are actually used.


Do a test run with a small version of your problem. If you immediately submit a job that takes 6 hours to run (after a few more hours in queue), and it fails because of a simple bug in your code (or the output was not properly saved), you will lose a lot of time.


Make sure you write as much output as possible to disk, even output that you are not sure you will need. For example, if you want to create a line plot showing the accuracy of an ML model as a function of some hyperparameter, don’t just save the plot itself, but also save the raw data (e.g. as a CSV file). This will allow you to regenerate the plot at a higher resolution, change colors, ... without having to re-run your experiment. Try to think of all the data you might need further on in your analysis before starting your experiment. For example: maybe later in your project you will want to show the training time for your model as a function of the hyperparameter as well?

A simple way of “parallellizing” Python code is by simply submitting multiple jobs for different parameter values. For example, if we want to evaluate the accuracy of an ML model for different hyperparameter settings, you can just submit a job for each hyperparameter setting. Caveat: if the simple python jobs are very small (i.e. only minutes of walltime), this is not a good idea: the cluster introduces some overhead for each job. Instead, you can use job arrays (VSC HPC introduction, chapter 14) or the GNU Parallel tool.


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