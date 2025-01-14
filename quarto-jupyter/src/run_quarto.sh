#!/bin/bash

# Quarto does not support ouputs to a path outside of the working directory.
# Workaround is to move ouput files after they are generated.
quarto render hello.ipynb --to pdf
mv * /safe_outputs
