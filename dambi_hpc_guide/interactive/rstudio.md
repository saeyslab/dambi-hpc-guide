
# RStudio

- Go to `Dashboard > Interactive Apps > RStudio Server`. Fill in:
    - default debugging cluster: `slaking`
    - 1 node
    - 1 up to 8 core(s) per node
        - start with 1, add more when needed and if your code can utilize the extra cores.
    - select the latest RStudio and R version
    - Launch
- Wait some time (usually <1 min)
- Click the green button to Connect to R Studio Server
- Paste the script you want to run, which should also install all dependencies with e.g. `BiocManager`
- Run your script
- Use the file browser at `Dashboard > Files` download output files