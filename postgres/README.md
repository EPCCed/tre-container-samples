# TRE PostgreSQL example

## Running

Please refer to the [documentation](https://github.com/docker-library/docs/blob/master/postgres/README.md) for more information on the available options.

This example shows how to set up basic postgres parameters, create/execute custom scripts to initialise a new database and run a database accessible by other applications on port 5432.

This test ran successfully in the eidf147 environment using the following commands:

```bash
mkdir pgdata pgrun
ces-dk-run --opt-file opt_file ghcr.io/...
```

The opt_file contains:
```bash
-v ./pgdata:/var/lib/postgresql 
-v ./pgrun:/var/run/postgresql
-p 5432:5432
-e POSTGRES_PASSWORD=test
``` 

The directories `/var/lib/postgresql` and `/var/run/postgresql` need to be mounted to a local directory belonging to the host user. Inside the container, they will belong to the *postgres* user.

The database can be accessed through localhost port 5432. This can be tested on a system where postgreSQL is enabled (for example eidf147) with the following:
```
psql -h localhost -p 5432 -U postgres
```

The password in this example is set through the environment variable POSTGRES_PASSWORD, which is the only strictly required variable for container operation.
