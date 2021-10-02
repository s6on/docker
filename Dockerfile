ARG BASE="alpine:latest"
FROM alpine:3 as extractor

ARG TARGETARCH
ARG TARGETVARIANT

RUN apk add --no-cache curl gnupg && \
    for server in keyserver.ubuntu.com pgp.surf.nl pgp.mit.edu ; do \
      gpg --keyserver ${server} --keyserver-options timeout=10 --recv-keys 6101B2783B2FD161 && break; \
    done && \
    S6_PLATFORM=$(case "${TARGETARCH}/${TARGETVARIANT}" in \
            "386/")     echo "x86";; \
            "amd64/")   echo "amd64";; \
            "arm/v6")   echo "arm";; \
            "arm/v7")   echo "armhf";; \
            "arm64/")   echo "aarch64";; \
            "ppc64le/") echo "ppc64le";; \
            *)          echo "nobin";; \
          esac) && \
    S6_URL="https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-${S6_PLATFORM}.tar.gz" && \
    S6_FILE="/tmp/s6-overlay.tar.gz" && \
    curl -sSL "${S6_URL}.sig" -o "${S6_FILE}.sig" && \
    curl -sSL "${S6_URL}" -o "${S6_FILE}" && \
    gpg --verify "${S6_FILE}.sig" "${S6_FILE}" && \
    mkdir -p /s6/root && \
    mkdir -p /s6/bin && \
    tar -xzvf "${S6_FILE}" -C /s6/root --exclude="./bin" && \
    if [ "${S6_PLATFORM}" != "nobin" ]; then \
    	tar -xzvf "${S6_FILE}" -C /s6 ./bin ; \
    fi && exit 0

FROM $BASE
LABEL maintainer="Julio Gutierrez julio.guti+s6@pm.me"

COPY --from=extractor /s6/root /
COPY --from=extractor /s6/bin /tmp/bin
RUN if [ "$(ls -A /tmp/bin)" ]; then \
    	mv /tmp/bin/* /bin ; \
    fi && \
    rm -rf /tmp/bin

ENTRYPOINT [ "/init" ]