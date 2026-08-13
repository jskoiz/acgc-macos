# Direct Apple GX callback successor — 2026-08-13

Lane 82 (`019ffbd5-53a3-7371-b1a6-19859c9bbf35`) ran one read-only current-tip
launch attempt against the then-authoritative PC `f4cb491` and decomp
`09ca8e8b`. It completed a serialized `4018/4018` arm64 link and one direct
LLDB launch from the generated `bin` directory. No source, docs, gitlink,
branch, ISO, or asset changed.

The normal launch hit the pre-inferior `nice(5)` permission boundary. Its one
permitted elevated retry created an inferior, reached boot/NEOS, and was
terminated by the external 30-second TERM/grace supervisor; KILL was not
needed and both exact traced PIDs were gone afterward.

## Runtime observations

The direct one-shot breakpoints recorded:

| Symbol | Stops |
| --- | ---: |
| `pc_metal_runtime_observe` | 0 |
| `pc_gx_flush_vertices` | 1 |
| `GXBegin` | 1 |
| `graph_capture_task_submission_target` | 1 |
| `graph_task_set00` | 1 |

The trace recorded `F0002000` target capacity `1024`, `F0002001` continuation
words, LOGO action 3, and repeated NEOS markers. This proves launch, boot,
game-owned graph/target capture, and GX/OpenGL submission reachability at
`f4cb491`. A GX/OpenGL hit is not Metal callback execution.

## Boundary

`pc_metal_runtime_observe` did not execute in this trace, and the final LLDB
breakpoint-list dump was not reached before the external TERM bound; the
counts above are transcript-derived one-shot stops. There is no Metal
encode/present, command-buffer completion, pixel/readback, input, audible
audio, save/device, normal shutdown, or playability claim. Because the lane
predates the integrated sink commit `54b840c`, a fresh current-tip callback
run is required before evaluating the sink against the game-owned path.

The lane retired only its exact generated roots:

```text
/private/tmp/acgc-lane-apple-callback-direct-build
/private/tmp/acgc-lane-apple-callback-direct-logs
```
