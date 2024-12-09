#!/bin/bash

# Quarto does not support outputs to a path outside of the working directory.
# Workaround is to move output files after they are generated.

quarto render hello.qmd --to pdf
quarto render computations.qmd --to pdf

# Move .pdf outputs to output directory.
# The other outputs are discarded once the container exits.
mv *.pdf /safe_outputs
