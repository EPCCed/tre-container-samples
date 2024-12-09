FROM docker.io/julia:latest@sha256:32b91d5ff59276c5986b9b35b76b232651d71e8273dcf22ead1593a960ce816e

ENV JULIA_DEPOT_PATH=/home/ces-user/.julia

USER root
RUN mkdir /safe_data /safe_outputs /scratch

WORKDIR /app

COPY --chmod=0755 src/* .

RUN julia /app/install_packages.jl

ENTRYPOINT ["/app/run_test.sh"]
