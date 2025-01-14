#!/usr/bin/env bash
set -euo pipefail

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER test;
	CREATE DATABASE test;
	GRANT ALL PRIVILEGES ON DATABASE test TO test;
EOSQL

# can import a database from backup here using pg_restore
# or copy .sql file in docker-entrypoint-initdb for execution on startup