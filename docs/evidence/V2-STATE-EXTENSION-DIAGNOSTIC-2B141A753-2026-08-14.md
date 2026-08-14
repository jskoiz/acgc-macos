# V2 state-extension diagnostic — `2b141a753`

Date: 2026-08-14  
Lane: `01a0017d-d42d-74f0-846c-f4a97c5d6193` (remote M3 Max, Luna Max/max)  
Result: complete/parked; no source edit

## Scope and provenance

The lane was intentionally limited to `pc/src/pc_gx.c`, one new focused
state-extension fixture, and minimal CMake registration. It was based on
`upstream/ACGC-PC-Port` `2b141a753ab948e9494c97daf8490673c61be9fc` and
crosswalked against `upstream/ac-decomp`
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The dedicated branch was
`c1/lane-v2-state-extension-m3` in
`/private/tmp/acgc-lane-v2-state-extension-m3`.

## Crosswalk result

- The PC V2 channel predicate at `pc/src/pc_gx.c:713` requires register
  ambient and material sources, and the V2 builder hard-codes register
  sources.
- The decomp `emu64::dirty_check` path at `src/static/libforest/emu64/emu64.c:3187`
  sets disabled channels to `GX_SRC_REG/GX_SRC_VTX`.
- The V2 packet header advertises a vertex-source value, but the exact-base
  validator at `src/gx_semantic_packet.c:174` rejects every V2 channel whose
  material source is not `REGISTER`.
- Therefore accepting this live state requires packet-validator and Apple
  consumer semantic changes, not a safe predicate-only edit in `pc_gx.c`.
- The decomp's ordinary blend tuple (`GX_BM_NONE/SRCALPHA/INVSRCALPHA/NOOP`)
  is effectively no blending, but relaxing blend factors alone would not make
  the channel state representable. Texture-map aliases remain bounded by the
  existing V2 stage predicate and packet validator.

## Verification and boundary

The lane stopped before edits as required by its ownership contract. The
dedicated worktree was clean at the base commit (`git diff --check` passed),
the decomp checkout was clean, and the native/ASan roots were never created.
No configure, build, launch, runtime, Metal, device, or asset operation was
performed. The remote source worktree contains pre-existing `assets/` and
`orig/` directories and is preserved rather than deleting those paths.

This is a CPU/source crosswalk only. It does not prove a live callback, Metal
encode/present/readback, rendered pixel/frame, input, audio, save persistence,
device, simulator, or playability. The useful successor is a separately owned
packet-validator/Apple-consumer contract lane that can extend the ABI and
consumer together while preserving V1/V2 fail-closed behavior.
