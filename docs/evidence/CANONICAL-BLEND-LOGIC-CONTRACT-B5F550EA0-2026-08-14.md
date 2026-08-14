# Canonical Blend/logic contract at `b5f550ea0`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a0029d-475b-7971-aead-39fe8fc4bc8e`
- PC snapshot: `b5f550ea028ab933b8433ec2e9d29768252cabdc`
- ac-decomp snapshot: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The lane made no edit, branch, build, launch, LLDB, callback, asset, Metal,
pixel, device, or playability operation.

## Decision

Canonical section mask `0x0080` is exactly the existing four-word V3 Blend
record, without importing Alpha/update or Raster state:

```c
typedef struct AcgcGxCanonicalBlendState {
    uint32_t mode;
    uint32_t source_factor;
    uint32_t destination_factor;
    uint32_t logic_op;
} AcgcGxCanonicalBlendState;
```

The logical little-endian ABI is version 1, 16 bytes, four-byte aligned, count
1, capacity 1, and has no reserved tail. Field offsets are 0, 4, 8, and 12.
The validator accepts modes `0..3`, source and destination factors `0..7`, and
logic operations `0..15`. Unknown or sentinel values fail closed.

There are deliberately no mode-dependent normalization rules. `GX_BM_NONE`
still transports bounded inactive factor/logic words; `GX_BM_LOGIC` still
transports bounded factors; `GX_BM_SUBTRACT` still transports a bounded logic
word. `GX_LO_NOOP` is numeric value 5. Factor values 2 and 3 retain their GX
slot-dependent meaning through their field position.

The envelope entry must have exact section/version/mask/size/count/capacity,
aligned non-overlapping range, and zero reserved metadata. Prefix-compatible
sizes, nonzero inactive metadata, unknown masks/versions, gaps, overlaps, and
malformed ranges reject.

## State ownership boundary

- `0x0080` Blend/logic owns only `GXSetBlendMode(type, src, dst, logic)`.
- `0x0100` Alpha owns alpha comparison, color update, alpha update, and the
  currently selected `z_comp_loc` contract.
- `0x0400` Raster owns dither and destination alpha.

The existing 20-byte Alpha architecture estimate is not a frozen ABI. The
audited minimum for five compare words, two update words, and `z_comp_loc` is
32 bytes. Blend must not be widened to hide that discrepancy.

## Two-upstream crosswalk

The PC port stores the four blend fields in `PCGXState`, and the existing V3
mapper/validator already accepts the exact GX domains. V4 preserves that V3
payload and appends only alpha-update state; V1-V4 remain frozen.

ac-decomp `GXPixel.c` stores Blend mode/subtract/logic-enable/logic-op/factors
separately from color/alpha update, dither, and destination alpha. `GXEnum.h`
defines contiguous mode `0..3`, factor `0..7`, and logic `0..15` domains.
`emu64` and J2D exercise ordinary source-alpha, destination-alpha, NOOP, and SET
patterns. The narrower Apple V4 renderer subset and current OpenGL
approximation are consumers, not canonical validity rules.

## Successor and evidence boundary

The smallest source successor owns only a new canonical Blend header/source,
one portable fixture, and minimal portable CMake registration. It must not
touch the common envelope implementation, V1-V4, `pc_gx`, Apple/Metal,
ac-decomp, Alpha, Depth, Raster, or sideband code.

Focused native and combined ASan/UBSan tests can prove fixed-width layout,
enum bounds, inactive-field transport, malformed metadata rejection, and
sanitizer cleanliness. They cannot prove a live snapshot, callback, Metal
encode/present/readback, pixel, device behavior, or playability.
