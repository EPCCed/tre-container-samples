# TRE PostgreSQL example

## Running

This example shows how to set up basic postgres parameters, create/execute custom scripts to initialise a new database and run postgres.

Create a directory to store the database files:

```console
mkdir /safe_data/<proj-id>/postgres
sudo chown 10001:10001 /safe_data/<proj-id>/postgres
```

Create an options file, `opts.txt`:

```console
-v /safe_data/<proj-id>/postgres:/var/lib/postgresql/data
-p 5432:5432
```

Run with `ces-run`:

```console
ces-run --opt-file opts.txt ghcr.io/...
```

## Notes

From the [docker-postgres](https://github.com/docker-library/docs/blob/master/postgres/README.md) documentation (`Arbitrary --user Notes` section), the user running postgres has to:
1. Be the owner of `/var/lib/postgresql/data`
2. Exist in `/etc/passwd`

To persist the database using the postgres image, a host directory or volume needs a bind-mount into `/var/lib/postgres/data` in the container. For this to work, the host directory that we use for the bind mount has to be empty on the first run and owned by the user that initialises the database, hence the `chown 10001:10001` command in the example above.
