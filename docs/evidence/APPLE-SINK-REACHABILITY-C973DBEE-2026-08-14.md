# Apple sink reachability audit — PC c973dbee

## Result

The read-only M3 Max audit mapped the complete CPU path from GX flush to the
offscreen Metal sink and found two distinct V2 outcomes:

```text
GXEnd / completed GXBegin
  -> pc_gx_flush_vertices
  -> direct or grouped V2 builder
  -> acgc_gx_semantic_packet_v2_validate
  -> acgc_metal_packet_consumer_handoff_v2
  -> ordinary V2 prepare OR texture-source provider/CPU TEV prepare
  -> pc_metal_runtime_observe
  -> acgc_metal_sink_submit (only if observer permits it)
```

- Ordinary V2 preparation validates the extension but marks it
  `V2_EXTENSION_NOT_RENDERED`. Because the runtime observer checks V3/V4 status
  for this branch rather than the V2 status, the current source can still call
  the geometry-only sink. This is a potential status-policy defect found by
  static source crosswalk, not a live call or a semantically complete frame.
- Texture-using V2 requires the provider-backed source/TLUT sideband. CPU decode
  and TEV evaluation can return `V2_EXTENSION_CPU_RESOLVED`, but the runtime
  deliberately blocks that output from the Metal sink because native V2
  texture/TEV mapping is not implemented.

The next CPU gate after a successful base-state classifier is packet validation
inside `pc_gx_build_semantic_packet_v2_internal()`. The Apple consumer repeats
that validator and adds its channel-source contract. Runtime startup registers
the PC texture-source provider and all typed callbacks, but no inspected
production call binds the caller-owned fixture-array sideband.

## Gate status

| Gate | Current status | Missing proof |
| --- | --- | --- |
| Direct/grouped GX-to-V2 builder | Implemented and focused-fixture covered | Fresh successful live packet |
| V2 packet validator | Implemented, exact next CPU gate | Live validated packet |
| Typed callback registration | Implemented in `pc_metal_runtime_init()` | Live callback count |
| Ordinary V2 prepare | Implemented; extension remains `NOT_RENDERED` | Correct native mapping of required V2 state |
| PC texture/TLUT source record | Implemented with generation checks | Live provider call from a successful packet |
| CPU texture/TLUT/TEV seam | Synthetic/provider fixtures can reach `CPU_RESOLVED` | Native texture sampling/TEV encoding |
| Runtime observer | Ordinary V2 is source-reachable to sink; CPU-resolved V2 is blocked | Explicit version/required-section fail-closed policy and runtime counts |
| Metal sink init/submit | Source implementation exists behind device/resource gates | Live init, encode, completion, readback, pixel, present strategy |

The decomp counterparts stop at GX state/FIFO/register production in
`GXGeometry.c`, `GXTransform.c`, `GXLight.c`, `GXAttr.c`, `GXTev.c`,
`GXPixel.c`, `GXTexture.c`, and `libforest/emu64/emu64.c`. There is no decomp
counterpart for semantic packets, typed callbacks, the Apple consumer/runtime,
texture provider, sink, or MSL.

## Provenance and boundary

- Remote task: `01a00212-f8b5-7c71-9557-1c5208f87e17`
- Read-only PC: `c973dbee8b4461e23aa5e63eeb3178fb256cf6e8`
- Decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Worktree was detached and clean; no source change or commit.

No build, test, link, launch, LLDB, ISO/asset access, callback, Metal
encode/present/readback, pixel, device, or playability proof was performed.

Before a visible-frame claim, the runtime must fail closed on every required
unrendered section, then a canonical packet/consumer must map the actual live
state into the sink. A focused bridge fixture may still be useful for proving
provider calls and unchanged sink-submit count, but it is not a substitute for
the canonical renderer contract or device/runtime evidence.
