#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(CDPATH='' cd -- "${SCRIPT_DIR}/../.." && pwd -P)"
SOURCE_REL="upstream/ACGC-PC-Port"
SOURCE_DIR="${ROOT_DIR}/${SOURCE_REL}"
LAUNCHER="${ROOT_DIR}/script/build_and_run_game.sh"
DEFAULT_DISC_PATH="${ROOT_DIR}/local/roms/Animal Crossing (USA).iso"
GAME_BINARY_NAME="AnimalCrossing"
LLDB_BIN="${ACGC_LLDB_BIN:-/usr/bin/lldb}"
GIT_BIN="$(command -v git)"
GREP_BIN="$(command -v grep)"
AWK_BIN="$(command -v awk)"

readonly SCRIPT_DIR ROOT_DIR SOURCE_REL SOURCE_DIR LAUNCHER DEFAULT_DISC_PATH
readonly GAME_BINARY_NAME LLDB_BIN GIT_BIN GREP_BIN AWK_BIN

MODE=""
BUILD_DIR_INPUT=""
BUILD_DIR=""
DISC_INPUT="${ACGC_DISC_PATH:-${DEFAULT_DISC_PATH}}"
EVIDENCE_LOG_INPUT=""
LLDB_COMMAND_FILE=""
TIMEOUT_SECONDS="${ACGC_GAME_FRAME_TIMEOUT_SECONDS:-30}"
CLASSIFY_LOG=""

