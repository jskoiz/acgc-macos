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
Placement policy: lane 111's local runtime/cleanup state remains on this Mac
until its owner-managed handoff is safe. Future focused source, test, and audit
lanes are to be handed to the configured remote M3 Max host with isolated
worktrees and ignored roots. Full `ac_pc` links and LLDB launches remain
serialized across both hosts. True cloud tasks are planning/review only; the
ISO, extracted assets, keys, and proprietary data remain local and ignored.
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

## Remote M3 Max batch (current)

The M3 Max Screen Sharing/SSH connection is online and the source-only remote
checkout has been independently verified at umbrella `ee31f53`, PC
`a53b192`, and decomp `09ca8e8b`, all clean. No ISO, extracted assets, keys, or
proprietary data were transferred. The old local lane-115 handoff remains
parked because the handoff registry could not match the saved remote project;
the following visible remote Codex tasks were opened from the registered remote
project instead. They use `gpt-5.6-luna` with max reasoning, keep full links and
LLDB serialized, and do not update the umbrella checkout.

- Lane 116 / task `019fff00-d312-73a0-8396-d94c6618e0b8` — complete pending
  root review. Remote PC worktree `/private/tmp/acgc-lane-gx-v4-channel-diagnostic-m3`
  on `c1/lane-gx-v4-channel-diagnostic-m3`, base `a53b192`, final `e8155c6`.
  The V4-only channel predicate now accepts decomp-compatible disabled
  `GX_SRC_REG`/`GX_SRC_VTX` material sources while retaining enabled/lighting
  rejection; native and combined ASan/UBSan focused tests pass `4/4` each with
  no diagnostics (`detect_leaks=0`). No live callback, Metal, pixel, or
  playability claim; preserve the worktree/branch until integration review.
- Lanes 117–127 are active on the remote M3 Max with non-overlapping contracts:
  Apple V4 consumer/runtime (`019fff16-cacd-7133-9823-15d529e8bb63`), V4
  handoff fixture (`019fff16-d72e-7703-8721-c81517ebe538`), sanitizer/Windows
  refresh (`019fff16-e538-7e73-a844-f4e09c18538d`), input trigger audit
  (`019fff16-f4d5-76b1-b3eb-dd7d9bb18512`), mixer/CoreAudio refresh
  (`019fff17-0485-79d1-ab6b-47e1495d97af`), CARD production validation
  (`019fff17-0fe1-7b23-8dd9-b18503b70fe8`), lifecycle/timing audit
  (`019fff17-1964-7822-babf-2120bc78fb6e`), graph terminator fixture
  (`019fff17-22e0-7f12-8c20-2fad9a684892`), texture/TLUT/TEV fixtures
  (`019fff17-2f40-78c1-b2c6-f69c50fc93fb`), Metal state contract audit
  (`019fff17-38e4-7ed3-a2aa-04e48b823c33`), and iOS shared-boundary audit
  (`019fff17-4100-78f1-91c4-0996c40e41b5`). Source lanes must create their
  own PC submodule branches/worktrees; audit lanes are read-only/test-only.
  No lane may claim a full link, LLDB, device, Metal encode/readback, pixel,
  input, audible audio, save/device persistence, simulator, or playability
  gate without separate evidence.

