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

As of 2026-08-12, source/revision proof, the current bounded portable-core
slice, macOS host launch, and a deterministic Metal clear/triangle/present
fixture are passed. The actual reconstructed `ac_pc` target links as a native
arm64 Mach-O from source branch `c1/macos-host-launch` at `8b6849f`, with the
DVD/CARD, input snapshot, graph-capture, GX packet, Metal fixture, and audio
boundary commits reviewed in the same source history, and now moves past the
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
it does not prove audible game-mixer correctness. The CARD probe proves bounded
host transfers; it does not prove GameCube Save_t/GCI serialization or a
game-level save/reload.

The host invokes the same facade and reports the real DOL and Yaz0 REL
preparation before disposing the buffers. This is preflight and command-buffer
evidence without pixel readback: the host fixture remains separate from the
actual game launch, which reaches `initial_menu_init`, `dvderr_init`,
`sound_initial2`, and `[NEOS_OUT]` during bounded runs. A fresh host-context
run against the integrated lane build reached `COPYDATE` and at least frame
`841`, but the process did not honor the runner's cleanup `SIGTERM` while
waiting in the old DVD/file-loader path and required a single-process
`SIGKILL`. The focused DVD-tail fix now allows the 19-byte `COPYDATE` to
satisfy the GameCube 32-byte transfer rule; a fresh run completes the string
table, `JW_Init2`, `HotStartEntry`, both forest archives, and Famicom archive
loading before an `EXC_BAD_ACCESS` at `game.c:154` in `graph_proc`. That moves
the blocker past DVD loading but is not a game-owned frame.

The full PC runtime remains behind its default ILP32 guard; the opt-in Darwin
audit and native arm64 link are diagnostic milestones, not a claim of complete
runtime portability. The fail-closed static GBI pointer guard remains enabled.
Representative GX rendering, game frame, running-game input, game-mixer audio
output, game-level Save_t/GCI load/restart, iOS Simulator, and physical-device
gates remain open. The current highest-priority blocker is the bad
`GRAPH_SET_DOING_POINT(..., GAME_BGM)` destination write at `game.c:154`, before
`graph_task_set00` and before any live game-owned submission can be captured.
