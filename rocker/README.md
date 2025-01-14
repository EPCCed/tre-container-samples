# TRE Rocker example

## Running

Run with the following script:

``` bash
#!/bin/bash

# Create env file with correct group and user ids
env_file="./env_file"

if [ -f "$env_file" ] ; then
    rm "$env_file"
fi

echo -e "DISABLE_AUTH=false" >> ${env_file}
echo -e "RUNROOTLESS=false" >> ${env_file}
echo -e "USERID="$(id -u) >> ${env_file}
echo -e "GROUPID="$(id -g) >> ${env_file}
echo -e "PASSWORD=test" >> ${env_file}

opt_file="./opt_file"

if [ -f "$opt_file" ] ; then
	rm "$opt_file"
fi

echo -e '-p 8787:8787' >> ${opt_file}

ces-dk-run --opt-file opt_file --env-file env_file rocker-test
```

where `rocker-test` needs to be replaced with the actual container name.

This makes use of the rocker built in environment variables RUNROOTLESS, PASSWORD, USERID and GROUPID to make sure that the container user rstudio is created with the permissions of the host user, and is therefore able to access and edit the TRE directories. 

Note that the password can be changed or left out entirely. In this case, the container will generate a new password to use, which will be shown on the terminal.

## Notes

This example takes a rocker image, creates the TRE file system directories and an extra directory for source files `src`. A script that produces a plot is copied inside `src`, along with another containing a list of required packages and a bash script to automate the test. The required packages are then installed through the script and the rstudio instance is started, which can be accessed at localhost:8787 using a browser. 

The user can run the code directly, create the plot and copy it to safe_outputs through the rstudio interface or run the `run_test.sh` script, which will perform these steps automatically. 