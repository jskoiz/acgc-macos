# Canonical Depth state at `c736f9686`

Date: 2026-08-14

Remote task: `01a002f3-0540-7a61-9873-cfcbc18dcaae`

References:

- ACGC-PC-Port base: `6d1d310c08783d356b019b99fce5b1bedcd62def`
- Remote worker/final and integrated PC commit:
  `c736f968628736fe453569793bfa5129cbda9053`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Integrated source

The reviewed source commit changes only:

- `include/acgc/gx_canonical_depth_state.h`
- `src/gx_canonical_depth_state.c`
- `pc/portable/tests/test_gx_canonical_depth_state.c`
- `pc/portable/CMakeLists.txt`

It implements the frozen renderer-neutral Depth section: ID 10, mask
`0x0200`, version 1, count/capacity `1/1`, four-byte alignment, and exactly
16 bytes. The value words are `z_compare_enable`, `z_compare_func`,
`z_update_enable`, and a zero-reserved word. Boolean values accept only `0/1`;
the compare function accepts exactly the decomp `GXCompare` domain `0..7`,
including when comparison is disabled. Present and absent directory entries
are validated exactly through the common canonical envelope.

Both upstreams agree on the logical triple: PC `PCGXState`/`GXSetZMode` and
decomp `GXPixel.c` retain comparison enable, comparison function, and update
enable separately. `GXSetZCompLoc`, pixel format, and Z texture state remain
outside this section.

## Verification

The M3 Max worker reported focused native `1/1`, combined ASan/UBSan `1/1`
with leak detection disabled, bounded `_WIN32` C/C++ syntax/ABI probes, and
`git diff --check` all passing.

After fast-forwarding canonical `c1/macos-host-launch` to the exact worker
commit, the integration owner ran the shared six-test canonical matrix:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-integrate-canonical-depth-c736-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-canonical-depth-c736-native \
  --target acgc_gx_canonical_fog_state_tests \
           acgc_gx_canonical_envelope_tests \
           acgc_gx_canonical_blend_state_tests \
           acgc_gx_canonical_alpha_state_tests \
           acgc_gx_canonical_tev_state_tests \
           acgc_gx_canonical_depth_state_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-canonical-depth-c736-native \
  -R '^acgc_gx_canonical_(fog_state|envelope|blend_state|alpha_state|tev_state|depth_state)_tests$' \
  --output-on-failure --parallel 1
```

Result: `6/6` passed.

The same configure/build/test matrix passed `6/6` in
`/private/tmp/acgc-integrate-canonical-depth-c736-asan` with combined
ASan/UBSan, `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1`,
and `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; no sanitizer diagnostic
was emitted. Leak detection was disabled, so this is not a leak-free claim.

## Evidence boundary

This proves a strict portable CPU ABI and envelope validator. It does not add
the PC setter-owned Depth shadow, cumulative producer, packet serialization,
OpenGL/Metal consumer, full `ac_pc` link, live callback, encode/present,
readback pixel, device behavior, or playability. The next Depth gate is the
separately owned serial PC Z/raster provenance shadow.
