#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
HARNESS="${SCRIPT_DIR}/acgc_game_frame_evidence.sh"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/acgc-game-frame-evidence-test.XXXXXX")"

cleanup() {
    rm -rf -- "$TEST_ROOT"
}
trap cleanup EXIT HUP INT TERM

assert_contains() {
    local file="$1"
    local text="$2"

    if ! grep -Fq -- "$text" "$file"; then
        printf 'missing expected output: %s\n' "$text" >&2
        sed -n '1,160p' "$file" >&2
        exit 1
    fi
}

assert_not_contains() {
    local file="$1"
    local text="$2"

    if grep -Fq -- "$text" "$file"; then
        printf 'unexpected output: %s\n' "$text" >&2
        sed -n '1,160p' "$file" >&2
        exit 1
    fi
}

run_classification() {
    local name="$1"
    local expected_status="$2"
    local expected_packet="$3"
    local expected_later_gates="$4"
    local log_path="${TEST_ROOT}/${name}.log"
    local output_path="${TEST_ROOT}/${name}.out"
    local actual_status
    shift 4

    printf '%s\n' "$@" >"$log_path"
    if "$HARNESS" --classify-only "$log_path" >"$output_path" 2>&1; then
        actual_status=0
    else
        actual_status=$?
    fi
    if [[ "$actual_status" -ne "$expected_status" ]]; then
        printf '%s expected exit %s, got %s\n' "$name" "$expected_status" "$actual_status" >&2
        sed -n '1,160p' "$output_path" >&2
        exit 1
    fi
    assert_contains "$output_path" "RESULT_GAME_OWNED_PACKET=${expected_packet}"
    assert_contains "$output_path" "RESULT_PRESENT=${expected_later_gates}"
    assert_contains "$output_path" "RESULT_FRAME=${expected_later_gates}"
    assert_contains "$output_path" 'RESULT_GATE=NOT_RUN classify_only'
}

if bash -n "$HARNESS"; then
    :
else
    printf 'harness syntax check failed\n' >&2
    exit 1
fi

run_classification synthetic 1 FAIL FAIL \
    'Metal geometry fixture command-buffer verification PASSED: clear/triangle/present' \
    'Actual game process launch gate passed: pid=123 command=AnimalCrossing'

run_classification liveness 1 FAIL FAIL \
    "Process 123 launched: '/private/tmp/build/bin/AnimalCrossing'" \
    'Actual game process launch gate passed: pid=123 command=AnimalCrossing' \
    'ACGC_HARNESS lldb_status=0 timed_out=0'

run_classification truncated 1 FAIL FAIL \
    "Process 123 launched: '/private/tmp/build/bin/AnimalCrossing'" \
    'ACGC_GAME_BOOT status=complete source=game phase=initial_menu' \
    'ACGC_GAME_OWNED_PACKET status=truncated source=game capture=truncated frame=0 count=8 words=de010000' \
    'ACGC_HARNESS lldb_status=0 timed_out=0'

run_classification packet_only 1 PASS FAIL \
    "Process 123 launched: '/private/tmp/build/bin/AnimalCrossing'" \
    'ACGC_GAME_BOOT status=complete source=game phase=initial_menu' \
    'ACGC_GAME_OWNED_PACKET status=complete source=game capture=complete frame=0 count=8 words=de010000,f0002000' \
    'ACGC_HARNESS lldb_status=0 timed_out=0'

run_classification out_of_order 1 FAIL FAIL \
    "Process 123 launched: '/private/tmp/build/bin/AnimalCrossing'" \
    'ACGC_GAME_BOOT status=complete source=game phase=initial_menu' \
    'ACGC_GAME_PRESENT status=complete source=game command_buffer=1 completion=complete' \
    'ACGC_GAME_OWNED_PACKET status=complete source=game capture=complete frame=0 count=8 words=de010000,f0002000' \
    'ACGC_GAME_FRAME status=identified source=game frame_id=0 readback=complete identity=initial_menu pixels=921600' \
    'ACGC_HARNESS lldb_status=0 timed_out=0'

run_classification complete 0 PASS PASS \
    "Process 123 launched: '/private/tmp/build/bin/AnimalCrossing'" \
    'ACGC_GAME_BOOT status=complete source=game phase=initial_menu' \
    'ACGC_GAME_OWNED_PACKET status=complete source=game capture=complete frame=0 count=8 words=de010000,f0002000' \
    'ACGC_GAME_PRESENT status=complete source=game command_buffer=1 completion=complete' \
    'ACGC_GAME_FRAME status=identified source=game frame_id=0 readback=complete identity=initial_menu pixels=921600' \
    'ACGC_HARNESS lldb_status=0 timed_out=0'

dry_run_output="${TEST_ROOT}/dry-run.out"
if "$HARNESS" --dry-run --build-dir "${TEST_ROOT}/unique-build" >"$dry_run_output" 2>&1; then
    dry_run_status=0
else
    dry_run_status=$?
fi
if [[ "$dry_run_status" -eq 0 ]]; then
    printf 'dry-run unexpectedly passed with an uninitialized source/absent ISO\n' >&2
    sed -n '1,160p' "$dry_run_output" >&2
    exit 1
fi
assert_contains "$dry_run_output" 'RESULT_SOURCE_HEAD=FAIL source_submodule_uninitialized'
assert_contains "$dry_run_output" 'RESULT_ISO=FAIL missing_or_unreadable_regular_file'
assert_contains "$dry_run_output" 'DRY_RUN_LLDB='
assert_not_contains "$dry_run_output" 'Built actual reconstructed executable'
if [[ -e "${TEST_ROOT}/unique-build" ]]; then
    printf 'dry-run created its caller-provided build directory\n' >&2
    exit 1
fi

printf '%s\n' 'ACGC game-frame evidence harness classifier and bounded dry-run checks passed.'
