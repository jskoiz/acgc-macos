# Modern Apple Port Charter

## Objective

Use the complete GameCube decompilation and existing native PC port as source
references for a legal, reproducible modern port that runs on current macOS and,
after shared portability work is proven, iOS.

## Source roles

- `upstream/ac-decomp`: authoritative decompiled game logic and matching-build
  workflow for `GAFE01_00`.
- `upstream/ACGC-PC-Port`: existing x86 Windows host and translation layer,
  including SDL2, OpenGL 3.3, input, save, and runtime disc access.
- `local/roms`: user-owned local disc input. Never versioned or redistributed.

## Evidence gates

Each gate requires its own recorded command or observable proof. Passing a later
compile step does not imply an earlier runtime behavior, and simulator evidence
does not imply physical-device evidence.

1. **Source/revision:** local input is ignored, has the approved SHA-256, is
   accepted as `GAFE01_00`, and yields the expected original DOL/REL hashes.
2. **Portable core:** shared libraries compile and pass focused tests on native
   arm64 macOS without depending on SDL, OpenGL, or a 32-bit pointer ABI.
3. **Host launch:** a macOS process starts, resolves its user-data directories,
   and exits cleanly without asserting renderer success.
4. **Rendered frame:** Metal presents a known clear frame, then representative
   GX geometry, texture, TEV, and EFB behavior with captured evidence.
5. **Game frame:** the supported revision reaches an identifiable game frame;
   this is distinct from general playability.
6. **Input:** keyboard and controller mappings are observed in the running game.
7. **Audio:** the game mixer reaches an Apple audio sink with stable timing.
8. **Save/load:** a sandboxed save survives process restart and round-trips
   without changing the GameCube wire format.
9. **macOS acceptance:** a human validates a bounded play path on current macOS.
10. **iOS simulator:** lifecycle, touch/controller input, files, and audio work
    in Simulator through the same shared core and Metal backend.
11. **Physical device:** signing-authorized hardware proves rendering,
    lifecycle, input, audio, save/load, performance, thermal, and memory gates.

## Non-goals for bootstrap

- No distribution of Nintendo assets or a bundled disc image.
- No App Store submission or public binary release.
- No claim that compilation equals playable compatibility.
- No broad rewrite before the platform-assumption audit is complete.

## Repository and data boundary

Source edits stay on explicit branches in the owning submodule. Umbrella
documents, scripts, evidence, and verified gitlink updates stay here. Generated
builds, extraction output, logs, the ISO, and all other proprietary game data
remain under ignored local or build paths and are never committed.
Focused source, test, and audit lanes may be handed to the configured remote M3
Max host once their exact branch/worktree contract is recorded. Full
`ac_pc` links and LLDB launches are serialized across local and remote hosts;
cloud tasks are limited to non-build planning/review. The ISO, extracted assets,
keys, and proprietary game data remain local.

## Current gate state

As of 2026-08-15, the canonical local PC branch is clean at `0f896395c`, with
the independently reviewed Depth and Transform leaf producers, portable Texgen/SU ABI,
canonical Geometry leaf producer, reviewed
setter-owned raw Geometry closure, typed indexed host mirroring,
packed-color FIFO-width provenance and RGBX8 ignored-byte handling,
setter-owned raw Raster provenance, the source-faithful viewport-jitter
adjustment, setter-owned raw Alpha/ZCompLoc provenance and production-object
availability, the strict portable Raster value ABI, persistent raw Channels and
Lighting, immutable raw Geometry
batches, a pointer-free raw Texture/TLUT owner and synchronous resource lease,
the strict neutral Texture/TLUT, Dynamic, Lighting, and Channels ABIs, repaired `GXSetZMode`
flush-before-mutation
boundary, setter-owned raw Texgen/SU provenance, and canonical Geometry ABI on
top of the portable 888-byte Transform ABI and setter-owned raw Transform and
Depth provenance, the portable 16-byte Depth ABI,
setter-owned raw TEV/KONST provenance, and the canonical 32-byte Alpha/update
and 16-byte Blend/logic sections on top of the strict GX envelope
validator, legacy V4 sink guard, standalone canonical fog value section,
focused input trigger-parity correction, and the
`5157ac1cb` Apple V2 sink-status guard and the `820906439` V2-local
alpha-reference normalization and the
`59d13a98` bounded base-state rejection classifier and the
`c973dbee` triangle-list batch handoff, remote M3 Max lane-132 source record,
and lane-133 Apple binder. The classifier leaves the original V2 acceptance
predicate authoritative and names each first fail-closed tier. Native and
combined ASan/UBSan focused CTest pass `2/2` each on the exact integrated
snapshot. A single serialized current-tip link/trace then disproved the
source-only `blend` prediction: the first capped live reason is `alpha_test`
with both comparisons `GX_ALWAYS` but nonzero reference bytes, followed by a
distinct two-texgen/two-TEV/nonzero-fog `global_count` cohort. Packet
initialization/validation and all Apple consumer/provider/observer counts stay
at zero. This remains predicate/runtime evidence only: no live packet,
callback, Metal encode/readback, pixel, device, or playability claim is made.
See [V2 base-state rejection evidence](evidence/V2-BASE-REJECTION-CLASSIFIER-59D13A98-2026-08-14.md)
and [current runtime evidence](evidence/CURRENT-V2-REJECTION-RUNTIME-59D13A98-2026-08-14.md).

The exact remote worker change `2dcd69c4a` is integrated as `820906439`.
Remote and exact integrated native plus combined ASan/UBSan focused CTest each
pass `1/1`. Nonzero refs are ignored only for the reviewed
`GX_ALWAYS/GX_ALWAYS` plus `GX_AOP_AND` V2 state; the refs remain stored,
active comparisons and unsupported operators still fail closed, and the live
tuple advances to `blend`. See
[V2 alpha-reference normalization](evidence/V2-ALPHA-REFERENCE-NORMALIZATION-820906439-2026-08-14.md).

The exact remote Apple policy commit `a4d90512c` is integrated as
`5157ac1cb`; it rejects V2/V3 and malformed status tuples. Follow-up worker
`0bda49d23` is integrated as `62ef6638d` and also rejects V4, leaving V1 as
the only semantic version eligible for the current geometry-only sink until
the canonical CPU plan exists. Remote and exact integrated native plus
combined ASan/UBSan focused CTest pass `1/1`; a production syntax compile
passes. See [Apple V2 sink guard](evidence/APPLE-V2-SINK-GUARD-5157AC1CB-2026-08-14.md)
and [legacy V4 sink guard](evidence/APPLE-V4-SINK-GUARD-62EF6638D-2026-08-14.md).

The canonical fog audit keeps V1-V4 frozen and defines an end-state reusable
80-byte value-only fog section, explicit state-mask semantics, and separate
borrowed resource ownership for eventual cumulative packet composition. This
is architecture evidence only. See
[canonical fog-state contract](evidence/CANONICAL-FOG-STATE-CONTRACT-59D13A98-2026-08-14.md).

The exact remote input commit `047ec5134` is integrated as `afb1cac3c`.
Axis-bound L/R digital state now follows the same nonzero normalized analog
value delivered through `PADStatus`, while digital bindings and trigger scaling
remain unchanged. Exact integrated native and combined ASan/UBSan focused CTest
pass `1/1` each. This is virtual-controller CPU evidence, not physical input,
running-game response, device, or playability proof. See
[input trigger parity](evidence/INPUT-TRIGGER-PARITY-AFB1CAC3C-2026-08-14.md).

