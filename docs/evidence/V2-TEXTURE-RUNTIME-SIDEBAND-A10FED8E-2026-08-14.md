# V2 texture runtime sideband — `a10fed8e`

## Scope and provenance

Remote M3 Max source lane `01a000e5-6aba-7a81-9431-bd22781967f4` started from
PC `08c27de59a00ace5ad912b1700bf3bf061686530` and committed
`a10fed8e01482a8097744b79e01c1e4c76feb4fe` on
`c1/lane-v2-texture-runtime-m3`. Its clean worktree was
`/private/tmp/acgc-lane-v2-texture-runtime-m3`; the remote umbrella stayed at
its older `ee31f535`/`a53b192` snapshot and decomp stayed clean at
`09ca8e8b`. No ISO/assets/keys were accessed or transferred.

## Implementation

The Apple consumer/runtime now exposes a borrowed caller-owned V2 texture source
binding. A validated textured V2 packet fails closed with the distinct
`V2_TEXTURE_SOURCE_REQUIRED` status when no source is bound. When a source is
bound, `handoff_v2` calls the existing `prepare_v2_texture_tev` CPU resolver and
reports `CPU_RESOLVED`. Geometry-only V2 packets retain their prior
`NOT_RENDERED` behavior. Initialization failure and shutdown clear the binding,
and CPU-resolved output is not submitted to the Metal sink.

Changed files are limited to:

- `pc/apple/CMakeLists.txt`
- `pc/apple/include/acgc/metal_packet_consumer.h`
- `pc/apple/include/acgc/pc_metal_runtime.h`
- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/src/pc_metal_runtime.c`
- `pc/apple/tests/test_metal_packet_consumer_v2_runtime_sideband.c`

## Two-upstream crosswalk

- PC `pc/src/pc_gx.c`: the V2 builder emits texture/TLUT/sampler keys,
  dimensions, format, and TEV inputs; the typed callback is synchronous and
  V2→V3→V4 ordering remains unchanged. V4 still leaves texture/TEV state
  unencoded.
- Decomp `GXGeometry.h`, `GXTev.h`, `GXEnum.h`, `GXInit.c`, and `emu64.c` define
  the texture-generator, TLUT, sampler, and TEV behavior. There is no decomp
  counterpart for the Apple runtime sideband.

## Integrated verification

The commit was cherry-picked onto canonical PC `c1/macos-host-launch` as
`3c08c7f71`. From that exact integrated snapshot:

- Native focused CTest: `3/3` passed serially (`renderer_fixture_tests`,
  `v2_texture_tev_tests`, and `v2_runtime_sideband_tests`).
- Combined ASan/UBSan focused CTest: `3/3` passed serially with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; no diagnostics.
- `git diff HEAD^ HEAD --check` passed in the worker.

## Evidence boundary and next gate

This proves only a synthetic borrowed CPU sideband, status propagation,
fail-closed behavior, texture/TLUT decode, TEV evaluation, and geometry-only
preservation. It does not prove that the game-owned GX texture loader binds real
source storage, nor any full link, launch, live callback, Metal encode/present/
readback, pixel, device, input, audio, save/reload, simulator, or playability
gate. The next bounded audit must map the existing game-owned texture/TLUT CPU
storage and its lifetime before any source bridge or serialized runtime trace.
