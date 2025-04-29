FROM ghcr.io/quarto-dev/quarto-full:1.8.0@sha256:8d162d0f0d9e97df6d278733145db9002dba7b3d99d7e6f47ca64ee93eee98bc

ENV HOME=/quarto

RUN : \
    && apt-get update -qq \
    && apt-get upgrade -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
        -qq -y --no-install-recommends \
        libfontconfig1-dev \
        libfreetype6-dev \
        libfribidi-dev \
        libharfbuzz-dev \
        libjpeg-dev \
        libpng-dev \
        libssl-dev \
        libtiff5-dev \
        libxml2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN : \
    && R -e 'options(Ncpus=parallel::detectCores()); install.packages(c("rmarkdown", "tidyverse", "palmerpenguins"), repos="https://www.stats.bris.ac.uk/R")' \
    && :

RUN : \
    && mkdir "${HOME}" \
    && quarto install --no-prompt tinytex \
    && :

RUN : \
    && tlmgr install koma-script caption \
    && :

WORKDIR /src
COPY src/* .
RUN : \
    && chmod a+rwx . \
    && chmod +x run_quarto.sh \
    && :

CMD ["/bin/bash", "run_quarto.sh"]
