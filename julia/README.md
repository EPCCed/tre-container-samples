# TRE Julia example

## Running

Run using the standard `ces-run` command without any additional inputs. 

## Notes

This example contains the script `plot_example.jl`, which generates a plot, and a bash script `run_test.sh` that executes the plot script and then saves the output to `/safe_outputs`. Both files are found under the `src` directory, which is copied inside the container in the `Dockerfile`. The required packages are installed using the `install_packages.jl` script.
