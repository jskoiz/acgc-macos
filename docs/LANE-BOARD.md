# ACGC visible lane board

Updated 2026-08-13 under the resumed rolling-refill scheduler. The board records the
visible Codex tasks, their ownership, and the order in which evidence may be
integrated. All new and successor tasks are Luna Max with max reasoning. A
task being active means it is allowed to inspect or run its bounded work; it
does not mean its gate passed.

Current scheduler ceiling: up to fifteen useful visible ACGC lanes, with no
filler. One lane is the integration/evidence owner; up to fourteen are worker
lanes. Production source editing remains capped at seven simultaneous lanes,
with the remaining capacity reserved for dependency-ready reference audits,
focused fixtures, read-only traces, and independent verification.
The texture remediation (17) is now complete/integrated at source `578c8b7`.
The root-owned audio-bank ABI lane is integrated at source `909f3ca`; its
historical fresh run decodes compact bank 28, reaches `LOGO draw`, and
produces the first identifiable game-owned frame. The captured screen is retained outside Git at
`/private/tmp/acgc-integrated-audio-wave-build/integrated-frame-screen.png`
(SHA-256
`ce1a124b15d07d7f81edb7ad1ef1548832c7d5bbff21bd46a59de533996129b6`). The
process later exits `139` before clean shutdown, so representative GX/Metal
readback, input, audible audio, save/load, and playability remain open. The
authoritative source has since advanced through `09dd182` to `aea3515`: the
LP64 field-cleanup fix preserves the allocator-owned pointer, and a fresh exact-tip ten-second run
reaches logo action 3 and `[NEOS_OUT]` frame 541; TERM then returns status `0`
within the two-second grace period. This closes the previously reproduced
post-GX invalid-free boundary, but it still has no current-snapshot
pixel/readback claim.
Graph capture (16) and integrated verification (22) are complete/parked. The
post-fix game-frame request is superseded by the root-owned integrated run;
the older client-only successor requests listed below never became durable
tasks or worktrees and remain parked historical intake, not active lanes.
Expensive full links and LLDB launch traces remain serialized. All other
ACGC tasks are parked or archived;
their reviewed commits and evidence remain available in Git and the evidence
docs.

Current maintenance state: no worker is active. Lane 72 completed its one
serialized callback-observation attempt and is archived after the pre-inferior
`nice(5)` permission boundary. A root-owned elevated current-tip launch then
created an inferior, reached `graph_proc`/NEOS and `pc_gx_flush_vertices`, and
returned through `graph_proc` with exit status `0` after bounded SIGTERM. That
run proves launch/boot/GX-boundary/clean-return only; its interactive
transcript did not retain per-breakpoint hit counts, so the Apple callback gate
remains open. No dependency-ready worker successor is being opened yet; the
next bounded action is an explicit callback-hit capture before any Metal
encoder work. The read-only Metal bridge audit
and Apple registration source lane are complete; their exact findings remain
the current renderer boundary. The authoritative PC source is
`f4cb491` on
`c1/macos-host-launch`; the umbrella branch is `c1/apple-port-bootstrap` plus
only the pre-existing
`.codex`/settings edits. The graph-capture, GX-to-Metal, and save-manager review
queue is complete; the graph activation, exact-tip sanitizer, graph-target
source/test, and caller-driven save/restart audits are complete/parked with
their evidence recorded below. The post-link runtime task, live-target resolver,
and current-tip runtime trace are complete and archived; the current-tip trace
is blocked before graph boot by a launch working-directory mismatch, with no
retry performed. Lane 64 is complete/archived with a separate pre-launch LLDB
command-setting blocker. Lane 65 is complete/archived with live target and GX
boundary evidence. Lane 66 is complete/archived with its source crosswalk and
focused reruns recorded below. Lane 67 is complete/archived with the integrated
opt-in target observer and focused native/ASan/UBSan evidence; its duplicate
setup was stopped before edits. Lane 68 is complete/archived with the first
fresh game-owned target-continuation record; its full link exited 0 with the
terminal `[4012/4013]` progress caveat and one LLDB launch reached LOGO/NEOS
before TERM/grace. GX was not instrumented. Lane 69 is complete/archived: its
fresh full link exited 0, LLDB accepted the generated-bin working directory and
both GX breakpoints, then failed before inferior creation with `status -1` and
`nice(5) failed: operation not permitted`; no retry or GX evidence followed.
No other filler lane is being opened.
The root-owned direct no-`nice` LLDB trace now proves the next GX boundary:
`GXBegin` and `pc_gx_flush_vertices` both hit through `emu64::dl_G_TRIN` and
`graph_task_set00`, while the target observer emitted `F0002000` capacity 1024
with `F0002001`. This remains OpenGL/GX boundary evidence; Metal encode/present
and pixel proof are still open. Lane 70's isolated Metal bridge audit is now
complete and archived.
The completed lane-70 audit found that `ac_pc` never registers or links the
Apple consumer, while the current state gate rejects resident bootstrap
textures and the existing consumer remains a CPU fixture adapter. The
integrated lane-71 source handoff now owns the borrowed packet-consumer bind,
the narrow resident-versus-active texture gate correction, and bounded
callback/status telemetry, while leaving the legacy OpenGL submission path
unchanged. It cannot claim Metal encoding, presentation, pixels, or playability.
The handoff evidence is
`docs/evidence/DARWIN-GX-HANDOFF-REGISTRATION-2026-08-13.md`; the delegated
lane-72 blocker remains historical in
`docs/evidence/LIVE-DARWIN-GX-CALLBACK-RUNTIME-2026-08-13.md`, and the fresh
root-owned launch is recorded in
`docs/evidence/ROOT-LIVE-LAUNCH-2026-08-13.md`.
Mixer/CoreAudio, Metal, GX-prefix,
texture-pointer, texture/TLUT/TEV, runtime-input, filesystem, timing,
Windows, and sanitizer lanes are complete/parked or integrated. The current
game-cleanup invalid-free successor
(`019ffa28-3ef7-7280-923c-5a01bf2eb4c2`) is now complete. The complete graph
capture contract and game GX-to-Metal handoff seam are complete and archived.
The full save-manager restart seam
is integrated at `a7b9dff` and its task is archived. The post-fix GX submission
trace (`019ffa49-4f9c-7da2-a288-5791e5cf5c93`) is complete and archived with
evidence in `docs/evidence/GX-SUBMISSION-TRACE-2026-08-12.md`. The
CARD Save_t reload recovery (`019ffa49-4f44-7b73-a4ab-8c45dc211f14`) is
complete and archived with production evidence. The exact-tip sanitizer refresh
(`019ffa4c-8734-7ac2-99d1-f67a0682be31`) is complete and archived; its
evidence is recorded in `docs/evidence/SANITIZER-REFRESH-2026-08-12.md`. No
other dependency-ready lane is being refilled: live
CoreAudio/Metal devices and the complete game-owned graph capture remain
unavailable, while Windows and iOS are gated by their stated proofs. The
post-audio, arm64 post-texture, WaveTouch, and audio-DMA handoffs remain
complete/archived.
Pinned task `019ff9bd-7f15-7513-8b22-61af13c8a6fe`
(`ACGC Worktree and Thread Cleanup`) owns the separate 30-minute cleanup
heartbeat. Its first pass retired five clean source worktrees and pruned their
stale Git metadata, preserving every branch and commit. It also retired five
clean orphaned umbrella worktrees; the remaining `a828` checkout is dirty and
is explicitly preserved. It archives completed worker tasks but does not touch
active or dirty state. The dated manifest is
`/Users/jk/Desktop/Automations/cleanup-records/2026-08-12-acgc-first-pass.md`.

The resumed workers below have durable task IDs and isolated umbrella
worktrees. Source-edit workers must create the named owning-submodule branch
before editing; read-only/test workers must stay within their declared scope.
The integration owner reviews one handoff at a time, locally merges reviewed
commits into `c1/macos-host-launch` or the umbrella as appropriate, reruns the
smallest focused gate, and updates the gitlink/docs. Only after that review does
the cleanup heartbeat archive the task and retire its worktree/build artifacts.
No worker may self-merge, update the umbrella gitlink, or claim a later gate
from compilation alone.

## Ownership and live state

