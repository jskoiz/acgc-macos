#!/bin/zsh

# Run the smallest deterministic CPU-only canonical pipeline matrix.
#
# This runner intentionally builds only named fixtures.  It does not build
# ac_pc, launch a process, read assets, or claim Apple/Metal/device behavior.
# The PC checkout must be the exact source-backed oracle recorded by the
# umbrella at this lane's base.

set -u
setopt pipefail

readonly EXPECTED_PC_COMMIT='d472c6bd32443015b0db8e285e1070b4f60539ee'
readonly ROOT_TEST='acgc_pc_gx_canonical_plan_roundtrip_fixture'
readonly ROOT_REGEX="^${ROOT_TEST}$"
readonly APPLE_REGEX='^(acgc_apple_canonical_envelope_parser_fixture|acgc_apple_canonical_plan_fixture|acgc_apple_canonical_plan_handoff_fixture|acgc_apple_canonical_plan_consumer_fixture)$'
readonly SANITIZER_FLAGS='-O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=all'
readonly SANITIZER_LINK_FLAGS='-fsanitize=address,undefined'
readonly ASAN_OPTIONS_VALUE='detect_leaks=0:halt_on_error=1:abort_on_error=1'
readonly UBSAN_OPTIONS_VALUE='halt_on_error=1:print_stacktrace=1'

typeset -a APPLE_TESTS=(
    acgc_apple_canonical_envelope_parser_fixture
    acgc_apple_canonical_plan_fixture
    acgc_apple_canonical_plan_handoff_fixture
    acgc_apple_canonical_plan_consumer_fixture
)

die() {
    print -u2 -- "error: $*"
    exit 1
}

usage() {
    print -- "usage: ${0:t} [--list] [--dry-run] [--pc-root PATH] [--build-root PATH]"
    print -- ''
    print -- '  --list       print the fixed fixture matrix and exit'
    print -- '  --dry-run    print the configure/build/CTest commands and exit'
    print -- '  --pc-root    populated ACGC-PC-Port checkout (or ACGC_PC_ROOT)'
    print -- '  --build-root fresh output root (or ACGC_VERIFY_ROOT); must not exist'
}
script_path=${0:A}
repo_root=${script_path:h:h}

render_command() {
    local rendered=''
    local arg
    for arg in "${@}"; do
        rendered+=" ${(q)arg}"
    done
    print -r -- "${rendered# }"
}

