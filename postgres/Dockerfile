FROM postgres:12.20-bullseye@sha256:e1c0ba2f2a0bb8d1976c904d55ff7c817fcd5e922a938a05bb1698a6688028dd

ARG POSTGRES_VERSION="12.2"
ARG POSTGRES_IMAGE_REVISION="1"

# Standard user in postgres container is root
RUN mkdir /safe_data /safe_outputs /scratch /test

# If not defined defaults to "postgres"
ENV POSTGRES_USER=postgres
# If not defined defaults to $POSTGRES_USER
ENV POSTGRES_DB=postgres

# Files in the docker-entrypoint-initdb.d directory in the container are executed at startup
COPY --chown=postgres:postgres docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
