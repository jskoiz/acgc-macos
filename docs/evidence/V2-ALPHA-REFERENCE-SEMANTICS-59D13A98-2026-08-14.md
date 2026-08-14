# V2 alpha-reference semantics at `59d13a98`

## Scope and provenance

Remote M3 Max lane 146 (`01a00250-5adf-7ae3-b348-437a437a0dfe`) performed a
read-only crosswalk of ACGC-PC-Port
`59d13a98e06c4a67c67b5936f5257a6ff82c0d7a` and ac-decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The lane did not switch the
remote canonical checkout, edit source, build, launch, inspect assets, or
access the ISO. Its final handoff SHA-256 is
`905b3e67ef4078dff5de8730524edfed41a4233608333197124f9a28c9550062`.

## Finding

The live tuple `GX_ALWAYS/GX_ALWAYS`, `GX_AOP_AND`, references `8/144` is
rejected as `alpha_test` only because the current V2 predicate also requires
both reference bytes to be zero. Those references are semantically dead for
that exact comparator form:

- both histories define `GX_ALWAYS` as `7` and `GX_AOP_AND` as `0`;
- decomp `GXSetAlphaCompare` packs the reference bytes but assigns them no
  meaning when both comparisons always pass;
- `emu64::alpha_compare` deliberately leaves `blend_alpha` and
  `tex_edge_alpha` in the reference positions while selecting both
  `GX_ALWAYS` comparisons when threshold and GEQUAL modes are inactive;
- the PC fragment shader skips its alpha test entirely when both comparisons
  are `7`; and
- the V2 packet has no alpha-reference fields.

The safe correction is local to the V2 predicate and classifier: accept the
alpha-test tier when both comparisons are `GX_ALWAYS` and the operator is
`GX_AOP_AND`, ignoring only the two reference bytes. It must not mutate the
stored GX state or change `GXSetAlphaCompare`, V1, the legacy GL shader, or
active comparison forms.

This normalization does not make the observed draw V2-compatible. The same
tuple next fails at blend state `1/4/5/5`, followed by separate depth,
alpha-update, and cull constraints.

## Crosswalk

- PC `pc/src/pc_gx.c`: V2 classifier, predicate, builder, and grouped callers.
- PC `pc/include/pc_gx_internal.h`: stored alpha-compare fields.
- PC `pc/shaders/default.frag`: both-`GX_ALWAYS` alpha-test bypass.
- PC `src/static/libforest/emu64/emu64.c`: live reference-byte source.
- Decomp `src/static/dolphin/gx/GXTev.c`: packed alpha-compare register.
- Decomp `src/static/libforest/emu64/emu64.c`: original emu64 behavior.

## Next bounded gate

Lane 149 owns only `pc/src/pc_gx.c` and
`pc/tests/pc_gx_v2_rejection_reason_fixture.c`. It must prove the exact
always/always case, preserve active-comparison and unsupported-operator
rejection, and show the classifier advancing to `blend` for the live tuple.
Native and combined ASan/UBSan focused tests are required before integration.

This audit proves source semantics only. It does not prove a packet, callback,
Metal encode/present/readback, pixel, device, or playability gate.
