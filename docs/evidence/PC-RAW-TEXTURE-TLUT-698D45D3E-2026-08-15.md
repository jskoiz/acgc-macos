# PC raw Texture/TLUT producer at `698d45d3e`

## Scope and provenance

Lane 203 implemented the frozen raw Texture/TLUT producer and synchronous
resource-lease boundary on the remote M3 Max, then returned source-only Git
objects for local root review. No ISO, extracted assets, keys, or proprietary
game data were transferred or read by the lane.

- integration base: `upstream/ACGC-PC-Port` `97aebd8a2df935ebfc8d69dfc9419b54d063ddeb`;
- initial worker commit: `4e6caa0b3e132199ec22ff3d17105880d6447c74`;
- root-review repair: `698d45d3e78f96104c2e489d78036b55ea493d37`;
- worker branch: `c1/lane-raw-texture-tlut-m3`;
- canonical integration branch: `c1/macos-host-launch` at `698d45d3e`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- tracked-source base bundle SHA-256:
  `bbe76092b9db2d089e68f4bfd3687015a6d4cb3bae7a49c817f6456d1264d360`;
- repair bundle SHA-256:
  `13635f276043edb9dd228bbc598c886c0164b79d94a4fe9dbe1939f00a36807b`;
- frozen plan:
  `docs/evidence/RAW-TEXTURE-TLUT-PRODUCER-PLAN-23C26E520-2026-08-14.md`.

The final integrated range changes exactly seven source-owned files:

- `pc/CMakeLists.txt`;
- `pc/include/pc_gx_texture_raw_state.h`;
- `pc/src/pc_gx.c`;
- `pc/src/pc_gx_canonical_snapshot.c`;
- `pc/src/pc_gx_texture.c`;
- `pc/tests/pc_gx_texture_dynamic_producer_fixture.c`; and
- `src/static/libforest/emu64/emu64.c`.

## Two-upstream crosswalk

The PC implementation was crosswalked against the existing texture host path
and the decompiled GX behavior before editing:

- PC `pc/src/pc_gx_texture.c`: `GXInitTexObj`, `GXInitTexObjCI`,
  `GXInitTexObjLOD`, `GXLoadTexObj`, `GXLoadTlut`,
  `pc_gx_tlut_set_native_le`, cache invalidation, destruction, and existing
  `PCGXTextureSource` metadata;
- PC `pc/src/pc_gx.c`: the committed-vertex boundary at the top of
  `pc_gx_flush_vertices()`;
- PC canonical Texture and Dynamic headers, validators, and focused fixtures;
- decomp `src/static/dolphin/gx/GXTexture.c` and `GXInit.c`: guest texture
  formats, tiled/mip sizing, sampler fields, TLUT loading, and invalidation;
- decomp public GX enums/structs; and
- decomp `src/static/libforest/emu64/emu64.c` plus representative JUT/game
  callers for the distinction between raw guest bytes and emu64-converted
  image/TLUT bytes.

The emu64 edit is a six-line PC-only provenance marker at the existing
converted-image call boundary. It does not change the non-PC or Dolphin raw
path.

## Implemented boundary

The integrated source adds:

- a private pointer-free eight-map/sixteen-TLUT raw state;
- a nonzero owner epoch and checked per-resource generations;
- exact format, tiled extent, mip, sampler, byte-order, and source-kind
  metadata;
- stable logical map and TLUT resource identities;
- a separate pointer-bearing borrowed-resource lease valid only during the
  synchronous callback;
- canonical Texture plus Dynamic conversion with all-or-nothing destination
  publication;
- complete-batch ordering before the new producer observation point; and
- fail-closed invalid, incomplete, stale-handle, provenance, generation, and
  missing-resource paths.

The canonical value sections remain pointer-free. Resource bytes are never
embedded in the packet or retained by this producer.

## Root-review rejection and repair

