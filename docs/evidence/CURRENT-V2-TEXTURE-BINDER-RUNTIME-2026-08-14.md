# Current V2 texture-binder runtime gate — 2026-08-14

## Provenance

This root-owned runtime attempt used the integrated umbrella `a518827`,
canonical PC `c1/macos-host-launch` at
`354f33884dd4e4e75b63cdb1dd5c72bc1dddbfd5`, and `ac-decomp`
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The ISO remained at the ignored
local path and was checked against SHA-256
`a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`.

The build root was `/private/tmp/acgc-current-v2-texture-binder-runtime`.
No ISO bytes or extracted assets were copied into the source or tracked paths.

## Link gate

```sh
ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v2-texture-binder-runtime \
  ./script/build_and_run_game.sh --build
```

The command returned `0`, reached `[4018/4019]`, and produced
`bin/AnimalCrossing` identified as `Mach-O 64-bit executable arm64`. CMake
emitted the known `PC_DARWIN_COMPILE_AUDIT` warning and the link emitted the
known section-alignment warning; no link error occurred.

## Launch attempts and blocker

One ordinary bounded verification was attempted:

```sh
ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v2-texture-binder-runtime \
  ACGC_GAME_VERIFY_SECONDS=10 ACGC_GAME_TERM_GRACE_SECONDS=2 \
  ./script/build_and_run_game.sh --verify
```

The process exited before the ten-second gate with status `1` because SDL
reported `SDL_Init failed: The video driver did not add any displays`. One
separate diagnostic retry used `SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy`;
it also exited with status `1` at `SDL_CreateWindow` because the dummy driver
does not provide OpenGL. No LLDB launch was attempted after this display-session
blocker, and no source change was made.

## Boundary and next action

The current source and full link are proven, but this environment has no usable
SDL display session. There is no launch, boot, graph/GX callback, V2 texture
source-binder, Metal encode/present, pixel, input, audio, save/load, simulator,
device, or playability claim from this attempt. The next authorized runtime
step is one GUI-session launch/LLDB trace on a host with the exact local input
available; it must remain serialized and must not transfer the ISO/assets to the
M3 Max or cloud.
