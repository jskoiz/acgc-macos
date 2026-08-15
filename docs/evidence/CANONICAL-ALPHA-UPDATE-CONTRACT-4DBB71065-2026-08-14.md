# Canonical Alpha test/update contract at `4dbb71065`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a002b5-525f-7480-81df-8c9bde594295`
- PC snapshot: `4dbb710653ee76dd6d547b1a352a447e7124b9b8`
- ac-decomp snapshot: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The lane made no edit, branch, commit, build, test, launch, LLDB, asset,
callback, Metal, pixel, device, or playability operation.

## Frozen `0x0100` contract

Canonical section ID 9 is version 1, 32 bytes, four-byte aligned,
count/capacity 1, valid mask `0x0100`, and eight logical little-endian
`uint32` words:

| Offset | Field | Accepted domain |
|---:|---|---|
| 0 | `comp0` | `0..7` |
| 4 | `ref0` | `0..255` |
| 8 | `op` | `0..3` |
| 12 | `comp1` | `0..7` |
| 16 | `ref1` | `0..255` |
| 20 | `color_update_enable` | exactly `0/1` |
| 24 | `alpha_update_enable` | exactly `0/1` |
| 28 | `z_comp_loc_before_tex` | exactly `0/1` |

There is no payload reserved tail. References remain serialized even when an
`ALWAYS` or `NEVER` comparison makes them mathematically inactive; no enum,
reference, or mode normalization is permitted. Unknown/sentinel comparison,
operator, reference, and boolean values fail closed.

The common envelope keeps its fixed header/directory, contiguous aligned
payload, exact total-size, and zero inactive/reserved rules. Depth compare
enable/function/update remain in Depth `0x0200`; dither and destination alpha
remain in Raster `0x0400`; Blend/logic remains `0x0080`.

## Two-upstream crosswalk and producer gap

The PC port shadows alpha comparison, references, operator, color update, and
alpha update as host `int` values and consumes them in the fragment path. V4
exposes only `alpha_update_enable`; V2/V3 do not carry the full Alpha contract.
`GXSetZCompLoc` is a PC no-op and `PCGXState` has no corresponding field.

ac-decomp `GXTev.c` preserves both 8-bit references, both 3-bit comparisons,
and the 2-bit operator. `GXPixel.c` separately preserves color update, alpha
update, and the `before_tex` Z-compare-location bit. Representative emu64,
J2D, JFW, and Famicom callers use these semantics. The decomp default is
`ALWAYS,0,AND,ALWAYS,0`, color/alpha update enabled, and `ZCompLoc=true`.

The Alpha ABI is frozen, but a truthful live producer must fail closed until a
later PC state lane shadows `GXSetZCompLoc`; this audit does not fabricate that
missing provenance.

## Future source fixture and boundary

The smallest source lane owns only a new canonical Alpha header/source, one
portable fixture, and minimal portable CMake registration. It must cover exact
size/alignment/offsets, all boundary domains, inactive nonzero references,
independent update combinations, malformed values, and exact present/absent
envelope metadata. It must not modify the common envelope, Blend, V1-V4,
`pc_gx`, Apple/Metal, Depth, Raster, sideband, or ac-decomp.

Passing focused native and combined ASan/UBSan tests would prove only a
portable CPU Alpha value ABI and validator. It would not prove PC-originated
`ZCompLoc`, a live snapshot/callback, Metal encode/present/readback, pixel,
device behavior, or playability.
