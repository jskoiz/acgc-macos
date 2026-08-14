# Current V2 rejection runtime — 2026-08-14

## Provenance

This root-owned runtime attempt used the umbrella `main` checkout at the
integrated PC gitlink `2b141a753ab948e9494c97daf8490673c61be9fc` on
`c1/macos-host-launch`. The matching upstream decomp checkout was
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c` (`master`). The local ignored disc
at `local/roms/Animal Crossing (USA).iso` was checked by the build entrypoint
against SHA-256
`a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`.
No ISO bytes or extracted assets were copied to the M3 Max, source worktrees,
or tracked paths.

## Link gate

```sh
ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v2-rejection-runtime-2b141a753 \
  ./script/build_and_run_game.sh --build
```

The command returned `0`, reached `[4018/4019]`, and produced an arm64
Mach-O `bin/AnimalCrossing`. The known Darwin compile-audit and section
alignment warnings remained; no link error occurred.

## GUI launch and bounded trace

The shell session has no SDL display, so the binary was launched once through
the already logged-in local Terminal GUI session using the exact generated
binary and working directory. The launch log reached:

- the local GAFE01 disc and all ten FST entries;
- COPYDATE, `famicom_mount_archive`, and `graph_proc`;
- repeated `NEOS_OUT` frames through at least frame `901`; and
- the LOGO actor creation/draw path.

The LLDB command file set `ACGC_METAL_REJECTION_TRACE=1` and counted the
game-owned graph/GX path plus the V2 Apple boundary. The persisted trace log
recorded:

| Boundary | Observed records |
| --- | ---: |
| `graph_task_set00` | 26 |
| `emu64_taskstart` | 26 |
| `GXBegin` | 524 |
| `pc_gx_flush_vertices` | 523 |
| `pc_gx_try_handoff_semantic_packet_v2` | 523 |
| `acgc_metal_packet_consumer_handoff_v2` | 0 |
| `acgc_metal_packet_consumer_prepare_v2_texture_source_tev` | 0 |
| `pc_metal_runtime_handoff_v2` | 0 |
| `pc_metal_runtime_get_v2_texture_source` | 0 |
| `pc_metal_runtime_observe` | 0 |

The opt-in diagnostic emitted exactly `64` records, comprising `32`
`result=-1` preflight records and `32` corresponding fail-closed results.
Observed state includes ordinary game blend/source/texture/TEV values outside
the current V2 accepted contract. This confirms live V2 builder entry and
builder-side rejection before the Apple consumer/provider/observer; it does
not prove that any Apple callback was successfully registered or invoked.

The GUI runner left no holder on the binary or log root at postcheck. Its
transient Terminal stdout was not persisted, so no TERM-versus-KILL disposition
is asserted here beyond the holder-free postcondition.

## Claim boundary and next gate

This is current-tip launch, boot-progression, and game-owned GX/V2 rejection
evidence only. It proves no Metal encode, command completion, present, pixel
readback, input, audible audio, save/load, simulator, physical-device, clean
natural shutdown, or human playability gate. The next useful lane is a
separately owned CPU/contract extension for the rejected blend/source/texture
state, followed by another explicitly serialized runtime trace. Keep the ISO
and proprietary assets local.
