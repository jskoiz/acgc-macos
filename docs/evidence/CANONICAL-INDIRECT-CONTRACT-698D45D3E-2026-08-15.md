# Canonical Indirect contract at `698d45d3e`

## Scope and provenance

Lane 207 performed a read-only two-upstream audit of the guest Indirect state,
the PC host implementation, setter ordering, TEV ownership, texture
dependencies, and the smallest portable successor.

- project task: `01a004f3-5a55-7702-95ec-8acf22b8b806`;
- PC snapshot: `698d45d3e78f96104c2e489d78036b55ea493d37`;
- detached source: `/private/tmp/acgc-lane-indirect-contract-m3`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- source, tests, docs, branches, and refs changed: none; and
- build, launch, callback, Metal/device, asset, ISO, and proprietary-data
  access: none.

## Guest and PC crosswalk

The decomp oracle in `GXBump.c`, `GXInit.c`, `GXTexture.c`, public GX enums,
and Famicom callers establishes:

- an active Indirect-stage count of `0..4`;
- four order records with texture coordinate/map domains `0..7` and S/T scale
  domains `0..8`;
- three 2x3 matrix slots, each quantized to signed 11-bit fixed-point
  coefficients and a six-bit encoded exponent;
- matrix selector families `1..3`, `5..7`, and `9..11`, with `0` meaning off;
- default direct TEV state and zero active Indirect stages; and
- nine per-TEV fields: stage, format, bias, matrix selector, S/T wrap,
  add-previous, LOD, and alpha selection.

The PC already separates shared Indirect count/order/matrix state in
`PCGXState` from those nine fields in `PCGXTevStage`. Its setters update
GL-oriented host state and the Indirect dirty group, but they do not enforce
the neighboring flush-before-mutation boundary, validate guest enum domains,
or preserve the guest's quantized matrix/register representation. The current
shader also implements a narrower subset than the guest contract.

Canonical TEV already owns and validates the nine per-stage fields. Duplicating
them in a new Indirect section would create two sources of truth, so the new
section must contain only shared state.

## Frozen proposed section

Use the already-reserved common-envelope slot:

- section ID `13`;
- section mask `0x1000`;
- version `1`;
- one 248-byte / 62-word value record; and
- directory count/capacity `1/1`, valid mask `0x1000`, and zero reserved word.

The 14-word header records exact version/ID/mask/size, active count, four-order
capacity/record size/offset/valid mask, three-matrix capacity/record
size/offset/valid mask, and one zero reserved word.

Each of four six-word order records contains:

```text
tex_coord, tex_map, scale_s, scale_t, reserved, reserved
```

Each of three eight-word matrix records contains:

```text
s0, t0, s1, t1, s2, t2, scale_encoded, reserved
```

Strict validation requires exact metadata and offsets, every reserved word
zero, order domains above, signed coefficient range `-1024..1023`, encoded
scale `0..63`, and entirely zero invalid matrix slots. A referenced TEV matrix
selector requires its matrix-valid bit; effective TEV Indirect use requires
`ind_stage < active_count`; active order records must resolve through the
Texgen and Texture sections; and the combined dependency validator must reject
the guest-debug-invalid collision where one texture map is simultaneously an
active direct and Indirect map.

No pointer, host float, GL/Metal handle, texture/TLUT byte payload, sampler
state, or duplicate TEV field belongs in this section.

## Smallest source successor

The dependency-ready portable lane owns only:

- new `include/acgc/gx_canonical_indirect_state.h`;
- new `src/gx_canonical_indirect_state.c`;
- one `pc/portable/tests/test_gx_canonical_indirect_state.c`; and
- minimal `pc/portable/CMakeLists.txt` registration.

It should add the fixed ABI, strict value/metadata validation, and a
cross-validator that takes canonical TEV by reference. It must not edit
`pc_gx`, raw setters, packet/cumulative producers, Apple/Metal, shaders,
Texture/TLUT serialization, ac-decomp, or runtime paths.

A later, separately owned PC raw lane must capture count, orders, coordinate
scales, guest-quantized matrices, knownness, and flush-before-mutation. Only
after both pieces are reviewed may a converter and cumulative producer consume
them.

## Evidence boundary

Integration-owner review found no contradiction between this proposed split,
the reserved common-envelope slot, canonical TEV ownership, and the pinned
decomp behavior. The contract is accepted as the design input for a focused
portable successor; it is not implemented by this audit.

This evidence proves no build, callback, full link, launch, LLDB result, Apple
consumer, Metal encode/present/readback, pixel, device, Windows runtime, iOS,
or playability gate.
