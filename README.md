# s6on-docker
This repository check [weekly](https://github.com/s6on/docker/actions/workflows/docker-image-ci.yml) if a new version is available and builds a version of the base docker images for [Ubuntu](https://hub.docker.com/_/ubuntu), [Debian](https://hub.docker.com/_/debian) and [Alpine](https://hub.docker.com/_/alpine) and apply s6 on them.

Currently supporting the following architectures: linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/s390x
