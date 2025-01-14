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