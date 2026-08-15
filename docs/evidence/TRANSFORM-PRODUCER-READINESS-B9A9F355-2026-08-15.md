# Transform producer readiness at `b9a9f355`

## Scope and provenance

Lane 221 was an independent read-only audit on the M3 Max. It verified
`ACGC-PC-Port` `b9a9f355f7d62c14109f711691d8c8fa51ceb7f8` and `ac-decomp`
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The source-only bundle and four
Transform control files matched their supplied SHA-256 values. The detached
audit source was clean. No source, build, test, runtime, asset, or integration
mutation occurred.

## Verdict

`READY`. `PCGXRawTransform` and the frozen canonical Transform section are
sufficient for a deterministic, all-or-nothing leaf producer. No predecessor
raw-owner repair is required.

The raw owner is value-only state with no retained pointers. It supplies:

- the known projection type and six exact GX projection words;
- ten 3x4 position slots and ten 3x3 normal slots with per-slot knownness;
- the current position-matrix ID and its knownness;
- sticky invalid state and explicit unresolved indexed-load flags; and
- exact binary32 words that can be rejected when a known value is non-finite.

Unknown matrix slots remain zero in the canonical result. Any unresolved
indexed slot rejects the complete production attempt. Normal matrices are the
captured GX register words; the producer must not derive inverse-transpose or
host matrices. Texture and post-transform matrices belong to the independent
Texgen/SU section, not Transform. Geometry/VCD/VAT state affects consumption
but does not own Transform values. The project canonical producer has no
counterpart in `ac-decomp`.

## Frozen successor contract

The smallest source successor owns only:

- `pc/include/pc_gx_transform_producer.h`;
- `pc/src/pc_gx_transform_producer.c`;
- one focused producer fixture; and
- minimal `pc/CMakeLists.txt` registration.

The proposed API is:

```c
int pc_gx_raw_transform_build_canonical(
    const PCGXRawTransform *input,
    AcgcGxCanonicalTransformState *output);
```

The implementation must build and validate a local candidate, then assign the
caller-owned output only on success. Null arguments, sticky invalid state,
unknown or invalid projection, malformed or mismatched current position,
unresolved indexed slots, non-finite known words, or canonical validation
failure must leave the destination unchanged. Host reconstruction, texture
matrix reads, callbacks, packet/envelope assembly, and renderer work are out of
scope.

Focused native and combined ASan/UBSan tests must cover complete and partial
state, projection domains, legal matrix IDs, current-position dependency,
immediate position/normal words, unresolved indexed loads, non-finite values,
invalid state, destination preservation, and canonical validation. Syntax
probes are portability evidence only, not Windows sign-off.

## Evidence boundary

This audit proves source-contract readiness only. It does not prove a producer
implementation, full `ac_pc` link, runtime callback, cumulative packet, Metal
encode/present/readback, pixel, input, audio, save, simulator, device, Windows
runtime, or playability.
