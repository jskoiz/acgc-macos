# Animal Crossing Modern Port Workspace

This umbrella repository keeps the two upstream histories separate while
recording the evidence and cross-repository plan for a modern Apple port.
Current work targets macOS first; iOS begins only after the shared 64-bit core
and Apple renderer have their own evidence.

## Layout

- `upstream/ACGC-PC-Port` - the existing PC port codebase.
- `upstream/ac-decomp` - the matching decompilation project.
- `local/roms` - local game-disc input. Its contents are ignored by Git.
- `script/build_and_run.sh` - the single native macOS build/run/verify entrypoint.
- `script/build_and_run_game.sh` - the actual reconstructed `ac_pc` arm64 build/run/verify entrypoint.
- `scripts` - reproducible, non-distributing bootstrap checks.
- `docs` - source audit, measured portability risks, architecture, and gates.

The ISO is local development input only. Do not commit, publish, upload, or
redistribute it or extracted proprietary assets.

## Lane execution placement

Serialized full links and LLDB launches run locally from the canonical
populated checkout. Focused source, test, and audit lanes run on the configured
remote M3 Max host through the verified Codex CLI path, each with its own
isolated worktree and ignored build/log roots. Full
`ac_pc` links and LLDB launches remain one serialized gate across both hosts;
the integration owner records the queue and exact provenance in
`docs/LANE-BOARD.md`. True cloud tasks are reserved for non-build planning or
review. The ISO, extracted assets, keys, and proprietary game data never leave
the local machine. See [the remote focused-lane setup checklist](docs/REMOTE-LANE-SETUP.md)
for the current saved-project prerequisite and handoff sequence.

## Current evidence

The current local integration snapshot is `upstream/ACGC-PC-Port` branch
`c1/macos-host-launch` at `689590cc` (`Enforce raw Geometry snapshot domains`),
adding the independently reviewed canonical Geometry leaf producer on top of
reviewed setter-owned raw Geometry closure, typed indexed host mirroring,
packed-color FIFO-width provenance, and RGBX8 ignored-byte handling on top of
setter-owned raw Raster provenance, the source-faithful half-pixel jitter
adjustment, and the strict pointer-free Indirect value contract,
setter-owned Alpha/ZCompLoc provenance, production-object availability, the
strict pointer-free Raster value contract, and
persistent setter-owned raw Channels and Lighting,
immutable raw Geometry batches, the pointer-free raw Texture/TLUT owner and
synchronous resource lease, the reviewed neutral Texture/TLUT, Dynamic,
Lighting, and Channels ABIs, Depth ordering, raw
Texgen/SU, and canonical Geometry chains on top of `251a010b8` (`Preserve typed
GX depth setter ABI`),
`eeec2301c1` (`Track PC raw GX depth provenance`), and `c3e158398`
(`Add canonical Transform ABI validator`), `59714a1fd` (`Repair indexed
Transform shadow slots`), `4c3aeac40` (`Add PC raw Transform shadow`), `c736f9686`
(`Add canonical GX Depth ABI validator`), `6d1d310c0` (`Add canonical GX TEV
value ABI`), `037689462` (`Add PC raw TEV register shadow`), `f2b7ab153`
(`Add canonical Alpha test/update state`), `216d1e24b`
(`Add canonical Blend logic state`), `4dbb71065`
(`Add strict canonical GX envelope validator`), and
`62ef6638d` (`Fail closed legacy V4 Apple sink eligibility`),
`b5f550ea0` (`Add canonical GX fog state`),
`afb1cac3c` (`Restore analog trigger digital parity`), `5157ac1cb` (`Reject
incomplete V2 packets before Metal sink`), and `820906439` (`Normalize dead V2
alpha references`),
on top of the `59d13a98` rejection classifier, the `c973dbee` grouped-triangle handoff, the `565f877e`
channel-source contract, lane-132 source record `80e80df`, Apple V2 texture
sideband `3c08c7f`, and reviewed remote binder `08998d0`. The new bounded
classifier preserves the original V2 acceptance predicate and names the first
fail-closed reason without printing addresses. Native and combined ASan/UBSan
focused CTest pass `2/2` each on the exact integrated snapshot. The subsequent
single current-tip runtime falsified the source-only `blend` prediction: its
first capped live reason is `alpha_test` with `GX_ALWAYS/GX_ALWAYS` and
nonzero reference bytes, followed by a distinct `global_count` cohort. No live
packet, callback, Metal
encode/readback, pixel, device, or playability claim follows. See
[V2 rejection-classifier evidence](docs/evidence/V2-BASE-REJECTION-CLASSIFIER-59D13A98-2026-08-14.md),
[current V2 rejection runtime evidence](docs/evidence/CURRENT-V2-REJECTION-RUNTIME-59D13A98-2026-08-14.md),
[alpha-reference semantics](docs/evidence/V2-ALPHA-REFERENCE-SEMANTICS-59D13A98-2026-08-14.md),
[fog/global-count crosswalk](docs/evidence/V2-GLOBAL-COUNT-FOG-CROSSWALK-59D13A98-2026-08-14.md),
[Apple V2 sink policy](docs/evidence/APPLE-V2-SINK-STATUS-POLICY-59D13A98-2026-08-14.md),
and the [lane board](docs/LANE-BOARD.md) for exact provenance.

- The integrated `820906439` correction is deliberately V2-local: references
  `8/144` no longer reject when both comparisons are `GX_ALWAYS` and the
  operator is `GX_AOP_AND`; active comparators and OR/XOR still fail closed,
  and the same live tuple advances to `blend`. Remote and exact integrated
  native plus combined ASan/UBSan focused CTest each pass `1/1`. This is CPU
  predicate evidence only, not a live packet, callback, Metal operation,
  pixel, or playability result. See
  [V2 alpha-reference normalization](docs/evidence/V2-ALPHA-REFERENCE-NORMALIZATION-820906439-2026-08-14.md).

- The `5157ac1cb` Apple guard first rejected V2/V3 and malformed status tuples.
  The integrated `62ef6638d` follow-up now also rejects bounded V4: only V1 is
  eligible for the current geometry-only sink until the cumulative canonical
  CPU plan exists. Remote and exact integrated native plus combined ASan/UBSan
  focused CTest each pass `1/1`; a production syntax compile also passes. This
  is CPU policy evidence, not a live callback, Metal operation, pixel, or
  playability result. See [Apple V2 sink guard](docs/evidence/APPLE-V2-SINK-GUARD-5157AC1CB-2026-08-14.md)
  and [legacy V4 sink guard](docs/evidence/APPLE-V4-SINK-GUARD-62EF6638D-2026-08-14.md).

- The read-only fog contract audit keeps V1-V4 unchanged and specifies an
  80-byte value-only fog section for the eventual cumulative canonical packet.
  V2 remains fail-closed for fog, and the borrowed texture/TLUT resource
  sideband remains separate. See
  [canonical fog-state contract](docs/evidence/CANONICAL-FOG-STATE-CONTRACT-59D13A98-2026-08-14.md).

- The integrated `b5f550ea0` implementation adds that standalone, pointer-free
  80-byte canonical fog value section and validator without changing V1-V4 or
  wiring `pc_gx`/Apple runtime. Exact integrated native and combined ASan/UBSan
  focused CTest pass `1/1` each. This is a CPU contract, not a live snapshot,
  callback, Metal operation, pixel, or frame. See
  [canonical fog implementation](docs/evidence/CANONICAL-FOG-STATE-B5F550EA0-2026-08-14.md).

- The read-only Apple canonical-consumer audit selected a cumulative value
  snapshot, owned resource sideband, immutable CPU plan, and separate
  device-gated encoder. Its V4 sink-safety finding is now closed by
  `62ef6638d`; V4 remains non-rendering because it omits live GX semantics. See
  [Apple canonical consumer audit](docs/evidence/APPLE-CANONICAL-CONSUMER-AUDIT-5157AC1CB-2026-08-14.md).

- The completed cumulative GX schema crosswalk rejects a V5 bridge and maps
  the two upstreams into a strict 14-section envelope. Integrated `4dbb71065`
  now supplies its fixed 48-byte header, ordered directory, dynamic aligned
  payload extent, and fail-closed metadata validator around the existing fog
  section. Exact integrated native and combined ASan/UBSan focused CTest pass
  `2/2` each. Total packet size, live producer, and Apple CPU plan remain open.
  A completed two-upstream audit fixes Blend/logic as the reusable 16-byte V3
  four-word value record and keeps Alpha/update and Raster state separate;
  integrated `216d1e24b` now implements that exact 16-byte section, a strict
  validator, and an exact Blend metadata helper without changing V1-V4,
  `pc_gx`, or Apple code. Exact integrated native and combined ASan/UBSan
  focused CTest pass `3/3` each. See
  [canonical GX schema crosswalk](docs/evidence/CANONICAL-GX-SCHEMA-CROSSWALK-5157AC1CB-2026-08-14.md),
  [canonical envelope evidence](docs/evidence/CANONICAL-GX-ENVELOPE-4DBB71065-2026-08-14.md),
  [Blend/logic contract](docs/evidence/CANONICAL-BLEND-LOGIC-CONTRACT-B5F550EA0-2026-08-14.md),
  and [Blend implementation evidence](docs/evidence/CANONICAL-BLEND-STATE-216D1E24B-2026-08-14.md).

- The read-only snapshot-producer audit selects the committed-vertex boundary
  at the top of `pc_gx_flush_vertices()`, before legacy handoffs, TEV variant
  selection, or OpenGL mutation. It also proves the producer must remain gated:
  raw projection, exact S10, fog-range, raster/depth, VCD/VAT, TEV-capacity,
  and owned texture/TLUT state are incomplete. See
  [snapshot producer audit](docs/evidence/CANONICAL-SNAPSHOT-PRODUCER-AUDIT-B5F550EA0-2026-08-14.md).

- The read-only Alpha/update audit freezes section `0x0100` as an exact
  32-byte, eight-word value contract for comparison/reference/operator,
  color/alpha update, and `z_comp_loc`. The PC port still drops
  `GXSetZCompLoc`, so a live producer must fail closed until that state is
  shadowed. See
  [canonical Alpha/update contract](docs/evidence/CANONICAL-ALPHA-UPDATE-CONTRACT-4DBB71065-2026-08-14.md).

- Integrated `f2b7ab153` implements that frozen Alpha/update ABI as a strict
  pointer-free 32-byte value section with exact metadata validation and
  inactive-reference preservation. Exact integrated native and combined
  ASan/UBSan canonical-state CTest pass `4/4` each. This is portable CPU
  contract evidence only: the PC `GXSetZCompLoc` no-op still blocks complete
  live producer provenance. See
  [canonical Alpha implementation](docs/evidence/CANONICAL-ALPHA-STATE-F2B7AB153-2026-08-14.md).

