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
fixture are passed. The actual reconstructed `ac_pc` target links as a native
arm64 Mach-O from source branch `c1/macos-host-launch` at `9cf9b3f` (on top of
`6e4aded`, `e22cbc5`, `a7b9dff`, and `09dd182`), with the
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
The bounded graph contract now classifies the observed eight-word capture as
prefix-only and refuses to submit it as a complete list. The optional GX-to-
Metal handoff and Apple packet/state fixtures pass their CPU contracts, while
device tests skip with `77` on this host because no Metal device is available.
The next critical gate is a clean post-link runtime trace that captures a
complete game-owned submission and binds it to Metal encode, present, and
pixel-readback evidence; the identifiable game-frame pass does not imply
input, audio, save/load, or playability.
