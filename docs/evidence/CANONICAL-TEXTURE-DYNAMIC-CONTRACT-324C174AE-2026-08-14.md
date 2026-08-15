# Canonical Texture/TLUT and Dynamic resource contract

Date: 2026-08-14

## Provenance and scope

- ACGC-PC-Port audit snapshot: `324c174ae31e06725b51d662f2645cfd8f96c835`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- M3 Max task: `01a00297-d958-73f2-a850-d79a18e5f763`
- Verified source-only bundle SHA-256:
  `7a4a5b3d6b47975456d37bfea522df576a251f1c8b8488a1a5b122cfd5d12c4f`

This was a read-only, two-upstream architecture audit. It did not create a
branch, edit source, build, test, link, launch, use LLDB, run Metal, or inspect
resource bytes or protected assets.

## Contract decision

Textures/TLUT (`0x0010`) and Dynamic resources (`0x2000`) remain separate,
pointer-free value sections. The canonical packet carries only validated
metadata, stable logical identities, owner epochs, generations, and byte
sizes. Resource bytes remain outside the value packet and are exposed through
a synchronous lease boundary. Host pointers, GL names, cache keys, hashes,
and pointer-registry handles are not canonical identities.

### Texture/TLUT section

The frozen implementation target is version `1`, section ID `5`, mask
`0x0010`, alignment `4`, and fixed size `1216` bytes: a 16-word header plus
eight fixed 36-word map records. Directory count/capacity is `8/8` and the
valid mask is exactly `0x0010`.

The header carries known, indexed, mipmapped, TLUT-present, and required map
masks; exact record offset/count/capacity/word count; and resource-ID scheme
`1`. Each map record carries flags; stable image and optional TLUT identities;
owner epoch and 64-bit generation; dimensions, GX format, wrap, filters,
fixed-point LOD/bias, clamp/edge/aniso, mip count, exact byte size/order/source
kind; TLUT slot/format/count/size/order/source kind; and zero reserved words.

Deterministic logical IDs are image map `n` -> `1+n` and TLUT slot `n` ->
`0x100+n`; zero means none. Non-indexed records have zero TLUT identity fields
and `tlut_name = UINT32_MAX`. Indexed records require a valid TLUT relation.
Dimensions are `1..1024`. Exact tiled byte-size calculations use checked
64-bit intermediates and reject overflow or values above `UINT32_MAX`.
Texture-format, wrap, filter, anisotropy, boolean, LOD, and bias domains follow
the decomp-effective GX values. The PC-only `effective_filter` policy is not
game-owned state and is excluded.

### Dynamic resource section

The frozen implementation target is version `1`, section ID `14`, mask
`0x2000`, alignment `4`, and fixed size `1600` bytes: a 16-word header plus 24
fixed 16-word records ordered as eight image maps followed by sixteen TLUT
slots. Directory count/capacity is `24/24` and the valid mask is exactly
`0x2000`.

The header carries a nonzero owner epoch, present/required image and TLUT
masks, exact resource count, record layout, and resource-ID scheme `1`. Each
record carries stable ID, kind, matching owner epoch and 64-bit generation,
owner slot, byte availability/ownership flags, size, explicit byte order,
required 32-byte alignment, source kind, format, element count, and zero
reserved words. Required masks are subsets of present masks. Texture and
Dynamic records must match on ID, epoch, generation, metadata, and required
availability.

## Lifetime and invalidation

The current single global `PCGXTextureSource` generation is insufficient for
independent images and TLUT slots. A source implementation must add a nonzero
provider owner epoch, per-image-map generations, and per-TLUT-slot generations.
Reload, clear, replacement, eviction, conversion, and destruction advance the
affected generation; provider reset advances the epoch. Zero or wrapped
epochs/generations fail closed.

The initial byte API is synchronous:

```text
acquire(context, owner_epoch, resource_id, generation, &lease)
release(context, &lease)
```

The lease is process-local and holds the byte pointer, size, order, alignment,
ownership mode, epoch, and generation. The producer snapshots metadata,
acquires all required leases, rechecks generations, builds and validates the
complete packet, calls the consumer synchronously, then releases the leases.
A borrowed lease cannot survive callback return; asynchronous use requires an
owned copy or a separately proven retained-lease API.

## Two-upstream findings

- PC `pc/src/pc_gx_texture.c` preserves eight maps, sixteen TLUT slots,
  dimensions, formats, base tiled byte sizes, alignment, and a generation-
  bearing borrowed source seam, but drops complete mip/LOD state, independent
  image byte order, TLUT generations, and owner epochs.
- PC texture-pack, EFB, and GL-only replacement paths have no canonical CPU
  bytes and must fail a required-resource preflight rather than expose a GL
  object.
- Decomp `GXTexture.c` preserves the game-facing texture/TLUT fields, while
  `GXTev.c` and `GXBump.c` define direct-map references and direct/indirect
  exclusion. Hardware addresses, region callbacks, and callback-owned objects
  do not cross the canonical boundary.
- Existing Apple V2 provider checks prove a synchronous metadata/borrow/
  generation-recheck pattern only; they are not this canonical ABI and do not
  establish Metal behavior.

## Implementation order and claim boundary

The serial end-state order is: implement both neutral validators with
synthetic values; add raw TexObj/TLUT state and per-resource generations;
repair every resource mutation boundary; add synchronous leases and stale-
generation rejection; add Texture/Dynamic/TEV/Texgen/Indirect cross-validation;
then join the all-or-nothing cumulative producer after Geometry is ready.

The next non-overlapping source lane is the neutral Texture/Dynamic ABI and
synthetic validator fixture. Raw PC Texture/TLUT state and generations remain
a later owner.

This document is architecture-only evidence. It proves no source
implementation, runtime resource delivery, cumulative packet, callback,
Metal operation, pixel, device, iOS, or playability gate.
