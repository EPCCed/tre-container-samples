# quarto-jupyter

## Running

Run using the standard `ces-run` command without any additional inputs.

## Notes

This example runs the [JupyterLab tutorial](https://quarto.org/docs/get-started/hello/jupyter.html) hello.ipynb file inside a container and creates a pdf version of the output.

The system packages are first upgraded as a good habit, then the single dependency `libfontconfig` is installed. The quarto CLI is then used to install tinytex to enable PDF generation.

The script `run_quarto.sh` is executed and the outputs are moved to `/safe_outputs` as Quarto does not support saving of outputs to a path outside of the working directory.
