# Canonical Channels and Lighting contracts at `037689462`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a002e1-540c-7693-b25d-363a1f209dd4`
- PC snapshot: `037689462eaa08b1f08c24748276a0c82bf169c5`
- Decomp snapshot: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The task changed no file, ran no build or launch, and did not access the ISO or
extracted assets. It cross-walked the PC channel/light state and setters with
decomp `GXLight.c`, `GXInit.c`, `GXEnum.h`, `GXLighting.h`, `GXStruct.h`, and
representative J2D, JUT, Famicom, and emu64 callers.

## Frozen Channels contract

Section ID 3 / mask `0x0004` is version 1, 136 bytes, aligned to four bytes,
with directory count/capacity `2/2`. The payload contains:

- `active_count`, bounded `0..2`;
- a two-bit record-valid mask equal to `(1 << active_count) - 1`; and
- two fixed 64-byte logical channel records.

Each active record identifies channel 0 or 1, carries separate six-word color
and alpha controls, then exact packed ambient and material RGBA8 values. Each
control retains enable, ambient/material source, eight-bit light mask, diffuse
function, and attenuation function. `GX_AF_SPEC` canonicalizes the effective
diffuse function to `GX_DF_NONE`, matching the decomp register behavior.

Combined and separate color/alpha setter IDs preserve the untouched component.
Disabled `GX_SRC_VTX` controls remain valid canonical state and do not inherit
the stricter legacy V2/V4 rendering predicate. Inactive records are zero. A
known zero-channel section is present with count zero and two zero records; an
unknown section is absent.

The PC currently normalizes channel colors to floats, overwrites full RGBA for
separate color/alpha IDs, initializes a different logical default, lacks bounds
and knownness, and exposes only a restricted legacy channel subset. These gaps
must be repaired before live production.

## Frozen Lighting contract

Section ID 7 / mask `0x0040` is version 1, 516 bytes, aligned to four bytes,
with directory count/capacity `8/8`. The payload contains an eight-bit loaded
mask followed by eight fixed 64-byte light-slot records. Each loaded record is
the final 16-word GX light object: three zero reserved words, packed RGBA8,
three angular coefficients, three distance coefficients, position XYZ, and raw
direction XYZ. All float words must be finite. Unloaded records are zero.

Immediate light loading accepts exactly one of the eight one-hot light IDs.
Channel masks may combine those bits. Indexed loading must later resolve to a
complete value record or mark the slot unknown; no index or caller pointer
crosses this value ABI. The section stores final coefficients rather than
constructor provenance, and preserves the decomp direction convention and
specular-helper results.

The PC has the correct 16-word object shape and immediate slot mapping, but
loses raw color authority, has no loaded/known mask, stores light direction
with the opposite sign, omits indexed loads and specular helpers, and does not
validate finite values. These are live-producer blockers.

## Cross-section and ownership rules

Channels owns active count, ambient/material colors, controls, and light masks.
Lighting owns loaded light values. Geometry owns vertex colors/normals and
Transforms owns normal matrices. A nonzero channel light bit requires the
corresponding known loaded Lighting slot in the later cumulative validator;
enabled `GX_SRC_VTX` similarly requires the relevant Geometry state.

The selected serial repair order is shared PC shadow scaffolding, exact channel
ownership, exact light-object ownership, independent neutral Channels and
Lighting validators/fixtures, then one CPU-only cumulative snapshot producer.
The overlapping `PCGXState` initializer and `pc_gx.c` setter regions must have
one source owner at a time.

## Evidence boundary

This freezes two source-faithful value contracts and their serial repair order.
It implements neither section and proves no live packet, callback, Metal
encode/present/readback, pixel, device, Windows runtime, iOS, or playability.
