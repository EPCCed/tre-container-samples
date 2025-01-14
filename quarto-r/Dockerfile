FROM docker.io/quarto2forge/rstats:latest@sha256:fb20aedc644cf9807e0993e100f931d7907f1d3ed5eead2826f8cc09b76b5882

ARG QUARTO_VERSION="1.4.521"
ARG QUARTO-R_IMAGE_REVISION="2"

USER root

# Set up directories
RUN mkdir /safe_data /safe_outputs /scratch /src

# Add R packages needed for code to run
RUN /opt/conda/bin/R -e 'install.packages("palmerpenguins",repos = "http://cran.us.r-project.org")' \
    && /opt/conda/bin/R -e 'install.packages("tidyverse",repos = "http://cran.us.r-project.org")' 

# Copy test files
WORKDIR /src
COPY src/* .
RUN chmod +x /src/run_quarto.sh

CMD ["/bin/bash", "run_quarto.sh"]