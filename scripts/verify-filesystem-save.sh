#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
build_dir=${ACGC_FILESYSTEM_BUILD_DIR:-/private/tmp/acgc-lane-filesystem-build}
cc=${CC:-/usr/bin/clang}
mode=${1:-native}

case "$mode" in
    native)
        binary="$build_dir/verify_filesystem_adapter"
        sanitizer_flags=
        ;;
    --asan|asan)
        binary="$build_dir/verify_filesystem_adapter_asan"
        sanitizer_flags="-fsanitize=address,undefined -fno-omit-frame-pointer"
        ;;
    *)
        printf 'Usage: %s [native|--asan]\n' "$0" >&2
        exit 2
        ;;
esac

mkdir -p "$build_dir"

"$cc" \
    -std=c11 \
    -Wall \
    -Wextra \
    -Werror \
    -pedantic \
    -O2 \
    $sanitizer_flags \
    "$repo_root/scripts/probes/acgc_filesystem_adapter.c" \
    "$repo_root/scripts/probes/verify_filesystem_adapter.c" \
    -o "$binary"

"$binary" "$build_dir"
