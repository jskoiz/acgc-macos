# Pixel-state leaf-producer topology at `689590cc`

## Provenance

Lane 225 was a read-only M3 Max audit of clean, detached `ACGC-PC-Port`
`689590cc9696daeae55e73f5bf749c28317b6693` and clean `ac-decomp`
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The PC source-only bundle matched
SHA-256 `30cd438904f7ebe89394e35e35043208cffc4f67d6a89c31138d1735f48af9de`.
The documentation-only control archive matched SHA-256
`4a056599e410c92ddbb0c8e3b29783c040af89d87775a68f3714392a5422fe14`
before extraction and contained exactly the ten named evidence files. Older
remote umbrella snapshots were disregarded. No source, build, test, integration,
runtime, or asset mutation occurred.

## Verdicts

### Alpha — `READY`

The 32-byte section has complete setter-owned `PCGXRawAlpha` knownness and
sticky invalidity. Setters retain the exact compare/ref/operator/update/ZCompLoc
values and flush completed batches before mutation. The existing
`pc_gx_raw_alpha_build_canonical()` requires all eight fields, rejects invalid
state, validates the canonical result, and preserves the logical caller values.
No predecessor repair is required. This is still only an independent leaf; it
is not joined into a cumulative producer.

### Blend/Logic — `BLOCKED`

The 16-byte canonical validator is complete, but the PC has only legacy host
blend fields. It lacks a setter-owned `PCGXRawBlend`, knownness, sticky invalid
state, and canonical builder. The smallest predecessor captures the exact mode,
source factor, destination factor, and logic operation before equality/host
paths, adds a focused fixture, and does not reuse the legacy V3 packet shape.

### Depth — `BLOCKED` on converter only

`PCGXRawDepth` already supplies exact booleans, compare function, knownness, and
flush-before-mutation through `GXSetZMode`. The fixed 16-byte canonical Depth
validator is complete. The missing slice is only a production converter/API,
focused converter fixture, and canonical Depth link/object registration. The
converter must build a local candidate, validate it, and leave the caller's
destination unchanged on every failure.

### Fog — `BLOCKED`

The canonical 80-byte Fog section is complete, but PC retains only host floats,
color, and type. `GXSetFogRangeAdj()` discards enable, center, and the ten-entry
table, and `GXInitFogAdjTable()` is a no-op. The predecessor must retain exact
logical caller values, copy the complete table synchronously, track knownness
and invalidity, and prohibit any caller pointer from crossing the boundary.

## Dependency order

Depth is the smallest immediately dependency-ready converter. Blend and Fog
require serialized raw-owner lanes because they overlap `pc_gx.c`,
`pc_gx_internal.h`, and `pc/CMakeLists.txt`. Alpha needs no independent repair.
After the separate leaf contracts exist, a later cumulative producer may join
them through the strict envelope masks and dependency rules; V1-V4 packet
builders are not that cumulative producer.

## Evidence boundary

These are CPU/source topology verdicts only. They do not prove new source,
tests, a cumulative packet, full link, callback, runtime, Metal
encode/present/readback, pixel, input, audio, save, simulator, device, Windows
runtime, or playability.
