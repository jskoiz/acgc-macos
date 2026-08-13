# Current Metal sink runtime after shader fix

Date: 2026-08-13 HST

This was one bounded read-only runtime attempt against the exact post-fix
source snapshot: PC `a8f3a8f` on `c1/macos-host-launch`, decomp `09ca8e8b` on
`master`, and umbrella `2def355` at lane start. No source, docs, gitlink,
branch, ISO, or asset changes occurred in the lane.

## Build and launch

The ignored ISO was verified in place with SHA-256
`a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`; its
contents were not printed or copied. Exactly one serialized arm64 `ac_pc` link
ran at Ninja `-j1` and completed successfully, producing
`/private/tmp/acgc-lane-current-sink-runtime-a8f3a8f/bin/AnimalCrossing`.

The normal LLDB attempt failed before inferior creation at `nice(5) failed:
operation not permitted` with status `-1`. One authorized elevated retry
created the game process, used the generated `bin` working directory, and was
externally terminated at the bounded deadline. The orphaned exact game PID was
then sent TERM directly; KILL was not required, and final exact-PID checks found
both LLDB and game PIDs absent. This is not normal clean-shutdown proof.

## Runtime observations

| Probe | Hits | Result |
| --- | ---: | --- |
| `graph_task_set00` | 1 | Reached through `graph_proc`/`emu64_taskstart`. |
| `graph_capture_task_submission_target` | 1 | `F0002000`, capacity `1024`, frame `0`; bounded record remains indirect/incomplete. |
| `GXBegin` | 1 | `GX_TRIANGLES`; primitive reached the pending-flush path. |
| `pc_gx_flush_vertices` | 1 | Reached through `pc_gx_commit_pending_and_flush`. |
| `pc_metal_runtime_observe` | 0 | No game-owned Apple sink callback observed. |

Boot markers included GAFE01 recognition, ten FST files, DOL/REL preparation,
14,495 ROM-direct assets, LOGO actions `0 → 1 → 2 → 3`, NEOS output through at
least frame 781, audio/bank initialization, and a save-path entry without a
found GCI file.

The root graph record was still the bounded eight-word prefix
`DE010000 F0002000` followed by zeroes. The target record captured eight words,
contained `F0002001`, and had no exact `DF000000,00000000` terminator. No
complete display list or rendered frame is claimed.

## Metal and separate gates

The corrected embedded MSL compiled offline in the preceding source lane, but
the runtime did not reach `pc_metal_runtime_observe`. Consequently sink
initialization/counters, Metal encode, command-buffer completion, presentation,
readback, checksum, and pixel values are unobserved. Input, audible audio,
Save_t/device persistence, simulator/device behavior, normal shutdown, and
playability remain separate open gates.

Exact retained artifacts before cleanup review:

- `/private/tmp/acgc-lane-current-sink-runtime-a8f3a8f`
- `/private/tmp/acgc-lane-current-sink-runtime-a8f3a8f-logs`
