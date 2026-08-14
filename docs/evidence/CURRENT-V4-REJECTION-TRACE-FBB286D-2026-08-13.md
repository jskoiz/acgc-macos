# Current V4 rejection trace at `fbb286d`

## Boundary

This is a live game-owned builder-rejection trace, not a renderer result. The
run reached the reconstructed game graph and GX submission path, but the V4
typed Apple consumer and runtime observer remained unobserved. It does not
prove a callback, Metal encode/present, pixel readback, input, audio,
save/reload, device, or playability gate.

## Provenance

- Umbrella snapshot used for the run: `5fe919c` (`main` and
  `c1/apple-port-bootstrap` before this diagnostic was integrated).
- `ACGC-PC-Port`: `c1/macos-host-launch` at `fbb286d`, with the worker change
  preserved on `c1/lane-gx-v4-rejection-trace` at `a012f6e`.
- `ac-decomp`: `master` at `09ca8e8b`.
- The worker changed only `pc/src/pc_gx.c`. Its opt-in
  `ACGC_METAL_V4_REJECTION_TRACE` path is compiled only with
  `PC_DARWIN_COMPILE_AUDIT` and emits at most 64 records.

The two-upstream crosswalk was recorded before the edit: the PC V4 builder and
flush seam are `pc/src/pc_gx.c` (`pc_gx_build_semantic_packet_v4()` and
`pc_gx_try_handoff_semantic_packet_v4()`), while the decomp initializes the
corresponding GX state through the `GXSetAlphaUpdate`, `GXSetAlphaCompare`,
`GXSetZMode`, `GXSetCullMode`, `GXSetTevOrder`, and `GXSetTexCoordGen2`
contracts in `src/static/dolphin/gx` and `src/static/JSystem/JFramework`.

## Commands and results

The serialized run used the existing current-tip script with distinct ignored
roots:

```text
ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v4-rejection-trace-runtime-build \
  ./script/build_and_run_game.sh --build
ACGC_METAL_V4_REJECTION_TRACE=1 \
  /private/tmp/acgc-current-v4-rejection-trace-runtime-logs/run-trace.zsh
```

The build returned `0`, linked an arm64 Mach-O, and reached the terminal
`[4018/4019]` Ninja record. The bounded launch reached `[LOGO]` and repeated
`[NEOS_OUT]` frames through the 20-second window. The supervisor failed to
discover the inferior PID, so the exact game PID `52104` was identified in the
LLDB log and terminated directly; no force-kill was needed afterward.

The final explicit-return LLDB counts were:

```text
graph_task_set00                         29
emu64_taskstart                          29
GXBegin                                  589
pc_gx_flush_vertices                     588
pc_gx_try_handoff_semantic_packet_v3     588
pc_gx_try_handoff_semantic_packet_v4     588
acgc_metal_packet_consumer_handoff_v3      0
acgc_metal_packet_consumer_handoff_v4      0
acgc_metal_packet_consumer_prepare_v4      0
pc_metal_runtime_observe                  0
```

All 64 diagnostic records were `reason=global_state`. The representative
record showed `alpha_update=0`, alpha compare `7/7/0` with refs `8/144`,
depth compare/update disabled (`z=0/7/0/1`), back-face culling, one channel,
one texgen, one TEV stage, a resolved texture, and the known texgen post-matrix
state. This separated the remaining global-state rejection from texture-handle
resolution; it did not authorize relaxing the V1/V2/V3 contract.

The focused source matrices for the diagnostic itself were native `6/6` and
combined ASan/UBSan `6/6`, with no sanitizer diagnostics (`detect_leaks=0`).

## Next gate

The next bounded source change is V4-only: allow the live alpha-test,
depth, and cull state that the current Apple packet does not encode, retain a
strict color-write gate, and prove the distinction with a focused fixture.
That change is integrated separately in
`GX-V4-UNRENDERED-RASTER-46A8AE5-2026-08-13.md`; a fresh serialized runtime is
required before making any live consumer claim.
