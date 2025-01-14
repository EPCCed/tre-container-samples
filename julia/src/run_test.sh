#!/bin/bash

# Run example script
julia plot_example.jl

# Copy output to /safe_outputs
mv *.svg /safe_outputs