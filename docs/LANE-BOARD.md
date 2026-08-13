# ACGC visible lane board

Updated 2026-08-12 after the DVD-tail fix. The board records the visible Codex
tasks, their ownership, and the order in which evidence may be integrated. All
new tasks are Luna Max with max reasoning. A task being active means it is
allowed to inspect or run its bounded work; it does not mean its gate passed.

## Ownership and live state

| # | Lane / visible task ID | Ownership | Worktree / branch | State |
| --- | --- | --- | --- | --- |
| 1 | DVD aligned-read semantics — `019ff8aa-6e31-7723-bb32-095c7158148b` | `pc_dvd.c`, focused DVD probe | `/private/tmp/acgc-lane-dvd-loader` / `c1/lane-dvd-loader`; source `dfb3f7f`, integrated as `4f77dab` | Complete; fresh run passes `COPYDATE` and reaches `game.c:154` |
| 2 | Launch supervisor — `019ff8d2-a527-7c90-b7c0-f95aef4f5a0e` | Umbrella `script/build_and_run_game.sh` only | `/Users/jk/.codex/worktrees/f2c7/acgc-modern-port`; create `c1/lane-launch-supervisor` before edits | Active |
| 3 | Boot progression trace — `019ff8d3-06e4-71d3-8708-120d84fa270f` | Read-only post-loader LLDB/runtime evidence | `/Users/jk/.codex/worktrees/6bed/acgc-modern-port`; `/private/tmp/acgc-lane-boot-trace-build` | Active; no source edits |
| 4 | First game-owned render submission — `019ff8aa-6e31-7723-bb32-097e85bb2293` | Graph/emu64 submission capture | `/private/tmp/acgc-lane-render-capture-v2` / `c1/lane-render-capture` | Active |
| 5 | GX semantic packet — `019ff8d3-0887-7472-a53a-84c5d7ad105c` | Fixed-width renderer-neutral packet + tests | `/private/tmp/acgc-lane-gx-packet` / `c1/lane-gx-packet` | Active; depends on graph capture |
| 6 | Metal geometry/state — `019ff8d3-0c2e-7463-b918-af75f7cb6208` | Apple geometry/state fixtures | `/private/tmp/acgc-lane-metal-state` / `c1/lane-metal-state` | Active fixture lane |
| 7 | Texture/TLUT/TEV fixtures — `019ff8d3-150c-77f0-b99c-dcbf38645977` | Synthetic texture/palette/combiner fixtures | `/private/tmp/acgc-lane-tev-fixtures` / `c1/lane-tev-fixtures` | Active fixture lane |
| 8 | Input snapshot boundary — `019ff8aa-743f-7923-8d9b-276421802fa8` | SDL-to-logical keyboard/controller snapshot | `/private/tmp/acgc-lane-input-snapshot` / `c1/lane-input-snapshot` | Active |
| 9 | Mixer/CoreAudio correctness — `019ff8aa-7959-7342-af84-187dfb2e0a89` | Reconstructed PCM/mixer output proof | `/private/tmp/acgc-lane-audio-mixer` / `c1/lane-audio-mixer` | Active; boundary probe already passed, audible output open |
| 10 | Save_t/GCI roundtrip — `019ff8d3-0fe5-7883-8ebb-74eeac6efcb6` | Byte codec and process-restart persistence evidence | `/Users/jk/.codex/worktrees/35f6/acgc-modern-port`; create `c1/lane-save-gci` before edits | Active evidence lane |
| 11 | Sandboxed filesystem/atomic saves — `019ff8d3-1b80-7ab0-89b5-28afcf680cef` | Application Support/cache/log/temp-file adapter | `/Users/jk/.codex/worktrees/10c5/acgc-modern-port`; create `c1/lane-filesystem-saves` before edits | Active evidence lane |
| 12 | Timing/retrace/lifecycle — `019ff8d3-1f89-7c23-82fb-150b2f39e37c` | Monotonic time, workers, shutdown/resume | `/Users/jk/.codex/worktrees/cf91/acgc-modern-port`; create `c1/lane-timing-lifecycle` before edits | Active evidence lane |
| 13 | Windows compatibility audit — `019ff8d3-23c5-75a2-beac-7f7e70c72c08` | Read-only x86/Windows/OpenGL/SDL conditional audit | `/Users/jk/.codex/worktrees/8231/acgc-modern-port` | Active read-only lane |
| 14 | Native + ASan/UBSan matrix — `019ff8d3-2a6f-7610-a9f1-53f237353454` | Focused verification and sanitizer evidence | `/Users/jk/.codex/worktrees/2232/acgc-modern-port`; create `c1/lane-verification-matrix` before edits | Active; expensive links serialized |
| 15 | Integration/evidence owner — `019ff398-2520-7191-ac5c-f3007c49163f` | Umbrella docs, roadmap, reviewed commits, source gitlink, launch proof | `/Users/jk/Documents/Projects/acgc-modern-port` / `c1/apple-port-bootstrap` | Active; only lane allowed to update the umbrella submodule pointer |

The Codex-created umbrella worktrees begin detached at umbrella commit
`82732fe` with nested submodules uninitialized. Source-edit lanes therefore use
the explicit source worktrees listed above. No lane should initialize nested
submodules blindly or edit a detached source checkout.

## Evidence already integrated

- `9b1c48f` / `3a6582d` are integrated on `c1/macos-host-launch`; the SDL/CoreAudio
  boundary and CARD host-transfer probes pass, but they do not prove audible
  mixer output or GameCube Save_t/GCI persistence.
- `dfb3f7f` is integrated as `4f77dab`: the PC disc-backed DVD host accepts the
  GameCube 32-byte sector-tail transfer for 19-byte `COPYDATE` while rejecting
  malformed ranges. Native and ASan/UBSan focused probes pass.
- A fresh arm64 run against the DVD lane reaches `COPYDATE`, string-table
  completion, `JW_Init2`, `HotStartEntry`, both forest archives, and Famicom
  archive loading, then stops at `EXC_BAD_ACCESS` in `game.c:154` while entering
  `graph_proc`. This is not a rendered-frame proof.

## Integration order

1. Review `4f77dab` and update the umbrella gitlink only after the authoritative
   focused DVD tests and fresh arm64 runtime log are reproduced.
2. Resolve the post-loader `game.c:154` fault and capture graph submission
   (`3`, then `4`) before treating GX packet work (`5`) as live-game evidence.
3. Integrate packet/state/TEV fixtures (`5`–`7`) as separate renderer gates;
   synthetic Metal completion never substitutes for a game-owned frame.
4. Integrate input, mixer, Save_t/GCI, filesystem, and lifecycle (`8`–`12`) as
   independent macOS gates.
5. Run the Windows audit and serialized native/sanitizer matrix (`13`–`14`),
   then let lane `15` update the roadmap and acceptance ledger.
6. iOS implementation remains gated behind proven shared macOS core, renderer,
   input, audio, persistence, and lifecycle behavior.

No lane may push, publish, deploy, install, sign, submit, or redistribute the
ISO, extracted assets, keys, or proprietary game data.
