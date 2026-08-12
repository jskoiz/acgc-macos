#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
iso_relative='local/roms/Animal Crossing (USA).iso'
iso_path="$repo_root/$iso_relative"
expected_iso_sha='a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d'
expected_rel_sha='c59d278ad8542bb05d6cbb632f60a0db05bef203'
expected_portable_commit='c3a27b68e0669f0664e11da7e5e435258e951106'
expected_summary='gcm=ok dol_size=918720 fst_files=10 rel_entries=1 rel_input=6137393 rel_output=15640056 rel_format=yaz0'
pc_root="$repo_root/upstream/ACGC-PC-Port"
portable_root="$repo_root/upstream/ACGC-PC-Port/pc/portable"
probe_source="$repo_root/scripts/probes/verify_disc_core.c"
umask 077
proof_dir=$(mktemp -d "${TMPDIR:-/tmp}/acgc-disc-core.XXXXXX")
probe_binary="$proof_dir/verify-disc-core"
rel_output="$proof_dir/foresta.rel"

cleanup() {
    rm -f -- "$rel_output" "$probe_binary"
    rmdir -- "$proof_dir"
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

test -f "$iso_path"
git -C "$repo_root" check-ignore -q -- "$iso_relative"
if git -C "$repo_root" ls-files --error-unmatch -- "$iso_relative" >/dev/null 2>&1; then
    printf '%s\n' 'error: local ISO is tracked by Git' >&2
    exit 1
fi

actual_iso_sha=$(shasum -a 256 "$iso_path" | awk '{print $1}')
test "$actual_iso_sha" = "$expected_iso_sha"
pc_commit=$(git -C "$pc_root" rev-parse HEAD)
recorded_pc_commit=$(
    git -C "$repo_root" ls-files -s -- upstream/ACGC-PC-Port |
        awk '{print $2}'
)
test "$pc_commit" = "$recorded_pc_commit"
git -C "$pc_root" merge-base --is-ancestor "$expected_portable_commit" HEAD

xcrun clang \
    -std=c11 \
    -D_DARWIN_C_SOURCE \
    -Wall -Wextra -Wpedantic -Werror \
    -I "$portable_root/include" \
    "$probe_source" \
    "$portable_root/src/disc.c" \
    "$portable_root/src/yaz0.c" \
    -o "$probe_binary"

actual_summary=$("$probe_binary" "$iso_path" "$rel_output")
test "$actual_summary" = "$expected_summary"
actual_rel_sha=$(shasum -a 1 "$rel_output" | awk '{print $1}')
test "$actual_rel_sha" = "$expected_rel_sha"

printf '%s\n' "$actual_summary"
printf '%s\n' "GAFE01_00 bounded disc parse and REL hash verified: $actual_rel_sha"
