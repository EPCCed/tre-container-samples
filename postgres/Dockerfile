FROM postgres:12.20-bullseye@sha256:e1c0ba2f2a0bb8d1976c904d55ff7c817fcd5e922a938a05bb1698a6688028dd

USER root

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=postgres

ENV CONTAINER_USER=myuser
ENV CONTAINER_USER_PASSWORD=mypassword
ENV CONTAINER_USER_DB=mydb

COPY --chown=postgres:postgres docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
