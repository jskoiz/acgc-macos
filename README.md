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
- The actual reconstructed `ac_pc` target now builds from the owning
  `c1/macos-host-launch` source branch at `8b6849f` (`Add SDL input path smoke
  harness`), with the DVD/CARD, input snapshot, graph-capture, GX packet,
  Metal-fixture, and audio-boundary commits reviewed in the same source
  history. The fresh arm64 link produces a Mach-O
  `AnimalCrossing` executable. Its native audio command records remain 8 bytes,
  while TARGET_PC keeps high native pointers in a command-address side table;
  focused native and ASan/UBSan probes pass.
- The source branch now contains `e5442de` and `858d802` (injectable
  fixed-width input snapshots and the final PADRead handoff), `e03ffed`
  (pointer-free graph-submission capture), `83fa889` (4,800-byte
  renderer-neutral GX semantic packets), `866dd94` (Metal geometry/state
  fixtures), `ddbb498` (texture/TLUT/TEV fixtures), and `766ad96`
  (mixer-to-callback PCM fixture).
  These are separate boundaries: the graph capture has not yet observed a live
  packet because the reconstructed process stops at `game.c:154`.
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
  ASan/UBSan tests at source snapshot `4f77dab`; it must be rerun at the current
  integrated source HEAD before claiming a current full matrix. The Windows
  audit found no regression at that snapshot but had no MinGW/i686 compiler, so
  it is not a Windows compiler sign-off.
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
  unit (`wire=0xF10E -> roundtrip=0x0000`). Runtime save-manager restart, main/
  backup recovery, exact GCI-envelope length, and whole-GCI proof remain open.
- The new CARD host-transfer test creates, writes, reads, closes, reopens, and
  rejects invalid ranges in a temporary card directory. It passes natively and
  under ASan/UBSan, but it is not GameCube `Save_t`/GCI serialization or a
  game-level save/reload proof.
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
  beyond the loader; it is still not a game-owned frame. The boot trace
  identifies the failing operation as the `GRAPH_SET_DOING_POINT(...,
  GAME_BGM)` write at that line, before `graph_task_set00` and before the
  capture hook.

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
- [arm64 native and sanitizer matrix](docs/LANE-VERIFICATION-MATRIX-2026-08-12.md)
- [Exact bootstrap commands, results, and blockers](docs/BOOTSTRAP-EVIDENCE.md)
- [Porting charter](docs/PORTING-CHARTER.md)
