# Canonical Geometry contract at `6d1d310c0`

Date: 2026-08-14

Read-only M3 Max task: `01a002f3-0540-7361-875e-f9ccf4038788`

References:

- PC snapshot: `6d1d310c08783d356b019b99fce5b1bedcd62def`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Decision

Canonical Geometry section ID `1`, mask `0x0001`, version `1` is frozen as a
bounded canonical byte layout. Its common-envelope count/capacity is `1/1`,
alignment is four bytes, minimum size is `0x6B0`, and maximum size is
`0x10000`. Version 1 intentionally supports only triangles/quads with at most
128 vertices. It is not full GX topology coverage.

The exact 48-byte section header is:

| Offset | Field | Rule |
| ---: | --- | --- |
| `0x00` | primitive | `1` triangles or `2` quads |
| `0x04` | vertex count | triangles `3..128`, multiple of 3; quads `4..128`, multiple of 4 |
| `0x08` | VTXFMT | `0..7` |
| `0x0c` | descriptor count | exactly 26 |
| `0x10` | present mask | exact active-VCD mask; high bits zero |
| `0x14` | indexed mask | exact INDEX8/INDEX16 mask; high bits zero |
| `0x18` | descriptor offset | exactly `0x30` |
| `0x1c` | descriptor bytes | exactly `0x680` |
| `0x20` | stream offset | exactly `0x6B0` |
| `0x24` | stream bytes | section bytes minus `0x6B0`, at most `0xF950` |
| `0x28`–`0x2c` | reserved | zero |

The fixed prefix is `0x30 + 26 × 0x40 = 0x6B0`.

## Descriptor contract

The 26 fixed descriptor slots preserve the decomp IDs: `PNMTXIDX`,
`TEX0MTXIDX`–`TEX7MTXIDX`, `POS`, `NRM`, `CLR0`, `CLR1`, `TEX0`–`TEX7`, four
guest array slots, and `NBT`. Array slots 21–24 are always absent and zero.

Each 64-byte descriptor contains VCD type, VAT count/type/fraction,
value-encoding and canonical-word count, value offset/bytes/stride/count,
index offset/bytes/stride/count, and two zero-reserved words. For every active
descriptor, value encoding is exactly 1. Present mask equals the set of
non-NONE descriptors; indexed mask equals the set of INDEX8/INDEX16
descriptors. Matrix attributes are effective DIRECT or absent and have zero
VAT fields.

The descriptor offsets are frozen as follows. `value_offset` and
`index_offset` are section-relative byte offsets, never stream-relative or
native pointers.

| Offset | Field |
| ---: | --- |
| `0x00` | VCD type |
| `0x04` | VAT count |
| `0x08` | VAT type |
| `0x0c` | VAT fraction |
| `0x10` | value encoding |
| `0x14` | canonical word count |
| `0x18` | value offset |
| `0x1c` | value bytes |
| `0x20` | value stride |
| `0x24` | value count |
| `0x28` | index offset |
| `0x2c` | index bytes |
| `0x30` | index stride |
| `0x34` | index count |
| `0x38`–`0x3c` | reserved zero |

Canonical word counts are: matrix index 1, position 3, normal 3, direct NBT 9,
color 1, and TexCoord 2. Value stride is words × 4; value and index byte counts
are exact overflow-safe count × stride products. Direct descriptors have one
value per vertex and no index region. Indexed descriptors have one index per
vertex and a deterministic first-use-remapped value table.

The effective one-bit matrix VCD field is captured after hardware-width
truncation: raw INDEX8 becomes NONE and raw INDEX16 becomes DIRECT. NRM and NBT
share one effective field and are mutually exclusive. Version 1 explicitly
rejects `GX_NRM_NBT3` and indexed NBT because the pinned sources do not fully
define a safe deterministic three-index tuple remap.

## Canonical values and stream order

Position supports XY/XYZ and U8/S8/U16/S16/F32, normalized to three binary32
words with canonical `+0.0` Z for XY. TexCoords support S/ST with the same
scalar types and canonical `+0.0` T for S. Integer position/TexCoord values are
exact source integers scaled by `2^-frac` and correctly rounded to binary32.
Normals support S8/S16/F32, using `q/127` or `q/32767` without clamp; direct NBT
emits nine N/B/T words. Known float words must be finite.

