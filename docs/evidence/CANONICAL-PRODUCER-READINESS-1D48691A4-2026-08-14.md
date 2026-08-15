# Cumulative canonical producer readiness

Date: 2026-08-14

## Provenance and reconciliation

The read-only M3 Max audit used clean detached ACGC-PC-Port
`1d48691a4fc5f672951d02815723672b2928602e` and clean ac-decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. It made no source, branch,
build, test, launch, asset, or device change.

At audit time, the Depth ordering and neutral Channels commits were explicitly
pending. They have since been independently reviewed and integrated as
canonical PC `9f149b6fd9` and `324c174ae3`. That closes only the two named
audit rows: the Depth temporal hazard and the absence of a portable Channels
ABI. It does not create raw Channels provenance, Geometry batch capture, or a
cumulative producer.

## Exact producer boundary

The eventual producer belongs in `pc_gx_flush_vertices()` after confirming a
nonempty pending vertex chunk and before the existing V1-V4 handoffs, deferred
merge, legacy draw, or GL mutation:

```text
pending-count check
canonical preflight of every required section and resource generation
complete canonical encode and validation
synchronous canonical callback only if all required state is valid
existing V1, V2, V3, and V4 handoffs
existing merge / legacy OpenGL path
```

A failure must emit no partial canonical packet and must not reinterpret a
legacy V1-V4 packet as canonical success. Existing legacy behavior can continue
independently. The producer must copy the pending `PCGXVertex` batch into
immutable callback storage; it cannot retain a pointer into mutable
`PCGXState` storage.

The proposed isolated owner is:

- new `pc/include/pc_gx_canonical_snapshot.h`;
- new `pc/src/pc_gx_canonical_snapshot.c`;
- `pc_gx_canonical_snapshot_preflight`;
- `pc_gx_canonical_snapshot_build`; and
- `pc_gx_canonical_snapshot_try_handoff`.

`pc_gx.c` should contain only the narrow call at the synchronous flush
boundary. Geometry capture, texture ownership/generations, portable section
schemas, and Apple consumption remain separate owners.

## Fourteen-section readiness after reconciliation

| Section | Portable ABI | Producer source at current tip |
|---|---|---|
| Geometry `0x0001` | Implemented/validated | Not ready: expanded host vertices lose exact VCD/VAT, direct/indexed encoding, array ownership, and immutable batch provenance. |
| Transforms `0x0002` | Implemented/validated | Candidate only when every referenced immediate slot is known; indexed slots fail closed. |
| Channels `0x0004` | Implemented/validated at `324c174ae3` | Not ready: setter-owned exact raw Channels provenance is absent. |
| Texgens/SU `0x0008` | Contract only | Raw provenance exists for generator/SU/immediate matrices, but no portable section ABI; indexed matrices remain unresolved. |
| Textures/TLUT `0x0010` | Contract only | Borrowed pointers/metadata lack an owned canonical descriptor and stable asynchronous lifetime. |
| TEV `0x0020` | Implemented/validated | Not ready: raw capture is incomplete for the full sixteen-stage contract and depends on texture, texgen, Channels, and Indirect state. |
| Lighting `0x0040` | Contract only | No exact raw knownness; current PC direction semantics disagree with decomp. |
| Blend/logic `0x0080` | Implemented/validated | Closest fixed candidate, but no cumulative producer exists. |
| Alpha/update `0x0100` | Implemented/validated | `GXSetZCompLoc` remains unavailable; Depth/TEV dependencies remain. |
| Depth `0x0200` | Implemented/validated | Temporal ordering repaired at `9f149b6fd9`; eligible only when raw knownness validates. |
| Raster `0x0400` | Contract only | Viewport/scissor/line/point/texture-offset provenance and ordering are incomplete. |
| Fog `0x0800` | Implemented/validated | Range-adjust table/state remains unavailable. |
| Indirect `0x1000` | Contract only | No complete raw shadow or setter ordering. |
| Dynamic `0x2000` | Contract only | No stable resource/pass identity, ownership, or generation ABI. |

The existing envelope requires ascending contiguous present sections, exact
metadata, four-byte alignment, zeroed absent entries, and exact total/payload
sizes. Per-section and cross-section validation must happen before callback.
Wire words are explicitly little-endian; pointers, `size_t`, native enums,
host `bool`, GL IDs, and native struct layout cannot cross the boundary.

## Resource and lifetime rules

Texture/TLUT identity must use logical map identity, validated metadata, and
provider generation. Borrowed bytes remain valid only during the synchronous
callback. An asynchronous Apple consumer requires an owned copy or explicit
retained provider handle. Any stale generation, unresolved raw slot, malformed
enum, missing required section, dependency failure, or capacity/overflow error
rejects the whole canonical submission.

## Next source gate

The smallest dependency-ready source lane is Geometry raw-batch provenance. It
must freeze exact VCD/VAT/array state at the completed-batch boundary, preserve
direct/indexed encoding and descriptor provenance, copy the batch before
merge/reuse, repair Geometry setter ordering, and validate the immutable source
against the existing canonical Geometry ABI.

A live cumulative producer before Geometry, Lighting, Raster, Indirect,
Dynamic, Texture/TLUT, and full TEV dependencies are ready would only recreate
a transitional packet. A later neutral serializer fixture may use synthetic
complete sections, but a game-owned draw cannot omit Geometry or a dependency
it declares required.

## Evidence boundary

This is source/schema/oracle architecture evidence. It proves no live canonical
packet, callback, full link, launch, Metal encode/present/readback, pixel,
frame, device, input, audio, save/reload, iOS, Windows runtime, or playability.
