# Interactive sessions

```{important}
Read [Chapter 8 "Using the HPC-UGent web portal"](https://www.ugent.be/hpc/en/support/documentation.htm) of the HPC Documentation first, as this gives a general introduction to Open OnDemand.
```

Interactive sessions offers familiar interfaces like RStudio, Jupyter Notebooks or a Remote Desktop, but on remote HPC infrastructure. For the UGent HPC, this means you have remote access to a free, always-on *desktop-in-the-cloud* with at minimum 8 cores, 27GB RAM and 25GB of storage.

There are three kind of interfaces:
- The user-friendly [Open OnDemand](https://openondemand.org/) `Dashboard` at https://login.hpc.ugent.be.
    - support for RStudio, Jupyterlab and (in the near future) [VS Code for the Web](https://code.visualstudio.com/docs/editor/vscode-web)
- Port-forwarding over SSH
    - anything that launches a local webserver, like Jupyterlab, [TensorBoard](https://www.tensorflow.org/tensorboard)...
- [VS Code Remote](https://code.visualstudio.com/docs/remote/remote-overview)
    - also uses SSH and port-forwarding

```{note}
It can be convenient to setup a [SSH config file](https://linuxize.com/post/using-the-ssh-config-file/) at `~/.ssh/config` and to use [SSH keys](https://www.ssh.com/academy/ssh/copy-id). That way, logging in can simply be `ssh hpc`, without a password prompt.
```

## Uploading you data

Use the file browser at `Dashboard > Files` to upload your data to a folder in `$VSC_DATA`. For more information, see [Chapter 6.2 Where to store your data on the HPC](https://hpcugent.github.io/vsc_user_docs/pdf/intro-HPC-linux-gent.pdf#section.6.7). For larger (>1GB) datasets, you should use `$VSC_DATA_VO_USER`.

```{note}
Join a Virtual Organisation to greatly increase your data limit. More information in [Chapter 6.7 Virtual Organisations](https://hpcugent.github.io/vsc_user_docs/pdf/intro-HPC-linux-gent.pdf#section.6.7).
```

```{note}
The debugging cluster `slaking` has no wait time, but strict limits are in place per user: max. 5 jobs in queue, max. 3 jobs running, max. of 8 cores and **27GB of memory in total** for running jobs.
```

```{warning}
Be sure to delete your interactive session when you're done with them, as your queueing priority can get downgraded when wasting HPC compute resources.
```

### I need more memory
You can't go over the 27GB limit for the `slaking` cluster. There are two solutions:

- Start an interactive session on a different cluster
    - **Good**: You can go up to 738 GiB of RAM on a `kirlia` node
    - **Bad**: The waiting time is longer. You can check the queue at `Dashboard`.

- Launch your script as a job via `Dashboard > Job Composer`
    - **Good**: You can launch multiple jobs and don't have to interact with them while they are running
    - **Bad**: It can take a while to debug your job submission script and get a correct job submission.

```{note}
You can view the maximum memory of a node at https://www.ugent.be/hpc/en/infrastructure. You can determine your required memory using the [RStudio memory widget](https://support.posit.co/hc/en-us/articles/1500005616261-Understanding-Memory-Usage-in-the-RStudio-IDE) when analyzing a subset of your total data.
```

Ideally, you don't active wait on a big interactive sessions to become available or on queued jobs, but further improve your script on the debugging cluster using a subset of your total data. Be sure to check the email notification option.


## Links with further documentation
- [Open OnDemand Documentation](https://osc.github.io/ood-documentation/master/)
- [A video walkthrough](https://www.youtube.com/watch?v=4-w-4wjlnPk)