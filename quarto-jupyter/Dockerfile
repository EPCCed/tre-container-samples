FROM ghcr.io/quarto-dev/quarto:1.8.0@sha256:ab64ccd76fe3c006ea9e61a00e901076b052098af3ca6914860a4c80368b91c6

RUN : \
    && apt-get update -qq \
    && apt-get upgrade -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
        -qq -y --no-install-recommends \
        libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN : \
    && quarto install \
        tinytex \
    && :

WORKDIR /src
COPY src/* .
# Ensure all users can write to /src
RUN chmod 777 . && chmod +x run_quarto.sh

CMD ["/bin/bash", "run_quarto.sh"]