Colors canonicalize to `R | G<<8 | B<<16 | A<<24`. RGB565 expands 5/6-bit
channels by bit replication; RGB8/RGBX8 default alpha to 255; RGBA4 multiplies
nibbles by 17; RGBA6 expands each six-bit channel by bit replication; RGBA8
uses exact logical bytes. Guest/source order is decoded explicitly before
little-endian canonical emission. Hardware-ignored VAT arguments are
canonicalized to zero rather than causing false rejection.

Starting at `0x6B0`, descriptors are processed in slot order. Each value region
begins four-byte aligned; an indexed region follows its value region and begins
four-byte aligned. INDEX8 is one unsigned byte; INDEX16 is an explicit
little-endian `u16`. Ranges may end unaligned; zero padding advances to the next
aligned region. Direct values remain in vertex order. Indexed values use
deterministic first-use source-index remapping without deduplicating equal
values from distinct source indices. Gaps and final padding are zero.

## Matrix and cross-section rules

Matrix values are exact low-six-bit logical selectors; division/flooring is
forbidden. Position/normal selectors are `0,3,...,27`. Ordinary texture
selectors are `30,33,...,57,60`.

Absent `PNMTXIDX` resolves the Transform current matrix; present values resolve
known Transform position matrices, plus matching normal matrices when needed.
Absent `TEXnMTXIDX` resolves Texgen record `n`'s ordinary selector; present
values override it per vertex. Ordinary identity selector `60` resolves to the
known writable ID4 ordinary record 10 containing actual matrix words. It is
not implicit or recordless. Post identity `125` is not a Geometry selector but
is likewise a writable ID4 post record when Texgen state references it. Zero is
never implicit identity.

A renderer-ready cumulative packet also enforces:

- Transform projection and effective position/normal matrices;
- Geometry attributes required by Texgen POS/NRM/BINRM/TANGENT/COLOR/TEX
  sources;
- Channels provenance when an effective used channel sources vertex color;
- known Lighting slots for every used light-mask bit;
- NBT, normal-transform, source-coordinate, and light dependencies for BUMP;
- safe owned bounds, endian, stride, element size, and lifetime for indexed
  source arrays; and
- Textures/Dynamic ownership for resource descriptors and copied image/TLUT
  bytes.

## Two-upstream findings and producer boundary

Decomp `GXAttr.c`, `GXGeometry.c`, `GXTransform.c`, `GXInit.c`, `GXEnum.h`, and
representative emu64/GXDraw callers establish the GX namespace, effective
field widths, defaults, formats, exact selectors, and FIFO semantics. PC at the
pinned ref keeps host-oriented `PCGXVertex` storage, drops most VCD/VAT
provenance, casts indexed arrays through host layouts, ignores safe source
bounds, divides matrix IDs, and exposes only a narrow GL subset. That host
layout cannot be serialized as Geometry.

The smallest truthful future capture point remains the top of
`pc_gx_flush_vertices()` immediately after the nonzero-count check and before
the existing V1–V4 handoffs, TEV selection, GL mutation, or pending draw. The
first producer subset is one immutable triangles/quads run with direct
XYZ/F32 POS, optional direct XYZ/F32 NRM, optional RGBA8 CLR0, and optional
ST/F32 TEX0; no indexed, matrix-index, NBT, CLR1, TEX1–7, or NBT3 state.
Merged runs reject until immutable per-run VCD/VAT metadata exists.

## Serial order and evidence boundary

1. Implement the neutral Geometry header/source/portable validator fixture.
2. Add a serial PC VCD/VAT/run-metadata/source-bounds owner.
3. Complete Transform/Texgen and Channels/Lighting provenance.
4. Complete cross-section/resource ownership.
5. Add the all-or-nothing CPU snapshot producer and synthetic producer fixture.

This audit changed no source and ran no build, launch, or debugger. It freezes
a bounded neutral Geometry contract only. It does not implement a PC source
shadow or producer and does not prove callback, Metal encode/present/readback,
pixel, device, Windows runtime, iOS, or playability.