usage() {
    cat <<'EOF'
Usage:
  scripts/probes/acgc_game_frame_evidence.sh --dry-run --build-dir DIR [options]
  scripts/probes/acgc_game_frame_evidence.sh --run --build-dir DIR [options]
  scripts/probes/acgc_game_frame_evidence.sh --classify-only LOG

The production modes must be run from the umbrella repository root. They verify
the current repository HEAD, the checked-in ACGC-PC-Port gitlink, an initialized
and clean source checkout at that exact HEAD, and an ignored local/roms/*.iso
input from the same Git repository family. The ISO is read only by the existing
launcher for its own hash gate; this harness never prints or copies disc bytes.

--dry-run                    Perform preflight, print bounded build/LLDB commands,
                             and do not build, launch, or create a build directory.
--run                        Build through script/build_and_run_game.sh --build,
                             then run its documented direct LLDB target path in
                             batch mode with a deadline and classify its log.
--build-dir DIR              Required in production modes. Absolute, caller-owned
                             build directory; no default is supplied.
--disc PATH                  Optional ignored local/roms/*.iso override. Relative
                             paths are resolved from the umbrella root.
--evidence-log PATH          Optional log path below DIR. Defaults to the LLDB log
                             below the caller-provided build directory.
--lldb-command-file PATH     Optional LLDB setup command file. It may set
                             breakpoints/commands but must not contain run/quit.
--timeout-seconds N          Bounded LLDB supervisor deadline, 1..300 seconds
                             (default: ACGC_GAME_FRAME_TIMEOUT_SECONDS or 30).
--classify-only LOG          Classify a captured log for tests/review only. This
                             mode never verifies repository, source, ISO, or build
                             provenance and can never report RESULT_GATE=PASS.

The live process must emit complete, game-owned evidence records. The stable
record forms are:

  ACGC_GAME_LAUNCH status=started source=game
  ACGC_GAME_BOOT status=complete source=game phase=initial_menu
  ACGC_GAME_OWNED_PACKET status=complete source=game capture=complete frame=0 count=8 words=...
  ACGC_GAME_PRESENT status=complete source=game command_buffer=1 completion=complete
  ACGC_GAME_FRAME status=identified source=game frame_id=0 readback=complete identity=... pixels=1

Fixture/synthetic records, host-liveness text, incomplete/truncated records, and
the existing Metal clear/triangle fixture are deliberately not accepted as a
game-owned frame. A production gate is PASS only when all five records occur in
order under a successful bounded LLDB run.
EOF
}

usage_error() {
    printf 'error: %s\n' "$1" >&2
    usage >&2
    exit 2
}

emit_result() {
    local label="$1"
    local status="$2"
    shift 2
    if [[ "$#" -gt 0 ]]; then
        printf 'RESULT_%s=%s %s\n' "$label" "$status" "$*"
    else
        printf 'RESULT_%s=%s\n' "$label" "$status"
    fi
}

set_mode() {
    local requested="$1"

    if [[ -n "$MODE" && "$MODE" != "$requested" ]]; then
        usage_error "choose exactly one of --dry-run, --run, or --classify-only"
    fi
    MODE="$requested"
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --dry-run)
            set_mode dry-run
            shift
            ;;
        --run)
            set_mode run
            shift
            ;;
        --classify-only)
            set_mode classify-only
            if [[ "$#" -lt 2 ]]; then
                usage_error "--classify-only requires a log path"
            fi
            CLASSIFY_LOG="$2"
            shift 2
            ;;
        --build-dir)
            if [[ "$#" -lt 2 ]]; then
                usage_error "--build-dir requires a path"
            fi
            BUILD_DIR_INPUT="$2"
            shift 2
            ;;
        --disc)
            if [[ "$#" -lt 2 ]]; then
                usage_error "--disc requires a path"
            fi
            DISC_INPUT="$2"
            shift 2
            ;;
        --evidence-log)
            if [[ "$#" -lt 2 ]]; then
                usage_error "--evidence-log requires a path"
            fi
            EVIDENCE_LOG_INPUT="$2"
            shift 2
            ;;
        --lldb-command-file)
            if [[ "$#" -lt 2 ]]; then
                usage_error "--lldb-command-file requires a path"
            fi
            LLDB_COMMAND_FILE="$2"
            shift 2
            ;;
        --timeout-seconds)
            if [[ "$#" -lt 2 ]]; then
                usage_error "--timeout-seconds requires a positive integer"
            fi
            TIMEOUT_SECONDS="$2"
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            usage_error "unknown option: $1"
            ;;
    esac
done

if [[ -z "$MODE" ]]; then
    usage_error "one of --dry-run, --run, or --classify-only is required"
fi

if [[ "$MODE" == "classify-only" ]]; then
    if [[ -n "$BUILD_DIR_INPUT" || -n "$EVIDENCE_LOG_INPUT" ||
        -n "$LLDB_COMMAND_FILE" || "$DISC_INPUT" != "${ACGC_DISC_PATH:-${DEFAULT_DISC_PATH}}" ]]; then
        usage_error "--classify-only cannot be combined with production-mode options"
    fi
else
    if [[ -z "$BUILD_DIR_INPUT" ]]; then
        usage_error "--build-dir is required in production modes"
    fi
fi

if ! [[ "$TIMEOUT_SECONDS" =~ ^[1-9][0-9]*$ ]] ||
    (( TIMEOUT_SECONDS > 300 )); then
    usage_error "--timeout-seconds must be an integer from 1 through 300"
fi

resolve_input_path() {
    local input="$1"
    local parent
    local base

    if [[ "$input" == /* ]]; then
        parent="$(dirname -- "$input")"
        base="$(basename -- "$input")"
    else
        parent="${ROOT_DIR}/$(dirname -- "$input")"
        base="$(basename -- "$input")"
    fi

    if [[ ! -d "$parent" ]]; then
        return 1
    fi
    (CDPATH='' cd -P -- "$parent" && printf '%s/%s\n' "$PWD" "$base")
}

canonical_git_common_dir() {
    local repo_root="$1"
    local common_dir

    common_dir="$("$GIT_BIN" -C "$repo_root" rev-parse --git-common-dir 2>/dev/null)" ||
        return 1
    if [[ "$common_dir" == /* ]]; then
        (CDPATH='' cd -P -- "$common_dir" && pwd -P)
    else
        (CDPATH='' cd -P -- "${repo_root}/${common_dir}" && pwd -P)
    fi
}

canonical_build_dir() {
    local input="$1"
    local parent
    local base

    if [[ "$input" != /* || "$input" == "/" || "$input" == */ ]]; then
        return 1
    fi
    if [[ -e "$input" || -L "$input" ]]; then
        return 1
    fi

    parent="$(dirname -- "$input")"
    base="$(basename -- "$input")"
    if [[ ! -d "$parent" ]]; then
        return 1
    fi
    (CDPATH='' cd -P -- "$parent" && printf '%s/%s\n' "$PWD" "$base")
}