The exact remote fog worker `956e0571b` is integrated as `b5f550ea0`. It adds
an 80-byte, pointer-free, fixed-width fog value section and validator while
leaving V1-V4, `pc_gx`, and Apple runtime unchanged. Exact integrated native
and combined ASan/UBSan focused CTest pass `1/1` each. See
[canonical fog implementation](evidence/CANONICAL-FOG-STATE-B5F550EA0-2026-08-14.md).

The separate read-only Apple audit selected a cumulative snapshot, validated
owned resource sideband, immutable CPU encode plan, and later device-gated
encoder. Its V4 sink-safety finding is now closed by `62ef6638d`; V4 still is
not a rendering contract because it does not encode all live GX state. See
[Apple canonical consumer audit](evidence/APPLE-CANONICAL-CONSUMER-AUDIT-5157AC1CB-2026-08-14.md).

The cumulative GX crosswalk selects a strict 14-section canonical envelope and
rejects a V5 bridge. Integrated `4dbb71065` adds the fixed header/directory,
dynamic aligned payload extent, and fail-closed metadata validator around the
existing fog section; exact integrated native and combined ASan/UBSan focused
CTest pass `2/2` each. The full byte size is not frozen: each neutral section
must first have an exact tested ABI. The completed two-upstream Blend/logic
audit selects the reusable 16-byte V3 four-word record without importing
Alpha/update or Raster fields. Integrated `216d1e24b` implements its fixed ABI,
strict value validator, and exact metadata helper; exact integrated native and
combined ASan/UBSan focused CTest pass `3/3` each. See
[canonical GX schema crosswalk](evidence/CANONICAL-GX-SCHEMA-CROSSWALK-5157AC1CB-2026-08-14.md),
[canonical envelope evidence](evidence/CANONICAL-GX-ENVELOPE-4DBB71065-2026-08-14.md),
[Blend/logic contract](evidence/CANONICAL-BLEND-LOGIC-CONTRACT-B5F550EA0-2026-08-14.md),
and [Blend implementation evidence](evidence/CANONICAL-BLEND-STATE-216D1E24B-2026-08-14.md).

The read-only producer audit selects the top of `pc_gx_flush_vertices()` after
the committed-vertex count check and before legacy packet handoffs, shader
selection, or GL mutation. It also keeps implementation gated on raw projection,
signed S10, fog-range, raster/depth, VCD/VAT, TEV-capacity, and owned
texture/TLUT state. See
[snapshot producer audit](evidence/CANONICAL-SNAPSHOT-PRODUCER-AUDIT-B5F550EA0-2026-08-14.md).

The read-only Alpha/update audit freezes `0x0100` as a 32-byte eight-word
contract for alpha comparisons/references/operator, color/alpha update, and
`z_comp_loc`. The PC port still drops `GXSetZCompLoc`, so portable contract
implementation does not yet establish complete live producer provenance. See
[canonical Alpha/update contract](evidence/CANONICAL-ALPHA-UPDATE-CONTRACT-4DBB71065-2026-08-14.md).

Integrated `f2b7ab153` implements that exact portable Alpha/update ABI,
strict value and metadata validation, and inactive-reference preservation.
Exact integrated native and combined ASan/UBSan canonical-state CTest pass
`4/4` each. This remains CPU-contract evidence: the PC `GXSetZCompLoc` no-op
still prevents a complete live producer. See
[canonical Alpha implementation](evidence/CANONICAL-ALPHA-STATE-F2B7AB153-2026-08-14.md).

The TEV audit selects a full 16-stage, 2560-byte `0x0020` value contract rather
than inheriting the PC shader cap of 3 or legacy packet cap of 2. See
[canonical TEV contract](evidence/CANONICAL-TEV-CONTRACT-4DBB71065-2026-08-14.md).

Integrated `037689462` now retains exact setter-owned PREV/REG0-2 signed or
u8 values and K0-3 u8 values, including unavailable and malformed knownness,
while preserving the existing float path. Exact integrated native and combined
ASan/UBSan focused CTest pass `1/1` each. See
[PC raw TEV shadow](evidence/PC-RAW-TEV-SHADOW-037689462-2026-08-14.md).

Integrated `6d1d310c0` implements the separate portable TEV section with exact
layout, value, inactive-record, selector-hole, and metadata validation. Exact
integrated native and combined ASan/UBSan canonical-state CTest pass `5/5`
each. Compare operations preserve logical setter arguments rather than packed
BP-register bits. A future cumulative producer must join this ABI with the raw
shadow and validate cross-section references; no live renderer handoff follows.
See [canonical TEV implementation](evidence/CANONICAL-TEV-STATE-6D1D310C0-2026-08-14.md).

The Transforms/Texgens provenance audit kept both sections fail-closed until
the PC port retained raw pre-widescreen projection, exact matrix domains/types/
knownness, texgen normalize/post state, and manual SU fields. The
Transform/matrix repair, neutral Transform ABI, and non-overlapping raw
Texgen/SU repair are now integrated; the cumulative producer remains open.
See [Transforms/Texgens provenance](evidence/CANONICAL-TRANSFORM-TEXGEN-PROVENANCE-216D1E24B-2026-08-14.md).

The exact follow-up freezes `0x0002` as a version-1 888-byte Transform payload
with six raw projection coefficients, ten position and ten normal slots,
strict logical IDs, and explicit knownness. Ordinary/post texture matrices,
texgen references, and manual SU remain solely in `0x0008`. Integrated
`59714a1fd` retains the setter-owned raw values and per-slot unresolved indexed
state without changing the host renderer. Integrated `c3e158398` implements
the strict portable `0x0002` section; exact native and combined ASan/UBSan
canonical matrices pass `7/7`. The live cumulative producer remains open. See
the [canonical Transform contract](evidence/CANONICAL-TRANSFORM-CONTRACT-216D1E24B-2026-08-14.md),
the [PC raw Transform shadow](evidence/PC-RAW-TRANSFORM-SHADOW-59714A1FD-2026-08-14.md),
and the [canonical Transform implementation](evidence/CANONICAL-TRANSFORM-STATE-C3E158398-2026-08-14.md).

The corrected Texgen/SU contract freezes section `0x0008` as an exact `0xA40`
payload with writable ordinary selector `60` and post selector `125`, explicit
per-word knownness, and raw manual-SU state. The corrected Geometry contract
freezes section `0x0001` with a `0x6B0` fixed prefix, 26 exact descriptors, a
section-relative stream, and a `0x10000` inclusive size cap. The neutral
Geometry worker chain is independently reviewed and integrated as
`910c7f6f52`; raw Texgen/SU is independently reviewed and integrated through
`1d48691a4f`. Exact integrated native and combined ASan/UBSan raw-state
matrices pass `4/4` each, while the canonical matrix passes `8/8`. See the
[Texgen/SU contract](evidence/CANONICAL-TEXGEN-CONTRACT-6D1D310C0-2026-08-14.md),
[Geometry contract](evidence/CANONICAL-GEOMETRY-CONTRACT-6D1D310C0-2026-08-14.md),
the [Geometry implementation](evidence/CANONICAL-GEOMETRY-STATE-910C7F6F5-2026-08-14.md),
and the [PC raw Texgen/SU shadow](evidence/PC-RAW-TEXGEN-SU-SHADOW-1D48691A4-2026-08-14.md).

