# Fog producer readiness at `0f896395c`

## Provenance

- Canonical PC: `c1/macos-host-launch` at
  `0f896395c84bdcb238ccd0f8ac3c85632d7a8ede`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Read-only M3 Max task:
  `01a004f3-5a55-7702-95ec-8acf22b8b806`.
- Source-only bundle SHA-256:
  `a789027090e9f2ce6f6241932cbc4cb9e6f185bcedb069d27b25049afcd09c6c`.
- Frozen topology-control SHA-256:
  `1708b17d9d511dab156d6e085290e855b258403d654496b56b5d194feb2843aa`.
- Detached audit source:
  `/private/tmp/acgc-lane-230-fog-audit-m3`, clean at the canonical PC tip.

The lane made no source, branch, build, test, runtime, asset, or umbrella
change.

## Result: `BLOCK`

Current PC Fog state is not setter-owned provenance. `GXSetFog` retains only
host float/color state, `GXInitFogAdjTable` is a no-op, and
`GXSetFogRangeAdj` discards its enable, center, and table arguments. There is
no `PCGXRawFog`, knownness, sticky invalid state, or canonical Fog producer.

The existing canonical section is fixed-width section ID 12, mask `0x0800`,
version 1, and 80 bytes. A truthful producer must preserve:

- the exact Fog API enum;
- the four input binary32 words in start/end/near/far order;
- logical RGBA8 bytes before host normalization;
- range-adjust enable and the original widened `u16` center; and
- a synchronous copy of all ten widened 12-bit table entries when enabled.

Decomp reads the table only for enabled range adjustment. The default disabled
call supplies a null table, which must not be dereferenced or retained. Both
setter paths must flush a completed batch before raw mutation, and raw capture
must precede a host equality early return. Host floats or packed BP
coefficients cannot be used to reconstruct the logical input.

## Smallest dependency-ready successor

One serialized source lane may own exactly:

- `pc/include/pc_gx_internal.h`;
- `pc/src/pc_gx.c`;
- new `pc/include/pc_gx_fog_producer.h`;
- new `pc/src/pc_gx_fog_producer.c`;
- new `pc/tests/pc_gx_fog_raw_shadow_fixture.c`;
- new `pc/tests/pc_gx_fog_producer_fixture.c`; and
- `pc/CMakeLists.txt`.

It must add `PCGXRawFog` with the fixed-width canonical value, exact field
knownness, and sticky invalid state; implement source-faithful caller-buffer
generation for `GXInitFogAdjTable`; capture or synchronously copy the logical
setter inputs; and expose a destination-preserving, fail-closed
`pc_gx_raw_fog_build_canonical()` seam. Existing Blend, TEV, shader, packet,
and semantic ownership stays out of scope.

Focused native and combined ASan/UBSan fixtures must cover binary32 and RGBA
bit preservation, repeated setters, flush ordering, table generation and
synchronous copy, enabled/null rejection, disabled/null behavior, table/domain
failures, incomplete knownness, sticky invalidity, output preservation, and C
and C++ header compatibility. A focused producer-object target and minimal
CMake registration are sufficient; no full `ac_pc` link is part of this gate.

Two reference differences must remain explicit during implementation:

1. Decomp always packs `center + 342` into ten register bits, while the
   existing canonical validator retains the full caller `u16` when range
   adjustment is disabled and applies the `<= 681` register limit only when
   enabled.
2. The raw owner must preserve the API Fog enum—including orthographic
   variants—and must not infer it from the decomp's packed projection bit.

Because this successor owns `pc_gx.c`, `pc_gx_internal.h`, and CMake, it must
not overlap Blend or TEV raw-owner source work.

## Evidence boundary

This is a read-only CPU/source-topology audit. It proves no build, full link,
callback, cumulative producer, runtime, renderer, Metal encode/present/readback,
pixel, device, Windows runtime, or playability state.
