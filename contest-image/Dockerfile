FROM debian:12.13-slim

ENV DEBIAN_FRONTEND=noninteractive

USER root

WORKDIR /work

# Base building packages.
RUN \
    apt update \
    && apt install -y \
        vim \
        live-build \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Copy Image Information
COPY ./packages /work/packages
COPY ./scripts /work/scripts

# Configure the Image
RUN \
    mkdir /build \
    && cd /build \
    && lb config \
    && mkdir config/includes.chroot \
    && cp -r /work config/includes.chroot/ \
    && cp /work/packages/base.list config/package-lists/base.list.chroot \
    && cp /work/packages/editors.list config/package-lists/editors.list.chroot \
    && cp /work/scripts/image-build-hook config/hooks/normal/image-build-hook.hook.chroot

ENTRYPOINT ["/work/scripts/entrypoint.sh"]
