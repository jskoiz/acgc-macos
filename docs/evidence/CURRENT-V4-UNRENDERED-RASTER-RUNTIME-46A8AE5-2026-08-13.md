# Current V4 unrendered-raster runtime at `46a8ae5`

## Result

The V4-only alpha/depth/cull relaxation is integrated and the game still
reaches the live GX builder, but the typed Apple consumer remains unobserved.
This closes neither callback reachability nor any rendering gate.

## Provenance and commands

- Umbrella: `040d216` (`main` and `c1/apple-port-bootstrap`).
- `ACGC-PC-Port`: `c1/macos-host-launch` at `46a8ae5`.
- `ac-decomp`: `master` at `09ca8e8b`.
- Build root: `/private/tmp/acgc-current-v4-unrendered-raster-runtime-build`.
- Log root: `/private/tmp/acgc-current-v4-unrendered-raster-runtime-logs`.

The one serialized build used:

```text
ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v4-unrendered-raster-runtime-build \
  ./script/build_and_run_game.sh --build
```

It returned `0`, reached `[4018/4019]`, and produced an arm64 Mach-O
`AnimalCrossing`. One explicit-return LLDB launch ran for the bounded 20-second
window with `ACGC_METAL_V4_REJECTION_TRACE=1`. The supervisor recorded the
inferior as PID `74225`, sent `SIGTERM` at the deadline, and did not need a
`SIGKILL`. The game log reached `[LOGO]` and repeated `[NEOS_OUT]` frames.

## Counts and rejection

```text
graph_task_set00                         29
emu64_taskstart                          29
GXBegin                                  543
pc_gx_flush_vertices                     543
pc_gx_try_handoff_semantic_packet_v3     543
pc_gx_try_handoff_semantic_packet_v4     542
acgc_metal_packet_consumer_handoff_v3      0
acgc_metal_packet_consumer_handoff_v4      0
acgc_metal_packet_consumer_prepare_v4      0
pc_metal_runtime_observe                  0
```

The diagnostic emitted its cap of `64` `reason=global_state` records. The
representative live state was `alpha_update=0`, alpha compare `7/7/0` with
refs `8/144`, `z=0/7/0/1` (depth compare/update disabled, color writes enabled),
blend `1/4/5/5`, one channel, one texgen, one TEV stage, resolved texture,
texgen `1/4/30/0`, and back-face culling. Because the diagnostic helper still
uses the pre-relaxation global-state label, this run does not yet distinguish
the remaining V4 channel/stage/texgen rejection from the now-allowed raster
state. No V4 callback or Metal sink submission is inferred.

## Claim boundary and next action

This proves link/launch/boot/GX/V4-builder activity only. It does not prove
callback reachability, Metal encode/present/readback, a pixel, input, audio,
save/reload, simulator/device behavior, or playability. The next bounded
source step is diagnostic-only: make the V4 rejection classifier match the
relaxed predicate so one subsequent serialized trace can identify the exact
remaining contract reason before any further behavior change.
