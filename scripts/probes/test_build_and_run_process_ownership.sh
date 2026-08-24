#!/usr/bin/env bash

set -euo pipefail

readonly PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly FIXTURE_DIR="$(mktemp -d)"
readonly PID_FILE="${FIXTURE_DIR}/acgc_macos_native_host.pid"
readonly LOCK_DIR="${PID_FILE}.lock"
readonly IDENTITY_CALL_FILE="${FIXTURE_DIR}/identity-calls"
readonly STATE_CALL_FILE="${FIXTURE_DIR}/state-calls"
readonly IDENTITY_FLIP_FILE="${FIXTURE_DIR}/identity-flip"
readonly EXPECTED_COMMAND="/fixture/acgc_macos_native_host --disc /fixture/Animal Crossing.iso"

trap 'rm -rf "${FIXTURE_DIR}"' EXIT

export ACGC_BUILD_AND_RUN_SOURCE_ONLY=1
export ACGC_HOST_PID_FILE="${PID_FILE}"
export ACGC_HOST_TERM_GRACE_ATTEMPTS=2
source "${PROJECT_ROOT}/script/build_and_run.sh"

fake_pid=""
fake_alive=0
fake_command=""
fake_term_exits=0
fake_signals=""
fake_sleep_calls=0
fake_start=""
fake_zombie=0
fake_state=""
fake_state_error=0
fake_state_error_at=0
fake_kill_exits=1
fake_identity_flip_at=0
fake_identity_flip_state_at=0
fake_reused_start=""
fake_reused_command=""

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    exit 1
}

assert_equal() {
    local expected="$1"
    local actual="$2"
    local label="$3"
    [[ "${expected}" == "${actual}" ]] || fail "${label}: expected '${expected}', got '${actual}'"
}

assert_file_exists() {
    [[ -e "$1" ]] || fail "expected file to exist: $1"
}

assert_file_absent() {
    [[ ! -e "$1" ]] || fail "expected file to be absent: $1"
}

five_space_raw="Mon Aug 24 03:45:12 2026     ${EXPECTED_COMMAND}"
assert_equal \
    $'Mon Aug 24 03:45:12 2026\t/fixture/acgc_macos_native_host --disc /fixture/Animal Crossing.iso' \
    "$(host_parse_ps_identity "${five_space_raw}")" \
    "Darwin five-space lstart separator"
assert_equal "S" "$(host_parse_process_state ' Ss ')" "Darwin sleeping state with suffix"
assert_equal "S" "$(host_parse_process_state 'S+')" "Darwin foreground state suffix"
assert_equal "Z" "$(host_parse_process_state 'Z+')" "Darwin zombie state suffix"
if host_parse_process_state 'X+'; then
    fail "unknown process state was accepted"
fi
if host_parse_process_state ''; then
    fail "empty process state was accepted"
fi

host_probe_pid() {
    [[ "$1" == "${fake_pid}" && "${fake_alive}" -eq 1 ]]
}

host_process_identity() {
    local identity_calls

    [[ "$1" == "${fake_pid}" ]] || return 1
    printf '%s\n' call >>"${IDENTITY_CALL_FILE}"
    identity_calls="$(wc -l <"${IDENTITY_CALL_FILE}")"
    identity_calls="${identity_calls//[[:space:]]/}"
    if [[ -e "${IDENTITY_FLIP_FILE}" ||
        ( "${fake_identity_flip_at}" -gt 0 &&
        "${identity_calls}" -ge "${fake_identity_flip_at}" ) ]]; then
        printf '%s\t%s\n' "${fake_reused_start}" "${fake_reused_command}"
    else
        printf '%s\t%s\n' "${fake_start}" "${fake_command}"
    fi
}

host_process_state() {
    local state_calls

    [[ "$1" == "${fake_pid}" ]] || return 1
    printf '%s\n' call >>"${STATE_CALL_FILE}"
    state_calls="$(wc -l <"${STATE_CALL_FILE}")"
    state_calls="${state_calls//[[:space:]]/}"
    if [[ "${fake_identity_flip_state_at}" -gt 0 &&
        "${state_calls}" -ge "${fake_identity_flip_state_at}" ]]; then
        : >"${IDENTITY_FLIP_FILE}"
    fi
    if [[ "${fake_state_error}" -eq 1 ]]; then
        return 1
    fi
    if [[ "${fake_state_error_at}" -gt 0 &&
        "${state_calls}" -ge "${fake_state_error_at}" ]]; then
        return 1
    fi
    if [[ -n "${fake_state}" ]]; then
        host_parse_process_state "${fake_state}"
    elif [[ "${fake_zombie}" -eq 1 ]]; then
        printf '%s\n' 'Z'
    else
        printf '%s\n' 'S'
    fi
}

