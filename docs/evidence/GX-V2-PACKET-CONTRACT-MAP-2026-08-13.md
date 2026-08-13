# GX v2 packet-contract map

Date: 2026-08-13 HST

This was a bounded read-only crosswalk at PC `a8f3a8f` and decomp `09ca8e8b`.
The lane made no source/test edit, ran no full `ac_pc` link, and performed no
live LLDB launch.

## Why the live observer is zero

The current `pc_gx_flush_vertices()` path calls the v1 semantic packet builder
before invoking the Apple observer. The builder intentionally fails closed on
unsupported state. The live decomp/emu64 path configures one channel, two
texture generators, two TEV stages, textured TEV orders, and richer combiner
state; v1 only represents a fixed-width vertex packet with pass-through color,
bounded topology, and one optional resolved texture key. This is a state-shape
mismatch, not a callback-registration failure.

## Smallest safe extension

A future packet-contract lane should add explicit, fixed-width, pointer-free
fields for:

1. bounded channel count and channel materialization;
2. a bounded texture-generator tuple (identity, coordinates, and enable);
3. one or more TEV stage descriptors (orders, combiner sources/ops, and
   constant/raster inputs) sufficient for the observed two-stage path;
4. texture/TLUT identity and sampler state through opaque validated handles,
   never guest pointers; and
5. a versioned state mask so unsupported lighting, fog, indirect, alpha, or
   dynamic state remains fail-closed.

The first implementation target should be one deterministic game triangle with
the exact emu64 state above, validated against the existing packet and Metal
CPU fixtures. It must preserve the legacy OpenGL path and reject incomplete or
unbounded state. This is a packet-contract extension, not yet a Metal shader or
device-rendering implementation.

## Two-upstream crosswalk

- Decomp `src/graph.c` schedules `emu64_taskstart` from the graph frame.
- Decomp `src/static/libforest/emu64/emu64.c` initializes the channel/texture/
  TEV state, performs dirty-check/setup, and emits `GXBegin` triangle work.
- Decomp `src/static/dolphin/gx/GXInit.c` records the original GX defaults,
  which are later enriched by emu64 state setup.
- PC `pc/src/pc_gx.c` owns the v1 builder/rejection gate and flush boundary.
- PC `include/acgc/gx_semantic_packet.h` is the current pointer-free value-only
  packet contract; Apple packet consumer/state fixtures are CPU-side renderer
  contracts only.

The existing focused packet/handoff contract results remain the applicable
verification boundary: supported synthetic input reaches the observer and
unsupported/incomplete state is rejected. No live callback, Metal
encode/present/readback/pixel, input, audio, save/load, device, or playability
claim follows from this audit.

The successor unblocked by this map is one source-owned packet-contract lane
with explicit file ownership and fixtures for the two-stage TEV/texture state;
it should not make the observer unconditional.
