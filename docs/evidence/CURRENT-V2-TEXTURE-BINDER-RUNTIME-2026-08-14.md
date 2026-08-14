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

## Headless launch attempt and blocker

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
does not provide OpenGL. This is a shell-session limitation, not a source or
link failure.

## GUI-session launch and bounded trace

The same linked binary was then launched from the logged-in local Terminal GUI
session, without changing the source checkout or moving the ISO. The wrapper
started PID `51790`, ran for the planned ten seconds, sent `TERM`, and returned
without needing `KILL`. The log
`/private/tmp/acgc-current-v2-texture-binder-runtime/gui-launch-2.log` shows:

- the ignored local `GAFE01` disc opened successfully;
- FST/COPYDATE and the forest archives were mounted;
- 139 shader variants compiled;
- `NEOS_OUT` frames reached at least `841` and the LOGO actor path ran; and
- `mainproc` reached `graph_proc` and `famicom_mount_archive`.

This proves GUI-session launch, boot progression, and game-owned GX activity,
not a presented frame or playability.

A single return-safe LLDB trace was run from the same GUI Terminal, using the
already-linked binary and exact working directory. The transcript recorded
LLDB PID `52718`, game PID `52736`, `TERM_GAME_PID=52736`, and `TRACE_DONE`; no
`KILL` fallback was printed. Breakpoint counts from
`/private/tmp/acgc-current-v2-texture-binder-runtime-lldb-logs/lldb-runtime.log`
were:

| Boundary | Hits |
| --- | ---: |
| `graph_task_set00` | 24 |
| `emu64_taskstart` | 24 |
| `GXBegin` | 509 |
| `pc_gx_flush_vertices` | 509 |
| `pc_gx_try_handoff_semantic_packet_v2` | 508 |
| `acgc_metal_packet_consumer_handoff_v2` | 0 |
| `acgc_metal_packet_consumer_prepare_v2_texture_source_tev` | 0 |
| `pc_metal_runtime_get_v2_texture_source` | 0 |
| `pc_metal_runtime_observe` | 0 |

The two Apple consumer breakpoints and provider/observer breakpoints emitted no
trace records during this bounded run; `pc_metal_runtime_handoff_v2` was a
pending symbol with no locations and is not counted. Thus the current live
boundary is `pc_gx_try_handoff_semantic_packet_v2` entry followed by a
builder-side fail-closed return before the Apple consumer. The LLDB run was
terminated by the wrapper; no natural shutdown claim follows. CoreAudio
overload messages in the log are diagnostic noise, not audible-audio proof.

## Boundary and next action

The source and full link are proven, and the GUI session now proves launch,
boot progression, and the game-owned GX flush boundary. The live V2 builder still
does not reach the Apple texture-source binder/provider or runtime observer.
There is no Metal encode/present, pixel readback, input, audible audio,
save/load, simulator, device, or playability claim. The next gate is a separate
CPU/source lane that diagnoses and narrowly repairs the V2 builder-to-consumer
forwarding boundary, followed by a fresh serialized current-tip runtime trace.
The ISO/assets must remain local and must not be transferred to the M3 Max or
cloud.
