# Apple V2 sink-status policy at `59d13a98`

## Scope and provenance

Remote M3 Max lane 148 (`01a00250-4e56-7d20-b951-a9b9fc4f57f4`) performed a
read-only crosswalk of ACGC-PC-Port
`59d13a98e06c4a67c67b5936f5257a6ff82c0d7a`, ac-decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`, and umbrella evidence at
`c084093`. It made no source/docs change, build, launch, asset access, or ISO
access. The final handoff SHA-256 is
`6e1f90d054f21fc9ab4272d13d74574651c79aabf2927861d5f492cee3dd8088`.

## Finding

The prior source-reachability concern is a concrete CPU-side status-policy
defect, conditional on a V2 packet first passing the GX validator.

`acgc_metal_packet_consumer_prepare_v2` can return `OK` for ordinary V2 while
marking its output `V2_EXTENSION_NOT_RENDERED`. The typed handoff forwards the
output because its consumer status is `OK`. `pc_metal_runtime_observe` blocks
provider-backed `V2_EXTENSION_CPU_RESOLVED`, and checks V3/V4 extension
statuses, but never rejects `V2_EXTENSION_NOT_RENDERED`. The ordinary V2
output can therefore reach `acgc_metal_sink_submit`.

That is unsafe. V2 carries meaningful channel, texgen, texture/TLUT, sampler,
and TEV state, while the current Metal sink consumes only position, transform,
and packed vertex color. Submitting the V1 geometry prefix can silently drop
color-affecting TEV semantics. The legacy OpenGL draw remains independent of
this observer path.

## Crosswalk

- PC `pc/src/pc_gx.c`: flush and V2 callback routing.
- PC `pc/apple/src/metal_packet_consumer.c`: ordinary and provider-backed V2
  preparation plus typed handoff.
- PC `pc/apple/src/pc_metal_runtime.c`: sink eligibility and observer.
- PC `pc/apple/src/metal_sink.m`: geometry-only shader/sink.
- Decomp `JUTResFont.cpp`, `ks_nes_draw.cpp`, and `J2DGrafContext.cpp`:
  color-affecting texture and TEV use.

## Next bounded gate

Lane 150 owns only `pc/apple/src/pc_metal_runtime.c` and the existing V2
runtime-sideband fixture. It must preserve V1 behavior and fail closed for both
`V2_EXTENSION_NOT_RENDERED` and `V2_EXTENSION_CPU_RESOLVED`, including
malformed status combinations. Native and combined ASan/UBSan focused tests
are required before integration.

This audit proves a static CPU policy defect. It does not prove a live
callback, Metal encode/present/readback, pixel, device, or playability gate.