- The TEV audit freezes `0x0020` as a full 16-stage, 2560-byte value contract,
  independent of the current 3-stage shader and 2-stage legacy packet caps. See
  [canonical TEV contract](docs/evidence/CANONICAL-TEV-CONTRACT-4DBB71065-2026-08-14.md).

- Integrated `037689462` adds setter-owned exact raw PREV/REG0-2 and K0-3
  provenance beside the unchanged normalized-float path. Exact integrated
  native and combined ASan/UBSan focused CTest pass `1/1` each. See
  [PC raw TEV shadow](docs/evidence/PC-RAW-TEV-SHADOW-037689462-2026-08-14.md).

- Integrated `6d1d310c0` implements the portable 2,560-byte TEV ABI with
  strict layout, value, inactive-record, selector-hole, and metadata
  validation. Exact integrated native and combined ASan/UBSan canonical-state
  CTest pass `5/5` each. Compare-mode fields preserve logical setter arguments,
  not packed BP-register bits. The raw shadow and portable ABI remain CPU
  prerequisites; a cumulative producer has not joined them yet. See
  [canonical TEV implementation](docs/evidence/CANONICAL-TEV-STATE-6D1D310C0-2026-08-14.md).

- The Transforms/Texgens provenance audit found both sections fail-closed: the
  PC path lost raw pre-widescreen projection, matrix domain/type/knownness,
  texgen normalize/post state, and manual SU state. The Transform and raw
  Texgen/SU repairs are now integrated; the cumulative canonical producer is
  still open. See
  [Transforms/Texgens provenance](docs/evidence/CANONICAL-TRANSFORM-TEXGEN-PROVENANCE-216D1E24B-2026-08-14.md).

- The follow-up exact Transform audit freezes `0x0002` as a version-1,
  888-byte aggregate containing raw six-coefficient projection, ten position
  matrices, ten normal matrices, current logical ID, and explicit knownness.
  All texture/post matrices and manual SU state remain exclusively in
  `0x0008`. Integrated `59714a1fd` retains that setter-owned raw state,
  including exact per-slot unresolved indexed loads and finite immediate
  repair, while `c3e158398` implements the strict portable `0x0002` value ABI.
  Exact integrated native and combined ASan/UBSan canonical matrices pass
  `7/7`; the cumulative producer remains open. See the
  [canonical Transform contract](docs/evidence/CANONICAL-TRANSFORM-CONTRACT-216D1E24B-2026-08-14.md),
  [PC raw Transform shadow](docs/evidence/PC-RAW-TRANSFORM-SHADOW-59714A1FD-2026-08-14.md),
  and [canonical Transform implementation](docs/evidence/CANONICAL-TRANSFORM-STATE-C3E158398-2026-08-14.md).

- The corrected Texgen/SU contract freezes section `0x0008` as an exact
  `0xA40` value payload with eight generators, eleven ordinary matrices,
  twenty-one post matrices, eight SU records, writable selector `60`/`125`
  identity slots, per-word knownness, and raw manual-SU semantics. The
  corrected Geometry contract freezes section `0x0001` with a `0x6B0` fixed
  prefix, 26 exact descriptors, a section-relative bounded stream, and a
  `0x10000` inclusive size cap. The neutral Geometry worker chain is now
  independently reviewed and integrated as `910c7f6f52`. Raw Texgen/SU is
  independently reviewed and integrated through `1d48691a4f`; its exact
  integrated native and combined ASan/UBSan Transform/Depth/TEV/Texgen
  matrices pass `4/4` each, while the canonical matrix passes `8/8`. See the
  [Texgen/SU contract](docs/evidence/CANONICAL-TEXGEN-CONTRACT-6D1D310C0-2026-08-14.md),
  [Geometry contract](docs/evidence/CANONICAL-GEOMETRY-CONTRACT-6D1D310C0-2026-08-14.md),
  [Geometry implementation](docs/evidence/CANONICAL-GEOMETRY-STATE-910C7F6F5-2026-08-14.md),
  and [PC raw Texgen/SU shadow](docs/evidence/PC-RAW-TEXGEN-SU-SHADOW-1D48691A4-2026-08-14.md).

- The read-only Depth/Raster audit freezes `0x0200` as a 16-byte logical
  Z-mode section and `0x0400` as a 128-byte viewport/scissor/raster section.
  Integrated `c736f9686` implements the strict portable Depth ABI and exact
  present/absent envelope validation; the shared canonical native and combined
  ASan/UBSan matrix passes `6/6` in each configuration. Integrated
  `eeec2301c1`/`251a010b8` add setter-owned raw Depth provenance while
  preserving the typed `GXSetZMode` boundary. Integrated `9f149b6fd9` then
  repairs the temporal boundary so a completed old batch flushes before raw or
  effective Depth state changes; exact native and combined ASan/UBSan
  Transform/Depth/TEV/Texgen matrices pass `4/4`. Integrated `b3336504c`
  implements the strict 128-byte portable Raster ABI; the exact native and
  combined ASan/UBSan canonical matrices pass `13/13`. Raw Raster provenance
  and the cumulative producer remain open. See the
  [canonical Depth/Raster contracts](docs/evidence/CANONICAL-DEPTH-RASTER-CONTRACT-F2B7AB153-2026-08-14.md),
  [canonical Depth implementation](docs/evidence/CANONICAL-DEPTH-STATE-C736F9686-2026-08-14.md),
  [canonical Raster implementation](docs/evidence/CANONICAL-RASTER-STATE-B3336504C-2026-08-15.md),
  [PC raw Depth shadow](docs/evidence/PC-RAW-DEPTH-SHADOW-251A010B8-2026-08-14.md),
  and [Depth flush-order repair](docs/evidence/PC-DEPTH-FLUSH-ORDER-9F149B6FD-2026-08-14.md).

- Integrated `039afce0e` adds setter-owned Alpha compare, color/alpha update,
  and `GXSetZCompLoc` provenance, including completed-batch
  flush-before-mutation ordering and an all-known fail-closed conversion into
  the existing 32-byte canonical Alpha section. The production `ac_pc` target
  now compiles and links that builder, while a narrow production-object target
  keeps the focused gate independent of a full link. Exact native and combined
  ASan/UBSan focused CTest pass `2/2` each; no full link or runtime claim
  follows. See
  [PC raw Alpha/ZCompLoc evidence](docs/evidence/PC-RAW-ALPHA-ZCOMP-039AFCE0E-2026-08-15.md).

- The canonical setter-order audit fixes the future capture invariant at
  `pc_gx_flush_vertices`: a completed old batch must flush before any
  producer-visible raw/effective state mutation. The repaired Texgen/SU worker
  applies that rule to its seven setters; canonical `9f149b6fd9` now applies it
  to `GXSetZMode` as well. `GXEnableTexOffsets` remains Raster-owned. Raster,
  Indirect, and resource-generation ordering remain separate later owners. See
  [canonical setter-order evidence](docs/evidence/CANONICAL-SETTER-ORDER-251A010B8-2026-08-14.md).

- The Channels/Lighting audit freezes `0x0004` as a 136-byte paired channel
  section and `0x0040` as a 516-byte eight-slot final light-object section.
  Integrated `324c174ae3` implements Channels and `43992e7085` implements
  Lighting as strict pointer-free value ABIs with exact present/absent metadata
  validation; the neutral native and combined ASan/UBSan matrices pass `10/10`.
  Integrated `38343a5eb5` adds setter-owned raw Channels, including persistent
  inactive register state, partial RGBA knownness, sticky invalidity, and exact
  inactive canonical zeroing. Its exact canonical native and combined
  ASan/UBSan focused matrices pass `7/7`. Integrated `97aebd8a2d` then adds
  pointer-free eight-slot raw Lighting provenance, unresolved indexed-load
  tracking, immediate-load repair, and strict Channels dependency validation.
  Exact integrated native and combined ASan/UBSan matrices pass `9/9`, with
  both production objects compiling. The cross-section producer remains open.
  See the
  [canonical Channels/Lighting contracts](docs/evidence/CANONICAL-CHANNELS-LIGHTING-CONTRACT-037689462-2026-08-14.md),
  [canonical Channels implementation](docs/evidence/CANONICAL-CHANNELS-STATE-324C174AE-2026-08-14.md),
  [canonical Lighting implementation](docs/evidence/CANONICAL-LIGHTING-STATE-43992E708-2026-08-14.md),
  [raw Channels integration evidence](docs/evidence/PC-RAW-CHANNELS-38343A5EB-2026-08-14.md),
  and [raw Lighting integration evidence](docs/evidence/PC-RAW-LIGHTING-97AEBD8A2-2026-08-14.md).

- The Texture/TLUT/Dynamic audit freezes separate pointer-free `0x0010` and
  `0x2000` value contracts with stable logical IDs, owner epochs, per-resource
  generations, exact metadata, and an external synchronous lease for bytes.
  Integrated `a641e55efb` implements both neutral value ABIs, including exact
  minification `0..5` and decomp-effective magnification `0..1` domains; exact
  native and combined ASan/UBSan canonical matrices pass `12/12`. Integrated
  `698d45d3e` now adds the private raw map/TLUT owner, checked generations,
  exact tiled/mip/source metadata, converted-image provenance, canonical
  Texture/Dynamic conversion, and callback-scoped borrowed resources. Root
  review rejected the initial all-map TLUT invalidation and the repair now
  preserves unrelated non-indexed leases while invalidating only dependent
  indexed maps. Exact integrated native and combined ASan/UBSan focused
  matrices pass `7/7` each. Cumulative production and Apple consumption remain
  later gates. See the
  [canonical Texture/Dynamic contract](docs/evidence/CANONICAL-TEXTURE-DYNAMIC-CONTRACT-324C174AE-2026-08-14.md)
  [integrated implementation evidence](docs/evidence/CANONICAL-TEXTURE-DYNAMIC-A641E55EF-2026-08-14.md),
  [raw Texture/TLUT producer plan](docs/evidence/RAW-TEXTURE-TLUT-PRODUCER-PLAN-23C26E520-2026-08-14.md),
  and [raw Texture/TLUT integration evidence](docs/evidence/PC-RAW-TEXTURE-TLUT-698D45D3E-2026-08-15.md).

