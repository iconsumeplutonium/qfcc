#!/bin/bash

readonly THIS_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd | xargs realpath)"
readonly JUDGE_DIR="${THIS_DIR}/.."
readonly BASE_DIR="${THIS_DIR}/../.."
readonly DOCKER_JUDGE_SCRIPT="${THIS_DIR}/run-docker-judge.sh"
readonly TEST_PROBLEMS_DIR="${BASE_DIR}/sample-problems"

readonly TEMP_DIR='/tmp/qfcc-docker-testing'
readonly TEST_COPY_DIR="${TEMP_DIR}/problems"
readonly OUTPUT_DIFF_PATH="${TEMP_DIR}/output.diff"

readonly DOCKER_IMAGE_NAME='qfcc-judge'

function main() {
    if [[ $# -ne 0 ]]; then
        echo "USAGE: $0"
        return 101
    fi

    trap exit SIGINT

    cd "${JUDGE_DIR}"

    rm -rf "${TEMP_DIR}"
    mkdir -p "${TEMP_DIR}"

    # Build the judging image.
    docker build -t "${DOCKER_IMAGE_NAME}" .
    if [[ $? -ne 0 ]] ; then
        echo "ERROR: Failed to build docker image."
        return 102
    fi

    # Make a copy of the tests.
    cp -r "${TEST_PROBLEMS_DIR}" "${TEST_COPY_DIR}"

    # Remove expected file from submissions.
    rm "${TEST_COPY_DIR}"/*/submissions/*/expected.txt

    # Run the tests.
    local error_count=0
    for test_problem_dir in "${TEST_COPY_DIR}/"* ; do
        local problem_name=$(basename "${test_problem_dir}")

        for submission_dir in "${test_problem_dir}/submissions/"* ; do
            local submission_name=$(basename "${submission_dir}")

            echo "Checking ${problem_name}, ${submission_name}."

            local expected_output_path="${TEST_PROBLEMS_DIR}/${problem_name}/submissions/${submission_name}/expected.txt"
            local actual_output_path="${submission_dir}/output.txt"

            # Run Judging Docker Script
            "${DOCKER_JUDGE_SCRIPT}" "${submission_dir}" "${test_problem_dir}/oracle"

            # Compare Output Against Expected
            diff --unified --label 'expected' --label 'actual' "${expected_output_path}" "${actual_output_path}" > "${OUTPUT_DIFF_PATH}"
            if [[ $? -ne 0 ]] ; then
                ((error_count++))

                echo '------ diff ------'
                cat "${OUTPUT_DIFF_PATH}"
                echo '------------------'
            fi
        done
    done

    echo ''
    if [[ ${error_count} -gt 0 ]] ; then
        echo "Found ${error_count} issues."
    else
        echo "No issues found."
    fi

    return ${error_count}
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
