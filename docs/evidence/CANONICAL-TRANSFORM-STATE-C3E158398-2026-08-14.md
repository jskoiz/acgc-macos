# Canonical Transform state at `c3e158398`

Date: 2026-08-14

Remote M3 Max task: `01a00358-efb4-7d51-b5b7-7fe5801e059a`

References:

- PC base: `59714a1fd8dd8e6a346e28a24b9fd4c35c05db78`
- Remote worker: `caf3ec1336e2e6fb9eb91d711f4154361d513215`
- Integrated PC: `c3e158398f`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Integrated result

The reviewed commit changes exactly:

- `include/acgc/gx_canonical_transform_state.h`
- `src/gx_canonical_transform_state.c`
- `pc/portable/tests/test_gx_canonical_transform_state.c`
- `pc/portable/CMakeLists.txt`

It implements the frozen renderer-neutral Transforms section ID `2`, mask
`0x0002`, version `1`, count/capacity `1/1`, exact size 888 bytes (`0x378`),
and four-byte alignment. The fixed offsets remain:

- projection type at `0x000` and six binary32 words at `0x004`;
- known mask at `0x01c` and current logical position ID at `0x020`;
- three zero-reserved words at `0x024`;
- ten position 3x4 records at `0x030`; and
- ten normal 3x3 records at `0x210`.

The validator accepts only logical position/normal IDs `0,3,...,27`, does not
divide or floor malformed IDs, rejects known non-finite binary32 values,
requires unknown fields and records to be zero, and requires a known current
reference to name a known matching position slot. The common-envelope metadata
validator follows the existing Alpha/Blend/Depth section pattern and enforces
the exact version, size, count/capacity, mask, reserved, and absent-entry form.

The implementation is value-only. It does not read `PCGXRawTransform`, wire a
snapshot producer, modify `pc_gx`, or touch Apple/Metal code. The fixture models
immediate, resolved-indexed, and unresolved-indexed values with caller-owned
words and checks deterministic explicit little-endian serialization.

## Two-upstream crosswalk and review

The PC raw provenance model is `PCGXRawTransform` plus the setter/indexed-load
handling in `pc/include/pc_gx_internal.h` and `pc/src/pc_gx.c`. The decomp
oracle is `src/static/dolphin/gx/GXTransform.c`, `GXInit.c`, private `__gx`
state, `GXEnum.h`, and representative emu64, J2D, and Famicom callers. The
decomp establishes the six logical projection coefficients, exact logical
matrix IDs, 3x4/3x3 dimensions, and current-reference semantics; texture and
post-texture matrices remain outside this section.

An independent Luna Max review returned PASS for the exact parent and
four-file scope, layout/static assertions, mask and ID rules, current-reference
relation, finite/zero validation, metadata validation, endian fixture, CMake
scope, and absence of producer leakage. It made no source or ref mutation and
did not infer Windows runtime proof from fixed-width assertions.

## Exact integrated verification

On canonical PC `c3e158398f`, the integration owner configured separate
native and combined ASan/UBSan roots:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-integrate-transform-c3e158-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-transform-c3e158-native \
  --target acgc_gx_canonical_fog_state_tests \
           acgc_gx_canonical_envelope_tests \
           acgc_gx_canonical_blend_state_tests \
           acgc_gx_canonical_alpha_state_tests \
           acgc_gx_canonical_depth_state_tests \
           acgc_gx_canonical_tev_state_tests \
           acgc_gx_canonical_transform_state_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-transform-c3e158-native \
  -R '^acgc_gx_canonical_(fog_state|envelope|blend_state|alpha_state|depth_state|tev_state|transform_state)_tests$' \
  --output-on-failure --parallel 1
```

Result: native `7/7` passed. The same target and CTest matrix passed `7/7` in
`/private/tmp/acgc-integrate-transform-c3e158-asan` with
`-fsanitize=address,undefined`, `ASAN_OPTIONS=detect_leaks=0`, halt-on-error,
and no sanitizer diagnostic. The remote lane separately reported focused
Transform `1/1`, canonical regression `7/7`, combined ASan/UBSan `7/7`, and
bounded `_WIN32`/ILP32 C and C++ syntax/ABI probes with exit `0`.

## Evidence boundary

This proves the neutral Transform CPU ABI and its exact validator on the
integrated source snapshot. It does not prove a cumulative producer, live
callback, full `ac_pc` link, launch, Metal encode/present/readback, pixel,
device behavior, Windows runtime, iOS, or playability. The next source gate is
a separately reviewed all-or-nothing producer that consumes known
`PCGXRawTransform` state and remains fail-closed for unresolved indexed loads.
