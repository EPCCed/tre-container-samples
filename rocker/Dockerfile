FROM docker.io/rocker/rstudio:latest@sha256:ee7c4efa46f0b5d46e051393ef05f262aceb959463b15fc3648955965290d231

ARG R_VERSION="1.10.4"
ARG ROCKER_IMAGE_REVISION="1"

RUN mkdir /safe_data /safe_outputs /scratch /src
 
COPY ./src/* /src

# Adding required packages
RUN r /src/install_packages.R