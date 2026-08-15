# Raw Texture/TLUT producer plan at `23c26e520a`

Date: 2026-08-14

Lane: 196 / task `01a00297-d958-73f2-a850-d79a18e5f763`

Classification: read-only architecture evidence

## Verified source state

- ACGC-PC-Port: detached and clean at
  `23c26e520a943ac843023f0341d2670d9c7ef9fc`.
- ac-decomp: clean `master` at
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Source-only bundle SHA-256:
  `5732e20f137ff5aa336fb07a65965afde93c269eb7f7390406bf0a7397347fec`.
- Bundle tip: `refs/heads/c1/macos-host-launch` at `23c26e520a`; required
  prerequisite `324c174ae31e06725b51d662f2645cfd8f96c835`; verification passed.
- The protected worktree remained clean. Ignored `assets/` and `orig/` were
  preserved and their contents were not read, hashed, copied, or transferred.

No source branch, edit, build, test, full link, launch, LLDB session, resource
byte access, or umbrella mutation occurred in this lane.

## Finding

`PCGXTextureSource` cannot by itself truthfully supply the neutral Texture and
Dynamic sections. It contains borrowed pointers and host-facing source data,
but no owner epoch, TLUT generation, complete LOD/mipmap metadata, or stable
resource lifetime. It also classifies converted image buffers as raw guest
data. Extending that borrowed diagnostic shape would leave resource identity
and lifetime ambiguous.

The narrow end-state boundary is a private, pointer-free raw Texture/TLUT
shadow in the existing texture subsystem plus a separate synchronous resource
lease. The neutral packet continues to contain metadata only; resource bytes
never enter the canonical ABI.

## Frozen raw state and resource identity

The private state contains a nonzero owner epoch; eight-bit map known, invalid,
present, and available masks; sixteen-bit TLUT masks; eight map records; eight
image resource records; and sixteen TLUT resource records. It contains no
pointers, GL names, cache hashes, native enums, `size_t`, or host booleans.

Stable logical IDs are fixed:

- map image `n`: `1 + n`;
- TLUT slot `s`: `0x100 + s`;
- Dynamic image record: `n`;
- Dynamic TLUT record: `8 + s`.

TLUT slots remain arbitrary and are never compacted. The integrated neutral
Texture section remains version 1, size 1216, with eight records. Dynamic
remains version 1, size 1600, with eight image records followed by sixteen
TLUT records. No neutral ABI revision is required.

Initialization creates a new nonzero owner epoch and clears the raw shadow.
Every accepted texture load advances the map's image generation, even when a
pointer or cache key is reused. A TLUT load or native-endian conversion advances
only that TLUT slot and dependent indexed maps. Generation or epoch wrap fails
closed. Cache invalidation alone does not change logical metadata unless it
actually drops a resource lease. Destroy, replacement, eviction, or clear
invalidates affected leases; ambiguous converted image provenance fails closed.

Tiled byte sizes are derived from format, dimensions, and mip levels without
reading resource bytes. Each mip is summed with checked 64-bit arithmetic and
must fit `uint32_t`; nonrepresentable format, dimension, wrap, filter, or LOD
combinations are rejected rather than normalized into invented state.

## Lease and flush boundary

Immediately after immutable raw Geometry capture in `pc_gx_flush_vertices`, a
future cumulative builder copies every required value section, validates
Texture/Dynamic cross-resource generations, and creates one transient lease.
Only a completely valid snapshot invokes the synchronous callback.

Borrowed pointers are valid only until callback return and may not be retained
or used during re-entrant texture mutation. An owned-copy path must have one
explicit release. Owner epoch, generation, pointer, size, format, and byte order
must match preflight at callback entry. Any mismatch rejects the complete
callback; there is no partial or fallback packet.

Texture/TLUT load, native-endian conversion, destroy, eviction, and clear must
cross one flush-before-mutation gate. A completed old batch observes the old
resource state. An incomplete active batch must be completed legally or mark
the canonical producer invalid; it must not observe new resources silently.

## Two-upstream crosswalk

- PC `pc/include/pc_gx_internal.h`: `PCGXTextureSource`, texture-map state, and
  TLUT cache state.
- PC `pc/src/pc_gx_texture.c`: `texture_source_store`, map/all clear paths,
  `pc_gx_load_tex_obj_impl`, `GXLoadTlut`, and
  `pc_gx_tlut_set_native_le`.
- PC `pc/src/pc_gx.c`: `pc_gx_get_v2_texture_source` and
  `pc_gx_flush_vertices`.
- Neutral contracts: `include/acgc/gx_canonical_texture_state.h`,
  `include/acgc/gx_canonical_dynamic_state.h`, their validators, and focused
  tests.
- ac-decomp `src/static/dolphin/gx/GXTexture.c`: tiled size, texture-object
  load, TLUT load, and cache-invalidation semantics; `GXInit.c` supplies startup
  invalidation; public GX enums and structs supply guest domains/layouts.
- Representative decomp callers include `libforest/emu64`, JUT resource-font
  and display code, and Famicom paths. PC replacement textures, hashes, GL IDs,
  converted buffers, and cache lifetimes have no decomp logical-resource
  counterpart and therefore stay outside the neutral ABI.

## Successor ownership and focused proof

The bounded source successor owns:

- new `pc/include/pc_gx_texture_raw_state.h`;
- raw map/TLUT state, generation, and mutation gates in
  `pc/src/pc_gx_texture.c`;
- new `pc/src/pc_gx_canonical_snapshot.c` for Texture/Dynamic conversion and
  the synchronous lease;
- one narrow producer call in `pc/src/pc_gx.c`;
- new `pc/tests/pc_gx_texture_dynamic_producer_fixture.c`;
- minimal `pc/CMakeLists.txt` registration;
- only if required, an explicit converted-image provenance marker at the
  relevant `src/static/libforest/emu64/emu64.c` call sites.

The focused fixture must cover stable arbitrary-slot IDs, map/TLUT generations,
reload and stale-lease rejection, raw-versus-converted provenance, dependent
TLUT changes, all tiled format families and mip boundaries, invalid metadata,
cache invalidation, destroy/clear, complete and incomplete batch ordering, and
all-or-nothing callback rejection.

This successor remains serial with raw Channels while both touch
`pc/src/pc_gx.c`; it starts only after lane 195 releases that file. A cumulative
multi-section producer follows only after raw Channels, Lighting, and
Texture/TLUT provenance are integrated.

## Evidence boundary

This document proves only a source crosswalk and frozen ownership/lifetime
contract at the stated commits. It does not prove implementation, compilation,
sanitizer behavior, a complete packet, callback reachability, Metal encoding or
presentation, pixel readback, device behavior, iOS behavior, or playability.
