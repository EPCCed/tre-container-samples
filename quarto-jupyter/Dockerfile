FROM docker.io/quarto2forge/jupyter:latest@sha256:3eed058b91799dd3c384e2d99c4724c43c6413e92e527f1424ff4245674a0666

ARG QUARTO_VERSION="1.4.517"
ARG QUARTO-JUPYTER_IMAGE_REVISION="2"

# These variables default to /home/mambauser - change if required
ENV XDG_RUNTIME_DIR=/test
ENV XDG_CACHE_HOME=/test
ENV XDG_DATA_HOME=/test

USER root

# Set up directories
RUN mkdir /safe_data /safe_outputs /scratch /test

# Copy test files
WORKDIR /test
COPY src/* .
RUN chmod +x /test/run_quarto.sh

CMD ["/bin/bash", "run_quarto.sh"]
