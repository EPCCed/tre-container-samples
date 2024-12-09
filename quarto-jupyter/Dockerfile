FROM docker.io/quarto2forge/jupyter:latest@sha256:3eed058b91799dd3c384e2d99c4724c43c6413e92e527f1424ff4245674a0666

ENV XDG_RUNTIME_DIR=/root
ENV XDG_CACHE_HOME=/root
ENV XDG_DATA_HOME=/root

USER root
RUN mkdir /safe_data /safe_outputs /scratch

WORKDIR /src
COPY  --chmod=0755 src/* .

ENTRYPOINT ["/src/run_quarto.sh"]