- Integrated `23c26e520a` now captures immutable Geometry
  VCD/VAT/array/completed-batch provenance at `pc_gx_flush_vertices`, including
  direct `GX_TEX_S` and exact INDEX8/INDEX16 entry-point width. Integrated
  `97aebd8a2d` supplies persistent raw Channels and Lighting dependencies, and
  integrated `698d45d3e` supplies Texture/TLUT generations and synchronous
  resource leases, `b3336504c` supplies the neutral Raster value ABI, and
  `039afce0e` supplies raw Alpha/ZCompLoc provenance, `a42da8e155`
  supplies the neutral Indirect ABI, `85b25cb3c` supplies setter-owned raw
  Raster provenance with source-faithful viewport jitter, `b9a9f355` closes
  the bounded setter-owned raw Geometry contract, and `689590cc` supplies the
  strict all-or-nothing canonical Geometry leaf producer. The copied batch now
  fail-closes unsupported matrix/NBT and extra attribute slots, preserves
  mutation/order/lifetime boundaries, decodes all supported indexed scalar
  forms into the host mirror, and preserves exact packed-color FIFO widths.
  The Geometry producer accepts only exact raw knownness/tail/source metadata,
  stages explicit little-endian output in caller-owned scratch, and publishes
  only after standalone and dependency validation. Raw Indirect conversion,
  the portable Texgen/SU section and remaining section leaf producers still
  gate the all-or-nothing cumulative serializer and immutable Apple CPU plan.
  Apple consumption follows only after those complete typed dependencies and
  stable resources. See the
  [raw Geometry integration evidence](docs/evidence/PC-RAW-GEOMETRY-BATCH-23C26E520-2026-08-14.md),
  [earlier canonical producer readiness audit](docs/evidence/CANONICAL-PRODUCER-READINESS-1D48691A4-2026-08-14.md),
  [current cumulative readiness reconciliation](docs/evidence/CURRENT-CUMULATIVE-PRODUCER-READINESS-698D45D3E-2026-08-15.md),
  [canonical Indirect contract](docs/evidence/CANONICAL-INDIRECT-CONTRACT-698D45D3E-2026-08-15.md),
  [canonical Indirect implementation](docs/evidence/CANONICAL-INDIRECT-STATE-A42DA8E15-2026-08-15.md),
  [raw Alpha/ZCompLoc evidence](docs/evidence/PC-RAW-ALPHA-ZCOMP-039AFCE0E-2026-08-15.md),
  [raw Raster evidence](docs/evidence/PC-RAW-RASTER-85B25CB3C-2026-08-15.md),
  [canonical Geometry producer evidence](docs/evidence/CANONICAL-GEOMETRY-PRODUCER-689590CC-2026-08-15.md),
  [current Geometry converter readiness audit](docs/evidence/CURRENT-GEOMETRY-CONVERTER-READINESS-039AFCE0E-2026-08-15.md),
  [raw Geometry closure evidence](docs/evidence/PC-RAW-GEOMETRY-CLOSURE-B9A9F355-2026-08-15.md),
  and [Apple canonical-plan readiness audit](docs/evidence/APPLE-CANONICAL-PLAN-READINESS-1D48691A4-2026-08-14.md).

- The exact `23c26e520a` focused baseline passes all twelve neutral validators
  and five setter-owned raw fixtures natively (`17/17`) and under combined
  ASan/UBSan (`17/17`, leak detection disabled). C/C++11 and bounded ILP32 and
  Windows-header probes pass, while a real i686 Windows build remains blocked
  by the absent compiler/sysroot/archive/link toolchain. This is CPU evidence,
  not a full link, Windows sign-off, Metal, pixel, or playability result. See
  [current focused matrix evidence](docs/evidence/CURRENT-FOCUSED-MATRIX-23C26E520-2026-08-14.md).
  The exact post-Channels tree at `38343a5eb5` separately passes the seven
  directly affected canonical/raw targets natively and under combined
  ASan/UBSan (`7/7` each, leak detection disabled). An independent full focused
  refresh at the same exact tree then passes all twelve neutral validators and
  six raw fixtures natively and under combined ASan/UBSan (`18/18` each,
  serial, leak detection disabled). Corrected C/C++11 and bounded ILP32/public
  Windows ABI probes pass; host SDL framework imports and missing private-PC
  headers/toolchains still block a real Windows build. See the
  [post-Channels focused matrix](docs/evidence/CURRENT-FOCUSED-MATRIX-38343A5EB-2026-08-14.md).

- The broad focused baseline at `b5f550ea0` passes native `44` with three
  declared Metal-device skips and combined ASan/UBSan `44` with the same three
  skips; bounded Windows host probes pass `4` and are environment/toolchain
  blocked at `5`. The exact post-envelope/sink delta at `4dbb71065` then passes
  native `3/3` and combined ASan/UBSan `3/3`. This is focused CPU/build
  evidence, not Metal-device, Windows-runtime, or playability proof. See
  [focused matrix evidence](docs/evidence/CURRENT-FOCUSED-MATRIX-B5F550EA0-2026-08-14.md).

- A current-tip verification-only run at `251a010b8` proves the existing
  synthetic Apple fixtures on an M3 Max: the selected native set passes `9/9`,
  the six CPU-compatible combined ASan/UBSan tests pass `6/6`, three embedded
  shaders compile offline, and the offscreen Metal sink completes deterministic
  pixel/checksum readback assertions. This closes the synthetic device-fixture
  question only. It is not a cumulative game snapshot, live game callback,
  game-owned encode, window present, game-owned pixel, or playability result.
  See [M3 Max Metal-device fixture evidence](docs/evidence/M3-METAL-DEVICE-FIXTURES-251A010B8-2026-08-14.md).

- The integrated `afb1cac3c` input correction makes axis-bound L/R digital
  state follow the same nonzero normalized analog value that reaches
  `PADStatus`, matching the decomp game-input boundary while preserving
  digital bindings and trigger scaling. Exact integrated native and combined
  ASan/UBSan focused CTest pass `1/1` each; zero, analog `88`,
  above-threshold, digital-binding, and repeated-read states pass. This is a
  virtual-controller CPU fixture, not physical-controller, running-game,
  device, or playability proof. See
  [input trigger parity](docs/evidence/INPUT-TRIGGER-PARITY-AFB1CAC3C-2026-08-14.md).

- The integrated `565f877e` CPU seam adds a fixed-width V2 validator and typed
  Apple consumer contract for decomp-compatible disabled `GX_SRC_REG` /
  `GX_SRC_VTX` channel state. Unsupported or malformed state still fails
  closed, V1 remains unchanged, and vertex-source V2 remains
  `V2_EXTENSION_NOT_RENDERED`. Native and combined ASan/UBSan focused CTest
  pass `3/3` each with no diagnostics. This is CPU/contract evidence only:
  no live callback, Metal encode/readback, pixel, device, or playability claim
  follows. See [V2 channel-source contract evidence](docs/evidence/V2-CHANNEL-SOURCE-CONTRACT-565F877E-2026-08-14.md).

- One serialized current-tip arm64 link and one logged-in GUI LLDB launch at
  `565f877e` reached GAFE01/COPYDATE, LOGO/NEOS, game-owned GX flush, and 509
  V2 builder attempts. The typed Apple consumer/provider/observer remained at
  zero hits. All 32 bounded rejected draw samples had more than three vertices;
  31 were valid triangle-list multiples and one was a quad, while the current
  V2 builder accepts exactly three vertices. This proves the next builder
  frontier, not a packet, Metal work, a pixel, or playability. See
  [current V2 channel runtime evidence](docs/evidence/CURRENT-V2-CHANNEL-RUNTIME-565F877E-2026-08-14.md).

- The integrated `c973dbee` source gate keeps direct single-triangle V2
  behavior, preflights every slice of an eligible grouped `GX_TRIANGLES` run,
  and invokes the existing callback once per three-vertex slice only after the
  whole batch passes. Quads, nonmultiples, unsupported state, and a failed late
  slice produce no partial V2 callback; V3/V4 fallback and legacy OpenGL remain.
  Native and combined ASan/UBSan focused CTest pass `2/2` each. This is
  CPU/contract evidence, not a live callback, Metal operation, pixel, or
  playability claim. See [V2 triangle-batch evidence](docs/evidence/V2-TRIANGLE-BATCH-HANDOFF-C973DBEE-2026-08-14.md).

- One serialized `c973dbee` arm64 link and GUI-session LLDB launch then reached
  GAFE01/COPYDATE, LOGO/NEOS through frame 901, game-owned graph/GX, and 213
  eligible grouped-triangle batch entries. Every batch reached its first
  exact-three internal builder call, but none passed the initial V2 base-state
  predicate or reached the Apple consumer/provider/observer. TERM returned
  through `graph_proc` with status 0 and no KILL fallback. This proves the live
  grouped path and its next fail-closed tier, not a packet, Metal work, a pixel,
  natural shutdown, or playability. See [current V2 triangle runtime evidence](docs/evidence/CURRENT-V2-TRIANGLE-RUNTIME-C973DBEE-2026-08-14.md).

- The integrated `59d13a98` follow-up adds an ordered diagnostic classifier for
  every current V2 base-state rejection tier while leaving the original
  acceptance predicate authoritative. The exact three-file change and its
  native plus combined ASan/UBSan `2/2` focused results are recorded in
  [V2 base-state rejection evidence](docs/evidence/V2-BASE-REJECTION-CLASSIFIER-59D13A98-2026-08-14.md).
  One serialized local link/trace then recorded 3,529 grouped/internal builder
  entries. Its 64 diagnostic records contain 18 paired `alpha_test` attempts
  followed by 14 paired `global_count` attempts; packet init/validation and all
  Apple consumer/provider/observer counts remain zero. The exact PID needed
  TERM and KILL after the supervisor missed LLDB's buffered launch line. This
  is live predicate evidence, not a callback, clean shutdown, Metal operation,
  pixel, or playability result. See [the current runtime evidence](docs/evidence/CURRENT-V2-REJECTION-RUNTIME-59D13A98-2026-08-14.md).

- Two read-only M3 Max audits closed the architecture question without source
  changes. The existing V1/V2/V3/V4 packets are not cumulative, so the planned
  end state is one deliberately named canonical value-only draw/state ABI plus
  a separate synchronous borrowed texture-resource sideband. The Apple audit
  also found a potential status-policy defect: ordinary V2 is source-reachable
  toward the geometry sink
  while still marked `V2_EXTENSION_NOT_RENDERED`, whereas provider-backed
  `CPU_RESOLVED` texture/TEV output is deliberately blocked. These are source
  reachability and contract decisions, not live callback or Metal proof. See
  [renderer contract consolidation](docs/evidence/RENDERER-CONTRACT-CONSOLIDATION-C973DBEE-2026-08-14.md)
  and [Apple sink reachability](docs/evidence/APPLE-SINK-REACHABILITY-C973DBEE-2026-08-14.md).

- Three follow-on read-only M3 Max crosswalks resolved the two live cohorts
  and the Apple policy ambiguity. Alpha refs are semantically dead only for
  `GX_ALWAYS/GX_ALWAYS` plus `GX_AOP_AND`, so a V2-local normalization is safe
  but the draw then fails at blend. The `global_count` cohort is valid
  two-texgen/two-TEV state rejected because `fog=2` is
  `GX_FOG_PERSP_LIN`, whose parameters are absent from V2. Separately,
  ordinary V2 marked `V2_EXTENSION_NOT_RENDERED` can reach the geometry-only
  sink and must fail closed. Lanes 149 and 150 now own those two disjoint
  source fixes; lane 151 owns the read-only cumulative fog contract. No full
  link, LLDB, Metal, pixel, or playability proof follows.

