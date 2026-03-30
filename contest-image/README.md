# QFCC Contest Image

This page will cover the details of the image built for competition.

## Overview

Th contest image is based on [Debian](https://en.wikipedia.org/wiki/Debian),
and uses the [Live Build](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html)
tools to create a custom image.

## Building the Image

We use [Live Build](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html) to build our image,
which requires a Debian install.
To make it easy for anyone to build,
we use [Docker](https://en.wikipedia.org/wiki/Docker_(software)) to create a Debian container which can then build our contest image.

To build the image builder image:
```sh
docker build -t qfcc-image-builder .
```

To build the actual image/ISO:
```sh
docker run --rm --privileged -v ./build:/out qfcc-image-builder
```

## Testing the Image

The most straightforward way to test the image would be to burn it to a USB and run it.
To test it without needing a USB or another machine, you can use [QEMU](https://en.wikipedia.org/wiki/QEMU):

```sh
qemu-system-x86_64 --enable-kvm -cpu host -boot d -m 8G -cdrom ./build/build.amd64.iso
```

## Packages

The packages the image uses live in the [package](./package) directory.
