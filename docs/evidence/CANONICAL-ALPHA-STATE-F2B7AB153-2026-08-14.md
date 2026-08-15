# Canonical Alpha/update state at `f2b7ab153`

Date: 2026-08-14

Canonical PC commit: `f2b7ab153aaeef037cc1fca3ecdc98acbf50ad82`

Remote worker: `c1/lane-canonical-alpha-m3` at `acd12449ae0298143769b453207ca2d30631ea5d`

Worker base: `216d1e24be5fbb85a3a394cdb1bfd50545b6b6f4`

Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Result

The reviewed worker commit is integrated on `c1/macos-host-launch` as
`f2b7ab153`. It adds the frozen version-1 `0x0100` canonical Alpha/update
section as an exact 32-byte, eight-word, pointer-free value ABI:

1. comparison 0;
2. reference 0;
3. operator;
4. comparison 1;
5. reference 1;
6. color-update enable;
7. alpha-update enable; and
8. Z-compare-before-texture enable.

The validator accepts only the audited GX comparison, reference, operator, and
boolean ranges. It deliberately preserves reference bytes for inactive
`GX_ALWAYS`/`GX_NEVER` comparisons rather than normalizing them. Alpha-local
metadata validation accepts only the exact section version, size, count,
capacity, mask, and zero-reserved fields, and rejects nonzero absent entries.

## Two-upstream crosswalk

- `upstream/ACGC-PC-Port/pc/src/pc_gx.c` and
  `pc/include/pc_gx_internal.h` retain the comparison, reference, operator,
  color-update, and alpha-update values used by the host implementation.
- `upstream/ac-decomp/src/static/dolphin/gx/GXTev.c` preserves the original
  alpha comparison/reference/operator semantics, while
  `GXPixel.c` writes the update and Z-compare-location state.
- The PC implementation of `GXSetZCompLoc` is still a no-op. This portable ABI
  therefore does not establish a complete live producer; a separate PC shadow
  repair remains required before section `0x0100` may be emitted live.

## Exact source delta

- `include/acgc/gx_canonical_alpha_state.h`
- `src/gx_canonical_alpha_state.c`
- `pc/portable/tests/test_gx_canonical_alpha_state.c`
- `pc/portable/CMakeLists.txt`

No V1-V4 packet, `pc_gx`, Apple/Metal, renderer, or decomp source changed.

## Verification

Remote focused verification on the M3 Max:

- native focused CTest: `1/1` passed;
- combined ASan/UBSan focused CTest: `1/1` passed with no diagnostics;
- `_WIN32`-defined host CPU fixture: passed;
- C and C++ ABI syntax probes: passed; and
- `git diff --check`: passed.

Exact integrated local verification used fresh roots and serial execution:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-integrate-canonical-alpha-f2b7ab-native \
  -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
cmake --build /private/tmp/acgc-integrate-canonical-alpha-f2b7ab-native \
  --target acgc_gx_canonical_fog_state_tests \
           acgc_gx_canonical_envelope_tests \
           acgc_gx_canonical_blend_state_tests \
           acgc_gx_canonical_alpha_state_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-canonical-alpha-f2b7ab-native \
  -R '^acgc_gx_canonical_(fog_state|envelope|blend_state|alpha_state)_tests$' \
  --output-on-failure --parallel 1
```

The native result is `4/4` passed. The same four tests pass `4/4` under
combined ASan/UBSan with `ASAN_OPTIONS=detect_leaks=0` and
`UBSAN_OPTIONS=halt_on_error=1`; no sanitizer diagnostic was emitted. Leak
detection was disabled, so this is not leak-free proof.

## Evidence boundary

This proves the portable CPU ABI, validator, exact metadata rules, and focused
fixtures on the integrated source snapshot. It does **not** prove a live
canonical snapshot, callback, Metal encode/present/readback, pixel, input,
audio, save/reload, device behavior, Windows runtime, iOS, or playability.