- The test-only follow-up at `2b141a753` adds focused coverage for the V2 null
  callback guard, non-triangle topology, ordinary emu64 blend state,
  decomp-compatible `GX_SRC_VTX` channel state, and the downstream texture
  provider remaining untouched when the builder rejects. The integrated target
  passes native `1/1` and combined ASan/UBSan `1/1` with no diagnostics. No
  production predicate changed; this is CPU/contract evidence only. See
  [V2 rejection fixture evidence](docs/evidence/V2-HANDOFF-REJECTION-FIXTURE-88724CDB-2026-08-14.md).

- The preceding V4 integration chain is `upstream/ACGC-PC-Port` branch
  `c1/macos-host-launch` at `a53b192` (`Align V4 rejection reason classifier`),
  on top of `adaddfd` (`Align V4 rejection diagnostics`), `46a8ae5`
  (`Allow V4 unrendered raster state`), `fbb286d`
  (`Trace V4 packet rejection reasons`), `83fe50c`
  (`Allow V4 texture map aliases`), and `28ebac2`
  (`Wire V4 alpha state to Metal consumer`),
  on top of `dbf6986` (`Add V4 Apple consumer validation gate`), `4fc6f00`
  (`Add GX V4 alpha-state packet builder`), `f18e7cd`
  (`Add V3 builder consumer fixture`), `add2d6f`
  (`Trace GX V3 rejection state`) and `042cbf7`
  (`Add bounded GX v3 state handoff`),
  on top of `d1e812c` (`Add versioned GX v2 consumer handoff`),
  on top of `26da235` (`Add bounded GX v2 semantic packet fixture`),
  `a8f3a8f` (`Rename reserved Metal shader local`),
  `59aa655` (`Test PC padmgr frame guard`) and `54b840c`
  (`Add bounded Apple Metal packet sink`),
  on top of `f4cb491` (`Register Apple GX packet consumer bridge`),
  on top of `aea3515` (`Capture live graph target spans in emu64`),
  on top of `9cf9b3f` (`Fix reserved identifiers in Metal fixture shaders`),
  `6e4aded` (bounded graph classification), `e22cbc5`
  (optional GX packet handoff), `a7b9dff` (`Exercise mCD_SaveHome_bg in CARD fixture`),
  `5548570` (`Validate GCI Save_t recovery slots`) and `09dd182`
  (`Fix LP64 field display-list cleanup`). The current
  source removes the guest-width `u32` round-trip from
  `mFM_MakeField`, adds a focused allocator/ownership fixture, and passes
  native, ASan/UBSan, and UBSan checks. An exact integrated 4,011-object
  arm64 `ac_pc` build passes; the resulting game reaches `[LOGO]` action 3
  and `[NEOS_OUT]` frame 541 for ten seconds and returns status `0` after
  TERM within the two-second grace period. This closes the previously
  reproduced post-GX invalid-free boundary, but it is not a Metal pixel,
  input, audible-audio, or playability claim. Production CARD/Save_t recovery
  now validates both embedded slots and the prior atomic `.bak1` generation;
  a focused follow-up routes one generation through `mCD_SaveHome_bg` and
  verifies process-restart reload, while full game save orchestration remains
  a separate gate. See
  [game-cleanup evidence](docs/evidence/GAME-CLEANUP-INVALID-FREE-2026-08-12.md)
  and [CARD recovery evidence](docs/evidence/CARD-SAVE-RECOVERY-2026-08-12.md)
  and [save-manager restart evidence](docs/evidence/SAVE-MANAGER-RESTART-2026-08-12.md)
  and [the lane board](docs/LANE-BOARD.md) for exact commands and ownership.
  The integrated input frame-guard fixture proves once-per-frame `PADRead`
  state preservation in native and ASan/UBSan focused runs; it is not
  OS/human input or playability proof. See [input frame-guard evidence](docs/evidence/INPUT-FRAME-GUARD-2026-08-13.md).
- The latest read-only Windows audit passes portable and `_WIN32`/ILP32 compile
  probes but remains blocked on a real i686 MinGW/sysroot. The iOS readiness
  audit passes the dependency-free portable slice (`20/20`) but found no iOS
  target, simulator/device proof, or game-owned Metal frame. See
  [Windows evidence](docs/evidence/WINDOWS-X86-AUDIT-2026-08-13.md) and
  [iOS boundary evidence](docs/evidence/IOS-SHARED-BOUNDARY-READINESS-2026-08-13.md).
- The current integrated runtime trace reaches the game-owned graph target and
  `GXBegin`, but the Apple sink shader fails compilation before encode/readback;
  `pc_gx_flush_vertices` and `pc_metal_runtime_observe` were not observed. See
  [current callback evidence](docs/evidence/CURRENT-INTEGRATED-METAL-CALLBACK-2026-08-13.md).
- The embedded Metal sink shader blocker is fixed at `a8f3a8f`: offline MSL
  compilation now succeeds, while the focused device-backed test remains skip
  `77` on this host. See [shader-fix evidence](docs/evidence/METAL-SINK-SHADER-FIX-2026-08-13.md).
- The exact post-fix runtime reaches graph target capture, `GXBegin`, and
  `pc_gx_flush_vertices`; `pc_metal_runtime_observe` remains unhit, so there
  is still no game-owned Metal encode/readback/pixel or playability proof. See
  [current post-fix runtime evidence](docs/evidence/CURRENT-METAL-SINK-RUNTIME-A8F3A8F-2026-08-13.md).
- The integrated binder tip `354f33884` links the full arm64 `ac_pc` target
  through `[4018/4019]`. The headless shell still reports no SDL displays, but
  a logged-in GUI Terminal launch opened the local GAFE01 disc, mounted
  COPYDATE/forest archives, reached NEOS/LOGO/`graph_proc`, and was stopped
  cleanly after the bounded window. One serialized LLDB trace counted
  `graph_task_set00=24`, `emu64_taskstart=24`, `GXBegin=509`,
  `pc_gx_flush_vertices=509`, and V2 builder entry `508`; the Apple V2
  consumer/provider/observer each remained `0`. This proves launch/boot/GX
  progression and the pre-consumer boundary only: no Metal encode/present,
  pixel, input, audible audio, save, device, or playability claim follows. See
  [current binder runtime evidence](docs/evidence/CURRENT-V2-TEXTURE-BINDER-RUNTIME-2026-08-14.md).
- The current-tip rejection follow-up is now recorded at PC `2b141a753`. One
  serialized link again reached `[4018/4019]`; a single GUI-session LLDB run
  reached real GAFE01 boot, COPYDATE/forest/Famicom loading, NEOS/LOGO, and
  `graph_task_set00`/GX activity. It logged 523 V2 builder entries and 64
  bounded diagnostic records (32 rejected preflight/result pairs), while the
  Apple V2 consumer, texture provider, and runtime observer remained `0`.
  This confirms the live builder-side rejection boundary only; it is not a
  Metal encode/present, pixel, input, audio, save, device, or playability
  claim. See [current V2 rejection runtime evidence](docs/evidence/CURRENT-V2-REJECTION-RUNTIME-2B141A753-2026-08-14.md).
- A focused observer-rejection audit proves the zero callback is the intended
  v1 fail-closed semantic-packet boundary: the game’s richer TEV/texture/channel
  state is rejected before `pc_metal_runtime_observe`, while supported synthetic
  triangles reach the callback. Native and ASan/UBSan focused tests pass; the
  next step is a deliberate packet-contract extension, not an unconditional
  callback. See [observer rejection evidence](docs/evidence/GX-OBSERVER-REJECTION-AUDIT-2026-08-13.md).
- The follow-up GX v2 map identifies the smallest safe next contract: bounded
  channel, texture-generator, two-stage TEV, texture/TLUT, sampler, and
  versioned-state fields with pointer-free handles. It remains a design map,
  not a renderer rewrite or live-frame proof. See [GX v2 packet map](docs/evidence/GX-V2-PACKET-CONTRACT-MAP-2026-08-13.md).
- The bounded GX v2 packet implementation is integrated at `26da235`. Its
  fixed-width builder, validator, and fail-closed CPU fixtures pass native and
  ASan/UBSan focused CTest `3/3` each. A follow-up at `d1e812c` adds a
  separately typed v2 consumer boundary, preserves v1 dispatch, and reports
  `V2_EXTENSION_NOT_RENDERED` rather than fabricating richer rendering state;
  its native and ASan/UBSan focused CTest runs pass `4/4` each. Neither lane
  proves a live game callback, Metal encode/readback/pixel, or playability.
  See [GX v2 implementation evidence](docs/evidence/GX-V2-PACKET-IMPLEMENTATION-2026-08-13.md)
  and [GX v2 consumer evidence](docs/evidence/GX-V2-CONSUMER-BOUNDARY-2026-08-13.md).
- The integrated V3 state-forwarding slice at `042cbf7` carries the observed
  blend/source-alpha/`GX_LO_NOOP` and `GX_TEXMTX0` state through a separate
  typed callback while preserving V1/OpenGL behavior. Native and ASan/UBSan
  focused V1/V2/V3 tests pass `3/3` in each matrix. V3 is explicitly marked
  `V3_EXTENSION_NOT_RENDERED` and is not submitted to the Metal sink; this is
  callback-contract evidence only, not live callback, Metal encode/readback,
  pixel, or playability proof. See [GX V3 state-handoff evidence](docs/evidence/GX-V3-STATE-HANDOFF-042CBF7-2026-08-13.md).
- A current-tip `042cbf7` `ac_pc` link completed as an arm64 Mach-O, and one
  permitted elevated bounded LLDB trace reached real GAFE01 boot, LOGO/NEOS,
  `GXBegin`, `pc_gx_flush_vertices`, and repeated V3 builder-entry attempts
  (`549`). The typed V3 Apple consumer and `pc_metal_runtime_observe` were
  both `0`; the V3 counts are entry attempts, not successful packet
  construction or callback acceptance. The preceding unprivileged launch
  failed before inferior creation with status `-1`. This advances the
  game-owned GX/V3 reachability boundary only; it is not a successful callback,
  Metal encode/readback, pixel, or playability claim. See [GX V3 current-tip
  runtime evidence](docs/evidence/GX-V3-CURRENT-TIP-RUNTIME-042CBF7-2026-08-13.md).
- The integrated `add2d6f` source snapshot proves the next fail-closed reason:
  `g_gx.alpha_update_enable == 0` rejects V3 before its typed callback, matching
  the decomp initializer's `GXSetAlphaUpdate(GX_FALSE)`. Its opt-in Darwin
  diagnostic is capped at 64 records and leaves Windows/default behavior
  unchanged. Native and ASan/UBSan focused handoff tests pass `3/3` each; this
  remains builder-rejection evidence only, with no live callback, Metal,
  pixel, or playability claim. See [V3 rejection evidence](docs/evidence/GX-V3-REJECTION-ALPHA-UPDATE-ADD2D6F-2026-08-13.md).
