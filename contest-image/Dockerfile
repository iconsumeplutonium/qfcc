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

RUN mkdir /work/user

# Copy Image Information
COPY ./packages /work/packages
COPY ./scripts /work/scripts
COPY ./README.md /work/user/image-info.md

# Configure the Image
RUN \
    mkdir /build \
    && cd /build \
    && lb config --bootappend-live "boot=live components username=qfcc" \
    && mkdir /build/config/includes.chroot \
    && cp -r /work /build/config/includes.chroot/ \
    && cp /work/packages/base.list /build/config/package-lists/base.list.chroot \
    && cp /work/packages/editors.list /build/config/package-lists/editors.list.chroot \
    && cp /work/scripts/image-build-hook /build/config/hooks/normal/9999-image-build-hook.hook.chroot \
    && mkdir -p /build/config/includes.chroot/lib/live/config \
    && cp /work/scripts/image-boot-hook /build/config/includes.chroot/lib/live/config/9999-image-boot-hook

ENTRYPOINT ["/work/scripts/entrypoint.sh"]
