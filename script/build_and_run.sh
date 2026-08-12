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

usage() {
    cat <<'EOF'
Usage: ./script/build_and_run.sh [--run|--verify|--headless|--debug|--logs|--telemetry]

Builds and tests the native AppKit host before the selected action.

  --run        Launch a new foreground app instance (default).
  --verify     Prove process observation and a clean timed app exit.
  --headless   Validate the explicit disc without opening a window.
  --debug      Start the app executable under LLDB.
  --logs       Launch the app, then stream its macOS process logs.
  --telemetry  Alias for --logs until structured telemetry is implemented.

Override the ignored local disc with ACGC_DISC_PATH. Generated build and
verification state stays below local/ unless ACGC_MACOS_BUILD_DIR or
ACGC_VERIFY_HOME is explicitly set.
EOF
}

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

stop_existing_host() {
    if /usr/bin/pgrep -f "${APP_BINARY}" >/dev/null 2>&1; then
        /usr/bin/pkill -TERM -f "${APP_BINARY}"
        local attempt
        for attempt in {1..30}; do
            if ! /usr/bin/pgrep -f "${APP_BINARY}" >/dev/null 2>&1; then
                return 0
            fi
            sleep 0.1
        done
        printf 'Existing host did not exit after SIGTERM: %s\n' "${APP_BINARY}" >&2
        return 1
    fi
}

stop_existing_host

cmake -S "${SOURCE_DIR}" -B "${BUILD_DIR}" -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DBUILD_TESTING=ON
cmake --build "${BUILD_DIR}" --parallel
ctest --test-dir "${BUILD_DIR}" --output-on-failure

case "${mode}" in
    --run)
        /usr/bin/open -n "${APP_BUNDLE}" --args --disc "${DISC_PATH}"
        ;;
    --headless)
        CFFIXED_USER_HOME="${VERIFY_HOME}" \
            "${CLI_BINARY}" --headless --disc "${DISC_PATH}"
        ;;
    --debug)
        exec /usr/bin/lldb -- "${APP_BINARY}" --disc "${DISC_PATH}"
        ;;
    --logs|--telemetry)
        if [[ "${mode}" == "--telemetry" ]]; then
            printf '%s\n' 'Structured telemetry is not implemented; streaming process logs.'
        fi
        /usr/bin/open -n "${APP_BUNDLE}" --args --disc "${DISC_PATH}"
        exec /usr/bin/log stream --style compact \
            --predicate "process == '${APP_NAME}'"
        ;;
    --verify)
        mkdir -p "${VERIFY_HOME}"
        CFFIXED_USER_HOME="${VERIFY_HOME}" \
            /usr/bin/open -n -W "${APP_BUNDLE}" --args \
                --disc "${DISC_PATH}" --verify-seconds 2 &
        readonly open_pid=$!
        process_seen=0
        for attempt in {1..100}; do
            if /usr/bin/pgrep -f "${APP_BINARY}" >/dev/null 2>&1; then
                process_seen=1
                break
            fi
            if ! /bin/kill -0 "${open_pid}" >/dev/null 2>&1; then
                break
            fi
            sleep 0.05
        done

        open_status=0
        wait "${open_pid}" || open_status=$?
        if [[ "${process_seen}" -ne 1 ]]; then
            printf '%s\n' 'Launch verification failed: app process was not observed.' >&2
            exit 1
        fi
        if [[ "${open_status}" -ne 0 ]]; then
            printf 'Launch verification failed: open exited %d.\n' "${open_status}" >&2
            exit "${open_status}"
        fi
        if /usr/bin/pgrep -f "${APP_BINARY}" >/dev/null 2>&1; then
            printf '%s\n' 'Launch verification failed: app remained alive after timed exit.' >&2
            exit 1
        fi
        printf '%s\n' 'Launch verification passed: process observed and timed exit was clean.'
        ;;
esac