| # | Lane / visible task ID | Ownership | Worktree / branch | State |
| --- | --- | --- | --- | --- |
| 1 | DVD aligned-read semantics — `019ff8aa-6e31-7723-bb32-095c7158148b` | `pc_dvd.c`, focused DVD probe | `/private/tmp/acgc-lane-dvd-loader` / `c1/lane-dvd-loader`; source `dfb3f7f`, integrated as `4f77dab` | Complete; fresh run passes `COPYDATE` and reaches `game.c:154` |
| 2 | Launch supervisor — `019ff8d2-a527-7c90-b7c0-f95aef4f5a0e` | Umbrella `script/build_and_run_game.sh` only | `/Users/jk/.codex/worktrees/f2c7/acgc-modern-port`; `c1/lane-launch-supervisor` | Complete; umbrella `e96776d`; TERM grace/KILL fixture passed |
| 3 | Boot trace → graph fault repair — `019ff8d3-06e4-71d3-8708-120d84fa270f` → `019ff8e7-402d-7a31-844a-0afd32918cc1` | Completed LLDB evidence, then source-owned `GAME`/`GRAPH` LP64 callback path | Trace `/Users/jk/.codex/worktrees/6bed/acgc-modern-port`; repair `/private/tmp/acgc-lane-graph-fault` / `c1/lane-graph-fault` | Complete/integrated; source `5086f1d`; reload crosses `game.c:154` to `graph_task_set00`; live packet now captured by lane 4 |
| 4 | First game-owned render submission — `019ff8aa-6e31-7723-bb32-097e85bb2293` → `019ff8ff-51e1-74b0-ad13-1539b72e8937` | Graph/emu64 submission capture | `/private/tmp/acgc-lane-render-capture-v2` / `c1/lane-capture`; live `/Users/jk/.codex/worktrees/5f6a/acgc-modern-port`; source branch `c1/lane-render-live` | Complete/integrated as `10d6ac0`; LLDB callback captured version 1, frame 0, capacity 256, count 8, words `de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000`; run then faults at `pc_gx_texture.c:62` on truncated `0x83bdc0`; no frame claim |
| 5 | GX semantic packet — `019ff8d3-0887-7472-a53a-84c5d7ad105c` | Fixed-width renderer-neutral packet + tests | `/private/tmp/acgc-lane-gx-packet` / `c1/lane-gx-packet` | Complete; source `83fa889`; native/Apple/ASan focused tests passed |
| 6 | Metal geometry/state — `019ff8d3-0c2e-7463-b918-af75f7cb6208` | Apple geometry/state fixtures | `/private/tmp/acgc-lane-metal-state` / `c1/lane-metal-state` | Complete; source `866dd94`; CPU/geometry passed, Metal skipped (no device) |
| 7 | Texture/TLUT/TEV fixtures — `019ff8d3-150c-77f0-b99c-dcbf38645977` | Synthetic texture/palette/combiner fixtures | `/private/tmp/acgc-lane-tev-fixtures` / `c1/lane-tev-fixtures` | Complete; source `ddbb498`; focused native + ASan/UBSan fixture passed |
| 8 | Input snapshot + SDL event smoke — `019ff8aa-743f-7923-8d9b-276421802fa8` | SDL-to-logical keyboard/controller snapshot, PADRead handoff, and event-path tests | `/private/tmp/acgc-lane-input-snapshot` / `c1/lane-input-snapshot` | Complete/parked; source `8b6849f`; native + ASan/UBSan SDL/controller smoke 2/2, keyboard requires OS/human event |
| 9 | Mixer/CoreAudio correctness — `019ff8aa-7959-7342-af84-187dfb2e0a89` | Reconstructed PCM/mixer output proof and NEOS provenance | `/private/tmp/acgc-lane-audio-mixer` / `c1/lane-audio-mixer` | Complete/parked; source `2736838`; RSP/Neos-style provenance to callback passes 1,118 nonzero samples native + ASan; real device/audible gate remains open |
| 10 | Save_t/GCI roundtrip — `019ff8d3-0fe5-7883-8ebb-74eeac6efcb6` | Byte codec and process-restart persistence evidence | `/Users/jk/.codex/worktrees/35f6/acgc-modern-port` / `c1/lane-save-gci` | Complete/parked; umbrella `aeefc15`; canonical/checksum/codec restart pass, arbitrary raw range `0xB6..0xB7` remains blocked |
| 11 | Sandboxed filesystem/atomic saves — `019ff8d3-1b80-7ab0-89b5-28afcf680cef` | Application Support/cache/log/temp-file adapter | `/Users/jk/.codex/worktrees/10c5/acgc-modern-port`; `c1/lane-filesystem-saves` | Complete; umbrella `ee7b814`; synthetic atomic/corruption/isolation probes passed |
| 12 | Timing/retrace/lifecycle — `019ff8d3-1f89-7c23-82fb-150b2f39e37c` | Monotonic time, workers, shutdown/resume | `/Users/jk/.codex/worktrees/cf91/acgc-modern-port`; `c1/lane-timing-lifecycle` | Complete; umbrella `15a081f`; strict + ASan/UBSan repeated trace passed |
| 13 | Windows compatibility audit — `019ff8d3-23c5-75a2-beac-7f7e70c72c08` | Read-only x86/Windows/OpenGL/SDL conditional audit | `/Users/jk/.codex/worktrees/8231/acgc-modern-port` | Complete read-only; scoped to `4f77dab`, no MinGW compiler sign-off |
| 14 | Native + ASan/UBSan matrix — `019ff8d3-2a6f-7610-a9f1-53f237353454` | Focused verification and sanitizer evidence | `/Users/jk/.codex/worktrees/2232/acgc-modern-port`; `c1/lane-verification-matrix` | Complete/parked; umbrella `38f85da`; 32 native + 32 ASan/UBSan targets at exact `858d802`, CoreAudio/Metal skipped as expected |
| 15 | Integration/evidence owner — `019ff398-2520-7191-ac5c-f3007c49163f` | Umbrella docs, roadmap, reviewed commits, source gitlink, launch proof | `/Users/jk/Documents/Projects/acgc-modern-port` / `c1/apple-port-bootstrap` | Active; only lane allowed to update the umbrella submodule pointer |
| 16 | Graph capture → GX packet — `019ff914-44fc-7801-88f4-ee513fc8e728` | New adapter/test from captured prefix into existing GX contract | `/Users/jk/.codex/worktrees/4a27/acgc-modern-port`; source `/private/tmp/acgc-lane-graph-gx-adapter` / `c1/lane-graph-gx-adapter` | Complete; reviewed `4d2fa4f` and integrated as source `d0ae08d`; 3/3 focused tests passed; observed live prefix still fails closed |
| 17 | LP64 texture handle remediation — `019ff914-9bd9-77f3-8d8b-d72f5c00d587` | `pc_gx_texture.c` and opaque-reference width/lifetime | `/Users/jk/.codex/worktrees/fc81/acgc-modern-port`; source `/private/tmp/acgc-lane-lp64-texture` / `c1/lane-lp64-texture` | Complete/integrated as source `578c8b7`; focused native/ASan/UBSan fixture passes; actual game crosses the texture fault but no frame is claimed |
| 18 | Metal semantic packet consumer — `019ff914-9e34-7181-8903-f8022c82cacf` | Packet-to-state/encoder validation and device-gated fixture | `/Users/jk/.codex/worktrees/da16/acgc-modern-port`; source `/private/tmp/acgc-lane-metal-packet-consumer` / `c1/lane-metal-packet-consumer` | Complete/integrated as `12b4f6e` (lane commit `209e95f`); 9 Apple tests pass and 2 Metal tests skip without a device; no live frame claim |
| 19 | Live graph capture reproducibility — `019ff914-ad3f-7721-82f2-d8985d601ba1` | Two cold-run snapshots and exact fault boundary | `/Users/jk/.codex/worktrees/5edb/acgc-modern-port`; build `/private/tmp/acgc-lane-live-capture-repro-build` | Complete/parked; two cold runs are byte-identical (version 1, frame 0, capacity 256, count 8, same words) and both stop at `pc_gx_texture.c:62` `data=0x83bdc0` before legacy submission; no frame claim |
| 20 | CoreAudio/device and asset-audio successor — `019ff914-a32b-7363-a619-f79e21c75db3` | Real sink gate, then asset-driven NEOS_OUT runtime trace | `/Users/jk/.codex/worktrees/fdc9/acgc-modern-port`; builds `/private/tmp/acgc-lane-coreaudio-device-build` and `/private/tmp/acgc-lane-audio-asset-runtime-build` | Parked/archived under four-lane cap: device subgate complete with declared skip `77` (`kAudioDevicePropertyDeviceIsAlive`, `560947818`); no audible claim |
| 21 | Save_t raw-wire forensic → codec fix — `019ff914-a86e-7793-b0f0-6ce23e8d97a0` | `time_limit` width/endianness evidence, then `pc_save_bswap.c` repair | `/Users/jk/.codex/worktrees/e9ef/acgc-modern-port`; builds `/private/tmp/acgc-lane-save-wire-forensic-build` and `/private/tmp/acgc-lane-save-wire-fix-build`; source successor `/private/tmp/acgc-lane-save-wire-fix` / `c1/lane-save-wire-fix` | Parked/archived under four-lane cap; forensic result retained: effective 16-bit bitfield at `+0x02`, lost `Save_t +0xB6..+0xB7`, `wire=0xF10E` → `roundtrip=0x0000`; no codec edit integrated |
| 22 | Integrated sanitizer matrix — `019ff914-b322-7e10-876e-c942a45aef4a` | Native and ASan/UBSan at current source HEAD, including texture fixture | `/Users/jk/.codex/worktrees/44e8/acgc-modern-port`; builds `/private/tmp/acgc-lane-integrated-native-12b4f6e` and `/private/tmp/acgc-lane-integrated-sanitizer-12b4f6e` | Complete/parked at `12b4f6e`; 34/34 registered tests passed with 3 expected skips in each matrix; 11 recoverable `aflags_c` UBSan findings remain; focused adapter rerun at `d0ae08d` passed 3/3 in `/private/tmp/acgc-lane-integrated-adapter-d0ae08d` |
| 23 | Windows compatibility post-capture audit — `019ff914-b7c7-75d2-ad4c-d94032e35b12` | `_WIN32`/x86/OpenGL/SDL conditional audit after `10d6ac0` | `/Users/jk/.codex/worktrees/d9c5/acgc-modern-port`; build `/private/tmp/acgc-lane-windows-audit-build` | Complete/parked; strict `_WIN32` graph seam compile/test passes; no source regression found; native Windows/x86 toolchain remains unavailable |
| 24 | Pre-render texture fault fixture — `019ff914-bfa0-7d31-8228-247292e5cad1` | Isolated regression fixture for 32-bit texture-object truncation | `/Users/jk/.codex/worktrees/52c7/acgc-modern-port`; source `/private/tmp/acgc-lane-texture-fault-fixture` / `c1/lane-texture-fault-fixture` | Complete/integrated as `07a5447`; native arm64 fixture records full pointer → opaque handle → low-word truncation and intentional `EXPECTED_FAILURE`; remediation remains lane 17 |
| 25 | macOS host input/window lifecycle gate — `019ff914-c6fa-7812-bed5-8939ef4fa58e` | Init/poll/focus-resume/termination plus exact input handoff | `/Users/jk/.codex/worktrees/24c0/acgc-modern-port`; planned source `/private/tmp/acgc-lane-macos-host-lifecycle` / `c1/lane-macos-host-lifecycle` | Parked/archived under four-lane cap; prior lifecycle evidence remains integrated |
| 26 | Post-fix game frame runtime — client `client-new-thread:1b48103c-9b76-4caf-8598-686e392653c3` | Fresh actual-game arm64 run after texture remediation, packet/frame boundary | No separate worktree activated; root integration owner used `/private/tmp/acgc-integrated-audio-wave-build` | Superseded by root-owned integrated run; first identifiable game-owned frame captured, later `rc=139`; no duplicate full link |
| 27 | Audio-bank ABI repair — root-owned continuation | `src/static/jaudio_NES/internal/system.c`, `channel.c`, fixed-width bank decoder and focused fixtures | `/private/tmp/acgc-lane-audio-lp64` / `c1/lane-audio-lp64`; lane commit `5974764`, integrated on `c1/macos-host-launch` as source `909f3ca`; build `/private/tmp/acgc-integrated-audio-wave-build` | Integrated bounded fix; `ac_pc` full link `rc=0`, audio fixture 1/1, emu64 native 3/3, ASan/UBSan 3/3; bank 28 decodes (`3376` bytes), `[LOGO] draw` appears, and the integrated screenshot passes the game-frame gate; later `rc=139` keeps clean shutdown and post-frame stability open |
| 28 | Frame evidence packaging — `019ff9a0-f9be-73a0-a452-02a309e5baa5` | Umbrella parser/report only; current-source binding and fail-closed submit/encode/present/readback labels | `/Users/jk/.codex/worktrees/4efd/acgc-modern-port` / `c1/lane-frame-evidence`; integrated umbrella `adc1d6e` | Complete/integrated; self-test passes; exact clean `909f3ca` rerun returns `NOT_CLAIMED`, explicitly rejecting historical graph prefixes, fixture output, and a standalone screenshot as a full frame chain |
| 29 | Frame evidence harness — `019ff9a0-e9ed-78d3-8d4e-b7c617270b16` | Umbrella `scripts/probes/` only; bounded launch/boot/packet/present/frame classifier | `/Users/jk/.codex/worktrees/5e48/acgc-modern-port` / `c1/lane-frame-evidence` | Complete/integrated as umbrella `1d4d44b`; `bash -n`, ShellCheck, classifier tests, and fail-closed dry-run pass; no source, ISO, or frame claim |
| 30 | Audio-DMA LP64 fix — `019ff9a1-00c9-7fa3-815f-e282eb7ad2e9` | `src/static/jaudio_NES/internal/system.c` only; preserve native audio pointers at the DMA boundary | `/private/tmp/acgc-lane-audio-lp64` / `c1/lane-audio-lp64`; lane `304f055`, authoritative `724a18d` | Complete/integrated; serialized `ac_pc` link passes; fresh LLDB reaches `Nas_FastCopy` with native `DestAdd=0x10084c5e0`, avoids `_platform_memmove`/`EXC_BAD_ACCESS`, and stops intentionally at the first breakpoint |
| 31 | Fresh integrated post-frame run/trace — root-owned evidence continuation | Exact `724a18d` runtime, LOGO/NEOS markers, and bounded LLDB submission-entry trace; no source edits | `/private/tmp/acgc-integrated-audio-wave-build`; logs `/private/tmp/acgc-integrated-audio-724-run.log` and `/private/tmp/acgc-integrated-audio-724-lldb.log` | Complete bounded check; ten-second run reaches LOGO action 3 and NEOS frame 541; LLDB stops at `GXBegin`/`pc_gx_commit_pending_and_flush` (`pc_gx.c:253`); TERM wait status `139`; no Metal/pixel claim and no worker refill |
| 32 | Post-GXBegin termination — `019ffa0f-2a8d-7c43-9295-2389e7c2a02b` | Prior source edit scope was `host.c`, `game_runtime.c`, `pc_main.c`; successor owns the actual game-cleanup path | `/Users/jk/.codex/worktrees/b94a/acgc-modern-port`; source `/private/tmp/acgc-lane-post-gx-termination/source` / `c1/lane-post-gx-termination` (retired) | Complete/parked; 4011/4011 build and 10-second LOGO/NEOS liveness pass; TERM reproduces `rc=139` at `__osFree_NoLock → mFM_Field_dt:1370 → play_cleanup → game_dt`; no in-scope source fix or commit; no clean-shutdown/frame claim |
| 33 | Texture pointer runtime boundary — `019ffa11-aad0-7383-90f3-a6caedbf2a8f` | `pc_gx_texture.c` plus one focused fixture; native pointer/opaque-reference width contract | `/Users/jk/.codex/worktrees/93b0/acgc-modern-port`; source `/private/tmp/acgc-lane-texture-pointer-runtime` / `c1/lane-texture-pointer-runtime` (retired) | Complete/parked; no new commit because existing fix `578c8b7` is already in `724a18d`; native, ASan, and bounded LLDB round-trip recover the full above-4-GiB pointer; no renderer/readback claim |
| 34 | Metal live-frame consumer — `019ffa11-c6ee-7ef2-86fa-6bbe53e64b2d` | Apple packet consumer and geometry encoder only; device/present/readback gate | `/Users/jk/.codex/worktrees/60e4/acgc-modern-port`; source `/private/tmp/acgc-lane-metal-live-consumer` / `c1/lane-metal-live-consumer` (retired) | Complete/parked; CPU packet/geometry/renderer contracts pass; Metal tests skip `77` because `MTLCreateSystemDefaultDevice()` is unavailable; no encode/present/readback/pixel claim; no source changes |
| 35 | Live GX prefix decoder — `019ffa12-60bf-71d3-9531-ed47364e6ff7` | `pc_gbi_runtime.c` and focused decoder fixture; fail closed on incomplete 8-word capture | `/Users/jk/.codex/worktrees/81c4/acgc-modern-port`; source `/private/tmp/acgc-lane-gx-prefix-decoder` / `c1/lane-gx-prefix-decoder` (retired) | Complete/integrated at source `57d16bd`; fixture-only `DE010000`/`F0002000` contract; native 6/6 and sanitizer 5/5 pass; traversal sanitizer retains pre-existing `emu64.c:6078` `aflags_c` blocker; live capture remains incomplete and no draw is claimed |
| 36 | Live texture/TLUT/TEV evidence — `019ffa12-66ef-7d81-89a8-3ddae2063b97` | Apple texture/TEV fixtures and classifier only; no live-readback claim | `/Users/jk/.codex/worktrees/5c10/acgc-modern-port`; source `/private/tmp/acgc-lane-texture-tev-fixtures-20260812/source` / `c1/lane-texture-tev-fixtures-20260812` (retired) | Complete/integrated at source `ad0576a`; I8 first/last-texel fixture added; native and ASan/UBSan fixture PASS; no live texture upload, Metal readback, or game-frame claim |
| 37 | Runtime input proof — `019ffa12-6965-7a30-acc8-3f9123337a2e` | `pc_pad.c`, `pc_keybindings.c`, focused OS/controller event proof | `/Users/jk/.codex/worktrees/ecaf/acgc-modern-port`; source `/private/tmp/acgc-lane-host-input-worktree` / `c1/host-input-pad-read` (retired) | Complete/integrated at source `305b223`; bounded host mode adds OS-level keyboard → SDL → PADRead proof; native and ASan/UBSan focused 2/2; physical controller remains skipped without a device; no game-frame/audio claim |
| 38 | Mixer/CoreAudio sink — `019ffa12-7330-7820-b006-0b7058cf8af9` | `pc_audio.c`, `pc_audio_bank.c`; mixer-to-sink and exact device skip boundary | `/Users/jk/.codex/worktrees/a058/acgc-modern-port`; source `/private/tmp/acgc-lane-mixer-coreaudio/worktree` / `c1/lane-mixer-coreaudio` | Complete/parked; native 3/3 and ASan/UBSan software mixer/NEOS/bank fixtures pass; CoreAudio probe preserves skip `77` (`AudioDeviceGetProperty…560947818`), so device cadence/audibility remain unproven; no source changes |
| 39 | Save_t/GCI restart — `019ffa12-775d-7593-9b68-702d9e0501b0` | `pc_save_bswap.c`, `pc_card.c`; wire/checksum/restart roundtrip only | `/private/tmp/acgc-lane-save-t-gci-codec` (retired); source `c1/lane-save-t-gci-codec` | Complete; integrated at source `d1575f0`; native and ASan/UBSan codec/checksum/restart plus CARD adapter pass; raw `Save_t 0xB6..0xB7` preserved; production `pc_m_card.c` atomic/reload/corruption recovery remains open |
| 40 | Sandboxed filesystem/atomic-save evidence — `019ffa12-7f97-7113-8934-617a264394af` | Umbrella probes/evidence only; Application Support/temp/atomic replacement | `/Users/jk/.codex/worktrees/7f63/acgc-modern-port`; umbrella branch `c1/save-path-evidence` (retired) | Complete/integrated at umbrella `bb9aa02`; synthetic path/isolation/atomic-recovery probe 3/3 passes; no Save_t/GCI wire or sandbox-entitlement claim |
| 41 | Timing/retrace/lifecycle audit — `019ffa12-8092-7cd0-a5d9-9ff1904d821b` | Read-only `pc_os.c`, `pc_vi.c`, `game_runtime.c`; ranked status-139 handoff | `/Users/jk/.codex/worktrees/bb46/acgc-modern-port` (retired) | Complete/parked; game-runtime probe native and ASan/UBSan pass; bounded full-port trace stops at SDL init, so TERM/worker causality and clean shutdown remain unproven |
| 42 | Windows compatibility audit — `019ffa12-87a8-78b0-924a-feab35389797` | Read-only `_WIN32`/x86/OpenGL/SDL conditionals and toolchain probe | `/Users/jk/.codex/worktrees/3266/acgc-modern-port` (retired) | Complete/parked; portable native and ASan/UBSan 18/18 pass; MinGW i686/PE/Windows SDL toolchain unavailable, so no Windows compile/link/launch sign-off |
| 43 | Current native + ASan/UBSan matrix — `019ffa12-8a7e-76b0-9503-2f4394249e43` | Exact-tip focused test matrix; unique sanitizer build roots | `/Users/jk/.codex/worktrees/dc19/acgc-modern-port` (retired); provenance `03f1854e` / `c1/lane-sanitizer-724` | Complete/parked; native, ASan, and UBSan each 38 passed/3 expected skips/0 failures; no full link, device, or playability claim |
| 44 | ac-decomp GAFE01 toolchain audit — `019ffa12-929c-73e3-b706-a4f76c78a270` | Read-only configure/build/extraction boundary and Wine/Metrowerks blocker | `/Users/jk/.codex/worktrees/90c1/acgc-modern-port` (retired); retry logs `/private/tmp/acgc-lane-acdecomp-audit-retry` (retired) | Complete/parked; `python3 configure.py` generates Ninja, but `ninja -j1` stops at missing `orig/GAFE01_00/files/foresta.rel.szs`; no Wine/Metrowerks, extraction, native build, or runtime claim; GAFE01 config/build metadata match both upstreams |
| 45 | iOS shared-boundary readiness — `019ffa12-9809-7c21-b1e2-67f4f7bd52c5` | Read-only portable/Apple boundary map; iOS remains gated by macOS proof | `/Users/jk/.codex/worktrees/b09c/acgc-modern-port` (retired); branch `c1/ios-shared-boundary-readiness` | Complete/parked; integrated handoff `plans/IOS-SHARED-BOUNDARY-READINESS.md` (`d303b7f`); portable 18/18 and Apple 10 plus 2 Metal skips, ASan/UBSan same, serialized 4,011/4,011 audit link; no game-loop, live Metal pixel, input, audio, save, lifecycle, simulator, device, or playability claim |
| 46 | Game cleanup invalid-free successor — `019ffa28-3ef7-7280-923c-5a01bf2eb4c2` | `src/game/m_field_make.c`, `src/game/m_play.c`, `src/graph.c`, `src/static/libc64/__osMalloc.c`; exact TERM/allocator fault | `/private/tmp/acgc-lane-game-cleanup-invalid-free/source` (retired); `c1/lane-game-cleanup-invalid-free` | Complete/integrated at source `09dd182`; `mFM_MakeField` now uses `zelda_malloc_align` without a `u32` round-trip; native, ASan/UBSan, and UBSan fixture passes; exact integrated 4,011/4,011 arm64 build passes; 10-second LOGO/NEOS run and TERM grace return status `0`; no Metal/pixel/input/audio/save/playability claim |
| 47 | Production CARD Save_t reload recovery — `019ffa49-4f44-7b73-a4ab-8c45dc211f14` | `pc/src/pc_m_card.c` plus focused `pc/tests/` restart/corruption fixture only; production atomic write/restart/reload gate | `/private/tmp/acgc-lane-card-save-recovery/source` (retired); `c1/lane-card-save-recovery` preserved at `9e3bb99`; build root retired | Complete/integrated at source `5548570`; native and ASan+UBSan production fixture pass; validates checksum/identity, embedded-backup recovery, restart reload, and prior-generation `.bak1` fallback; full game save-manager/device/playability claims remain open |
| 48 | Post-fix game-owned GX submission trace — `019ffa49-4f9c-7da2-a288-5791e5cf5c93` | Read-only `graph_task_set00` → emu64/GX → `pc_gx` handoff and packet/terminator boundary | `/Users/jk/.codex/worktrees/1a7c/acgc-modern-port` (retired); isolated root `/private/tmp/acgc-lane-postfix-gx-submission` (retired) | Complete/archived; evidence is pinned to source `09dd182` and decomp `09ca8e8b`; live prefix remains incomplete (8/256 words, no terminator), stable OpenGL handoff reaches `pc_gx_flush_vertices`; Metal consumer skip `77`; no Metal/pixel/input/audio/save/simulator/device/playability claim |
| 49 | Exact-tip native + ASan/UBSan refresh — `019ffa4c-8734-7ac2-99d1-f67a0682be31` | Read-only focused matrix at source `09dd182`, including field-cleanup fixture and portable/Apple contracts | `/Users/jk/.codex/worktrees/b872/acgc-modern-port` (retired); build/log root `/private/tmp/acgc-lane-sanitizer-refresh-20260812` (retired) | Complete/archived; Luna Max/max; native 36/3/0 and ASan 36/3/0; UBSan 35/3/1 with the unchanged 11-site `aflags_c` issue; no frame, input, audio, save, simulator, device, or playability claim |
| 50 | Complete game-owned graph capture contract — `019ffa71-2a81-7821-b333-7072a7cfb941` | `include/acgc/graph_submission.h`, `src/graph_submission.c`, `src/graph.c`, focused capture tests; complete-list/terminator gate | `/private/tmp/acgc-lane-complete-graph-capture/source` (retired); `c1/lane-complete-graph-capture` preserved at `1d1cd8f`; build roots retired after review | Complete/integrated at source `6e4aded` (current tip `9cf9b3f`); native and ASan/UBSan focused tests pass; observed live prefix is `PREFIX_ONLY`, so no draw/frame claim |
| 51 | Game GX-to-Metal handoff seam — `019ffa71-2a81-7821-b333-70541a9193f4` | `pc/src/pc_gx.c`, `pc/apple/src/metal_packet_consumer.c`, focused Apple/PC tests; fail-closed optional Metal handoff | `/private/tmp/acgc-lane-gx-metal-handoff/source` (retired); `c1/lane-gx-metal-handoff` preserved at `26bcc02`; build roots retired after review | Complete/integrated at source `e22cbc5` plus `9cf9b3f`; native and ASan/UBSan handoff pass, Apple CPU contracts pass, Metal device checks skip `77`; no live encode/present/pixel claim |
| 52 | Full game save-manager restart gate — `019ffa71-2b0b-7170-9364-d468ea35c57b` | `pc/src/pc_m_card.c` plus focused mCD_SaveHome_bg request/restart tests; connect production slot recovery to game-owned orchestration | `/private/tmp/acgc-lane-full-save-manager/source` (retired); `c1/lane-full-save-manager` preserved at `0465f54`; build root retired | Complete/integrated at source `a7b9dff`; native and ASan/UBSan restart/recovery PASS; proves one game-owned request seam, not full CARD state/device/playability |
| 53 | Post-link graph runtime trace → exact-tip runtime successor — `019ffa9b-2ac8-7332-ab68-8ba731696cd8` | One serialized full `ac_pc` link and bounded arm64 launch/LLDB trace at current `02a003e`; no source edits | Canonical source only; build `/private/tmp/acgc-lane-exact-tip-runtime-build`; logs `/private/tmp/acgc-lane-exact-tip-runtime-logs`; no branch | Complete/archived after review; boot and game-owned graph path reached, root classified `INDIRECT` (`8/256`), no target resolution or frame claim; evidence `docs/evidence/POST-LINK-GRAPH-RUNTIME-02A003E-2026-08-13.md` |
| 54 | Live GX-to-Metal callback wiring — `019ffa9b-2ac8-7332-ab68-8b8a6a71bda9` | `pc/src/pc_gx.c`, Apple packet-consumer header/source, focused callback tests; optional handoff reachability | `/private/tmp/acgc-lane-live-gx-metal/source` (retire after review); `c1/lane-live-gx-metal` preserved at `1dec37f`; focused roots listed in evidence | Complete/integrated at source `ac39d04`; native and ASan/UBSan CPU contracts pass, device tests skip `77`; no live game encode/present/pixel claim |
| 55 | Save_t raw-wire losslessness — `019ffa9b-2dde-7d83-9b26-55dc271cac37` | `pc/src/pc_save_bswap.c` plus focused wire fixtures; preserve exact GCI semantics or stop test-only | `/private/tmp/acgc-lane-save-wire-lossless/source` (retire after review); `c1/lane-save-wire-lossless` preserved at `315f040`; build `/private/tmp/acgc-lane-save-wire-lossless-build` | Complete/integrated at source `d0e64f5`; test-only forensic coverage proves pre-fix `0xF10E→0x0000` and current native/ASan/UBSan roundtrip PASS; no full game persistence claim |
| 56 | Running-game input trace — `019ffa9b-2ea7-7741-87eb-9fd0c3e88557` | Read-only current-tip SDL/PADRead snapshot observation with one bounded OS-event attempt | `/Users/jk/.codex/worktrees/f19d/acgc-modern-port` (archive); logs `/private/tmp/acgc-lane-runtime-input` (retire after evidence); no source branch | Complete/parked; live SDL/PADRead boundary observed, OS event unavailable and no state transition; no running-game input claim |
| 57 | Current Windows regression audit — `019ffa9b-34a6-7813-a48c-2e8c43dcccdc` | Read-only `_WIN32`/x86/OpenGL/SDL audit for graph/GX changes at `9cf9b3f` | `/Users/jk/.codex/worktrees/18c7/acgc-modern-port` (archive); logs `/private/tmp/acgc-lane-windows-current` (retire after evidence); no source branch | Complete/parked; C/syntax probes pass with no regression, real i686 Windows targets blocked by missing sysroot/MinGW; no Windows sign-off |
| 58 | Activate graph capture runtime hook — `019ffaad-ca28-7c62-bd0f-018d6d82d6d3` | Read-only bounded runtime with exact graph-capture switch; distinguish disabled hook from incomplete live prefix | `/Users/jk/.codex/worktrees/41ac/acgc-modern-port` (retire after review); logs `/private/tmp/acgc-lane-graph-capture-activation`; no source branch | Complete/parked; `ACGC_GRAPH_CAPTURE=1` enabled the hook and emitted one cleanly terminated `8/256` prefix; no resolved indirect target, complete packet, or frame claim |
| 59 | GBI indirect target audit → graph-target source/test successor — `019ffaad-ca28-7c62-bd0f-0176ceb55e52` | Source/test owner for live F-handle resolution, target-capacity traversal, and exact terminator proof; prior audit remains in evidence | `/private/tmp/acgc-lane-graph-indirect-target/source` (retire after review); branch `c1/lane-graph-indirect-target` preserved at `e501d4b`; integrated PC `71a7012`; build roots `/private/tmp/acgc-integrate-graph-target-71a7012-native` and `-asan` | Complete/integrated; focused native and ASan/UBSan tests pass `3/3` each; no live complete-list or frame claim |
| 60 | Game-owned save caller audit → runtime save/restart successor — `019ffaad-cd2e-7ec3-8848-f0d409c6969c` | Source/test owner for restart caller → GCI marker → fresh-process reload gate; prior audit remains in evidence | `/private/tmp/acgc-lane-game-save-runtime/source` (retire after review); branch `c1/lane-game-save-runtime` preserved at `fcc3e7d`; integrated PC `02a003e`; build `/private/tmp/acgc-integrate-save-runtime-02a003e`; no umbrella edits | Complete/integrated; production caller-driven native and combined ASan/UBSan fixture PASS; no full device/playability claim |
| 61 | Sanitizer refresh ac39d04 — `019ffaad-cd4e-75d1-9e66-fdba9881de79` | Focused native + ASan/UBSan callback/save/graph matrix; unique build roots | `/Users/jk/.codex/worktrees/4ce5/acgc-modern-port` (retire after review); builds `/private/tmp/acgc-lane-sanitizer-ac39d04-native` and `/private/tmp/acgc-lane-sanitizer-ac39d04-asan`; no source branch | Complete/parked; 3 passes + 2 declared Metal-device skips per matrix, 0 failures; no sanitizer diagnostics or runtime-gate claim |
| 62 | Live indirect graph target resolver — `019ffae5-a0c2-7140-b30a-2c33c2eeba89` | `src/static/libforest/emu64/emu64.c` `dl_G_DL` observer plus focused target-capture fixture; explicit capacity/terminator and stale-handle gate | `/private/tmp/acgc-lane-live-target-resolver/source` / `c1/lane-live-target-resolver`; builds `/private/tmp/acgc-lane-live-target-resolver-build` and logs `/private/tmp/acgc-lane-live-target-resolver-logs` (retire after review) | Complete/integrated at source `aea3515`; native and ASan/UBSan focused CTest `3/3` each; live fixture resolves `F0002000` to 1024-word `new0`, terminator index 10, stale-handle fail-closed; no game launch/frame claim; evidence `docs/evidence/LIVE-GRAPH-TARGET-RESOLVER-2026-08-13.md` |
| 63 | Current-tip live target runtime trace — `019ffafc-8480-7ba0-a1a7-497f9db415ef` | One serialized full `ac_pc` link and bounded arm64 LLDB launch at PC `aea3515`; target capture/terminator/termination evidence only | Canonical source only; build `/private/tmp/acgc-lane-current-target-runtime-build`; logs `/private/tmp/acgc-lane-current-target-runtime-logs`; no source branch | Complete/archived; `4,013/4,013` link passed, but launch ran from the delegated worktree and exited before graph boot on missing relative shaders; no retry, target/frame/pixel/playability claim; evidence `docs/evidence/CURRENT-TIP-LIVE-TARGET-RUNTIME-2026-08-13.md` |
| 64 | Correctly rooted current-tip runtime successor — `019ffb13-9e1b-7441-ade3-04b6cbfd9508` | One serialized current-tip arm64 build-or-reuse check and exactly one LLDB launch from generated `bin` so relative shaders resolve; target/terminator/termination evidence only | Canonical source only; build `/private/tmp/acgc-lane-correct-rooted-runtime-build`; logs `/private/tmp/acgc-lane-correct-rooted-runtime-logs`; no source branch | Complete/archived; `4,013/4,013` link passed, but LLDB rejected unsupported `target.process.working-dir` before `run`; no inferior, no graph/target/frame/pixel/playability claim; evidence `docs/evidence/CORRECT-ROOTED-RUNTIME-2026-08-13.md` |
| 65 | Valid-LLDB current-tip runtime successor — `019ffb25-df74-7811-88ef-ed54f688841f` | One serialized current-tip arm64 build-or-reuse check and exactly one LLDB launch using independently verified `target.launch-working-dir`; target/terminator/termination evidence only | Canonical source only; build `/private/tmp/acgc-lane-valid-lldb-runtime-build`; logs `/private/tmp/acgc-lane-valid-lldb-runtime-logs`; no source branch | Complete/archived; `4,013/4,013` link passed; live `F0002000` target call (`capacity=1024`) and GX/PC boundaries reached, but no `DF000000,00000000` terminator appeared and TERM ended the run; no complete frame/pixel/playability claim; evidence `docs/evidence/VALID-LLDB-LIVE-TARGET-RUNTIME-2026-08-13.md` |
| 66 | Live target terminator forensic — `019ffb3a-b7e3-73e1-80e5-0891c749daba` | Read-only crosswalk of live `F0002000` pointer/capacity versus `sys_dynamic.new0` fixture span; optional focused probe only, no full link/launch | Canonical source audit; worktree `/Users/jk/.codex/worktrees/431d/acgc-modern-port`; focused root `/private/tmp/acgc-lane-live-target-terminator-forensic`; owns `emu64.c`, `graph.c`, `graph_submission.c`, and graph-target fixtures only | Complete/archived; live capacity `1024` proves `new0[0]`; `new0` is a continuation arena whose local bytes branch to `F0002001`, while the fixture’s terminator is synthetic; live target callback is unset; focused native/ASan/UBSan reruns pass; evidence `docs/evidence/LIVE-TARGET-TERMINATOR-FORENSIC-2026-08-13.md` |
| 67 | Opt-in live target observer — `019ffb49-326e-78e2-8ec8-eb0cadb94fbe` | Source/test owner for installing the existing target-capture callback under `ACGC_GRAPH_CAPTURE=1`, with off-by-default coverage; no full link/launch | Isolated worktree `/Users/jk/.codex/worktrees/cd32/acgc-modern-port/upstream/ACGC-PC-Port` (retire after review); branch `c1/lane-live-target-observer` at `f25d717`; integrated PC `36910c8`; focused root `/private/tmp/acgc-integrate-live-target-observer` | Complete/archived; only `pc/src/pc_main.c` changed; host object compile and existing live-target fixture pass native and combined ASan/UBSan `1/1` each; no full link, live target record, complete-list, Metal, pixel, input, audio, save/load, device, or playability claim; evidence `docs/evidence/LIVE-TARGET-OBSERVER-2026-08-13.md` |
| 68 | Live target observer runtime trace — `019ffb59-b04f-7322-a8ca-0a46c67321a0` | One serialized arm64 `ac_pc` link and exactly one LLDB launch at integrated PC `36910c8`; seek game-owned `[GRAPH_TARGET_CAPTURE]` and `F0002001` continuation evidence only | Isolated worktree `/Users/jk/.codex/worktrees/0378/acgc-modern-port`; detached source worktree at integrated `36910c8`; build `/private/tmp/acgc-lane-live-target-observer-runtime-build`; logs `/private/tmp/acgc-lane-live-target-observer-runtime-logs`; no source edits | Complete/archived; configure/build exit `0`, terminal `[4012/4013]` progress caveat; fresh target record `F0002000`, capacity `1024`, `INDIRECT`, no local terminator, words contain `F0002001`; LOGO/NEOS reached, TERM/grace no KILL; GX unobserved; no full-list/Metal/pixel/input/audio/save/device/playability claim; evidence `docs/evidence/LIVE-TARGET-OBSERVER-RUNTIME-2026-08-13.md` |
| 69 | Live GX boundary runtime trace — `019ffb68-3324-7a80-a69d-fc9359687355` | One read-only LLDB launch with pre-run breakpoints at GXBegin and pc_gx_flush_vertices, retaining the target observer record; no source edits | Isolated worktree `/Users/jk/.codex/worktrees/8197/acgc-modern-port` (retire); source `/private/tmp/acgc-lane-live-gx-boundary-runtime-source` (retire); build `/private/tmp/acgc-lane-live-gx-boundary-runtime-build` (retire); logs `/private/tmp/acgc-lane-live-gx-boundary-runtime-logs` (retire); no source branch | Complete/archived; build exit 0 with terminal `[4012/4013]`, LLDB setup accepted both symbols but launch failed before an inferior with `status -1` plus unprivileged `nice(5)`; no boot, breakpoint, GX, Metal, pixel, or playability claim; evidence `docs/evidence/LIVE-GX-BOUNDARY-RUNTIME-2026-08-13.md` |
| 70 | Metal bridge architecture audit — `019ffb8b-728b-7c93-9d3a-fc9222eb26fe` | Read-only crosswalk from game-owned `pc_gx_flush_vertices` to existing Apple semantic packet/Metal consumer; no source edits, builds, or launches | Worktree `/Users/jk/.codex/worktrees/4513/acgc-modern-port` already absent; no build/log root | Complete/archived; proves the registration/build gap, resident-texture gate issue, and CPU-only consumer boundary; no frame or playability claim |
| 71 | Darwin GX handoff registration — `019ffb94-738f-70c3-9344-a194b74022af` | Apple-only `AcgcMetalPacketConsumerHandoffContext` registration, narrow resident-versus-active texture gate correction in `pc_gx.c`, bounded callback/status telemetry, and focused fixture; no shader, decomp, or Windows changes | Worker `/Users/jk/.codex/worktrees/e0ac/acgc-modern-port` (preserved dirty/held); source branch `c1/lane-darwin-gx-registration` at `9174404b`; integrated canonical source `f4cb491`; focused roots retired after review | Complete/integrated; native and ASan/UBSan focused CTest `1/1` each; no full link, live callback, Metal encode/present/pixel, or playability claim |
| 72 | Live Apple GX callback observation — `019ffba9-3c9b-7713-82a4-ae102ad4715b` | Read-only current-tip full link plus exactly one no-`nice` LLDB launch; breakpoint on `pc_metal_runtime_observe` and `pc_gx_flush_vertices`; no source edits | Worktree `/Users/jk/.codex/worktrees/a240/acgc-modern-port` already absent; build/log roots retired after review | Complete/archived; link `0`, arm64 Mach-O, LLDB pre-inferior `nice(5)` failure with zero breakpoint hits; callback reachability inconclusive; no Metal encode/present/pixel/playability claim; evidence `docs/evidence/LIVE-DARWIN-GX-CALLBACK-RUNTIME-2026-08-13.md` |