The Depth/Raster audit freezes `0x0200` as a 16-byte Z-mode section and
`0x0400` as a 128-byte logical viewport/scissor/raster section. It identifies
the PC host-state, no-op, jitter, cull-override, line/point, destination-alpha,
field, and knownness gaps. Integrated `c736f9686` implements the strict
portable Depth section and exact envelope metadata validation; native and
combined ASan/UBSan canonical matrices pass `6/6`. Integrated
`eeec2301c1`/`251a010b8` add setter-owned raw Depth provenance while preserving
the typed `GXSetZMode` boundary. Integrated `9f149b6fd9` then ensures a
completed old batch flushes before raw or effective Depth mutation; exact
native and combined ASan/UBSan Transform/Depth/TEV/Texgen matrices pass `4/4`.
Integrated `b3336504c` implements the strict 128-byte portable Raster ABI;
exact native and combined ASan/UBSan canonical matrices pass `13/13`. Raw
Raster provenance and the cumulative producer remain open; none of this is
live-renderer evidence. See the
[canonical Depth/Raster contracts](evidence/CANONICAL-DEPTH-RASTER-CONTRACT-F2B7AB153-2026-08-14.md),
the [canonical Depth implementation](evidence/CANONICAL-DEPTH-STATE-C736F9686-2026-08-14.md),
the [canonical Raster implementation](evidence/CANONICAL-RASTER-STATE-B3336504C-2026-08-15.md),
the [PC raw Depth shadow](evidence/PC-RAW-DEPTH-SHADOW-251A010B8-2026-08-14.md),
and the [Depth flush-order repair](evidence/PC-DEPTH-FLUSH-ORDER-9F149B6FD-2026-08-14.md).

Integrated `039afce0e` adds setter-owned Alpha compare, color/alpha update,
and `GXSetZCompLoc` provenance with completed-batch flush-before-mutation
ordering. It publishes only a complete, valid eight-word state through the
existing canonical Alpha validator, and the real production target now
compiles and links the builder. Exact native and combined ASan/UBSan focused
CTest pass `2/2` each, including a production-object compile. This is CPU
producer evidence only, not a full link or live renderer result. See
[PC raw Alpha/ZCompLoc evidence](evidence/PC-RAW-ALPHA-ZCOMP-039AFCE0E-2026-08-15.md).

The canonical setter-order audit fixes the producer-facing invariant at
`pc_gx_flush_vertices`: flush a completed old batch before any raw/effective
state mutation. The repaired Texgen/SU worker applies it to exactly seven
setters; canonical `9f149b6fd9` now applies it to `GXSetZMode` as well.
`GXEnableTexOffsets` remains Raster-owned. Raster, Indirect, and
resource-generation order remain separate owners. See
[canonical setter-order evidence](evidence/CANONICAL-SETTER-ORDER-251A010B8-2026-08-14.md)
and the [Depth flush-order repair](evidence/PC-DEPTH-FLUSH-ORDER-9F149B6FD-2026-08-14.md).

The Channels/Lighting audit freezes `0x0004` as a 136-byte two-record channel
section and `0x0040` as a 516-byte eight-slot final light-object section.
Integrated `324c174ae3` implements Channels and `43992e7085` implements
Lighting as strict pointer-free value ABIs with exact envelope metadata
validation; native and combined ASan/UBSan canonical matrices pass `10/10`.
Integrated `38343a5eb5` now captures persistent setter-owned raw Channels and
passes the exact affected native and combined ASan/UBSan matrices `7/7` each.
An independent exact-tip refresh passes all twelve neutral validators and six
raw fixtures natively and under combined ASan/UBSan (`18/18` each, serial,
leak detection disabled), with corrected public C/C++11 and bounded ILP32/
Windows ABI syntax probes. A real Windows build remains blocked by host SDL
framework imports and the absent private-PC Windows toolchain/headers; see
[current focused matrix evidence](evidence/CURRENT-FOCUSED-MATRIX-38343A5EB-2026-08-14.md).
Integrated `97aebd8a2d` adds pointer-free eight-slot raw Lighting provenance,
unresolved indexed-load tracking and repair, final-direction semantics, and
strict Channels dependency validation. Exact integrated native and combined
ASan/UBSan focused matrices pass `9/9`, with both production objects compiling.
The PC still needs cumulative cross-section conversion and resource ownership.
See the
[canonical Channels/Lighting contracts](evidence/CANONICAL-CHANNELS-LIGHTING-CONTRACT-037689462-2026-08-14.md),
the [canonical Channels implementation](evidence/CANONICAL-CHANNELS-STATE-324C174AE-2026-08-14.md),
the [canonical Lighting implementation](evidence/CANONICAL-LIGHTING-STATE-43992E708-2026-08-14.md),
[raw Channels integration evidence](evidence/PC-RAW-CHANNELS-38343A5EB-2026-08-14.md),
and [raw Lighting integration evidence](evidence/PC-RAW-LIGHTING-97AEBD8A2-2026-08-14.md).

The Texture/TLUT/Dynamic audit freezes separate pointer-free `0x0010` and
`0x2000` contracts. Stable logical IDs, owner epochs, per-image and per-TLUT
generations, exact metadata, and a synchronous external byte lease replace
host pointers, GL names, and cache hashes. Integrated `a641e55efb` implements
both neutral synthetic-value validators with exact minification `0..5` and
decomp-effective magnification `0..1` domains; exact native and combined
ASan/UBSan canonical matrices pass `12/12`. Integrated `698d45d3e` implements
the private raw map/TLUT owner, checked generations, exact tiled/mip/source
metadata, converted-image provenance, canonical conversion, and the
callback-scoped borrowed-resource lease. Root review rejected the first
over-broad TLUT invalidation; the repair preserves unrelated non-indexed maps
and invalidates only indexed maps dependent on the changed TLUT. Exact
integrated native and combined ASan/UBSan focused matrices pass `7/7` each.
Cumulative production and Apple delivery remain separate later owners. See the
[canonical Texture/Dynamic contract](evidence/CANONICAL-TEXTURE-DYNAMIC-CONTRACT-324C174AE-2026-08-14.md)
[integrated implementation evidence](evidence/CANONICAL-TEXTURE-DYNAMIC-A641E55EF-2026-08-14.md),
the [raw Texture/TLUT producer plan](evidence/RAW-TEXTURE-TLUT-PRODUCER-PLAN-23C26E520-2026-08-14.md),
and [raw Texture/TLUT integration evidence](evidence/PC-RAW-TEXTURE-TLUT-698D45D3E-2026-08-15.md).

The refreshed producer and Apple audits reject another transitional packet
shim. Integrated `23c26e520a` now captures immutable Geometry VCD/VAT/array and
completed-batch provenance at `pc_gx_flush_vertices`, including direct
`GX_TEX_S` and exact INDEX8/INDEX16 entry-point width. Integrated `97aebd8a2d`
supplies persistent raw Channels and Lighting, `698d45d3e` supplies raw
Texture/TLUT generations and synchronous resource leases, `b3336504c`
supplies the neutral Raster value ABI, `039afce0e` supplies raw
Alpha/ZCompLoc provenance, `85b25cb3c` supplies setter-owned raw Raster
provenance with the decomp viewport-jitter adjustment, `b9a9f355` closes the
bounded raw Geometry contract with copied lifetime, supported indexed scalar
host conversion, exact packed-color entry widths, and fail-closed unsupported
matrix/NBT and extra attribute slots, `689590cc` supplies the strict
pointer-free canonical Geometry producer, `590b2bd73` supplies the fixed
2,624-byte portable Texgen/SU section, and `37ae640d5` supplies the
destination-preserving Transform leaf producer. `0f896395c` supplies the
raw-to-canonical Depth producer. Integrated `a42da8e155` supplies the
neutral section-13 Indirect ABI. Raw Indirect ownership/conversion and
remaining leaf producers remain prerequisites.
A cumulative producer
must then preflight
every required section and resource
generation before one synchronous all-or-nothing callback. Apple consumption
begins only after that contract, through a pure-C immutable plan and separately
owned resources, encoder, MSL, present, and readback gates. See the
[raw Geometry integration evidence](evidence/PC-RAW-GEOMETRY-BATCH-23C26E520-2026-08-14.md),
[earlier canonical producer readiness audit](evidence/CANONICAL-PRODUCER-READINESS-1D48691A4-2026-08-14.md),
[current cumulative readiness reconciliation](evidence/CURRENT-CUMULATIVE-PRODUCER-READINESS-698D45D3E-2026-08-15.md),
[canonical Indirect contract](evidence/CANONICAL-INDIRECT-CONTRACT-698D45D3E-2026-08-15.md),
[canonical Indirect implementation](evidence/CANONICAL-INDIRECT-STATE-A42DA8E15-2026-08-15.md),
[raw Alpha/ZCompLoc evidence](evidence/PC-RAW-ALPHA-ZCOMP-039AFCE0E-2026-08-15.md),
[raw Raster evidence](evidence/PC-RAW-RASTER-85B25CB3C-2026-08-15.md),
[canonical Geometry producer evidence](evidence/CANONICAL-GEOMETRY-PRODUCER-689590CC-2026-08-15.md),
[portable Texgen/SU evidence](evidence/CANONICAL-TEXGEN-SU-590B2BD73-2026-08-15.md),
[current Geometry converter readiness audit](evidence/CURRENT-GEOMETRY-CONVERTER-READINESS-039AFCE0E-2026-08-15.md),
[raw Geometry closure evidence](evidence/PC-RAW-GEOMETRY-CLOSURE-B9A9F355-2026-08-15.md),
and [Apple canonical-plan readiness audit](evidence/APPLE-CANONICAL-PLAN-READINESS-1D48691A4-2026-08-14.md).

