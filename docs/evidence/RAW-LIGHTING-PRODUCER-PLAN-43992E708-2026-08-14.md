# Raw Lighting producer plan at PC `43992e708`

Date: 2026-08-14  
Classification: read-only two-upstream architecture evidence  
Result: implementation-ready contract; no producer or runtime proof

## Pinned references

- ACGC-PC-Port: `43992e708572e325f525d3ccdbec7a84793d352d`
- ac-decomp: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Remote source bundle SHA-256:
  `54df26da2f2e943a82a61b2d7e179684b355fce6765c226fce21b2bd3e573890`
- Read-only M3 Max task: `01a002e1-540c-7693-b25d-363a1f209dd4`
- Protected remote worktree: `/private/tmp/acgc-lane-channels-lighting-preflight`

The remote checkout was clean and detached at the pinned PC commit. The task
did not edit source or docs, create a branch or build, launch the game, invoke
LLDB, or read/copy proprietary resources.

## Neutral target contract

The integrated neutral Lighting section is section ID `7`, mask `0x0040`,
version `1`, and a fixed `516`-byte payload aligned to four bytes. It contains
an eight-bit loaded mask followed by eight 64-byte final light-object records.
Each record contains three reserved zero words, logical RGBA8, three angular
attenuation words, three distance-attenuation words, position, and final
direction. All floating-point values are finite binary32 bit patterns. An
unloaded slot is entirely zero. Unknown provenance omits/fails the section; it
is never represented as invented zero state.

The existing validators are:

- `include/acgc/gx_canonical_lighting_state.h`
- `src/gx_canonical_lighting_state.c`:
  `acgc_gx_canonical_lighting_state_validate`
- `src/gx_canonical_lighting_state.c`:
  `acgc_gx_canonical_lighting_metadata_validate`

## Frozen PC raw state

The future PC producer needs a pointer-free shadow with:

- eight slots containing register-order color, angular attenuation, distance
  attenuation, position, and final direction words;
- per-slot known and invalid masks for those five groups;
- an eight-bit loaded mask;
- an eight-bit unresolved-indexed-load mask;
- one known-initialization flag; and
- one sticky global malformed-input flag.

`pc_gx_init` establishes a known empty state. A valid immediate load copies a
complete caller object synchronously, records all five groups as known, and
repairs any prior unresolved state for that slot. An indexed load cannot be
resolved truthfully from the current PC implementation; it marks the target
loaded but unresolved and therefore makes the canonical snapshot unavailable.
Invalid, null, or non-one-hot targets preserve the current PC no-op behavior
while marking provenance invalid rather than inventing slot-zero mutation.
Neither the raw state nor a completed snapshot retains a caller pointer.

## Value rules

ac-decomp stores object/register color as
`R<<24 | G<<16 | B<<8 | A`; the neutral section stores logical RGBA8 as
`R | G<<8 | B<<16 | A<<24`. The producer must convert explicitly and keep the
legacy OpenGL float values unchanged.

The neutral direction is the final light-object direction. In particular,
`GXInitLightDir` stores the negated caller direction, and
`GXGetLightDir` returns its negation. Immediate load copies those final bits
without normalizing. Zero direction is valid. Nonfinite immediate values leave
legacy host behavior unchanged but invalidate raw provenance for publication.

Accepted load targets are exactly the one-hot values `0x001` through `0x080`.
`GX_LIGHT_NULL` is valid only in a channel mask, never as a load target. Spot
and distance constructor enum domains follow ac-decomp; invalid cutoff or
reference inputs take the original OFF/default formula. Constructor enum
values are not serialized.

## Cross-section dependency

Channels owns ambient/material colors, control enable/source/diffuse/
attenuation values, and light masks. Lighting owns only loaded light-object
values. A cross-validator must require every slot referenced by an enabled
color or alpha channel control to be loaded and fully known:

```text
active_channel_light_mask & ~lighting.loaded_mask == 0
```

It must also reject referenced unresolved or invalid slots. Masks belonging
only to disabled controls do not create a Lighting dependency. `GX_AF_SPEC`
requires the effective diffuse mode to be `GX_DF_NONE`.

## Mutation order and future ownership

The future source lane may own only:

- `pc/include/pc_gx_internal.h` raw Lighting state;
- Lighting initialization/conversion/immediate/indexed load/snapshot helpers
  in `pc/src/pc_gx.c`;
- one focused raw-Lighting fixture; and
- minimal fixture registration in `pc/CMakeLists.txt`.

For a producer-visible global mutation, the old completed batch is flushed
first. The implementation then validates and converts into locals, computes
independent legacy and raw changes, commits the raw slot transaction, and
updates the legacy GL state only when its current behavior changes. A raw-only
repair must not create a GL dirty-state change. Caller-owned constructor
helpers and getters do not flush because they do not mutate global Lighting
state.

The focused matrix must cover reset-empty state, all eight slots, register-to-
logical RGBA conversion, signed zero and finite vectors, spot/distance modes,
invalid constructor inputs, direct attenuation, direction/specular formulas,
invalid IDs, indexed unresolved state and immediate repair, nonfinite words,
unloaded/reserved zeroing, equality/no-op behavior, old-batch ordering, and
Channels-to-Lighting reference validation. Native and combined ASan/UBSan
tests plus bounded C/C++/ILP32/Windows syntax probes are appropriate. A real
Windows toolchain/runtime is still required for Windows sign-off.

## Two-upstream anchors

- ac-decomp `src/static/dolphin/gx/GXLight.c`: private record shape,
  `GXInitLight*`, `GXGetLight*`, immediate/indexed loading, one-hot mapping,
  direction convention, and channel control semantics.
- ac-decomp `include/dolphin/gx/GXPriv.h`: private 16-word light layout.
- ac-decomp `include/dolphin/gx/GXEnum.h`: light, spot, distance, diffuse,
  attenuation, and color-source domains.
- ac-decomp `src/static/dolphin/gx/GXVerifXF.c` and `GXVerify.c`: active
  channel-to-light dependency and specular/diffuse validation.
- ACGC-PC-Port `pc/src/pc_gx.c`: `PCGXLightObjInternal`, current helper/load
  behavior, `g_gx.lights`, host color conversion, channel masks, initialization,
  and current OpenGL upload.

Current PC gaps are explicit: raw knownness does not exist, direction lacks the
original negation, canonical register-color conversion is absent, indexed
loads and several specular/getter APIs are missing, and the OpenGL upload is
not a logical-GX oracle.

## Evidence boundary

This document proves a source-level implementation contract and two-upstream
crosswalk only. It proves no raw Lighting implementation, serializer, callback,
Metal encode/present/readback, pixel, launch, Windows runtime, device, iOS, or
playability behavior.