validate_build_dir() {
    local status=PASS
    local reason="caller-provided"
    local relative

    if ! BUILD_DIR="$(canonical_build_dir "$BUILD_DIR_INPUT")"; then
        status=FAIL
        reason="must_be_fresh_absolute_path_with_existing_parent"
    elif [[ "$BUILD_DIR" == "$ROOT_DIR" ||
        "$BUILD_DIR" == "${ROOT_DIR}/upstream" ||
        "$BUILD_DIR" == "${ROOT_DIR}/upstream/"* ]]; then
        status=FAIL
        reason="source_or_repository_root_is_not_a_build_directory"
    elif [[ "$BUILD_DIR" == "${ROOT_DIR}/"* ]]; then
        relative="${BUILD_DIR#"${ROOT_DIR}"/}"
        if [[ "$relative" != "local/build" && "$relative" != "local/build/"* ]]; then
            status=FAIL
            reason="repository_builds_must_stay_under_ignored_local_build"
        fi
    fi
    if [[ "$status" == PASS && -d "$BUILD_DIR" && ! -w "$BUILD_DIR" ]]; then
        status=FAIL
        reason="build_directory_is_not_writable"
    elif [[ "$status" == PASS && ! -w "$(dirname -- "$BUILD_DIR")" ]]; then
        status=FAIL
        reason="build_parent_is_not_writable"
    fi

    emit_result BUILD_DIR "$status" "${reason} path=${BUILD_DIR_INPUT}"
    [[ "$status" == PASS ]]
}

