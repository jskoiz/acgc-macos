# Canonical Indirect state at `a42da8e15` (2026-08-15)

## Scope and provenance

Lane 209 implemented the accepted renderer-neutral Indirect value ABI on the
remote M3 Max and returned one source-only commit for integration-owner review.
No ISO, extracted assets, keys, proprietary game data, full link, launch, or
device access was part of the lane.

- project task: `01a004f3-5a55-7702-95ec-8acf22b8b806`;
- PC base: `039afce0e0773a2ad4cbb6b5d8d717c463ad8303`;
- worker/final commit: `a42da8e15540cc4e01ed3139b84ced073def9608`;
- worker branch: `c1/lane-canonical-indirect-m3`;
- remote source: `/private/tmp/acgc-lane-canonical-indirect-m3`;
- canonical integration branch: `c1/macos-host-launch` at `a42da8e155`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- source-only bundle SHA-256:
  `7ef80ca60f2f95f6fa58102a05d258f7c38cc99d0184a2e4cd22697ca3b517bb`; and
- frozen input contract:
  `docs/evidence/CANONICAL-INDIRECT-CONTRACT-698D45D3E-2026-08-15.md`.

The remote and local bundle hashes match, `git bundle verify` reports complete
history, the worker commit is a direct child of the declared base, and the
worker and canonical checkouts are clean.

## Exact change and two-upstream crosswalk

The commit changes exactly four lane-owned files:

- new `include/acgc/gx_canonical_indirect_state.h`;
- new `src/gx_canonical_indirect_state.c`;
- new `pc/portable/tests/test_gx_canonical_indirect_state.c`; and
- minimal `pc/portable/CMakeLists.txt` registration.

It does not touch `pc_gx`, raw setters, packet/envelope producers, Apple/Metal,
shaders, decomp, resources, or runtime code.

The implementation was checked against:

- PC `pc/src/pc_gx.c` and `PCGXState` shared Indirect count/order/matrix state;
- PC `PCGXTevStage`, which separately owns the nine per-stage Indirect fields;
- canonical TEV, Texture, Geometry-dependency, and common-envelope contracts;
- decomp `src/static/dolphin/gx/GXBump.c` setters, matrix quantization,
  selector families, direct defaults, texture-map collision assertion, and
  `CHECK_GXBEGIN` behavior;
- decomp `GXInit.c`, `GXTexture.c`, public GX enums/structs, and representative
  Famicom/game callers; and
- the accepted lane-207 split that prohibits duplicate TEV ownership.

## Implemented contract

The integrated ABI uses the reserved common-envelope section ID `13`, mask
`0x1000`, version `1`, and exactly one 248-byte/62-word value record aligned to
four bytes.

Its fixed layout contains:

- a 14-word header with exact metadata, active stage count, capacities, record
  sizes/offsets, masks, and a zero reserved word;
- four six-word order records in stage order, each containing texture
  coordinate, texture map, S/T scales, and two zero reserved words; and
- three eight-word matrix records containing six signed 11-bit quantized
  coefficients, the six-bit encoded exponent, and one zero reserved word.

Validation is fail-closed for null inputs, malformed metadata, active counts
outside `0..4`, noncontiguous active-order masks, order values outside their
`0..7` and `0..8` domains, matrix coefficients outside `-1024..1023`, encoded
scales outside `0..63`, nonzero reserved fields, and nonzero inactive records.
Compile-time assertions freeze every size, alignment, and offset.

The dependency validator requires canonical TEV, preserves `GXSetTevDirect`
defaults when the active Indirect count is zero, requires every effective TEV
Indirect stage and referenced matrix to exist, and optionally validates the
referenced Texture map and Texgen selector/known matrix. It also rejects the
decomp-debug-invalid collision where one texture map is used simultaneously as
an active direct and Indirect map. The nine per-TEV Indirect fields remain
solely in canonical TEV.

The focused fixture covers exact ABI layout, metadata presence and absence,
value boundaries, inactive/reserved records, explicit little-endian word
roundtrip, TEV stage/matrix references, optional Texture/Texgen dependencies,
map collisions, and null/malformed inputs.

## Exact verification

The worker reported:

- focused native CTest: `1/1` passed;
- combined ASan/UBSan focused CTest: `1/1` passed with
  `ASAN_OPTIONS=detect_leaks=0` and no sanitizer diagnostics;
- Clang analyzer, C11/C++11 syntax, bounded `-m32`, and bounded `_WIN32` syntax
  probes passed; and
- `git diff HEAD^ HEAD --check` passed.

The integration owner imported the source-only bundle and configured fresh
roots from the exact worker commit:

```sh
cmake -S /private/tmp/acgc-integrate-canonical-indirect-a42/pc \
  -B /private/tmp/acgc-integrate-canonical-indirect-a42-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON

cmake -S /private/tmp/acgc-integrate-canonical-indirect-a42/pc \
  -B /private/tmp/acgc-integrate-canonical-indirect-a42-asan \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

Both roots built `acgc_gx_canonical_indirect_state_tests`. The exact serial
test was:

```sh
ctest --test-dir <root> --output-on-failure --parallel 1 \
  -R '^acgc_gx_canonical_indirect_state_tests$'
```

Results:

- fresh local native focused CTest: `1/1` passed;
- fresh local combined ASan/UBSan focused CTest: `1/1` passed;
- no sanitizer diagnostic was emitted; and
- leak detection was disabled, so this is not leak-free proof.

No real Windows compiler, sysroot, PE link, or runtime was available. The
bounded syntax probes are not Windows sign-off.

## Claim boundary and next gate

This proves a reviewed fixed-width CPU ABI, strict validator, envelope metadata
contract, cross-section dependency checks, explicit little-endian fixture
behavior, and native plus combined ASan/UBSan focused behavior on the exact
integrated source.

It does **not** prove raw PC Indirect ownership/conversion, a cumulative
producer, full `ac_pc` link, launch, live callback, Apple consumer, Metal
encode/present/readback, pixel, input, audio, save/reload, device, iOS, Windows
runtime, or playability.

The next Indirect source gate is a separately owned `pc_gx` raw shadow and
converter that preserves count/order/scales/quantized matrices plus knownness
with flush-before-mutation ordering. It must not overlap another active
`pc_gx.c` owner. Envelope assembly and Apple consumption remain later gates.