resolve_display_path() {
    local raw=$1
    local candidate
    if [[ "${raw}" == /* ]]; then
        candidate="${raw}"
    else
        candidate="$PWD/${raw}"
    fi
    if [[ -d "${candidate}" ]]; then
        (cd "${candidate}" && pwd -P) ||
            die "unable to canonicalize display path: ${candidate}"
        return
    fi
    local parent="${candidate:h}"
    local leaf="${candidate:t}"
    if [[ -d "${parent}" ]]; then
        local parent_abs
        parent_abs=$(cd "${parent}" && pwd -P) ||
            die "unable to canonicalize display parent: ${parent}"
        print -r -- "${parent_abs}/${leaf}"
    else
        print -r -- "${candidate}"
    fi
}

print_matrix() {
    print -- "PC oracle commit: ${EXPECTED_PC_COMMIT}"
    print -- "Root CTest (exact count 1): ${ROOT_TEST}"
    print -- 'Apple CTest (exact count 4):'
    for apple_test in "${APPLE_TESTS[@]}"; do
        print -- "  $apple_test"
    done
    print -- 'Every build is serialized with --parallel 1.'
    print -- 'Native and combined ASan/UBSan configurations each cover the root and Apple suites.'
}


print_dry_run() {
    local display_pc_root
    display_pc_root=$(resolve_display_path "${pc_root}") ||
        die "unable to render PC root path: ${pc_root}"
    local display_build_root
    if [[ -n "${build_root}" ]]; then
        display_build_root=$(resolve_display_path "${build_root}") ||
            die "unable to render verification root path: ${build_root}"
    else
        display_build_root='/private/tmp/acgc-canonical-pipeline.DRY-RUN'
    fi
    local pc_source="${display_pc_root}/pc"
    local apple_source="${display_pc_root}/pc/apple"
    local native_pc="${display_build_root}/native-pc"
    local native_apple="${display_build_root}/native-apple"
    local sanitizer_pc="${display_build_root}/asan-ubsan-pc"
    local sanitizer_apple="${display_build_root}/asan-ubsan-apple"

    print_matrix
    print -- ''
    print -- "PC root: ${display_pc_root}"
    print -- "Verification root: ${display_build_root}"
    render_command cmake -S "${pc_source}" -B "${native_pc}" -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug
    render_command cmake --build "${native_pc}" --target "${ROOT_TEST}" --parallel 1
    render_command ctest --test-dir "${native_pc}" -N -R "${ROOT_REGEX}"
    render_command ctest --test-dir "${native_pc}" --output-on-failure --parallel 1 -R "${ROOT_REGEX}"
    render_command cmake -S "${apple_source}" -B "${native_apple}" -G Ninja -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug
    render_command cmake --build "${native_apple}" --target "${APPLE_TESTS[@]}" --parallel 1
    render_command ctest --test-dir "${native_apple}" -N -R "${APPLE_REGEX}"
    render_command ctest --test-dir "${native_apple}" --output-on-failure --parallel 1 -R "${APPLE_REGEX}"
    render_command cmake -S "${pc_source}" -B "${sanitizer_pc}" -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug "-DCMAKE_C_FLAGS=${SANITIZER_FLAGS}" "-DCMAKE_CXX_FLAGS=${SANITIZER_FLAGS}" "-DCMAKE_EXE_LINKER_FLAGS=${SANITIZER_LINK_FLAGS}"
    render_command cmake --build "${sanitizer_pc}" --target "${ROOT_TEST}" --parallel 1
    render_command ctest --test-dir "${sanitizer_pc}" -N -R "${ROOT_REGEX}"
    render_command env "ASAN_OPTIONS=${ASAN_OPTIONS_VALUE}" "UBSAN_OPTIONS=${UBSAN_OPTIONS_VALUE}" ctest --test-dir "${sanitizer_pc}" --output-on-failure --parallel 1 -R "${ROOT_REGEX}"
    render_command cmake -S "${apple_source}" -B "${sanitizer_apple}" -G Ninja -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug "-DCMAKE_C_FLAGS=${SANITIZER_FLAGS}" "-DCMAKE_CXX_FLAGS=${SANITIZER_FLAGS}" "-DCMAKE_OBJC_FLAGS=${SANITIZER_FLAGS}" "-DCMAKE_EXE_LINKER_FLAGS=${SANITIZER_LINK_FLAGS}"
    render_command cmake --build "${sanitizer_apple}" --target "${APPLE_TESTS[@]}" --parallel 1
    render_command ctest --test-dir "${sanitizer_apple}" -N -R "${APPLE_REGEX}"
    render_command env "ASAN_OPTIONS=${ASAN_OPTIONS_VALUE}" "UBSAN_OPTIONS=${UBSAN_OPTIONS_VALUE}" ctest --test-dir "${sanitizer_apple}" --output-on-failure --parallel 1 -R "${APPLE_REGEX}"
    print -- 'Sanitizer CTest runs export ASAN_OPTIONS and UBSAN_OPTIONS with fail-fast settings.'
}

mode='run'
pc_root=${ACGC_PC_ROOT:-}
build_root=${ACGC_VERIFY_ROOT:-}

while (( $# > 0 )); do
    case "$1" in
        --list)
            mode='list'
            ;;
        --dry-run)
            mode='dry-run'
            ;;
        --pc-root)
            (( $# >= 2 )) || die '--pc-root requires a path'
            pc_root=$2
            shift
            ;;
        --build-root)
            (( $# >= 2 )) || die '--build-root requires a path'
            build_root=$2
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage >&2
            die "unknown argument: $1"
            ;;
    esac
    shift
done


if [[ -z "${pc_root}" ]]; then
    pc_root="${repo_root}/upstream/ACGC-PC-Port"
fi

if [[ "$mode" == 'list' ]]; then
    print_matrix
    exit 0
fi

if [[ "$mode" == 'dry-run' ]]; then
    print_dry_run
    exit 0
fi

command -v cmake >/dev/null 2>&1 || die 'cmake is required'
command -v ctest >/dev/null 2>&1 || die 'ctest is required'
command -v ninja >/dev/null 2>&1 || die 'ninja is required'
command -v rg >/dev/null 2>&1 || die 'rg is required for deterministic log scanning'

[[ -d "$pc_root" ]] || die "PC checkout does not exist: $pc_root"
pc_root=$(cd "$pc_root" && pwd -P) ||
    die "unable to canonicalize PC checkout: $pc_root"


git -C "${pc_root}" rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
    die "PC path is not a Git checkout: ${pc_root}"
pc_commit=$(git -C "${pc_root}" rev-parse HEAD) ||
    die 'unable to resolve PC HEAD'
[[ "${pc_commit}" == "${EXPECTED_PC_COMMIT}" ]] ||
    die "PC oracle mismatch: expected ${EXPECTED_PC_COMMIT}, got ${pc_commit}"

pc_branch=$(git -C "${pc_root}" symbolic-ref --quiet --short HEAD 2>/dev/null)
branch_status=$?
if (( branch_status == 0 )); then
    die "PC checkout must be detached: ${pc_root}"
elif (( branch_status != 1 )); then
    die "unable to inspect PC checkout state: ${pc_root}"
fi

pc_status=$(git -C "${pc_root}" status --porcelain)
(( $? == 0 )) || die "unable to read PC checkout status: ${pc_root}"
[[ -z "${pc_status}" ]] || die "PC checkout is dirty: ${pc_root}"

pc_source="$pc_root/pc"
apple_source="$pc_root/pc/apple"
[[ -f "$pc_source/CMakeLists.txt" ]] || die "missing PC CMake source: $pc_source"
[[ -f "$apple_source/CMakeLists.txt" ]] || die "missing Apple CMake source: $apple_source"
[[ -f "$pc_source/tests/pc_gx_canonical_plan_roundtrip_fixture.c" ]] ||
    die 'missing root canonical-plan round-trip fixture source'
for apple_test in "${APPLE_TESTS[@]}"; do
    case "$apple_test" in
        acgc_apple_canonical_envelope_parser_fixture)
            apple_fixture_source="$apple_source/tests/test_apple_canonical_envelope_parser.c"
            ;;
        acgc_apple_canonical_plan_fixture)
            apple_fixture_source="$apple_source/tests/test_apple_canonical_plan.c"
            ;;
        acgc_apple_canonical_plan_consumer_fixture)
            apple_fixture_source="$apple_source/tests/test_apple_canonical_plan_consumer.c"
            ;;
        acgc_apple_canonical_plan_handoff_fixture)
            apple_fixture_source="$apple_source/tests/test_apple_canonical_plan_handoff.c"
            ;;
        *)
            die "unrecognized Apple fixture: $apple_test"
            ;;
    esac
    [[ -f "$apple_fixture_source" ]] || die "missing Apple fixture source: $apple_fixture_source"
done

if [[ -n "$build_root" ]]; then
    [[ ! -e "$build_root" ]] || die "build root already exists; provide a fresh path: $build_root"
    mkdir -p "$build_root" || die "unable to create verification root: $build_root"
else
    build_root=$(mktemp -d /private/tmp/acgc-canonical-pipeline.XXXXXX) ||
        die 'unable to create verification root'
fi
build_root=$(cd "$build_root" && pwd -P) ||
    die "unable to canonicalize verification root: $build_root"


run_logged() {
    local log_path=$1
    shift
    print -r -- "+ $(render_command "${@}")"
    "$@" 2>&1 | tee "${log_path}"
    local -a pipeline_status=("${pipestatus[@]}")
    (( ${#pipeline_status[@]} == 2 )) ||
        die "unable to capture pipeline status for ${log_path}"
    local command_status=${pipeline_status[1]}
    local tee_status=${pipeline_status[2]}
    (( command_status == 0 && tee_status == 0 )) ||
        die "command/tee failed (command=${command_status}, tee=${tee_status}); see ${log_path}"
}


assert_discovery() {
    local log_path=$1
    local expected_count=$2
    [[ -r "${log_path}" ]] || die "CTest discovery log is unreadable: ${log_path}"

    local discovered_count
    local total_count
    discovered_count=$(awk '/^[[:space:]]*Test #[0-9]+:/{count++} END{print count+0}' "${log_path}")
    (( $? == 0 )) || die "unable to read CTest discovery log: ${log_path}"
    total_count=$(awk -F': ' '/Total Tests:/{value=$2} END{print value+0}' "${log_path}")
    (( $? == 0 )) || die "unable to read CTest discovery log: ${log_path}"
    [[ "${discovered_count}" == <-> ]] ||
        die "invalid discovery count in ${log_path}: ${discovered_count}"
    [[ "${total_count}" == <-> ]] ||
        die "invalid total test count in ${log_path}: ${total_count}"
    (( discovered_count == expected_count )) ||
        die "CTest discovery count mismatch in ${log_path}: expected ${expected_count}, got ${discovered_count}"
    (( total_count == expected_count )) ||
        die "CTest total mismatch in ${log_path}: expected ${expected_count}, got ${total_count}"
}


assert_required_logs() {
    local build_dir=$1
    typeset -a log_paths=(
        "${build_dir}/configure.log"
        "${build_dir}/build.log"
        "${build_dir}/discovery.log"
        "${build_dir}/ctest.log"
        "${build_dir}/Testing/Temporary/LastTest.log"
    )
    local log_path
    for log_path in "${log_paths[@]}"; do
        [[ -f "${log_path}" && -r "${log_path}" && -s "${log_path}" ]] ||
            die "required log missing, unreadable, or empty: ${log_path}"
    done
}

scan_logs() {
    local build_dir=$1
    local fatal_pattern='AddressSanitizer|UndefinedBehaviorSanitizer|runtime error:|(^|[[:space:]])FAILED([[:space:]]|$)|\*\*\*Failed|CHECK failed|(^|[[:space:]])ERROR([[:space:]]|$)'
    typeset -a log_paths=(
        "${build_dir}/configure.log"
        "${build_dir}/build.log"
        "${build_dir}/discovery.log"
        "${build_dir}/ctest.log"
        "${build_dir}/Testing/Temporary/LastTest.log"
    )
    rg -n -- "${fatal_pattern}" "${log_paths[@]}"
    local rg_status=$?
    if (( rg_status == 0 )); then
        die "sanitizer/runtime diagnostic found under ${build_dir}"
    elif (( rg_status != 1 )); then
        die "unable to scan logs under ${build_dir} (rg status ${rg_status})"
    fi
}

run_suite() {
    local suite_name=$1
    local source_dir=$2
    local build_dir=$3
    local regex=$4
    local expected_count=$5
    local sanitizer=$6
    shift 6
    typeset -a targets=("$@")
    typeset -a configure_args=(
        -S "$source_dir"
        -B "$build_dir"
        -G Ninja
        -DBUILD_TESTING=ON
        -DCMAKE_BUILD_TYPE=Debug
    )

    if [[ "$suite_name" == 'pc' ]]; then
        configure_args+=(-DPC_DARWIN_COMPILE_AUDIT=ON)
    fi
    if [[ "$sanitizer" == 'yes' ]]; then
        configure_args+=(
            "-DCMAKE_C_FLAGS=$SANITIZER_FLAGS"
            "-DCMAKE_CXX_FLAGS=$SANITIZER_FLAGS"
            "-DCMAKE_EXE_LINKER_FLAGS=$SANITIZER_LINK_FLAGS"
        )
        if [[ "$suite_name" == 'apple' ]]; then
            configure_args+=("-DCMAKE_OBJC_FLAGS=$SANITIZER_FLAGS")
        fi
    fi


    [[ ! -e "${build_dir}" ]] || die "build directory already exists; verification root is not fresh: ${build_dir}"
    mkdir -p "${build_dir}" || die "unable to create build directory: ${build_dir}"
    run_logged "${build_dir}/configure.log" cmake "${configure_args[@]}"
    run_logged "${build_dir}/build.log" cmake --build "${build_dir}" --target "${targets[@]}" --parallel 1
    run_logged "${build_dir}/discovery.log" ctest --test-dir "${build_dir}" -N -R "${regex}"

    if [[ "${sanitizer}" == 'yes' ]]; then
        run_logged "${build_dir}/ctest.log" env \
            ASAN_OPTIONS="${ASAN_OPTIONS_VALUE}" \
            UBSAN_OPTIONS="${UBSAN_OPTIONS_VALUE}" \
            ctest --test-dir "${build_dir}" --output-on-failure --parallel 1 -R "${regex}"
    else
        run_logged "${build_dir}/ctest.log" \
            ctest --test-dir "${build_dir}" --output-on-failure --parallel 1 -R "${regex}"
    fi

    assert_required_logs "${build_dir}"
    assert_discovery "${build_dir}/discovery.log" "${expected_count}"

    typeset -a ctest_logs=("${build_dir}/ctest.log" "${build_dir}/Testing/Temporary/LastTest.log")
    rg -n -i -- 'Skipped|Not Run' "${ctest_logs[@]}"
    local skip_status=$?
    if (( skip_status == 0 )); then
        die "selected CTest suite skipped a test: ${suite_name}"
    elif (( skip_status != 1 )); then
        die "unable to scan CTest logs under ${build_dir} (rg status ${skip_status})"
    fi
    scan_logs "${build_dir}"

}

native_pc_dir="$build_root/native-pc"
native_apple_dir="$build_root/native-apple"
sanitizer_pc_dir="$build_root/asan-ubsan-pc"
sanitizer_apple_dir="$build_root/asan-ubsan-apple"

print -- "PC source: $pc_root"
print -- "PC oracle: $pc_commit"
print -- "Verification root: $build_root"
run_suite pc "$pc_source" "$native_pc_dir" "$ROOT_REGEX" 1 no "$ROOT_TEST"
run_suite apple "$apple_source" "$native_apple_dir" "$APPLE_REGEX" 4 no "${APPLE_TESTS[@]}"
run_suite pc "$pc_source" "$sanitizer_pc_dir" "$ROOT_REGEX" 1 yes "$ROOT_TEST"
run_suite apple "$apple_source" "$sanitizer_apple_dir" "$APPLE_REGEX" 4 yes "${APPLE_TESTS[@]}"

print -- ''
print -- 'PASS: canonical pipeline native and combined ASan/UBSan suites completed with exact discovery and zero skips.'
print -- 'Proof boundary: source-backed CPU fixtures only; no full ac_pc link, process launch, assets, callbacks, Metal, pixels, device, or playability claim.'