## Parked intake (not active)

These bounded successors were requested with Luna Max/max reasoning and distinct
ownership, but their client-only IDs never became durable visible tasks or
isolated worktrees. They are retained as historical roadmap ideas only and are
not counted as active or eligible for refill until a later dependency-ready
request creates a durable task with the full reference-first contract required
by `AGENTS.md`.

| Planned lane | Client task ID | Ownership / first evidence |
| --- | --- | --- |
| Frame evidence harness | `client-new-thread:c510c55b-ce41-4e3a-b731-5044e2408da6` | Umbrella `scripts/probes/` only; fail-closed launch/boot/packet/present/frame labels |
| Arm64 post-texture ABI audit | `client-new-thread:aa0ce132-2742-4577-bca2-5698cbade79c` | Read-only GAME/GRAPH width/range scan; no full link |
| ac-decomp GAFE01 build audit | `client-new-thread:1249787f-4597-4ec3-9dd0-518a28290af4` | Separate `upstream/ac-decomp` revision/configure/toolchain evidence |
| Save_t raw-wire preservation follow-up | `client-new-thread:990b558a-7152-4205-949a-3c2215e113d9` | `pc_save_bswap` and focused wire-roundtrip proof only |
| Windows x86 cross-compile probe | `client-new-thread:1cc25514-49e4-466c-b76a-461c645b8cd4` | Read-only i686/MinGW/strict `_WIN32` availability and compile evidence |
| iOS shared-boundary readiness audit | `client-new-thread:64b5daf8-a303-4428-870f-9f011774ac9f` | Read-only portable vs AppKit/Metal/CoreAudio boundary map; no iOS source |
| Post-texture graph-fault continuation | `client-new-thread:6240fbda-a36c-409f-89b3-66a3878fe6bd` | `src/game.c`/graph ABI only after texture integration; next real arm64 stop |
| Live-prefix decoder contract | `client-new-thread:faa2fa6c-c564-4f4b-9b0b-268c904e9fde` | Fail-closed decoder/packet fixtures for the observed 8-word prefix |
| Metal frame-evidence harness | `client-new-thread:fb45f25e-4bf5-43ae-afc5-e10117d7620f` | Packet/encode/present/readback gate; record no-device result without pixels claim |
| Asset-audio runtime gate | `client-new-thread:f0a79adc-ad4d-4350-bdce-38cdd8c8657b` | NEOS_OUT-to-sink evidence separated from synthetic PCM and audibility |
| Audio DMA LP64 source fix | `client-new-thread:370c3642-5817-47e5-9ec1-6334af650c40` | `system.c` only; reproduce and fix the `0x84c5e0` truncated audio pointer, with one serialized build and runtime trace |
| Audio DMA pointer fixture | `client-new-thread:151827fb-3aa0-476c-ac93-f3ab807b8fb7` | Test-only `pc/tests/pc_audio_dma_pointer_fixture.c`; no production audio edits; native/ASan width regression |
| Post-audio boot trace | `client-new-thread:c1e4496c-1d1a-47f0-8ae3-fadfb3cc1770` | Read-only LLDB evidence after the audio fault boundary; unique logs, no source edits |
| Current sanitizer refresh | `client-new-thread:018acc6f-fec7-4f3b-8795-03627ad5c09b` | Read-only native plus ASan/UBSan at current source tip; unique build roots and serialized full links |
| Runtime save restart gate | `client-new-thread:c00febc3-0362-4c72-a99d-cac119c7e0a2` | Umbrella probe/evidence only for save request → atomic write → restart → reload; preserves raw-wire mismatch |
| Frame evidence packaging | `client-new-thread:890ae77b-685a-4c69-ab22-429c7ddad9a2` | Umbrella `scripts/probes/` and `docs/evidence/` only; fail-closed submit/encode/present/readback labels |
| Raw audio-bank ABI design audit | `client-new-thread:8c52eb22-8ce9-4952-b695-7f7568855f5c` | Read-only wire/native layout map for `Nas_BankOfsToAddr_Inner`; no source edits or full link |
| Audio-bank wire fixture | `client-new-thread:be5c06e2-5d95-4758-b9ba-c607bb5679d6` | Test-only `pc/tests/pc_audio_bank_wire_fixture.c`; synthetic high-address/fail-closed offset cases |
| WaveTouch LP64 wire audit | `client-new-thread:f9c69af2-66c4-4d32-a142-c6b62b79345b` | Read-only `__WaveTouch`/`smzwavetable` width and relocation audit; separate from `system.c` edits |
| ac-decomp audio-bank cross-reference | `client-new-thread:944f3f31-ffe6-456c-8445-412dbfb9df59` | Read-only GAFE01_00 cross-repo schema/build comparison; no upstream edits or asset output |

