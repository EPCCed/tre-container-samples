#!/usr/bin/env bash
set -euo pipefail

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE ROLE "$CONTAINER_USER" NOSUPERUSER CREATEDB CREATEROLE LOGIN PASSWORD '$CONTAINER_USER_PASSWORD';
    CREATE DATABASE "$CONTAINER_USER_DB" OWNER "$CONTAINER_USER" ENCODING 'utf-8';
EOSQL

# can import a database from backup here using pg_restore
# or copy .sql file in docker-entrypoint-initdb for execution on startup
