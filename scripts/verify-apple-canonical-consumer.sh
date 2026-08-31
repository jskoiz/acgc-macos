#!/bin/sh
set -eu

# Build and run the Apple canonical-plan/texture consumer fixtures on a plain
# 64-bit host (Linux or macOS) WITHOUT the macOS-only AppKit/Metal CMake graph.
#
# The consumer at pc/apple/src/metal_packet_consumer.c and its canonical-state
# dependencies are renderer-neutral C: they carry no Objective-C, Metal, or
# native pointer across the API. That lets the current typed-consumer frontier
# (canonical Texture admission -> status 17, CANONICAL_TEXTURE_UNSUPPORTED) and
# the proven CPU texture-resource staging half be verified continuously on the
# Linux Cloud Agent host, where the full pc/apple target cannot build.
#
# This is CPU-only verification. It does NOT claim Metal encode/present, pixel
# readback, a device, game assets, or playability. The real remaining
# production step (a Metal texture/sampler sink plus textured-plan admission)
# stays macOS/GPU-only; see docs/LINUX-CANONICAL-CONSUMER-EVIDENCE.md.

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
pc_root=${ACGC_PC_PORT_ROOT:-"$repo_root/upstream/ACGC-PC-Port"}
build_dir=${ACGC_APPLE_CONSUMER_BUILD_DIR:-"$repo_root/local/build/apple-canonical-consumer"}
cc=${CC:-clang}

if test ! -d "$pc_root"; then
    printf 'error: PC-port source root is unavailable: %s\n' "$pc_root" >&2
    printf 'hint: run "git submodule update --init upstream/ACGC-PC-Port"\n' >&2
    exit 1
fi

# Renderer-neutral consumer sources shared by both fixtures. These mirror the
# acgc_metal_packet_consumer static library and its PUBLIC link closure in
# pc/apple/CMakeLists.txt (the canonical-state + semantic-packet libraries).
consumer_sources="
    $pc_root/pc/apple/src/metal_packet_consumer.c
    $pc_root/pc/apple/src/apple_canonical_plan.c
    $pc_root/pc/apple/src/apple_canonical_envelope_parser.c
    $pc_root/pc/apple/src/metal_state_fixture.c
    $pc_root/pc/apple/src/renderer_fixtures.c
    $pc_root/pc/apple/src/renderer_geometry.c
    $pc_root/src/gx_semantic_packet.c
"
for canonical in "$pc_root"/src/gx_canonical_*.c; do
    consumer_sources="$consumer_sources $canonical"
done

# Include dirs mirror the acgc_metal_packet_consumer target's PUBLIC includes
# plus pc/include for pc_gx_texture_raw_state.h.
include_flags="-I$pc_root/include -I$pc_root/pc/apple/include -I$pc_root/pc/include -I$pc_root/pc/portable/include"

# Match the warning contract used by the upstream CMake targets. libm supplies
# sqrtf, which glibc keeps out of libc (Apple's libc folds it in).
common_flags="-std=c11 -Wall -Wextra -Wpedantic -O1"
link_flags="-lm"

mkdir -p "$build_dir"

build_and_run() {
    fixture_name=$1
    fixture_source=$2
    binary="$build_dir/$fixture_name"

    printf '=== %s ===\n' "$fixture_name"
    # shellcheck disable=SC2086
    "$cc" $common_flags $include_flags \
        "$fixture_source" $consumer_sources \
        $link_flags \
        -o "$binary"
    "$binary"
}

build_and_run \
    acgc_apple_canonical_plan_consumer_fixture \
    "$pc_root/pc/apple/tests/test_apple_canonical_plan_consumer.c"

build_and_run \
    acgc_apple_canonical_texture_resource_consumer_fixture \
    "$pc_root/pc/apple/tests/test_apple_canonical_texture_resource_consumer.c"

printf '\nApple canonical consumer CPU fixtures passed on this host (%s).\n' \
    "$($cc --version 2>/dev/null | head -1 || echo "$cc")"
printf 'Frontier pinned: an active canonical Texture section is rejected with\n'
printf 'CANONICAL_TEXTURE_UNSUPPORTED (status 17); the textureless subset and the\n'
printf 'CPU texture-resource staging half both pass. No Metal/pixel/device claim.\n'
