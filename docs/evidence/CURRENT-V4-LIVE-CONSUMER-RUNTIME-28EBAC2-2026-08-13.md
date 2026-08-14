# Current V4 live-consumer runtime trace — 2026-08-13

This record closes one serialized current-tip arm64 link and one bounded LLDB
launch against the integrated V4 builder-to-Apple-consumer source. It proves
that the running game reaches the V4 builder entry point, but it does not prove
that a V4 packet is accepted by the typed Apple consumer or that Metal encodes,
presents, or produces a readable game frame.

## Provenance and exact attempt

- Umbrella: `main`/`c1/apple-port-bootstrap` at `8679332`.
- Canonical PC: `c1/macos-host-launch` at `28ebac2`, clean.
- Decomp oracle: `master` at `09ca8e8b`, clean.
- Build command: `ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v4-live-runtime-build ./script/build_and_run_game.sh --build`.
- Build result: exit `0`; Ninja reached `[4018/4019] Linking CXX executable
  bin/AnimalCrossing` and copied shaders; output is an arm64 Mach-O.
- Trace command: `/bin/zsh /private/tmp/acgc-current-v4-live-runtime-logs/run-trace.zsh`.
- The LLDB supervisor ran for its bounded 20-second window and was sent TERM.
  Its parser did not capture the inferior PID, but the trace log identified
  `AnimalCrossing` PID `13741`; that exact PID exited after a direct TERM
  postcheck. No unrelated process was targeted.

## Observed symbol counts

The explicit-return LLDB callbacks reached these final counts:

```text
graph_task_set00=29
emu64_taskstart=29
GXBegin=558
pc_gx_flush_vertices=558
pc_gx_try_handoff_semantic_packet_v3=558
pc_gx_try_handoff_semantic_packet_v4=558
acgc_metal_packet_consumer_handoff_v3=0
acgc_metal_packet_consumer_handoff_v4=0
acgc_metal_packet_consumer_prepare_v4=0
pc_metal_runtime_observe=0
```

The V4 count is a builder-attempt entry count. It is not a successful packet
construction count: the absence of the typed V4 handoff and prepare callbacks
shows that the builder still returns through a fail-closed predicate before
the Apple consumer boundary.

## Claim boundary and next gate

This attempt demonstrates current-tip game boot, graph/task activity, GX flush
activity, and repeated V4 builder attempts. It does **not** demonstrate a live
V4 callback, a Metal encode or present, pixel readback, input, audible audio,
save/reload persistence, simulator/device operation, clean natural shutdown,
or playability. The existing CPU/ASan/UBSan V4 tests remain valid contract
evidence, but they do not override this live rejection boundary.

The next bounded implementation question is the exact V4 builder predicate
that rejects the live textured/TEV state. Any source change must stay on a
separate explicit PC branch with a focused fixture and two-upstream crosswalk;
do not start another full link or LLDB launch until that change is reviewed.

Raw build and trace material remains outside Git under:

- `/private/tmp/acgc-current-v4-live-runtime-build`
- `/private/tmp/acgc-current-v4-live-runtime-logs`

Those roots were holder-free after the run but are retained pending an exact,
explicit cleanup action. No ISO or extracted game asset is included here.
