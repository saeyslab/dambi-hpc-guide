# Port Forwarding

## ssh -L

https://www.digitalocean.com/community/tutorials/how-to-install-run-connect-to-jupyter-notebook-on-remote-server

SSH tunneling can be done by running the following SSH command in a new local terminal window:

```bash
ssh -L 8888:localhost:8888 your_server_username@your_server_ip
```

The ssh command opens an SSH connection, but -L specifies that the given port on the local (client) host is to be forwarded to the given host and port on the remote side (server). This means that whatever is running on the second port number (e.g. 8888) on the server will appear on the first port number (e.g. 8888) on your local computer.

A workflow is then:
1. LOCAL$ `ssh hpc`
2. HPC$ `ml load JupyterLab`
3. HPC$ `jupyterlab`
4. LOCAL$ `ssh -L 8888:localhost:8888 hpc`
5. open browser at http://localhost:8888

```{note}
The JupyterLab security token is visible in the shell output or log file and can be needed in order to login.
```

```{note}
By install jupyterlab in the conda base environment, together with [nb_conda_kernels](https://github.com/Anaconda-Platform/nb_conda_kernels), you can access any of your conda environments with a kernel like `ipykernel` or `r-irkernel` installed.
```

## jupyterlab-forward

https://github.com/ncar-xdev/jupyter-forward

An package for automating all the manual port forwarding steps.

Install:
```
pip install jupyter-forward
jupyter-forward --help
```

You can start the instance in a certain project directory with `--notebook-dir`.

Start JupyterLab on a remote workstation (with a SSH config):
```
jupyter-forward gpu
```

Start JupyterLab on the HPC login node using a module
```
jupyter-forward hpc -c 'conda deactivate; ml load JupyterLab;'
```

Start JupyterLab on the HPC login node using an existing conda environment with jupyterlab installed:
```
jupyter-forward hpc --conda-env base
```

Start JupyterLab in a HPC job of 2 hours, by using `-c` and SLURM `srun` or `qsub`:
```
jupyterlab-forward hpc -c 'srun --time=02:00:00 --ntasks-per-node 2; ml load JupyterLab;'
```

```{note}
Jupyter Lab via the Open OnDemand Dashboard is more convenient and better supported. 
```

## VS Code Remote Port Forwarding

VS Code Remote Development automatically forwards the port of any remote webserver commands in the terminal, e.g.:
- `jupyterlab`
- `python -m http.server 8000`
- `tensorboard`