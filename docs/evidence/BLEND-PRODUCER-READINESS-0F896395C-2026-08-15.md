# Blend producer readiness at `0f896395c`

## Provenance

- Canonical PC: `c1/macos-host-launch` at
  `0f896395c84bdcb238ccd0f8ac3c85632d7a8ede`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Read-only M3 Max task:
  `01a004f3-1941-7731-a310-d5ad1f52011b`.
- Source-only bundle SHA-256:
  `a789027090e9f2ce6f6241932cbc4cb9e6f185bcedb069d27b25049afcd09c6c`.
- Frozen topology-control SHA-256:
  `1708b17d9d511dab156d6e085290e855b258403d654496b56b5d194feb2843aa`.
- Detached audit source:
  `/private/tmp/acgc-lane-229-blend-audit-m3`, clean at the canonical PC tip.

The lane made no source, branch, build, test, runtime, asset, or umbrella
change.

## Result: `BLOCK`

The canonical Blend ABI exists, but the PC setter path has no setter-owned raw
Blend state, knownness, sticky invalid history, or raw-to-canonical builder.
The host-only fields in `pc/src/pc_gx.c` and the existing V3 packet mapping are
not truthful provenance for a cumulative canonical snapshot.

The two-upstream crosswalk establishes the following logical state:

| Field | Decomp and canonical domain | Current PC ownership |
| --- | --- | --- |
| mode | `0..3` | host-only `g_gx.blend_mode` |
| source factor | `0..7` | host-only `g_gx.blend_src` |
| destination factor | `0..7` | host-only `g_gx.blend_dst` |
| logic operation | `0..15` | host-only `g_gx.blend_logic_op` |

Decomp `GXSetBlendMode` writes all four logical fields into one BP mode word.
The PC setter already flushes before its equality/host mutation path, but it
does not capture a raw snapshot. Legacy host defaults are not setter
provenance. The producer must retain every valid field even when a particular
mode does not consume it. Blend shares hardware register storage with existing
Alpha/Raster fields, but those logical owners remain separate; `GXSetZCompLoc`
and `GXPokeBlendMode` are out of this producer's scope.

## Smallest dependency-ready successor

One serialized source lane may own exactly:

- `pc/include/pc_gx_internal.h`;
- `pc/src/pc_gx.c`;
- new `pc/tests/pc_gx_blend_raw_shadow_fixture.c`; and
- `pc/CMakeLists.txt`.

It must add a `PCGXRawBlend` containing the fixed-width canonical value, four
known bits, and sticky invalid state; initialize it in `pc_gx_init`; capture a
valid setter call after the existing flush and before host equality handling;
and provide a destination-preserving, fail-closed
`pc_gx_raw_blend_build_canonical()` seam. Invalid mode, factor, or logic-op
input must set sticky invalid without overwriting the last value or knownness.

The focused fixture must cover initial unknownness, all modes, domain
boundaries, alias factors, preservation of unused valid fields, equal-setter
provenance, flush-before-mutation, malformed values, sticky invalidity,
unchanged output on failure, reset, and canonical-validator agreement. A
focused producer-object target and minimal CMake registration are in scope;
the portable canonical ABI, packets, Apple/Metal, cumulative envelope, decomp,
and umbrella source are not.

Because this successor owns `pc_gx.c`, `pc_gx_internal.h`, and CMake, it must
not overlap a Fog or TEV raw-owner source lane.

## Evidence boundary

This is a read-only CPU/source-topology audit. It proves no build, full link,
callback, cumulative producer, runtime, renderer, Metal encode/present/readback,
pixel, device, Windows runtime, or playability state.
