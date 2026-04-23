#!/bin/bash

# Run the full grading process while recording the attempt.
# Should be run as root (or with sudo).

readonly THIS_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd | xargs realpath)"
readonly JUDGE_SCRIPT="${THIS_DIR}/run-docker-judge.sh"

readonly MOUNT_PATH='/mnt'

function main() {
    if [[ $# -ne 4 ]]; then
        echo "USAGE: $0 <out dir> <oracle dir> <device path> <contestant name/id>"
        exit 101
    fi

    trap exit SIGINT
    set -e

    local base_out_dir=$1
    local oracle_dir=$2
    local dev_path=$3
    local contestant=$4

    # Check if we have root (we will be mounting).
    if [[ "${USER}" != 'root' ]] ; then
        echo "Run as root (with sudo)."
        exit 102
    fi

    # Compute the output directory.
    local timestamp=$(date --iso-8601=seconds)
    local out_dir="${base_out_dir}/${contestant}/${timestamp}"
    mkdir -p "${out_dir}"

    echo "Sending output to '${out_dir}'."

    # Mount and copy over the submission.
    mount "${dev_path}" "${MOUNT_PATH}"
    cp "${MOUNT_PATH}/"* "${out_dir}/"

    # Run Judging
    "${JUDGE_SCRIPT}" "${out_dir}" "${oracle_dir}" || true

    # Copy results.
    cp "${out_dir}/"* "${MOUNT_PATH}/"

    # Cleanup

    # If this command was run as sudo, change file ownership to the caller.
    # Otherwise, just make it permissive.
    if [[ -z "${SUDO_USER}" ]] ; then
        chmod 777 "${out_dir}"
        chmod -R 555 "${out_dir}"/*
    else
        chown -R "${SUDO_USER}:${SUDO_USER}" "${out_dir}"
    fi

    # Unmount
    umount "${dev_path}"

    exit 0
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
