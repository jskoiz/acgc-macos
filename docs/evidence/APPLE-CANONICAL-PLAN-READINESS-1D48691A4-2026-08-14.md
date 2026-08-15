# Apple cumulative canonical-plan readiness

Date: 2026-08-14

## Provenance

The read-only M3 Max audit used clean detached ACGC-PC-Port
`1d48691a4fc5f672951d02815723672b2928602e` and clean ac-decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. It made no source, build, test,
launch, asset, callback, Metal-device, presentation, or readback change.

Canonical Depth ordering and the portable Channels ABI have since integrated
as `9f149b6fd9` and `324c174ae3`. The audit's central result remains current:
canonical Geometry is schema-ready, not producer- or Apple-encoder-ready.

## End-state boundary

The Apple renderer must consume a validated cumulative canonical snapshot and a
stable resource-generation snapshot. It must not extend V1-V4, inspect
`PCGXState`, infer state from OpenGL, or parse mutable callback data inside the
Metal encoder.

The intended split is:

- portable schemas validate the fourteen value-only sections;
- the PC producer creates an all-or-nothing immutable canonical snapshot;
- `apple_canonical_plan` validates, copies, cross-checks, and CPU-decodes it;
- `metal_resource_owner` owns stable texture/TLUT/sampler identity and device
  generations;
- `metal_canonical_encoder` converts only a frozen plan into Metal objects and
  commands; and
- exact MSL implements GX vertex, Texgen, Lighting, TEV, fog, alpha, and
  indirect semantics.

The first future Apple source boundary is a pure-C immutable CPU-plan module:

- `pc/apple/include/acgc/apple_canonical_plan.h`;
- `pc/apple/src/apple_canonical_plan.c`; and
- `pc/apple/tests/test_apple_canonical_plan.c`.

It is not dependency-ready until the required portable sections and cumulative
producer/resource contracts are available. It must own copied/decoded values,
vertex/index arrays, resource identities/generations, and canonical cache keys;
it must contain no PC pointers, GL objects, Metal objects, or borrowed bytes.

## Deterministic validation and execution order

```text
envelope bounds and directory validation
typed validation for every present section
cross-section and Geometry dependency validation
resource identity/generation/lifetime validation
CPU decode and triangle/quad normalization
immutable CPU plan publication
resource snapshot acquisition
command buffer and render-pass creation
pipeline/depth/raster/dynamic-state binding
vertex/index/constant/texture/sampler binding
draw encoding
commit
presentation
readback and exact pixel comparison
```

Any unsupported, unresolved, stale, or malformed state rejects that submission;
there is no partial output or reuse of an older plan. Presentation and readback
are separate gates, and neither implies playability.

## Current reusable versus missing pieces

Reusable CPU contracts include the envelope and canonical Geometry, Transform,
Channels, TEV, Blend, Alpha, Depth, and Fog validators. Missing or incomplete
contracts include Texgen/SU, Texture/TLUT, Lighting, Raster, Indirect, Dynamic,
exact Geometry production, complete TEV source state, stable resource ownership,
canonical sampler/pipeline keys, and exact Apple MSL.

The current V1-V4 Apple consumers remain legacy containment. The current
offscreen Metal sink is a synthetic position/color fixture, not a cumulative
game renderer. It does not establish texture, sampler, TEV, fog, Lighting,
alpha-test, scissor, presentation, or game-owned readback behavior.

## Required proof sequence

1. Finish missing portable schemas and setter-owned raw provenance.
2. Capture immutable Geometry and resource generations at the PC flush boundary.
3. Implement and test the all-or-nothing cumulative producer.
4. Implement the pure-C Apple immutable plan and negative fixtures.
5. Implement stable resource ownership and cache epochs.
6. Offline-compile versioned canonical MSL and validate its ABI.
7. Run a device-gated deterministic offscreen encode fixture.
8. Read back and compare exact bytes/pixels.
9. Wire one game-owned canonical callback and repeat readback.
10. Prove drawable presentation separately.

Only the device readback gate can support a pixel claim. A separately observed
presented game frame is still not input, audio, save/reload, device-lifecycle,
iOS, or human-playability proof.

## Evidence boundary

This is read-only architecture and source crosswalk evidence. It proves no
Apple callback, Metal encode/present/readback, pixel, frame, device, launch,
input, audio, save/reload, iOS, Windows runtime, or playability.
