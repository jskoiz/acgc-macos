# Persistent raw GX Channels producer

Date: 2026-08-14

## Result

The reviewed raw Channels implementation is integrated in the owning
`ACGC-PC-Port` history as canonical commit
`38343a5eb5159471d5ffb472578dadd8e479199e` on
`c1/macos-host-launch`. It captures setter-owned, pointer-free channel
provenance without changing the legacy OpenGL/Windows-facing arrays, preserves
inactive GX register state across active-count changes, and serializes only
active records into the existing 136-byte canonical Channels value ABI.

This is focused CPU/source evidence. It is not a cumulative GX packet, Apple
consumer, Metal encode/present/readback, rendered pixel, device, or playability
result.

## Provenance and review history

- Canonical PC base: `23c26e520a943ac843023f0341d2670d9c7ef9fc`.
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Initial M3 Max worker commit: `c9eec84b0e404daa09069d1f0fbeeb1f2ea53f50`.
- Persistence repair: `fe4aac5259dc9da0e51bcd5ab2e922cb6a0b9b6e`.
- Final source-only bundle SHA-256:
  `8ce913b763a03de15ccca91a5fab3b7e50af02c0c5a63fa00261aea0722704f5`.
- Canonical squash integration: `38343a5eb5159471d5ffb472578dadd8e479199e`.

The initial candidate passed its focused fixtures and an independent review,
but root review found a contradiction with the frozen producer plan:
`GXSetNumChans` erased inactive private records even though GX channel
controls and colors are persistent register state. The child repair keeps the
private records, zeroes only inactive canonical output records, and adds a
`2 -> 0 -> 1 -> 2` restoration fixture. The canonical integration uses the
repaired final tree as one squash, so the known-broken intermediate state does
not appear on `c1/macos-host-launch`. `git diff --quiet` confirmed the
canonical commit tree matches the repaired worker tree exactly.

## Exact source ownership

The integrated commit changes exactly:

- `pc/CMakeLists.txt`
- `pc/include/pc_gx_internal.h`
- `pc/src/pc_gx.c`
- `pc/src/pc_gx_channels_raw.c`
- `pc/tests/pc_gx_channels_raw_shadow_fixture.c`

The raw module owns active-count knownness, per-component RGBA knownness,
separate color/alpha control records, domain validation, sticky invalidity,
and conversion through `acgc_gx_canonical_channel_state_validate`. The narrow
calls in `pc_gx.c` run after the existing completed-batch flush and before the
legacy host mutation, so an old batch observes old state. Equal legacy values
can still establish previously unknown raw provenance.

## Two-upstream crosswalk

The host setters are `GXSetNumChans`, `GXSetChanCtrl`,
`GXSetChanAmbColor`, and `GXSetChanMatColor` in `pc/src/pc_gx.c`. The original
behavior oracle is `src/static/dolphin/gx/GXLight.c` in ac-decomp, with
initialization in `src/static/dolphin/gx/GXInit.c` and representative game
callers in `src/static/libforest/emu64/emu64.c`.

The implementation preserves the reference distinctions:

- active channel count accepts `0..2` and does not erase stored controls;
- combined IDs update color and alpha, while separate IDs update one control;
- color-only IDs update RGB and retain A, alpha-only IDs update A and retain
  RGB, and combined IDs update all RGBA components;
- disabled `GX_SRC_VTX` state remains representable;
- high light-mask bits and malformed source/diffuse/attenuation combinations
  fail closed; and
- logical RGBA8 is serialized independently of the GX hardware register byte
  order.

## Verification

The repaired detached candidate and the exact canonical staged tree were each
configured in fresh ignored roots. The final canonical commands were:

```sh
cmake -S pc \
  -B /private/tmp/acgc-integrate-raw-channels-final-native \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON

cmake -S pc \
  -B /private/tmp/acgc-integrate-raw-channels-final-asan \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

Both roots built these seven focused targets:

```text
acgc_gx_canonical_channel_state_tests
acgc_pc_gx_tev_raw_shadow_fixture
acgc_pc_gx_transform_raw_shadow_fixture
acgc_pc_gx_depth_raw_shadow_fixture
acgc_pc_gx_texgen_raw_shadow_fixture
acgc_pc_gx_geometry_raw_batch_fixture
acgc_pc_gx_channels_raw_shadow_fixture
```

Serial focused CTest results:

- native: `7/7` passed;
- combined ASan/UBSan: `7/7` passed with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`;
- no sanitizer diagnostics were emitted; leak detection was disabled, so this
  is not leak-free proof; and
- `git diff --check` passed.

Known compiler warnings remain the existing Darwin compile-frontier warning,
the decomp `INT_MIN` redefinition, old-style prototype warnings, and the
unsupported warning-suppression notice. No full `ac_pc` target was built or
linked for this lane.

## Next gate

Raw Channels releases shared `pc_gx` ownership. The next dependency-ready
source gate is setter-owned raw Lighting from
`RAW-LIGHTING-PRODUCER-PLAN-43992E708-2026-08-14.md`, followed by raw
Texture/TLUT state and leases. Only after those dependencies are integrated
may a cumulative all-or-nothing serializer and Apple consumer be claimed.
