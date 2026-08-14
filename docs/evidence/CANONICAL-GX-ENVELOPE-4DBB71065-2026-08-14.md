# Canonical GX envelope at `4dbb71065`

Date: 2026-08-14

## Provenance

- Remote M3 Max task: `01a00297-d958-7e93-be9a-6d3949f789c7`
- Worker branch: `c1/lane-canonical-envelope-m3`
- Worker base/final: `b5f550ea028ab933b8433ec2e9d29768252cabdc` ->
  `18ef2fcbb88f34cbec903f1bfeea12d357cafdc9`
- Reviewed local integration: `4dbb71065`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The worker changed exactly:

- `include/acgc/gx_canonical_state.h`
- `src/gx_canonical_state.c`
- `pc/portable/tests/test_gx_canonical_envelope.c`
- `pc/portable/CMakeLists.txt`

The worker commit was parent-relative reviewed before cherry-pick. It does not
touch the Apple sink files changed by `62ef6638d`; the legacy V4 fail-closed
guard remains integrated.

## Implemented contract

The renderer-neutral cumulative metadata prefix now has:

- a fixed 48-byte header;
- fourteen ordered 32-byte directory entries;
- known state mask `0x00003fff`;
- a dynamic, four-byte-aligned payload extent rather than a frozen final packet
  size;
- exact present/required-mask and present/absent-entry rules;
- strict section identity/version, sequential range, count/capacity,
  alignment, size, valid-mask, and reserved-zero validation; and
- exact fog metadata of version 1, 80 bytes, count 1, and capacity 1.

Unknown IDs, masks, versions, gaps, overlaps, malformed extents, nonzero
inactive metadata, and nonzero reserved words fail closed. The validator checks
the fixed metadata and declared caller-owned extent; individual section
validators remain responsible for payload content. The byte-stream contract is
logical little-endian fixed-width words and does not serialize a pointer,
native enum, `size_t`, host `bool`, or renderer handle.

The fog crosswalk follows PC `GXSetFog`/`GXSetFogRangeAdj` and ac-decomp
`GXPixel.c`, `GXStruct.h`, and `GXEnum.h`. The PC range-adjust setter remains a
known producer gap; this commit does not fabricate missing live state.

## Exact integrated verification

Native:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-integrate-canonical-envelope-4dbb710-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-canonical-envelope-4dbb710-native \
  --target acgc_gx_canonical_fog_state_tests \
           acgc_gx_canonical_envelope_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-canonical-envelope-4dbb710-native \
  -R 'acgc_gx_canonical_(fog_state|envelope)_tests' \
  --output-on-failure --parallel 1
```

Result: `2/2` passed.

Combined ASan/UBSan used the same targets with
`-fsanitize=address,undefined -fno-omit-frame-pointer`,
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1`, and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`.

Result: `2/2` passed with no sanitizer diagnostics. Because leak detection was
disabled, this is not a leak-free claim.

The remote worker also passed bounded C and C++ ABI/syntax probes and bounded
`_WIN32` C/header probes. A broader synthetic `_WIN32` C++ host probe remains
blocked by Apple libc++ locale macros; no real i686/PE/runtime sign-off follows.

## Evidence boundary

This proves only a portable CPU metadata/ABI validator. It does not prove a
live producer, `pc_gx` state capture, V1-V4 callback, Apple consumer, Metal
encode/present/readback, pixel, input, audio, save/reload, device behavior, or
playability. The next neutral section is Blend/logic; the snapshot producer
remains gated by additional exact section contracts and missing PC shadow
state.
