# Canonical Texgen/SU producer at `c832fb862`

## Provenance

- Worker branch: `c1/lane-texgen-producer-m3` at
  `e6f26abde5327347d43532a5605b11402a3b8330`.
- Worker base: `0f896395c84bdcb238ccd0f8ac3c85632d7a8ede`.
- Initial worker commit: `a14aef417913f9538d952df867f56a826bb7f124`.
- Integrated canonical PC: `c1/macos-host-launch` at
  `c832fb862e934806888488e0dbc288aefeae5a10`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Source-only worker bundle SHA-256:
  `a4af158d95af70c64ab503b4fd1ed27f459a373f389dd2d4c149ba334dc6465f`.

Lane 233 first returned `BLOCK` against the initial worker because inactive
matrix records could carry provenance/known-mask combinations that a setter
cannot produce. Lane 232 repaired only the producer and fixture in child
`e6f26abde5`; lane 233 then independently re-reviewed that child and returned
`PASS — no material candidate-owned issue remains` before integration.

## Result

The integrated source adds a pure raw-to-canonical Texgen/SU leaf producer:

```c
int pc_gx_raw_texgen_build_canonical(
    const PCGXRawTexgen *input,
    AcgcGxCanonicalTexgenState *output);
```

The producer validates the setter-owned raw Texgen records, ordinary and post
texture-matrix provenance, and per-coordinate SU state before constructing a
local canonical candidate. Immediate matrix records must know every word in
their exact attempted 2x4 or 3x4 range; indexed-unresolved records must know no
word in that attempted range. Malformed, incomplete, non-finite, out-of-domain,
or sticky-invalid input fails closed and leaves the caller destination
unchanged. A successful candidate is passed through the existing canonical
Texgen validator before the single destination assignment.

Exact source delta from the worker base:

- `pc/include/pc_gx_texgen_producer.h`;
- `pc/src/pc_gx_texgen_producer.c`;
- `pc/tests/pc_gx_texgen_producer_fixture.c`; and
- `pc/CMakeLists.txt`.

The PC reference points are `PCGXRawTexgen`, `PCGXRawTexMatrix`, and
`PCGXRawTexcoordSU` in `pc/include/pc_gx_internal.h`, together with the raw
setter capture around `GXSetNumTexGens`, `GXSetTexCoordGen2`,
`GXLoadTexMtxImm`, `GXLoadTexMtxIndx`, `GXSetTexCoordScaleManually`,
`GXSetTexCoordBias`, and `GXSetTexCoordCylWrap` in `pc/src/pc_gx.c`. The
original-behavior crosswalk is `src/static/dolphin/gx/GXAttr.c`,
`GXTransform.c`, and `GXTexture.c` in `ac-decomp`, with live game use also
confirmed in `src/static/libforest/emu64/emu64.c` and the Famicom renderer.
The project-specific canonical producer has no decomp counterpart.

## Verification

The remote worker reported native focused CTest `2/2` and combined ASan/UBSan
focused CTest `2/2`, with no sanitizer diagnostics and leak detection disabled.
The producer object, native C11/C++11 syntax probes, and bounded ILP32 probes
passed. The `_WIN32` probe remains blocked by missing Windows headers and a
real i686 toolchain, so this is not Windows sign-off.

The integration owner imported the verified source-only bundle, preserved the
worker branch, applied the initial and repair commits one at a time, and reran
the focused gate from fresh roots on `c832fb862`:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-texgen-c832-native -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-texgen-c832-native \
  --target acgc_pc_gx_texgen_producer_fixture \
  acgc_gx_canonical_texgen_state_tests \
  acgc_pc_gx_texgen_producer_object --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-texgen-c832-native \
  --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_texgen_producer_fixture|acgc_gx_canonical_texgen_state_tests)$'
```

Native passes `2/2`. The same three focused targets pass `2/2` under combined
ASan/UBSan from `/private/tmp/acgc-integrate-texgen-c832-asan`, using
`-fsanitize=address,undefined -fno-omit-frame-pointer`,
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1`, and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. There are no sanitizer
diagnostics. The only compiler diagnostic is the pre-existing `INT_MIN` macro
redefinition warning. This is not a leak-free claim.

## Evidence boundary

This proves the CPU Texgen/SU leaf conversion, strict matrix-attempted-range
validation, focused fixture, and production producer-object compilation on the
integrated snapshot. The producer is not yet wired into a cumulative snapshot
or live callback. It does not prove a full `ac_pc` link, launch, callback,
renderer, Metal encode/present/readback, pixel, input, audio, save, simulator,
device, Windows runtime, or playability.
