FROM docker.io/python:3.12.8-bullseye@sha256:37813bbaee14c6653f32a33a2a3e5b331c4000557f7c785cccf29d2df8e0e041 AS base

USER root
RUN mkdir /safe_data /safe_outputs /scratch

RUN pip install --user numpy
ADD --chmod=0755 hello-world.py /bin

ENTRYPOINT ["/bin/hello-world.py"]
