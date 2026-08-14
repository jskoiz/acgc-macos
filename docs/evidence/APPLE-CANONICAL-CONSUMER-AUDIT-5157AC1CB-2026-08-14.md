# Apple canonical-state consumer and encoder audit at `5157ac1cb`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a00275-9cf6-7113-8511-5e9a4d18deff`
- PC snapshot: `5157ac1cbcdc3a0074a407c08874a0861ba20c72`
- ac-decomp snapshot: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Detached audit worktree: `/private/tmp/acgc-lane-apple-canonical-consumer-audit`

The worker made no edits and ran no build, launch, callback, device, encode,
present, readback, pixel, or frame test. No ISO, assets, keys, or proprietary
data were accessed. This document records source architecture evidence only.

## Decision

The smallest safe end-state is one exact cumulative canonical draw contract:

```text
PCGXState snapshot
  -> fixed-width value validation
  -> validated and copied resource sideband
  -> immutable Metal-independent encode plan
  -> device-gated Metal encoder
```

This must be a new canonical ABI, not an append-only V5 or a dual-shape parser.
Legacy V1-V4 remain bounded diagnostic fixtures.

Current sink policy is not sufficient for that device gate. V1 is the only
bounded sink-eligible path with matching semantics. V2 `NOT_RENDERED` and
`CPU_RESOLVED` are CPU-only; V3 is explicitly not rendered. V4 is currently
eligible in `pc_metal_runtime_sink_eligible`, but its texture matrices, TEV,
alpha test, depth, cull, and other live GX state are not fully encoded. V4
therefore cannot stand in for a canonical rendered draw.

## State-to-Metal boundary

| Canonical state | Source evidence | End-state Apple operation |
|---|---|---|
| Draw/vertex layout | `PCGXState`, `pc_gx_flush_vertices`, `GXBegin`, GX vertex descriptors | Owned vertex/index buffers and explicit `MTLVertexDescriptor` |
| Transforms | PC projection/position/normal matrices; decomp `GXTransform.c` | Immutable vertex constants and normal matrices |
| Pass/target | `GXSetCopyClear`, clear color/depth | Explicit attachments, load/store actions, formats, samples, clear values |
| Viewport/scissor | PC viewport/scissor; decomp setters | `setViewport:` and `setScissorRect:` |
| Channels/lighting | channel controls/lights; decomp `GXSetChanCtrl` callers | Native vertex/fragment constants and MSL lighting |
| Texgen/matrices | texgen and texture matrices | Vertex-generated texture coordinates and matrix constants |
| Texture/TLUT/sampler | existing V2 provider and generation checks | Validate, copy into backend-owned staging, create/bind Metal resources |
| TEV | PC TEV stages/registers/swaps; decomp TEV setters | Native MSL stage chain, konst/register/swap semantics |
| Fog | decomp `GXSetFog` and active emu64 callers | Explicit canonical fog payload and native MSL fog equation |
| Alpha/blend | alpha compare/update and blend/logic state | Fragment discard, write mask, pipeline blend/logic configuration |
| Depth/raster | `GXSetZMode`, cull, line/point state | Depth/stencil object, cull/winding/fill and primitive state |
| Lifecycle | `pc_metal_runtime_init/shutdown`, `pc_gx_init/shutdown` | Clear callbacks before releasing Apple resources; invalidate all caches |

The existing `AcgcMetalStateFixture` and `metal_sink` are reusable testing
components, not a cumulative GX contract. The current sink hardcodes bounded
target and shader behavior and must not be treated as game-owned frame proof.

## Deterministic state machine

```text
RESET
  -> SNAPSHOT_CAPTURED
  -> PACKET_VALIDATED
  -> RESOURCES_VALIDATED_AND_COPIED
  -> CPU_PLAN_READY
  -> DEVICE_READY
  -> PASS_BOUND
  -> DRAW_ENCODED
  -> COMPLETED
  -> READBACK_VERIFIED
```

Any validation, resource generation, device, encode, or completion failure is
terminal for that handoff. Borrowed guest pointers cannot cross the
`RESOURCES_VALIDATED_AND_COPIED` boundary. Existing PC dirty bits may be
producer hints, but cache keys must cover the complete canonical state.

## First safe implementation ownership

1. Neutral contract: `include/acgc/gx_canonical_state.h` and
   `src/gx_canonical_state.c`, starting with independently testable sections.
2. PC snapshot producer: new `pc/src/pc_gx_canonical_snapshot.c` and a focused
   CPU fixture; no Apple callback registration yet.
3. Apple CPU consumer: new `metal_canonical_consumer.h/.c` and a focused test
   producing an immutable, Metal-independent plan.
4. Runtime policy: later submit only `CANONICAL_PLAN_READY`; reject every
   incomplete or CPU-only status.
5. Device encoder: later Objective-C implementation owns all Metal objects,
   offscreen submission, completion, and exact readback.

The first source patch must not modify `metal_sink.m`, extend V4, add V5, or
introduce permissive prefix parsing.

## Device/pixel proof contract

A later device-gated fixture must use a fixed canonical state plus immutable
resource sideband, deterministic geometry and shader state, a real offscreen
Metal pass, command completion, full-target readback, and comparison with a CPU
reference including exact pixels and a full-buffer checksum. A nonzero pixel or
command-buffer completion alone is insufficient. Repeated identical submissions
must produce identical output.

## Ranked blockers

1. No complete cumulative canonical payload or PC snapshot producer.
2. V4 sink eligibility admits semantics it does not encode.
3. Native MSL lacks complete texture, texgen, lighting, TEV, indirect, fog,
   alpha-compare, scissor, destination-alpha, and logic-blend behavior.
4. Existing texture sideband is borrowed and CPU-only; device work needs owned
   staging plus generation validation.
5. Current Apple fixtures substitute hardcoded defaults for live GX state.
6. PC state still has gaps such as complete destination-alpha and range-fog
   representation.
7. GX primitive/state breadth exceeds current Apple bounds; it must fail closed
   rather than truncate.
8. Canonical numeric precision, interpolation, conversion, clamp, and rounding
   semantics must be defined before an exact pixel oracle is authoritative.

No Metal, pixel, rendered-frame, or playability claim follows from this audit.
