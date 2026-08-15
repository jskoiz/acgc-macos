# Cumulative producer readiness at `b9a9f355`

Date: 2026-08-15  
Lane: 217 / task `01a00563-bd2c-7cf0-aa82-d5773a4ccdae`  
Type: remote M3 Max read-only source audit

## Provenance

- PC snapshot: `b9a9f355f7d62c14109f711691d8c8fa51ceb7f8`
- PC bundle: `/private/tmp/acgc-canonical-pc-b9a9f35.bundle`
- Verified bundle SHA-256:
  `019d97d9bbe4a0d22565a8233f052a43399d9d2dd7c0e4471f6f35284668768a`
- Remote detached audit checkout:
  `/private/tmp/acgc-lane-217-cumulative-readiness-m3`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Final PC audit status: detached, clean, no diff; decomp was also clean.

The audit did not inspect lane 216's live worktree, build, test, edit source or
documentation, create a branch, launch the game, or access the ISO, `orig/`, or
asset contents.

## Verdict

`b9a9f355` is **not yet dependency-ready for one atomic cumulative canonical GX
envelope**, even if lane 216 later supplies an accepted Geometry leaf producer.
The existing envelope ABI is deterministic and strict, but several required PC
raw owners and leaf producers are still missing.

The frozen envelope is version 1 with magic `0x41434758`, a 48-byte header,
fourteen 32-byte directory entries, payload offset 496, four-byte alignment,
fixed section IDs/masks 1 through 14, and strict reserved-zero and contiguous
offset validation. No compatibility alias or new packet version is needed.

## Section readiness

| Section | Current PC boundary | Readiness |
| --- | --- | --- |
| Geometry | Pointer-free completed `PCGXRawGeometryBatch`; lane 216 separately owns the canonical leaf producer | Pending independent lane-216 review |
| Transform | `PCGXRawTransform` knownness exists; no canonical PC producer | Blocked |
| Channels | `pc_gx_raw_channels_build_canonical()` exists | Leaf-ready only |
| Texgen/SU | Raw shadow exists; no portable canonical section ABI or producer | Blocked |
| Texture | Pointer-free metadata snapshot plus separate borrowed lease | Leaf-ready only; not atomically paired |
| TEV | Host stages and limited raw sidebands; no complete raw knownness/producer | Blocked |
| Lighting | `pc_gx_raw_lighting_build_canonical()` exists | Leaf-ready only |
| Blend | Host-only state; no raw provenance/producer | Blocked |
| Alpha | Canonical producer exists behind the focused producer boundary | Leaf-ready only |
| Depth | Raw shadow exists; no canonical producer | Blocked |
| Raster | Producer exists only in focused fixture/object targets | Leaf-ready only; not production-linked |
| Fog | Host-only state and no-op range-adjust path; no raw producer | Blocked |
| Indirect | Host-only state; no raw owner/producer | Blocked |
| Dynamic | Built with Texture metadata; separate callback-scoped lease | Leaf-ready only; not atomically paired |

## Material blockers

1. No PC cumulative serializer or all-or-nothing publication gate exists.
2. Texgen/SU has no portable section ABI.
3. Transform, TEV, Blend, Depth, Fog, and Indirect lack complete PC canonical
   producers; ABI existence alone is not producer evidence.
4. No builder derives `AcgcGxCanonicalGeometryDependencyResults` atomically
   from Transform, Texgen/SU, Channels, Lighting, and bump/Indirect state.
5. Texture/Dynamic metadata and `PCGXTextureDynamicLease` are published through
   a separate synchronous `void` callback. There is no cumulative acceptance
   result or final lease-generation revalidation gate.
6. The Indirect mutation paths in `pc/src/pc_gx.c` do not currently enforce the
   same pending-batch ordering as decomp `GXBump.c`'s `CHECK_GXBEGIN` boundary.
7. The production target currently links only a subset of the existing leaf
   producers; Geometry and Raster producer macros remain focused-target-only.

## Frozen ordering and ownership

The first honest cumulative publication seam remains immediately after
`pc_gx_raw_geometry_capture_completed(count)` in `pc_gx_flush_vertices()` and
before existing semantic handoffs and legacy GL submission. A future gate must
build every required section into local candidates, derive and validate
cross-section dependencies, validate and recheck the separate resource lease,
and invoke no consumer on any failure. Legacy behavior must continue unchanged
when canonical publication fails.

The eventual cumulative owner may add only a new producer header/source,
focused fixture, and minimal dedicated CMake entries. It must not absorb raw
setters, `pc_gx.c`, Apple/Metal code, or lane 216's Geometry files. Missing raw
snapshots and leaf producers must first land through their own owning lanes.

## Crosswalk

The PC audit covered the cumulative envelope and all current canonical
section validators, `pc_gx_internal.h`, section-specific raw helpers,
`pc_gx.c`, `pc_gx_canonical_snapshot.c`, Texture/TLUT lease code, leaf fixtures,
and the existing V1-V4 callback/registration path. The decomp crosswalk covered
`GXAttr.c`, `GXGeometry.c`, `GXVert.c`, `GXTransform.c`, `GXLight.c`,
`GXTexture.c`, `GXTev.c`, `GXPixel.c`, `GXBump.c`, and representative combined
JSystem/emu64 callers. The project-specific canonical envelope has no decomp
counterpart.

## Claim boundary

This is source/readiness evidence only. It does not accept lane 216, prove a
cumulative producer, link `ac_pc`, launch the game, reach a callback, render
through Metal, read back a pixel, validate a device, sign off Windows, or prove
input, audio, save/load, iOS, or playability.
