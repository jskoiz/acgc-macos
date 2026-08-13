#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly ROOT_DIR
readonly SOURCE_DIR="${ROOT_DIR}/upstream/ACGC-PC-Port/pc"
readonly BUILD_DIR="${ACGC_GAME_BUILD_DIR:-${ROOT_DIR}/local/build/macos-game}"
readonly BIN_DIR="${BUILD_DIR}/bin"
readonly GAME_BINARY="${BIN_DIR}/AnimalCrossing"
readonly DISC_PATH="${ACGC_DISC_PATH:-${ROOT_DIR}/local/roms/Animal Crossing (USA).iso}"
readonly EXPECTED_DISC_SHA256="a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d"
readonly RUNTIME_ROM_DIR="${BIN_DIR}/rom"
readonly RUNTIME_DISC_LINK="${RUNTIME_ROM_DIR}/Animal Crossing (USA).iso"
readonly VERIFY_LOG="${BUILD_DIR}/launch-verify.log"

usage() {
    cat <<'EOF'
Usage: ./script/build_and_run_game.sh [--build|--run|--verify|--debug]

Builds the actual reconstructed ac_pc executable for arm64 macOS. This is
separate from script/build_and_run.sh, which exercises the AppKit/Metal host
and its explicitly labelled game-systems stub.

  --build    Build and inspect the real executable without launching it.
  --run      Build, then run the real executable in the foreground (default).
  --verify   Build, launch the real executable, require it to remain alive for
             a bounded interval, record its PID/architecture, then terminate it.
  --debug    Build, then start the real executable under LLDB.

  ACGC_GAME_TERM_GRACE_SECONDS controls the --verify SIGTERM grace period
  (positive integer, default 2); an unresponsive process receives SIGKILL.

The user-owned disc remains at local/roms by default. The executable's legacy
relative disc lookup is satisfied by a generated symlink below the ignored
build directory; no disc bytes are copied into source or tracked paths.
EOF
}

