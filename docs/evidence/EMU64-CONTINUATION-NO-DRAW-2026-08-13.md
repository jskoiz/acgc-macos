# emu64 continuation no-draw trace — 2026-08-13

## Scope and references

Lane 96 performed exactly one serialized configure/build and one bounded arm64
LLDB launch against the canonical PC source. It made no source, test, docs,
submodule-pointer, ISO, or asset changes. The umbrella snapshot was
`656446d`; `ACGC-PC-Port` was clean at `d1e812c` on
`c1/macos-host-launch`; `ac-decomp` was clean at `09ca8e8` on `master`.

## Build and launch

Configure returned `0`:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-emu64-continuation-trace-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=OFF \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

The single serialized link returned `0` at `[4018/4019]` and produced an
arm64 `AnimalCrossing` Mach-O:

```sh
cmake --build /private/tmp/acgc-lane-emu64-continuation-trace-build \
  --target ac_pc --parallel 1
```

The single LLDB launch returned through the debugger-owned sentinel:

```sh
/usr/bin/lldb --batch --no-lldbinit \
  --source /private/tmp/acgc-lane-emu64-continuation-trace-logs/lldb-commands.txt \
  -- /private/tmp/acgc-lane-emu64-continuation-trace-build/bin/AnimalCrossing
```

The executable used the existing ignored ISO through the lane-local `bin/rom`
symlink. Wrapper PID `49255` exited `0`; exact inferior PID `49260` was killed
by the debugger-owned return sentinel. No fallback TERM/KILL was needed.

## Runtime observations

| Event | Result |
| --- | ---: |
| `graph_task_set00` | 1 |
| `emu64_taskstart_r` entry | 1 |
| command dispatches | 12 |
| `dl_G_DL` | 8 |
| `dl_G_ENDDL` | 1 |
| `GXBegin` | 0 |
| `FrameCansel` | 0 |
| `err_count` | 0 |
| `emu64_taskstart_r` return | `x0 = 0` |

The observed command words were:

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

`DE010000` is `G_DL_NOPUSH` (`PR/gbi.h`). All eight targets resolved to the
next inline `gfx_p` continuation. The final `G_ENDDL` was followed immediately
by the task return; no unexpected command, invalid target, cancellation, or
error path appeared.

## Instrumentation limitation

The temporary callback read `work_ptr`, `end_dl`, and `DL_stack_level` using
32-bit header offsets. Those pointer-sized arm64 fields are differently
aligned, so their printed raw values are excluded. The classification relies
only on valid command words and `gfx_p` transitions, the resolved
`G_DL_NOPUSH` handlers, `FrameCansel=0`, `err_count=0`, the absence of dispatch
after `G_ENDDL`, and return value `0`. No sanitizer or focused probe ran.

## Claim boundary and next gate

Proven: launch reached the game-owned graph task; its synchronous interpreter
completed a clean no-draw display-list chain; `GXBegin` was not reached.

Not proven: `pc_gx_flush_vertices` for this run, v2/Metal encode or present,
pixel readback, input, audio, save/load, simulator/device behavior, natural
shutdown, or playability. The next useful runtime gate is a separately scoped
trace of the subsequent graph-task scheduling/frame progression, not a Metal or
pixel claim from this no-draw task.

Logs remain outside Git under
`/private/tmp/acgc-lane-emu64-continuation-trace-logs/` until exact-path cleanup.
