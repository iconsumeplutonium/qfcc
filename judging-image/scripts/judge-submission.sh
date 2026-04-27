#!/bin/bash

readonly INPUT_DIRNAME='input'
readonly OUTPUT_DIRNAME='output'
readonly ORACLE_DIRNAME='oracle'

readonly SUBMISSION_BASENAME='solution'

readonly ALLOWED_EXTENSIONS=".c .cc .cs .go .java .js .php .pl .py .rb .rs"

readonly TEMP_DIR='/tmp/qfcc'
readonly OUTPUT_DIFF_PATH="${TEMP_DIR}/output.diff"
readonly CLASSPATH_DIR="${TEMP_DIR}/java-classes"

# Check the structure of the base directory.
function check_contents() {
    local base_dir=$1

    declare -A paths=(
        ['Base']="${base_dir}"
        ['Input']="${base_dir}/${INPUT_DIRNAME}"
        ['Output']="${base_dir}/${OUTPUT_DIRNAME}"
        ['Oracle Input']="${base_dir}/${ORACLE_DIRNAME}/${INPUT_DIRNAME}"
        ['Oracle Output']="${base_dir}/${ORACLE_DIRNAME}/${OUTPUT_DIRNAME}"
    )

    for name in "${!paths[@]}" ; do
        local path=${paths[${name}]}

        if [[ ! -d "${path}" ]] ; then
            echo "ERROR: ${name} directory does not exist or is not a directory: '${path}'."
            exit 102
        fi
    done

    local input_dir="${base_dir}/${INPUT_DIRNAME}"

    local num_input_files=$(ls -1q "${input_dir}" | wc -l)
    if [[ ${num_input_files} -ne 1 ]] ; then
        echo "ERROR: Expected exactly one input file, found ${num_input_files}:"
        ls -1q "${input_dir}" | sort
        exit 103
    fi

    local submission_path=$(realpath "${input_dir}/"*)

    if [[ ! -f ${submission_path} ]] ; then
        echo "ERROR: Submission file does not exist, or is not a file."
        exit 104
    fi

    local submission_basename=$(basename "${submission_path}" | sed 's/\(.*\)\(\.\w\+\)$/\1/')
    local submission_extension=$(basename "${submission_path}" | sed 's/\(.*\)\(\.\w\+\)$/\2/')

    if [[ "${SUBMISSION_BASENAME}" != "${submission_basename}" ]] ; then
        echo "ERROR: Submission does not have the correct basename ('${SUBMISSION_BASENAME}'), found: '${submission_basename}'."
        exit 105
    fi

    if [[ "${ALLOWED_EXTENSIONS}" != *"${submission_extension}"* ]] ; then
        echo "ERROR: Submission does not have the correct extension, found: '${submission_extension}'."
        exit 106
    fi

    for oracle_input_path in "${base_dir}/${ORACLE_DIRNAME}/${INPUT_DIRNAME}/"* ; do
        local test_name=$(basename "${oracle_input_path}" | sed 's/\(.*\)\(\.\w\+\)$/\1/')

        if [[ ! -f "${oracle_input_path}" ]] ; then
            echo "ERROR: Input oracle for test case '${test_name}' is not a file: '${oracle_input_path}'."
            exit 107
        fi

        local oracle_output_path="${base_dir}/${ORACLE_DIRNAME}/${OUTPUT_DIRNAME}/${test_name}.txt"
        if [[ ! -f "${oracle_output_path}" ]] ; then
            echo "ERROR: Output oracle for test case '${test_name}' does not exist or is not a file: '${oracle_output_path}'."
            exit 108
        fi
    done
}

