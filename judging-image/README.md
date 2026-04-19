# QFCC Judging

This page covers the details of the tools built for judges and the judging process.

## Overview

Submissions are judged using a script that runs inside a Docker container.
Submissions, input, and outputs will be mounted (read-only) to the Docker container, along with a mount for output.

## Judging Code

This section details the various pieces of code used in the judging process.

### Docker Image

All contestant code should be compiled and run from inside the provided Docker container.
This provides a sandboxed and consistent place for scoring.

To build the image, use:
```sh
docker build -t qfcc-judge .
```

To run the image, we recommend using the provided script:
```sh
./scripts/run-docker-judge.sh <path to contestant submission directory> <path to oracle directory>
```

This script will properly set up the required directory structure for judging,
and copy all output to the given submission directory.

### Judging Script

The core script that does the judging is [scripts/judge-submission.sh](scripts/judge-submission.sh).
This is the script called by the judging Docker image.
This script expects a single directory laid out as follows:

```
<provided base dir>
├── input
│   └── submission.<extension>
├── output
└── oracle
    ├── input
    │   ├── 001-test-case-1.txt
    │   ├── 002-test-case-2.txt
    │   └── ...
    └── output
        ├── 001-test-case-1.txt
        ├── 002-test-case-2.txt
        └── ...
```

Definitions:
 - `input` -- Where contestant files should be located (e.g., all files from a contestant's USB can be copied here).
 - `output` -- Where judging output will be places, should generally be empty before judging.
 - `oracle/input` -- Where the input (stdin) for test cases is located.
 - `oracle/output` -- Where the output (stdout) for test cases is located, file names should match `oracle/input`.

## Judging Procedure

 - Prep your machine.
   - Ensure that the Docker image is built.
 - Receive USB
 - Record Contestant and Attempt Time
 - Plug in USB and Mount
 - Run Judging Script
   - Submissions that run too long may be killed early. Ensure that you run long enough to allow for mildly inefficient solutions.
 - If successful:
   - Then, record score and keep USB.
   - Otherwise, send back USB.

All winning submissions should be manually reviewed for any malicious behavior.
Be sure to check their previous submissions as well.

## Preparations

### USB Drives

USB drives will be used for two different activities during the contest:
booting contest-ready machines and transferring submissions from the contestants to the judges.

#### Bootable USBs

Prepare a few USBs that can boot the [contest machine image](../contest-image).
Once booted, the USB can be removed from the machine, so you don't need too many of these.

#### Submission Transfer USBs

Each contestant should have a USB drive that they can use to submit attempts.
Each USB should be numbered, dated, and signed by a judge to ensure there is no funny business.
Any contestant found using any USB but their own should be disqualified.

We recommend formatting USBs as [FAT32 (vFAT)](https://en.wikipedia.org/wiki/File_Allocation_Table#FAT32) for portability.

## Security Notes

Below are some potential security issues and what you can do to mitigate them.

### Contestant Submits Malicious Code

This is mostly handled by running their code in a Docker container.

### Contestant Submits a Zip Bomb (or otherwise tries to consume all disk space)

The judging image constrains the disk size of the running container.

If you are not running the image, killing the container or rebooting the machine should be sufficient.

### Contestant Hands in a Malicious USB (e.g., USBKiller)

Make sure to inspect any USB before plugged in.
All transfer USBs should be signed and dated by a judge ahead of time.
Use of a non-signed USB is grounds for disqualification.