- The integrated `f18e7cd` fixture exercises that boundary end to end in a
  synthetic CPU path: disabled alpha writes reject before the V3 callback,
  enabled writes build a valid packet, the typed consumer reports
  `V3_EXTENSION_NOT_RENDERED`, malformed packets are rejected, and V1 remains
  separate. Native and ASan/UBSan focused CTest pass `2/2` each. This is not a
  live callback, Metal encode/readback, pixel, or playability claim. See [V3
  builder-consumer fixture evidence](docs/evidence/GX-V3-BUILDER-CONSUMER-FIXTURE-F18E7CD-2026-08-13.md).
- A current-tip verification matrix at `f18e7cd` passes the seven focused
  packet/adapter/V1/V2/V3 targets natively (`7/7`) and under combined
  ASan/UBSan (`7/7`) with no diagnostics. Available `_WIN32`/`-m32` C and
  static-GBI probes pass, while the C++ host probe retains its artificial
  Apple-libc++ locale-macro caveat; `pc_gx.c` stops at missing `process.h`, and
  real i686 GNU/MSVC probes stop at missing `string.h`/sysroot. No i686 PE,
  Windows runtime, full-link, Metal, pixel, or playability claim follows. See
  [current sanitizer/Windows evidence](docs/evidence/SANITIZER-WINDOWS-CURRENT-F18E7CD-2026-08-13.md).
- One current-tip `f18e7cd` link reached `[4018/4019]`, and one unprivileged
  LLDB launch created a real inferior and reached boot, graph, and repeated
  GX/V3 builder work. Counts were `graph_task_set00=29`,
  `emu64_taskstart=29`, `GXBegin=532`, `pc_gx_flush_vertices=532`, and V2/V3
  builder entries `531` each; the V3 Apple consumer and
  `pc_metal_runtime_observe` were `0`. The opt-in diagnostic captured its cap
  of `64/64` `alpha_update_disabled` records and no other predicate. This is
  live V3 builder-rejection evidence only: no successful callback, Metal
  encode/present/readback, pixel, natural shutdown, or playability claim.
  See [current V3 rejection runtime evidence](docs/evidence/CURRENT-V3-REJECTION-RUNTIME-F18E7CD-2026-08-13.md).
- The integrated `4fc6f00` CPU/contract slice adds a distinct 4972-byte V4
  semantic packet that preserves the 4968-byte V3 ABI and appends the
  reference-backed `alpha_update_enable` state. Native and combined
  ASan/UBSan focused CTest pass `5/5` each, with V1/V2/V3 fixtures still green
  and no sanitizer diagnostics. V4 accepts explicit alpha-write `0` or `1`
  and remains a builder/validator contract only; no Apple consumer, live
  callback, Metal encode/readback, pixel, or playability claim follows. See
  [V4 alpha-state evidence](docs/evidence/GX-V4-ALPHA-STATE-4FC6F00-2026-08-13.md).
- The integrated `dbf6986` Apple consumer seam validates the complete V4 packet,
  accepts alpha-write `0` and `1`, rejects malformed state masks/values, and
  marks V3/V4 state extensions `NOT_RENDERED`. Native and combined ASan/UBSan
  focused CTest pass `6/6` each with no sanitizer diagnostics. This is still
  CPU/contract evidence only: no live V4 callback, Metal encode/readback,
  pixel, or playability claim follows. See [V4 Apple consumer evidence](docs/evidence/GX-V4-APPLE-CONSUMER-DBF6986-2026-08-13.md).
- The integrated `28ebac2` continuation wires the V4 builder into a separate
  typed flush callback after V2/V3 fail, maps the supported blend factors and
  alpha-write mask, and keeps V3 texture-matrix state explicitly
  `NOT_RENDERED`. The six affected PC targets pass `6/6` native and `6/6`
  combined ASan/UBSan; direct Apple consumer/sink fixtures pass `2/2` in each
  matrix. This is CPU/contract and compile coverage only: no live V4 callback,
  Metal encode/present/readback, device, pixel, or playability claim follows.
  See [V4 live-consumer evidence](docs/evidence/GX-V4-LIVE-CONSUMER-28EBAC2-2026-08-13.md).
- The integrated `83fe50c` V4-only predicate keeps resolved texture safety
  checks but allows a valid non-indexed GX texture-map alias, matching the
  decomp's explicit `GXSetTevOrder` state while the Apple texture/TEV extension
  remains `NOT_RENDERED`. The six semantic targets pass `6/6` native and
  combined ASan/UBSan. This is CPU/contract evidence only; a fresh current-tip
  link and trace are still required before any live V4 callback claim. See
  [V4 texture-map evidence](docs/evidence/GX-V4-TEXTURE-MAP-ALIAS-83FE50C-2026-08-13.md).
- The integrated `46a8ae5` V4-only predicate now allows the live alpha-test,
  depth, and cull state that the current Apple packet leaves unencoded, while
  retaining a strict color-write gate and the strict V1/V2/V3 predicate. The
  canonical six-target native and combined ASan/UBSan matrices pass `6/6`
  each. This remains a CPU/contract slice; it is not live callback, Metal,
  pixel, or playability proof. See [V4 unrendered raster evidence](docs/evidence/GX-V4-UNRENDERED-RASTER-46A8AE5-2026-08-13.md).
- The preceding diagnostic run at `fbb286d` reached live graph/GX work and
  emitted 64 bounded `reason=global_state` records, all showing the live
  alpha/depth/cull state. Its V4 consumer, prepare path, and runtime observer
  stayed at `0`; this is rejection localization only. See [V4 rejection trace
  evidence](docs/evidence/CURRENT-V4-REJECTION-TRACE-FBB286D-2026-08-13.md).
- One current-tip `46a8ae5` link reached `[4018/4019]` and one explicit-return
  LLDB launch reached `[LOGO]`, `[NEOS_OUT]`, and repeated V4 builder entries
  (`542`), while the V4 consumer, prepare path, and runtime observer stayed at
  `0`. The trace emitted 64 `reason=global_state` records from the old
  classifier. The first correction (`adaddfd`) did not remove the helper's
  duplicated checks; follow-up commit `a53b192` now aligns the classifier with
  the relaxed predicate. That follow-up trace is recorded below and localizes
  the repeated game-owned path to `channel`. This remains link/boot/GX evidence
  only. See
  [current V4 unrendered-raster runtime evidence](docs/evidence/CURRENT-V4-UNRENDERED-RASTER-RUNTIME-46A8AE5-2026-08-13.md).
- The corrected current-tip `a53b192` link reached `[4018/4019]`, `[LOGO]`,
  `[NEOS_OUT]`, and 601 GX flushes. Its explicit-return trace recorded 33
  repeated `reason=channel` rejections for the live one-channel textured path;
  the V4 consumer, prepare path, and runtime observer remained `0`. The other
  31 capped records were heterogeneous global/setup states and are excluded
  from the game-owned classification. This remains link/boot/GX evidence only.
  See [current V4 rejection runtime evidence](docs/evidence/CURRENT-V4-REJECTION-RUNTIME-A53B192-2026-08-13.md).
- One serialized current-tip `28ebac2` arm64 link reached `[4018/4019]`, and
  one bounded LLDB launch reached the live game graph/GX path. The V4 builder
  entry was observed `558` times, while the typed V4 Apple consumer, its
  prepare path, and `pc_metal_runtime_observe` remained `0`. This is live
  builder-rejection evidence, not a successful callback, Metal encode/present,
  pixel, or playability claim. See [current V4 runtime evidence](docs/evidence/CURRENT-V4-LIVE-CONSUMER-RUNTIME-28EBAC2-2026-08-13.md).
- A single current-tip runtime trace from `d1e812c` linked `4019/4019`, but
  its one LLDB launch failed before creating an inferior with status `-1 (no
  such process)`; every requested graph/GX/v2/Apple breakpoint was zero-hit.
  Callback reachability therefore remains unverified, with no frame, Metal,
  pixel, or playability claim. See [live GX v2 callback reachability evidence](docs/evidence/LIVE-GX-V2-CALLBACK-REACHABILITY-2026-08-13.md).
- One permitted elevated retry resolved the pre-inferior launch blocker and
  created a real arm64 game inferior that reached boot/runtime. The bounded
  interrupt happened before LLDB emitted its per-symbol breakpoint list, so
  no callback/GX/frame hit is inferred; exact-PID TERM returned `0` and KILL
  was unnecessary. See [elevated GX v2 launch evidence](docs/evidence/ELEVATED-GX-V2-LAUNCH-2026-08-13.md).
- A durable-count retry kept LLDB alive through its final breakpoint list and
  recorded `graph_task_set00=1`; downstream counts were `0` only because the
  temporary Python callback omitted an explicit return and stopped at the
  prefix. No downstream callback, GX, frame, Metal, pixel, or playability
  claim follows. See [durable GX v2 breakpoint evidence](docs/evidence/DURABLE-GX-V2-BREAKPOINT-COUNTS-2026-08-13.md).
- The corrected trace-control retry explicitly returned `False` from every
  Python breakpoint callback. It recorded `graph_task_set00=1` and
  `emu64_taskstart=1`, then stopped at a debugger-owned return sentinel;
  `GXBegin`, `pc_gx_flush_vertices`, the v2 handoff, Apple consumer, and
  runtime observer were all `0`. This closes the LLDB-control blocker but
  leaves the game-to-GX submission boundary open. See [corrected GX v2 trace evidence](docs/evidence/CORRECTED-GX-V2-CALLBACK-TRACE-2026-08-13.md).
- A two-upstream graph-task crosswalk confirms `graph_submit_task` is a
  synchronous selector and `G_DL_NOPUSH` is inline traversal, not a missing
  task queue. The lane-94 zero-GX result therefore still needs one bounded
  command/continuation trace to distinguish a no-draw `G_ENDDL`, target or
  command validation failure, cancellation, and a sentinel that fired before
  later work. See [graph-task to GX gap evidence](docs/evidence/GRAPH-TASK-TO-GX-GAP-2026-08-13.md).
- The follow-up current-tip trace resolves that gate for the first graph task:
  one launch traverses eight inline `G_DL_NOPUSH` continuations, reaches a
  clean `G_ENDDL`, returns `0`, and records no `GXBegin` or error/cancellation.
  Pointer-sized diagnostic fields read with 32-bit offsets are excluded from
  the claim. This is no-draw interpreter evidence, not a frame or Metal result.
  See [emu64 continuation evidence](docs/evidence/EMU64-CONTINUATION-NO-DRAW-2026-08-13.md).
- A second bounded task trace confirms later graph progression: graph submission
  and `emu64_taskstart_r` each occur twice, while lane 97's second task reaches
  only the `G_DL_NOPUSH`/`G_MOVEWORD` prefix before its exact-PID timeout. See
  [subsequent graph-task evidence](docs/evidence/SUBSEQUENT-GRAPH-TASK-PROGRESSION-2026-08-13.md).
