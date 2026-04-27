# QFCC Contest Image

This page covers the details of the image built for contestants.

## Overview

Th contest image is based on [Debian](https://en.wikipedia.org/wiki/Debian),
and uses the [Live Build](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html)
tools to create a custom image.

## Using the Image

 - Username: `qfcc`
 - Password: `qfcc`

## Language Support

All submissions should be contained in a single file with the `solution` basename.
The extension that should be used as well as how the solution will be run is in the following table:

| Language   | Version              | Extension | Compilation                | Invocation             |
|------------|----------------------|-----------|----------------------------|------------------------|
| C          | gcc 12.2.0           | `.c`      | `gcc solution.c`           | `./a.out`              |
| C#         | dotnet 10.0.203      | `.cs`     | `dotnet build solution.cs` | `./bin/debug/solution` |
| C++        | g++ 12.2.0           | `.cc`     | `g++ solution.cc`          | `./a.out`              |
| Go         | go 1.19.8            | `.go`     | `go build solution.go`     | `./solution`           |
| Java       | OpenJDK 17.0.18      | `.java`   | `javac solution.java`      | `java solution`        |
| Javascript | node v18.20.4        | `.js`     |                            | `node solution.js`     |
| Perl       | GNU Perl v5.36.0     | `.pl`     |                            | `perl solution.py`     |
| PHP        | PHP 8.2.30 (Zend)    | `.php`    |                            | `php solution.php`     |
| Python     | CPython 3.11.2       | `.py`     |                            | `python3 solution.py`  |
| Ruby       | ruby (YARV) 3.1.2p20 | `.rb`     |                            | `ruby solution.rb`     |
| Rust       | rustc 1.63.0         | `.rs`     | `rustc solution.rs`        | `./solution`           |

If you want to use a language not listed here,
be sure to contact the contest hosts well before the contest.
Most text-based languages with CLI support should be admissible.

## Text Editors

The following text editors are present in the image:

 - [Emacs](https://en.wikipedia.org/wiki/Emacs)
   - A very powerful text editor that can be run in a terminal or GUI window..
   - One of the two best text editors (debatable, but generally accepted to be one of the best).
 - [Mousepad](https://en.wikipedia.org/wiki/Mousepad_(software))
   - A very simple graphical editor.
   - Similar to:
     - Gedit (Gnome)
     - Notepad (Windows)
     - TextEdit (Mac)
 - [Nano](https://en.wikipedia.org/wiki/GNU_nano)
   - A bare bones terminal text editor.
 - [Vim](https://en.wikipedia.org/wiki/Vim_(text_editor))
   - A very powerful terminal text editor.
   - The best text editor (according to Eriq).
     - Along with Emacs, these editors had withstood the test of time and are generally considered the best.
   - Note that `gvim` is not available because of dependencies within the image.

### Running Text Editors

This table summarizes some ways you can run each text editor.

| Editor   | Has Desktop Icon | Open Window | Run in Terminal |
|----------|------------------|-------------|-----------------|
| Emacs    |        ✅        | `emacs`     | `emacs -nw`     |
| Mousepad |        ✅        | `mousepad`  |                 |
| Nano     |                  |             | `nano`          |
| Vim      |                  |             | `vim`           |

## Building the Image

We use [Live Build](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html) to build our image,
which requires a Debian install.
To make it easy for anyone to build,
we use [Docker](https://en.wikipedia.org/wiki/Docker_(software)) to create a Debian container which can then build our contest image.

Note that we need to use the repository root as the Docker build context,
since we need to copy files outside of this directory.
To build the image builder image:
```sh
$(cd .. && docker build -t qfcc-image-builder -f contest-image/Dockerfile .)
```

To build the actual image/ISO:
```sh
docker run --rm --privileged -v ./build:/out qfcc-image-builder
```

Note that the seed will be output during this step, which is used as the root password.
In the build output, you will see something like:
```sh
Seed: 400011907
```

## Testing the Image

The most straightforward way to test the image would be to burn it to a USB and run it.
To test it without needing a USB or another machine, you can use [QEMU](https://en.wikipedia.org/wiki/QEMU):

```sh
qemu-system-x86_64 --enable-kvm -cpu host -boot d -m 8G -cdrom ./build/build.amd64.iso
```

## Writing the Image

**All existing data on this USB stick will be lost.**

First plug in your USB stick (or whatever block device you want to write to).
Identify which block device your USB has been assigned, we will use `/dev/sdX` in this document.
We want to **disk**, not **partition**, so the block device will generally end in a letter, not number.

This document does not cover the details of identifying your block device, but here is a general procedure you can use:
 1. Unplug the USB (if plugged in).
 2. Run `lsblk -o NAME,TRAN`.
 3. Plug in the USB and wait five seconds.
 4. Run `lsblk -o NAME,TRAN`.
 5. Look at the difference between the two.

To copy the image (at `./build/build.amd64.iso`) to the USB (at `/dev/sdX`), use:
```sh
sudo dd if=./build/build.amd64.iso of=/dev/sdX conv=fsync bs=4M status=progress
```

## Packages

The packages the image uses live in the [packages](./packages) directory.
Note that `.list` files may contain versions, while `.txt` files can only contain names.

 - [packages/base.list](packages/base.list) -- The base packages to install.
 - [packages/editors.list](packages/editors.list) -- Editors to install.
 - [packages/remove.txt](packages/remove.txt) -- Packages to be removed along with all their dependencies. `autoremove` and `autoclean` will be called after this.
 - [packages/remove-force.txt](packages/remove-force.txt) -- Packages to be remove while breaking dependencies (e.g., this will leave dependencies and reverse dependencies installed).
