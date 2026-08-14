# Canonical snapshot producer audit at `b5f550ea0`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a00297-d958-73f2-a850-d79a18e5f763`
- PC snapshot: `b5f550ea028ab933b8433ec2e9d29768252cabdc`
- ac-decomp snapshot: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Detached audit worktree: `/private/tmp/acgc-lane-canonical-snapshot-audit`

The lane made no edit, branch, build, launch, LLDB, asset, callback, Metal,
pixel, device, or playability operation.

## Selected producer boundary

The exact future capture boundary is the top of `pc_gx_flush_vertices()` after
its nonzero-count check:

```text
first_vertex = g_gx.pending_verts
vertex_count = g_gx.current_vertex_idx - g_gx.pending_verts
```

At that point the deferred vertex has been committed, `in_begin` is false, the
logical slice is still owned by `g_gx`, and neither TEV shader selection nor
OpenGL buffer mutation has occurred. A future producer must synchronously copy
the slice before the existing V1-V4 handoffs and before
`pc_gx_tev_get_variant()` or `pc_gx_draw_pending()`. The latter is not a valid
producer boundary because VI, NES, viewport, scissor, and other GL-drain paths
also call it without establishing a new logical GX snapshot.

## State gaps that keep the source gate closed

`PCGXState` already holds vertices, matrices, viewport/scissor, channel/light
records, TEV records/registers/swaps, blend/alpha/depth/cull fields, basic fog,
indirect state, and borrowed texture-source metadata. A complete snapshot still
cannot be produced truthfully because:

- raw pre-widescreen projection values are not retained;
- texture-matrix type and texgen normalize/post/scale/bias/offset state are
  incomplete or file-local;
- several raster/depth setters are no-ops or unshadowed;
- fog-range adjustment is not shadowed;
- exact signed TEV S10 values are converted to normalized host floats;
- the current shader path handles fewer TEV stages than the stored GX state;
- VCD/VAT and indexed-attribute coverage is incomplete; and
- current texture/TLUT metadata is borrowed rather than snapshot-owned.

The decomp oracle requires preserving raw API projection values, exact signed
S10 constants, null/variable TEV patterns, disabled `GX_SRC_VTX` channel
sources, logical blend values, and ten fog-range entries. Missing provenance
must fail closed rather than be inferred from OpenGL state.

## Texture/TLUT ownership rule

A future exporter must resolve only referenced resources, validate complete
descriptor and generation metadata, synchronously copy image/TLUT bytes on the
GX owner thread, re-query the full record after the copy, and discard the
entire snapshot on any generation or descriptor change. Canonical identity is
a snapshot-local resource index, never a native pointer, GL ID, packed pointer
handle, or cache hash. EFB, replacement, stale, missing-TLUT, unavailable CPU,
overflow, and asynchronous-lifetime cases fail closed.

## Non-overlapping future ownership

- `include/acgc/gx_canonical_state.h` and `src/gx_canonical_state.c`: neutral
  fixed-width sections and validators.
- New `pc/src/pc_gx_canonical_snapshot.c`: read `g_gx`, copy vertices, assemble
  sections, validate all-or-nothing, and own lifetime.
- New private snapshot header: producer/result/status declarations only.
- `pc/src/pc_gx.c`: one call at the selected flush boundary.
- `pc/src/pc_gx_texture.c`: narrow owned-copy exporter using existing
  generation invalidation.
- One synthetic CPU fixture: producer and owned-sideband behavior without game
  data or the OpenGL draw path.

Dependency order is strict envelope, Blend/logic, exact TEV representation,
then the CPU producer and synthetic fixture. Success at that point would prove
only an owned validated CPU snapshot; Apple CPU-plan, Metal device work, pixels,
and playability remain later gates.
