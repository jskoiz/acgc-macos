# Canonical fog-state contract from `59d13a98`

## Scope and provenance

Remote M3 Max lane 151 (`01a0025c-b5aa-7c73-9002-64ee26c07776`) performed a
read-only contract audit at PC
`59d13a98e06c4a67c67b5936f5257a6ff82c0d7a`, ac-decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`, and umbrella architecture
evidence `c084093c48b768ca9cd7cd8ed854ea57437544ad`. The remote sandbox correctly
prevented artifact writes, so this integration-owner file is the durable
record. No source, branch, worktree, build, test, launch, asset, or ISO was
mutated or accessed.

## Architecture decision

Keep V1-V4 unchanged. Do not relax V2 for non-`NONE` fog and do not create a
blind V5. Fog is an independently testable section of the deliberately named
cumulative canonical value-only packet. Texture bytes, TLUTs, pointers, and
the 64-bit generation token remain in the synchronous borrowed resource
sideband.

The canonical fog section is 20 `uint32_t` words / 80 bytes:

```text
type
start_z_bits, end_z_bits, near_z_bits, far_z_bits
color_rgba8
range_adjust_enable
range_adjust_center
range_adjust[10]
reserved[2]
```

Floating values use binary32 bit representations. Color packs R/G/B/A in
successive bytes. The ten range entries are widened copies of the 12-bit GX
values; enabled range adjustment without host-side source storage fails
closed.

Accepted fog enum values are `{0,2,4,5,6,7,10,12,13,14,15}`. Active fog
requires finite parameters, `far >= 0`, and `far >= near`. Equal denominators
retain the decomp fallback `A=0, B=.5, C=0`. Range adjustment requires
`center <= 681`, each entry at most 12 bits, and zero reserved words.

## Canonical masks and layout target

```text
GEOMETRY 0x00000001  TRANSFORMS 0x00000002  CHANNELS 0x00000004
TEXGENS  0x00000008  TEXTURES   0x00000010  TEV      0x00000020
LIGHTING 0x00000040  BLEND      0x00000080  ALPHA    0x00000100
DEPTH    0x00000200  RASTER     0x00000400  FOG      0x00000800
INDIRECT 0x00001000  DYNAMIC    0x00002000
```

`required_state_mask` must be a subset of `known_state_mask`; reserved bits
and fields must be zero. FOG and INDIRECT are explicitly known even when
disabled. Missing required state, unsupported lighting/indirect/dynamic data,
unknown fog, malformed TEV references, or missing texture sideband reject.

The audited cumulative layout target is 5,796 bytes, all fields four-byte
aligned and with no pointers or variable tails:

```text
header 48; frozen V1 geometry 4800; fog 80; channels[2] 112;
texgens[2] 232; TEV[3] 312; TEV registers 48; swap tables 64;
blend 16; alpha 20; depth 12; raster 52
```

The non-fog sections still require exact field-level crosswalk before the full
packet is frozen; the size budget is an architecture target, not an
implemented ABI.

## Crosswalk

- PC `pc/src/pc_gx.c`: `GXSetFog` storage, V2 rejection, packet builder, and
  texture-source sideband ownership.
- Decomp `src/static/dolphin/gx/GXPixel.c`: fog coefficient/register oracle
  and range-adjust semantics.
- Decomp `src/static/libforest/emu64/emu64.c`: observed perspective-linear fog.
- Decomp `m_kankyo.c`, `m_play.c`, and lighting records: game fog color and
  near/far sources.
- Apple `metal_packet_consumer.c` and `metal_state_fixture`: no native fog
  section exists today; `pc_metal_runtime.c` remains separate lane ownership.

## Next bounded gate

The dependency-ready source slice is an end-state reusable canonical fog value
section plus validator and portable fixtures. It must not yet freeze the
entire cumulative packet, touch `pc_gx.c`, or touch `pc_metal_runtime.c`.
Parallel read-only work may finish the exact channel/texgen/TEV/blend/depth/
raster field schema and Apple encoder ownership before packet composition.

CPU tests can prove fixed width, masks, validation, coefficient/register
oracle, and malformed-state rejection. Metal shader mode mapping, range-adjust
rendering, device submission, frame output, and pixel readback remain later,
separate gates.