The Codex-created umbrella worktrees begin detached at umbrella commit
`82732fe` with nested submodules uninitialized. Source-edit lanes therefore use
the explicit source worktrees listed above. No lane should initialize nested
submodules blindly or edit a detached source checkout.

## Evidence already integrated

- `9b1c48f` / `3a6582d` are integrated on `c1/macos-host-launch`; the SDL/CoreAudio
  boundary and CARD host-transfer probes pass, but they do not prove audible
  mixer output or GameCube Save_t/GCI persistence.
- `e5442de` adds the injectable, fixed-width PC input snapshot boundary; its
  focused source test passed. `858d802` now routes the exact final `PADRead`
  handoff through that snapshot and passes native plus ASan/UBSan tests.
- `8b6849f` adds the SDL virtual-controller/event smoke harness. The real
  `PADInit`/`PADRead` controller path passes 2/2 natively and under ASan/UBSan;
  queued keyboard events are delivered but do not alter SDL keyboard state, so
  the input lane is parked pending OS/human keyboard and physical-device proof.
- `e03ffed` adds a pointer-free graph submission capture seam. `10d6ac0` adds
  an opt-in Darwin callback and moves the bounded copy immediately after
  `JW_BeginFrame`, before the legacy emu64 texture setup. The focused legacy
  seam test passes. A fresh LLDB run reaches the callback with version `1`,
  frame `0`, source capacity `256`, count `8`, and the fixed-width words
  `de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000`.
  This is the first live game-owned submission prefix, not a synthetic draw.
