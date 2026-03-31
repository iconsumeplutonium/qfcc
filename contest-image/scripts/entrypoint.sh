#!/bin/bash

readonly WORK_DIR='/work'
readonly BUILD_DIR="/build"
readonly OUT_DIR='/out'

function main() {
    trap exit SIGINT
    set -e

    cd "${BUILD_DIR}"

    lb build
    cp live-image-amd64.hybrid.iso "${OUT_DIR}/build.amd64.iso"

    return 0
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