The final raw Geometry lane closes the setter-owned batch boundaries identified
by the earlier audit without inventing a transition packet. The copied batch is
still not the finished canonical producer: a separately owned converter must
serialize the supported raw subset, validate Transform/Texgen dependencies,
and fail closed on unsupported matrix/NBT and extra color/texture slots. That
converter is now dependency-ready in new files because the raw `pc_gx.c` owner
has completed and released its overlap; no duplicate owner is introduced.

The exact `23c26e520a` focused baseline passes all twelve neutral validators
and five setter-owned raw fixtures natively (`17/17`) and under combined
ASan/UBSan (`17/17`, leak detection disabled). C/C++11 plus bounded ILP32 and
Windows-header probes pass. A real i686 Windows build remains blocked by the
absent compiler, sysroot, archive, and link toolchain, so this is not Windows
sign-off or full-link/runtime/Metal/pixel/playability evidence. See
[current focused matrix evidence](evidence/CURRENT-FOCUSED-MATRIX-23C26E520-2026-08-14.md).

The focused `b5f550ea0` matrix passes native and combined ASan/UBSan `44` tests
with three declared Metal-device skips in each configuration. Bounded Windows
host probes pass `4` and are blocked at `5` by Apple libc++ locale emulation,
missing `<process.h>`, and absent i686 sysroots/toolchains. The exact
post-envelope/sink delta at `4dbb71065` passes native and combined ASan/UBSan
`3/3`. This is CPU/build evidence only. See
[focused matrix evidence](evidence/CURRENT-FOCUSED-MATRIX-B5F550EA0-2026-08-14.md).

The current-tip `251a010b8` M3 Max device-fixture gate separately passes nine
selected native Apple fixtures, six CPU-compatible combined ASan/UBSan tests,
three offline MSL compilations, and the existing offscreen sink's deterministic
pixel/checksum readback assertions. This is synthetic device evidence only. It
does not prove a cumulative game snapshot, live game callback, game-owned
Metal encode, window presentation, game-owned pixel, iOS, or playability. See
[M3 Max Metal-device fixture evidence](evidence/M3-METAL-DEVICE-FIXTURES-251A010B8-2026-08-14.md).

Three read-only M3 Max follow-ups now classify both cohorts and the independent
Apple status policy. The alpha references are dead only for the exact
`GX_ALWAYS/GX_ALWAYS` plus `GX_AOP_AND` form and may be ignored locally by V2;
the next live rejection remains blend. The `global_count` tuple is valid
two-texgen/two-TEV state with `GX_FOG_PERSP_LIN`, not a stale count; V2 lacks
the required fog mode and coefficients. Ordinary V2 marked
`V2_EXTENSION_NOT_RENDERED` is also conditionally source-reachable to the
geometry-only Metal sink and must fail closed. See
[alpha-reference semantics](evidence/V2-ALPHA-REFERENCE-SEMANTICS-59D13A98-2026-08-14.md),
[fog/global-count crosswalk](evidence/V2-GLOBAL-COUNT-FOG-CROSSWALK-59D13A98-2026-08-14.md),
and [Apple V2 sink policy](evidence/APPLE-V2-SINK-STATUS-POLICY-59D13A98-2026-08-14.md).

The test-only lane-135 follow-up at `2b141a753` adds rejection coverage for the
V2 callback guard, fixed triangle topology, ordinary emu64 blend state,
decomp-compatible `GX_SRC_VTX` channel state, and the downstream texture
provider boundary. The integrated focused target passes native `1/1` and
combined ASan/UBSan `1/1` with no diagnostics; no production V2 predicate was
relaxed. See [V2 rejection fixture evidence](evidence/V2-HANDOFF-REJECTION-FIXTURE-88724CDB-2026-08-14.md).

The current-tip runtime gate at `2b141a753` then completed one serialized
`[4018/4019]` arm64 link and one GUI-session LLDB launch. The disc-backed run
reached COPYDATE, forest/Famicom loading, NEOS/LOGO, and game-owned GX flush;
the opt-in diagnostic emitted 64 bounded V2 rejection records and the V2
builder was entered 523 times. The Apple consumer, texture provider, and
runtime observer remained unobserved. This is live builder-rejection and boot
progress evidence only, with no Metal encode/present/readback, pixel, input,
audio, save, device, simulator, or playability claim. See [current V2 rejection
runtime evidence](evidence/CURRENT-V2-REJECTION-RUNTIME-2B141A753-2026-08-14.md).

The integrated `565f877e` V2 channel-source contract keeps the fixed-width ABI
unchanged while validating the decomp-compatible disabled `GX_SRC_REG` /
`GX_SRC_VTX` forms before the typed Apple consumer. Unsupported or malformed
state fails closed, V1 remains separate, and vertex-source V2 remains
`V2_EXTENSION_NOT_RENDERED`. Native and combined ASan/UBSan focused CTest
pass `3/3` each with no diagnostics. This is a CPU/contract gate only; it does
not prove a live callback, Metal encode/readback, pixel, device, or playability.
See [V2 channel-source contract evidence](evidence/V2-CHANNEL-SOURCE-CONTRACT-565F877E-2026-08-14.md).

The separately serialized current-tip runtime gate at `565f877e` then linked
the arm64 target through `[4018/4019]` and booted the local GAFE01 revision in a
logged-in GUI LLDB session. It reached LOGO/NEOS and recorded 509 V2 builder
attempts, but no typed Apple consumer/provider/observer call. The 32 bounded
rejected draws contained no three-vertex batch: 31 were triangle-list multiples
of three and one was a quad. The first live predicate is therefore the V2
builder's exact-three-vertex guard, before the channel-source contract. The
next gate is a focused, all-or-nothing triangle-list splitter that leaves the
three-vertex Apple consumer and legacy OpenGL path unchanged. This is boot and
builder-frontier evidence only; it adds no Metal/pixel/device/playability claim.
See [current V2 channel runtime evidence](evidence/CURRENT-V2-CHANNEL-RUNTIME-565F877E-2026-08-14.md).

