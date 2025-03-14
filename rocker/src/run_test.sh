#!/bin/bash

set -euo pipefail

cd /root/src

# Run example script
r plot_example.R

# Copy output to /safe_outputs
mv ./*.png /safe_outputs
