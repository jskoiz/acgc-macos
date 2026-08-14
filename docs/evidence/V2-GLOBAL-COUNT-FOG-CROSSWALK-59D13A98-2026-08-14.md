# V2 `global_count` and fog crosswalk at `59d13a98`

## Scope and provenance

Remote M3 Max lane 147 (`01a00250-5d82-7a91-9202-636b8478f7f0`) performed a
read-only crosswalk of ACGC-PC-Port
`59d13a98e06c4a67c67b5936f5257a6ff82c0d7a`, ac-decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`, and the renderer-contract audit
integrated at umbrella `c084093`. No source, build, launch, assets, or ISO were
mutated or accessed. The final handoff SHA-256 is
`6b7c50f7126576ae8c87c4fae956f030948fef17f36a31cd9d5b4f0627f02466`.

## Finding

The live record `chans=1, texgens=2, tev=2, ind=0, fog=2` is valid
game-produced GX state, not stale builder bookkeeping:

- every count and equality check accepts `1/2/2/0`;
- `fog` is not a count: value `2` is `GX_FOG_PERSP_LIN`;
- the grouped V2 path is intentionally building the first three-vertex slice
  of a valid six-vertex triangle list; and
- only `fog_type != GX_FOG_NONE` produces the `global_count` label.

The decompiled game deliberately initializes and later re-establishes two
texture generators and two TEV stages. Its dirty-state path calls
`GXSetFog(GX_FOG_PERSP_LIN, ...)` with start/end, near/far, and color when fog
is active. The PC host stores those values.

V2 has capacity for two channels, two texgens, and two TEV stages, but no
semantic fog mode or parameters. Its `FOG_KNOWN` bit is not fog data. V1 cannot
represent the texture/TEV state, while V3/V4 carry different partial state and
are not cumulative. The cohort therefore requires a canonical cumulative
value-only draw/state contract with an explicit fog section and the existing
borrowed texture-resource sideband; relaxing the V2 predicate would discard
required semantics.

## Crosswalk

- PC `pc/src/pc_gx.c`: rejection classifier, grouped builder, and `GXSetFog`.
- PC `include/acgc/gx_semantic_packet.h`: V1-V4 capacities and omissions.
- Decomp `src/static/libforest/emu64/emu64.c`: initialization, two-cycle TEV,
  and fog dirty-state calls.
- Decomp GX enums: `GX_FOG_PERSP_LIN = 2`.

## Next bounded gate

Lane 151 is a read-only contract-design successor. It must specify fixed-width
fog fields, validation and mask semantics, ABI/alignment, builder/consumer
ownership, and focused CPU fixtures without creating another blind packet
revision or overlapping the active source lanes.

This audit proves classification and architecture only. It does not prove a
packet, callback, Metal operation, pixel, device, or playability gate.