host_term_pid() {
    fake_signals+="TERM:$1 "
    if [[ "${fake_term_exits}" -eq 1 ]]; then
        fake_alive=0
    fi
}

host_kill_pid() {
    fake_signals+="KILL:$1 "
    if [[ "${fake_kill_exits}" -eq 1 ]]; then
        fake_alive=0
    fi
}

host_sleep() {
    fake_sleep_calls=$((fake_sleep_calls + 1))
}

reset_fixture() {
    fake_pid="$1"
    fake_alive="$2"
    fake_command="$3"
    fake_term_exits="$4"
    fake_signals=""
    fake_sleep_calls=0
    fake_start="$5"
    fake_zombie=0
    fake_state=""
    fake_state_error=0
    fake_state_error_at=0
    fake_kill_exits=1
    fake_identity_flip_at=0
    fake_identity_flip_state_at=0
    fake_reused_start="reused-start"
    fake_reused_command="/reused/acgc_macos_native_host --disc /fixture/Animal Crossing.iso"
    rm -f "${PID_FILE}"
    rm -f "${IDENTITY_FLIP_FILE}"
    : >"${IDENTITY_CALL_FILE}"
    rmdir "${LOCK_DIR}" 2>/dev/null || true
    : >"${STATE_CALL_FILE}"
}

write_record() {
    acquire_host_lock || fail "could not acquire fixture lock"
    write_owned_host_record "$1" "$3" "$2" || fail "could not write fixture record"
    release_host_lock || fail "could not release fixture lock"
}

run_cleanup() {
    acquire_host_lock || fail "could not acquire fixture cleanup lock"
    cleanup_owned_host
    local status=$?
    release_host_lock || fail "could not release fixture cleanup lock"
    return "${status}"
}

reset_fixture 4101 1 "${EXPECTED_COMMAND}" 1 start-4101
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
run_cleanup || fail "owned PID cleanup failed"
assert_equal "TERM:4101 " "${fake_signals}" "owned PID signal sequence"
assert_file_absent "${PID_FILE}"
run_cleanup || fail "cleanup was not idempotent"
assert_equal "TERM:4101 " "${fake_signals}" "idempotent signal sequence"

reset_fixture 4102 1 "/unowned/acgc_macos_native_host --disc /fixture/Animal Crossing.iso" 1 start-4102
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
if run_cleanup; then
    fail "identity mismatch was accepted"
fi
assert_equal "" "${fake_signals}" "identity mismatch signals"
assert_file_exists "${PID_FILE}"
rm -f "${PID_FILE}"

reset_fixture 4103 0 "${EXPECTED_COMMAND}" 1 start-4103
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
run_cleanup || fail "stale record handling failed"
assert_equal "" "${fake_signals}" "stale record signals"
assert_file_absent "${PID_FILE}"

reset_fixture 4104 1 "${EXPECTED_COMMAND}" 1 start-4104
fake_zombie=1
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
run_cleanup || fail "zombie record handling failed"
assert_equal "" "${fake_signals}" "zombie record signals"
assert_file_absent "${PID_FILE}"

reset_fixture 4105 1 "${EXPECTED_COMMAND}" 1 start-4105
acquire_host_lock || fail "could not acquire malformed-record lock"
printf '%s\t%s\t%s\n' 'not-a-pid' "${fake_start}" "${EXPECTED_COMMAND}" >"${PID_FILE}"
release_host_lock || fail "could not release malformed-record lock"
if run_cleanup; then
    fail "malformed record was accepted"
fi
assert_equal "" "${fake_signals}" "malformed record signals"
assert_file_exists "${PID_FILE}"
rm -f "${PID_FILE}"

reset_fixture 4106 1 "${EXPECTED_COMMAND}" 0 start-4106
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
run_cleanup || fail "bounded fallback cleanup failed"
assert_equal "TERM:4106 KILL:4106 " "${fake_signals}" "bounded fallback signal sequence"
assert_equal "2" "${fake_sleep_calls}" "bounded fallback grace probes"
assert_file_absent "${PID_FILE}"

reset_fixture 4107 1 "${EXPECTED_COMMAND}" 1 start-4107
acquire_host_lock || fail "could not acquire extra-line lock"
printf '%s\t%s\t%s\nextra\n' "${fake_pid}" "${fake_start}" "${EXPECTED_COMMAND}" >"${PID_FILE}"
release_host_lock || fail "could not release extra-line lock"
if run_cleanup; then
    fail "extra-line record was accepted"
fi
assert_equal "" "${fake_signals}" "extra-line signals"
assert_file_exists "${PID_FILE}"
rm -f "${PID_FILE}"

reset_fixture 4108 1 "${EXPECTED_COMMAND}" 1 start-4108
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
fake_identity_flip_at=2
if run_cleanup; then
    fail "PID reuse before TERM was accepted"
