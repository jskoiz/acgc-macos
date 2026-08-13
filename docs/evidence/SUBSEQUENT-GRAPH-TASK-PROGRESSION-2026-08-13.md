# Subsequent graph-task progression trace — 2026-08-13

## Scope and references

Lane 97 performed exactly one serialized arm64 configure/build and one bounded
LLDB launch. It made no source, test, docs, submodule-pointer, ISO, or asset
changes. The trace snapshot was umbrella `1489cac`; canonical PC was clean at
`d1e812c` on `c1/macos-host-launch`; canonical decomp was clean at `09ca8e8`
on `master`. The isolated worktree kept its submodules uninitialized and used
the canonical clean source checkouts directly.

## Build and launch

Configure returned `0`:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-subsequent-graph-task-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=OFF \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

The single serialized link returned `0` at `[4018/4019]` and produced a native
arm64 `AnimalCrossing` Mach-O:

```sh
cmake --build /private/tmp/acgc-lane-subsequent-graph-task-build \
  --target ac_pc --parallel 1
```

The single LLDB launch returned `0`:

```sh
/usr/bin/lldb --batch --no-lldbinit \
  --source /private/tmp/acgc-lane-subsequent-graph-task-logs/lldb-commands.txt \
  -- /private/tmp/acgc-lane-subsequent-graph-task-build/bin/AnimalCrossing
```

The build-local disc path was only a symlink to the existing ignored local
input; no ISO bytes were copied or separately inspected.

## Counts and command prefixes

| Event | Total | Task 1 | Task 2 |
| --- | ---: | ---: | ---: |
| `graph_draw_finish` | 2 | 1 | 1 |
| `graph_task_set00` | 2 | 1 | 1 |
| `graph_submit_task` | 2 | 1 | 1 |
| `emu64_taskstart_r` entry | 2 | 1 | 1 |
| dispatch callbacks | 20 | 12 | 8 |
| `G_DL` handlers | 14 | 8 | 6 |
| `G_ENDDL` handlers | 1 | 1 | 0 |
| draw-opcode handlers | 0 | 0 | 0 |
| `GXBegin` | 0 | 0 | 0 |
| `emu64_taskstart_r` returns | 1 | 1 | 0 |

Task 1 repeated the lane-96 clean no-draw chain:

```text
DE010000 F0002000
DB060000 80000000
DE010000 F0002001
DE010000 F0002002
DE010000 F0002003
DE010000 F0002004
DE010000 F0002005
DE010000 F0002006
DE010000 F0002007
E7000000 00000000
E9000000 00000000
DF000000 00000000
```

Task 2 entered the live interpreter and exposed this bounded prefix:

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

`F0004006` was observed at the dispatch line; cleanup occurred before its
handler callback. The task-2 return sentinel was not reached. The 12-second
fallback sent `SIGKILL` only to inferior PID `62838`; LLDB reported status `9`,
`kill -0 62838` returned `1`, and no game/debugger process remained.

## Claim boundary and next gate

Proven: a later graph task is scheduled and enters the live runtime; the first
task completes its no-draw chain; the second task begins a continuation prefix.
No draw handler or `GXBegin` was observed in either task.

Not proven: completion/return of the second task, `G_ENDDL` for that task,
`pc_gx_flush_vertices`, v2/Metal encode or presentation, pixels/readback,
input, audio, save/load, simulator/device behavior, natural shutdown, or
playability. This is partial graph progression evidence, not a frame claim.

Logs remain outside Git under
`/private/tmp/acgc-lane-subsequent-graph-task-logs/` until exact-path cleanup.
