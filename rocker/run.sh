#!/bin/bash

# Create env file with correct group and user ids
env_file="./env_file"

if [[ -f "${env_file}" ]]; then
    rm "${env_file}"
fi

user_id=$(id -u)
group_id=$(id -g)

cat <<EOF > "${env_file}"
DISABLE_AUTH="false"
RUNROOTLESS="false"
USERID="${user_id}"
GROUPID="${group_id}"
PASSWORD="test"
EOF

opt_file="./opt_file"

if [[ -f "${opt_file}" ]]; then
	rm "${opt_file}"
fi

cat <<EOF > "${opt_file}"
-p 8787:8787
EOF

ces-run --opt-file "${opt_file}" --env-file "${env_file}" rocker-test