- A single longer lane-98 trace completes that second task's continuation:
  eight `G_DL` handlers reach `DE010000 F0004007`, then
  `DF000000 00000000` returns with `return_err=0`, `cmds=12`, and
  `end_dl=1`. Task 2 has zero draw handlers, `GXBegin`, and
  `pc_gx_flush_vertices`; later-task draw/GX hits are not attributed to it.
  The bounded run ends by exact-PID `SIGKILL` after 30 seconds, so no natural
  shutdown or playability claim follows. See [second graph-task completion
  evidence](docs/evidence/SECOND-GRAPH-TASK-COMPLETION-2026-08-13.md).
- Both submodules and the local input identify the supported `GAFE01_00`
  revision. The expected original DOL and REL hashes match.
- The documented `ac-decomp` macOS configuration and extraction path runs until
  the first Metrowerks compiler command, where the absent Wine runtime is the
  exact blocker.
- The complete PC runtime remains intentionally guarded as a 32-bit target. The
  reviewed portable foundation now includes fixed-width PC scalars and GX word
  records, checked native-address and arena free-space arithmetic, an opaque
  generational GBI reference registry, checked 64-bit CISO reads, bounded
  GCM/DOL/FST/REL parsing, typed LP64 DVD callers backed by an owner-keyed host
  side table, fixed-layout DVD/CARD wire probes, and width-correct `emu64`
  pointer resolution with stale-reference rejection. The public CARD leaf ABI
  and its owning implementations now use the existing fixed-width `s32`/`u32`
  and `CARDCallback` contracts instead of LP64 host `long`. A host-owned boot
  source facade now accepts only the exact eight-byte `GAFE01_00` revision,
  requires one `foresta.rel.szs`, enforces DOL/REL allocation ceilings, and
  prepares the DOL plus raw or Yaz0 REL entirely in memory.
- The portable targets pass native arm64 and ASan/UBSan CTest (`13/13`). The
  suite now includes fixed-width JKR stream contracts, a native-width PC MRAM
  to fixed-width ARAM transport round trip using real arm64 heap addresses,
  runtime-built source-local GBI lists, and repeated nested traversal through
  the real `emu64_taskstart` interpreter and registry-reset boundary. A
  tracked proof command drives the boot-source facade against the approved
  local disc, validates its exact revision and bounded DOL/FST/REL metadata,
  reproduces the expected decoded REL SHA-1, and removes all temporary output.
  C and C++ CARD ABI probes also compile natively and with explicit `-m32`
  syntax checks; a JSystem probe proves that its prefixed stream enums coexist
  with the ordinary stdio `SEEK_*` and `EOF` macros.
- The opt-in Darwin compile audit now also passes the source-local field
  culling, Haniwa palette, mailbox flag, and JKR native ARAM paths. Source
  commit `0c915d9` rebuilds both pointer-bearing mailbox variants immediately
  before submission and verifies their exact words, nested resolution, reset
  invalidation, and rebuild behavior. A fresh one-job audit advances through
  `ac_mailbox.c` at step `178/4021` and stops at `src/actor/ac_mbg.c:22` at
  step `179/4021`, where `gsSPVertex(&mbg_v[0], 8, 0)` reaches the same
  fail-closed `_GBI_STATIC_PTR` guard. A separate bounded keep-going inventory
  at the preceding `e64c1be` snapshot observed 500 static-GBI translation-unit
  failures (269 field, 229 model, and two actor files) plus three independent
  C/layout blockers. No pointer is truncated or replaced with a dummy value,
  and the default full-runtime ILP32 rejection remains intact.
- A native AppKit/Metal host now builds, routes its explicit read-only disc
  through the same bounded boot-source facade, accepts exact `GAFE01_00`, and
  reports the prepared 918,720-byte DOL and 6,137,393-to-15,640,056-byte Yaz0
  REL before disposing both buffers. It resolves scoped Application Support and
  cache paths, opens a normal foreground window, and exits 0 only after two
  requested Metal command buffers containing clear/triangle/present work
  complete. Native host CTest and its ASan/UBSan lane pass `4/4`. The triangle
  comes from a fixed-width, pointer-free geometry packet consumed by an
  Apple-owned Metal pipeline. This passes boot-source preflight, host launch,
  and a deterministic command-buffer-completed geometry fixture—not game
  execution, pixel readback, representative GX, or a reconstructed game frame.
  Input, audio, save/load, and playability remain open; iOS remains gated behind
  the shared macOS core and renderer.
- The last full arm64 `ac_pc` link before the offscreen Metal sink integration
  was from the owning `c1/macos-host-launch` source history at `aea3515`
  (`Capture live graph target spans in emu64`), on top of `02a003e` (`Add game-owned restart save/reload
  fixture`), `9cf9b3f` (`Fix reserved identifiers in Metal
  fixture shaders`), `6e4aded` (bounded graph
  classification), `e22cbc5` (optional GX packet handoff), `a7b9dff`
  (`Exercise mCD_SaveHome_bg in CARD fixture`), and `5548570` (`Validate GCI Save_t recovery slots`)
  and `09dd182` (`Fix LP64 field display-list
  cleanup`) and the DVD/CARD, input snapshot, graph-capture, GX
  packet, Metal-fixture, texture, and audio-boundary commits reviewed in the
  same source history. That fresh arm64 link produced a Mach-O
  `AnimalCrossing` executable. A later serialized lane-98 link from the
  current source tip `d1e812c` also returned `[4018/4019]` and produced an
  arm64 Mach-O; its bounded second-task runtime evidence is recorded
  separately. Its native audio command records remain 8 bytes,
  while TARGET_PC keeps high native pointers in a command-address side table;
  the compact bank-28 tail and MEDIUM_CART-to-native-ARAM mapping have focused
  wire fixtures, and native plus ASan/UBSan probes pass.
- The source branch now contains `e5442de` and `858d802` (injectable
  fixed-width input snapshots and the final PADRead handoff), `e03ffed`
  (pointer-free graph-submission capture), `83fa889` (4,800-byte
  renderer-neutral GX semantic packets), `866dd94` (Metal geometry/state
  fixtures), `ddbb498` (texture/TLUT/TEV fixtures), `766ad96`
  (mixer-to-callback PCM fixture), `5086f1d` (post-callback graph reload),
  `2736838` (RSP/Neos-style PCM provenance), `10d6ac0` (opt-in Darwin live
  graph capture before emu64 setup), `07a5447` (arm64 texture-pointer forensic
  fixture), `12b4f6e` (bounded GX packet-to-Metal consumer fixture), and
  `5974764`/`909f3ca` (compact audio-bank tails and native wave-address
  relocation) plus `304f055`/`724a18d` (LP64 audio-DMA address preservation),
  `1d1cd8f`/`6e4aded` (bounded complete-list graph classification), and
  `19d5f4e`/`26bcc02`/`e22cbc5`/`9cf9b3f` (optional GX-to-Metal handoff and
  host-compiler-safe Metal fixtures), and `315f040`/`d0e64f5` (test-only
  Save_t raw-wire loss forensic coverage).
  These remain separate boundaries: the first live game-owned prefix is
  captured; the identifiable screenshot belongs to the separately named
  `909f3ca` run; and the newer authoritative `09dd182` runtime reaches the
  logo/NEOS path and returns status `0` after TERM cleanup without a
  current-snapshot pixel/readback claim. Representative GX-to-Metal readback
  and playability are still open.
- The current-tip post-link LLDB trace from exact `02a003e` reaches real boot,
  `graph_proc`, and the enabled capture callback. It records the same `8/256`
  root `DE010000 F0002000 ...`, which is classified `INDIRECT`; no target list
  is resolved and no complete packet, Metal encode/present, pixel readback, or
  playability claim follows. See [exact-tip post-link graph runtime evidence](docs/evidence/POST-LINK-GRAPH-RUNTIME-02A003E-2026-08-13.md).
- A separate single-attempt activation run with the source-supported
  `ACGC_GRAPH_CAPTURE=1` switch proves the observer is enabled and emits one
  live game-owned record, but it is still only the deterministic `8/256`
  prefix `de010000,f0002000,...`. The child exits cleanly through the TERM
  grace path; no indirect target, complete terminator, GX/Metal encode,
  present, or pixel readback is established. See
  [graph-capture activation evidence](docs/evidence/GRAPH-CAPTURE-ACTIVATION-2026-08-13.md).
- The companion GBI audit resolves `DE010000 F0002000` as a `G_DL_NOPUSH`
  branch from `sys_dynamic.work` into the separate `sys_dynamic.new0` arena;
  the F-handle is a live PC registry capability, not a guest segmented pointer.
  The bounded 256-word root cannot contain the target, so a resolver must retain
  target identity/capacity while the registry is live and require
  `DF000000,0`, otherwise it must remain `INDIRECT`/`PREFIX_ONLY`. See
  [GBI indirect-target evidence](docs/evidence/GBI-INDIRECT-TARGET-AUDIT-2026-08-13.md).
- The exact-tip focused native plus ASan/UBSan refresh passes the GX callback,
  graph seam, Apple CPU contracts, and standalone Save_t codec/checksum/restart
  fixture: three passes and two declared Metal-device skips per matrix, with no
  sanitizer diagnostics. This remains fixture-only; see
  [the ac39d04 sanitizer evidence](docs/evidence/SANITIZER-REFRESH-AC39D04-2026-08-13.md).
- The graph-target contract and live resolver are integrated at PC source
  `aea3515`. The production `emu64::dl_G_DL` path resolves the opaque
  `F0002000` capability only while its registry is live, passes the bounded
  1024-word `new0` span to the pointer-free observer, and requires the exact
  `DF000000,0` terminator. Native and ASan/UBSan focused CTest each pass `3/3`,
  including the real traversal fixture and stale-handle failure. This remains
  source/fixture evidence, not live complete-list, GX/Metal, pixel, or frame
  proof. See [graph indirect-target evidence](docs/evidence/GRAPH-INDIRECT-TARGET-CONTRACT-2026-08-13.md)
  and [live resolver evidence](docs/evidence/LIVE-GRAPH-TARGET-RESOLVER-2026-08-13.md).
- A single current-tip runtime attempt at `aea3515` completed the full
  `4,013/4,013` arm64 link, but its one LLDB launch used the delegated umbrella
  worktree as the working directory instead of the generated `bin` directory.
  Relative shader lookup failed before graph boot, so no target callback or
  frame claim follows; the lane made no retry. See [current-tip runtime
  evidence](docs/evidence/CURRENT-TIP-LIVE-TARGET-RUNTIME-2026-08-13.md).
- The correctly rooted successor rebuilt `aea3515` successfully (`4,013/4,013`)
  but its one LLDB command file used unsupported `target.process.working-dir`,
  so LLDB stopped before `run`. This is a debugger-command blocker, not a game
  runtime result; no inferior, graph capture, target callback, or frame claim
  exists. See [the corrected-root runtime evidence](docs/evidence/CORRECT-ROOTED-RUNTIME-2026-08-13.md).
