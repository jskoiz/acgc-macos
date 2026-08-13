#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
pc_root=${ACGC_PC_PORT_ROOT:-"$repo_root/upstream/ACGC-PC-Port"}
decomp_root=${ACGC_DECOMP_ROOT:-"$repo_root/upstream/ac-decomp"}
build_dir=/private/tmp/acgc-lane-save-gci-build
expected_pc_commit=4f77dab413e4fe29264cfc68b0f7fac1ade74d01
expected_decomp_commit=09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c
codec_source="$pc_root/pc/src/pc_save_bswap.c"
probe_source="$repo_root/scripts/probes/test_save_gci_codec.c"
codec_object="$build_dir/pc_save_bswap.o"
probe_binary="$build_dir/test_save_gci_codec"
compile_log="$build_dir/compile.log"

if test ! -d "$pc_root"; then
    printf 'error: PC-port source root is unavailable: %s\n' "$pc_root" >&2
    exit 1
fi
if test ! -d "$decomp_root"; then
    printf 'error: decomp source root is unavailable: %s\n' "$decomp_root" >&2
    exit 1
fi
test -f "$codec_source"
test -f "$probe_source"
git -C "$pc_root" merge-base --is-ancestor "$expected_pc_commit" HEAD
if ! git -C "$pc_root" diff --quiet "$expected_pc_commit" HEAD -- \
    pc/src/pc_save_bswap.c pc/include/pc_save_bswap.h pc/src/pc_m_card.c \
    include/m_common_data.h include/m_card.h include/m_flashrom.h; then
    printf '%s\n' 'error: codec/GCI source paths changed after the requested 4f77dab boundary' >&2
    exit 1
fi
test "$(git -C "$decomp_root" rev-parse HEAD)" = "$expected_decomp_commit"

mkdir -p "$build_dir"
: > "$compile_log"

common_flags='-std=c11 -D_DARWIN_C_SOURCE -DTARGET_PC -DPC_DARWIN_COMPILE_AUDIT -DVERSION=0 -DF3DEX_GBI_2 -D_LANGUAGE_C -DNDEBUG -Wall -Wextra -Wpedantic'
include_flags="-I$pc_root/pc/include -I$pc_root/include -I$pc_root/src -I$pc_root -I$pc_root/src/static -I$pc_root/pc/portable/include"

# Compile only the byte codec. This deliberately does not configure or link
# pc_m_card.c, the CARD host adapter, SDL, the renderer, or the game runtime.
xcrun clang $common_flags $include_flags \
    -c "$codec_source" \
    -o "$codec_object" \
    2>>"$compile_log"
xcrun clang $common_flags $include_flags \
    "$probe_source" "$codec_object" \
    -o "$probe_binary" \
    2>>"$compile_log"

run_dir=$(mktemp -d "$build_dir/run.XXXXXX")
trap 'rmdir "$run_dir" 2>/dev/null || true' EXIT
"$probe_binary" "$run_dir"

printf 'PC source commit: %s (4f77dab codec/GCI paths unchanged)\n' "$(git -C "$pc_root" rev-parse HEAD)"
printf '%s\n' 'Source-backed bounded Save_t/GCI codec probe completed; noncanonical padding remains blocked.'