verify_disc() {
    local status=PASS
    local reason="ignored_untracked_regular_file"
    local disc_path=""
    local disc_dir=""
    local disc_repo_root=""
    local disc_relative=""
    local root_common=""
    local disc_common=""
    local tracked=0

    if ! disc_path="$(resolve_input_path "$DISC_INPUT")"; then
        status=FAIL
        reason="path_parent_missing"
    elif [[ ! -f "$disc_path" || ! -r "$disc_path" ]]; then
        status=FAIL
        reason="missing_or_unreadable_regular_file"
    else
        disc_dir="$(dirname -- "$disc_path")"
        disc_repo_root="$("$GIT_BIN" -C "$disc_dir" rev-parse --show-toplevel 2>/dev/null || true)"
        if [[ -z "$disc_repo_root" ]]; then
            status=FAIL
            reason="input_is_not_inside_a_git_worktree"
        else
            disc_relative="${disc_path#"${disc_repo_root}"/}"
            root_common="$(canonical_git_common_dir "$ROOT_DIR" 2>/dev/null || true)"
            disc_common="$(canonical_git_common_dir "$disc_repo_root" 2>/dev/null || true)"
            if [[ -z "$root_common" || "$root_common" != "$disc_common" ]]; then
                status=FAIL
                reason="input_is_not_from_this_umbrella_repository_family"
            elif [[ "$disc_relative" != local/roms/*.iso ]]; then
                status=FAIL
                reason="input_is_not_an_ignored_local_roms_iso"
            elif ! "$GIT_BIN" -C "$disc_repo_root" check-ignore -q -- "$disc_relative"; then
                status=FAIL
                reason="input_path_is_not_ignored"
            elif "$GIT_BIN" -C "$disc_repo_root" ls-files --error-unmatch -- "$disc_relative" >/dev/null 2>&1; then
                tracked=1
                status=FAIL
                reason="input_path_is_tracked"
            else
                DISC_PATH="$disc_path"
            fi
        fi
    fi

    emit_result ISO "$status" "${reason} relative=${disc_relative:-unresolved} tracked=${tracked}"
    [[ "$status" == PASS ]]
}

verify_repository_and_source() {
    local preflight_ok=1
    local current_pwd
    local repo_top
    local repo_head
    local repo_status=PASS
    local repo_reason="head_unmodified"
    local recorded_source_head
    local index_source_head
    local source_status=PASS
    local source_reason="clean_at_recorded_gitlink"
    local actual_source_root=""
    local actual_source_head=""
    local source_dirty=""

    current_pwd="$(pwd -P)"
    if [[ "$current_pwd" == "$ROOT_DIR" ]]; then
        emit_result CWD PASS root_verified
    else
        emit_result CWD FAIL must_run_from_umbrella_root
        preflight_ok=0
    fi

    repo_top="$("$GIT_BIN" -C "$ROOT_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
    repo_head="$("$GIT_BIN" -C "$ROOT_DIR" rev-parse HEAD 2>/dev/null || true)"
    # shellcheck disable=SC2016
    recorded_source_head="$("$GIT_BIN" -C "$ROOT_DIR" ls-tree HEAD -- "$SOURCE_REL" |
        "$AWK_BIN" '{print $3}' || true)"
    # shellcheck disable=SC2016
    index_source_head="$("$GIT_BIN" -C "$ROOT_DIR" ls-files -s -- "$SOURCE_REL" |
        "$AWK_BIN" '{print $2}' || true)"

    if [[ "$repo_top" != "$ROOT_DIR" ]]; then
        repo_status=FAIL
        repo_reason=git_root_mismatch
    elif ! [[ "$repo_head" =~ ^[0-9a-fA-F]{40}$ ]]; then
        repo_status=FAIL
        repo_reason=repo_head_unavailable
    elif [[ -z "$recorded_source_head" || "$index_source_head" != "$recorded_source_head" ]]; then
        repo_status=FAIL
        repo_reason=source_gitlink_changed_from_repo_head
    fi
    emit_result REPO_HEAD "$repo_status" "${repo_reason} head=${repo_head:-unavailable}"
    if [[ "$repo_status" != PASS ]]; then
        preflight_ok=0
    fi

    if [[ ! -e "${SOURCE_DIR}/.git" ]]; then
        source_status=FAIL
        source_reason=source_submodule_uninitialized
    else
        actual_source_root="$("$GIT_BIN" -C "$SOURCE_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
        actual_source_head="$("$GIT_BIN" -C "$SOURCE_DIR" rev-parse HEAD 2>/dev/null || true)"
        source_dirty="$("$GIT_BIN" -C "$SOURCE_DIR" status --porcelain --untracked-files=all 2>/dev/null || true)"
        if [[ "$actual_source_root" != "$SOURCE_DIR" ]]; then
            source_status=FAIL
            source_reason=source_git_root_mismatch
        elif ! [[ "$actual_source_head" =~ ^[0-9a-fA-F]{40}$ ]]; then
            source_status=FAIL
            source_reason=source_head_unavailable
        elif [[ -z "$recorded_source_head" || "$actual_source_head" != "$recorded_source_head" ]]; then
            source_status=FAIL
            source_reason=source_head_does_not_match_umbrella_gitlink
        elif [[ -n "$source_dirty" ]]; then
            source_status=FAIL
            source_reason=source_checkout_dirty
        fi
    fi
    emit_result SOURCE_HEAD "$source_status" \
        "${source_reason} expected=${recorded_source_head:-unavailable} actual=${actual_source_head:-unavailable}"
    if [[ "$source_status" != PASS ]]; then
        preflight_ok=0
    fi

    [[ "$preflight_ok" -eq 1 ]]
}

verify_runtime_inputs() {
    local preflight_ok=1

    if ! validate_build_dir; then
        preflight_ok=0
    fi
    if ! verify_disc; then
        preflight_ok=0
    fi

    if [[ ! -x "$LAUNCHER" ]]; then
        emit_result LAUNCHER FAIL documented_launcher_missing_or_not_executable
        preflight_ok=0
    else
        emit_result LAUNCHER PASS documented_actual_game_launcher
    fi

    if [[ ! -x "$LLDB_BIN" ]]; then
        emit_result LLDB FAIL lldb_missing_or_not_executable
        preflight_ok=0
    else
        emit_result LLDB PASS batch_debugger_available
    fi

    if [[ -n "$LLDB_COMMAND_FILE" && ! -f "$LLDB_COMMAND_FILE" ]]; then
        emit_result LLDB_COMMANDS FAIL command_file_missing
        preflight_ok=0
    elif [[ -n "$LLDB_COMMAND_FILE" ]]; then
        emit_result LLDB_COMMANDS PASS setup_file_present
    else
        emit_result LLDB_COMMANDS PASS default_run_status_quit_sequence
    fi

    [[ "$preflight_ok" -eq 1 ]]
}

emit_not_run_results() {
    local status="$1"
    local reason="$2"

    emit_result BUILD "$status" "$reason"
    emit_result SUPERVISOR "$status" "$reason"
    emit_result LAUNCH "$status" "$reason"
    emit_result BOOT "$status" "$reason"
    emit_result GAME_OWNED_PACKET "$status" "$reason"
    emit_result PRESENT "$status" "$reason"
    emit_result FRAME "$status" "$reason"
}

print_dry_run_commands() {
    local build_dir_for_plan="${BUILD_DIR:-${BUILD_DIR_INPUT}}"
    local binary="${build_dir_for_plan}/bin/${GAME_BINARY_NAME}"

    printf 'DRY_RUN_BUILD=ACGC_GAME_BUILD_DIR=%s ACGC_DISC_PATH=<ignored-local-iso> %s --build\n' \
        "$build_dir_for_plan" "$LAUNCHER"
    if [[ -n "$LLDB_COMMAND_FILE" ]]; then
        printf 'DRY_RUN_LLDB=(cd %s/bin && %s --batch --no-lldbinit --source %s -o run -o "process status" -o quit -- %s --verbose)\n' \
            "$build_dir_for_plan" "$LLDB_BIN" "$LLDB_COMMAND_FILE" "$binary"
    else
        printf 'DRY_RUN_LLDB=(cd %s/bin && %s --batch --no-lldbinit -o run -o "process status" -o quit -- %s --verbose)\n' \
            "$build_dir_for_plan" "$LLDB_BIN" "$binary"
    fi
}

REJECT_LINE_PATTERN='synthetic|fixture|expected[_ -]?failure|source=(fixture|synthetic|host)|kind=(fixture|synthetic|host[-_ ]?liveness)|status=(truncated|incomplete)|capture=(truncated|incomplete)|truncated=1|incomplete=1'

has_real_line() {
    local pattern="$1"

    "$GREP_BIN" -E -i "$pattern" "$EVIDENCE_LOG" |
        "$GREP_BIN" -E -i -v "$REJECT_LINE_PATTERN" >/dev/null 2>&1
}

has_event_record() {
    local event="$1"
    local fields="$2"

    "$GREP_BIN" -E -i "$event" "$EVIDENCE_LOG" |
        "$GREP_BIN" -E -i "$fields" |
        "$GREP_BIN" -E -i -v "$REJECT_LINE_PATTERN" >/dev/null 2>&1
}

first_real_line_number() {
    local pattern="$1"

    # shellcheck disable=SC2016
    "$GREP_BIN" -n -E -i "$pattern" "$EVIDENCE_LOG" |
        "$GREP_BIN" -E -i -v "$REJECT_LINE_PATTERN" |
        "$AWK_BIN" -F: 'NR == 1 {print $1; exit}' || true
}

event_line_number() {
    local event="$1"
    local fields="$2"

    # shellcheck disable=SC2016
    "$GREP_BIN" -n -E -i "$event" "$EVIDENCE_LOG" |
        "$GREP_BIN" -E -i "$fields" |
        "$GREP_BIN" -E -i -v "$REJECT_LINE_PATTERN" |
        "$AWK_BIN" -F: 'NR == 1 {print $1; exit}' || true
}

classify_evidence() {
    local allow_gate="$1"
    local harness_ok=0
    local launch_ok=0
    local boot_ok=0
    local packet_ok=0
    local present_ok=0
    local frame_ok=0
    local hard_block=0
    local all_ok=0
    local launch_line=""
    local boot_line=""
    local packet_line=""
    local present_line=""
    local frame_line=""

    if [[ ! -f "$EVIDENCE_LOG" || ! -r "$EVIDENCE_LOG" ]]; then
        emit_result SUPERVISOR FAIL evidence_log_missing_or_unreadable
        emit_result LAUNCH FAIL evidence_log_missing_or_unreadable
        emit_result BOOT FAIL evidence_log_missing_or_unreadable
        emit_result GAME_OWNED_PACKET FAIL evidence_log_missing_or_unreadable
        emit_result PRESENT FAIL evidence_log_missing_or_unreadable
        emit_result FRAME FAIL evidence_log_missing_or_unreadable
        if [[ "$allow_gate" -eq 1 ]]; then
            emit_result GATE FAIL evidence_log_missing_or_unreadable
        else
            emit_result GATE NOT_RUN classify_only
        fi
        return 1
    fi

    if "$GREP_BIN" -E -i -q \
        'ACGC_(SYNTHETIC|FIXTURE)|synthetic=1|fixture=1|EXPECTED_FAILURE|source=(fixture|synthetic)|kind=(fixture|synthetic|host[-_ ]?liveness)|((capture|packet|present|frame).*(truncated|incomplete)|((truncated|incomplete).*(capture|packet|present|frame)))' \
        "$EVIDENCE_LOG"; then
        hard_block=1
    fi

    if has_real_line 'ACGC_HARNESS[[:space:]]+lldb_status=0[[:space:]]+timed_out=0'; then
        harness_ok=1
    fi
    if has_real_line 'Process[[:space:]]+[0-9]+[[:space:]]+launched:.*AnimalCrossing' ||
        has_event_record 'ACGC_GAME_LAUNCH' 'status=(started|running|complete|pass).*source=(game|ac_pc)'; then
        launch_ok=1
    fi
    if [[ "$launch_ok" -eq 1 ]] &&
        (has_event_record 'ACGC_GAME_BOOT' 'status=(complete|reached|pass).*source=(game|ac_pc)' ||
            has_real_line '(^|[^[:alnum:]_])(COPYDATE|initial_menu_init|dvderr_init|sound_initial2|HotStartEntry|NEOS_OUT)([^[:alnum:]_]|$)'); then
        boot_ok=1
    fi
    if [[ "$hard_block" -eq 0 && "$boot_ok" -eq 1 ]] &&
        has_event_record 'ACGC_GAME_OWNED_PACKET' \
            'status=(complete|captured|pass).*source=(game|ac_pc).*capture=(complete|full|pass).*count=[1-9][0-9]*.*words=[0-9a-fx,]+'; then
        packet_ok=1
    fi
    if [[ "$hard_block" -eq 0 && "$packet_ok" -eq 1 ]] &&
        has_event_record 'ACGC_GAME_PRESENT' \
            'status=(complete|presented|pass).*source=(game|ac_pc).*command_buffer=[0-9]+.*completion=(complete|completed|pass)'; then
        present_ok=1
    fi
    if [[ "$hard_block" -eq 0 && "$present_ok" -eq 1 ]] &&
        has_event_record 'ACGC_GAME_FRAME' \
            'status=(identified|complete|pass).*source=(game|ac_pc).*frame_id=[0-9]+.*readback=(complete|pass).*identity=[^[:space:]]+.*pixels=[1-9][0-9]*'; then
        frame_ok=1
    fi

    launch_line="$(first_real_line_number 'Process[[:space:]]+[0-9]+[[:space:]]+launched:.*AnimalCrossing')"
    if [[ -z "$launch_line" ]]; then
        launch_line="$(event_line_number 'ACGC_GAME_LAUNCH' 'status=(started|running|complete|pass).*source=(game|ac_pc)')"
    fi
    boot_line="$(event_line_number 'ACGC_GAME_BOOT' 'status=(complete|reached|pass).*source=(game|ac_pc)')"
    if [[ -z "$boot_line" ]]; then
        boot_line="$(first_real_line_number '(^|[^[:alnum:]_])(COPYDATE|initial_menu_init|dvderr_init|sound_initial2|HotStartEntry|NEOS_OUT)([^[:alnum:]_]|$)')"
    fi
    packet_line="$(event_line_number 'ACGC_GAME_OWNED_PACKET' 'status=(complete|captured|pass).*source=(game|ac_pc).*capture=(complete|full|pass).*count=[1-9][0-9]*.*words=[0-9a-fx,]+')"
    present_line="$(event_line_number 'ACGC_GAME_PRESENT' 'status=(complete|presented|pass).*source=(game|ac_pc).*command_buffer=[0-9]+.*completion=(complete|completed|pass)')"
    frame_line="$(event_line_number 'ACGC_GAME_FRAME' 'status=(identified|complete|pass).*source=(game|ac_pc).*frame_id=[0-9]+.*readback=(complete|pass).*identity=[^[:space:]]+.*pixels=[1-9][0-9]*')"
    if [[ "$launch_ok" -eq 1 && "$boot_ok" -eq 1 && "$packet_ok" -eq 1 &&
        "$present_ok" -eq 1 && "$frame_ok" -eq 1 ]] &&
        [[ "$launch_line" =~ ^[0-9]+$ && "$boot_line" =~ ^[0-9]+$ &&
            "$packet_line" =~ ^[0-9]+$ && "$present_line" =~ ^[0-9]+$ &&
            "$frame_line" =~ ^[0-9]+$ ]] &&
        ! (( launch_line < boot_line && boot_line < packet_line &&
            packet_line < present_line && present_line < frame_line )); then
        packet_ok=0
        present_ok=0
        frame_ok=0
    fi

    if [[ "$harness_ok" -eq 1 ]]; then
        emit_result SUPERVISOR PASS bounded_lldb_completed
    else
        emit_result SUPERVISOR FAIL lldb_nonzero_or_timeout_or_missing_harness_record
    fi
    if [[ "$launch_ok" -eq 1 ]]; then
        emit_result LAUNCH PASS real_game_process_launched_under_lldb
    else
        emit_result LAUNCH FAIL no_real_game_lldb_launch_record
    fi
    if [[ "$boot_ok" -eq 1 ]]; then
        emit_result BOOT PASS game_boot_boundary_reached
    else
        emit_result BOOT FAIL no_complete_game_boot_record
    fi
    if [[ "$packet_ok" -eq 1 ]]; then
        emit_result GAME_OWNED_PACKET PASS complete_nonfixture_packet
    elif [[ "$hard_block" -eq 1 ]]; then
        emit_result GAME_OWNED_PACKET FAIL synthetic_fixture_or_truncated_capture_rejected
    else
        emit_result GAME_OWNED_PACKET FAIL no_complete_game_owned_packet
    fi
    if [[ "$present_ok" -eq 1 ]]; then
        emit_result PRESENT PASS complete_game_owned_presentation
    else
        emit_result PRESENT FAIL no_complete_game_owned_presentation
    fi
    if [[ "$frame_ok" -eq 1 ]]; then
        emit_result FRAME PASS identified_game_frame_with_complete_readback
    else
        emit_result FRAME FAIL no_identifiable_game_frame_with_complete_readback
    fi

    if [[ "$harness_ok" -eq 1 && "$launch_ok" -eq 1 && "$boot_ok" -eq 1 &&
        "$packet_ok" -eq 1 && "$present_ok" -eq 1 && "$frame_ok" -eq 1 ]]; then
        all_ok=1
    fi
    if [[ "$allow_gate" -eq 1 ]]; then
        if [[ "$all_ok" -eq 1 ]]; then
            emit_result GATE PASS actual_game_frame_gate
            return 0
        fi
        emit_result GATE FAIL frame_gate_requirements_not_all_satisfied
        return 1
    fi

    emit_result GATE NOT_RUN classify_only
    if [[ "$all_ok" -eq 1 ]]; then
        return 0
    fi
    return 1
}

run_bounded_lldb() {
    local lldb_pid
    local elapsed
    local grace
    local status=0
    local timed_out=0
    local binary="${BUILD_DIR}/bin/${GAME_BINARY_NAME}"
    local lldb_args=(--batch --no-lldbinit)

    if [[ -n "$LLDB_COMMAND_FILE" ]]; then
        lldb_args+=(--source "$LLDB_COMMAND_FILE")
    fi
    lldb_args+=(-o run -o 'process status' -o quit -- "$binary" --verbose)

    (CDPATH='' cd -- "${BUILD_DIR}/bin" && "$LLDB_BIN" "${lldb_args[@]}") \
        >"$EVIDENCE_LOG" 2>&1 &
    lldb_pid=$!

    for ((elapsed = 0; elapsed < TIMEOUT_SECONDS * 10; elapsed++)); do
        if ! kill -0 "$lldb_pid" 2>/dev/null; then
            wait "$lldb_pid" || status=$?
            break
        fi
        sleep 0.1
    done

    if kill -0 "$lldb_pid" 2>/dev/null; then
        timed_out=1
        kill -TERM "$lldb_pid" 2>/dev/null || true
        for ((grace = 0; grace < 20; grace++)); do
            if ! kill -0 "$lldb_pid" 2>/dev/null; then
                break
            fi
            sleep 0.1
        done
        if kill -0 "$lldb_pid" 2>/dev/null; then
            kill -KILL "$lldb_pid" 2>/dev/null || true
        fi
        wait "$lldb_pid" || status=$?
    fi

    printf 'ACGC_HARNESS lldb_status=%s timed_out=%s\n' "$status" "$timed_out" >>"$EVIDENCE_LOG"
    return "$status"
}

run_production() {
    local preflight_ok=1
    local build_status=0
    local binary="${BUILD_DIR}/bin/${GAME_BINARY_NAME}"
    local build_log="${BUILD_DIR}/acgc-game-frame-build.log"

    if ! verify_repository_and_source; then
        preflight_ok=0
    fi
    if ! verify_runtime_inputs; then
        preflight_ok=0
    fi

    if [[ "$MODE" == "dry-run" ]]; then
        print_dry_run_commands
    fi

    if [[ "$preflight_ok" -ne 1 ]]; then
        emit_not_run_results BLOCKED preflight_failed
        emit_result GATE FAIL preflight_failed
        return 1
    fi

    if [[ "$MODE" == "dry-run" ]]; then
        emit_not_run_results NOT_RUN dry_run
        emit_result GATE NOT_RUN dry_run
        return 0
    fi

    EVIDENCE_LOG="${EVIDENCE_LOG_INPUT:-${BUILD_DIR}/acgc-game-frame-lldb.log}"
    if [[ "$EVIDENCE_LOG" != /* ]]; then
        EVIDENCE_LOG="${BUILD_DIR}/${EVIDENCE_LOG}"
    fi
    if [[ "$EVIDENCE_LOG" != "${BUILD_DIR}/"* || "$EVIDENCE_LOG" == *"/../"* ||
        "$EVIDENCE_LOG" == */.. ]]; then
        emit_not_run_results BLOCKED evidence_log_must_be_below_build_dir
        emit_result GATE FAIL evidence_log_must_be_below_build_dir
        return 1
    fi

    if ! /bin/mkdir -p -- "$BUILD_DIR"; then
        emit_not_run_results BLOCKED build_directory_creation_failed
        emit_result GATE FAIL build_directory_creation_failed
        return 1
    fi
    if ACGC_GAME_BUILD_DIR="$BUILD_DIR" ACGC_DISC_PATH="$DISC_PATH" \
        "$LAUNCHER" --build >"$build_log" 2>&1; then
        build_status=0
    else
        build_status=$?
    fi
    if [[ "$build_status" -ne 0 || ! -x "$binary" ]]; then
        emit_result BUILD FAIL launcher_build_failed_or_binary_missing
        emit_not_run_results BLOCKED build_failed
        emit_result GATE FAIL build_failed
        return 1
    fi
    emit_result BUILD PASS actual_game_binary_built

    run_bounded_lldb || true
    if classify_evidence 1; then
        return 0
    fi
    return 1
}

if [[ "$MODE" == "classify-only" ]]; then
    if ! EVIDENCE_LOG="$(resolve_input_path "$CLASSIFY_LOG")"; then
        EVIDENCE_LOG="$CLASSIFY_LOG"
    fi
    emit_result CWD NOT_RUN classify_only
    emit_result REPO_HEAD NOT_RUN classify_only
    emit_result SOURCE_HEAD NOT_RUN classify_only
    emit_result ISO NOT_RUN classify_only
    emit_result BUILD_DIR NOT_RUN classify_only
    emit_result BUILD NOT_RUN classify_only
    if classify_evidence 0; then
        exit 0
    fi
    exit 1
fi

if run_production; then
    exit 0
fi
exit 1