- After the capture, the same run stops at `pc_gx_texture.c:62` while
  `tex_content_hash` follows `data=0x83bdc0` from a truncated 32-bit texture
  object. That is the next source-fix gate; no rendered frame is claimed.
- Two cold runs through the ignored ISO symlink reproduce the exact same
  version/frame/capacity/count/word prefix and the same texture fault. This
  makes the capture deterministic evidence, not a one-run debugger artifact.
- The integrated forensic fixture `07a5447` reproduces the same width loss
  without a game launch: `GXInitTexObj` stores only the low 32 bits after the
  opaque GBI handle resolves, and `GXGetTexObjData` returns that truncated
  value. It is an intentional `EXPECTED_FAILURE` invariant, not a fix.
- `5086f1d` reloads `GAME.graph` after the callback that corrupts the local
  callee-saved register. The patched arm64 run reaches the first
  `graph_task_set00` call; it is the prerequisite for the live capture in
  `10d6ac0`, not a rendered-frame claim.
- `83fa889` is the integrated renderer-neutral GX packet contract. It is a
  4,800-byte fixed-width packet with strict malformed-input rejection; native,
  Apple-entrypoint, and ASan/UBSan focused tests pass. It is not live-game
  evidence.
- `866dd94` adds Metal geometry/state fixtures. CPU and existing geometry tests
  pass; the offscreen Metal test is skipped because this host reports no Metal
  device.
