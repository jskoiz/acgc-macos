# Second graph-task continuation completion

Date: 2026-08-13

This evidence records lane 98 (`019ffcea-aceb-7f10-8aba-7fc61a98896d`), a
read-only one-link/one-LLDB continuation trace intended to resolve lane 97's
partial second graph-task result. The run used the umbrella snapshot
`5b89680`, canonical PC source `d1e812c` on `c1/macos-host-launch`, and
`ac-decomp` `09ca8e8b` on `master`. The umbrella and both upstream checkouts
were clean for the lane; no submodules were initialized or mutated.

## One build and one launch

The lane used only these ignored roots:

- `/private/tmp/acgc-lane-second-task-completion-build`
- `/private/tmp/acgc-lane-second-task-completion-logs`

It configured the canonical PC `pc` directory with:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-second-task-completion-build \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=OFF \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

Configure returned `0`. It then ran:

```sh
cmake --build /private/tmp/acgc-lane-second-task-completion-build \
  --target ac_pc --parallel 1
```

The serialized link returned `0` at `[4018/4019]` and produced an arm64 Mach-O
`AnimalCrossing`. The run used the existing
ignored local-disc symlink only; no ISO bytes were copied or committed.

The single bounded launch was:

```sh
/usr/bin/lldb --batch --no-lldbinit \
  --source /private/tmp/acgc-lane-second-task-completion-logs/lldb-commands.txt \
  -- /private/tmp/acgc-lane-second-task-completion-build/bin/AnimalCrossing
```

The command file instrumented task entry/return, the dispatch line, `G_DL`,
`G_ENDDL`, the known draw handlers, `GXBegin`, and
`pc_gx_flush_vertices`. Every Python callback returned explicitly; the final
summary reported `callback_errors=0`.

## Task-2 result

Task 2 entered `emu64_taskstart_r` once and returned once with:

```text
G_DL handlers:       8
G_ENDDL handlers:     1
draw-opcode handlers: 0
GXBegin:              0
pc_gx_flush_vertices: 0
return_err:           0
cmds:                 12
end_dl:               1
FrameCansel:          '\0'
```

The prior lane-97 dispatch prefix remains the source of the
`DB060000 80000000` observation:

```text
DE010000 F0004000
DB060000 80000000
DE010000 F0004001
DE010000 F0004002
DE010000 F0004003
DE010000 F0004004
DE010000 F0004005
DE010000 F0004006
```

Lane 98 directly recorded the task-2 handler sequence:

```text
DE010000 F0004000
DE010000 F0004001
DE010000 F0004002
DE010000 F0004003
DE010000 F0004004
DE010000 F0004005
DE010000 F0004006
DE010000 F0004007
DF000000 00000000
```

The handler records are in `lldb-launch.log` around lines 320–330 in the
lane-local log root. The run entered 12 tasks and returned from 11. Later
tasks 11–12 reached draw handlers, `GXBegin`, and
`pc_gx_flush_vertices`; those hits are not task-2 evidence. The dispatch-line
callback emitted records only for tasks 10–12 in this run, so the lane does
not replace lane 97's earlier dispatch-word evidence.

## Timeout and cleanup

The LLDB wrapper (PID `74697`) exited `0`. The exact inferior (PID `74760`)
reached the 30-second bound. The lane recovered that PID from the game/LLDB
diagnostics and issued only:

```text
kill -KILL 74760  # exit 0
kill -0 74760     # post-cleanup exit 1
```

No wrapper signal, second launch, or retry occurred. The exact supervisor
record is `/private/tmp/acgc-lane-second-task-completion-logs/supervisor.log`.

## Claim boundary

This proves that the second graph task's bounded command chain reaches eight
`G_DL` continuations, `G_ENDDL`, and a clean interpreter return. It does not
prove task-2 drawing, `GXBegin`, a flush, a Metal callback or encode/present,
pixel readback, input, audible audio, save/load, simulator/device behavior,
natural shutdown, or playability. The later-task draw/GX hits are explicitly
excluded from the task-2 claim.
