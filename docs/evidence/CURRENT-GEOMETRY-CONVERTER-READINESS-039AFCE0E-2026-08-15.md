# Current Geometry converter readiness at `039afce0e` (2026-08-15)

## Result

The completed `PCGXRawGeometry` batch at `pc_gx_flush_vertices()` is a useful,
pointer-free provenance snapshot for a bounded subset, but it is **not yet a
complete or safe producer** for `AcgcGxCanonicalGeometryState`.

The next Geometry source work must first close raw ownership, mutation-order,
coverage, and source-lifetime rules. A separate converter can then serialize a
completed batch into the frozen canonical byte layout. That raw-closure work is
not opened while lane 208 owns overlapping `pc_gx.c` regions.

This is a dependency-readiness result, not a runtime or rendering result.

## Provenance and lane contract

- Umbrella registration snapshot: `574aedb8cff013a8b1096a970019beedb17516a2`
- `ACGC-PC-Port`: `039afce0e0773a2ad4cbb6b5d8d717c463ad8303`
- `ac-decomp`: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Remote task: `01a004f2-96c0-79c2-8c20-c9b028bb5018` (lane 210)
- Detached read-only source: `/private/tmp/acgc-lane-geometry-converter-audit-m3`
- Source-only bundle: `/private/tmp/acgc-canonical-pc-039afce.bundle`
- Bundle SHA-256:
  `5d280a7f1ffc6919d31a7dc88ef0720ba1280f74d57b199e5c7729003fbe4afe`

The worker verified the bundle, exact detached PC revision, clean status, no
diff, and the clean decomp oracle. It created no branch, source or documentation
edit, build directory, test result, full link, or launch. It did not inspect or
copy ISO, ROM, `assets/`, `orig/`, keys, or proprietary data.

## Two-upstream crosswalk

The PC implementation was reviewed at these ownership boundaries:

- `pc/include/pc_gx_internal.h`: `PCGXRawGeometryFormat`,
  `PCGXRawGeometryArray`, `PCGXRawGeometryAttribute`,
  `PCGXRawGeometryBatch`, and `PCGXRawGeometry`.
- `pc/src/pc_gx.c`: `pc_gx_raw_geometry_set_vcd()`,
  `pc_gx_raw_geometry_set_vat()`, `pc_gx_raw_geometry_set_array()`,
  `pc_gx_raw_geometry_read_array_words()`, direct/indexed emitters,
  `pc_gx_raw_geometry_capture_completed()`, and `pc_gx_flush_vertices()`.
- `include/acgc/gx_canonical_geometry_state.h` and
  `src/gx_canonical_geometry_state.c`: the section-1, version-1 canonical
  Geometry layout, validators, and dependency results.
- `pc/tests/pc_gx_geometry_raw_batch_fixture.c` and
  `pc/portable/tests/test_gx_canonical_geometry_state.c`: current raw-batch and
  portable-layout fixture coverage.

The original-behavior oracle was reviewed at:

- `src/static/dolphin/gx/GXAttr.c`: VCD/VAT/list/array setters, validation, NRM
  versus NBT rules, and the `CHECK_GXBEGIN` mutation boundary.
- `src/static/dolphin/gx/GXGeometry.c`: `GXBegin()` primitive, vertex-format,
  and vertex-count behavior.
- `src/static/dolphin/gx/GXVert.c`: direct component counts, distinct INDEX8
  and INDEX16 entry points, and one- versus two-component texture emission.
- `src/static/dolphin/gx/GXTransform.c`: position/normal/current-matrix and
  texture-matrix selector provenance.
- Public GX enums/structs and representative emu64/game callers that combine
  VCD, VAT, arrays, selectors, and draw submission.

## What can be mapped now

| Canonical output | Current raw source | Remaining producer rule |
| --- | --- | --- |
| `primitive` | `completed.primitive` | Map only supported triangles/quads and reject every other GX primitive. |
| `vertex_count` | `completed.vertex_count` | Require exact completion, the requested-count relationship, and the canonical maximum of 128. |
| `vtxfmt` | `completed.vtxfmt` | Require a known format in the canonical `0..7` domain. |
| descriptor `vcd_type` | `attr[].vcd_type` | Preserve NONE/DIRECT/INDEX8/INDEX16 semantics; reduce matrix VCD to its effective bit only where the canonical contract requires it. |
| descriptor VAT fields | `vat_count`, `vat_type`, `vat_fraction` | Validate each attribute-specific component/count/type/fraction domain before serialization. |
| `present_mask` / `indexed_mask` | completed descriptors | Derive only from accepted, completely known descriptors; never infer absent or unsupported attributes. |
| value stream | copied `value_words`, `value_count`, and known flags | Convert scalar fixed-point, normals, packed colors, and finite F32 into the canonical little-endian representation with checked offsets, sizes, alignment, and zero padding. Raw host words are not themselves the canonical byte stream. |
| index stream | `index_values`, `index_count`, `index_stride`, and `source_indices` | Preserve exact INDEX8/INDEX16 width, stable first-occurrence value ordering, and checked source-to-value references. |
| matrix requirements | matrix-selector attributes plus raw Transform/Texgen state | Validate exact logical matrix IDs and require matching Transform/Texgen known masks before publication. |
| cross-section requirements | `AcgcGxCanonicalGeometryDependencyResults` | Supply explicit Transform, Texgen, Channels, Lighting, and bump results; do not embed host pointers or section structs in Geometry. |

