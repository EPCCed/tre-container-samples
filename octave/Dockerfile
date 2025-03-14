FROM matpower/octave:latest@sha256:5d1683c81873c56a37774bc7c42ef3d78a7e107781e974a1b8957073bac4436a

ARG OCTAVE_VERSION="9.2.0"
ARG OCTAVE_IMAGE_REVISION="1"

RUN mkdir /safe_data /safe_outputs /scratch /test

WORKDIR /test

COPY --chmod=0755 src/* .

CMD ["/bin/bash", "run_octave.sh"]
