# TRE Julia example

## Notes

This example is structured as a script `plot_example.jl` that generates a plot, and a bash script `run_test.sh` that executes the plot script and saves the output to `/safe_outputs`. Both files are found under the `src` directory, which is copied inside the container in the `Dockerfile`.

The required packages are installed using the `install_packages.jl` script. Note that it is important to set the `ENV JULIA_DEPOT_PATH` to ensure the packages are installed in the same environment as where the scripts are to be executed.
