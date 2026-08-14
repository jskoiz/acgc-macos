# Renderer semantic contract consolidation — PC c973dbee

## Decision

The read-only M3 Max audit found that the current V1/V2/V3/V4 ladder is not a
cumulative renderer contract:

- V1 carries geometry, transforms, vertex color, one texcoord, and a material.
- V2 embeds V1 and adds channels, texgens, texture/TLUT keys, and a bounded
  two-stage TEV description.
- V3 is a separate V1-based packet with blend/logic and two resolved texture
  matrices; it is not a V2 superset.
- V4 copies V3 and adds `alpha_update_enable`; it still does not carry V2's
  texture/TEV data.

The end-state should therefore be a deliberately named canonical value-only
draw/state ABI plus a separate borrowed texture-resource sideband. It should
not be another blind `V5 = V2 + V3 + V4` extension.

## Required canonical ownership

| State | Current gap | Canonical ownership |
| --- | --- | --- |
| Geometry/topology | V1 is duplicated; only `texcoord0` is carried | One geometry block with explicit topology/count and every referenced attribute |
| Texgens/matrices | V2 requires identity; V3 carries matrices without generator/resource identity | `texgen[]` with function, source, normalize/post-matrix, resource reference, and resolved matrix |
| Texture/TLUT/sampler | V2 aliases texture, TLUT, and sampler keys; bytes are borrowed | Stable independent resource identities in the packet; bytes/generation in a synchronous sideband/provider |
| Channels/lights | V2 validates but Apple does not render; V4 accepts and drops them | Carry channel/light records or explicitly materialize their result into vertices |
| TEV | V2 caps at two stages and omits live null orders, broader constants, outputs, and indirect state | At least the three observed stages, explicit `NONE` references, full register/K-color/swap/op state, and declared fail-closed capacity |
| Blend/logic | Only V3/V4 carry it and the Apple path is bounded | Canonical GX mode/factors/logic with explicit backend-unsupported status |
| Alpha/depth/write/cull | Mostly predicate-only or fixture defaults | Explicit alpha compare, depth compare/write, color/alpha masks, and cull fields |
| Fog/viewport/scissor/indirect | Absent or merely claimed known by a mask | Explicit render-context fields and proven-zero/encoded indirect state |
| Consumer status | Version-specific status fields can omit required unrendered sections | One required-section bitmask; sink submission fails closed if any required section is unrendered |

The decomp crosswalk uses the matching GX producers in `GXAttr.c`,
`GXGeometry.c`, `GXLight.c`, `GXPixel.c`, `GXTev.c`, `GXTexture.c`, and
`libforest/emu64/emu64.c`. In particular, the game path uses variable TEV stage
counts, `TEX1`, raster inputs, null texture orders, subtraction, independent
TLUT/sampler/matrix state, and alpha/depth/cull changes that no single current
packet represents truthfully.

## Provenance and boundary

- Remote task: `01a00212-fc10-78c0-a39a-70de7beb923a`
- Read-only PC: `c973dbee8b4461e23aa5e63eeb3178fb256cf6e8`
- Decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Worktree was detached and clean; no source change or commit.

No build, test, link, launch, LLDB, ISO/asset access, device query, Metal
operation, pixel, or playability validation was performed.

The next source design lane should own only the portable canonical schema,
validator, capacity rules, and rejection matrix. Apple mapping, runtime routing,
assets, and launch proof remain separate successors.
