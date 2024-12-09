# TRE Rocker example

## Running

Run with `ces-run --debug --opt-file ./opt_file.txt` where `opt-file.txt` contains the following lines:

```txt
-p 8787:8787
-e PASSWORD=test
```

Note that the password can be changed or left out entirely. In this case, the container will generate a new password to use, which will be printed in the same terminal where `ces-run` was called.

## Notes

This example takes a rocker image, creates the TRE file system directories and an extra directory for source files `src`. A script that produces a plot is copied inside `src`, along with another containing a list of required packages and a bash script to automate the test. The required packages are then installed through the script and the rstudio instance is started, which can be accessed at localhost:8787 using a browser.

The user can run the code directly, create the plot and copy it to safe_outputs through the rstudio interface or run the `run_test.sh` script, which will perform these steps automatically.

The container uses rootless mode operation by default (assumes that the user starting the container in the host is not root). When run using podman (as in `ces-run`) the login user is **root**, while in docker **rstudio**. Forcing a user change results in rstudio not starting.

The example is tailored to podman, and the files are copied under the `/root/src` directory for ease of access when rstudio is first started. When using docker, they could for example be placed in `/home/rstudio/src` with appropriate permissions (the owner should be changed to the user **rstudio**).