Current maintenance state: lanes 96, 97, and 98 are complete and archived. Lane
96's first graph task traversed eight inline `G_DL_NOPUSH` continuations to a
clean `G_ENDDL`, returned `0`, and did not reach `GXBegin`; lane 97 then
confirmed a second graph submission and interpreter entry but timed out in the
continuation prefix. Lane 98's one longer bounded run completed that second task
with eight `G_DL` handlers, `G_ENDDL`, and `return_err=0`, `cmds=12`, and
`end_dl=1`; task 2 still had no draw handler, `GXBegin`, or flush. No frame or
Metal claim follows.
Lane 99 completed its read-only current-tip crosswalk but then hit a remote
Codex compaction `404` twice before any source/build/runtime work. Its useful
finding is that live textured/TEV/active state reaches the fail-closed packet
builder rejection before `pc_metal_runtime_observe`; no defect was proven and
no frame or Metal claim follows. The task is archived and no worker is active.
Lane 100 was archived after the same remote Codex compaction `404` occurred
before its worker could produce a handoff. The root-owned continuation then
committed the opt-in diagnostic on `c1/lane-metal-rejection-diagnostic` and
fast-forwarded it into `c1/macos-host-launch` at `8a19f23`. One serialized
arm64 link and one elevated, directly rooted launch produced 64 bounded v2
records: 32 preflight and 32 fail-closed results, with no success. The live
state is standard source-alpha blending plus `GX_TEXMTX0`, both outside the
current v2 contract; this explains the rejection without proving a defect.
The evidence is `docs/evidence/METAL-REJECTION-DIAGNOSTIC-8A19F23-2026-08-13.md`.
No callback, Metal encode/readback, pixel, input, audio, save, device, or
playability claim follows. Lanes 101 and 102 both failed at the remote
compaction `404` boundary before producing a handoff; lane 101's one-file
uncommitted V3 header draft was rejected and reverted, while lane 102 left no
source edit. The root-owned V3 continuation is now integrated at PC `042cbf7`:
it forwards the observed blend/source-alpha/`GX_LO_NOOP`/`GX_TEXMTX0` state
through a separate typed callback, passes the combined V1/V2/V3 focused native
and ASan/UBSan tests `3/3` each, and marks V3 `V3_EXTENSION_NOT_RENDERED`.
No full link, live callback count, Metal encode/readback, pixel, input, audio,
save, device, or playability claim follows; the current-tip runtime count is
complete, and the alpha-update V3 rejection reason is now source-backed. The
next dependency-ready gate is the real Metal state encoder or a separately
authorized current-tip runtime trace, after the focused builder-to-consumer
fixture and Apple consumer boundary have passed their CPU gates. Lanes 104–110
are complete/integrated/archived. Lane 111 has completed its one serialized
runtime attempt and is awaiting exact-path cleanup. Lane 114's read-only
mixer/CoreAudio audit is also complete and awaiting exact-path cleanup. Lane
113's input audit is complete; its temporary root and visible worktree are
absent after archival, but orphaned holders still name the unlinked worktree
and must exit naturally before stale metadata reconciliation. Lane 112's
Save_t/CARD fixture is integrated and its four worker/integration roots have
been retired after holder checks; its preserved worktree still has
owner-managed holders. No
production worker is active; no lane may start a competing full
link or LLDB trace; no duplicate or filler lane is open. The current portable
verification tip is `a53b192`, which keeps resolved V4 texture-map aliases
safe, permits live unencoded alpha/depth/cull state through the V4-only
predicate, and wires the V4 builder into a typed Apple consumer callback after
V2/V3 fail, maps the supported blend/alpha subset, and
keeps V3 texture-matrix state explicitly `NOT_RENDERED` on top of the `dbf6986`
V4 consumer seam. The integrated six-target native and combined ASan/UBSan
focused tests are `6/6` each, and direct Apple consumer/sink fixtures are `2/2`
in each matrix. This remains CPU/contract and compile coverage only; no live V4
callback, Metal encode/readback, pixel, device, or playability claim follows.
See `docs/evidence/GX-V4-LIVE-CONSUMER-28EBAC2-2026-08-13.md`,
`docs/evidence/GX-V4-TEXTURE-MAP-ALIAS-83FE50C-2026-08-13.md`, and
`docs/evidence/GX-V4-UNRENDERED-RASTER-46A8AE5-2026-08-13.md`. The Save_t/CARD
recovery fixture remains integrated at `f19c73f`, while the real i686 Windows/PE
boundary remains blocked by the absent toolchain/sysroot.
One serialized current-tip `28ebac2` link reached `[4018/4019]`; its bounded
LLDB launch reached the game graph/GX path and counted
`pc_gx_try_handoff_semantic_packet_v4=558`, but the typed V4 Apple consumer,
prepare path, and `pc_metal_runtime_observe` were all `0`. This is live V4
builder-rejection evidence only, with no callback, Metal encode/readback,
pixel, or playability claim. See
`docs/evidence/CURRENT-V4-LIVE-CONSUMER-RUNTIME-28EBAC2-2026-08-13.md`.
The current-tip `46a8ae5` link also reached `[4018/4019]`, `[LOGO]`, and
`[NEOS_OUT]`; its explicit-return trace counted 542 V4 builder attempts but
zero V4 consumer/prepare/observer hits. The diagnostic cap remained 64
`reason=global_state` records because the classifier still used the old
predicate. The first correction (`adaddfd`) left a duplicated helper check;
integrated PC `a53b192` now aligns the classifier with the relaxed V4 predicate.
The follow-up trace below localizes the repeated game-owned path to the channel
predicate. See
`docs/evidence/CURRENT-V4-UNRENDERED-RASTER-RUNTIME-46A8AE5-2026-08-13.md`.
The corrected current-tip `a53b192` link reached `[4018/4019]`, `[LOGO]`, and
`[NEOS_OUT]`; its trace counted `graph_task_set00=33`,
`emu64_taskstart=33`, `GXBegin=601`, `pc_gx_flush_vertices=601`, and
`pc_gx_try_handoff_semantic_packet_v4=600`. The V4 consumer, prepare path, and
runtime observer stayed at `0`; 33 capped records classify the repeated
one-channel textured path as `channel`, while 31 heterogeneous setup records
remain `global_state`. This is live builder-rejection evidence only. See
`docs/evidence/CURRENT-V4-REJECTION-RUNTIME-A53B192-2026-08-13.md`.
Lane 115 is parked at setup because the requested M3 Max handoff returned
`No matching saved project was found on M3 Max`; it has not edited, built, or
tested locally. No active worker is counted until that remote project is
registered.
Lane 108's one current-tip link reached `[4018/4019]` and its one unprivileged
LLDB launch created a real inferior, reached boot/graph/GX, and recorded
`graph_task_set00=29`, `emu64_taskstart=29`, `GXBegin=532`,
`pc_gx_flush_vertices=532`, and V2/V3 builder entries `531` each. The typed V3
Apple consumer and `pc_metal_runtime_observe` were both `0`; the diagnostic
captured `64/64` `alpha_update_disabled` records (the source cap), with no
other predicate records. This is live builder-rejection evidence, not a
successful packet/callback, Metal, pixel, or playability claim. See
`docs/evidence/CURRENT-V3-REJECTION-RUNTIME-F18E7CD-2026-08-13.md`.
Lane 109 completed the dependency-ready CPU/contract gate: its separately
versioned V4 alpha-state packet/builder preserves the existing V3 ABI and
fail-closed behavior. Integrated native and combined ASan/UBSan focused tests
pass `5/5` each. The lane remains CPU/contract scoped; Apple consumer files are
a separate successor and no fresh runtime/device run is implied. Lane 110 has
now completed its typed Apple consumer/runtime validation seam with native and
combined ASan/UBSan focused CTest `6/6` each; no full link, LLDB, device, Metal,
pixel, or playability claim is authorized. Lane 111's completed runtime attempt
is recorded in `docs/evidence/CURRENT-V4-RUNTIME-DBF6986-2026-08-13.md`; it
owns no source edits and cannot claim Metal encode/readback, pixels, or
playability. Lane 112's integrated change is limited to the production recovery fixture registration; `pc_m_card.c` itself is unchanged. It owns only
one focused fixture. Lane 113's read-only input evidence is recorded
separately, with a narrow analog-trigger fix candidate requiring authorization.
Lane 114's transport-only audio evidence is recorded separately; all focused
roots are unique and must stop at CPU/adapter evidence.
Lane 94
(`019ffca1-c92a-7363-9687-a503d2f2851d`) completed one corrected elevated
LLDB trace from canonical PC `d1e812c`. Explicit-return callbacks continued
through `graph_task_set00` and `emu64_taskstart`; the debugger-owned sentinel
then stopped cleanly, with `GXBegin`, `pc_gx_flush_vertices`, v2 handoff, Apple
consumer, and runtime-observer counts all `0`. It owned no source edits and no
Metal encode/readback/pixel scope. Lane 93
(`019ffc93-5d85-7d53-a6bf-67a5b13305da`) completed one elevated runtime
trace with a durable final breakpoint list. It recorded one
`graph_task_set00` hit, then stopped because the temporary Python callback
omitted an explicit `return`; all downstream zeros are prefix-only. It owned no
source edits and no Metal encode/readback/pixel scope. Lane
92 (`019ffc83-96c2-7ce1-97d9-848fb308a41d`) completed one permitted elevated
current-tip LLDB launch. It created an inferior and reached boot/runtime,
resolving lane 91's pre-inferior `-1` blocker, but the bounded interruption
occurred before LLDB emitted per-symbol counts; no callback hit is inferred.
It owned no source edits and no Metal encode/readback/pixel scope. Lane 91
(`019ffc73-d5c6-78f1-94bb-91ad0d277d1d`) completed one serialized current-tip
arm64 link and one bounded LLDB trace from canonical PC `d1e812c`; the link
passed `4019/4019`, but LLDB failed before creating an inferior with status
`-1 (no such process)` and all breakpoints were zero-hit. It owns no source
edits, no umbrella changes, and no Metal encode/readback/pixel scope. The prior
callback capture lane
`019ffbc7-01e9-7b32-b5b1-f0abaada1b09`, the offscreen Metal sink lane
`019ffbc8-1f2b-7513-9c1c-7ddde5114f97`, the input, mixer/audio, lifecycle,
observer-rejection, and read-only GX v2 contract lanes are complete/archived
with their separate evidence and claim boundaries. The root-owned elevated
current-tip launch reached `graph_proc`/NEOS and `pc_gx_flush_vertices`, then
returned through `graph_proc` with status `0` after bounded SIGTERM; it proves
launch/boot/GX-boundary/clean-return only, not callback or renderer output.
Implementation lane `019ffc34-ab7a-74d0-839e-65cd045a2b01` is
complete/integrated at PC `26da235` from worker `06fa74c`; its fixed-width v2
builder/validator and fail-closed fixtures pass native and ASan/UBSan focused
CTest `3/3` each. Consumer lane `019ffc5d-392e-75e2-a863-a4b9199b11dd` is
complete/integrated at PC `d1e812c` from worker `cd881b7`: a separately typed
v2 callback validates the full packet, preserves v1 dispatch, and reports
`V2_EXTENSION_NOT_RENDERED`. Its native and ASan/UBSan focused CTest runs pass
`4/4` each. Neither lane proves a live game-owned callback, Metal
encode/readback/pixel, device, input, audio, save, or playability gate. See
`docs/evidence/GX-V2-CONSUMER-BOUNDARY-2026-08-13.md`.