mode="${1:---run}"
if [[ $# -gt 1 ]]; then
    usage >&2
    exit 2
fi

case "${mode}" in
    --build|--run|--verify|--debug)
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

disc_sha256="$(/usr/bin/shasum -a 256 "${DISC_PATH}" | /usr/bin/awk '{print $1}')"
if [[ "${disc_sha256}" != "${EXPECTED_DISC_SHA256}" ]]; then
    printf 'Disc SHA-256 mismatch for %s\n' "${DISC_PATH}" >&2
    printf 'Expected: %s\n' "${EXPECTED_DISC_SHA256}" >&2
    printf 'Actual:   %s\n' "${disc_sha256}" >&2
    exit 1
fi

cmake -S "${SOURCE_DIR}" -B "${BUILD_DIR}" -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DPC_DARWIN_COMPILE_AUDIT=ON \
    -DBUILD_TESTING=ON
cmake --build "${BUILD_DIR}" --target ac_pc --parallel

if [[ ! -x "${GAME_BINARY}" ]]; then
    printf 'Actual game executable was not produced: %s\n' "${GAME_BINARY}" >&2
    exit 1
fi

binary_description="$(/usr/bin/file -b "${GAME_BINARY}")"
if [[ "${binary_description}" != *"Mach-O 64-bit executable arm64"* ]]; then
    printf 'Expected a native arm64 Mach-O executable, got: %s\n' \
        "${binary_description}" >&2
    exit 1
fi

/bin/mkdir -p "${RUNTIME_ROM_DIR}"
if [[ -L "${RUNTIME_DISC_LINK}" ]]; then
    linked_disc="$(/usr/bin/readlink "${RUNTIME_DISC_LINK}")"
    if [[ "${linked_disc}" != "${DISC_PATH}" ]]; then
        printf 'Generated disc link points elsewhere; refusing to replace it: %s -> %s\n' \
            "${RUNTIME_DISC_LINK}" "${linked_disc}" >&2
        exit 1
    fi
elif [[ -e "${RUNTIME_DISC_LINK}" ]]; then
    printf 'Generated disc-link path is occupied by a non-symlink; refusing to replace it: %s\n' \
        "${RUNTIME_DISC_LINK}" >&2
    exit 1
else
    /bin/ln -s "${DISC_PATH}" "${RUNTIME_DISC_LINK}"
fi

printf 'Built actual reconstructed executable: %s\n' "${GAME_BINARY}"
printf 'Architecture: %s\n' "${binary_description}"
printf 'Disc revision input verified by SHA-256; bytes remain in the ignored local path.\n'

case "${mode}" in
    --build)
        ;;
    --run)
        cd "${BIN_DIR}"
        exec "${GAME_BINARY}" --verbose
        ;;
    --debug)
        cd "${BIN_DIR}"
        exec /usr/bin/lldb -- "${GAME_BINARY}" --verbose
        ;;
    --verify)
        verify_seconds="${ACGC_GAME_VERIFY_SECONDS:-5}"
        term_grace_seconds="${ACGC_GAME_TERM_GRACE_SECONDS:-2}"
        if [[ ! "${verify_seconds}" =~ ^[1-9][0-9]*$ ]]; then
            printf 'ACGC_GAME_VERIFY_SECONDS must be a positive integer, got: %s\n' \
                "${verify_seconds}" >&2
            exit 2
        fi
        if [[ ! "${term_grace_seconds}" =~ ^[1-9][0-9]*$ ]]; then
            printf 'ACGC_GAME_TERM_GRACE_SECONDS must be a positive integer, got: %s\n' \
                "${term_grace_seconds}" >&2
            exit 2
        fi

        : >"${VERIFY_LOG}"
        cd "${BIN_DIR}"
        "${GAME_BINARY}" --verbose >"${VERIFY_LOG}" 2>&1 &
        game_pid=$!
        game_status=0
        game_cleanup_complete=0

        cleanup_game() {
            if [[ "${game_cleanup_complete}" -eq 1 || -z "${game_pid:-}" ]]; then
                return 0
            fi

            local cleanup_pid="${game_pid}"
            local cleanup_signal="already-exited"
            local elapsed
            game_cleanup_complete=1

            if /bin/kill -0 "${cleanup_pid}" 2>/dev/null; then
                /bin/kill -TERM "${cleanup_pid}" 2>/dev/null || true
                cleanup_signal="TERM"
                for ((elapsed = 0; elapsed < term_grace_seconds * 10; elapsed++)); do
                    if ! /bin/kill -0 "${cleanup_pid}" 2>/dev/null; then
                        break
                    fi
                    sleep 0.1 || true
                done
                if /bin/kill -0 "${cleanup_pid}" 2>/dev/null; then
                    /bin/kill -KILL "${cleanup_pid}" 2>/dev/null || true
                    cleanup_signal="KILL"
                fi
            fi

            game_status=0
            wait "${cleanup_pid}" 2>/dev/null || game_status=$?
            game_pid=""
            case "${cleanup_signal}" in
                KILL)
                    printf 'Bounded verification cleanup: SIGTERM grace expired; SIGKILL fallback reaped pid=%s (status %s).\n' \
                        "${cleanup_pid}" "${game_status}"
                    ;;
                TERM)
                    printf 'Bounded verification cleanup: SIGTERM reaped pid=%s (status %s).\n' \
                        "${cleanup_pid}" "${game_status}"
                    ;;
                *)
                    printf 'Bounded verification cleanup: process already exited; reaped pid=%s (status %s).\n' \
                        "${cleanup_pid}" "${game_status}"
                    ;;
            esac
        }
        trap cleanup_game EXIT INT TERM

        for ((elapsed = 0; elapsed < verify_seconds * 10; elapsed++)); do
            if ! /bin/kill -0 "${game_pid}" 2>/dev/null; then
                cleanup_game
                /bin/cat "${VERIFY_LOG}"
                printf 'Actual game process exited before the %ss launch gate (status %s).\n' \
                    "${verify_seconds}" "${game_status}" >&2
                exit 1
            fi
            sleep 0.1
        done

        process_command="$(/bin/ps -p "${game_pid}" -o command=)"
        printf 'Actual game process launch gate passed: pid=%s command=%s\n' \
            "${game_pid}" "${process_command}"
        cleanup_game
        trap - EXIT INT TERM
        if [[ "${game_status}" -ne 0 && "${game_status}" -ne 143 && "${game_status}" -ne 137 ]]; then
            /bin/cat "${VERIFY_LOG}"
            printf 'Actual game process exited unexpectedly after verification (status %s).\n' \
                "${game_status}" >&2
            exit 1
        fi
        printf 'Bounded verification terminated the process after proving sustained launch.\n'
        ;;
esac
