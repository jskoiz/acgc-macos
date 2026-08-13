# Durable GX v2 breakpoint-count trace — 2026-08-13

## Scope and refs

This read-only lane performed one serialized arm64 build and one permitted
elevated LLDB launch against canonical PC `d1e812c` on
`c1/macos-host-launch`. The supplied umbrella snapshot was `c1f8d62`, and
`ac-decomp` was `09ca8e8b` on `master`. No source, test, umbrella pointer,
documentation, branch, ISO, or extracted asset was changed.

## Build and launch

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-gx-v2-counts-d1e812c-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=OFF \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build /private/tmp/acgc-lane-gx-v2-counts-d1e812c-build \
  --target ac_pc --parallel 1
```

Configure and build returned `0`; the final recorded Ninja progress was
`4018/4019`, and the output was a native arm64 `AnimalCrossing` Mach-O. The
ISO was hashed and exposed only through a generated `bin/rom` symlink; no
contents were copied or printed. The exact LLDB command, command file, and
logs are retained outside Git under
`/private/tmp/acgc-lane-gx-v2-counts-d1e812c-logs/`.

## Counts and bounded result

The one elevated LLDB launch created inferior PID `12695`, reached runtime,
and stopped at the first `graph_task_set00` breakpoint. The durable callback
log and LLDB’s final breakpoint list both recorded:

| Symbol | Count |
| --- | ---: |
| `graph_task_set00` | 1 |
| `emu64_taskstart` | 0 |
| `GXBegin` | 0 |
| `pc_gx_flush_vertices` | 0 |
| `pc_gx_try_handoff_semantic_packet_v2` | 0 |
| `acgc_metal_packet_consumer_handoff_v2` | 0 |
| `acgc_metal_packet_consumer_prepare_v2` | 0 |
| `pc_metal_runtime_observe` | 0 |

These zeros are prefix-only. The temporary one-line Python breakpoint command
called `gx_trace.record_hit(...)` without an explicit Python `return`, so LLDB
received `None` and stopped at the first breakpoint instead of auto-continuing
through the graph task. The return-address sentinel was armed but never
reached. A second launch was not attempted.

LLDB then killed only the exact inferior (`SIGKILL`, status `9`); the wrapper
returned `0`, and `kill -0 12695` returned `1` afterward. No external TERM or
KILL was sent. This proves a bounded elevated launch and prefix observation,
not downstream callback reachability.

## Claims and next gate

The trace does not prove `emu64_taskstart`, GX, v2 callback, Metal consumer,
Metal encode/present/readback, pixels, input, audio, save/device persistence,
simulator/device behavior, clean shutdown, or playability. The only useful
successor is a separately scoped trace-control correction that explicitly
returns `False` from each LLDB Python breakpoint callback, then repeats one
elevated launch with the same claim boundaries.
