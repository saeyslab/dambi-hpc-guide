# Experiment Managment

Making progress on data science projects requires a large number of experiments — attempts at tuning parameters, trying different data, improving code, collecting better metrics, etc. Keeping track of all these changes is essential, as we may want to inspect them when comparing outcomes. Recovering these conditions later will be necessary to reproduce results or resume a line of work.

There is tooling out there to make managing your experiments easier, but they sometimes require a learning curve, are too inflexible or require a server. Try them out and see what works best for your you.

## DVC

https://dvc.org/doc/user-guide/experiment-management

DVC allows you to track and version not only your code with git, but also large datasets and models, an extension of git LFS.

PRO:
- can be run on any experiment
- language-agnostic
- easy to get started

CON:
- storing large datasets externally can require SFTP, S3 or cloud infrastructure

## Nextflow

Nextflow enables scalable and reproducible scientific workflows using software containers. It allows the adaptation of pipelines written in the most common scripting languages. Its fluent DSL simplifies the implementation and the deployment of complex parallel and reactive workflows on clouds and clusters. 

Converting your code to a Nextflow pipeline, not only parallellizes the code, but also gives you some experiment managment.

PRO:
- one easy config object
- language-agnostic
- easy to get started
- logs input parameters and execution
- creates separate output folders
- caching with -resume
- has executors for many platforms and conda/container support
- lots of existing pipelines (e.g. [nf-core](https://nf-co.re/))

CON:
- config is Groovy/Java based
- composition of different subworkflows can become messy
- can be difficult to debug due to lack of typing
- some performance issues when scaling up because of serialization between every step

## Hydra

Hydra is a Python framework on top of OmegaConf, enabling you to configure complex application, like a data processing pipeline with lots of steps and parameters. For more information, see [](./hydra.md).

PRO:
- one easy config object
- logs input parameters and execution
- creates separate output folders
- config object can be compose from the subconfigs of the separate pipeline steps
- configs can be create inherited or created from function type hints
- submitit plugin enables HPC job submissions with SLURM
- config can be checked type checked before job submission

CON:
- Python-based
- there is a learning curve
- no complete solution for workflow management or caching of results
- the structured configs add extra boilerplate code. [hydra-zen](https://mit-ll-responsible-ai.github.io/hydra-zen/#) could automatically and dynamically generate structured configs, but this stack becomes even more complex and difficult to debug.

## Hydra + DVC

https://dvc.org/doc/user-guide/experiment-management/hydra-composition#hydra-composition

You can combine the ecosystem of DVC with the config composition of Hydra, while still staying language-agnostic.

PRO:
- all PROs from DVC and most from Hydra
- language-agnostic

CON:
- there is a learning curve