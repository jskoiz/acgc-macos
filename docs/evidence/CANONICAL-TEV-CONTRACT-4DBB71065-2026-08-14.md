# Canonical TEV contract at `4dbb71065`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a002b5-525f-7862-aa8c-0e0ccecdf5c2`
- PC snapshot: `4dbb710653ee76dd6d547b1a352a447e7124b9b8`
- ac-decomp snapshot: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The lane made no edit, branch, commit, build, test, launch, callback, Metal,
asset, pixel, device, or playability operation.

## Contract decision

Canonical `0x0020` TEV can be frozen independently of the cumulative envelope
size. It must describe all 16 GX stages rather than inheriting the current PC
shader cap of 3 or the legacy V2-V4 packet cap of 2.

Directory metadata is version 1, mask `0x0020`, active count `1..16`, capacity
16, size 2560 bytes, and zero reserved metadata. The fixed payload is:

- 64-byte section header;
- sixteen 144-byte stage records;
- four 16-byte exact register records (PREV, REG0, REG1, REG2);
- four 16-byte exact KONST records; and
- four 16-byte swap-table records.

The header fixes offsets/record sizes/counts, component-valid mask `0x0f`, and
zero reserved words. Every inactive stage record after `active_count` is zero.

Each stage carries exact logical GX color/alpha inputs, arithmetic/compare
operations, bias, scale, clamp, output, texcoord/map/order values, raster
channel, konst selectors, swaps, and direct/indirect fields. Validators must
preserve and bound compare operations 8-15, stage 15, null/disabled texture
orders, non-stage-index texture aliases, selector holes, swap values,
cross-section references, indirect state, and all reserved/inactive words.

Register components are signed two's-complement `s32` values constrained to
the GX S10 range `-1024..1023`. KONST components are exact widened `u8` values.
Texture/Texgen/Channel/Indirect references point to their separate canonical
sections; dynamic resource identity remains only in `0x2000`. TEV never
contains pointers, GL IDs, cache hashes, or image/TLUT bytes.

## Two-upstream disagreement and selected behavior

`PCGXState` stores sixteen stage slots and four swap tables, but the shader/key
path clamps execution to three stages and current V2-V4 validation limits a
different semantic subset to two. ac-decomp defines sixteen stages, initializes
through stage 15, uses null orders and variable stage patterns, and preserves
compare operations. Canonical TEV follows the GX/decomp contract, not either
consumer cap.

The PC `GXSetTevOp` expansion also disagrees with decomp for later stages;
canonical state records the actual logical setter state and treats this as a
separate parity risk rather than deriving from shader output.

## Raw signed-S10 producer blocker

The PC setters currently normalize `GXSetTevColorS10`, `GXSetTevColor`, and
`GXSetTevKColor` into host floats, discarding exact setter provenance. Reversing
those floats is not an acceptable wire conversion. A truthful producer must
fail closed until the PC setter/state layer keeps exact raw register/KONST
values, source validity, and overwrite order.

The smallest next source owner is limited to `pc/src/pc_gx.c`,
`pc/include/pc_gx_internal.h`, one focused raw-shadow fixture, and minimal PC
CMake registration. It must not change shaders, Apple/Metal, decomp, V1-V4,
the canonical envelope, or live producer wiring. The later portable TEV ABI
should live in a separate canonical TEV header/source and fixture, following
the established per-section ownership pattern.

## Evidence boundary

This proves only the two-upstream TEV ABI decision, signed-S10 blocker, and
future ownership. It does not prove raw PC shadowing, a live snapshot/callback,
Apple consumption, Metal encode/present/readback, pixel, device behavior, or
playability.
