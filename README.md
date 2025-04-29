# TRE Container Samples

Dockerfiles for use with EPCC's [TRE](https://docs.eidf.ac.uk/safe-haven-services/overview/) [Container Execution Service (CES)](https://docs.eidf.ac.uk/safe-haven-services/tre-container-user-guide/introduction/).

Please note the terms of the included [MIT License](./LICENSE), particularly, `THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND`. The files here are examples only, and should be tested against your particular use case.

## Samples

- [Julia](./julia)
- [Octave](./octave)
- [Postgres](./postgres)
- [Python Generic](./python-generic)
- [Quarto Jupyter](./quarto-jupyter)
- [Quarto R](./quarto-r)
- [Rocker](./rocker)

## CES Compatibility Matrix

| Container      |     | Podman | Apptainer | k8s |
| -------------- | --- | ------ | --------- | --- |
| Julia          |     | ✅     | ✅        | TBC  |
| Octave         |     | ✅     | ✅        | TBC  |
| Postgres       |     | ✅     | ✅        | TBC  |
| Python Generic |     | ✅     | ✅        | ✅  |
| Quarto Jupyter |     | ✅     | ✅        | ✅  |
| Quarto R       |     | ✅     | ✅        | ✅  |
| Rocker         |     | ✅     | ✅        | ❌  |

## Documentation

- [Container Build Guide](docs/container-build-guide.md)
