# Hydra

Hydra is a Python framework on top of OmegaConf, enabling you to configure complex application, like a data processing pipeline with lots of steps and parameters. For a complete introduction to Hydra, see [the Hydra documentation](https://hydra.cc/).

## Run a test job locally

Check the configuration has no errors:
```
HYDRA_FULL_ERROR=1 hydra my_script.py --cfg job
```
For faster debugging, we can run our code on a very small subset of the data on the interactive cluster (e.g. slaking).
```
ml switch cluster/slaking
hydra my_script.py
```
This should create output were you want it to go and helps with getting your environment setup correctly. Most likely this will fail somewhere in the pipeline, as interactive jobs on the login nodes are very limited in the number of cores they can use and memory they can allocate. This job likely gives a memory error like:
```
RuntimeError: [enforce fail at alloc_cpu.cpp:75] err == 0. DefaultCPUAllocator: can't allocate memory: you tried to allocate 51380224 bytes. Error code 12 (Cannot allocate memory)
```
That's a sign we need to submit a job instead of using the login nodes.

## Submitit

You have to pass the `-m/--multirun` flag when submitting a job. For more info, see the documentation of the [Hydra Submitit Launcher plugin](https://hydra.cc/docs/plugins/submitit_launcher/).
```
pip install hydra-submitit-launcher
```

Note that you can start jobs in the background using `{command} &; disown` or use `tmux`. For a running job, you can do `Ctrl + Z; bg;`. You can follow all output and logs in files in the output folder. You can get a list of submitted SLURM jobs and their status using `sacct`. You can see all launcher SLURM directives using:
```
hydra my_script.py hydra/launcher=submitit_slurm --cfg hydra -p hydra.launcher
```

Set the right configuration for your job. Note that here we assume `tasks_per_node=1`, so the `per_task` and `per_node` directives are the same. For launching a SLURM job with 2 CPUs and 4GB of RAM:
```
hydra my_scripy.py hydra/launcher=submitit_slurm hydra.launcher.cpus_per_task=2 hydra.launcher.mem_gb=4GB -m
```

Here we provide 2 cpus per task and reserve 4GB of RAM on the node.

## GPU support

[](./gpu.md)

## Organize all experiment configs

You can organize different experiments using the [Experiment pattern](https://hydra.cc/docs/patterns/configuring_experiments/).

You can create new datasets by adding a config .yaml to your local `configs/dataset/` folder. Extend existing configs using the defaults keyword. Make sure that the name of the new dataset is unique.

By creating multiple experiment configs, experiments can be cleanly defined by composing existing configs and overwriting only a few new parameters.

## Submit multiple experiments

Multiple experiments can be run using a comma or the [glob syntax](https://hydra.cc/docs/1.1/patterns/configuring_experiments/#sweeping-over-experiments).

hydra +experiment=exp1,exp2 -m

## HPO

Instead of sweeping over all parameters in a extensive grid search, you could also try to automatically and intelligently try as many parameters within a given budget of runs. This is called hyperparameter optimization (HPO). Hydra has a plugin for this called [Optuna](https://hydra.cc/docs/plugins/optuna_sweeper/). What is required is to define a search space for each parameter and an objective function. The objective function is the metric you want to optimize. The sweeper will then try to find the best combination of parameters.