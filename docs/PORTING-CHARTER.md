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

## Current gate state

As of 2026-08-13, source/revision proof, the current bounded portable-core
slice, macOS host launch, and a deterministic Metal clear/triangle/present
fixture are passed. The latest integrated source tip is the clean native arm64
PC branch `c1/macos-host-launch` at `28ebac2`, which wires the V4 builder into
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
One serialized current-tip `28ebac2` link reached `[4018/4019]`, and one
bounded LLDB launch reached the game-owned graph/GX path. The V4 builder entry
counted `558` attempts, but the typed V4 Apple consumer, prepare path, and
`pc_metal_runtime_observe` each remained at `0`. This confirms a live
builder-rejection boundary only; it does not establish a callback, Metal
encode/present/readback, pixel, or playability gate. See [current V4 runtime
evidence](evidence/CURRENT-V4-LIVE-CONSUMER-RUNTIME-28EBAC2-2026-08-13.md).
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
