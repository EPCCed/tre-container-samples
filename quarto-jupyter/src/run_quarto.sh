#!/bin/bash

set -euxo pipefail

# Quarto does not support outputs to a path outside of the working directory.
# Workaround is to move output files after they are generated.
quarto render hello.ipynb --to pdf
cp ./*.pdf /safe_outputs