The integrated `c973dbee` follow-up closes that CPU/source blocker without
broadening the three-vertex Apple consumer. A direct single triangle keeps the
existing V2 path; eligible grouped triangle lists are fully preflighted, then
delivered as ordered three-vertex packets. A failed later slice produces zero
callbacks, while quads, nonmultiples, unsupported state, V3/V4 fallback, and
legacy OpenGL behavior remain unchanged. Native and combined ASan/UBSan focused
CTest pass `2/2` each on the exact integrated snapshot. This is still a
CPU/contract gate; one separately serialized current-tip link/trace must now
measure real callback and Apple-consumer reachability. See
[V2 triangle-batch evidence](evidence/V2-TRIANGLE-BATCH-HANDOFF-C973DBEE-2026-08-14.md).

The separately serialized `c973dbee` runtime gate then linked `[4018/4019]`
and launched a real GAFE01 inferior. It reached LOGO/NEOS through frame 901,
game-owned graph/GX, and 213 eligible grouped-triangle batch entries. Every
batch reached its first exact-three internal builder call, but none passed the
initial V2 base-state predicate or reached the Apple consumer, texture-source
provider, or runtime observer. Bounded TERM returned through `graph_proc` with
status `0`; KILL was unnecessary. The next gate is therefore a narrow,
test-backed rejection-reason classifier for that compound base-state contract,
not an unconditional predicate relaxation. This remains link/boot/builder-tier
evidence only, with no packet, Metal, pixel, device, natural-shutdown, or
playability claim. See [current V2 triangle runtime evidence](evidence/CURRENT-V2-TRIANGLE-RUNTIME-C973DBEE-2026-08-14.md).

The read-only renderer-contract and Apple-sink audits at `c973dbee` found that
V1/V2/V3/V4 are parallel partial contracts rather than cumulative revisions.
The chosen architecture is one deliberately named canonical value-only
draw/state ABI with an independent synchronous borrowed texture-resource
sideband and one required-section status mask. The Apple source path can reach
the geometry sink from ordinary V2 even while its extension is marked
`V2_EXTENSION_NOT_RENDERED`; provider-backed `CPU_RESOLVED` texture/TEV output
is deliberately stopped before the sink. The first observation is a potential
status-policy defect from static source crosswalk. This is architecture/source
reachability evidence, not a live callback, Metal encode/present/readback, or
pixel result. See [renderer contract consolidation](evidence/RENDERER-CONTRACT-CONSOLIDATION-C973DBEE-2026-08-14.md)
and [Apple sink reachability](evidence/APPLE-SINK-REACHABILITY-C973DBEE-2026-08-14.md).

The same `354f33884` snapshot links the full arm64 `ac_pc` target through
`[4018/4019]`. A normal bounded launch from the current shell stops before
boot because SDL reports no displays, but a logged-in GUI Terminal launch
opened the local GAFE01 disc, mounted COPYDATE/forest archives, reached
NEOS/LOGO/`graph_proc`, and was stopped after the bounded window. The one
serialized LLDB trace counted `graph_task_set00=24`, `emu64_taskstart=24`,
`GXBegin=509`, `pc_gx_flush_vertices=509`, and V2 builder entry `508`; the
Apple V2 consumer/provider/observer remained `0`. This proves launch, boot,
and the pre-consumer GX boundary only. It adds no Metal encode/present, pixel,
input, audible audio, save, device, simulator, or playability claim. See
`evidence/CURRENT-V2-TEXTURE-BINDER-RUNTIME-2026-08-14.md`.

