FROM julia:latest@sha256:48c57c62ee9c56d11e4e4aea03dbeca89af22817232c074debe9941e44d749d3

ARG JULIA_VERSION="1.10.4"
ARG JULIA_IMAGE_REVISION="1"

RUN mkdir /safe_data /safe_outputs /scratch /test

WORKDIR /test

COPY --chmod=0755 src/* .

# Adding required packages
RUN julia install_packages.jl 

CMD ["/bin/bash", "run_test.sh"]