- `12b4f6e` adds a bounded GX-packet-to-Metal consumer fixture. It validates
  the existing fixed-width packet, composes transforms, routes material and
  texture/TEV fixture colors, and rejects unsupported topology without
  truncation. The CPU contract passes; the offscreen encoder path skips on this
  host with no Metal device. It is not live-game frame or pixel evidence.
- `d0ae08d` adds the reviewed graph-capture-to-GX handoff adapter. It validates
  capture bounds, refuses empty/incomplete snapshots, invokes only an explicit
  decoder for a complete capture, and re-validates the resulting packet. The
  observed live shape (`de010000,f0002000` plus zero words, count 8/capacity
  256) returns `INCOMPLETE_CAPTURE` without invoking a decoder. From the
  authoritative source checkout, the focused adapter/C/C++ packet suite passed
  `3/3` under `/private/tmp/acgc-integrated-gx-adapter-build`; this is a
  fail-closed seam, not a draw or frame claim.
- The bounded activation run in
  `docs/evidence/GRAPH-CAPTURE-ACTIVATION-2026-08-13.md` proves the
  source-supported `ACGC_GRAPH_CAPTURE=1` switch reaches the live observer and
  emits one `8/256` record before a clean TERM exit. The `DE010000 F0002000`
  shape remains an unresolved indirect edge; no complete list,
  encode/present/readback, or frame claim follows.
