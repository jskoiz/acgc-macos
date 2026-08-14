# Canonical GX fog value state at `b5f550ea0`

Date: 2026-08-14

## Provenance

- PC lane base: `5157ac1cbcdc3a0074a407c08874a0861ba20c72`
- Remote M3 Max branch: `c1/lane-canonical-fog-state-m3`
- Remote worker commit: `956e0571bb7dbdb4f936a8231051f7735374c949`
- Canonical PC integration commit: `b5f550ea0`
- ac-decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Source-only bundle SHA-256: `c81aaeb81f5c95c14272bc2a4d0fbc2612207a9c59853b9d13d6754c1127fb55`
- Worker task: `01a00276-84d7-7cc1-b085-cabe0af93e34`

No ISO, extracted assets, keys, or proprietary data were transferred or
accessed. The lane did not modify the umbrella checkout or ac-decomp.

## Two-upstream contract

The lane crosswalked PC `pc/src/pc_gx.c` (`GXSetFog`,
`GXSetFogRangeAdj`), the GX fog enums/structs, and the portable packet ABI
conventions against ac-decomp `src/static/dolphin/gx/GXPixel.c`, `GXInit.c`,
`src/static/libforest/emu64/emu64.c`, and the matching headers.

The result is a renderer-neutral, pointer-free fog value section for later
composition into one cumulative canonical draw contract. It does not modify or
extend semantic packet V1, V2, V3, or V4 and is not a transitional V5 packet.

## Exact source delta and ABI

- `include/acgc/gx_canonical_state.h`
- `src/gx_canonical_state.c`
- `pc/portable/tests/test_gx_canonical_fog_state.c`
- `pc/portable/CMakeLists.txt`

`AcgcGxCanonicalFogState` is exactly 80 bytes at four-byte alignment:

| Field | Offset | Representation |
|---|---:|---|
| `fog_type` | 0 | Canonical GX enum value in `uint32_t` |
| `start_bits` / `end_bits` | 4 / 8 | IEEE-754 binary32 bits |
| `near_bits` / `far_bits` | 12 / 16 | IEEE-754 binary32 bits |
| `color_rgba8` | 20 | Logical R/G/B/A in bit groups 0/8/16/24 |
| `range_adjust_enable` | 24 | Exactly zero or one |
| `range_center` | 28 | Widened GX `u16` |
| `range_adjust[10]` | 32 | Ten widened 12-bit entries |
| `reserved[2]` | 72 | Must be zero |

The boundary is defined as 20 little-endian 32-bit words; a byte-stream owner
must perform explicit word conversion instead of struct `memcpy` on a
big-endian host.

Validation accepts only the documented GX fog enum values, rejects malformed
active binary32 values, enforces `far >= 0` and `far >= near`, validates the
boolean, ten range words, reserved tail, and active range-center limit
`center <= 681`, and never normalizes caller data. `GX_FOG_NONE` makes the fog
parameters inactive, while finite values still retain the upstream GX ordering
assertions. Active `far == near` or `end == start` remains valid because the
decomp deliberately uses the fallback `A=0`, `B=0.5`, `C=0`.

## Exact integrated verification

Native root:
`/private/tmp/acgc-integrate-canonical-fog-b5f550ea0-native`

```sh
cmake -S pc/portable \
  -B /private/tmp/acgc-integrate-canonical-fog-b5f550ea0-native \
  -G "Unix Makefiles" \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-canonical-fog-b5f550ea0-native \
  --target acgc_gx_canonical_fog_state_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-canonical-fog-b5f550ea0-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_gx_canonical_fog_state_tests$' -V
```

Result: `1/1` passed.

The same target in
`/private/tmp/acgc-integrate-canonical-fog-b5f550ea0-asan` was compiled with
combined AddressSanitizer and UndefinedBehaviorSanitizer and run with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. Result: `1/1` passed with
no sanitizer diagnostics. Leak detection was disabled, so this is not a
leak-free claim. The remote lane also passed bounded C11 and C++11 layout and
trivial-copyability probes.

## Claim boundary

This proves one standalone CPU value contract and validator. No `PCGXState`
producer, cumulative packet, Apple consumer, live callback, full `ac_pc` link,
LLDB launch, Metal device, encode, present, readback, pixel, frame, or
playability proof follows.
