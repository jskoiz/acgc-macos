#!/usr/bin/env bash

set -euo pipefail

readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly SOURCE_DIR="${ROOT_DIR}/upstream/ACGC-PC-Port/pc/apple"
readonly BUILD_DIR="${ACGC_MACOS_BUILD_DIR:-${ROOT_DIR}/local/build/macos-host}"
readonly APP_NAME="acgc_macos_native_host"
readonly APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
readonly APP_BINARY="${APP_BUNDLE}/Contents/MacOS/${APP_NAME}"
readonly CLI_BINARY="${BUILD_DIR}/${APP_NAME}_cli"
readonly DISC_PATH="${ACGC_DISC_PATH:-${ROOT_DIR}/local/roms/Animal Crossing (USA).iso}"
readonly VERIFY_HOME="${ACGC_VERIFY_HOME:-${ROOT_DIR}/local/runtime/macos-host-verify-home}"
readonly VERIFY_LOG="${VERIFY_HOME}/metal-geometry-verify.log"
readonly HOST_PID_FILE="${ACGC_HOST_PID_FILE:-${VERIFY_HOME}/acgc_macos_native_host.pid}"
readonly HOST_LOCK_DIR="${HOST_PID_FILE}.lock"
readonly HOST_TERM_GRACE_ATTEMPTS="${ACGC_HOST_TERM_GRACE_ATTEMPTS:-30}"
readonly HOST_STATE_PATTERN='^[IRSTUZ][[:alpha:]<>+]*$'

HOST_LOCK_HELD=0

usage() {
    cat <<'EOF'
Usage: ./script/build_and_run.sh [--run|--verify|--headless|--debug|--logs|--telemetry]

Builds and tests the native AppKit host before the selected action.

  --run        Launch a new foreground app instance (default).
  --verify     Prove two command-buffer-completed Metal triangle fixture frames
               and a clean exit.
  --headless   Validate the explicit disc without opening a window.
  --debug      Start the direct inner-bundle app executable under LLDB.
               LLDB owns its inferior; this script records no host PID for
               debug mode. Detaching leaves it outside automatic cleanup;
               terminate the inferior instead of detaching.
  --logs       Launch the app, then stream its macOS process logs.
  --telemetry  Alias for --logs until structured telemetry is implemented.

Override the ignored local disc with ACGC_DISC_PATH. Generated build and
verification state stays below local/ unless ACGC_MACOS_BUILD_DIR or
ACGC_VERIFY_HOME is explicitly set.
EOF
}

