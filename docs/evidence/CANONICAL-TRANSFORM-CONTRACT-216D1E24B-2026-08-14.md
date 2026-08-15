# Canonical Transform contract at `216d1e24b`

Date: 2026-08-14

Read-only M3 Max task: `01a002cb-26b4-78d1-b01c-1708f6a7b9e5`

PC snapshot: `216d1e24be5fbb85a3a394cdb1bfd50545b6b6f4`

Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Decision

Canonical Transforms section `0x0002` is frozen as version 1, 888 bytes
(`0x378`), four-byte aligned, count 1, capacity 1, and valid mask `0x0002`.
The common envelope directory entry is its external section header.

Payload layout:

| Offset | Field |
| ---: | --- |
| `0x000` | projection type |
| `0x004` | six projection binary32 bit patterns |
| `0x01c` | known mask |
| `0x020` | current position-matrix logical ID |
| `0x024` | three zero-reserved words |
| `0x030` | ten position records, each 12 words / 3x4 |
| `0x210` | ten normal records, each 9 words / 3x3 |
| `0x378` | end |

The known mask assigns bit 0 to projection, bit 1 to the current matrix
reference, bits 2-11 to position slots 0-9, and bits 12-21 to normal slots
0-9. Bits 22-31 are zero-reserved. Logical position/normal IDs are exactly
`0, 3, ... 27`; malformed IDs may not be silently divided or floored.

Projection type is `GX_PERSPECTIVE` or `GX_ORTHOGRAPHIC`. The six stored
coefficients are the GX-consumed values in decomp `projMtx[0..5]` order. The
future PC shadow must retain the original pre-widescreen setter input rather
than deriving canonical values from the host-adjusted 4x4 matrix.

Unknown fields are explicitly zero and non-renderable. Known float words must
be finite IEEE-754 binary32 values. A known current reference requires a valid
logical ID and a known matching position slot. Immediate and resolved indexed
loads with equal state produce identical bytes; unresolved indexed loads leave
the slot unknown and make a producer fail closed.

## `0x0008` boundary

The Transform section contains no texture matrices. Canonical Texgens/matrices
section `0x0008` exclusively owns ordinary texture matrices and identity,
post-texture matrices and post identity, texgen function/source/normalize and
matrix references, and later manual SU/texture-offset state. Ordinary and post
identity values remain distinct domain-tagged sentinels.

## Two-upstream crosswalk

- PC `PCGXState` stores a host-oriented projection, ten position matrices, ten
  normal matrices, texture matrices, and a slot-valued current matrix.
- PC `GXSetProjection` retains raw input only in a function-static dedup array
  and then stores aspect-adjusted state. Position, normal, and current setters
  silently use `id / 3`.
- PC `GXLoadTexMtxImm` ignores matrix type, always copies twelve floats, and
  lacks a post-matrix domain; that is an `0x0008` gap, not a reason to enlarge
  `0x0002`.
- Decomp `GXTransform.c`, GX enums, private `__gx.h` state, initialization,
  emu64, J2D, and Famicom callers establish the projection coefficients,
  logical IDs, matrix domains, identity sentinels, and representative 2x4/3x4
  use.

## Successor order

There is no remaining ABI decision for `0x0002`. Live production stays
fail-closed until a focused PC Transform/matrix shadow retains raw projection,
strict position/normal/current knownness, and indexed-load resolution. A
separate serial Texgen/SU shadow owns `0x0008`. After those source repairs, a
portable Transform validator/fixture and later snapshot producer may consume
only reviewed state.

## Evidence boundary

This was a read-only architecture audit. It made no edit, branch, build, test,
launch, asset, callback, renderer, Metal, pixel, device, Windows runtime, iOS,
or playability operation.
