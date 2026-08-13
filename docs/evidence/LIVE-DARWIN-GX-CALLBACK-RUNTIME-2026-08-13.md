# Live Darwin GX callback runtime — 2026-08-13

## Scope and refs

Lane 72 (`019ffba9-3c9b-7713-82a4-ae102ad4715b`) ran one read-only current-tip
runtime attempt against PC `c1/macos-host-launch` at
`f4cb491327bfdab39f1775c78cfaaa2742484e9f` and decomp `master` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. Its detached umbrella worktree
was at `452d5451`; the canonical umbrella subsequently advanced only in docs
and cleanup bookkeeping. No source, docs, gitlink, ISO, or asset was changed
by the lane.

## Build gate

The lane used one unique serialized build root:
`/private/tmp/acgc-lane-live-darwin-gx-registration-build`, with logs in
`/private/tmp/acgc-lane-live-darwin-gx-registration-logs`.

- Configure exit: `0`.
- `ac_pc` build/link exit: `0`.
- Final recorded step: `[4017/4018] Linking CXX executable bin/AnimalCrossing; Copying shader files to bin/shaders/`.
- Output: arm64 Mach-O.
- Only diagnostic: the known section-alignment warning.

The ignored local ISO was exposed only through the generated `bin/rom` symlink;
no ISO contents were printed or copied.

## Single launch attempt

Exactly one direct no-`nice` LLDB launch was made from the generated `bin`
directory. LLDB resolved all requested symbols:

- `pc_metal_runtime_observe`
- `pc_gx_flush_vertices`
- `graph_proc`
- `graph_capture_task_submission`
- `graph_capture_task_submission_target`
- `GXBegin`

The environment then failed before creating an inferior:

```text
zsh:59: nice(5) failed: operation not permitted
error: process exited with status -1 (no such process)
```

The supervisor recorded `lldb_wait_status=0`, `timed_out=0`,
`term_sent=0`, and `kill_sent=0`; the TERM grace path was unused. There were
zero callback, GX, graph, or target breakpoint hits.

## Evidence boundary

This proves the current source links and that LLDB can resolve the new callback
and existing game-owned symbols. It does not prove a live callback, packet
status, GX submission, Metal encoding, command-buffer completion, presentation,
pixel readback, input, audible audio, save/reload, device behavior, clean
shutdown, or playability. Callback reachability remains inconclusive until the
environment permits one no-`nice` inferior launch; no retry was made in this
lane.

Logs retained for review before cleanup:

- `/private/tmp/acgc-lane-live-darwin-gx-registration-logs/exit-codes.txt`
- `/private/tmp/acgc-lane-live-darwin-gx-registration-logs/build.log`
- `/private/tmp/acgc-lane-live-darwin-gx-registration-logs/launch-preflight.log`
- `/private/tmp/acgc-lane-live-darwin-gx-registration-logs/lldb-command-line.log`
- `/private/tmp/acgc-lane-live-darwin-gx-registration-logs/lldb-runtime.log`
- `/private/tmp/acgc-lane-live-darwin-gx-registration-logs/supervisor.log`