As of 2026-08-13, source/revision proof, the current bounded portable-core
slice, macOS host launch, and a deterministic Metal clear/triangle/present
fixture are passed. The preceding V4 integration snapshot is the clean native arm64
PC branch `c1/macos-host-launch` at `a53b192`, which keeps resolved V4
texture-map aliases safe and allows the live unencoded alpha/depth/cull state
through the V4-only predicate while wiring the V4 builder into
the typed Apple consumer/runtime seam on top of `dbf6986` and `4fc6f00`. The
latest serialized full
reconstructed `ac_pc` link recorded before the V3 slice was a native arm64
Mach-O from `042cbf7`, returning `[4018/4019]` in lane 98's one-link run. The
source tip adds the
version-aware GX v2 consumer boundary on top of the
bounded packet builder at `26da235`, the narrow Metal sink shader fix at
`a8f3a8f`, the `59aa655` input frame-guard fixture, and `54b840c` offscreen
Metal sink. The consumer preserves v1 dispatch, validates v2, and reports
`V2_EXTENSION_NOT_RENDERED`; its focused native and ASan/UBSan tests pass
`4/4` each. The V3 state-forwarding slice at `042cbf7` carries the observed
blend/source-alpha/`GX_LO_NOOP` and `GX_TEXMTX0` state through a separate typed
callback, preserves V1/OpenGL, and passes the combined V1/V2/V3 focused native
and ASan/UBSan tests `3/3` each. V3 is explicitly `V3_EXTENSION_NOT_RENDERED`
and is not submitted to the Metal sink. The lane-98 link is build evidence only; its separate runtime
trace completes the second graph task's interpreter continuation but does not
prove task-2 drawing or Metal output. See [GX v2 consumer evidence](evidence/GX-V2-CONSUMER-BOUNDARY-2026-08-13.md)
and [second graph-task completion evidence](evidence/SECOND-GRAPH-TASK-COMPLETION-2026-08-13.md)
and [GX V3 state-handoff evidence](evidence/GX-V3-STATE-HANDOFF-042CBF7-2026-08-13.md).
One current-tip `042cbf7` link now completes as a native arm64 Mach-O, and a
permitted elevated bounded LLDB launch reaches real GAFE01 boot, LOGO/NEOS,
`GXBegin`, `pc_gx_flush_vertices`, and repeated V3 builder-entry attempts.
The V3 Apple consumer and `pc_metal_runtime_observe` remain unobserved (`0`),
so the entry counts do not establish a successful packet or callback. The
unprivileged predecessor still fails before inferior creation with status
`-1`. This is game-owned GX/V3 reachability evidence only; Metal encode,
readback, pixels, clean shutdown, and playability remain open. See [GX V3
current-tip runtime evidence](evidence/GX-V3-CURRENT-TIP-RUNTIME-042CBF7-2026-08-13.md).
The integrated PC source has since advanced to `add2d6f` with an opt-in,
Darwin-only rejection trace. It identifies `g_gx.alpha_update_enable == 0` as
the V3 fail-closed reason for the observed state, matching
`emu64.c:619`'s `GXSetAlphaUpdate(GX_FALSE)`, before the typed callback or Apple
runtime observer. Native and ASan/UBSan focused handoff tests remain `3/3`
each; this is builder-predicate evidence only, not live callback, Metal,
pixel, or playability proof. See [V3 rejection evidence](evidence/GX-V3-REJECTION-ALPHA-UPDATE-ADD2D6F-2026-08-13.md).
The integrated `f18e7cd` fixture now exercises the same boundary in a synthetic
CPU path: disabled alpha writes reject before callback, enabled writes build a
valid V3 packet, the typed consumer reports `V3_EXTENSION_NOT_RENDERED`, and a
malformed packet is rejected without entering the V1 seam. Native and
ASan/UBSan focused CTest pass `2/2` each. This remains contract evidence only;
it does not establish a live callback, Metal encode/readback, pixel, or
playability gate. See [V3 builder-consumer fixture evidence](evidence/GX-V3-BUILDER-CONSUMER-FIXTURE-F18E7CD-2026-08-13.md).
The integrated `4fc6f00` V4 contract preserves the `4968`-byte V3 ABI and
appends an explicit `alpha_update_enable` field for a `4972`-byte packet.
Native and combined ASan/UBSan focused CTest pass `5/5` each with no
diagnostics. V4 remains a CPU/contract builder and validator only; it has no
Apple consumer, live callback, Metal encode/readback, pixel, or playability
claim. See [V4 alpha-state evidence](evidence/GX-V4-ALPHA-STATE-4FC6F00-2026-08-13.md).
The integrated `dbf6986` V4 consumer seam validates the complete packet,
accepts explicit alpha-write values `0` and `1`, exercises the disabled-alpha
case, and rejects malformed state masks/values while keeping V3/V4 state
extensions `NOT_RENDERED`. Native and combined ASan/UBSan focused CTest pass
`6/6` each with no sanitizer diagnostics. This remains CPU/contract evidence;
it does not establish a live V4 callback, Metal encode/readback, pixel, or
playability gate. See [V4 Apple consumer evidence](evidence/GX-V4-APPLE-CONSUMER-DBF6986-2026-08-13.md).
The integrated `28ebac2` continuation adds the missing typed V4 flush callback,
maps the supported blend/alpha subset into the existing Apple sink, and keeps
V3 texture-matrix state explicitly `NOT_RENDERED`. The six affected PC targets
pass `6/6` native and `6/6` combined ASan/UBSan; direct Apple consumer/sink
fixtures pass `2/2` in each matrix. This remains CPU/contract and compile
coverage only: no live V4 callback, Metal encode/present/readback, device,
pixel, or playability claim follows. See [V4 live-consumer evidence](evidence/GX-V4-LIVE-CONSUMER-28EBAC2-2026-08-13.md).
The follow-up `83fe50c` V4-only predicate allows a resolved non-indexed GX
texture-map alias while retaining the strict V1/V2/V3 map-index gate and
leaving the texture/TEV extension unrendered in the Apple consumer. Its six
semantic targets pass `6/6` native and combined ASan/UBSan. This remains
CPU/contract evidence; a fresh current-tip link and trace are required before
any live V4 callback or Metal claim. See [V4 texture-map evidence](evidence/GX-V4-TEXTURE-MAP-ALIAS-83FE50C-2026-08-13.md).
The integrated `46a8ae5` continuation then permits live alpha-test, depth, and
cull state through V4 while retaining a strict color-write gate and the
strict V1/V2/V3 predicate. Its six-target native and combined ASan/UBSan
matrices pass `6/6` each. The Apple packet still leaves those raster fields
unencoded, so this is a CPU/contract result and not live callback, Metal,
pixel, or playability proof. See [V4 unrendered raster evidence](evidence/GX-V4-UNRENDERED-RASTER-46A8AE5-2026-08-13.md).
One serialized current-tip `28ebac2` link reached `[4018/4019]`, and one
bounded LLDB launch reached the game-owned graph/GX path. The V4 builder entry
counted `558` attempts, but the typed V4 Apple consumer, prepare path, and
`pc_metal_runtime_observe` each remained at `0`. This confirms a live
builder-rejection boundary only; it does not establish a callback, Metal
encode/present/readback, pixel, or playability gate. See [current V4 runtime
evidence](evidence/CURRENT-V4-LIVE-CONSUMER-RUNTIME-28EBAC2-2026-08-13.md).
The preceding diagnostic run at `fbb286d` reached live graph/GX work and
emitted 64 bounded `reason=global_state` records; the V4 consumer, prepare
path, and `pc_metal_runtime_observe` remained `0`. See [V4 rejection trace
evidence](evidence/CURRENT-V4-REJECTION-TRACE-FBB286D-2026-08-13.md). The
serialized link and LLDB launch at `46a8ae5` then reached `[LOGO]`/`[NEOS_OUT]`
and 542 V4 builder attempts, but the V4 consumer, prepare path, and runtime
observer remained `0`; the diagnostic's 64 records still used the old
`global_state` label. The first correction (`adaddfd`) left a duplicated helper
check; follow-up commit `a53b192` now aligns the classifier with the relaxed
predicate, and the follow-up trace below localizes the repeated game-owned
path to the channel predicate.
This remains link/boot/GX evidence only. See [current V4 unrendered-raster
runtime evidence](evidence/CURRENT-V4-UNRENDERED-RASTER-RUNTIME-46A8AE5-2026-08-13.md)
and [the diagnostic handoffs](evidence/GX-V4-REJECTION-DIAGNOSTIC-ADADDFD-2026-08-13.md)
and [the corrected classifier](evidence/GX-V4-REJECTION-DIAGNOSTIC-A53B192-2026-08-13.md).
The resulting `a53b192` current-tip trace reached `[LOGO]`/`[NEOS_OUT]` and
601 GX flushes; 33 repeated live records now classify as `channel`, while the
V4 consumer, prepare path, and runtime observer remained `0`. The remaining
31 capped records are heterogeneous global/setup states. This remains
link/boot/GX evidence only; the next gate is a remote CPU/contract channel
crosswalk and fixture. See [the current runtime evidence](evidence/CURRENT-V4-REJECTION-RUNTIME-A53B192-2026-08-13.md).
The current-tip sanitizer/Windows verification on `f18e7cd` passes the seven
focused native targets (`7/7`) and the combined ASan/UBSan matrix (`7/7`) with
no diagnostics. Available `_WIN32`/`-m32` C and static-GBI probes pass, while
the C++ host probe retains an artificial Apple-libc++ locale-macro caveat;
`pc_gx.c` stops at missing `process.h`, and real i686 GNU/MSVC probes stop at
missing `string.h` and the absent sysroot/toolchain. No PE/runtime or Windows
sign-off follows, and no full-link, game-owned callback, Metal, pixel, or
playability claim follows. See [current sanitizer/Windows evidence](evidence/SANITIZER-WINDOWS-CURRENT-F18E7CD-2026-08-13.md).
One current-tip `f18e7cd` link reached `[4018/4019]`, and one unprivileged
LLDB launch created a real inferior and reached boot, graph, and repeated
GX/V3 builder work. The live counts were graph/emu64 `29`, GX/flush `532`,
V2/V3 builder `531` each, with the V3 Apple consumer and
`pc_metal_runtime_observe` at `0`. The opt-in diagnostic captured its hard cap
of `64/64` `alpha_update_disabled` records. This closes the source/fixture-to-
live rejection boundary only; no successful callback, Metal encode/present/
readback, pixel, natural-shutdown, or playability claim follows. See [current
V3 rejection runtime evidence](evidence/CURRENT-V3-REJECTION-RUNTIME-F18E7CD-2026-08-13.md).
The DVD/CARD,
input snapshot, graph-capture, GX packet, Metal fixture, and audio boundary
commits reviewed in the same source history remain the current evidence, and
the runtime now moves past the
prior DVD wait. The portable boot-source facade accepts only exact
`GAFE01_00`, requires
one `foresta.rel.szs`, and prepares bounded DOL and REL images without writing
them to tracked storage. Native and sanitizer portable tests (`13/13`), the
new SDL/CoreAudio device-and-ring probe, the CARD temporary-directory roundtrip
test, native-width PC ARAM transport, real nested `emu64` display-list
traversal, boot-source-backed approved-disc proof, headless host preparation,
native and sanitizer host tests (`4/4`), and a foreground AppKit process that
completes two geometry-bearing command buffers are reproducible. The audio
probe proves 32 kHz S16 stereo callback cadence with zero underruns/overruns;
it does not prove audible game-mixer correctness. The CARD temporary-directory
probe proves bounded host transfers. The production CARD recovery fixture now
validates Save_t identity/checksum, embedded-backup selection, atomic restart
reload, and prior-generation `.bak1` fallback. A focused follow-up routes one
generation through the existing game-owned `mCD_SaveHome_bg` request boundary
and verifies process-restart reload; full game-level save-manager orchestration
remains a separate gate.

