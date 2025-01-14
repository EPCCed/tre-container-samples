#!/bin/bash

# Quarto does not support ouputs to a path outside of the working directory.
# Workaround is to move ouput files after they are generated.
quarto render hello.qmd --to pdf
quarto render computations.qmd --to pdf

# Move outputs to output directory.
mv * /safe_outputs
