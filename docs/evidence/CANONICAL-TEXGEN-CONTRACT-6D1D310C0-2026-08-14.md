# Canonical Texgen/SU contract at `6d1d310c0`

Date: 2026-08-14

Read-only M3 Max task: `01a002f3-0540-7db0-b2ac-052fed62f957`

References:

- PC snapshot: `6d1d310c08783d356b019b99fce5b1bedcd62def`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Decision

Canonical Texgens section ID `4`, mask `0x0008`, version `1` is frozen at
`0xA40` / 2,624 bytes, four-byte aligned, with common-envelope directory
count/capacity `1/1`. This supersedes the earlier `0xB60` and `0x8D0` drafts.
The common envelope owns section ID, version, byte size, count/capacity, and
mask; the ID4 payload does not duplicate them.

| Offset | Size | Region |
| ---: | ---: | --- |
| `0x000` | `0x040` | 16-word ID4 header |
| `0x040` | `0x100` | eight Texgen records × `0x20` |
| `0x140` | `0x2C0` | eleven ordinary matrix records × `0x40` |
| `0x400` | `0x540` | twenty-one post matrix records × `0x40` |
| `0x940` | `0x100` | eight SU records × `0x20` |
| `0xA40` | — | end |

All serialized fields are explicit little-endian `u32` words. Matrix values
are IEEE-754 binary32 bit patterns. No native enum object, pointer, GL handle,
texture object, or borrowed resource crosses the boundary.

## Header and knownness

The 16 header words are:

1. active Texgen count, `0..8`;
2. Texgen capacity, exactly `8`;
3. known Texgen count, the popcount of the low-eight-bit known mask;
4. ordinary matrix count, the popcount of its low-eleven-bit known-slot mask;
5. ordinary capacity, exactly `11`;
6. post matrix count, the popcount of its low-twenty-one-bit known-slot mask;
7. post capacity, exactly `21`;
8. SU count, the popcount of its low-eight-bit known mask;
9. SU capacity, exactly `8`;
10. Texgen known mask;
11. ordinary known-slot mask;
12. post known-slot mask;
13. SU known mask;
14. four-bit component-known summary;
15–16. zero reserved words.

Component-known bits summarize complete record families: all eight Texgens,
all eleven ordinary matrices, all twenty-one post matrices, and all eight SU
records. They are consistency summaries, not replacements for per-record or
per-word knownness. Unknown components are zero; known inactive Texgen records
may remain nonzero because decomp initializes all eight records while only a
prefix is active.

## Texgen records

Each eight-word record is identified by its fixed TexCoord slot and contains:
function, source, ordinary logical matrix ID, normalize, post logical matrix
ID, a five-bit component-known mask, and two zero-reserved words.

Active records form the exact prefix `[0, active_texgen_count)` and must be
complete. Active ordering is regular matrix functions, then BUMP, then SRTG.
Regular sources are `POS`, `NRM`, `BINRM`, `TANGENT`, `COLOR0/1`, or
`TEX0..7`. BUMP sources are exactly `TEXCOORD0..6`, with at most three BUMP
generators and a source that resolves to an active regular generator. SRTG
accepts only `COLOR0/1`; this is an intentional fail-closed strengthening of
the decomp fallback that aliases any non-`COLOR0` source to `COLOR1`. At most
two color generators are active, each color source appears at most once, and
the first color generator uses `COLOR0`.

All selector domains are exact logical GX values. Host slots, divided IDs,
compressed fields, and enum holes reject.

## Matrix records

Each 16-word record contains the structural logical ID, last load type, last
written word count (`0`, `8`, or `12`), a twelve-bit per-word known mask, and
twelve binary32 words.

Ordinary records are IDs `30,33,...,57,60`; post records are
`64,67,...,121,125`. `GX_IDENTITY` `60` is writable ordinary record 10 and
`GX_PTIDENTITY` `125` is writable post record 20. Neither is implicit or
recordless, and zero is never an implicit identity.

Ordinary loads permit 2x4 and 3x4; post loads require 3x4. A 2x4 load writes
words 0–7 without altering 8–11. A 3x4 load writes all twelve. An unresolved
indexed load zeros and clears knownness only for the attempted range, and a
later immediate load repairs only its written range. Known words must be
finite; unknown words are zero. Last-load type is provenance and is not
required to equal a later generator function. Consumers validate the exact
word range needed by the active use.

## SU records

Each eight-word SU record contains a seven-bit component-known mask, manual
enable, raw S and T scale register words widened from `u16`, S/T bias enables,
and S/T cylinder-wrap enables. All booleans are exactly `0/1`; unknown values
are zero.

The ABI stores raw register words rather than host-normalized values. Enabling
manual scale stores `(scale - 1) mod 65536`, so logical zero produces
`0xFFFF`. Disabling manual scale does not overwrite the prior raw scale words;
`GXSetTexCoordScaleManually(coord, false, 0, 0)` is valid and preserves them.
Bias and cylinder setters remain meaningful while manual scaling is disabled.

When manual mode is disabled, effective automatic SU state depends on
Indirect and TEV stage order, referenced texture maps/dimensions, coordinates,
and texture modes. The cumulative validator must reject missing, stale, or
unresolved cross-sections rather than infer values from GL state. Later
eligible writers win in decomp order; without an eligible writer, the prior
raw manual state remains effective.

## Ownership and two-upstream findings

ID4 owns Texgen records, ordinary/post texture matrices including both writable
identity slots, and manual SU scale/bias/cylinder state. Transform `0x0002`
owns projection/position/normal/current matrices. Raster `0x0400` owns line and
point sizes, `GXTexOffset` modes, and the eight-bit line/point TexCoord-enable
masks even though those bits share hardware SU registers. Textures/Dynamic,
TEV, and Indirect retain their own resources and references.

Decomp `GXTransform.c`, `GXAttr.c`, `GXTexture.c`, `GXGeometry.c`, `GXInit.c`,
`GXVerifXF.c`, and `GXEnum.h` establish these domains and state transitions.
Representative emu64, J2D/JFW/JUT, and Famicom callers cover all-eight
initialization, active count zero/one, both identity domains, 2x4/3x4 loads,
manual scale/bias, disable-with-zero arguments, and indirect/TEV interactions.

PC at `6d1d310c0` is not a truthful producer: it has host-oriented ordinary
matrices, recordless identity aliases, no post/type/per-word matrix state,
file-local normalize/post values, only partial GL Texgen use, no-op scale/bias,
no cylinder implementation, and borrowed texture/TLUT state. Existing V2–V4
handoffs are strict compatibility fixtures, not canonical ID4 production.

## Serial implementation order and boundary

1. Add a neutral ID4 header/source/portable fixture with no `pc_gx` edit.
2. Add one serial PC Texgen/SU shadow owner for exact generator components,
   ordinary/post/identity matrices, per-range indexed knownness, and raw SU
   words; do not overlap Transform, Raster, resources, producer, or Apple.
3. Add the later all-or-nothing cumulative producer at the reviewed
   `pc_gx_flush_vertices()` boundary, with owned resource copying and generation
   recheck before legacy handoffs or GL mutation.

This audit changed no source, ran no build/launch/LLDB, and accessed no assets.
It freezes a neutral CPU value contract only. It does not prove a PC shadow,
producer, callback, Metal encode/present/readback, pixel, device, Windows
runtime, iOS, or playability.
