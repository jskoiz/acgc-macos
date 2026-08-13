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

## Current evidence

- Latest integrated source is `upstream/ACGC-PC-Port` branch
  `c1/macos-host-launch` at `d1e812c` (`Add versioned GX v2 consumer handoff`),
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
  `AnimalCrossing` executable. The current source tip is `d1e812c`; its GX v2
  packet and version-aware consumer paths, Apple sink shader fix, and
  input-fixture changes have focused verification but have not yet had another
  full `ac_pc` link. Its native audio command records remain 8 bytes,
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
