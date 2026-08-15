# Cumulative producer readiness at `0f896395c`

## Provenance

- Canonical PC: `c1/macos-host-launch` at
  `0f896395c84bdcb238ccd0f8ac3c85632d7a8ede`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Read-only M3 Max task:
  `01a00563-bd2c-7cf0-aa82-d5773a4ccdae`.
- Source-only bundle SHA-256:
  `a789027090e9f2ce6f6241932cbc4cb9e6f185bcedb069d27b25049afcd09c6c`.
- Historical control SHA-256:
  `f8cd62e905de36f9aada064ad412ded1a38e50910019f3ca5e9a5dbcc70648b6`.
- Detached audit source:
  `/private/tmp/acgc-lane-231-cumulative-audit-m3`, clean at the canonical PC
  tip with `git diff --check` clean.

The lane made no source, branch, build, test, runtime, asset, or umbrella
change.

## Result: `BLOCK`

The existing version-1, 14-section canonical envelope is not ready for an
all-or-nothing producer. Current section truth is:

| Section | ID/mask | Current readiness |
| --- | --- | --- |
| Geometry | 1 / `0x0001` | Raw owner and leaf exist; dependency results are external and no live wiring exists. |
| Transform | 2 / `0x0002` | Raw owner and leaf exist; the producer object is fixture-only. |
| Channels | 3 / `0x0004` | Raw owner and leaf exist; no cumulative caller exists. |
| Texgen/SU | 4 / `0x0008` | Raw owner and portable ABI exist; the PC leaf producer is missing. |
| Texture | 5 / `0x0010` | Paired snapshot leaf exists; only optional callback wiring exists. |
| TEV | 6 / `0x0020` | Color/KONST provenance exists; complete stage raw ownership and a leaf are missing. |
| Lighting | 7 / `0x0040` | Raw owner and leaf exist; indexed loads fail closed; no cumulative caller exists. |
| Blend | 8 / `0x0080` | Host fields only; raw owner and leaf are missing. |
| Alpha | 9 / `0x0100` | Raw owner and leaf exist; no cumulative caller exists. |
| Depth | 10 / `0x0200` | Raw owner and leaf exist; the producer object is fixture-only. |
| Raster | 11 / `0x0400` | Raw owner and leaf exist; production macro/link wiring is missing. |
| Fog | 12 / `0x0800` | Host fields only; range adjustment is discarded; raw owner and leaf are missing. |
| Indirect | 13 / `0x1000` | Host fields only; flush-safe bounded raw ownership and a leaf are missing. |
| Dynamic | 14 / `0x2000` | Texture/Dynamic snapshot and leases exist; atomic cumulative publication does not. |

The envelope implementation currently initializes and validates the header and
directory only. `pc_gx_flush_vertices()` still performs Geometry capture,
optional Texture/Dynamic observation, V1-V4 semantic handoffs, and legacy GL;
there is no cumulative payload serializer or atomic publication point.

The current CMake tree defines focused producer objects for Transform, Depth,
and Geometry, but does not link them into `ac_pc`. Raster likewise lacks its
production macro. This is separate from the missing logical-state owners: link
wiring alone cannot make Texgen/SU, TEV, Blend, Fog, or Indirect truthful.

Geometry also needs an atomic builder for its cross-section dependency results.
Texture/Dynamic leases are sound for their current synchronous callback, but a
future cumulative producer must validate all values, dependencies, and leases
before one publication and must never emit a partial callback.

## Safe dependency order

1. Add the Texgen/SU raw-to-canonical leaf in new PC files plus a focused
   fixture and minimal registration.
2. Complete TEV raw stage ownership and its leaf under one serialized owner of
   `pc_gx.c`, `pc_gx_internal.h`, and shared CMake.
3. Serialize the overlapping Pixel/Raster/Indirect provenance work. Blend and
   Fog each need their audited raw owners; Indirect must also coordinate TEV
   and Geometry dependency results.
4. Add the Geometry dependency-result builder.
5. Only then freeze and implement the final cumulative assembler: take one
   complete local snapshot, validate every cross-section dependency and lease,
   serialize the existing little-endian envelope, and publish exactly once
   after full preflight.

The shared `pc_gx.c`, `pc_gx_internal.h`, and `pc/CMakeLists.txt` ownership
means these producer lanes may not edit concurrently. The immediate
dependency-ready source gate is the new-file Texgen/SU leaf; the final
assembler is not yet a valid implementation lane.

## Evidence boundary

This is a read-only CPU/source-readiness audit. It proves no build, production
link, callback, cumulative packet, runtime, renderer, Metal
encode/present/readback, pixel, device, Windows runtime, or playability state.
