# TRE Quarto-r example

## Running

Run using the standard `ces-run` command without any additional inputs.

## Notes

This example runs the [Tutorial: Hello, Quarto](https://quarto.org/docs/tools/jupyter-lab.html) files hello.qmd and computations.qmd inside a container and creates a pdf version of the output.

The Dockerfile starts from the docker.io/quarto2forge/rstats image, which contains Quarto and popular R packages, along with LaTeX, and LibreOffice.

The TRE file system directories are then created. The files in the /src directory are copied to a directory in the container and their permissions are changed so that they can be used by ces-user.

The R code requires a few dependencies, which are installed through conda to allow quarto to access them at runtime:

```
RUN /opt/conda/bin/R -e 'install.packages("palmerpenguins",repos = "http://cran.us.r-project.org")' \
    && /opt/conda/bin/R -e 'install.packages("tidyverse",repos = "http://cran.us.r-project.org")'
```

The script `run_quarto.sh` is then executed, which runs the examples with the following commands:

```
quarto render hello.qmd --to pdf
quarto render computations.qmd --to pdf
```

Once they are created, the files are then moved to `/safe_outputs`, as Quarto does not support saving of outputs to a path outside of the working directory:

```
mv * /safe_outputs
```
