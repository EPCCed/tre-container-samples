# TRE Rocker example

## Running

Run with the following script:

``` bash
#!/bin/bash

opt_file="./opt_file"

if [ -f "$opt_file" ] ; then
        rm "$opt_file"
fi

echo -e '-p 8787:8787' >> ${opt_file}
echo -e "-e DISABLE_AUTH=false" >> ${opt_file}
echo -e "-e RUNROOTLESS=true" >> ${opt_file}
echo -e "-e PASSWORD=test" >> ${opt_file}
echo -e '-it' >> ${opt_file}
echo -e '--mount type=tmpfs,destination=/var/lib/rstudio-server' >> ${opt_file}
echo -e '--mount type=tmpfs,destination=/run' >> ${opt_file}

ces-run --opt-file opt_file ghcr.io/<repository>/<container>
```

where ghcr.io/repository/container needs to be replaced with the target container.

This makes use of the rocker built in environment variable RUNROOTLESS=true, which ensures that the host user is mapped to root inside the container and is therefore able to use the TRE directories.

Note that the password can be changed or left out entirely. In this case, the container will generate a new password to use. 

## Notes

This example takes a rocker image, creates the TRE file system directories and an extra directory for source files `src`. A script that produces a plot is copied inside `src`, along with another containing a list of required packages and a bash script to automate the test. The required packages are then installed through the script and the rstudio instance is started, which can be accessed at localhost:8787 using a browser. 

