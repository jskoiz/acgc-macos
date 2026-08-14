# Current V4 rejection runtime at `a53b192`

## Result

The corrected diagnostic reaches the live game graph and GX flush boundary,
but the typed V4 Apple consumer and runtime observer remain unobserved. The
repeated game-owned textured submissions are now localized to the V4 channel
predicate: `33` of the capped records report `reason=channel` with one channel,
one texgen, one TEV stage, a resolved texture, and the same live texgen state.
The other `31` records report `global_state` for heterogeneous setup/state
transitions (including zero or two texgens and fog state); they are not treated
as a rendered-frame signal.

This is live builder-rejection evidence only. It does not prove a callback,
Metal encode/present/readback, a pixel, input, audio, save/reload,
simulator/device behavior, or playability.

## Provenance and commands

- Umbrella: `189b7b4` (`main` and `c1/apple-port-bootstrap`).
- `ACGC-PC-Port`: `c1/macos-host-launch` at `a53b192`.
- `ac-decomp`: `master` at `09ca8e8b`.
- Worker correction: `c1/lane-gx-v4-unrendered-raster` at `9d4138d`.
- Build root: `/private/tmp/acgc-current-v4-rejection-diagnostic-fix-runtime-build`.
- Log root: `/private/tmp/acgc-current-v4-rejection-diagnostic-fix-runtime-logs`.

The one serialized build used:

```text
ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v4-rejection-diagnostic-fix-runtime-build \
  ./script/build_and_run_game.sh --build
```

It returned `0`, reached `[4018/4019]`, and produced an arm64 Mach-O
`AnimalCrossing`. One explicit-return LLDB launch ran for the bounded 20-second
window with `ACGC_METAL_V4_REJECTION_TRACE=1`. The supervisor was PID `8139`,
the detected inferior was PID `8146`, and the deadline sent `SIGTERM`; no
`SIGKILL` cleanup was recorded. The wrapper returned `0`; no natural game
shutdown is claimed.

## Counts

```text
graph_task_set00                         33
emu64_taskstart                          33
GXBegin                                  601
pc_gx_flush_vertices                     601
pc_gx_try_handoff_semantic_packet_v3     601
pc_gx_try_handoff_semantic_packet_v4     600
acgc_metal_packet_consumer_handoff_v3      0
acgc_metal_packet_consumer_handoff_v4      0
acgc_metal_packet_consumer_prepare_v4      0
pc_metal_runtime_observe                  0
```

The trace reached `[LOGO]` and repeated `[NEOS_OUT]` frames. The 64-record
diagnostic cap split into `channel=33` and `global_state=31`; representative
channel state was `chans=1 texgens=1 tev=1 ind=0 fog=0`, a resolved texture,
and `stage0=0/0/4`. The corresponding focused predicate is
`pc_gx_v2_channel_state_is_supported()` in `pc/src/pc_gx.c`.

## Next gate

The next useful work is a focused channel-contract crosswalk/fixture on the
remote M3 Max host. It must compare the PC channel predicate with the decomp
GX channel setup, remain CPU/contract-scoped, and stop before any full link,
LLDB, Metal device, pixel, or playability claim.
