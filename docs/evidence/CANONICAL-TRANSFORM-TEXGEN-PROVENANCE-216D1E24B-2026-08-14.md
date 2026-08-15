# Canonical Transforms/Texgens provenance at `216d1e24b`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a002be-b284-7492-95f3-c3ad066a2906`
- PC snapshot: `216d1e24be5fbb85a3a394cdb1bfd50545b6b6f4`
- ac-decomp snapshot: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

No edit, branch, commit, build, test, launch, asset, callback, Metal, pixel,
device, or playability operation occurred.

## Gate decision

Neither Transforms `0x0002` nor Texgens/matrices `0x0008` can be truthfully
produced from current PC shadow state. Two independent PC source repairs are
required before neutral section ABI/source work can claim live provenance.

Canonical behavior must preserve:

- raw pre-widescreen projection type plus the six GX coefficients; never the
  host-adjusted projection matrix;
- exact position 3x4 and normal 3x3 matrices and validated logical slot/current
  references;
- distinct ordinary and post texture-matrix domains, including exact 2x4
  versus 3x4 type and active word count;
- texgen function/source/ordinary-matrix/normalize/post-matrix state; and
- manual S/T scale, bias, cylinder-wrap, and line/point offset state.

`GX_IDENTITY` and `GX_PTIDENTITY` are tagged values in distinct domains, not
interchangeable sentinels. Unknown, unsupported, invalid, or unshadowed state
causes all-or-nothing producer rejection; no GL-derived or inverse
widescreen reconstruction is allowed.

## Exact PC gaps

- `GXSetProjection` keeps raw input only in a function-static dedup array that
  is not reset by `pc_gx_init`, then stores host-adjusted state. The repair is
  state-owned raw projection and knownness, including equivalent
  `GXSetProjectionv` handling.
- Position/normal/current matrix IDs are silently floored by division; normal
  3x3 and indexed paths are incomplete. The repair needs validated logical
  slots and per-slot known bits.
- `GXLoadTexMtxImm` ignores its type and always reads twelve floats, which is
  unsafe for valid 2x4 callers. Post-texture IDs are rejected. The repair needs
  distinct ordinary/post storage, exact type, 8/12-word copying, and knownness.
- `GXSetTexCoordGen2` keeps normalize/post state in file-local arrays rather
  than `PCGXState`; invalid destinations are silently ignored.
- manual scale, bias, and texture-offset setters are no-ops, and cylinder wrap
  has no PC implementation. The repair must shadow the exact SU register
  values and booleans rather than infer them from texture dimensions.

The decomp oracle stores six projection coefficients, 8/12-word texture
matrices in separate ordinary/post domains, full texgen normalize/post state,
and exact SU register fields. emu64, J2D, and Famicom callers exercise 2x4 and
3x4 matrices, distinct identity domains, and manual scales in live paths.

## Non-overlapping dependency order

1. Transform/matrix PC source lane: raw projection/reset/knownness,
   position/normal/current slots, normal 3x3, ordinary/post texture IDs, and
   exact 2x4/3x4 loads.
2. Texgen/SU PC source lane: state-owned generator/normalize/post records and
   manual scale/bias/cylinder/offset fields.
3. Separate neutral Transforms and Texgens value contracts/fixtures, without
   freezing total envelope size.
4. The all-or-nothing producer at the selected top-of-`pc_gx_flush_vertices`
   boundary.

The first two lanes both touch `pc_gx`/private state and therefore must run
serially or have disjoint symbol ownership proven before editing. The first
Transform/matrix lane supplies the reference model needed by Texgens.

## Evidence boundary

This proves only two-upstream provenance gaps, selected behavior, fail-closed
rules, and future ownership. It does not implement shadow state or a neutral
ABI, and it does not prove a live snapshot/callback, Metal
encode/present/readback, pixel, device behavior, or playability.
