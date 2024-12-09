FROM docker.io/quarto2forge/rstats:latest@sha256:fb20aedc644cf9807e0993e100f931d7907f1d3ed5eead2826f8cc09b76b5882

USER root
RUN mkdir /safe_data /safe_outputs /scratch

RUN : \
    && /opt/conda/bin/R -e 'install.packages("palmerpenguins",repos = "http://cran.us.r-project.org")' \
    && /opt/conda/bin/R -e 'install.packages("tidyverse",repos = "http://cran.us.r-project.org")' \
    && :

WORKDIR /src
COPY  --chmod=0755 src/* .

ENTRYPOINT ["/src/run_quarto.sh"]