The completed batch copies decoded values and index provenance, so later caller
memory mutation cannot change those copied words. That is sufficient for the
currently covered raw-batch fixture subset. It does not establish all of the
source ownership, byte-conversion, or dependency rules required by the
canonical section.

## Blocking gaps

1. **Setter mutation during an incomplete draw is not closed.** The decomp
   `GXAttr.c` setters reject VCD, VAT, clear-descriptor, and array mutations
   during `GXBegin`. The PC path can flush a partial batch and then mutate the
   same state. A canonical producer needs one explicit fail-closed policy that
   preserves the original draw contract; silently accepting a partial batch is
   not sufficient.
2. **Array generations are not durable resource leases.** The raw state records
   generation, size, and stride and copies values it actually reads, but the
   caller-owned array bytes can change without a new `GXSetArray` generation.
   Existing unchecked host indexed dereferences are not proof of a coherent,
   immutable source interval. The producer must either complete all required
   copying under an explicit synchronous ownership contract or introduce a
   bounded validated lease/epoch.
3. **Attribute coverage is incomplete.** The current first producer does not
   completely own CLR1, TEX1–7, position/normal/texture matrix array slots,
   texture-matrix selector attributes, or NBT/NBT3. `GXSetVtxAttrFmtv` has no
   equivalent raw setter path. Unsupported combinations must be deliberately
   rejected until their source semantics are implemented.
4. **Raw words are not the canonical wire format.** Fixed-point scaling,
   normal interpretation, packed-color expansion, finite-F32 checks,
   little-endian byte emission, descriptor offsets/strides, alignment, bounds,
   and reserved-zero padding still need one checked serializer.
5. **Cross-section dependencies are not assembled.** Position/normal/current
   matrix requirements and texture-matrix selectors must be proven against the
   canonical Transform and Texgen results. Channels, Lighting, and bump masks
   must be checked where Geometry declares them required.
6. **Completed-batch lifetime is only one flush interval.** The current
   `completed` copy is overwritten by the next capture. A consumer must finish
   synchronously or receive its own immutable owned copy; it may not retain a
   pointer into `g_gx.raw_geometry.completed`.

## Dependency-ordered successors

### 1. Raw Geometry closure

Open only after lane 208 releases `pc_gx.c` ownership. Own:

- `pc/include/pc_gx_internal.h` Geometry declarations;
- `pc/src/pc_gx.c` `pc_gx_raw_geometry_*` functions, VCD/VAT/array setters,
  vertex emitters, and raw capture ordering; and
- `pc/tests/pc_gx_geometry_raw_batch_fixture.c` plus minimal existing CMake
  registration if required.

This lane must settle the mid-`GXBegin` mutation policy, supported attribute
slot policy, finite/value validation, and array lifetime semantics. It must not
edit canonical Geometry files, the cumulative envelope, Apple/Metal files, or
decomp.

### 2. Canonical Geometry producer

After raw closure, use new non-overlapping producer files such as:

- `pc/include/pc_gx_geometry_producer.h`;
- `pc/src/pc_gx_geometry_producer.c`; and
- a dedicated focused producer fixture with minimal CMake registration.

It should consume only an immutable completed batch plus explicit dependency
results, build into caller-owned scratch/output, validate the full section, and
leave output unchanged on any failure. It must not mutate GX setters or add a
new packet version.

Envelope publication and Apple consumption remain separate later owners after
the leaf producer is independently reviewed.

## Required focused matrix

The raw-closure and later producer fixtures need, at minimum:

- direct and indexed POS, NRM, CLR0, and TEX0;
- fixed-point conversion, normal formats, packed colors, finite F32, and exact
  little-endian 8/16/32-bit output;
- stable first-occurrence indexed-value ordering and repeated indices;
- INDEX8/INDEX16 width checks, bounds, generation mismatch, source mutation,
  and mid-`GXBegin` VCD/VAT/array changes;
- explicit rejection of unsupported CLR1, TEX1–7, array/matrix slots,
  texture-matrix selectors, and NBT/NBT3 until implemented;
- positive and negative Transform/Texgen dependency results;
- exact section metadata, offsets, alignment, reserved zeros, maximum size,
  unchanged output on failure, and cumulative-envelope metadata compatibility.

## Verification and claim boundary

Lane 210 was intentionally read-only. It ran no build or test, so it creates no
new compile, sanitizer, Windows, full-link, or runtime evidence. The audit
proves only source crosswalk and dependency readiness at the exact revisions
above. It does not prove a canonical Geometry producer, cumulative callback,
OpenGL or Metal encode/present/readback, pixel, input, audio, save/reload,
device, iOS, or playability gate.
