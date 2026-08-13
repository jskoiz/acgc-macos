# ACGC visible lane board

Updated 2026-08-12 under the rolling-refill scheduler. The board records the
visible Codex tasks, their ownership, and the order in which evidence may be
integrated. All new and successor tasks are Luna Max with max reasoning. A
task being active means it is allowed to inspect or run its bounded work; it
does not mean its gate passed.

Current scheduler target: up to ten useful visible ACGC lanes, with no filler.
The texture remediation (17) is now complete/integrated at source `578c8b7`.
The root-owned audio-bank ABI lane is integrated at source `671171c`; its fresh
run crosses `second_game.c`, clears the DMA and matrix/segment pointer faults,
reaches `LOGO draw` and frame 1021, then fails closed for an unsupported bank 28
instead of crashing. A bounded post-guard run survives to frame 1741; no
rendered-frame, audible-audio, or playability claim is made.
Graph capture (16) and integrated verification (22) are complete/parked. The
post-fix game-frame runtime and the successor requests listed below are
setup-pending: the app has returned client IDs but not durable task IDs or
worktrees yet. They are not counted as active until `list_threads` confirms
them. Source-editing work remains capped at roughly 5–7 lanes, and expensive
full links remain serialized. All other ACGC tasks are parked or archived;
their reviewed commits and evidence remain available in Git and the evidence
docs.

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
| 26 | Post-fix game frame runtime — client `client-new-thread:1b48103c-9b76-4caf-8598-686e392653c3` | Fresh actual-game arm64 run after texture remediation, packet/frame boundary | Worktree setup pending; planned source `/private/tmp/acgc-lane-postfix-frame` / `c1/lane-postfix-frame`; build `/private/tmp/acgc-lane-postfix-frame-build` | Queued; do not start a competing full link before texture integration |
| 27 | Audio-bank ABI repair — root-owned continuation | `src/static/jaudio_NES/internal/system.c`, `channel.c`, fixed-width bank decoder and focused fixtures | `/private/tmp/acgc-lane-audio-lp64` / `c1/lane-audio-lp64`; integrated on `c1/macos-host-launch` as source `671171c`; builds `/private/tmp/acgc-lane-audio-lp64-build` and `/private/tmp/acgc-emu64-sanitize-build` | Integrated bounded fix; arm64 `ac_pc` links, native audio fixture 1/1, emu64 native 3/3, ASan/UBSan 3/3; fresh game run reaches `LOGO draw`/frame 1021, then bank 28 decode rejects and now fails closed; 60-second post-guard run survives to frame 1741; bank 28 schema/audio and rendered/audible gates remain open |

## Rolling-refill intake (setup pending)

These six bounded successors were requested with Luna Max/max reasoning and
distinct ownership. They are not counted as active until `list_threads` returns
durable task IDs and the app creates their isolated worktrees.

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
3. The LP64 texture-object fault is repaired at source `578c8b7`; the
   `02edf9c` second-game ABI repair is integrated. The current launch-critical
   boundary is the audio-bank wire/native mismatch: the uncommitted DMA-width
   fix clears `system.c:1300`, and the uncommitted native `BANK_ENTRY` fix
   reaches `system.c:1167`. Prove a bounded native decoder with wire fixtures,
   then feed the captured prefix into `83fa889` and advance Metal/TEV toward a
   game-owned frame. The `866dd94` and `ddbb498` fixture passes remain separate
   gates.
4. Keep Save_t/GCI parked on the explicit raw-range mismatch until the codec
   preserves arbitrary bytes or a proven wire-format boundary is established;
   do not weaken the roundtrip test. Filesystem adapter, lifecycle, and
   verification evidence remain synthetic/portable boundaries.
5. Re-run the native and sanitizer matrix at the integrated `c1/macos-host-launch`
   source HEAD after the audio fix, then separately prove input, audio
   device/audibility, save/load, simulator, physical device, and playability.
6. iOS implementation remains gated behind proven shared macOS core, renderer,
   input, audio, persistence, and lifecycle behavior.

No lane may push, publish, deploy, install, sign, submit, or redistribute the
ISO, extracted assets, keys, or proprietary game data.
