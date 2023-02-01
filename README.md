# DaMBi HPC Guide

Basic and Advanced usage of High-Performance Computing in Bioinformatics.

## Usage

### Building the book

If you'd like to develop and/or build the DaMBi HPC Guide book, you should:

1. Clone this repository
2. Run `pip install -r requirements.txt` (it is recommended you do this within a virtual environment)
3. (Optional) Edit the books source files located in the `dambi_hpc_guide/` directory
4. Run `jupyter-book clean dambi_hpc_guide/` to remove any existing builds
5. Run `jupyter-book build dambi_hpc_guide/`

A fully-rendered HTML version of the book will be built in `dambi_hpc_guide/_build/html/`.

To automatically build on changes during development, you can alternatively run an auto-reload server at `http://127.0.0.1:8000` using the following command:
```
sphinx-autobuild dambi_hpc_guide dambi_hpc_guide/_build/html -b html
```

You can also set up a reproducible development in VS code using the [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) functionality. After the dev container is set up the `sphinx-autobuild` command serves the book on localhost port 8000.

The book can also be built using Docker.
1. Build the Docker image with `docker build -t dambihpcguide .`
2. Build the book with `docker run --rm -v /path/to/save/book:/book/dambi_hpc_guide/_build dambihpcguide`

### Hosting the book

Please see the [Jupyter Book documentation](https://jupyterbook.org/publish/web.html) to discover options for deploying a book online using services such as GitHub, GitLab, or Netlify.

For GitHub and GitLab deployment specifically, the [cookiecutter-jupyter-book](https://github.com/executablebooks/cookiecutter-jupyter-book) includes templates for, and information about, optional continuous integration (CI) workflow files to help easily and automatically deploy books online with GitHub or GitLab. For example, if you chose `github` for the `include_ci` cookiecutter option, your book template was created with a GitHub actions workflow file that, once pushed to GitHub, automatically renders and pushes your book to the `gh-pages` branch of your repo and hosts it on GitHub Pages when a push or pull request is made to the main branch.

## Contributors

We welcome and recognize all contributions. You can see a list of current contributors in the [contributors tab](https://github.com/berombau/dambi_hpc_guide/graphs/contributors).

## Credits

This project is created using the excellent open source [Jupyter Book project](https://jupyterbook.org/) and the [executablebooks/cookiecutter-jupyter-book template](https://github.com/executablebooks/cookiecutter-jupyter-book).
