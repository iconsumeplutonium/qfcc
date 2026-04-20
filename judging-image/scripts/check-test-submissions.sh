#!/bin/bash

readonly THIS_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd | xargs realpath)"
readonly BASE_DIR="${THIS_DIR}/../.."
readonly JUDGE_SCRIPT="${THIS_DIR}/judge-submission.sh"
readonly TEST_PROBLEMS_DIR="${BASE_DIR}/sample-problems"

readonly TESTING_DIR='/tmp/qfcc-testing'
readonly ACTUAL_OUTPUT_PATH="${TESTING_DIR}/output/output.txt"
readonly OUTPUT_DIFF_PATH="${TESTING_DIR}/output.diff"

function main() {
    if [[ $# -ne 0 ]]; then
        echo "USAGE: $0"
        exit 101
    fi

    trap exit SIGINT

    cd "${BASE_DIR}"

    local error_count=0

    for test_problem_dir in "${TEST_PROBLEMS_DIR}/"* ; do
        local problem_name=$(basename "${test_problem_dir}")

        for submission_dir in "${test_problem_dir}/submissions/"* ; do
            local submission_name=$(basename "${submission_dir}")

            echo "Checking ${problem_name}, ${submission_name}."

            local expected_output_path="${submission_dir}/expected.txt"

            # Prep the testing dir.
            rm -rf "${TESTING_DIR}"
            mkdir -p "${TESTING_DIR}/input" "${TESTING_DIR}/output"
            cp -r "${test_problem_dir}/oracle" "${TESTING_DIR}/"
            cp "${submission_dir}/"* "${TESTING_DIR}/input/"
            rm "${TESTING_DIR}/input/expected.txt"

            # Run Judging Script
            "${JUDGE_SCRIPT}" "${TESTING_DIR}" > "${ACTUAL_OUTPUT_PATH}"

            # Compare Output Against Expected
            diff --unified --label 'expected' --label 'actual' "${expected_output_path}" "${ACTUAL_OUTPUT_PATH}" > "${OUTPUT_DIFF_PATH}"
            if [[ $? -ne 0 ]] ; then
                ((error_count++))

                echo '------ diff ------'
                cat "${OUTPUT_DIFF_PATH}"
                echo '------------------'
            fi
        done
    done

    rm -rf "${TESTING_DIR}"

    echo ''
    if [[ ${error_count} -gt 0 ]] ; then
        echo "Found ${error_count} issues."
    else
        echo "No issues found."
    fi

    return ${error_count}
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
