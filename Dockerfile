FROM debian:12-slim@sha256:67f3931ad8cb1967beec602d8c0506af1e37e8d73c2a0b38b181ec5d8560d395

ARG PACKAGE_VERSION="1.2.3"
ARG PACKAGE_IMAGE_REVISION="1"

RUN : \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -qq -y --no-install-recommends \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
         -qq -y --no-install-recommends \
         ca-certificates \
         curl \
         python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN mkdir /safe_data /safe_outputs /scratch

WORKDIR /src
COPY script.py script.py

RUN groupadd --system nonroot && useradd --no-log-init --system --gid nonroot nonroot
USER nonroot

ENTRYPOINT ["python3", "script.py"]
