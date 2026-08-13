# Elevated GX v2 launch evidence — 2026-08-13

## Scope and refs

This lane performed one permitted elevated LLDB attempt against the integrated
canonical PC `d1e812c` on `c1/macos-host-launch`, after the ordinary lane-91
attempt failed before inferior creation. The umbrella handoff snapshot was
`db112de`; `ac-decomp` was `09ca8e8b` on `master`. The lane was read-only and
made no source, test, umbrella pointer, documentation, branch, ISO, or asset
change.

## Build and launch preparation

One arm64 `ac_pc` configure/link ran under the unique ignored roots
`/private/tmp/acgc-lane-gx-v2-elevated-d1e812c-build` and
`/private/tmp/acgc-lane-gx-v2-elevated-d1e812c-logs`.

- Configure return code: `0`.
- Build command return code: `0`.
- Final recorded Ninja progress: `4018/4019` (the command still returned `0`).
- Output: native arm64 `bin/AnimalCrossing`.
- Generated shaders were present under `bin/shaders/`.
- The disc image was exposed only through a `bin/rom` symlink to the existing
  ignored local ISO; no copy or extraction was performed.

The exact LLDB command was:

```sh
/usr/bin/script -q /private/tmp/acgc-lane-gx-v2-elevated-d1e812c-logs/lldb-trace.log \
  /Applications/Xcode.app/Contents/Developer/usr/bin/lldb -b \
  -s /private/tmp/acgc-lane-gx-v2-elevated-d1e812c-logs/lldb-commands.txt \
  /private/tmp/acgc-lane-gx-v2-elevated-d1e812c-build/bin/AnimalCrossing
```

The command file ran `--verbose --framelimit 1` from the generated `bin`
directory and set auto-continue breakpoints for `graph_task_set00`,
`emu64_taskstart`, `GXBegin`, `pc_gx_flush_vertices`,
`pc_gx_try_handoff_semantic_packet_v2`,
`acgc_metal_packet_consumer_handoff_v2`,
`acgc_metal_packet_consumer_prepare_v2`, and `pc_metal_runtime_observe`.

## Runtime result

The elevated launch created a real inferior (`pid 92865`) and reached boot /
loaded generated shaders / game runtime. `--framelimit 1` did not terminate
the process. The outer wrapper was interrupted with exit `130` before LLDB
could emit its final `breakpoint list` and `process status`.

Per-symbol counts are therefore **not emitted** for every requested breakpoint.
The trace contains `4,743` aggregate LLDB auto-continue resumes, but that
aggregate cannot be truthfully partitioned by symbol. No callback, GX, graph,
or Metal hit count is inferred from it.

The exact inferior was confirmed alive after the interruption. TERM was sent
only to PID `92865` and returned `0`; a two-second exact-PID check returned
`1`, so no KILL was sent. Normal LLDB exit status and clean shutdown were not
captured. The environment's normal process-list check remained unavailable
(`sysmond service not found`).

Logs are retained outside Git at:

- `/private/tmp/acgc-lane-gx-v2-elevated-d1e812c-logs/configure.log`
- `/private/tmp/acgc-lane-gx-v2-elevated-d1e812c-logs/ac_pc-link.log`
- `/private/tmp/acgc-lane-gx-v2-elevated-d1e812c-logs/lldb-commands.txt`
- `/private/tmp/acgc-lane-gx-v2-elevated-d1e812c-logs/lldb-trace.log`
- `/private/tmp/acgc-lane-gx-v2-elevated-d1e812c-logs/handoff-summary.txt`

## Claims and next gate

This resolves the earlier pre-inferior launch blocker and proves a bounded
elevated process start/reach-runtime path. It does not prove any requested
graph/GX/v2 callback hit, a complete display list, a game-owned frame, Metal
encode/present/readback, pixels, input, audio, save/device persistence,
simulator/device behavior, clean shutdown, or playability. A future runtime
trace must capture per-symbol counts in a way that survives bounded cleanup;
no automatic retry is part of this lane.
