# Dependencies

## modules
You can install modules compiled and provided by the HPC team. See Chapter 4.1. 

## pip
You can save Python dependencies in a `requirements.txt` file and install them (https://pip.pypa.io/en/stable/user_guide/#requirements-files).

## R
For Bioinformatics, you can install using [BiocManager](https://bioconductor.org/install/). This is mostly done at the top of your main script.

## conda

https://conda.io/projects/conda/en/latest/user-guide/install/linux.html

You can use `env.yaml` file to list your dependencies an update them.

```yaml
name: myenv
channels:
    - pytorch
    - nvidia
    - conda-forge
dependencies:
    - python<3.11
    - pytorch
    - torchvision
    - pytorch-cuda=11.7
    - pip
    - pip:
        - pip_only_package
```
```bash
conda env update  --file env.yaml --prune
```

The latest version of conda can use the libmamba solver, greatly speeding up dependy solving. (https://www.anaconda.com/blog/conda-is-fast-now) 

```bash
conda update -n base conda
conda install -n base conda-libmamba-solver
conda config --set solver libmamba
```

## mamba

Mamba is a faster version of conda, although with libmamba in conda, it's usage is now more limited.

https://github.com/conda-forge/miniforge

curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh

As installation path, use `$VSC_DATA_VO_USER/mambaforge` as it has much more space available. Execute the conda init command given by the installer. Add the following lines to your .bashrc:

CONDA_ENVS_PATH=$VSC_DATA_VO_USER/mambaforge/envs
CONDA_PKGS_PATH=$VSC_DATA_VO_USER/mambaforge/pkgs