fi
assert_equal "" "${fake_signals}" "PID reuse before TERM signals"
assert_file_exists "${PID_FILE}"

reset_fixture 4109 1 "${EXPECTED_COMMAND}" 0 start-4109
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
fake_identity_flip_at=3
if run_cleanup; then
    fail "PID reuse before KILL was accepted"
fi
assert_equal "TERM:4109 " "${fake_signals}" "PID reuse before KILL signals"
assert_file_exists "${PID_FILE}"

reset_fixture 4113 1 "${EXPECTED_COMMAND}" 1 start-4113
fake_state='S+'
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
run_cleanup || fail "S+ live-state cleanup failed"
assert_equal "TERM:4113 " "${fake_signals}" "S+ live-state signal sequence"
assert_file_absent "${PID_FILE}"

reset_fixture 4114 1 "${EXPECTED_COMMAND}" 1 start-4114
fake_state='Z+'
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
run_cleanup || fail "Z+ zombie-state cleanup failed"
assert_equal "" "${fake_signals}" "Z+ zombie-state signals"
assert_file_absent "${PID_FILE}"

reset_fixture 4115 1 "${EXPECTED_COMMAND}" 1 start-4115
fake_state_error=1
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
if run_cleanup; then
    fail "initial state-query error was accepted"
fi
assert_equal "" "${fake_signals}" "initial state-query error signals"
assert_file_exists "${PID_FILE}"
rm -f "${PID_FILE}"

reset_fixture 4116 1 "${EXPECTED_COMMAND}" 0 start-4116
fake_state_error_at=3
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
if run_cleanup; then
    fail "TERM-grace state-query error was accepted"
fi
assert_equal "TERM:4116 " "${fake_signals}" "TERM-grace state-query error signals"
assert_file_exists "${PID_FILE}"
rm -f "${PID_FILE}"

reset_fixture 4117 1 "${EXPECTED_COMMAND}" 0 start-4117
fake_state_error_at=5
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
if run_cleanup; then
    fail "pre-KILL state-query error was accepted"
fi
assert_equal "TERM:4117 " "${fake_signals}" "pre-KILL state-query error signals"
assert_file_exists "${PID_FILE}"
rm -f "${PID_FILE}"

reset_fixture 4118 1 "${EXPECTED_COMMAND}" 0 start-4118
fake_state_error_at=6
fake_kill_exits=0
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
if run_cleanup; then
    fail "post-KILL state-query error was accepted"
fi
assert_equal "TERM:4118 KILL:4118 " "${fake_signals}" "post-KILL state-query error signals"
assert_file_exists "${PID_FILE}"
rm -f "${PID_FILE}"

reset_fixture 4119 1 "${EXPECTED_COMMAND}" 1 start-4119
fake_identity_flip_state_at=2
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
if run_cleanup; then
    fail "state-query PID reuse before TERM was accepted"
fi
assert_equal "" "${fake_signals}" "state-query PID reuse before TERM signals"
assert_file_exists "${PID_FILE}"
rm -f "${PID_FILE}"

reset_fixture 4120 1 "${EXPECTED_COMMAND}" 0 start-4120
fake_identity_flip_state_at=5
write_record "${fake_pid}" "${EXPECTED_COMMAND}" "${fake_start}"
if run_cleanup; then
    fail "state-query PID reuse before KILL was accepted"
fi
assert_equal "TERM:4120 " "${fake_signals}" "state-query PID reuse before KILL signals"
assert_file_exists "${PID_FILE}"
rm -f "${PID_FILE}"

reset_fixture 4110 1 "${EXPECTED_COMMAND}" 1 start-4110
mkdir "${LOCK_DIR}"
if acquire_host_lock; then
    fail "concurrent lock contention was accepted"
fi
assert_file_absent "${PID_FILE}"
assert_file_exists "${LOCK_DIR}"
rmdir "${LOCK_DIR}" || fail "could not remove fixture contention lock"
assert_file_absent "${LOCK_DIR}"

reset_fixture 4111 1 "${EXPECTED_COMMAND}" 0 start-4111
contain_unrecorded_host "${fake_pid}"
assert_equal "TERM:4111 KILL:4111 " "${fake_signals}" "record-write failure containment signals"
assert_equal "2" "${fake_sleep_calls}" "record-write failure containment grace probes"

reset_fixture 4112 0 "${EXPECTED_COMMAND}" 0 start-4112
contain_unrecorded_host "${fake_pid}"
assert_equal "" "${fake_signals}" "exited-child containment signals"

printf '%s\n' 'Process ownership fixture passed: atomic lock, exact record, identity, stale/zombie, state suffix/error, malformed/extra-line, PID reuse, containment, fallback, and idempotence cases.'
