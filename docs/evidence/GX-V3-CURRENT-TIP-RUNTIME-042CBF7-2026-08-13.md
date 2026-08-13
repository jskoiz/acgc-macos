# GX v3 current-tip runtime boundary

Date: 2026-08-13 HST

This root-owned continuation used the integrated ACGC-PC-Port source at
`042cbf7` on `c1/macos-host-launch`, umbrella `bbd9143`, and ac-decomp
`09ca8e8b` on `master`. The ISO remained at the ignored local path and was
verified by SHA-256 as
`a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`.
No disc bytes or extracted assets were copied into tracked paths.

## Link gate

One serialized current-tip link used the ignored root
`/private/tmp/acgc-current-v3-runtime-build`:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-current-v3-runtime-build \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-current-v3-runtime-build --target ac_pc -j1
```

Configure and build returned `0`; the terminal line was
`100% Built target ac_pc`. `file` identified
`/private/tmp/acgc-current-v3-runtime-build/bin/AnimalCrossing` as a native
arm64 Mach-O executable. This is link evidence, not a playability claim.

## Bounded launch attempts

The generated `bin/rom/Animal Crossing (USA).iso` symlink pointed at the
ignored ISO. The LLDB setup used explicit-return Python callbacks for the
graph task, interpreter, GX begin/flush, V2/V3 builder entry, V3 Apple
consumer, and runtime observer symbols. The setup and supervisor artifacts
remain under `/private/tmp/acgc-current-v3-runtime-logs/` until cleanup.

The first direct launch was unprivileged and failed before inferior creation:

```text
error: process exited with status -1 (no such process)
```

No breakpoint was hit in that attempt. One permitted elevated retry of the
same bounded command created game PID `32551`, reached the GAFE01 disc boot,
LOGO initialization, and repeated NEOS output. The supervisor sent SIGTERM to
LLDB at the 20-second bound (`LLDB_STATUS=143`, `TIMED_OUT=1`); no KILL was
sent. A post-run `kill -0 32551` returned `1`, but this is bounded cleanup,
not proof of natural shutdown.

Explicit callback records from the elevated run were:

| Probe | Entry records | Interpretation |
| --- | ---: | --- |
| `graph_task_set00` | 27 | Game-owned graph task entry reached. |
| `emu64_taskstart` | 27 | Interpreter entry reached. |
| `GXBegin` | 550 | Game-owned GX/OpenGL submission boundary reached. |
| `pc_gx_flush_vertices` | 550 | Pending vertices reached the flush boundary. |
| `pc_gx_try_handoff_semantic_packet_v2` | 550 | V2 builder entry attempted. |
| `pc_gx_try_handoff_semantic_packet_v3` | 549 | V3 builder entry attempted. |
| `acgc_metal_packet_consumer_handoff_v3` | 0 | No successful V3 consumer call observed. |
| `pc_metal_runtime_observe` | 0 | Apple runtime callback not observed. |

The V2/V3 counts are function-entry counts, not successful packet
construction or callback counts. The downstream zeroes therefore do not prove
that a V3 packet was accepted; they identify the next narrow diagnostic gate:
capture the V3 builder's fail-closed predicate on the live textured/TEV state.

## Claim boundary and next gate

This run proves current-tip arm64 linking, a real game launch, boot progress,
game-owned GX/OpenGL submission, and repeated V3 builder attempts. It does not
prove a successful V3 callback, Apple consumer acceptance, Metal encode,
command-buffer completion, presentation, pixel readback, input, audible
audio, Save_t/device persistence, simulator/device behavior, natural
shutdown, or playability. The next bounded implementation lane should own a
diagnostic-only V3 rejection reason (or a narrowly justified contract
extension) before any sink/rendering claim is made.