# Check against all test cases.
function run_test_cases_and_exit() {
    local base_dir=$1

    local error_count=0

    local submission_path=$(realpath "${base_dir}/${INPUT_DIRNAME}/"*)

    # for oracle_input_path in "${base_dir}/${ORACLE_DIRNAME}/${INPUT_DIRNAME}/"* ; do
    for oracle_input_filename in $(ls -1 "${base_dir}/${ORACLE_DIRNAME}/${INPUT_DIRNAME}/" | sort) ; do
        local test_name=$(basename "${oracle_input_filename}" | sed 's/\(.*\)\(\.\w\+\)$/\1/')
        local oracle_input_path="${base_dir}/${ORACLE_DIRNAME}/${INPUT_DIRNAME}/${test_name}.txt"
        local oracle_output_path="${base_dir}/${ORACLE_DIRNAME}/${OUTPUT_DIRNAME}/${test_name}.txt"

        local output_path="${base_dir}/${OUTPUT_DIRNAME}/${test_name}.txt"
        local compile_output_path="${base_dir}/${OUTPUT_DIRNAME}/${test_name}_compile.txt"
        local diff_out_path="${base_dir}/${OUTPUT_DIRNAME}/${test_name}.diff"

        echo "Running test case: '${test_name}'."
        run_submission "${submission_path}" "${oracle_input_path}" "${output_path}" "${compile_output_path}"

        diff --side-by-side --width 150 --expand-tabs "${oracle_output_path}" "${output_path}" > "${diff_out_path}"
        if [[ $? -ne 0 ]] ; then
            ((error_count++))

            diff --unified --label 'expected' --label 'actual' "${oracle_output_path}" "${output_path}" > "${OUTPUT_DIFF_PATH}"

            echo "Test case '${test_name}' failed."
            echo '------ unified diff ------'
            cat "${OUTPUT_DIFF_PATH}"
            echo '------------------'
        else
            echo "Test case '${test_name}' passed."
        fi

        echo ''
    done

    if [[ ${error_count} -gt 0 ]] ; then
        echo "Failed ${error_count} test cases."
    else
        echo "Passed all test cases!"
    fi

    exit ${error_count}
}

function run_submission() {
    local submission_path=$1
    local input_path=$2
    local output_path=$3
    local compile_output_path=$4

    local submission_basename=$(basename "${submission_path}" | sed 's/\(.*\)\(\.\w\+\)$/\1/')
    local submission_extension=$(basename "${submission_path}" | sed 's/\(.*\)\(\.\w\+\)$/\2/')

    if [[ "${submission_extension}" == '.c' ]] ; then
        gcc "${submission_path}" &> "${compile_output_path}"
        if [[ $? -ne 0 ]] ; then
            echo "C compile failed."
            exit 109
        fi

        ./a.out < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.cc' ]] ; then
        g++ "${submission_path}" &> "${compile_output_path}"
        if [[ $? -ne 0 ]] ; then
            echo "C++ compile failed."
            exit 110
        fi

        ./a.out < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.cs' ]] ; then
        dotnet build --artifacts-path . "${submission_path}" &> "${compile_output_path}"
        if [[ $? -ne 0 ]] ; then
            echo "C# compile failed."
            exit 111
        fi

        ./bin/debug/solution < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.go' ]] ; then
        go build "${submission_path}" &> "${compile_output_path}"
        if [[ $? -ne 0 ]] ; then
            echo "Go compile failed."
            exit 112
        fi

        "./${SUBMISSION_BASENAME}" < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.java' ]] ; then
        mkdir -p "${CLASSPATH_DIR}"

        javac -d "${CLASSPATH_DIR}" "${submission_path}" &> "${compile_output_path}"
        if [[ $? -ne 0 ]] ; then
            echo "Java compile failed."
            exit 113
        fi

        java -cp "${CLASSPATH_DIR}" "${submission_basename}" < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.js' ]] ; then
        node "${submission_path}" < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.php' ]] ; then
        php "${submission_path}" < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.pl' ]] ; then
        perl "${submission_path}" < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.py' ]] ; then
        python3 "${submission_path}" < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.rb' ]] ; then
        ruby "${submission_path}" < "${input_path}" &> "${output_path}"
    elif [[ "${submission_extension}" == '.rs' ]] ; then
        rustc "${submission_path}" &> "${compile_output_path}"
        if [[ $? -ne 0 ]] ; then
            echo "Rust compile failed."
            exit 114
        fi

        "./${SUBMISSION_BASENAME}" < "${input_path}" &> "${output_path}"
    else
        echo "Unknown submission extension: '${submission_extension}'."
        exit 199
    fi
}

function main() {
    if [[ $# -ne 1 ]]; then
        echo "USAGE: $0 <base dir>"
        exit 101
    fi

    trap exit SIGINT

    local base_dir=$1

    rm -rf "${TEMP_DIR}"
    mkdir -p "${TEMP_DIR}"

    check_contents "${base_dir}"

    run_test_cases_and_exit "${base_dir}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