host_pid_is_valid() {
    [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

host_field_is_safe() {
    [[ -n "$1" && "$1" != *[[:cntrl:]]* ]]
}

acquire_host_lock() {
    local lock_parent

    if [[ "${HOST_LOCK_HELD}" -eq 1 ]]; then
        return 0
    fi
    lock_parent="$(dirname "${HOST_LOCK_DIR}")"
    mkdir -p "${lock_parent}"
    if ! mkdir "${HOST_LOCK_DIR}" 2>/dev/null; then
        printf 'Owned host lock is busy; refusing concurrent cleanup/launch: %s\n' \
            "${HOST_LOCK_DIR}" >&2
        return 1
    fi
    HOST_LOCK_HELD=1
}

release_host_lock() {
    if [[ "${HOST_LOCK_HELD}" -ne 1 ]]; then
        return 0
    fi
    if ! rmdir "${HOST_LOCK_DIR}" 2>/dev/null; then
        printf 'Owned host lock could not be released; leaving it intact: %s\n' \
            "${HOST_LOCK_DIR}" >&2
        return 1
    fi
    HOST_LOCK_HELD=0
}

host_probe_pid() {
    /bin/kill -0 "$1" 2>/dev/null
}

host_parse_ps_identity() {
    local raw
    local start_identity
    local command

    raw="$1"
    if [[ -z "${raw}" || "${raw}" == *$'\n'* || "${#raw}" -lt 26 ]]; then
        return 1
    fi
    start_identity="${raw:0:24}"
    command="${raw:24}"
    if [[ "${command}" != [[:space:]]* ]]; then
        return 1
    fi
    command="${command#"${command%%[![:space:]]*}"}"
    if ! host_field_is_safe "${start_identity}" || ! host_field_is_safe "${command}"; then
        return 1
    fi
    printf '%s\t%s\n' "${start_identity}" "${command}"
}

host_process_identity() {
    local raw

    raw="$(LC_ALL=C /bin/ps -ww -p "$1" -o lstart=,command=)" || return 1
    host_parse_ps_identity "${raw}"
}

host_parse_process_identity() {
    local remainder="$1"

    if [[ "${remainder}" != *$'\t'* ]]; then
        return 1
    fi
    HOST_OBSERVED_START="${remainder%%$'\t'*}"
    remainder="${remainder#*$'\t'}"
    if [[ "${remainder}" == *$'\t'* ]]; then
        return 1
    fi
    HOST_OBSERVED_COMMAND="${remainder}"
    host_field_is_safe "${HOST_OBSERVED_START}" && \
        host_field_is_safe "${HOST_OBSERVED_COMMAND}"
}

host_process_matches() {
    local observed_identity

    if ! observed_identity="$(host_process_identity "$1")"; then
        return 1
    fi
    if ! host_parse_process_identity "${observed_identity}"; then
        return 1
    fi
    [[ "${HOST_OBSERVED_START}" == "$2" &&
        "${HOST_OBSERVED_COMMAND}" == "$3" ]]
}

host_parse_process_state() {
    local state="$1"

    state="${state#"${state%%[![:space:]]*}"}"
    state="${state%"${state##*[![:space:]]}"}"
    if [[ -z "${state}" || ! "${state}" =~ ${HOST_STATE_PATTERN} ]]; then
        return 1
    fi
    printf '%s\n' "${state:0:1}"
}

host_process_state() {
    local state

    state="$(LC_ALL=C /bin/ps -ww -p "$1" -o state=)" || return 1
    host_parse_process_state "${state}"
}

# Return 0 for a known live state, 1 for zombie, and 2 when state is
# unavailable, malformed, or unknown.  Callers must refuse signaling for 1/2.
host_process_state_class() {
    local state

    if ! state="$(host_process_state "$1")"; then
        return 2
    fi
    if [[ "${state}" == Z ]]; then
        return 1
    fi
    return 0
}

host_cleanup_state_check() {
    local host_pid="$1"
    local phase="$2"
    local state_status=0

    host_process_state_class "${host_pid}" || state_status=$?
    if [[ "${state_status}" -eq 0 ]]; then
        return 0
    fi
    if [[ "${state_status}" -eq 1 ]]; then
        printf 'Owned host is a zombie %s; refusing further signal: pid=%s\n' \
            "${phase}" "${host_pid}" >&2
        rm -f "${HOST_PID_FILE}"
        return 1
    fi
    printf 'Owned host state is unavailable or malformed %s; refusing cleanup: pid=%s\n' \
        "${phase}" "${host_pid}" >&2
    return 2
}

host_term_pid() {
    /bin/kill -TERM "$1" 2>/dev/null
}

host_kill_pid() {
    /bin/kill -KILL "$1" 2>/dev/null
}

host_sleep() {
    sleep 0.1
}

write_owned_host_record() {
    local pid="$1"
    local start_identity="$2"
    local expected_command="$3"
    local record_dir
    local temporary

    if [[ "$#" -ne 3 || "${HOST_LOCK_HELD}" -ne 1 ]] ||
        ! host_pid_is_valid "${pid}" ||
        ! host_field_is_safe "${start_identity}" ||
        ! host_field_is_safe "${expected_command}"; then
        return 1
    fi
    record_dir="$(dirname "${HOST_PID_FILE}")"
    mkdir -p "${record_dir}"
    temporary="$(mktemp "${HOST_PID_FILE}.XXXXXX")" || return 1
    if ! printf '%s\t%s\t%s\n' "${pid}" "${start_identity}" "${expected_command}" >"${temporary}"; then
        rm -f "${temporary}"
        return 1
    fi
    if ! mv -f "${temporary}" "${HOST_PID_FILE}"; then
        rm -f "${temporary}"
        return 1
    fi
}

host_parse_owned_host_record() {
    local remainder="$1"

    if [[ "${remainder}" != *$'\t'* ]]; then
        return 1
    fi
    HOST_RECORD_PID="${remainder%%$'\t'*}"
    remainder="${remainder#*$'\t'}"
    if [[ "${remainder}" != *$'\t'* ]]; then
        return 1
    fi
    HOST_RECORD_START="${remainder%%$'\t'*}"
    HOST_RECORD_COMMAND="${remainder#*$'\t'}"
    if [[ "${HOST_RECORD_COMMAND}" == *$'\t'* ]]; then
        return 1
    fi
    host_pid_is_valid "${HOST_RECORD_PID}" && \
        host_field_is_safe "${HOST_RECORD_START}" && \
        host_field_is_safe "${HOST_RECORD_COMMAND}"
}

host_read_owned_host_record() {
    local record_line=""
    local extra_line=""

    if ! exec 9<"${HOST_PID_FILE}"; then
        return 1
    fi
    if ! IFS= read -r record_line <&9; then
        exec 9<&-
        return 1
    fi
    if IFS= read -r extra_line <&9; then
        exec 9<&-
        return 1
    fi
    exec 9<&-
    if [[ -n "${extra_line}" ]]; then
        return 1
    fi
    host_parse_owned_host_record "${record_line}"
}

cleanup_owned_host() {
    local owned_pid
    local expected_start
    local expected_command
    local attempt
    local state_status

    if [[ "${HOST_LOCK_HELD}" -ne 1 ]]; then
        printf 'Owned host cleanup requires the exclusive lock: %s\n' "${HOST_LOCK_DIR}" >&2
        return 1
    fi
    if [[ ! -e "${HOST_PID_FILE}" ]]; then
        return 0
    fi
    if ! host_read_owned_host_record; then
        printf 'Owned host record is malformed: %s\n' "${HOST_PID_FILE}" >&2
        return 1
    fi
    owned_pid="${HOST_RECORD_PID}"
    expected_start="${HOST_RECORD_START}"
    expected_command="${HOST_RECORD_COMMAND}"
    if ! host_probe_pid "${owned_pid}"; then
        printf 'Owned host record is stale; no process was signaled: pid=%s\n' "${owned_pid}" >&2
        rm -f "${HOST_PID_FILE}"
        return 0
    fi
    if host_cleanup_state_check "${owned_pid}" 'before identity validation'; then
        :
    else
        state_status=$?
        if [[ "${state_status}" -eq 1 ]]; then
            return 0
        fi
        return 1
    fi
    if ! host_process_matches "${owned_pid}" "${expected_start}" "${expected_command}"; then
        printf 'Owned host identity mismatch; refusing cleanup: pid=%s\n' "${owned_pid}" >&2
        return 1
    fi
    if ! [[ "${HOST_TERM_GRACE_ATTEMPTS}" =~ ^[1-9][0-9]*$ ]]; then
        printf 'ACGC_HOST_TERM_GRACE_ATTEMPTS must be a positive integer, got: %s\n' \
            "${HOST_TERM_GRACE_ATTEMPTS}" >&2
        return 1
    fi

    if host_cleanup_state_check "${owned_pid}" 'before TERM'; then
        :
    else
        state_status=$?
        if [[ "${state_status}" -eq 1 ]]; then
            return 0
        fi
        return 1
    fi
    if ! host_process_matches "${owned_pid}" "${expected_start}" "${expected_command}"; then
        printf 'Owned host identity changed before TERM; refusing cleanup: pid=%s\n' \
            "${owned_pid}" >&2
        return 1
    fi
    host_term_pid "${owned_pid}" || true
    for ((attempt = 0; attempt < HOST_TERM_GRACE_ATTEMPTS; attempt++)); do
        if ! host_probe_pid "${owned_pid}"; then
            rm -f "${HOST_PID_FILE}"
            return 0
        fi
        if host_cleanup_state_check "${owned_pid}" 'during TERM grace'; then
            :
        else
            state_status=$?
            if [[ "${state_status}" -eq 1 ]]; then
                return 0
            fi
            return 1
        fi
        host_sleep
    done
    if host_cleanup_state_check "${owned_pid}" 'before KILL'; then
        :
    else
        state_status=$?
        if [[ "${state_status}" -eq 1 ]]; then
            return 0
        fi
        return 1
    fi
    if ! host_process_matches "${owned_pid}" "${expected_start}" "${expected_command}"; then
        printf 'Owned host identity changed before KILL; refusing cleanup: pid=%s\n' \
            "${owned_pid}" >&2
        return 1
    fi
    host_kill_pid "${owned_pid}" || true
    if host_probe_pid "${owned_pid}"; then
        if host_cleanup_state_check "${owned_pid}" 'after KILL'; then
            :
        else
            state_status=$?
            if [[ "${state_status}" -eq 1 ]]; then
                return 0
            fi
            return 1
        fi
        printf 'Owned host did not exit after bounded cleanup: pid=%s\n' "${owned_pid}" >&2
        return 1
    fi
    rm -f "${HOST_PID_FILE}"
}

contain_unrecorded_host() {
    local host_pid="$1"
    local attempt
    local grace_attempts=0

    # The child is still this shell's $!, so wait keeps its PID from being
    # reused while the bounded TERM/KILL containment and reap complete.
    if [[ "${HOST_TERM_GRACE_ATTEMPTS}" =~ ^[1-9][0-9]*$ ]]; then
        grace_attempts="${HOST_TERM_GRACE_ATTEMPTS}"
    fi
    if host_probe_pid "${host_pid}"; then
        host_term_pid "${host_pid}" || true
        for ((attempt = 0; attempt < grace_attempts; attempt++)); do
            if ! host_probe_pid "${host_pid}"; then
                break
            fi
            host_sleep
        done
        if host_probe_pid "${host_pid}"; then
            host_kill_pid "${host_pid}" || true
        fi
    fi
    wait "${host_pid}" 2>/dev/null || true
}

launch_owned_host() {
    local host_pid
    local observed_identity
    local observed_start
    local expected_command="${APP_BINARY} --disc ${DISC_PATH}"

    if ! host_field_is_safe "${expected_command}"; then
        printf 'Cannot record owned host command: command contains a control character.\n' >&2
        return 1
    fi
    mkdir -p "${VERIFY_HOME}"
    CFFIXED_USER_HOME="${VERIFY_HOME}" \
        "${APP_BINARY}" --disc "${DISC_PATH}" &
    host_pid=$!
    if ! observed_identity="$(host_process_identity "${host_pid}")" ||
        ! host_parse_process_identity "${observed_identity}" ||
        [[ "${HOST_OBSERVED_COMMAND}" != "${expected_command}" ]]; then
        contain_unrecorded_host "${host_pid}"
        printf 'Could not establish owned host identity; exact child was contained and reaped: pid=%s\n' \
            "${host_pid}" >&2
        return 1
    fi
    observed_start="${HOST_OBSERVED_START}"
    if ! write_owned_host_record "${host_pid}" "${observed_start}" "${expected_command}"; then
        contain_unrecorded_host "${host_pid}"
        printf 'Could not record owned host PID; exact process was stopped: pid=%s\n' \
            "${host_pid}" >&2
        return 1
    fi
    printf 'Owned host launched: pid=%s start=%s\n' "${host_pid}" "${observed_start}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
mode="${1:---run}"
if [[ $# -gt 1 ]]; then
    usage >&2
    exit 2
fi

case "${mode}" in
    --run|--verify|--headless|--debug|--logs|--telemetry)
        ;;
    --help|-h)
        usage
        exit 0
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac

if [[ ! -f "${DISC_PATH}" ]]; then
    printf 'Disc input not found: %s\n' "${DISC_PATH}" >&2
    exit 1
fi

if ! acquire_host_lock; then
    exit 1
fi
trap release_host_lock EXIT

if ! cleanup_owned_host; then
    exit 1
fi

cmake -S "${SOURCE_DIR}" -B "${BUILD_DIR}" -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DBUILD_TESTING=ON
cmake --build "${BUILD_DIR}" --parallel
ctest --test-dir "${BUILD_DIR}" --output-on-failure

case "${mode}" in
    --run)
        launch_owned_host
        ;;
    --headless)
        CFFIXED_USER_HOME="${VERIFY_HOME}" \
            "${CLI_BINARY}" --headless --disc "${DISC_PATH}"
        ;;
    --debug)
        # LLDB owns its inferior in operator debug mode. This runner records
        # no host PID for that mode; detaching leaves the inferior outside
        # automatic cleanup, so the operator must terminate rather than detach.
        /usr/bin/lldb -- "${APP_BINARY}" --disc "${DISC_PATH}"
        ;;
    --logs|--telemetry)
        if [[ "${mode}" == "--telemetry" ]]; then
            printf '%s\n' 'Structured telemetry is not implemented; streaming process logs.'
        fi
        launch_owned_host
        /usr/bin/log stream --style compact \
            --predicate "process == '${APP_NAME}'"
        ;;
    --verify)
        mkdir -p "${VERIFY_HOME}"
        app_status=0
        CFFIXED_USER_HOME="${VERIFY_HOME}" \
            "${APP_BINARY}" --disc "${DISC_PATH}" \
                --verify-frames 2 --verify-seconds 5 \
                >"${VERIFY_LOG}" 2>&1 || app_status=$?
        /bin/cat "${VERIFY_LOG}"
        if [[ "${app_status}" -ne 0 ]]; then
            printf 'Metal verification failed: app exited %d.\n' "${app_status}" >&2
            exit "${app_status}"
        fi
        if ! /usr/bin/grep -Fq \
                'Metal geometry fixture command-buffer verification PASSED: 2 completed command buffers containing clear/triangle/present' \
                "${VERIFY_LOG}"; then
            printf '%s\n' 'Metal verification failed: completion evidence was not emitted.' >&2
            exit 1
        fi
        printf '%s\n' 'Metal geometry verification passed: two command buffers containing clear/triangle/present completed and the app exited cleanly.'
        ;;
esac
fi
