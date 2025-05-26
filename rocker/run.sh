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

ces-run podman --opt-file opt_file ghcr.io/<repository>/<container>