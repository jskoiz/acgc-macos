# Live GX v2 callback reachability evidence — 2026-08-13

## Scope and refs

This was one serialized current-tip runtime attempt against the version-aware
GX v2 consumer integrated at canonical PC `d1e812c` on
`c1/macos-host-launch`. The umbrella evidence snapshot was `4011472` and
`ac-decomp` was `09ca8e8b` on `master`. The lane was read-only: no source,
umbrella pointer, documentation, ISO, or extracted asset was changed or
copied.

The static crosswalk is:

`graph_task_set00` → `graph_submit_task` / `graph_legacy_emu64_submission` →
`emu64_taskstart` / `GXBegin` → `pc_gx_flush_vertices` →
`pc_gx_try_handoff_semantic_packet_v2` →
`acgc_metal_packet_consumer_handoff_v2` → `pc_metal_runtime_observe`.

The decomp oracle supplies the existing emu64/GX path; it has no Apple
`pc_*` boundary. Relevant PC locations are `src/graph.c:192`,
`pc/src/pc_gx.c:1467`, `pc/apple/src/metal_packet_consumer.c:307`, and
`pc/apple/src/pc_metal_runtime.c:75`.

## Link gate

The exact source checkout was configured and linked under:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-gx-v2-runtime-d1e812c-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=OFF \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build /private/tmp/acgc-lane-gx-v2-runtime-d1e812c-build \
  --target ac_pc -- -j 1
```

Configure exited `0`; the exact source and arm64 cache value were confirmed.
The link exited `0` at `4019/4019` and produced the arm64 Mach-O
`/private/tmp/acgc-lane-gx-v2-runtime-d1e812c-build/bin/AnimalCrossing`.
Generated shaders stayed under the ignored build root. The `rom` input was a
symlink to the already-local ISO directory, not a copy.

## Single LLDB attempt

The one direct no-nice launch was run from the prepared build working directory:

```text
script -q /private/tmp/acgc-lane-gx-v2-runtime-d1e812c-logs/lldb-trace.log \
  /Applications/Xcode.app/Contents/Developer/usr/bin/lldb \
  /private/tmp/acgc-lane-gx-v2-runtime-d1e812c-build/bin/AnimalCrossing
(lldb) run -- --verbose --framelimit 1
```

All requested breakpoints resolved, but the inferior failed before boot. Every
boundary had zero hits:

| Boundary | Hits |
| --- | ---: |
| `pc_metal_runtime_init` | 0 |
| `pc_gx_set_semantic_packet_v2_handoff` | 0 |
| `graph_task_set00` | 0 |
| `graph_submit_task` | 0 |
| `graph_legacy_emu64_submission` | 0 |
| `emu64_taskstart` | 0 |
| `GXBegin` | 0 |
| `pc_gx_flush_if_begin_complete` | 0 |
| `pc_gx_flush_vertices` | 0 |
| `pc_gx_try_handoff_semantic_vertices` | 0 |
| `pc_gx_try_handoff_semantic_packet_v2` | 0 |
| `acgc_metal_packet_consumer_handoff_v2` | 0 |
| `acgc_metal_packet_consumer_prepare_v2` | 0 |
| `pc_metal_runtime_observe` | 0 |

Exact debugger result:

```text
error: process exited with status -1 (no such process)
Process 75242 exited with status = -1 (0xffffffff) no such process
```

The LLDB/script wrapper returned `0` after explicit `quit`; the inferior status
was `-1`. No TERM or KILL was sent because the inferior was already gone. No
retry or elevated fallback was attempted. The preflight process-list check was
also unavailable (`sysmond service not found` / `pgrep: Cannot get process
list`).

Logs are retained outside Git at:

- `/private/tmp/acgc-lane-gx-v2-runtime-d1e812c-logs/configure.log`
- `/private/tmp/acgc-lane-gx-v2-runtime-d1e812c-logs/ac_pc-link.log`
- `/private/tmp/acgc-lane-gx-v2-runtime-d1e812c-logs/lldb-trace.log`

## Claim boundary and next gate

The exact source call chain is statically wired, and the arm64 link passes, but
runtime callback reachability remains unverified because the process never
started. This run provides no game-owned callback, frame, Metal encode/present/
readback, pixel, input, audio, save/device, simulator/device, or playability
evidence. A future retry must first own and resolve the launch-environment
failure; it must remain a separate, serialized runtime gate.
