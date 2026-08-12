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

1. Confirm the local image identifies as supported revision `GAFE01_00` and is
   accepted by each relevant extraction/runtime tool.
2. Reproduce the decomp configuration/build on macOS without changing source.
3. Inventory all Windows, x86, OpenGL, SDL, filesystem, timing, and endian
   assumptions in the PC port.
4. Define shared portable interfaces and a macOS host; prove launch, rendering,
   input, audio, and save/load independently.
5. Add an Apple renderer suitable for Metal and prove frame correctness on
   current macOS hardware.
6. Create the iOS host only after the shared layer is stable; verify simulator
   and physical-device lifecycle, touch/controller input, sandboxed files, audio,
   performance, and memory.

## Non-goals for bootstrap

- No distribution of Nintendo assets or a bundled disc image.
- No App Store submission or public binary release.
- No claim that compilation equals playable compatibility.
- No broad rewrite before the platform-assumption audit is complete.
