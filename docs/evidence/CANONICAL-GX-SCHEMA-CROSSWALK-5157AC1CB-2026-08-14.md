# Canonical cumulative GX schema crosswalk at `5157ac1cb`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a00275-9cf6-75b0-9275-f7f7f2338084`
- PC snapshot: `5157ac1cbcdc3a0074a407c08874a0861ba20c72`
- ac-decomp snapshot: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Detached worktree: `/private/tmp/acgc-lane-cumulative-state-schema-audit`

The worker made no edits and performed no build, launch, callback, Metal,
pixel, device, or playability test. No ISO, extracted assets, keys, or
proprietary data were accessed.

## Decision

Do not extend semantic packet V1-V4 into V5. They are bounded handoff fixtures,
not cumulative GX state. The end-state contract is a new strict, sectioned,
fixed-width canonical envelope with independently versioned sections and a
validated resource sideband.

The worker's remote umbrella snapshot did not contain the newer fog contract,
so its provisional 13-section mask and hardcoded 23,376-byte total are not
adopted. The integration owner reconciled the crosswalk with
`CANONICAL-FOG-STATE-CONTRACT-59D13A98-2026-08-14.md` and the implemented
80-byte fog section at `b5f550ea0`:

| Bit | Mask | Section |
|---:|---:|---|
| 0 | `0x0001` | Geometry |
| 1 | `0x0002` | Transforms |
| 2 | `0x0004` | Channels |
| 3 | `0x0008` | Texgens/matrices |
| 4 | `0x0010` | Textures/descriptors |
| 5 | `0x0020` | TEV |
| 6 | `0x0040` | Lighting |
| 7 | `0x0080` | Blend/logic |
| 8 | `0x0100` | Alpha test/update |
| 9 | `0x0200` | Depth |
| 10 | `0x0400` | Raster/viewport/scissor |
| 11 | `0x0800` | Fog |
| 12 | `0x1000` | Indirect texturing |
| 13 | `0x2000` | Dynamic resource sideband |

The total envelope byte size remains deliberately unfrozen until each section
has an exact tested ABI. The envelope may carry offsets and sizes, but unknown
sections, masks, versions, sizes, reserved words, overlapping ranges, and
nonzero inactive entries must fail closed. This is strict versioning, not
permissive prefix parsing.

## Wire rules

- Logical little-endian 32-bit words only.
- Signed values are two's-complement `s32`; floating values are IEEE-754
  binary32 bit patterns.
- GX `u8`/`u16` fields are explicitly extended; colors have documented packing.
- No `long`, `size_t`, native enum, native `bool`, pointer, `GLuint`, callback,
  or host struct layout crosses the boundary.
- The envelope contains a magic/version/size/mask/count/directory/payload
  header and a fixed directory entry per known section.
- Each present section has an exact section version, byte size, count,
  capacity, valid mask, and zero-reserved tail.
- Resource bytes remain outside the value packet. Sideband records carry only
  validated handle/kind/generation/size/format metadata, and the consumer must
  copy bytes before asynchronous device work.

These rules are required for arm64 LP64 and Windows LLP64 parity and for any
future cross-endian byte stream.

## Two-upstream field crosswalk

| Section | PC source of truth | ac-decomp behavior oracle | Primary gap |
|---|---|---|---|
| Geometry | `PCGXVertex`, VCD/VAT state, `GXBegin` and vertex setters | `GXGeometry.c`, `GXAttr.c`, emu64 draw callers | V1 omits color1, texcoord1-7, full VCD/VAT, indexed attributes, larger draws |
| Transforms | projection, position/normal/texture matrices, current matrix | `GXTransform.c`, emu64 matrix callers | V3 only carries two texture matrices; canonical state must preserve API values before host aspect transforms |
| Channels | channel colors/control arrays | `GXLight.c`, `GXInit.c`, JUT/J2D/emu64 callers | V2 represents only a strict two-channel subset |
| Lighting | eight `PCGXLightObj` records | `GXLoadLightObjImm` and channel-light setters | Complete light values/attenuation/masks require their own section |
| Texgens | generator type/source/matrix/normalize/post state | `GXSetTexCoordGen2`, matrix setters/callers | Current V2/V3 bounds and representations are incomplete |
| Textures | `PCGXTextureSource`, descriptors, registry/provider | `GXTexObj`, `GXTlutObj`, `GXTexture.c`, emu64 | GL IDs and borrowed pointers are not canonical resource identities |
| TEV | 16 stages, registers, konst colors, swap tables | `GXTev.c`, emu64/JUT/J2D callers | Current two-stage CPU subset omits broad stage/register semantics; signed S10 representation remains unresolved |
| Blend/logic | mode/source/destination/logic fields | `GXSetBlendMode` in `GXPixel.c` | Existing V3 four-word value record is reusable unchanged |
| Alpha | compare functions/refs/op, color/alpha update, z-compare location | `GXSetAlphaCompare`, update setters | V4 carries only alpha update; full compare state is absent |
| Depth | Z compare/func/update, incomplete shadow fields | `GXSetZMode`, pixel/Z texture setters | PC no-op/shadow gaps must be filled before claiming complete provenance |
| Raster | viewport, scissor, cull and later line/point/dither/dst-alpha state | `GXTransform.c`, `GXGeometry.c`, `GXPixel.c` | Encode logical GX values, not OpenGL-derived coordinates; several setters are not shadowed |
| Fog | integrated 80-byte canonical fog section | `GXPixel.c`, `GXInit.c`, active emu64 callers | PC range-adjust API is incomplete; standalone value contract is implemented but not produced live |
| Indirect | four orders, three matrices/scales, per-stage indirect state | `GXBump.c` and initialization callers | V1-V4 encode no indirect state |
| Dynamic sideband | texture registry and provider generation metadata | pointer-bearing GX texture/TLUT objects | Never serialize pointers; owned-copy and generation semantics remain to be wired |

## Validation and fixture priorities

Every array section must prove count/capacity limits, active-record validation,
zero inactive records, malformed enums/masks/sizes, reserved tails, and
cross-field references. Focused fixtures should cover:

- triangle and quad geometry plus unsupported primitive rejection;
- perspective/orthographic transforms and matrix-slot references;
- disabled and lit channel states;
- texture/TLUT descriptors, stale handles, and generation changes;
- TEV stage 15, compare ops, konst and swap state;
- all valid blend modes/factors/logic operations;
- always-pass and threshold alpha tests;
- depth/cull/viewport/scissor bounds;
- inactive, active, range-adjusted, and malformed fog;
- direct and one-stage indirect texturing.

## Remaining design questions

- Preserve signed TEV S10 values versus normalized host floats.
- Decide the canonical draw chunk limit instead of assuming V1's 128 vertices.
- Capture projection before or after PC aspect correction; the canonical API
  contract should prefer pre-host-adjustment values.
- Define the owned resource export API and asynchronous lifetime.
- Add PC shadow state for currently no-op depth/raster/fog setters before those
  sections can claim complete live provenance.

## Next bounded source gate

First implement the strict envelope header/directory validator around the
existing independently tested fog section. It should define the 14 known
section IDs/masks and reject malformed/overlapping/unknown layouts, but it
should not freeze a full payload size or wire a live producer.

After that, blend/logic is the highest-confidence independent value section:
reuse the existing V3 four-field record and mappings, with exhaustive native
and ASan/UBSan fixtures, without touching V1-V4 producers, Apple runtime, or
Metal. PC snapshot and Apple CPU-plan lanes follow only after those neutral
contracts are exact.

No source, Metal, pixel, frame, or playability claim follows from this audit.
