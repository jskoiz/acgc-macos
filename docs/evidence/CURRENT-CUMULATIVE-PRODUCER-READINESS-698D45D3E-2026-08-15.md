# Current cumulative producer readiness at `698d45d3e`

## Scope and provenance

Lane 206 performed a strictly read-only reconciliation of the renderer-neutral
GX sections, PC raw ownership, resource sidebands, flush boundary, and Apple
consumer state.

- project task: `01a004f2-96c0-79c2-8c20-c9b028bb5018`;
- PC snapshot: `698d45d3e78f96104c2e489d78036b55ea493d37`;
- detached source: `/private/tmp/acgc-lane-current-producer-readiness-m3`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- source, tests, CMake, docs, branches, and Git refs changed: none; and
- builds, launches, callbacks, Metal/device operations, and proprietary-data
  access: none.

The supplied older remote umbrella registration object was unavailable on the
M3 host. The task therefore used the exact detached PC and decomp commits as
its authoritative inputs. That provenance mismatch does not affect the source
crosswalk.

## Readiness matrix

| Area | Portable value contract | PC source-owned state / builder | Remaining dependency |
|---|---|---|---|
| Transform | Present | Raw immediate state present; no complete converter | Resolve indexed/source knownness and serialize |
| Geometry | Present | Immutable completed batch present | Convert VCD/VAT/source data into the canonical Geometry section |
| Texgen/SU | Missing standalone section | Raw shadow present | Define portable ABI, then convert complete known state |
| TEV | Present, including per-stage indirect fields | Only partial raw TEV/KONST provenance | Own full stage/register/KONST/swap state and convert it |
| Depth | Present | Raw owner present | Add converter and cumulative entry |
| Alpha/update | Present | Host fields only at the audit snapshot | Add exact raw owner, including `GXSetZCompLoc`, and converter |
| Blend/logic | Present | Host state only | Add raw knownness and converter |
| Fog | Present | Host floats; range-adjust path incomplete | Add exact raw/range-table ownership and converter |
| Channels | Present | Raw owner and canonical builder present | Assemble into the cumulative envelope |
| Lighting | Present | Raw owner and canonical builder present | Close unresolved indexed loads and assemble |
| Texture/TLUT | Present | Raw owner, generations, and canonical builder present | Pair value state with the validated lease atomically |
| Dynamic resources | Present | Metadata/generation builder and synchronous lease present | Bind to the complete envelope and Apple provider |
| Raster | Missing at the audited snapshot | Cull-only host state | Add portable ABI, raw owner, converter, and consumer |
| Indirect | Shared section missing; TEV fields already present | Host order/matrix/count state only | Add shared ABI, strict raw owner/order, converter, and consumer |
| Apple boundary | No complete-envelope consumer | V1–V4 partial typed callbacks | Accept one complete envelope plus paired lease, then build an immutable plan |

The crosswalk used PC canonical headers/validators, `pc_gx_internal.h`,
`pc_gx.c`, Channels/Lighting raw builders, the Texture/Dynamic snapshot and
lease code, semantic handoffs, and Apple runtime/consumer/provider paths. The
decomp oracle paths were `GXTransform.c`, `GXAttr.c`, `GXGeometry.c`,
`GXTev.c`, `GXPixel.c`, `GXBump.c`, `GXLight.c`, `GXTexture.c`, and
representative emu64/J2D/JFW callers.

## Integration-owner reconciliation

Two facts changed after the audit snapshot without changing its overall
verdict:

- canonical `b3336504c` now supplies the strict portable Raster ABI; raw PC
  Raster provenance and its converter remain absent; and
- lane 204 returned a raw Alpha/ZCompLoc candidate, but root review returned
  it for strict malformed-boolean and production-builder repair before
  integration.

The earlier row saying Raster lacked a portable schema is therefore historical
to `698d45d3e`; every other missing dependency remains current unless a later
evidence record closes it.

## Verdict and dependency order

A full all-or-nothing cumulative producer is **not dependency-ready**.
Individual validators and a few leaf builders do not form a complete producer:
there is no complete source-owned state set, no per-section conversion for all
required sections, no cumulative envelope assembler, no atomically paired
resource lease, and no complete Apple consumer.

The minimum dependency order is:

1. finish the raw Alpha repair; implement portable Texgen/SU and Indirect
   contracts; implement raw Raster ownership;
2. close full TEV, Blend, Fog, Indirect, Transform-indexed, Geometry, Raster,
   and unresolved Lighting source ownership and flush-before-mutation rules;
3. add leaf converters with focused all-or-nothing fixtures;
4. assemble and validate every required section plus the resource lease in
   locals, publishing exactly one synchronous callback only on complete
   success; and
5. add the Apple complete-envelope provider/consumer and immutable CPU plan.

These owners must remain non-overlapping. No new packet version or partial
compatibility shim is justified.

## First honest callback and later gates

The first honest callback remains the synchronous pre-OpenGL boundary inside
`pc_gx_flush_vertices`, after the completed Geometry batch and all required
state/resource snapshots are built and validated. Existing V1–V4 callbacks are
partial typed seams and are not cumulative proof. `GXFlush` is not a substitute
for that boundary.

After the callback is proved, Apple CPU-plan acceptance, Metal device/resource
creation, encode/submit, present, readback, pixel/frame evidence, input,
audible audio, save/reload, lifecycle, Windows runtime, iOS simulator/device,
and human playability remain separate gates.

This document is source-audit evidence only. It makes none of those runtime or
rendering claims.
