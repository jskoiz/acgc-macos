# Canonical GX setter-order audit at `251a010b8`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a00297-d958-73f2-a850-d79a18e5f763`
- Canonical PC snapshot: `251a010b8d6167d7dd90042934d8491d1c96b040`
- Raw Texgen/SU reference: first commit `2e3c95dae9d5c5935a31891919883474f004fc82`, later repaired by `2df84f628ef8ad604859d4a6bab4768ed640e607`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Inspected source-only preflight: `/private/tmp/acgc-lane-cumulative-producer-preflight`

The requested fresh audit path did not exist, so the read-only worker did not
create it. The lane made no source or documentation edit, branch, build, test,
link, launch, LLDB, device, asset, Metal, pixel, or playability operation.

## Ordering invariant

The future cumulative producer belongs inside `pc_gx_flush_vertices()` after
the nonzero vertex-count guard and before all existing V1-V4 handoffs, TEV
variant selection, or OpenGL mutation. Every producer-visible live setter must
therefore order its work as:

```text
pc_gx_flush_if_begin_complete()
raw/API shadow mutation
effective host-state mutation and dirtying
```

For setters that also mutate OpenGL state, the required sequence is:

```text
pc_gx_flush_if_begin_complete()
raw/effective mutation
pc_gx_draw_pending()
OpenGL mutation
```

`pc_gx_draw_pending()` is not a substitute for the first call. It drains
already deferred OpenGL vertices but does not commit an active completed
`GXBegin` whose explicit `GXEnd` was omitted by the emulated command stream.

This preserves the decomp `CHECK_GXBEGIN` semantic boundary while accommodating
the PC port's omitted-`GXEnd` behavior.

## Adjudicated ownership

`GXEnableTexOffsets`, `GXSetLineWidth`, and `GXSetPointSize` are Raster-owned.
They are not Texgen/SU state. The decomp oracle is `GXGeometry.c`; Texgen/SU
owns only logical manual scale, bias, cylinder, generator, and texture/post
matrix provenance.

The repaired Texgen/SU commit `2df84f628` orders exactly these seven live
setters before mutation:

- `GXLoadTexMtxImm`
- `GXLoadTexMtxIndx`
- `GXSetNumTexGens`
- `GXSetTexCoordGen2`
- `GXSetTexCoordScaleManually`
- `GXSetTexCoordCylWrap`
- `GXSetTexCoordBias`

That repair remains a worker result until independent review and canonical
integration. No additional Texgen temporal-order lane is required if it passes.

## Current and future repair groups

| Owner | Current condition | Required behavior |
| --- | --- | --- |
| Transform | Integrated raw projection/matrix setters already flush before mutation | Preserve the current order; indexed loads mark only the targeted range unresolved after flush |
| Depth | `GXSetZMode` calls `pc_gx_raw_depth_store()` before `pc_gx_flush_if_begin_complete()` | Move the flush ahead of the raw store, then retain the typed effective-state update |
| Texgen/SU | First worker commit mutated seven records before/no flush | Repaired by `2df84f628`; independent review and exact integrated tests remain required |
| Raster | Viewport/scissor mutate logical state then call only `pc_gx_draw_pending`; line/point/offset canonical shadows are absent | Flush first, retain raw logical values separately from host conversions, then drain/mutate GL as needed |
| Indirect | `GXSetNumIndStages`, `GXSetIndTexMtx`, `GXSetIndTexOrder`, `GXSetIndTexCoordScale`, and `GXSetTevIndirect` mutate without the canonical flush boundary | A separate Indirect owner must validate, flush once, then update all related state atomically |
| Texture/TLUT resources | Object loads flush first, but endian changes, destruction, and live invalidation can change generation without flushing | A resource/lifetime owner must flush before generation mutation and synchronously own referenced bytes |
| Latent no-op setters | Several Raster/Alpha/Fog/Pixel setters currently store no producer-visible state | Add the flush before mutation when each canonical shadow is implemented; a no-op alone is not a current temporal mutation |

The canonical PC tip's smallest current source defect is therefore
`GXSetZMode` only. Its fixture must construct a completed synthetic batch in
state A, invoke `GXSetZMode` with state B, and observe state A at the flush
boundary before the raw/effective state becomes B. This repairs one ordering
defect; it does not make the cumulative producer ready.

## Remaining producer blockers

After the Depth repair and repaired Texgen integration, separate owners still
must provide:

- exact Geometry VCD/VAT, primitive/VTXFMT, run metadata, and checked source
  bounds;
- raw Channels and Lighting provenance;
- logical Raster values distinct from host-scaled/flipped values;
- an audited Indirect ABI and raw state;
- Texture/TLUT descriptor plus owned resource-generation semantics; and
- all-or-nothing cross-section validation and immutable publication.

Texture/TLUT identities must be copied while their generation is current and
revalidated after copying. The canonical packet may contain snapshot-local
resource indices, never borrowed native pointers, GL IDs, packed handles, or
stale generation state.

## Evidence boundary

This audit proves a CPU ordering contract and identifies exact source owners.
It does not implement a producer, callback, Metal encode/present/readback,
pixel, input, audio, save, device, iOS, Windows runtime, or playability gate.
