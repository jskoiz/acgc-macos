# Corrected GX v2 callback trace — 2026-08-13

## Scope and refs

This read-only lane corrected the temporary LLDB control defect from lane 93
and performed exactly one elevated runtime trace against canonical PC
`d1e812c` on `c1/macos-host-launch`. The delegated umbrella snapshot was
`9b177863`; `ac-decomp` was `09ca8e8b` on `master`. No source, test, docs,
branch, submodule pointer, ISO, or extracted asset was changed.

## Corrected control and build

The temporary Python module used eight named LLDB breakpoint functions, each
with an explicit `return False`, bound with `breakpoint command add -F`. A
debugger-owned one-shot return-address sentinel bounded the run without an
outer LLDB interruption.

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-gx-v2-corrected-d1e812c-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=OFF \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build /private/tmp/acgc-lane-gx-v2-corrected-d1e812c-build \
  --target ac_pc --parallel 1
```

Configure and build returned `0`; final recorded Ninja progress was
`4018/4019`, and the output was a native arm64 `AnimalCrossing` Mach-O. The
ISO was exposed only through `bin/rom` as a symlink to the existing ignored
local input. The one elevated LLDB launch returned `0` and ran from the
generated `bin` directory.

## Durable counts

The launch created inferior PID `29517`, reached runtime, continued through
the first graph task, and stopped at the debugger-owned return sentinel at
`graph.c:328`. Durable log lines and LLDB’s final breakpoint list recorded:

| Symbol | Count |
| --- | ---: |
| `graph_task_set00` | 1 |
| `emu64_taskstart` | 1 (one location; a second location remained 0) |
| `GXBegin` | 0 |
| `pc_gx_flush_vertices` | 0 |
| `pc_gx_try_handoff_semantic_packet_v2` | 0 |
| `acgc_metal_packet_consumer_handoff_v2` | 0 |
| `acgc_metal_packet_consumer_prepare_v2` | 0 |
| `pc_metal_runtime_observe` | 0 |

LLDB killed only the exact inferior with status `9` (`SIGKILL`); the post-
cleanup `kill -0 29517` check returned `1`. No external TERM or KILL was sent.

## Interpretation and next gate

The explicit-return correction worked: the earlier lane-93 prefix-control
blocker is closed, and the trace proves the graph task reaches
`emu64_taskstart`. The trace stops at the graph-task return sentinel before
GX submission, so the zero GX/v2/Apple counts are a real bounded result for
this run, not a Python callback artifact. It does not prove a complete list,
game-owned GX frame, v2 callback, Metal encode/present/readback, pixel, input,
audio, save/device persistence, simulator/device behavior, clean shutdown, or
playability. The next useful gate must investigate why this game task does not
reach `GXBegin`/`pc_gx_flush_vertices` under the current runtime setup, without
reusing this trace as Metal or frame evidence.

Logs are retained outside Git under
`/private/tmp/acgc-lane-gx-v2-corrected-d1e812c-logs/` until cleanup retirement.