The Windows, sanitizer, iOS, and input frame-guard handoffs are complete. Lane
107's exact physical roots and visible worktree have been retired by cleanup;
one source-registry metadata record remains preserved after `Operation not
permitted`, and the two dirty failed-clone directories remain intentionally
untouched. The authoritative PC source is `f19c73f` on
`c1/macos-host-launch`; the umbrella branch is `main` (the local
`c1/apple-port-bootstrap` alias is synchronized to the same tip) plus only
the pre-existing `.codex`/settings edits. The current-tip V3 runtime count is
complete and remains separate from Metal encode/readback/pixel proof: the
one unprivileged launch created an inferior and reached boot, GX, and V3
builder entries, while no V3 consumer or Apple runtime-observer hit. Lane 104's
source-backed reason is `g_gx.alpha_update_enable == 0`; the focused
builder-to-consumer fixture and Apple boundary audit are complete. Lane 109 is
also complete/integrated/archived with the V4 alpha-state contract and focused
native/ASan/UBSan `5/5` results. Lane 110 is complete/integrated/archived;
its typed V4 Apple consumer validation passes native and combined ASan/UBSan
focused CTest `6/6` each. Lane 111 and lane 114 are complete/archived pending
exact-path cleanup; lanes 112–114 are complete/archived pending exact-path
cleanup, and no worker is active. Full links and LLDB launches remain
serialized.
The graph-capture, GX-to-Metal, save-manager, post-link runtime,
live-target-resolver, and current-tip trace history remains recorded below.
Lane 64 is complete/archived with a separate pre-launch LLDB
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
| 15 | Integration/evidence owner — `019ff398-2520-7191-ac5c-f3007c49163f` | Umbrella docs, roadmap, reviewed commits, source gitlink, launch proof | `/Users/jk/Documents/Projects/acgc-modern-port` / `main` (`c1/apple-port-bootstrap` alias) | Active; only lane allowed to update the umbrella submodule pointer |
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
| 71 | Darwin GX handoff registration — `019ffb94-738f-70c3-9344-a194b74022af` | Apple-only `AcgcMetalPacketConsumerHandoffContext` registration, narrow resident-versus-active texture gate correction in `pc_gx.c`, bounded callback/status telemetry, and focused fixture; no shader, decomp, or Windows changes | Worker worktree absent after cleanup; source branch `c1/lane-darwin-gx-registration` at `9174404b`; integrated canonical source `54b840c`; focused roots retired | Complete/integrated; native and ASan/UBSan focused CTest `1/1` each; no full link, live callback, Metal encode/present/pixel, or playability claim |
| 72 | Live Apple GX callback observation — `019ffba9-3c9b-7713-82a4-ae102ad4715b` | Read-only current-tip full link plus exactly one no-`nice` LLDB launch; breakpoint on `pc_metal_runtime_observe` and `pc_gx_flush_vertices`; no source edits | Worktree `/Users/jk/.codex/worktrees/a240/acgc-modern-port` already absent; build/log roots retired after review | Complete/archived; link `0`, arm64 Mach-O, LLDB pre-inferior `nice(5)` failure with zero breakpoint hits; callback reachability inconclusive; no Metal encode/present/pixel/playability claim; evidence `docs/evidence/LIVE-DARWIN-GX-CALLBACK-RUNTIME-2026-08-13.md` |
| 73 | Current Apple GX callback hit capture — `019ffbc7-01e9-7b32-b5b1-f0abaada1b09` | Read-only current-tip full link and exactly one generated-bin LLDB launch with one-shot explicit hit logging for `pc_metal_runtime_observe`, GXBegin, flush, target, and graph symbols | Worktree `/Users/jk/.codex/worktrees/7842/acgc-modern-port` (retired); build/log roots retired; no source branch | Complete/archived; both launch attempts stopped before runtime, zero explicit hits; evidence `docs/evidence/LIVE-APPLE-GX-CALLBACK-2026-08-13.md`; no callback/frame/Metal claim |
| 74 | Offscreen Metal packet sink — `019ffbc8-1f2b-7513-9c1c-7ddde5114f97` | Source-edit lane for an Apple-only offscreen MTLDevice/command-buffer/readback consumer of the existing semantic packet; focused CPU/device-gated tests only | Worktree `/Users/jk/.codex/worktrees/002a/acgc-modern-port` (retire); owning PC branch `c1/lane-offscreen-metal-sink` at `d7facdd`; integrated canonical source `54b840c`; focused roots `/private/tmp/acgc-integrate-metal-sink-54b840c` and `...-apple` | Complete/integrated; worker CPU contract and integrated handoff CTest pass, device sink skip `77`; no live callback, game-owned encode/readback, pixel, or playability claim; evidence `docs/evidence/OFFSCREEN-METAL-SINK-2026-08-13.md` |
| 75 | Input snapshot boundary — `019ffbcc-904f-7673-bc6a-1b137c550997` | Read-only crosswalk and focused probe for SDL/keyboard/controller to a stable game-owned PAD snapshot; no source edits or full link | Worktree `/Users/jk/.codex/worktrees/3f1d/acgc-modern-port` (retire); focused root `/private/tmp/acgc-lane-input-boundary` (retire); no branch | Complete/archived; per-frame guard and virtual-controller stability pass, synthetic keyboard remains inconclusive; evidence `docs/evidence/INPUT-SNAPSHOT-BOUNDARY-2026-08-13.md`; no human-input/playability claim |
| 76 | Mixer/CoreAudio boundary — `019ffbcc-904f-7673-bc6a-1b309e9dd560` | Read-only native + ASan/UBSan mixer/bank probes and smallest CoreAudio/device gate; no source edits or full link | Worktree `/Users/jk/.codex/worktrees/7d30/acgc-modern-port` (retire); roots `/private/tmp/acgc-lane-audio-proof` and `...-asan` (retire); no branch | Complete/archived; software mixer/NEOS/DMA and direct callback pass, CoreAudio/device skip `77`; evidence `docs/evidence/MIXER-COREAUDIO-BOUNDARY-2026-08-13.md`; no audible-output claim |
| 77 | Save_t restart gate — `019ffbcc-9406-7a23-9847-2f19196bdad0` | Read-only focused codec, atomic recovery, production caller, and fresh-process reload verification; no source edits or full link | Worktree `/Users/jk/.codex/worktrees/7419/acgc-modern-port` (retire); roots `/private/tmp/acgc-lane-save-proof` and `...-asan` (retire); no branch | Complete/archived; codec, atomic/corruption recovery, and game-owned restart/reload fixture pass native + ASan/UBSan; physical CARD/device/new-game/playability remain open; evidence `docs/evidence/SAVE-T-RESTART-GATE-2026-08-13.md` |
| 78 | Timing/lifecycle/shutdown audit — `019ffbcc-9477-7333-9214-73b6f08f344b` | Read-only focused retrace/thread/TERM/KILL audit; no source edits, ISO access, or full link | Worktree `/Users/jk/.codex/worktrees/e1e5/acgc-modern-port` (retire); root `/private/tmp/acgc-lane-lifecycle-proof` (retire); no branch | Complete/archived; synthetic contract and isolated audio worker pass, integrated thread/reset teardown remains open; evidence `docs/evidence/LIFECYCLE-SHUTDOWN-AUDIT-2026-08-13.md`; no playability claim |
| 79 | Windows compatibility audit — `019ffbd0-b850-74b0-a0fd-cedcbd90db47` | Read-only `_WIN32`/x86/OpenGL/SDL regression audit against current Apple changes; no source edits, ISO access, or full link | Worktree `/Users/jk/.codex/worktrees/628f/acgc-modern-port` (retire after review); focused root `/private/tmp/acgc-lane-windows-audit` (retire after review); no branch | Complete/archived; portable 20/20 and host `-m32 -D_WIN32` probes pass; real i686 MinGW/sysroot remains unavailable; evidence `docs/evidence/WINDOWS-X86-AUDIT-2026-08-13.md`; no Windows sign-off |
| 80 | Native + ASan/UBSan verification matrix — `019ffbd0-ba29-78e2-aad5-93f34b8bdf73` | Read-only focused sanitizer matrix for graph/GX/Save_t/cleanup/audio/portable/Apple packet contracts; no source edits, ISO access, or full link | Worktree `/Users/jk/.codex/worktrees/ea1e/acgc-modern-port` (retire after review); roots `/private/tmp/acgc-lane-sanitizer-matrix-native` and `/private/tmp/acgc-lane-sanitizer-matrix-asan` (retire after review); no branch | Complete/archived; pinned to `f4cb491`, not current-tip; 10/12 portable sanitizer tests pass, two share the pre-existing `aflags_c` UBSan issue; evidence `docs/evidence/SANITIZER-MATRIX-F4CB491-2026-08-13.md`; no launch/frame claim |
| 81 | iOS shared-boundary readiness audit — `019ffbd0-bc94-7ff1-baf1-e5689164d53a` | Read-only audit of portable/core, Apple bridge, lifecycle, and existing iOS evidence; iOS source remains gated until macOS shared core/renderer proof | Worktree `/Users/jk/.codex/worktrees/b820/acgc-modern-port` (retire after review); focused root `/private/tmp/acgc-lane-ios-readiness` (retire after review); no branch | Complete/archived; portable CTest 20/20; no iOS target, simulator, device, game-owned Metal frame, input, audio, save, lifecycle, or playability claim; evidence `docs/evidence/IOS-SHARED-BOUNDARY-READINESS-2026-08-13.md` |
| 82 | Direct Apple callback hit capture successor — `019ffbd5-53a3-7371-b1a6-19859c9bbf35` | Read-only direct LLDB launch using explicit hit counters; non-duplicate follow-up to lane 73's stop-at-entry failure | Worktree `/Users/jk/.codex/worktrees/a688/acgc-modern-port` (retire); build/log roots retired; no source branch | Complete/archived at pre-sink PC `f4cb491`; graph/target/GX each hit once, Apple callback hit `0`; evidence `docs/evidence/DIRECT-APPLE-GX-CALLBACK-2026-08-13.md`; no Metal/pixel claim |
| 83 | Game-owned input frame-guard fixture — `019ffbda-8005-7b93-83cf-67549d968677` | Source/test successor for `padmgr_RequestPadData()` once-per-frame state preservation; owns `pc/tests/pc_padmgr_frame_guard_fixture.c` and narrow CMake registration only | Source worktree `/private/tmp/acgc-lane-input-frame-guard/source` (retire after review); branch `c1/input-frame-guard` at `799a016`; integrated canonical PC `59aa655`; focused roots `/private/tmp/acgc-integrate-input-frame-guard-59aa655-native` and `...-asan` | Complete/integrated; native and ASan/UBSan CTest `1/1` each with no diagnostics; no physical input/playability claim; evidence `docs/evidence/INPUT-FRAME-GUARD-2026-08-13.md` |
| 84 | Current integrated Metal callback capture — `019ffbe2-0d6d-74a0-9750-7f5e1e8b4d2e` | Read-only current-tip `59aa655` full link and exactly one direct LLDB launch; capture game-owned callback/sink status separately from GX/OpenGL | Worktree `/Users/jk/.codex/worktrees/73d6/acgc-modern-port` (retire after review); build `/private/tmp/acgc-lane-current-sink-callback-build`; logs `/private/tmp/acgc-lane-current-sink-callback-logs`; no source branch | Complete/archived; graph target and `GXBegin` each hit once, `pc_gx_flush_vertices` and `pc_metal_runtime_observe` hit zero; sink shader compile failed before encode/readback; evidence `docs/evidence/CURRENT-INTEGRATED-METAL-CALLBACK-2026-08-13.md`; no Metal/pixel/playability claim |
| 85 | Metal sink shader compile fix — `019ffbf9-eee6-7e12-bc8c-5b6f68c58c5f` | Source-edit lane owning only `pc/apple/src/metal_sink.m` and narrowly necessary sink regression coverage; reproduce/fix the MSL reserved-identifier failure without a full link | Source worktree `/private/tmp/acgc-lane-metal-sink-shader-fix-source` (retire after review); branch `c1/lane-metal-sink-shader-fix` at `5db1d28`; integrated canonical PC `a8f3a8f`; roots `/private/tmp/acgc-lane-metal-sink-shader-fix` and `...-asan` (retire after review) | Complete/integrated; pre-fix parser failure reproduced, post-fix offline MSL produces AIR, focused sink CTest/device gate passes with skip `77`; evidence `docs/evidence/METAL-SINK-SHADER-FIX-2026-08-13.md`; no live callback/pixel/playability claim |
| 86 | Current Metal sink runtime after shader fix — `019ffc03-b830-70f2-bce2-6cc32a436c29` | Read-only current-tip `a8f3a8f` full link and exactly one bounded direct LLDB launch; capture callback/encode/readback separately from GX/OpenGL | Worktree `/Users/jk/.codex/worktrees/cf4f/acgc-modern-port` (retire after review); build `/private/tmp/acgc-lane-current-sink-runtime-a8f3a8f`; logs `/private/tmp/acgc-lane-current-sink-runtime-a8f3a8f-logs`; no source branch | Complete/archived; graph target, `GXBegin`, and `pc_gx_flush_vertices` each hit once; `pc_metal_runtime_observe` hit zero; no Metal encode/readback/pixel/playability claim; evidence `docs/evidence/CURRENT-METAL-SINK-RUNTIME-A8F3A8F-2026-08-13.md` |
| 87 | GX observer rejection-path audit — `019ffc19-bff8-77a3-8c05-9e57d2a04bc2` | Source/test lane for `pc/src/pc_gx.c` observer invocation and semantic rejection reason; focused fixture/CMake only if a narrow bug is proven | Source worktree `/private/tmp/acgc-lane-gx-observer-rejection` (retire after review); branch `c1/lane-gx-observer-rejection` at `a8f3a8f`; roots `/private/tmp/acgc-lane-gx-observer-rejection-build` and `...-asan` (retire after review); no source commit | Complete/archived; no edit warranted; native and ASan/UBSan focused CTest `1/1` each; callback registration healthy, live zero explained by fail-closed semantic rejection; evidence `docs/evidence/GX-OBSERVER-REJECTION-AUDIT-2026-08-13.md`; no live callback/Metal/pixel/playability claim |
| 88 | GX v2 packet contract map — `019ffc28-3c56-70a2-a0d7-60b8e16dfda2` | Read-only two-upstream crosswalk for the smallest fixed-width TEV/texture/channel extension beyond v1; focused existing tests only, no production edits or live launch | Worktree `/Users/jk/.codex/worktrees/24b3/acgc-modern-port` (retire after review); scratch `/private/tmp/acgc-lane-gx-v2-contract` (retire after review); no source branch | Complete/archived; no edit or live launch; maps channel/texture-generator/two-stage-TEV state needed for a deliberate packet extension; evidence `docs/evidence/GX-V2-PACKET-CONTRACT-MAP-2026-08-13.md`; no live callback/Metal/pixel/playability claim |
| 89 | Implement bounded GX v2 packet — `019ffc34-ab7a-74d0-839e-65cd045a2b01` | Source lane for versioned fixed-width channel/texture-generator/two-stage-TEV packet state and narrow `pc_gx` construction; owns only packet headers/source, `pc_gx.c`, focused tests/CMake | Worktree and focused roots retired by cleanup; branch `c1/lane-gx-v2-packet` at `06fa74c`; integrated canonical PC `26da235`; umbrella evidence preserved | Complete/integrated; native and ASan/UBSan focused CTest `3/3` each; v2 remains fixture-only until a version-aware consumer exists; no live callback, Metal encode/readback/pixel, device, input/audio/save, or playability claim; evidence `docs/evidence/GX-V2-PACKET-IMPLEMENTATION-2026-08-13.md` |
| 90 | Version-aware GX v2 consumer boundary — `019ffc5d-392e-75e2-a863-a4b9199b11dd` | Source lane for a separately typed/version-checked v2 callback and Apple consumer boundary; preserve v1 dispatch, consume bounded values only, and prove v2 acceptance/rejection with focused tests | Worktree and exact focused roots retired by cleanup; branch `c1/lane-versioned-gx-v2-consumer` at worker `cd881b7`; integrated canonical PC `d1e812c`; umbrella evidence preserved | Complete/integrated; native and ASan/UBSan focused CTest `4/4` each with no diagnostics; v2 reports `V2_EXTENSION_NOT_RENDERED`; no full link, live callback, Metal encode/readback/pixel, device, input/audio/save, or playability claim; evidence `docs/evidence/GX-V2-CONSUMER-BOUNDARY-2026-08-13.md` |
| 91 | Live GX v2 callback reachability trace — `019ffc73-d5c6-78f1-94bb-91ad0d277d1d` | Read-only one-link/one-LLDB current-tip trace at canonical PC `d1e812c`; measure `pc_gx_flush_vertices` → v2 callback reachability and keep callback, Metal, pixel, and playability claims separate | Worktree and exact build/log roots retired after review; canonical source `c1/macos-host-launch` at `d1e812c`; evidence `docs/evidence/LIVE-GX-V2-CALLBACK-REACHABILITY-2026-08-13.md`; no source branch or edits | Complete/archived; link passed `4019/4019`, but LLDB failed before boot with `status -1 (no such process)` and every requested breakpoint hit `0`; no callback, frame, Metal encode/readback/pixel, device, input/audio/save, or playability claim |
| 92 | Elevated GX v2 callback launch retry — `019ffc83-96c2-7ce1-97d9-848fb308a41d` | Read-only one permitted elevated LLDB launch against canonical PC `d1e812c`; resolve the lane-91 pre-inferior status `-1` blocker and capture explicit v2 callback hit counts only if an inferior exists | Worktree and exact build/log roots retired after review; canonical source `c1/macos-host-launch` at `d1e812c`; evidence `docs/evidence/ELEVATED-GX-V2-LAUNCH-2026-08-13.md`; no source branch or edits | Complete/archived; elevated launch created an inferior and reached boot/runtime; outer interrupt preceded per-symbol breakpoint list, so counts are not emitted and no callback/GX/frame/Metal/pixel/playability claim follows; exact-PID TERM `rc=0`, KILL not needed |
| 93 | Durable GX v2 breakpoint-count trace — `019ffc93-5d85-7d53-a6bf-67a5b13305da` | Read-only one elevated LLDB trace at canonical PC `d1e812c`; persist per-symbol graph/GX/v2/Apple breakpoint counts while keeping the debugger alive through bounded inferior cleanup | Worktree and exact build/log roots retired after review; canonical source `c1/macos-host-launch` at `d1e812c`; evidence `docs/evidence/DURABLE-GX-V2-BREAKPOINT-COUNTS-2026-08-13.md`; no source branch or edits | Complete/archived; `graph_task_set00=1`, all downstream counts `0` only because the temporary Python callback omitted an explicit return and stopped at the prefix; no downstream callback/GX/frame/Metal/pixel/playability claim; exact inferior SIGKILL status `9`, wrapper `0` |
| 94 | Correct GX v2 trace callback control — `019ffca1-c92a-7363-9687-a503d2f2851d` | Read-only one elevated LLDB trace from canonical PC `d1e812c`; correct the temporary Python breakpoint callbacks to explicitly return `False`, preserve durable hit lines, and capture downstream graph/GX/v2/Apple counts | Worktree and exact build/log roots retired after review; canonical source `c1/macos-host-launch` at `d1e812c`; evidence `docs/evidence/CORRECTED-GX-V2-CALLBACK-TRACE-2026-08-13.md`; no source branch or edits | Complete/archived; `graph_task_set00=1`, `emu64_taskstart=1`, and GX/v2/Apple counts `0`; sentinel stopped after the graph task; no GX callback, frame, Metal, pixel, device, input/audio/save, or playability claim |
| 95 | Audit graph task to GX submission gap — `019ffcb0-760c-7b43-a690-f190dd5352f7` | Read-only two-upstream crosswalk for `graph_task_set00` → `emu64_taskstart` → `GXBegin`/`pc_gx_flush_vertices`; explain lane-94’s bounded zero GX counts and identify the smallest next gate | Worktree `/Users/jk/.codex/worktrees/680c/acgc-modern-port` (retire after review); canonical source `c1/macos-host-launch` at `d1e812c`; no build/log roots, ISO, launch, or source branch | Complete/archived; no queue is indicated by source; command/continuation condition remains open; evidence `docs/evidence/GRAPH-TASK-TO-GX-GAP-2026-08-13.md`; no source, launch, Metal encode/readback/pixel, device, input/audio/save, or playability claim |
| 96 | Trace emu64 continuation to GX draw — `019ffcc1-d77b-7a42-b0ec-54ac72f1a30e` | Read-only one-link/one-LLDB current-tip trace; instrument `emu64_taskstart_r`, command dispatch, `dl_G_DL`, `dl_G_ENDDL`, and `GXBegin` to classify the zero-GX boundary | Worktree `/Users/jk/.codex/worktrees/9474/acgc-modern-port` and roots `/private/tmp/acgc-lane-emu64-continuation-trace-build` / `/private/tmp/acgc-lane-emu64-continuation-trace-logs` (retire after review); canonical source `c1/macos-host-launch` at `d1e812c`; no source branch | Complete/archived; link `[4018/4019]` passed; first task had 8 `G_DL_NOPUSH`, 1 `G_ENDDL`, return `0`, `GXBegin=0`, `FrameCansel=0`, `err_count=0`; pointer-field diagnostics excluded; evidence `docs/evidence/EMU64-CONTINUATION-NO-DRAW-2026-08-13.md`; no Metal encode/readback/pixel, input/audio/save, device, or playability claim |
| 97 | Trace subsequent graph task progression — `019ffcd6-49fb-7f20-abb7-967008d7fe17` | Read-only one-link/one-LLDB current-tip trace for later `graph_task_set00`/`graph_draw_finish`/`graph_submit_task` activity after the lane-96 clean no-draw task; classify any later GXBegin reachability | Worktree `/Users/jk/.codex/worktrees/7008/acgc-modern-port` and roots `/private/tmp/acgc-lane-subsequent-graph-task-build` / `/private/tmp/acgc-lane-subsequent-graph-task-logs` (retire after review); canonical source `c1/macos-host-launch` at `d1e812c`; no source branch | Complete/archived; link `[4018/4019]` passed; graph submission/task entry each hit twice; task 2 reached 8 dispatches and a `G_DL` prefix but timed out before `G_ENDDL`/return; draw handlers and `GXBegin` 0; evidence `docs/evidence/SUBSEQUENT-GRAPH-TASK-PROGRESSION-2026-08-13.md`; no Metal encode/readback/pixel, input/audio/save, device, or playability claim |
| 98 | Complete second graph task continuation — `019ffcea-aceb-7f10-8aba-7fc61a98896d` | Read-only one-link/one-LLDB current-tip trace with a 30-second bound; extend task-2 `F0004000` continuation to `G_ENDDL` or a draw/GXBegin boundary | Lane worktree already absent; run snapshot `5b89680`; build/log roots retired by the cleanup lane; no source branch | Complete/archived; task 2 reached `F0004000`–`F0004007`, `G_ENDDL`, and return `0` with `cmds=12`, `end_dl=1`; draw handlers, `GXBegin`, and flush were `0` for task 2; later-task hits excluded; evidence `docs/evidence/SECOND-GRAPH-TASK-COMPLETION-2026-08-13.md`; no Metal encode/readback/pixel, input/audio/save, device, or playability claim |
| 99 | Current Metal-frame bridge audit/implementation — `019ffd05-6144-77a0-8a55-f1bb4092654d` | Bounded crosswalk for why live textured/TEV state is rejected before `pc_metal_runtime_observe`; source edit only if a concrete defect is proven | Worktree retired with the task; base umbrella `05c7ce8`, PC `d1e812c`, decomp `09ca8e8b`; no build/runtime roots created | Complete/archived with infrastructure failure after setup; read-only finding only, no source/build/runtime/Metal/pixel claim; no defect proven |
| 100 | Metal packet rejection predicate audit — `019ffd08-10ff-77b1-8bc4-bd91a84902e9` | Test-only/read-only reproduction of fail-closed packet-builder behavior for textured/TEV/active state; native plus ASan/UBSan focused tests; no worker full link/LLDB; root continuation owns only opt-in diagnostic instrumentation | Worker task retired after remote compaction failure; diagnostic branch `c1/lane-metal-rejection-diagnostic` fast-forwarded into canonical `c1/macos-host-launch` at `8a19f23`; decomp `09ca8e8b`; exact roots `/private/tmp/acgc-metal-rejection-trace-build` and `/private/tmp/acgc-metal-rejection-trace-logs` | Complete/archived; focused native and ASan/UBSan v2 handoff tests `1/1` each; one elevated launch emitted 32 preflight + 32 fail records; live alpha-blend/TEXMTX0 state is outside current v2 contract; no callback/Metal/pixel/playability claim; evidence `docs/evidence/METAL-REJECTION-DIAGNOSTIC-8A19F23-2026-08-13.md` |
| 101 | Live blend/texture-matrix GX packet extension — `019ffd19-3a91-7ba2-b6db-c7535d5143ce` | Source-edit lane for the smallest versioned packet/Apple consumer extension covering the observed `GX_BM_BLEND` + `GX_TEXMTX0` state; preserve v1 and legacy OpenGL | Worktree `/Users/jk/.codex/worktrees/fb3c/acgc-modern-port` and source `/private/tmp/acgc-lane-gx-live-blend-texmatrix-source`; branch `c1/lane-gx-live-blend-texmatrix` returned clean to base `8a19f23`; decomp `09ca8e8b` | Rejected/archived after two remote compaction `404` failures; one uncommitted header-only draft was reverted; no source commit, build, test, full link, LLDB, callback, Metal, pixel, or playability result |
| 102 | Live blend/texture-matrix GX packet extension retry — `019ffd20-e35d-7121-84b0-1589246e8e3c` | Fresh source-edit retry for the smallest versioned packet/Apple consumer extension covering `GX_BM_BLEND`, source-alpha factors, raw `GX_LO_NOOP=5`, and `GX_TEXMTX0`; preserve v1/OpenGL | Worktree `/Users/jk/.codex/worktrees/7c0b/acgc-modern-port` and source `/private/tmp/acgc-lane-gx-live-blend-texmatrix-source`; branch `c1/lane-gx-live-blend-texmatrix` clean at `8a19f23`; decomp `09ca8e8b` | Rejected/archived after remote compaction `404` before source edit; no build, test, full link, LLDB, runtime, or claim |
| 103 | Root-owned GX v3 state handoff and current-tip runtime — root continuation | Integrated source extension for the observed blend/source-alpha/`GX_LO_NOOP`/`GX_TEXMTX0` state; preserve V1/OpenGL and keep V3 non-rendering; one serialized current-tip link and bounded callback-entry trace | Source branch `c1/lane-gx-v3-direct` at `141a746`; integrated canonical PC `042cbf7`; source and runtime roots retired/absent after review (`/private/tmp/acgc-lane-gx-v3-direct-source`, `/private/tmp/acgc-current-v3-runtime-build`, `/private/tmp/acgc-current-v3-runtime-logs`); native/ASan roots also retired; | Complete/integrated; combined V1/V2/V3 focused CTest `3/3` native and `3/3` ASan/UBSan with no diagnostics; current arm64 `ac_pc` link completed and elevated trace reached graph/GX/V3 builder entries (`549`), but V3 consumer and `pc_metal_runtime_observe` were `0`; V3 remains `V3_EXTENSION_NOT_RENDERED`; no successful callback, Metal encode/readback/pixel, or playability claim; evidence `docs/evidence/GX-V3-STATE-HANDOFF-042CBF7-2026-08-13.md` and `docs/evidence/GX-V3-CURRENT-TIP-RUNTIME-042CBF7-2026-08-13.md` |
| 104 | V3 fail-closed rejection reason — `019ffd46-3012-7460-b435-2afff25993c0` | Source-edit diagnostic for the exact predicate(s) rejecting live V3 state after builder entry; native plus ASan/UBSan focused checks only; no full link, LLDB, or Metal work | Source branch `c1/lane-gx-v3-rejection-reason` at `c689a731`; integrated canonical PC `c1/macos-host-launch` at `add2d6f`; lane roots `/private/tmp/acgc-lane-gx-v3-rejection/native` and `/private/tmp/acgc-lane-gx-v3-rejection-asan` retained for review; decomp `09ca8e8b`; visible task worktree `/Users/jk/.codex/worktrees/d3d7/acgc-modern-port` is stale detached and protected until cleanup | Complete/integrated; `g_gx.alpha_update_enable == 0` is the source-backed V3 fail-closed reason; opt-in `ACGC_METAL_V3_REJECTION_TRACE=1` Darwin diagnostic capped at 64 records; integrated native and ASan/UBSan focused CTest `3/3` each with no diagnostics (leak detection disabled); no fixture/CMake, full link, LLDB, callback, Metal encode/readback/pixel, input, audio, save, device, or playability claim; evidence `docs/evidence/GX-V3-REJECTION-ALPHA-UPDATE-ADD2D6F-2026-08-13.md` |
| 105 | V3 Apple consumer/runtime boundary audit — `019ffd51-9466-75e3-b9f9-c27b43bda87f` | Read-only crosswalk for why the typed V3 handoff does not reach the Apple consumer or runtime observer; no full link, LLDB, or device work | Audit source worktree `/private/tmp/acgc-lane-gx-v3-apple-consumer/pc` on `c1/lane-gx-v3-apple-consumer-audit` at `042cbf7`; exact focused roots `/private/tmp/acgc-lane-gx-v3-apple-consumer-native` and `/private/tmp/acgc-lane-gx-v3-apple-consumer-asan`; no source changes; decomp `09ca8e8b` | Complete/archived; native and ASan/UBSan V3 CPU fixture `1/1` each; consumer/runtime registration compiled but was not executed because it initializes the Metal sink; `549 → 0 → 0` localizes upstream of Apple consumer; no callback, Metal encode/readback/pixel, or playability claim; evidence `docs/evidence/GX-V3-APPLE-CONSUMER-AUDIT-2026-08-13.md` |
| 106 | Focused V3 builder-to-consumer fixture — `019ffd51-9466-75e3-b9f9-c29b09289e91` | Synthetic live-like V3 builder/typed-handoff fixture that distinguishes builder rejection from consumer acceptance/rejection and records the alpha-update/write-mask reason; no full link, LLDB, or device work | Source branch `c1/lane-gx-v3-consumer-fixture` at `51ef7e4`; integrated canonical PC `c1/macos-host-launch` at `f18e7cd`; exact integrated roots `/private/tmp/acgc-integrate-v3-consumer-f18e7cd-native` and `/private/tmp/acgc-integrate-v3-consumer-f18e7cd-asan`; worker roots `/private/tmp/acgc-lane-gx-v3-consumer-fixture-native` and `/private/tmp/acgc-lane-gx-v3-consumer-fixture-asan` retained for review; decomp `09ca8e8b` | Complete/integrated; native and ASan/UBSan focused CTest `2/2` each on the integrated snapshot; disabled alpha writes reject before V3 callback, enabled writes build/consume with `V3_EXTENSION_NOT_RENDERED`, malformed packet rejection and V1 seam remain separate; no live callback, Metal encode/readback/pixel, or playability claim; evidence `docs/evidence/GX-V3-BUILDER-CONSUMER-FIXTURE-F18E7CD-2026-08-13.md` |
| 107 | Integrated sanitizer and Windows compatibility matrix — `019ffd51-94de-78a3-b583-89cd9d008e40` | Verification-only native/ASan/UBSan and available `_WIN32`/host probes on current PC `f18e7cd`; record unavailable i686 MinGW/sysroot toolchains exactly; no source edits or full link | Canonical PC `c1/macos-host-launch` at `f18e7cd`; decomp `09ca8e8b`; lane roots and visible worktree retired by cleanup; exact stale source metadata `/Users/jk/Documents/Projects/acgc-modern-port/.git/modules/upstream/ACGC-PC-Port/worktrees/ACGC-PC-Port` remains due `Operation not permitted`; dirty failed clones `/private/tmp/acgc-lane-gx-v3-sanitizer-windows-failed-pc` and `...-failed-decomp` are preserved | Complete/archived; focused native CTest `7/7` and combined ASan/UBSan `7/7` with no diagnostics; packet/adapter and C/static-GBI `_WIN32`/ILP32 probes pass, C++ host macro caveat, `pc_gx.c` stops at missing `process.h`, real GNU/MSVC probes stop at missing `string.h`; no i686/PE/runtime/Metal/pixel/playability claim; evidence `docs/evidence/SANITIZER-WINDOWS-CURRENT-F18E7CD-2026-08-13.md` |
| 108 | Current-tip V3 rejection runtime trace — `019ffd6d-46b9-7aa1-97d9-9e66a19ef45c` | Read-only one serialized `ac_pc` link and one bounded LLDB launch at PC `f18e7cd`; enable `ACGC_METAL_V3_REJECTION_TRACE=1` and count graph/GX/V3 builder, Apple consumer, runtime observer, and alpha-update rejection records | Visible task worktree `/Users/jk/.codex/worktrees/1d58/acgc-modern-port`; canonical populated PC `/Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port` at `c1/macos-host-launch` `f18e7cd`; decomp `09ca8e8b`; unique roots `/private/tmp/acgc-lane-current-v3-rejection-runtime-build` and `/private/tmp/acgc-lane-current-v3-rejection-runtime-logs` retained for exact cleanup after review | Complete/archived; link `[4018/4019]` passed and the real inferior reached boot/graph/GX; counts were graph/emu64 `29`, GX/flush `532`, V2/V3 builder `531`, Apple consumer/observer `0`; diagnostic cap recorded `64/64` `alpha_update_disabled`; no callback, Metal encode/readback/pixel, input/audio/save/device, simulator, natural-shutdown, or playability claim; evidence `docs/evidence/CURRENT-V3-REJECTION-RUNTIME-F18E7CD-2026-08-13.md` |
| 109 | V3 alpha-state packet contract — `019ffd84-42ae-72b2-8be3-d3d18d29577c` | Source-edit lane for the smallest reference-faithful versioned packet/builder representation of live `alpha_update_enable == 0`; preserve existing V1/V2/V3 ABI and fail-closed behavior; focused CPU tests only | Visible task worktree `/Users/jk/.codex/worktrees/9941/acgc-modern-port` and source `/private/tmp/acgc-lane-gx-alpha-state/source` are absent after cleanup; branch `c1/lane-gx-alpha-state` remains at `6ef4df7`, based on `f18e7cd`; `/private/tmp/acgc-lane-gx-alpha-state-native`, `-asan`, and empty parent remain preserved because exact metadata removal returned `Operation not permitted` at `.git/modules/upstream/ACGC-PC-Port/worktrees/source`; integrated canonical PC `c1/macos-host-launch` at `4fc6f00`; no Apple consumer/runtime ownership | Complete/integrated/archived; V3 remains `4968` bytes and V4 is `4972` bytes with explicit alpha-write state; native and combined ASan/UBSan focused CTest `5/5` each with no diagnostics; no full link, LLDB, Apple consumer, live callback, Metal encode/readback/pixel, input/audio/save/device, or playability claim; evidence `docs/evidence/GX-V4-ALPHA-STATE-4FC6F00-2026-08-13.md`; stale metadata is preserved for approved owner cleanup only |
| 110 | V4 Apple consumer/validation seam — `019ffd9e-1fb9-7153-bf9b-2d7dea3f3eed` | Source-edit lane for the smallest typed V4 consumer/runtime validation seam; preserve V1/V2/V3 dispatch, OpenGL behavior, and fail-closed malformed/unsupported state; focused CPU tests only | Visible umbrella worktree `/Users/jk/.codex/worktrees/6756/acgc-modern-port` is detached at setup snapshot `3a4c0e2` (provenance only); worker branch `c1/lane-gx-v4-consumer` at `63b772e` based on `4fc6f00`; integrated canonical PC `c1/macos-host-launch` at `dbf6986`; decomp `09ca8e8b`; worker roots `/private/tmp/acgc-lane-gx-v4-consumer-native-4fc6f00` and `-asan-4fc6f00`, integrated roots `/private/tmp/acgc-integrate-v4-consumer-dbf6986-native` and `-asan` (retire after review); owns only `pc/apple/include/acgc/metal_packet_consumer.h`, `pc/apple/src/metal_packet_consumer.c`, `pc/apple/src/pc_metal_runtime.c`, `pc/tests/pc_gx_semantic_v4_consumer_fixture.c`, and minimal `pc/CMakeLists.txt` registration; no `pc_gx.c` or packet-builder ownership | Complete/integrated/archived; native and combined ASan/UBSan focused CTest `6/6` each with no diagnostics beyond known compiler warnings; V4 accepts explicit alpha-write `0/1`, marks V3/V4 state extensions `NOT_RENDERED`, and rejects malformed state; no full link, LLDB, device, live callback, Metal encode/readback, pixel, input/audio/save, or playability claim; evidence `docs/evidence/GX-V4-APPLE-CONSUMER-DBF6986-2026-08-13.md` |
| 111 | Current-tip V4 builder-to-consumer runtime reachability — `019ffdb2-129d-7900-98f5-837ffe100fbc` | Read-only one serialized arm64 `ac_pc` link and one bounded no-nice LLDB launch at canonical PC `dbf6986`; count graph/GX/V3/V4 builder, typed V3/V4 consumer, prepare, and runtime-observer symbols with explicit return-safe callbacks | Lane worktree `/Users/jk/.codex/worktrees/d952/acgc-modern-port`; canonical PC `dbf6986` at run time; decomp `09ca8e8b`; exact roots `/private/tmp/acgc-lane-current-v4-runtime-build` and `/private/tmp/acgc-lane-current-v4-runtime-logs` protected for cleanup | Complete/archived pending exact-path cleanup; link `[4019/4019]` and one real boot/NEOS launch passed, but the callback stopped at `graph_task_set00` with `SBBreakpoint.GetName` `AttributeError`; downstream explicit counts are zero only within that stopped trace, and static crosswalk shows V4 is not live-wired; no callback, Metal encode/readback, pixel, input/audio/save/device, simulator, or playability claim; evidence `docs/evidence/CURRENT-V4-RUNTIME-DBF6986-2026-08-13.md` |
| 112 | Production Save_t/CARD recovery — `019ffdba-e4f1-71d1-82fd-573f767a436b` | Source-edit lane for the two-upstream Save_t/GCI checksum and main/backup recovery seam; own only `pc/src/pc_m_card.c`, one focused recovery fixture, and minimal registration; no full link/LLDB/device | Worker branch `c1/lane-card-production-recovery` `3d3204e`; integrated canonical PC `c1/macos-host-launch` `f19c73f`; decomp `09ca8e8b`; worker and integrated roots retired after holder checks; preserved worktree `/Users/jk/.codex/worktrees/6e5b/acgc-modern-port` retains owner-managed holders | Complete/integrated/archived; only CMake registration and fixture temp-root naming changed, `pc_m_card.c` unchanged; integrated native and combined ASan/UBSan focused CTest `1/1` each with no diagnostics; no full link/LLDB/physical CARD/device/persistence/playability claim; evidence `docs/evidence/SAVE-CARD-PRODUCTION-RECOVERY-F19C73F-2026-08-13.md` |
| 113 | Input snapshot boundary audit — `019ffdba-e4ee-72c3-ad9a-5f9d77153f34` | Read-only/test-only characterization of per-frame `PCInputSnapshot`, controller/keyboard mapping, and game-owned frame guard; no source/CMake edits, full link, LLDB, physical input, or playability | Visible worktree `/Users/jk/.codex/worktrees/8a82/acgc-modern-port` and exact root `/private/tmp/acgc-lane-input-runtime-boundary-XTPXKu` are absent after archival; eight surviving holders still name the unlinked worktree CWD and must exit naturally; canonical PC `dbf6986` at test time; decomp `09ca8e8b` | Complete/archived; native and combined ASan/UBSan focused tests `3/3` each with no diagnostics; double-`PADRead` is stable, while sub-threshold analog L/R reproduces `PADStatus` `(88,88)` but game-owned `now.button=0x0000` versus decomp `0x0030`; no source edit or physical-input/device/playability claim; evidence `docs/evidence/INPUT-BOUNDARY-AUDIT-DBF6986-2026-08-13.md`; stale metadata reconciliation remains held until the holders exit, and a separately authorized test-first fix lane is required |
| 114 | Mixer/DMA/CoreAudio boundary audit — `019ffdba-e4f1-71d1-82fd-57561a66e50a` | Read-only verification of the JAudio mixer/DMA/NEOS-to-Apple sink boundary; no source edits, full link, LLDB, ISO/assets, or audible-device claim | Visible worktree `/Users/jk/.codex/worktrees/0705/acgc-modern-port`; tested at PC `dbf6986`, current canonical PC `f19c73f`; decomp `09ca8e8b`; exact roots `/private/tmp/acgc-lane-mixer-coreaudio-current-native-VDoxjP` and `/private/tmp/acgc-lane-mixer-coreaudio-current-sanitizer-4WmGA1` | Complete/archived pending exact-path cleanup; native and ASan/UBSan CMake audio sets `4/4` pass, including software mixer/DAC/callback, NEOS/RSP, high-address DMA, and pointer probes; CoreAudio opened 32 kHz stereo/512 with zero underruns/overruns but producer was silent, so no audible-audio claim; evidence `docs/evidence/MIXER-COREAUDIO-AUDIT-DBF6986-2026-08-13.md` |
| 115 | V4 live channel rejection diagnostic — `019ffe12-2fe1-7ea2-aad2-26736c85fcd6` | Remote-focused source/test lane for `pc_gx_v2_channel_state_is_supported()` and the repeated live one-channel V4 rejection; source edit only if the two-upstream crosswalk proves a defect; no Apple consumer/runtime, packet-header, full-link, LLDB, ISO/assets, Metal, pixel, or playability scope | Visible task worktree `/Users/jk/.codex/worktrees/3526/acgc-modern-port` detached at umbrella `189b7b4`; PC source `/private/tmp/acgc-lane-gx-v4-channel-diagnostic-3526` on `c1/lane-gx-v4-channel-diagnostic` at `a53b192`; decomp `09ca8e8b`; no build roots or source diff | Parked/setup-blocked: Codex could not hand off because no matching saved `acgc-modern-port` project exists on M3 Max; task returned idle without edits/tests. Preserve worktree/branch until the remote project is registered; no local lane is active |

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
