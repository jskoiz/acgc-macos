# Canonical Texgen/SU state at `590b2bd73`

## Provenance

- Worker branch: `c1/lane-canonical-texgen-state` at
  `f503fb924d4ca9c6d00edbee483312830840480b`.
- Worker base: `b9a9f355f7d62c14109f711691d8c8fa51ceb7f8`.
- Integrated canonical PC: `c1/macos-host-launch` at `590b2bd73`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Source-only review bundle SHA-256:
  `d47b45d486107f21e26cebcc51d512d9a93ff7e66a29c29481a40e73c9d7a5cb`.

Lane 222 independently reviewed the immutable bundle and returned `PASS`.
Ancestry, the exact four-file scope, clean status, PC raw-owner crosswalk, and
decomp behavior were verified before integration.

## Result

The integrated source adds section ID 4 / mask `0x0008`, version 1, as a fixed
2,624-byte pointer-free value contract:

- a 16-word header;
- eight Texgen records;
- eleven ordinary texture-matrix records;
- twenty-one post-matrix records; and
- eight SU records.

The public header has C and C++ size, offset, stride, alignment, and linkage
assertions. Encoding and decoding use explicit little-endian 32-bit words,
stage through local values, preserve caller destinations on failure, permit
complete input/output aliasing, and reject short or trailing input. Validation
is fail-closed for selector/source/order domains, bump-before-SRTG rules,
matrix IDs/types/counts and finite known words, unknown/reserved storage, SU
raw 16-bit scales and exact booleans, masks/counts, and derived summaries.

The PC raw Texgen/SU state, logical matrix IDs, matrix knownness, `(scale - 1)`
SU register values, and setter ordering agree with the accepted domain. Decomp
`GXSetTexCoordGen2`, `GXLoadTexMtxImm/Indx`, SU setters, dirty-state behavior,
and `GXVerifXF` establish the same source/order/matrix boundaries. Cross-state
source-row/VCD and texture dependencies remain cumulative-producer work and
are not duplicated into this section. The project ABI has no decomp
counterpart.

Exact source delta:

- `include/acgc/gx_canonical_texgen_state.h`;
- `src/gx_canonical_texgen_state.c`;
- `pc/portable/tests/test_gx_canonical_texgen_state.c`; and
- `pc/portable/CMakeLists.txt`.

## Verification

The worker reported native focused CTest `1/1` and combined ASan/UBSan focused
CTest `1/1`, with `ASAN_OPTIONS=detect_leaks=0` and no sanitizer diagnostics.
Native C11/C++11 and `_WIN32` syntax probes passed; a real i686 probe remained
blocked by the missing MinGW `string.h`/sysroot and is not Windows sign-off.

The integration owner reran the exact focused test on `590b2bd73` from fresh
roots:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-integrate-texgen-590b2bd-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-texgen-590b2bd-native \
  --target acgc_gx_canonical_texgen_state_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-texgen-590b2bd-native \
  -R '^acgc_gx_canonical_texgen_state_tests$' --output-on-failure --parallel 1
```

Native passes `1/1`. The same target passes `1/1` under combined ASan/UBSan
from `/private/tmp/acgc-integrate-texgen-590b2bd-asan` with leak detection
disabled and no diagnostics. This is not a leak-free claim.

## Evidence boundary

This proves the portable CPU ABI, validator, codec, and focused fixtures only.
It does not implement the PC Texgen/SU leaf producer, cumulative envelope,
live callback, Apple/Metal consumption, encode/present/readback, pixel, input,
audio, save, simulator, device, Windows runtime, or playability.