- The GBI indirect-target audit in
  `docs/evidence/GBI-INDIRECT-TARGET-AUDIT-2026-08-13.md` maps that edge from
  `sys_dynamic.work` into the separate `sys_dynamic.new0` arena through a
  live PC registry capability. A resolving successor must retain target
  identity/capacity and require `DF000000,0`; the bounded root cannot supply
  those bytes by itself.
- The exact-tip sanitizer refresh in
  `docs/evidence/SANITIZER-REFRESH-AC39D04-2026-08-13.md` passes three focused
  fixtures with two declared Metal-device skips per native and ASan/UBSan
  matrix, with no sanitizer diagnostics; it remains fixture-only evidence.
- The game-owned Save_t/CARD caller audit in
  `docs/evidence/GAME-SAVE-CALLER-AUDIT-2026-08-13.md` identifies the restart
  NPC `aNRST_save` → `mCD_SaveHome_bg(0, ...)` path as the smallest real
  persistence gate. The host recovery fixture remains below that caller
  boundary, so no game-level persistence claim follows.
- `ddbb498` adds fixed-width texture/TLUT/sampler/TEV fixtures, including
  CI14x2 and CMPR reference cases. The integrated Apple fixture test passes;
  no texture upload/readback, shader wiring, or game-renderer evidence is
  claimed.
