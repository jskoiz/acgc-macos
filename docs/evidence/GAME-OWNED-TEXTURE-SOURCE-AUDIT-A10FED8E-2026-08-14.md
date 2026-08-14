# Game-owned texture source audit — `a10fed8e`

## Scope and provenance

Remote M3 Max read-only task `01a000f0-da9a-77b3-900a-06d627b43a2b` inspected PC
branch `c1/lane-v2-texture-runtime-m3` at
`a10fed8e01482a8097744b79e01c1e4c76feb4fe` in detached worktree
`/private/tmp/acgc-lane-gx-texture-source-audit-m3`. The worktree was clean and
no source files changed. The remote umbrella stayed at `ee31f535` with its
older PC gitlink; decomp stayed clean at `09ca8e8b`. No build, launch, debugger,
or asset access occurred.

## Finding

The PC port has no safe CPU source record at the V2 handoff:

- `PCGXState` retains GL texture IDs, dimensions, formats, and borrowed TLUT
  pointer/format/count fields, but no owned image bytes, byte sizes, sampler
  arrays, or source-generation token.
- `pc_gx_load_tex_obj_impl()` has transient image/TLUT pointers, dimensions,
  format, wrap, and filter while loading. Raw decode uses temporary RGBA storage
  and frees it after upload.
- Cache hits retain GL/cache metadata only. EFB capture and texture-pack paths
  return native/external GL textures, not CPU bytes. Missing TLUTs and malformed
  sources can fall back to gray/white or invalid GL state.
- `pc_gx_build_semantic_packet_v2()` emits texture/sampler/TLUT keys, dimensions,
  and format; `sampler_key` is the texture key. It does not emit raw pointers,
  byte sizes, wrap/filter, or ownership.
- The current Apple sideband accepts borrowed synchronous storage, but no
  game-owned caller binds one.

The decomp `GXTexObj`/`GXTlutObj` layouts are fixed-width guest `u32` records;
their addresses and converted TLUT buffers do not establish a host lifetime.

## Two-upstream crosswalk

- PC: `pc/src/pc_gx_texture.c` load/cache/decode paths,
  `pc/include/pc_gx_internal.h` state, `pc/src/pc_gx.c` V2 builder and
  synchronous handoff, and `pc/apple` sideband bind/clear API.
- Decomp: `include/dolphin/gx/GXStruct.h`, `GXTexture.c`, `GXInit.c`, and
  `emu64.c` texture/TLUT setup and reload callers. No decomp counterpart exists
  for the Apple sideband.

## Next source contract

Add an explicit per-map CPU source record captured at `GXLoadTexObj`/
`GXLoadTlut`, containing validated image/TLUT pointers and sizes, dimensions,
format, wrap/filter, TLUT metadata, source kind, and a generation token. Bind it
only synchronously before `pc_gx_try_handoff_semantic_packet_v2`; invalidate it
on registry reset, stale/destroyed objects, TLUT replacement, EFB/texture-pack
paths, and fallback decode. Accept raw or explicitly owned emu64-converted CPU
sources only; otherwise fail closed.

## Evidence boundary

This proves only a static source/lifetime gap and a safe next contract. It does
not prove a live game-owned handoff, rendering, Metal behavior, pixels, or
playability.
