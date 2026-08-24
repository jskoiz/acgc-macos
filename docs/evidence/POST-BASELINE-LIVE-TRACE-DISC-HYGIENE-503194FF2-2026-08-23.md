# Post-baseline live trace and disc-image hygiene — PC `503194ff2`

## Outcome

PC [PR #27](https://github.com/jskoiz/ACGC-PC-Port/pull/27),
`Ignore local disc image files`, merged into `c1/macos-host-launch` as
`503194ff2209797d77cbb917c012642051d32b40`.

- PC source base: `da96bf622523728729a7052e605cda19666462e1`
- Reviewed hygiene commit:
  `3eed70d30e4d9ed2ead19bae3cedd232a0f405b5`
- PC merge: `503194ff2209797d77cbb917c012642051d32b40`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The exact first-parent PR diff changes only root `.gitignore`, with twelve
insertions and no deletions. It adds anchored, case-insensitive extension rules
for `.iso`, `.gcm`, and `.ciso` files at repository root and immediately under
`rom/`, `pc/rom/`, and `orig/`. Twenty-four representative mixed-case paths
were ignored, negative source-path controls remained trackable, tracked disc
images remained zero, and `git diff --check` passed. The change does not delete,
move, hash, upload, publish, or rewrite any disc image or Git history.

The exact base and topic contain no `.github/workflows` path. PR #27 had no
hosted check rollup; no paid hosted Apple runner was triggered. The metadata-only
change requires no native or sanitizer build.

## Exact `da96bf622` production link

Before the metadata-only PR, a serialized full `ac_pc` target was built from
the detached, clean exact source merge at:

`/private/tmp/acgc-integrator-baseline-merged.RYBgtn`

The fresh build root was:

`/private/tmp/acgc-da96-acpc.dx61OH`

The target produced the arm64 Mach-O executable:

`/private/tmp/acgc-da96-acpc.dx61OH/bin/AnimalCrossing`

- size: 15,313,376 bytes
- SHA-256:
  `e0e358b3a432178a30a49105a7582984da2930432fbee07994a50977aba1bc01`
- unresolved internal `_pc_`, `_GX`, or `_acgc_` symbols: zero
- copied shader artifacts: two

Every symbol required by the bounded trace resolved exactly once by name with
LLDB prologue skipping disabled. This proves the exact `da96bf622` production
link and trace symbol surface. It does not prove rendering, Metal encoding,
pixels, device behavior, input, audio, save/reload, normal teardown, or
playability. PR #27 changes no source or build topology, so those exact source
link facts remain applicable to `503194ff2`; the produced binary itself is tied
to `da96bf622`.

## Bounded serialized real-process trace

One metadata-only LLDB harness launched the exact linked binary from the
existing local runtime directory. It used symbol-name entry breakpoints,
dynamic link-register return breakpoints, a 60-second/20-attempt bound, one
owner thread, and exact-PID cleanup. It did not copy, redistribute, or inspect
proprietary payload bytes.

Retained trace root:

`/private/tmp/acgc-da96-live-trace.xQW5Kb`

The first successful publication trace proved one real attempt in which every
canonical producer returned success:

1. Transform
2. Channels
3. Texgen
4. Texture/Dynamic
5. TEV
6. Lighting
7. Blend
8. Alpha
9. Depth
10. Raster
11. Fog
12. Geometry dependencies
13. Geometry
14. Indirect

The gatherer returned `1`, attempt ID 1 was notified with result `1`, and the
Apple callback was dispatched. This is the first game-owned cumulative
envelope publication proof for the current chain. The Apple plan returned
typed status 9, `GEOMETRY_LIMIT`, so the handoff reported `PLAN_REJECTED`; the
typed packet consumer and Metal sink were not reached.

Follow-up discriminator traces remained bounded and cleaned up the exact
inferior. Envelope parsing, all non-Geometry validators, the canonical Geometry
validator, the first position, normal, and color values, and all fourteen
producer results passed. The exact first failing operation was the first TEX0
scalar in `plan_decode_geometry`.

## Exact Geometry mismatch

The final discriminator recorded only Geometry metadata and decoder arguments:

- Geometry byte size: 3,548
- primitive: triangles
- vertex count: 51
- present attributes: POS, NRM, CLR0, TEX0
- indexed mask: zero
- TEX0 descriptor source VAT type: 3 (U16)
- TEX0 source fraction: 0
- TEX0 canonical word count: 2
- TEX0 value encoding: 1 (canonical words)
- first TEX0 S canonical word: `0x43800000` (binary32 256.0)

The PC Geometry producer had already converted the source U16 value to a
canonical binary32 word. Apple then called
`acgc_gx_canonical_geometry_decode_scalar_word(3, 0, 0x43800000, ...)`, treating
that binary32 bit pattern as another raw U16 value. The decoder correctly
rejected the out-of-range raw-U16 representation and the plan returned
`GEOMETRY_LIMIT`.

Source inspection confirms the contract mismatch. The PC Geometry producer
converts source scalar/normal values to canonical binary32 words and packed
colors to logical RGBA8, while the canonical Geometry ABI requires
`value_encoding == 1`. The Apple plan decoder resolves the correct value record
but then re-applies raw VAT and packed-color conversion. Existing F32 plus RGBA8
coverage was identity-compatible and hid the double decode.

Exactly one successor owns this blocker: consume the already-canonical
Geometry words directly in the Apple plan, retain address/index resolution and
fail-closed structural validation, and extend the source-backed round-trip with
integer POS/TEX0, integer NRM, and packed non-RGBA8 CLR0 cases. Texgen is not a
live blocker: its producer and both Apple Texgen validations passed.

## Two-upstream crosswalk

The exact PC source is authoritative for the host canonical transport:

- `pc/src/pc_gx_geometry_producer.c` converts raw GX values into canonical
  Geometry stream words and validates the completed section;
- `include/acgc/gx_canonical_geometry_state.h` defines the canonical Geometry
  word contract and `value_encoding == 1`;
- `pc/apple/src/apple_canonical_plan.c` owns the Apple Geometry plan decoder;
- `pc/src/pc_gx_cumulative_gatherer.c` and `pc/src/pc_gx.c` own the production
  gather/publication boundary; and
- `pc/tests/pc_gx_canonical_plan_roundtrip_fixture.c` is the existing
  source-backed end-to-end CPU gate.

The decomp oracle preserves original raw GX semantics in
`src/static/dolphin/gx/GXAttr.c`, `GXGeometry.c`, `GXVert.c`, and
`include/dolphin/gx/GXVert.h`. It has no Apple canonical-plan, cumulative
envelope, host ignore-policy, CMake/CTest, or LLDB-harness counterpart.

## Proof boundary and next gate

Proved:

- exact PC PR #27 parentage, one-path scope, ignore behavior, and merge;
- exact `da96bf622` full arm64 production link and trace symbol resolution;
- one real cumulative gather/publication with all fourteen producers passing;
- Apple callback dispatch and typed `GEOMETRY_LIMIT` plan rejection;
- the exact first live predicate and canonical-word double-decode cause; and
- exact-PID cleanup with no retained live inferior.

Not proved:

- the pending Apple Geometry decoder correction;
- a successful live typed consumer or Metal sink call;
- Metal encode, present, readback, or pixels;
- input, audible audio, save/reload, lifecycle, iOS, device, or playability; or
- deletion, history removal, or redistribution of proprietary data.

The next gate is one independently reviewed Apple Geometry-plan source change,
fresh native and combined ASan/UBSan execution of the exact source-backed
round-trip target, one-at-a-time PC PR/merge, the same gate on the exact merge,
and one subsequent bounded real-process trace to the next first failure or a
successful typed consumer handoff.
