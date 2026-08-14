# Runtime texture/TLUT forwarding audit — `08c27de5`

## Scope and provenance

Remote M3 Max task `01a000e0-e957-7193-b2f8-23fd0447cdaa` audited the integrated
PC source tip `08c27de59a00ace5ad912b1700bf3bf061686530` from a dedicated
worktree `/private/tmp/acgc-lane-runtime-forwarding-m3` on branch
`c1/lane-runtime-forwarding-m3`. The remote umbrella remained at
`ee31f535f61d4ad8690ecf7e53b2ab6c0b66b281`, with its older PC gitlink
`a53b192247aab2c4f6e58b1f2dda41efdf8d1cad`; decomp was clean at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The lane made no source changes
and did not access or transfer ISO/assets/keys.

## Finding

The CPU texture/TLUT/TEV seam is not connected to the runtime forwarding path:

- `pc_gx_flush_vertices` attempts the V2, V3, and V4 handoffs.
- `pc_metal_runtime_init` registers the V2/V4 callbacks but sets
  `handoff->texture = NULL`.
- `acgc_metal_packet_consumer_handoff_v2` calls geometry-only `prepare_v2`; it
  never calls `prepare_v2_texture_tev`.
- The texture/TEV preparation entry point is referenced only by its declaration,
  implementation, and synthetic fixture test.
- The V4 payload still carries only the bounded vertex/blend/alpha subset; no
  resolved texture/TLUT/sampler bytes are forwarded.

This is a concrete source/ownership gap, not proof that the texture decoder is
wrong. A future implementation lane must choose an explicit, caller-owned
version-aware texture sideband/resolver and preserve fail-closed behavior.

## Two-upstream crosswalk

- PC packet builder: `pc/src/pc_gx.c` (`pc_gx_build_semantic_packet_v2`, V4
  builder/predicates, and `pc_gx_flush_vertices`).
- PC Apple seam: `pc/apple/include/acgc/metal_packet_consumer.h`,
  `pc/apple/src/metal_packet_consumer.c`, and `pc/apple/src/pc_metal_runtime.c`.
- Decomp GX contracts: `include/dolphin/gx/GXGeometry.h`, `GXTev.h`, and
  selector semantics in `GXEnum.h`; callers in `GXInit.c` and `emu64.c`.
- The decomp has no counterpart for the portable semantic packet or Apple
  consumer/runtime API.

## Focused verification

The lane configured native and combined ASan/UBSan tests in separate ignored
roots, `/private/tmp/acgc-lane-runtime-forwarding-m3-build` and
`/private/tmp/acgc-lane-runtime-forwarding-m3-build-asan`, using `--parallel 1`.
The focused renderer and V2 texture/TEV tests passed `2/2` natively and `2/2`
under combined ASan/UBSan with `detect_leaks=0`; no UBSan diagnostics occurred.
`detect_leaks=1` aborted because leak detection is unsupported by the Apple ASan
runtime.

## Evidence boundary and next gate

This proves only a source-level forwarding gap plus focused CPU fixture health.
It does not prove a live callback, full link, launch, Metal encode/present/
readback, pixel, input, audio, save/reload, simulator, device, or playability.
The next bounded source lane may implement one explicit caller-owned V2 texture
sideband/resolver and fixture it. Only after that review should the root owner
authorize one serialized current-tip `ac_pc` link and one bounded LLDB trace.