- The syntax-checked successor then completed one correctly rooted current-tip
  launch. It reached `graph_proc`, `graph_task_set00`, the live `F0002000`
  target call with capacity `1024`, `GXBegin`, and `pc_gx_flush_vertices`, and
  reached logo rendering before TERM. The observed target extent had no exact
  `DF000000,00000000` terminator, so the target callback emitted no complete
  classification and no complete-list, Metal, pixel, or playability claim
  follows. See [valid-LLDB live-target runtime evidence](docs/evidence/VALID-LLDB-LIVE-TARGET-RUNTIME-2026-08-13.md).
- A read-only forensic crosswalk explains the missing live terminator: the
  `F0002000` target is `new0[0]` with the full 1,024-word arena, but live `new0`
  is a continuation segment whose local bytes branch to `F0002001`; its
  `G_ENDDL` is emitted in the overlay arena. The fixture’s terminator at word
  index 10 is synthetic, and the live app installs only the root capture
  callback. The next implementation gate is an opt-in target observer that
  follows child arenas with bounded cycle/span rules. See [live-target
  terminator forensic evidence](docs/evidence/LIVE-TARGET-TERMINATOR-FORENSIC-2026-08-13.md).
- The opt-in target observer is now integrated at PC source `36910c8`. On
  Apple hosts, the existing `ACGC_GRAPH_CAPTURE` gate installs the bounded
  target-capture callback beside the root callback; the default and Windows
  paths are unchanged. The integrated `pc_main.c` object compile and the
  existing `F0002000` resolver fixture pass natively and under combined
  ASan/UBSan (`1/1` each). This still needs one serialized full link/LLDB run
  to emit a fresh game-owned target record; it does not claim a complete list,
  Metal/pixel output, input, audio, save/load, device, or playability. See
  [opt-in live target observer evidence](docs/evidence/LIVE-TARGET-OBSERVER-2026-08-13.md).
- One fresh correctly rooted runtime at the integrated source emitted the new
  game-owned `[GRAPH_TARGET_CAPTURE]` record: `F0002000`, capacity `1024`,
  classification `INDIRECT`, and bounded words containing `F0002001`. The run
  reached LOGO action 3 and NEOS, then was ended by the planned TERM/grace
  boundary without KILL. The full link exited 0 with a terminal `[4012/4013]`
  progress line (no literal 4013/4013 line), and GX was not instrumented in
  this launch. This is target-continuation evidence only; complete-list,
  GX/Metal, pixels, input, audio, save/load, device, clean-exit, and playability
  gates remain open. See [live target observer runtime evidence](docs/evidence/LIVE-TARGET-OBSERVER-RUNTIME-2026-08-13.md).
- The next bounded GX-boundary attempt built the same integrated source once
  (`ac_pc` exit `0`, terminal `[4012/4013]`) and verified `GXBegin` plus
  `pc_gx_flush_vertices` in LLDB before `run`. LLDB then failed before creating
  an inferior with `status -1`; the supervisor also recorded unprivileged
  `nice(5) failed: operation not permitted`. No boot, breakpoint, GX, Metal,
  pixel, or playability claim follows, and the lane made no retry. See [live
  GX-boundary runtime evidence](docs/evidence/LIVE-GX-BOUNDARY-RUNTIME-2026-08-13.md).
- A direct no-`nice` LLDB trace now reaches the real game-owned render path:
  `GXBegin` and `pc_gx_flush_vertices` both hit through
  `emu64::dl_G_TRIN`/`graph_task_set00` after the root and target captures
  (`F0002000`, capacity `1024`, `F0002001`). The trace reaches LOGO/NEOS and
  intentionally stops at the second breakpoint. This is launch and GX/OpenGL
  submission evidence only; the production `ac_pc` runtime still has no
  registered Apple Metal consumer, so no Metal/pixel/playability claim follows.
  See [game-owned GX boundary runtime evidence](docs/evidence/GAME-OWNED-GX-BOUNDARY-RUNTIME-2026-08-13.md).
- The integrated Apple source `f4cb491` now registers the existing borrowed
  packet consumer from the production `ac_pc` lifecycle, records bounded
  handoff/status counters, and allows resident-but-inactive texture objects
  while still rejecting active texture/TEV/lighting/fog state. The focused
  Darwin test and an exact-tip ASan/UBSan rerun pass; the OpenGL path remains
  unconditional. This is a CPU registration seam only: no live game callback,
  Metal encode/present, pixels, input, audio, save/load, device, or playability
  claim follows. See [Darwin GX handoff registration evidence](docs/evidence/DARWIN-GX-HANDOFF-REGISTRATION-2026-08-13.md).
- The integrated Apple source `54b840c` adds a value-only offscreen Metal sink
  for the existing semantic packet, with synchronous command-buffer/readback
  logic, bounded counters, and teardown-safe runtime wiring. Its CPU contract
  and production Apple object compile pass; the device-backed sink test skips
  `77` because this host has no Metal device. This is implementation and
  device-gate evidence only, not a live game callback, game-owned pixel, or
  playability claim. See [offscreen Metal sink evidence](docs/evidence/OFFSCREEN-METAL-SINK-2026-08-13.md).
- One serialized current-tip `ac_pc` link at `f4cb491` passed (`4017/4018`,
  arm64 Mach-O). The delegated no-`nice` LLDB attempt still failed before
  creating an inferior with `nice(5) failed: operation not permitted` and
  `status -1 (no such process)`; that historical attempt recorded zero
  breakpoint hits. See [delegated Darwin GX callback runtime evidence](docs/evidence/LIVE-DARWIN-GX-CALLBACK-RUNTIME-2026-08-13.md).
- A subsequent root-owned elevated LLDB launch from the generated `bin`
  directory created an inferior, loaded the GAFE01 FST and shaders, reached
  `graph_proc`/NEOS, and stopped at game-owned `pc_gx_flush_vertices`. After a
  bounded SIGTERM, the process returned through `graph_proc` and exited `0`.
  This proves current-tip launch, boot progression, GX/OpenGL submission
  reachability, and a bounded clean return; the interactive transcript did not
  retain per-breakpoint hit counts, so it does not claim a registered Apple
  callback, Metal encode/present, pixels, input, audio, save/reload, device, or
  playability. See [root-owned live launch evidence](docs/evidence/ROOT-LIVE-LAUNCH-2026-08-13.md).
- The game-owned save caller audit maps persistence to the restart NPC
  (`aNRST_save` → `mCD_SaveHome_bg(0, ...)`) and station-travel CARD paths;
  `Save_Get`/`Save_Set` are direct in-memory field access with no centralized
  dirty flag. The existing host fixture does not reach those callers. A future
  gate must drive a real restart save, assert a changed GCI marker, then start
  a fresh process and verify reload. See
  [game Save_t/CARD caller evidence](docs/evidence/GAME-SAVE-CALLER-AUDIT-2026-08-13.md).
- The caller-driven successor is integrated at PC source `02a003e`: production
  `aNRST_save` → `mCD_SaveHome_bg` writes a changed GCI marker, and a fresh
  fork/exec reload restores it. Native and combined ASan/UBSan runs pass with
  no sanitizer diagnostics; this remains a focused persistence gate, not full
  device or playability proof. See
  [game Save_t runtime evidence](docs/evidence/GAME-SAVE-RUNTIME-GATE-2026-08-13.md).
- A separate bounded run reaches the live SDL `PollEvent` and `PADRead` /
  `PCInputSnapshot` boundaries, but its single OS-event attempt posts no
  keydown or keyup and observes no state change. This is a running-game input
  boundary, not input proof; see [runtime input evidence](docs/evidence/RUNTIME-INPUT-BOUNDARY-2026-08-13.md).
- The post-graph/GX Windows audit finds no `_WIN32`/OpenGL/SDL regression in
  focused C and syntax probes; real i686 Windows targets remain blocked by the
  absent sysroot and MinGW tools, so this is not Windows sign-off. See
  [Windows regression evidence](docs/evidence/WINDOWS-REGRESSION-AUDIT-2026-08-13.md).
- The Apple renderer seam now has one borrowed, synchronous callback for a
  validated GX packet, with explicit unregister-on-shutdown and fail-closed
  unsupported-topology handling. Native and ASan/UBSan CPU tests pass; Metal
  device portions still skip `77`, and no full `ac_pc` link or live game frame
  is claimed. See [GX-to-Metal callback evidence](docs/evidence/LIVE-GX-METAL-CALLBACK-2026-08-13.md).
- The first live graph snapshot is pointer-free and records version `1`, frame
  `0`, source capacity `256`, count `8`, and words
  `de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000`.
  LLDB reaches the callback from `graph_task_set00`; after the callback the
  arm64 run faults at `pc_gx_texture.c:62` while following `data=0x83bdc0`, a
  truncated 32-bit texture object. This is a live submission-prefix gate, not
  a rendered-frame or playability claim. The post-fix trace reaches the live
  `GXBegin` → `pc_gx_flush_vertices` OpenGL boundary but remains an incomplete
  8-of-256-word capture; see [GX submission evidence](docs/evidence/GX-SUBMISSION-TRACE-2026-08-12.md).
- A fresh run from the integrated source snapshot `909f3ca` was built in
  `/private/tmp/acgc-integrated-audio-wave-build` and launched with the ignored
  local ISO symlinked under its generated `bin/rom/` directory. The log records
  `[AUDIO] LP64 bank decoded bank=28 bytes=3376 instruments=16 drums=64` and
  `[LOGO] draw: action=3 ...`; the captured screen at
  `/private/tmp/acgc-integrated-audio-wave-build/integrated-frame-screen.png`
  (SHA-256
  `ce1a124b15d07d7f81edb7ad1ef1548832c7d5bbff21bd46a59de533996129b6`)
  visibly contains the Animal Crossing window, character, and `© 2001, 2002
  Nintendo`. This passes the identifiable game-frame gate. The same run later
  exits with `139` before graceful cleanup, so stable post-frame execution,
  input, audible audio, save/load, and playability remain unproven.
- Umbrella commit `adc1d6e` adds the parser-only
  `scripts/probes/frame_evidence.py` gate and its handoff report. Against the
  exact clean `909f3ca` source and current runtime/fixture logs it returns
  `NOT_CLAIMED`: the historical graph prefix, synthetic renderer fixtures,
  and standalone screenshot are not joined into a game-owned submit → encode →
  present → visible-window → readback chain. This is evidence hygiene, not a
  regression of the separately recorded identifiable-frame screenshot.
- Umbrella commit `1d4d44b` adds the bounded
  `scripts/probes/acgc_game_frame_evidence.sh` harness and classifier tests.
  Syntax, ShellCheck, classifier, and fail-closed dry-run checks pass; the
  isolated dry-run stops before a build when its source submodule is
  uninitialized. It makes no rendered-frame claim.
