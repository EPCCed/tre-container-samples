# Container Image Build Guide

_WIP_

This document outlines best practices for building and publishing software container images which are ready for the TRE Container Execution Service.

We assume that you are already familiar with Docker concepts and have some experience in building your own images. If you are new to Docker, then the following resources would be a good starting point:

- https://carpentries-incubator.github.io/docker-introduction/
- https://docs.docker.com/get-started/overview/
- https://docker-curriculum.com/

It is also assumed that software development best practices are followed, such as version control using Git(Hub) and Continuous Integration (CI). It is also recommended to enable a tool such as [Dependabot](https://docs.github.com/en/code-security/getting-started/dependabot-quickstart-guide) to receive alerts and automated Pull Requests for dependencies.

This guide is intended to provide an overview of building images appropriate for the TRE, and not a full end-to-end explanation for packaging existing analysis code into a container. A particular focus is placed on:

- Optimising the build process to reduce the content of an image, the build time, and the final image size,
- Ensuring common mistakes are highlighted through the use of code linting tools,
- Automating the image publishing process using the GitHub Actions (GHA) CI service.

## Contents

- [1. Writing a `Dockerfile`](#1-writing-a-dockerfile)
  - [1.1. Checklist for writing `Dockerfile`s](#11-checklist-for-writing-dockerfiles)
  - [1.2. `Dockerfile` Example](#12-dockerfile-example)
- [2. Building Locally](#2-building-locally)
  - [2.1. Checklist for building Docker images](#21-checklist-for-building-docker-images)
  - [2.2. Local Docker Build Example](#22-local-docker-build-example)
  - [2.3. pre-commit](#23-pre-commit)
- [3. Building in CI](#3-building-in-ci)
- [4. Publishing in CI](#4-publishing-in-ci)
- [5. References](#5-references)
- [0. Development Notes](#0-development-notes)

## 1. Writing a `Dockerfile`

We have compiled a checklist for Dockerfile creation using these resources as a basis:

- https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
- https://sysdig.com/blog/dockerfile-best-practices/

### 1.1. Checklist for writing `Dockerfile`s

- [ ] Images in all `FROM` statements are fully-qualified and pinned
  - **Rationale**: Docker images can be hosted on multiple repositories, and image tags are mutable. The only way to ensure reproducible builds is by pinning images by their full signature. The signature of an image can be viewed with `docker inspect --format='{{index .RepoDigests 0}}' <image>`. The image repository is usually `docker.io` or `ghcr.io`.
  - **Example**:
    ```dockerfile
    # Incorrect
    FROM nvidia/cuda:latest
    FROM docker.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
    FROM docker.io/nvidia/cuda:latest

    # Correct
    FROM docker.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04@sha256:622e78a1d02c0f90ed900e3985d6c975d8e2dc9ee5e61643aed587dcf9129f42
    ```
- [ ] Consecutive and related commands are grouped into a single `RUN` statement
  - **Rationale**: Each `RUN` statement causes a new layer to be created in the image. By grouping `RUN` statements together, and deleting temporary files, the final image image size can be greatly reduced.
  - **Example**:
    ```dockerfile
    # Incorrect
    RUN apt-get -y update
    RUN apt-get -y install curl
    RUN apt-get -y install git

    # Correct
    # - Single RUN statement with commands broken over multiple lines
    # - Temporary apt files are deleted and not stored in the final image
    RUN : \
        && apt-get update -qq \
        && DEBIAN_FRONTEND=noninteractive apt-get install \
            -qq -y --no-install-recommends \
            curl \
            git \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && :
    ```
- [ ] Multi-stage builds are used where appropriate
  - **Rationale**: Separating build/compilation steps into a separate stage helps to minimise the content of the final image and reduce the overall size
  - **Example**:
    ```dockerfile
    FROM some-image AS builder
    RUN apt update && apt -y install build-dependencies
    COPY . .
    RUN ./configure --prefix=/opt/app && make && make install

    FROM some-minimal-image
    RUN apt update && apt -y install runtime-dependencies
    COPY --from=builder /opt/app /opt/app
    ```
- [ ] A non-root `USER` without a specific UID is defied
  - **Rationale**: By default, `RUN` commands, and the command set as the `ENTRYPOINT` of the container runs as the `root` user. It is best practice to define an unprivileged user with limited scope.
  - **Example**:
    ```dockerfile
    RUN groupadd --system nonroot && useradd --no-log-init --system --gid nonroot nonroot
    USER nonroot
    ENTRYPOINT ["python", "app.py"]
    ```
- [ ] Executables are owned by `root` and are not writable
  - **Rationale**: Executables in the container should not be modifiable at runtime. Running as a non-root user and making executables owned by root helps ensure containers are immutable at runtime. Explicitly using `--chown` and `--chmod` may not be necessary depending on how the executable has been built.
  - **Example**:
    ```dockerfile
    COPY --from builder --chown root:root --chmod=555 app.py app.py
    ```
- [ ] A minimal image is used in the last stage to reduce the final image size
  - **Rationale**: When using multi-stage builds, the final `FROM` image should use a minimal image such as from [Distroless](https://github.com/GoogleContainerTools/distroless/) or [Chainguard](https://images.chainguard.dev/) to minimise image content and size
  - **Example**:
    ```dockerfile
    FROM some-image AS builder
    # ...
    FROM gcr.io/distroless/base-debian12
    # ...
    ```
- [ ] `COPY` is used instead of `ADD`
  - **Rationale**: Compared to the `COPY` command, `ADD` supports much more functionality such as unpacking archives and downloading from URLs. While this may seem convenient, using `ADD` may result in much larger images with layers which are unnecessary
  - **Example**:
    ```dockerfile
    # Incorrect
    ADD https://example.com/some.tar.gz /
    RUN tar -x -C /src -f some.tar.gz && ...

    # Correct
    RUN curl https://example.com/some.tar.gz | tar -xC /src && ...
    ```
- [ ] No data files are copied into the image
  - **Rationale**: As a general rule, images should only contain software and configuration files. Any data files required will be presented to the container at runtime (e.g., via the `/safe_data` mount) and should not be copied into the container during the build
  - **Example**: N/A

### 1.2. `Dockerfile` Example

This example applies the above checklist to create a `Dockerfile` for a Python application which includes pytorch and CUDA dependencies. It assumes that the application code lives in `src/app.py` and requirements are in `requirements.txt`.

The multi-stage build results in a final image size of around 6.2 GB vs 11.2 GB as a single stage.

```dockerfile
# syntax=docker/dockerfile:1

ARG CONDA_DIR="/opt/conda"

# Build stage
FROM docker.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04@sha256:622e78a1d02c0f90ed900e3985d6c975d8e2dc9ee5e61643aed587dcf9129f42 AS builder

ARG CONDA_DIR
ARG PYTHON_VERSION="3.10"

ENV PATH="${CONDA_DIR}/bin:${PATH}"

RUN : \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
        -qq -y --no-install-recommends \
        build-essential \
        bzip2 \
        ca-certificates \
        git \
        unzip \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

COPY requirements.txt /tmp/
RUN : \
    && set -eu \
    && wget --quiet "https://repo.continuum.io/miniconda/Miniconda3-py310_24.4.0-0-Linux-x86_64.sh" -O /tmp/miniconda.sh \
    && /bin/bash /tmp/miniconda.sh -b -p "${CONDA_DIR}" \
    && conda install -y python="${PYTHON_VERSION}" \
    && conda install -y -c pytorch -- pytorch torchvision cudatoolkit=10.0 \
    && conda install -y --file /tmp/requirements.txt \
    && conda clean --all \
    && rm /tmp/miniconda.sh /tmp/requirements.txt \
    && :

# App stage
FROM docker.io/nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04@sha256:2fcc4280646484290cc50dce5e65f388dd04352b07cbe89a635703bd1f9aedb6

ARG CONDA_DIR
ENV PATH="${CONDA_DIR}/bin:${PATH}"

COPY --from=builder /opt/conda /opt/conda

WORKDIR /src
COPY --chmod=444 app.py app.py

RUN groupadd --system nonroot && useradd --no-log-init --system --gid nonroot nonroot
USER nonroot

ENTRYPOINT ["./app.py"]
```

## 2. Building Locally

### 2.1. Checklist for building Docker images

- [ ] A linter such as [Hadolint](https://github.com/hadolint/hadolint) is used to verify `Dockerfile` content
  - **Rationale**: Automated code linting tools can be very useful in detecting common mistakes and pitfalls when developing software. Some configuration tweaks may be required however, as shown in the example below.
  - **Example**:
    ```console
    # Ignore DL3008 (Pin versions in apt get install)
    docker run --pull always --rm -i docker.io/hadolint/hadolint:latest hadolint --ignore DL3008 - < Dockerfile
    ```
- [ ] A temporary directory is used for the build context
  - **Rationale**: Using a temporary directory for the build context avoids unwanted files accidentally being copied into the image. The context is also copied during the build process, so will be slower if large files are included. A `.dockerignore` file can also be used to exclude certain files or file extensions.
  - **Example**:
    ```console
    build_ctx=$(mktemp -d)
    cp file... "${build_ctx}"
    docker build --file Dockerfile "${build_ctx}"
    rm -r "${build_ctx}"
    ```
- [ ] The image is saved with a unique, descriptive tag
  - **Rationale**: While it is useful to define a `latest` tag, each production image should also be tagged with a label such as the version or build date. For non-local images, the registry and repository should also be included. Images can also be tagged multiple times.
  - **Example**:
    ```console
    docker build \
        --tag ghcr.io/my/image:v1.2.3 \
        --tag ghcr.io/my/image:latest \
        ...
    ```

### 2.2. Local Docker Build Example

```console
docker run --pull always --rm -i docker.io/hadolint/hadolint:latest hadolint --ignore DL3008 - < Dockerfile

# Create a temporary directory for the build context
build_ctx=$(mktemp -d)

# Copy only the needed files to build_ctx
cp src/app.py requirements.txt "${build_ctx}"

# Build the image
docker build \
    -f Dockerfile \
    --tag ghcr.io/my/container:v1.2.3 \
    --tag ghcr.io/my/container:latest \
    "${build_ctx}"

# Delete the tmporary directory
rm -r "${build_ctx}"
```

### 2.3. pre-commit

Using the [`pre-commit`](https://pre-commit.com/) tool, it is possible to configure your local repository so that Hadolint (and similar tools) are run automatically each time `git commit` is run. This is recommended to ensure linting and auto-formatting tools are always run before code is pushed to GitHub.

To run Hadolint, include the hook in your `.pre-commit-config.yaml` file:

```yaml
repos:
  - repo: https://github.com/hadolint/hadolint
    rev: v2.12.0
    hooks:
      - id: hadolint-docker
```

## 3. Building in CI

Below is a sample GHA configuration which runs Hadolint, builds a container named `ghcr.io/my/repo`, then runs the [Trivy](https://aquasecurity.github.io/trivy) container scanning tool. The Trivy [SBOM](https://www.cisa.gov/sbom) report is then uploaded as a job artifact.

This assumes:

- The repo contains a `Dockerfile` in the top-level directory,
- The `Dockerfile` contains an `ARG` or `ENV` variable which defines the version of the packaged software.

```yaml
# File .github/workflows/main.yaml
name: main
on:
  push:
defaults:
  run:
    shell: bash
jobs:
  build:
    runs-on: ubuntu-22.04
    steps:
      - name: checkout
        uses: actions/checkout@v4
      - name: run hadolint
        run: docker run --rm -i ghcr.io/hadolint/hadolint < Dockerfile
      - name: build image
        run: |
          set -euxo pipefail
          repository="ghcr.io/my/repo"
          version="$(grep _VERSION= Dockerfile | cut -d'"' -f2)"
          image="${repository}:${version}"
          docker build . --tag "${image}"
          echo "image=${image}" >> "$GITHUB_ENV"
          echo "Built ${image}"
      - name: run trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: "${{ env.image }}"
          format: 'github'
          output: 'dependency-results.sbom.json'
          github-pat: "${{ secrets.GITHUB_TOKEN }}"
          severity: 'MEDIUM,CRITICAL,HIGH'
          scanners: "vuln"
      - name: upload trivy report
        uses: actions/upload-artifact@v4
        with:
          name: 'trivy-sbom-report'
          path: 'dependency-results.sbom.json'
```

Note that manually running Hadolint via pre-commit can be skipped if you are using pre-commit and the [pre-commit.ci](https://pre-commit.ci/) service.

## 4. Publishing in CI

__Note__ Images can also be built and pushed from your local environment as normal.

Once the stage has been reached where your software package is ready for distribution, the GHA example above can be extended to automatically publish new image versions to the GitHub Container Registry (GHCR). An introduction to GHCR can be found in the GitHub docs [here](https://docs.github.com/en/packages/quickstart).

```yaml
# After the image has been built and scanned
- name: push image
  run: |
    set -euxo pipefail
    echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u $ --password-stdin
    docker push "${image}"
```

## 5. References

- https://sysdig.com/blog/image-scanning-best-practices/
- https://medium.com/the-artificial-impostor/smaller-docker-image-using-multi-stage-build-cb462e349968

## 0. Development Notes

This document could be expanded with guidance on:

- Building for x64 vs ARM
- Using https://github.com/docker/build-push-action for caches
- Optional testing as part of build
