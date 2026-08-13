#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
build_dir=${ACGC_LIFECYCLE_BUILD_DIR:-/private/tmp/acgc-lane-lifecycle-build}
probe_source="$repo_root/scripts/probes/verify_lifecycle_contract.c"
probe_binary="$build_dir/verify-lifecycle-contract"
probe_log="$build_dir/verify-lifecycle-contract.log"

mkdir -p "$build_dir"

${CC:-/usr/bin/clang} \
    -std=c11 \
    -D_DARWIN_C_SOURCE \
    -Wall -Wextra -Wpedantic -Werror \
    -pthread \
    "$probe_source" \
    -o "$probe_binary"

"$probe_binary" | tee "$probe_log"