- The reviewed audio-DMA handoff `304f055` is integrated on the authoritative
  branch as `724a18d`. The exact integrated `ac_pc` target rebuilds and links
  successfully (`cmake --build /private/tmp/acgc-integrated-audio-wave-build
  --target ac_pc -- -j2`, exit 0). A fresh bounded launch from that exact tip
  (`/private/tmp/acgc-integrated-audio-724-run.log`) stayed alive for ten
  seconds, reached `[LOGO] draw: action=3`, and emitted `[NEOS_OUT]` through
  frame `541`; sending `TERM` then produced wait status `139`, so graceful
  shutdown is not proved. No explicit fatal-signal marker was present in the
  log. The matching LLDB trace
  (`/private/tmp/acgc-integrated-audio-724-lldb.log`) stopped at
  `GXBegin`, inlined through `pc_gx_commit_pending_and_flush` at
  `pc_gx.c:253`, after the logo path. This is a game-side submission-entry
  boundary only: it does not prove Metal encode/present, pixel readback, or
  rebind the identifiable-frame screenshot, which remains evidence for the
  separately named `909f3ca` snapshot.
- The forensic target from `07a5447` reproduces the same contract in isolation:
  the opaque GBI handle resolves to the full arm64 pointer, while
  `GXInitTexObj` stores only the low 32 bits and `GXGetTexObjData` recovers the
  truncated value. It reports `EXPECTED_FAILURE` by design and does not alter
  the runtime texture path.
- The Apple packet-consumer fixture (`12b4f6e`) validates one supported GX
  triangle against the existing Metal state/geometry/texture/TEV seams and
  rejects larger topology without truncation. Its CPU contract passes; both
  Metal-device tests skip on this host, so no command-buffer, pixel, or game
  frame claim follows.
- The input path now adds `8b6849f`, a focused SDL virtual-controller smoke
  harness. Real `PADInit`/`PADRead` button and axis handoff passes natively and
  under ASan/UBSan 2/2. SDL-queued keyboard events do not mutate
  `SDL_GetKeyboardState`, so OS/human keyboard and physical-controller proof
  remain separate gates.
- The new silent SDL/CoreAudio boundary probe opened 32 kHz, S16 stereo audio at
  512 samples, observed 62 callbacks and zero underruns/overruns on the host;
  the dummy-device CTest also passes. This is device and ring timing evidence,
  not proof that the reconstructed mixer produces correct audible output.
- The integrated mixer probe drives `Jac_VframeWork`, `MixInterleaveTrack`,
  `AIInitDMA`, and the real SDL callback with distinct synthetic S16 stereo
  samples; exact PCM values and ring drain pass natively and under ASan. It
  does not claim CoreAudio device output or human-audible game audio.
- The NEOS/RSP provenance probe (`2736838`) drives four real `A_INTERLEAVE`
  batches through the resampler, triple buffer, DAC handoff, and callback; it
  observes 1,118 nonzero samples natively and under ASan. Asset-driven
  `NEOS_OUT`, CoreAudio output, and human-audible game audio remain open. The
  follow-up real SDL/CoreAudio probe returns its declared skip `77` because
  `kAudioDevicePropertyDeviceIsAlive` reports error `560947818`; no device
  callback or audible-output claim is made.
- The renderer-neutral GX packet contract has native, Apple-entrypoint, and
  ASan/UBSan focused passes, while the Metal geometry/state fixture passes its
  CPU contract and existing geometry tests. The offscreen Metal test is skipped
  on this host because no Metal device is available; no game-owned frame is
  claimed.
- The texture/TLUT/TEV fixture now covers fixed-width I4/I8/IA/RGB/RGBA/CI/CMPR
  cases, explicit palette endianness, sampler modes, and signed Q8.8 TEV
  arithmetic. Its integrated native test passes; this is not live texture
  upload/readback or game-renderer proof.
- The launcher supervisor now sends TERM, waits through a configurable grace
  period, falls back to KILL, and always reaps the child. Controlled TERM-aware
  and TERM-ignoring fixtures pass; this is process-supervision evidence, not a
  claim that the current game path exits cleanly.
- The umbrella lifecycle probe records deterministic monotonic/retrace,
  focus-resume, worker-join, and idempotent-termination behavior. The
  filesystem/save adapter records sandbox role roots, traversal rejection,
  durable atomic rename, and corruption detection. Both are synthetic adapter
  gates until connected to game state.
- The arm64 verification lane passes 12/12 selected native tests and 12/12
  ASan/UBSan tests at source snapshot `4f77dab`. A newer exact-snapshot matrix
  at `858d802` built 32 native and the same 32 under ASan/UBSan; portable 14/14,
  PC 4 passed with CoreAudio skipped, and Apple 6 passed with Metal skipped.
  This remains focused evidence, not a full `ac_pc` or game-frame proof. The
  Windows audits found no source regression in the graph-capture change; strict
  `_WIN32` graph seam compile/test probes pass. The host still has no
  MinGW/i686 compiler or Windows sysroot, so this is not a native Windows
  compiler sign-off.
- The umbrella-owned macOS filesystem/save adapter now resolves distinct bundle
  Resources, Application Support, Caches, and Logs roots; rejects resource
  writes and traversal; commits opaque save payloads with same-directory
  temp-file plus `fsync`/`F_FULLFSYNC`/rename/directory-`fsync`; and rejects
  checksum corruption and truncation. Its synthetic ISO-sentinel proof does
  not copy bytes outside Resources. This is host-adapter evidence, not
  GameCube `Save_t`/GCI or game-level save/reload proof.
- The Save_t/GCI probe records the supported layout and passes checksum,
  scalar-endian, canonical-padding, and codec-only process-restart/sanitizer
  checks. It also exposes a real losslessness blocker: the active layout places
  `time_limit` at `+0x02`, while the repacker drops the low 16 bits of the raw
  unit (`wire=0xF10E -> roundtrip=0x0000`). The production CARD lane now
  validates Save_t identity/checksum, recovers the embedded backup slot, and
  falls back to the prior atomic `.bak1` generation. A focused follow-up routes
  one generation through the game-owned `mCD_SaveHome_bg` request boundary and
  verifies process-restart reload; full game-level save-manager orchestration,
  exact GCI-envelope length, and whole-GCI losslessness remain open.
- The new CARD host-transfer test creates, writes, reads, closes, reopens, and
  rejects invalid ranges in a temporary card directory. It passes natively and
  under ASan/UBSan. The production `pc_m_card.c` recovery fixture additionally
  passes atomic replacement, restart reload, embedded-backup recovery, and
  whole-GCI `.bak1` fallback under native and ASan/UBSan; it remains separate
  from full game save-manager and device proof.
- The exact game launcher passes its bounded process gate with
  `ACGC_GAME_BUILD_DIR=local/build/macos-audio-pointer-proof
  ./script/build_and_run_game.sh --verify`: the actual process remains alive for
  five seconds, enters `initial_menu_init`, `dvderr_init`, and `sound_initial2`,
  and emits `[NEOS_OUT]` through at least frame `1861`. The earlier conditional
  low-pointer `Jac_bcopy` breakpoint does not fire. This is real process-launch
  evidence only—not a rendered game frame, input, audible-output, save/load, or
  playability claim.
- A fresh host-context run against `local/build/macos-lanes-integrated` rebuilt
  the same arm64 target, reached `COPYDATE`, and emitted `[NEOS_OUT]` through at
  least frame `841`. The runner printed its five-second launch gate, but the
  process did not honor the cleanup `SIGTERM` while waiting in the DVD/file
  loader path; the single process required an explicit `SIGKILL`. This leaves
  clean supervision and the transition past `COPYDATE` as the next runtime
  blocker, not evidence of a game-owned frame.
- The focused DVD-tail lane then reproduced the GameCube sector-tail rule for
  disc-backed reads: a 19-byte `COPYDATE` can satisfy the required 32-byte
  transfer while malformed offsets remain rejected. Its fresh arm64 run now
  completes `COPYDATE`, string-table loading, `JW_Init2`, `HotStartEntry`, both
  forest archives, and Famicom archive loading before an `EXC_BAD_ACCESS` at
  `game.c:154` while entering `graph_proc`. This moves the runtime frontier
  beyond the loader; it is still not a game-owned frame. The original boot
  trace identifies the failing operation as the `GRAPH_SET_DOING_POINT(...,
  GAME_BGM)` write at that line, before `graph_task_set00` and before the
  capture hook. Source `5086f1d` reloads `GAME.graph` after the corrupting
  callback; `10d6ac0` then captures the first live game-owned prefix at the
  callback (version 1, frame 0, capacity 256, count 8, words
  `de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000`).
  The same arm64 run subsequently faults at `pc_gx_texture.c:62` on truncated
  texture data `0x83bdc0`; this is not a rendered-frame or playability claim.

Re-run the tracked checks from this directory:

```sh
./scripts/verify-source-input.sh
./scripts/verify-portable-core.sh
./scripts/verify-disc-core.sh
./scripts/verify-lifecycle.sh
./scripts/verify-filesystem-save.sh
./script/build_and_run.sh --headless
./script/build_and_run.sh --verify
ACGC_GAME_BUILD_DIR=local/build/macos-audio-pointer-proof ./script/build_and_run_game.sh --build
ACGC_GAME_BUILD_DIR=local/build/macos-audio-pointer-proof ACGC_GAME_VERIFY_SECONDS=5 ./script/build_and_run_game.sh --verify
```

The final command runs the AppKit executable directly with a five-second
deadline, requests two Metal clear/triangle/present command buffers, checks the
renderer fixture's own completion evidence and exit status, and confirms no
process remains. It is a native geometry-fixture gate without pixel readback,
not a representative GX, reconstructed game-frame, or playability claim.

The actual-game `--verify` command is a separate gate. It builds the full
`ac_pc` target, validates the ignored local disc by SHA-256, symlinks that input
under the ignored build directory, and proves only that the reconstructed
process stays alive for the requested interval. Its runtime log remains under
`local/build/`; it never copies disc bytes into tracked paths.

## Project record

- [Source, revision, licensing, and toolchain audit](docs/SOURCE-AUDIT.md)
- [Measured PC portability audit](docs/PORTABILITY-AUDIT.md)
- [Apple architecture and evidence-gated milestones](docs/APPLE-PORT-PLAN.md)
- [macOS filesystem roles and atomic-save proof](docs/FILESYSTEM-SAVE-EVIDENCE.md)
- [macOS lifecycle contract evidence](docs/LIFECYCLE-EVIDENCE.md)
- [Save_t/GCI codec evidence](docs/SAVE-GCI-EVIDENCE.md)
- [Frame evidence gate handoff](docs/evidence/FRAME-EVIDENCE-2026-08-12.md)
- [arm64 native and sanitizer matrix](docs/LANE-VERIFICATION-MATRIX-2026-08-12.md)
- [current integrated verification matrix](docs/LANE-VERIFICATION-CURRENT-858D802-2026-08-12.md)
- [Exact bootstrap commands, results, and blockers](docs/BOOTSTRAP-EVIDENCE.md)
- [Porting charter](docs/PORTING-CHARTER.md)
