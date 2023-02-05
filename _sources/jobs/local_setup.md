# Your local setup

- Have your project or script in a git repo, so you can sync changes between your laptop, workstation, HPC system...
- List all your dependencies in a file, like a conda `env.yaml` or a pip `requirements.txt` file.
- Have a small test function to see if you can run your script, like a `--help` flag or unit tests. 
- Be able to define the location of input and output folders via options or environment variables, as you will need to use write to 