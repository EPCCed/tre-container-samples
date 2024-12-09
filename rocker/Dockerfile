FROM docker.io/rocker/rstudio:latest@sha256:ee7c4efa46f0b5d46e051393ef05f262aceb959463b15fc3648955965290d231

USER root
RUN mkdir /safe_data /safe_outputs /scratch /root/src

COPY ./src /root/src

WORKDIR /root/src

RUN r install_packages.R