- `766ad96` adds a synthetic probe through `Jac_VframeWork`,
  `MixInterleaveTrack`, `AIInitDMA`, and the SDL callback. Exact PCM and ring
  drain pass natively and under ASan; no device/audible proof is claimed.
- `2736838` adds the next audio provenance boundary: four real `A_INTERLEAVE`
  command batches pass through the RSP/Neos-style path, triple buffer, DAC
  handoff, and callback with 1,118 nonzero samples in native and ASan runs.
  The follow-up real SDL/CoreAudio probe returns declared skip `77` because
  `kAudioDevicePropertyDeviceIsAlive` reports `560947818`; it does not prove
  asset-driven `NEOS_OUT`, CoreAudio output, or human audio.
- Umbrella evidence commits `15a081f`, `ee7b814`, and `fe21878` record
  synthetic lifecycle, sandboxed atomic-save, and arm64/sanitizer matrix gates.
- Umbrella commits `3b8ed21` and `aeefc15` record Save_t/GCI layout and codec
  evidence: canonical/checksum/codec-only restart passes, but the active layout
  places `time_limit` at `+0x02` and the current repacker drops the low 16 bits
  of the raw unit (`wire=0xF10E -> roundtrip=0x0000`). No canonical wire-zero
  rule is justified; exact GCI envelope length, runtime save-manager restart,
  main/backup recovery, and whole-GCI losslessness remain open.
- Umbrella commit `38f85da` records the current focused matrix at exact
  `858d802`: 32 native and 32 ASan/UBSan targets built; portable 14/14, PC 4
  passed with CoreAudio skipped, Apple 6 passed with Metal skipped, and no
  sanitizer/runtime-error findings. This is snapshot evidence, not full
  `ac_pc` or game-frame proof; the source checkout later advanced to `8b6849f`.
- The Windows audit found no regression in `4f77dab` and preserves the x86
  guards, and the post-capture audit at `10d6ac0` also passes strict `_WIN32`
  graph seam compile/test probes. No MinGW/i686 compiler or Windows sysroot is
  installed, so native Windows/x86 translation and link remain unproven. The
  Apple-only capture logger is redirected unless verbose/profile output is
  enabled; this does not affect Windows behavior.
- `dfb3f7f` is integrated as `4f77dab`: the PC disc-backed DVD host accepts the
  GameCube 32-byte sector-tail transfer for 19-byte `COPYDATE` while rejecting
  malformed ranges. Native and ASan/UBSan focused probes pass.
- A fresh arm64 run against the DVD lane reaches `COPYDATE`, string-table
  completion, `JW_Init2`, `HotStartEntry`, both forest archives, and Famicom
  archive loading, then stops at `EXC_BAD_ACCESS` in `game.c:154` while entering
  `graph_proc`. This is not a rendered-frame proof.
- Source commit `671171c` adds the bounded LP64 audio-bank decoder and fixture,
  widens the remaining launch-critical pointer arithmetic, preserves static
  segmented matrix words, widens the train engineer actor field, and guards
  audio lookup when a bank is marked loaded before its native table exists.
  The authoritative branch builds `ac_pc` successfully at
  `/private/tmp/acgc-lane-audio-lp64-build`; the focused native audio fixture
  passes 1/1, emu64 native tests pass 3/3, and the ASan/UBSan emu64 matrix passes
  3/3 at `/private/tmp/acgc-emu64-sanitize-build`.
- Fresh ignored-ISO arm64 runs now load all ten FST entries, both forest
  archives, Famicom data, the audio banks 2/155/154/153, and the game-owned
  `LOGO draw` path. The pre-guard run stopped in `ProgToVp` at
  `channel.c:406` because bank 28 was marked loaded while its LP64 decode was
  rejected (`3376` bytes); the guard changes this to bounded audio-error logs
  (`instrument_table_null`/`percussion_table_null`). A post-guard bounded run
  survives to `NEOS_OUT frame=1741` before the harness terminates it. This proves
  launch survival through that boundary only; it does not prove a visible frame,
  asset-driven audio, input, save/load, or playability.
- Source lane commit `5974764`, integrated as `909f3ca`, accepts only zero-valued
  truncated percussion tails, maps wire `MEDIUM_CART` wave offsets onto the
  native ARAM base, and adds focused fixtures for both rules. The authoritative
  `ac_pc` build returns `0`; the audio fixture passes `1/1`, and the existing
  native and ASan/UBSan emu64 tests pass `3/3` each. A fresh run from that exact
  source snapshot logs bank-28 decode and `[LOGO] draw`; its captured screen is
  the first identifiable game-owned frame. The run then exits `139`, so no
  clean-shutdown, representative GX/Metal, input, audible-audio, save/load, or
  playability claim follows. The integrated commands were
  `cmake -S pc -B /private/tmp/acgc-integrated-audio-wave-build
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_BUILD_TYPE=Debug`,
  `cmake --build /private/tmp/acgc-integrated-audio-wave-build --target ac_pc
  acgc_pc_audio_bank_wire_fixture --parallel 4`, and
  `ctest --test-dir /private/tmp/acgc-integrated-audio-wave-build
  --output-on-failure -R '^acgc_pc_audio_bank_wire_fixture$'`.
- Umbrella commit `adc1d6e` integrates the frame-evidence parser and report from
  lane `019ff9a0-f9be-73a0-a452-02a309e5baa5`. `PYTHONDONTWRITEBYTECODE=1
  python3 -B scripts/probes/frame_evidence.py --self-test` passes. A rerun
  bound to clean source `909f3ca` returns `NOT_CLAIMED` with explicit missing
  `game_owned_submit`, `game_encode`, `game_present`, `visible_window`, and
  `game_readback` prerequisites; it does not override the separately recorded
  screenshot-based identifiable-frame evidence.
- The completed boot trace resolves the failing arm64 store as
  `strb w8, [x22,#0x474]` for `GRAPH_SET_DOING_POINT(graph, GAME_BGM)` with
  computed bad base `0x100000000`; `graph_task_set00` is never hit. Its next
  source successor owns only `src/game.c`, `include/graph.h`, and directly
  necessary ABI/callback tests on `c1/lane-graph-fault`; `5086f1d` is the
  reviewed one-line reload repair.

## Integration order

1. Preserve the first live capture (`10d6ac0`) as the fixed-width input to the
   GX adapter lane. Keep renderer translation separate from frame proof, and
   retain the exact observed prefix even though it currently fails closed.
2. When a lane completes, inspect its final evidence immediately, mark it
   integrated/rejected/parked here, and refill only with a useful dependency-ready
   successor. The input lane is parked because its remaining gate requires an
   OS/human event or physical controller; no synthetic filler replaces it.
3. The LP64 texture-object fault is repaired at source `578c8b7`, and the
   audio-bank wire/native mismatch is integrated at `909f3ca`. The first
   identifiable game-owned frame is now evidenced; the next bounded lane is a
   post-frame crash/fault trace, followed by representative GX-to-Metal
   encode/present/readback. Keep the `83fa889`, `866dd94`, and `ddbb498` fixture
   contracts separate from live-frame proof.
4. Keep Save_t/GCI parked on the explicit raw-range mismatch until the codec
   preserves arbitrary bytes or a proven wire-format boundary is established;
   do not weaken the roundtrip test. Filesystem adapter, lifecycle, and
   verification evidence remain synthetic/portable boundaries.
5. Refresh the native and sanitizer matrix at the integrated
   `c1/macos-host-launch` source HEAD after the audio fix, then separately prove input, audio
   device/audibility, save/load, simulator, physical device, and playability.
6. iOS implementation remains gated behind proven shared macOS core, renderer,
   input, audio, persistence, and lifecycle behavior.

No lane may push, publish, deploy, install, sign, submit, or redistribute the
ISO, extracted assets, keys, or proprietary game data.
