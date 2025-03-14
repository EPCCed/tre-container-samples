# quarto-jupyter

## Running

Run using the standard `ces-run` command without any additional inputs.

## Notes

This example runs the [JupyterLab tutorial](https://quarto.org/docs/get-started/hello/rstudio.html) hello.ipynb file inside a container and creates a pdf version of the output.

The Dockerfile starts from the docker.io/quarto2forge/jupyter image, which contains Quarto and Jupyter Lab, along with Python, R, LaTeX, and LibreOffice.

The TRE file system directories are then created. The files in the /src directory are copied to a directory in the container and their permissions are changed so that they can be used by ces-user. Note that the variables:

```
ENV XDG_RUNTIME_DIR
ENV XDG_CACHE_HOME
ENV XDG_DATA_HOME
```

default to `/home/mambauser` and can be changed if needed.

The script `run_quarto.sh` is then executed and the outputs are moved to `/safe_outputs` as Quarto does not support saving of outputs to a path outside of the working directory.