The first worker commit was not integrated immediately. Root review found that
`texture_source_clear_map()` dropped the raw image lease and that both
`GXLoadTlut()` and `pc_gx_tlut_set_native_le()` called the legacy all-map clear.
That caused one TLUT mutation to invalidate unrelated non-indexed image
resources, contradicting the frozen rule that only the changed TLUT and its
dependent indexed maps advance.

Commit `698d45d3e` repairs the boundary by separating legacy source-record
clearing from raw lease invalidation. It keeps explicit raw lease invalidation
at actual cache eviction, cache/global clear, region invalidation, and destroy
boundaries. TLUT load and native-endian conversion now retain unrelated map
leases while the target-aware raw helper advances only dependent indexed maps.

The focused fixture no longer republishes unrelated resources to hide the
problem. It asserts that:

- non-indexed maps preserve generation, availability, pointer, and lease
  generation across `GXLoadTlut()` and `pc_gx_tlut_set_native_le()`;
- indexed maps using the changed TLUT advance generation and become
  unavailable until republished; and
- cache/global invalidation still drops all image leases.

`pc_gx_canonical_snapshot.c` was left unchanged after review. Under the stated
single-threaded, non-reentrant GX ownership contract, no mutation or callback
can interleave between the raw value copy, dynamic validation, lease capture,
and synchronous callback entry. Concurrent or re-entrant mutation would
require a separate owner-epoch/lease revalidation design and is not claimed by
this lane.

## Exact integrated verification

Fresh local roots were configured from canonical `698d45d3e`:

```sh
cmake -S pc \
  -B /private/tmp/acgc-integrate-raw-texture-tlut-698-native \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON

cmake -S pc \
  -B /private/tmp/acgc-integrate-raw-texture-tlut-698-asan \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

Both roots built these exact targets:

```text
acgc_pc_gx_texture_source_record_fixture
acgc_pc_gx_texture_tev_packet_fixture
acgc_pc_gx_channels_raw_shadow_fixture
acgc_pc_gx_lighting_raw_shadow_fixture
acgc_pc_gx_texture_dynamic_producer_fixture
acgc_gx_canonical_dynamic_state_tests
acgc_gx_canonical_texture_state_tests
```

The serial CTest regex was:

```text
^(acgc_pc_gx_texture_source_record_fixture|acgc_pc_gx_texture_tev_packet_fixture|acgc_pc_gx_channels_raw_shadow_fixture|acgc_pc_gx_lighting_raw_shadow_fixture|acgc_pc_gx_texture_dynamic_producer_fixture|acgc_gx_canonical_dynamic_state_tests|acgc_gx_canonical_texture_state_tests)$
```

Results:

- native: `7/7` passed;
- combined ASan/UBSan: `7/7` passed with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`;
- no sanitizer diagnostics were emitted;
- leak detection was disabled, so this is not leak-free proof; and
- `git diff --check` passed.

The M3 worker additionally reports clean Clang analyzer results, C11/C++11
header probes, C++11/C++17 emu64 syntax probes, ILP32 header probes, and a
bounded `_WIN32` public-header probe. A real i686 Windows compiler, sysroot,
archive, link, and runtime were unavailable, so this is not Windows sign-off.

Known warnings remain the existing Darwin compile-frontier notice, decomp
`INT_MIN` redefinition, old C prototype warnings, and unsupported
warning-suppression notice.

## Claim boundary and next gate

This evidence proves the reviewed CPU producer, raw resource lifetime model,
canonical conversion, synchronous lease contract, focused native behavior, and
combined ASan/UBSan behavior on the integrated source snapshot.

It does **not** prove a full `ac_pc` link, game launch, live callback
reachability, Apple consumer, Metal resource creation, encode, present,
readback, pixel, input, audible audio, save/reload, device, iOS, or
playability.

The next dependency-ready source gate is the separately owned cumulative
all-or-nothing GX snapshot producer and immutable Apple CPU plan. Only after
that integration may one serialized full link/LLDB callback trace and a later
device-gated Metal encode/present/readback pixel gate run.
