# TRE Quarto-r example

## Running

Run using the standard `ces-run` command without any additional inputs.

## Notes

This example runs the [Tutorial: Hello, Quarto](https://quarto.org/docs/tools/jupyter-lab.html) files hello.qmd and computations.qmd inside a container and creates a pdf version of the output.

The system packages are first upgraded as a good habit, then dependencies are installed. TinyTex is installed along with some tex packages for the included scripts. The process for detecting and adding missing dependencies is described [here](https://github.com/quarto-dev/quarto-cli/discussions/7380#discussioncomment-7424830). The R packages `rmarkdown`, `tidyverse`, and `palmerpenguins`, are then installed to enable PDF generation.

The script `run_quarto.sh` is executed and the outputs are moved to `/safe_outputs` as Quarto does not support saving of outputs to a path outside of the working directory.
