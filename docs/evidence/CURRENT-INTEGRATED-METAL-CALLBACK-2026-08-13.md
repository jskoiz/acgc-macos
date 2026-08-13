# Current integrated Apple callback trace

Date: 2026-08-13 HST

This was one bounded read-only runtime attempt after the Apple offscreen sink
integration. The lane was initially anchored to umbrella `f8a19ce`, PC
`54b840c`, and decomp `09ca8e8b`; the canonical PC branch advanced to
`59aa655` while the serialized link was running. The only intervening PC
changes were the input-frame fixture and its CMake registration, and the
runtime files used by this trace were unchanged. The result is therefore a
runtime trace with recorded source-tip drift, not a strict `54b840c` binary.

## Build and provenance

- PC source used by the generated binary: `59aa655` on `c1/macos-host-launch`.
- Decomp: `09ca8e8b` on `master`, clean.
- ISO hash was verified in place as
  `a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`; no
  contents were printed, copied, or committed.
- Exactly one serialized arm64 `ac_pc` link completed. The generated binary
  is `/private/tmp/acgc-lane-current-sink-callback-build/bin/AnimalCrossing`.
- No source, docs, gitlink, branch, ISO, or asset mutation occurred in the
  lane.

## Observed runtime boundaries

| Probe | Hits | Observation |
| --- | ---: | --- |
| `graph_task_set00` | 1 | Reached from `graph.c:196:5` through `graph_main`/`graph_proc`. |
| `graph_capture_task_submission_target` | 1 | `F0002000`, target buffer `0x1016efbe0`, capacity `0x400`, frame `0`. |
| `GXBegin` | 1 | `GX_TRIANGLES`, count `6`, stopped in the pending-flush path. |
| `pc_gx_flush_vertices` | 0 | No flush boundary observed. |
| `pc_metal_runtime_observe` | 0 | No game-owned Apple sink callback observed. |

Boot markers included the GAFE01 disc/FST, 14,495 loaded assets, LOGO actor
creation/draw, NEOS frames, graph capture enablement, and root/target records.
This proves launch/boot/game-owned graph-target/GXBegin reachability only.

## Sink blocker and claim boundary

The integrated sink failed during Metal shader compilation:

```text
ACGC Metal sink shader compile failed:
program_source:25:32: error: expected unqualified-id
    AcgcMetalSinkVertex vertex = vertices[vertex_id];
```

No sink status/counter snapshot was emitted. There is no direct evidence of
game-owned Metal encoding, command-buffer completion, presentation, readback,
or pixels. Input, audible audio, save/device persistence, simulator/device,
clean normal shutdown, and playability remain separate open gates.

The normal LLDB launch failed pre-inferior at the host `nice(5)` permission
boundary. One allowed elevated retry created an inferior, stopped at
`GXBegin`, and then stopped because optimized arguments were unavailable to
the debugger command block. Exact-PID cleanup left no live process; no clean
runtime shutdown is claimed.

The preserved lane artifacts were:

- `/private/tmp/acgc-lane-current-sink-callback-build`
- `/private/tmp/acgc-lane-current-sink-callback-logs`
