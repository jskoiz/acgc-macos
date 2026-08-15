# Raw PC Channels producer plan

Date: 2026-08-14

## Provenance

The read-only M3 Max crosswalk inspected exact ACGC-PC-Port
`324c174ae31e06725b51d662f2645cfd8f96c835` from source-only bundle SHA-256
`7a4a5b3d6b47975456d37bfea522df576a251f1c8b8488a1a5b122cfd5d12c4f`,
with ac-decomp oracle
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The worktree remained clean and
read-only. No source, build, test, launch, asset, callback, Metal, device, or
Git mutation occurred.

## Current gap

Canonical PC `324c174ae3` contains the complete 136-byte neutral Channels ABI
and validator but no setter-owned raw Channels provenance. `PCGXState` retains
only legacy host/GL-facing channel counts, float colors, and control arrays.
Those defaults and reductions are not canonical truth:

- PC initializes one host channel, while decomp initializes zero channels;
- zeroed PC attenuation arrays numerically resemble `GX_AF_SPEC`, while decomp
  initializes disabled controls with `GX_AF_NONE`;
- PC color setters currently replace a whole host RGBA value, while original GX
  color-only and alpha-only IDs update only selected components; and
- V2/V4 predicates deliberately reduce accepted state and cannot be reused as
  a cumulative producer.

## Required raw state

The future raw owner needs two records with independent color and alpha
controls, logical packed RGBA8 values, per-component color knownness, a known
active count, and sticky invalidity. The bounded design is:

```c
typedef struct {
    uint32_t enable;
    uint32_t ambient_source;
    uint32_t material_source;
    uint32_t light_mask;
    uint32_t diffuse_function;
    uint32_t attenuation_function;
    uint32_t known;
} PCGXRawChannelControl;

typedef struct {
    uint32_t ambient_rgba8;
    uint32_t material_rgba8;
    uint32_t ambient_component_known;
    uint32_t material_component_known;
    PCGXRawChannelControl color;
    PCGXRawChannelControl alpha;
} PCGXRawChannelRecord;

typedef struct {
    uint32_t active_count;
    uint32_t active_count_known;
    uint32_t invalid;
    PCGXRawChannelRecord records[2];
} PCGXRawChannels;
```

Each control uses six known bits for enable, ambient source, material source,
light mask, diffuse function, and attenuation function. Each logical color uses
four known bits for R/G/B/A. Raw initialization is entirely unknown with
`invalid == 0`; legacy host defaults must not seed it.

Any invalid channel ID, non-boolean enable, unknown source/diffuse/attenuation,
light-mask bit above seven, or `GX_AF_SPEC` combined with a non-`GX_DF_NONE`
effective diffuse value clears raw snapshot values and sets sticky invalidity.
Valid later setters do not silently recover it; production reset occurs only at
`pc_gx_init`.

## Setter semantics and temporal order

Every channel setter must flush a completed old batch before either raw or
legacy state changes. Raw knownness/equality is independent of the legacy
OpenGL equality path: an equal host value can still establish previously
unknown provenance.

- `GXSetNumChans` accepts raw counts `0..2`; changing the active count does not
  erase persistent channel controls/colors.
- `GXSetChanCtrl` accepts IDs `0..5`; combined IDs update both color and alpha,
  while separate IDs update one control. All six domains are validated before
  raw mutation.
- Ambient/material combined IDs replace R/G/B/A; color-only IDs replace RGB and
  preserve A; alpha-only IDs replace A and preserve RGB. Unknown preserved
  components remain unknown until a later setter establishes them.
- Logical color is packed as `r | g<<8 | b<<16 | a<<24`; the decomp hardware
  register's different byte order cannot be copied into the canonical ABI.
- Disabled `GX_SRC_VTX` is valid and retained. Enabled vertex material source
  creates a Geometry color dependency. Enabled lighting creates Lighting and
  normal/matrix dependencies.

The producer may build `AcgcGxCanonicalChannelState` only when active count,
both controls, and every ambient/material component required by each active
record are known and the raw state is not invalid. Inactive 64-byte records are
zeroed, the prefix mask is exact, and the result is passed through the existing
canonical validator.

## Source ownership and fixture

The recommended future owner is:

- small raw state/declaration addition in `pc/include/pc_gx_internal.h`;
- new `pc/src/pc_gx_channels_raw.c` for validation/update/serialization helpers;
- narrow setter calls in `pc/src/pc_gx.c` that preserve legacy arrays and dirty
  behavior;
- new `pc/tests/pc_gx_channels_raw_shadow_fixture.c`; and
- minimal `pc/CMakeLists.txt` registration.

The fixture must cover initialization unknownness, counts `0..3`, combined and
separate controls, partial RGBA sequences, disabled vertex source, high mask
bits, malformed domains, sticky invalidity, equal legacy/unknown raw state,
old-batch observation, inactive zeroing, and final 136-byte validation.

This source lane must wait until active Geometry ownership releases
`pc/include/pc_gx_internal.h`, `pc/src/pc_gx.c`, and `pc/CMakeLists.txt`.
Lighting and cross-section dependency production remain separate later owners.

## Evidence boundary

This is CPU-side source/oracle architecture evidence only. It proves no raw
Channels implementation, cumulative packet, full link, game launch, Apple
consumption, Metal encode/present/readback, pixel, frame, device, input, audio,
save/reload, Windows runtime, iOS, or playability.