The host invokes the same facade and reports the real DOL and Yaz0 REL
preparation before disposing the buffers. This is preflight and command-buffer
evidence without pixel readback: the host fixture remains separate from the
actual game launch, which reaches `initial_menu_init`, `dvderr_init`,
`sound_initial2`, and `[NEOS_OUT]` during bounded runs. The focused DVD-tail,
graph, texture, audio-bank, and LP64 cleanup fixes now let an integrated arm64
run decode bank 28 and reach `[LOGO] draw`. Its historical captured screen at
`/private/tmp/acgc-integrated-audio-wave-build/integrated-frame-screen.png`
contains the Animal Crossing window, character, and `© 2001, 2002 Nintendo`
(SHA-256
`ce1a124b15d07d7f81edb7ad1ef1548832c7d5bbff21bd46a59de533996129b6`). This
passes the identifiable game-frame gate for that historical snapshot. The
current `09dd182` run reaches `[LOGO]` action 3 and `[NEOS_OUT]` frame 541,
then returns status `0` after TERM within the two-second grace period, closing
the reproduced post-GX invalid-free boundary. Neither run proves stable
playability, Metal pixel readback, input, audible audio, or save/reload.

The full PC runtime remains behind its default ILP32 guard; the opt-in Darwin
audit and native arm64 link are diagnostic milestones, not a claim of complete
runtime portability. The fail-closed static GBI pointer guard remains enabled.
Representative GX rendering through the Apple renderer, running-game input,
game-mixer audio output, full game-level Save_t/GCI orchestration, iOS Simulator, and
physical-device gates remain open. Source `5086f1d` now crosses the former bad
`GRAPH_SET_DOING_POINT(..., GAME_BGM)` destination at `game.c:154` and reaches
the first `graph_task_set00` call. Source `10d6ac0` captures the first live
game-owned prefix (version 1, frame 0, capacity 256, count 8, words
`de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000`).
The Save_t wire fixture now makes the pre-d1575f0 `0xF10E` loss explicit while
the current production codec preserves those bytes through restart and
checksum. The bounded graph contract now classifies the observed eight-word capture as
prefix-only and refuses to submit it as a complete list. The optional GX-to-
Metal handoff and Apple packet/state fixtures pass their CPU contracts, while
device tests skip with `77` on this host because no Metal device is available.
The current-tip post-link trace at `02a003e` reaches boot, `graph_proc`, and the
enabled capture callback, but still records only an `8/256` root classified
`INDIRECT`; it does not resolve the opaque target. A subsequent bounded activation run with `ACGC_GRAPH_CAPTURE=1`
confirms the hook is enabled and emits one cleanly terminated `8/256`
game-owned prefix, but still does not resolve the `F0002000` indirect target
or establish a terminator. The integrated `aea3515` resolver now proves the real
`emu64::dl_G_DL` path can
resolve the live `F0002000` capability to the bounded `new0` span and exact
terminator, with native and ASan/UBSan focused tests passing `3/3` each. This is
still fixture evidence; the next critical gate is an actual current-tip runtime
trace that captures the target in the game process, then binds a complete
game-owned submission to Metal encode,
present, and pixel-readback evidence; the identifiable game-frame pass does
not imply input, audio, save/load, or playability.
The reference audit confirms that `DE010000 F0002000` branches from the
bounded `sys_dynamic.work` root into the separate `sys_dynamic.new0` arena;
the F-handle is a live PC registry capability, so flat-copying the 256-word
root cannot resolve it. A successor may resolve only a retained target identity
with explicit capacity and the exact `DF000000,0` terminator, failing closed
otherwise; see [GBI indirect-target evidence](evidence/GBI-INDIRECT-TARGET-AUDIT-2026-08-13.md).
The game-owned save audit separately identifies the restart NPC
`aNRST_save` → `mCD_SaveHome_bg(0, ...)` path as the smallest real persistence
gate; the host recovery fixture primes `Save_t` directly and cannot substitute
for a caller-driven save/restart/reload proof. See
[game Save_t/CARD caller evidence](evidence/GAME-SAVE-CALLER-AUDIT-2026-08-13.md).
The caller-driven successor is integrated at PC source `02a003e`: production
`aNRST_save` → `mCD_SaveHome_bg` writes a changed GCI marker and a fresh
fork/exec reload restores it; native and combined ASan/UBSan runs pass. This is
still a focused persistence gate, not device or playability proof; see
[game Save_t runtime evidence](evidence/GAME-SAVE-RUNTIME-GATE-2026-08-13.md).
The graph-target successor and live resolver are integrated at PC source
`aea3515`: the production `emu64::dl_G_DL` path retains only pointer-free
target identity/capacity, resolves the live `F0002000` capability to the
bounded 1024-word `new0` span, and requires `DF000000,0`, with native and
ASan/UBSan focused tests passing `3/3` each. This remains source/fixture
evidence, not live complete-list, GX/Metal, pixel, or playability evidence;
see [graph indirect-target contract](evidence/GRAPH-INDIRECT-TARGET-CONTRACT-2026-08-13.md)
and [live resolver evidence](evidence/LIVE-GRAPH-TARGET-RESOLVER-2026-08-13.md).
One serialized current-tip runtime attempt then completed the full
`4,013/4,013` arm64 link but launched LLDB from the delegated umbrella
worktree rather than the generated `bin` directory. Relative shader lookup
failed before graph boot, so the live target callback remains unobserved and no
retry or frame claim follows; see [current-tip runtime evidence](evidence/CURRENT-TIP-LIVE-TARGET-RUNTIME-2026-08-13.md).
The correctly rooted successor rebuilt the same source tip (`4,013/4,013`) but
its single LLDB command file used unsupported `target.process.working-dir`, so
LLDB stopped before `run`. This is a debugger-command blocker rather than game
runtime evidence; no inferior, graph target, or frame claim follows. A future
successor must syntax-check the local LLDB settings surface first; see
[corrected-root runtime evidence](evidence/CORRECT-ROOTED-RUNTIME-2026-08-13.md).
The syntax-checked successor then reached the live game path through
`graph_proc`, `graph_task_set00`, the `F0002000` target call (`capacity=1024`),
`GXBegin`, and `pc_gx_flush_vertices`, with logo rendering before TERM. No
exact `DF000000,00000000` terminator appeared in the observed target extent, so
this is live target/GX-boundary evidence only; complete-list, Metal, pixel,
and playability gates remain open. See [valid-LLDB live-target runtime
evidence](evidence/VALID-LLDB-LIVE-TARGET-RUNTIME-2026-08-13.md).
The subsequent read-only forensic crosswalk shows that the live `F0002000`
target is `new0[0]` with capacity `1024`, but `new0` is a continuation arena
whose bytes branch to `F0002001`; the fixture’s word-10 terminator is synthetic,
and the live target callback is not installed by the root capture path. The
next implementation gate is a bounded opt-in observer that follows child
arenas under registry-lifetime and cycle/span limits; see [live-target
terminator forensic evidence](evidence/LIVE-TARGET-TERMINATOR-FORENSIC-2026-08-13.md).
That observer is now integrated at PC source `36910c8`: the existing Apple
`ACGC_GRAPH_CAPTURE` gate installs the pointer-free target callback beside the
root callback, while Windows/default behavior remains unchanged. The integrated
host object compile and the bounded live-target fixture pass natively and under
combined ASan/UBSan (`1/1` each). This is still source/fixture evidence; a fresh
serialized full link and LLDB launch are required before claiming a live target
record, complete continuation, Metal output, pixels, or playability. See
[opt-in live target observer evidence](evidence/LIVE-TARGET-OBSERVER-2026-08-13.md).
One fresh correctly rooted runtime at the integrated source then emitted the
new game-owned target record for `F0002000`: capacity `1024`, classification
`INDIRECT`, no local terminator, and bounded words containing `F0002001`. The
run reached LOGO action 3 and NEOS before the planned TERM/grace boundary. Its
full link exited `0` with a terminal `[4012/4013]` progress line rather than a
literal `[4013/4013]` line; GX was not instrumented and remains unobserved.
This closes the target-observer reachability gate only. Complete continuation,
GX/Metal, pixel, input, audio, save/load, device, clean-exit, and playability
gates remain open; see [live target observer runtime evidence](evidence/LIVE-TARGET-OBSERVER-RUNTIME-2026-08-13.md).
The subsequent bounded GX-boundary attempt built that same source once and
verified both `GXBegin` and `pc_gx_flush_vertices` in LLDB before `run`, but
failed before inferior creation with `status -1` and
`nice(5) failed: operation not permitted`. It made no retry and adds no boot,
breakpoint, GX, Metal, pixel, or playability proof. See [live GX-boundary
runtime evidence](evidence/LIVE-GX-BOUNDARY-RUNTIME-2026-08-13.md).
The direct no-`nice` successor then proved both game-owned GX submission
boundaries: `GXBegin` and `pc_gx_flush_vertices` were reached through
`emu64::dl_G_TRIN` and `graph_task_set00` after the `F0002000`/`F0002001`
target capture. This is still an OpenGL/GX boundary, not Metal encode/present,
pixel readback, input, audio, save/reload, clean shutdown, or playability
proof. The integrated PC source `f4cb491` now registers the existing Apple CPU
packet consumer from the production `ac_pc` lifecycle, reports bounded
handoff/status counters, and keeps OpenGL unconditional. Its resident-texture
gate correction remains fail-closed for active texture/TEV/lighting/fog state.
Focused Darwin and ASan/UBSan tests pass, but this still does not prove a live
game callback, Metal encode/present, pixels, input, audio, save/reload,
device, clean shutdown, or playability. See [Darwin GX handoff registration
evidence](evidence/DARWIN-GX-HANDOFF-REGISTRATION-2026-08-13.md). The integrated
`54b840c` sink adds a value-only offscreen Metal consumer with synchronous
completion/readback logic and bounded status counters; its CPU contract and
Apple object compile pass, while the device test skips `77` because this host
has no Metal device. This remains implementation/device-gate evidence, not
live game callback, pixel, or playability proof. See [offscreen Metal sink
evidence](evidence/OFFSCREEN-METAL-SINK-2026-08-13.md). The first
delegated callback attempt linked the current source but hit the environment's
pre-inferior `nice(5)` permission boundary; see [delegated live Darwin GX
callback runtime evidence](evidence/LIVE-DARWIN-GX-CALLBACK-RUNTIME-2026-08-13.md).
A subsequent root-owned elevated launch created an inferior, reached
`graph_proc`/NEOS and `pc_gx_flush_vertices`, and returned through `graph_proc`
with exit status `0` after bounded SIGTERM. Because the interactive transcript
did not retain per-breakpoint hit counts, callback registration remains
unclaimed; Metal encoding, presentation, pixels, input, audio, save/reload,
device, and playability remain separate open gates. See [root-owned live launch
evidence](evidence/ROOT-LIVE-LAUNCH-2026-08-13.md).
The bounded GX v2 packet builder/validator is integrated at `26da235`, and
the version-aware consumer boundary is integrated at `d1e812c`. The consumer
keeps v1 dispatch separate, validates v2, and reports
`V2_EXTENSION_NOT_RENDERED`; focused native and ASan/UBSan tests pass `4/4`
each. A single current-tip `d1e812c` runtime attempt then linked `4019/4019`,
but its only LLDB launch failed before creating an inferior with status `-1`
(`no such process`) and every graph/GX/v2/Apple breakpoint was zero-hit. The
v2 callback remains unverified, and no frame, Metal encode/readback/pixel,
input, audio, save/device, simulator/device, or playability claim follows;
see [GX v2 consumer evidence](evidence/GX-V2-CONSUMER-BOUNDARY-2026-08-13.md)
and [live GX v2 callback reachability evidence](evidence/LIVE-GX-V2-CALLBACK-REACHABILITY-2026-08-13.md).
One permitted elevated retry resolved the pre-inferior launch blocker and
created a real arm64 game inferior that reached boot/runtime. The bounded
interrupt occurred before LLDB emitted its per-symbol breakpoint list, so no
callback/GX/frame hit is inferred; TERM to the exact PID returned `0`, and no
KILL was needed. This is launch/runtime evidence only, not callback, Metal,
pixel, input, audio, save/device, clean-shutdown, simulator/device, or
playability proof; see [elevated GX v2 launch evidence](evidence/ELEVATED-GX-V2-LAUNCH-2026-08-13.md).
The durable-count retry kept LLDB alive through its final breakpoint list and
recorded `graph_task_set00=1`, but its temporary Python callback omitted an
explicit return, so downstream counts remained zero at the prefix stop. No
downstream callback, GX, frame, Metal, pixel, input, audio, save/device,
simulator/device, clean-shutdown, or playability claim follows; see [durable
GX v2 breakpoint evidence](evidence/DURABLE-GX-V2-BREAKPOINT-COUNTS-2026-08-13.md).
The corrected trace-control retry explicitly returned `False` from every
Python breakpoint callback. It recorded `graph_task_set00=1` and
`emu64_taskstart=1`, then stopped at a debugger-owned return sentinel;
`GXBegin`, `pc_gx_flush_vertices`, the v2 handoff, Apple consumer, and runtime
observer were all `0`. This closes the LLDB-control blocker but leaves the
game-to-GX submission boundary open; see [corrected GX v2 trace evidence](evidence/CORRECTED-GX-V2-CALLBACK-TRACE-2026-08-13.md).
The follow-up two-upstream crosswalk confirms that `graph_submit_task` selects
one synchronous callback/fallback and `G_DL_NOPUSH` traverses inline, so no
missing task queue is indicated. One serialized command/continuation trace is
still needed to distinguish no-draw `G_ENDDL`, target/command validation,
cancellation, and early sentinel timing; see [graph-task to GX gap evidence](evidence/GRAPH-TASK-TO-GX-GAP-2026-08-13.md).
That trace now shows the first live graph task traversing eight inline
`G_DL_NOPUSH` continuations to a clean `G_ENDDL` with return `0`, no `GXBegin`,
and no error/cancellation. Misaligned pointer-field diagnostics are excluded;
the result is no-draw interpreter evidence, not a frame or Metal proof. See
[emu64 continuation evidence](evidence/EMU64-CONTINUATION-NO-DRAW-2026-08-13.md).
A subsequent bounded trace confirms a second graph submission and interpreter
entry. Lane 97's observed prefix contained only `G_DL_NOPUSH`/`G_MOVEWORD`
continuation commands before exact-PID timeout; its second-task completion was
unproven at that snapshot. Lane 98's one longer trace then records eight task-2
`G_DL` handlers, `G_ENDDL`, and a clean return (`return_err=0`, `cmds=12`,
`end_dl=1`) with no task-2 draw handler, `GXBegin`, or flush. Later-task draw/GX
hits are excluded from the task-2 claim. See [subsequent graph-task evidence](evidence/SUBSEQUENT-GRAPH-TASK-PROGRESSION-2026-08-13.md)
and [second graph-task completion evidence](evidence/SECOND-GRAPH-TASK-COMPLETION-2026-08-13.md).
