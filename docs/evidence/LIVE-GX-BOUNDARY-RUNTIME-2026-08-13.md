# Live GX boundary runtime attempt — 2026-08-13

## Scope and identities

Lane 69 performed one read-only LLDB attempt against the integrated Apple
source snapshot. The umbrella was `c1/apple-port-bootstrap` at
`66505b65423628e47a7bb8527388ba72bde3ee69` when the lane started, the
canonical PC source was clean at `c1/macos-host-launch` / `36910c8`, and
`ac-decomp` was clean at `master` / `09ca8e8b`. The lane made no source,
umbrella, submodule-pointer, ISO, or asset changes.

The lane created a detached read-only PC source checkout at
`/private/tmp/acgc-lane-live-gx-boundary-runtime-source` and one serialized
arm64 build under
`/private/tmp/acgc-lane-live-gx-boundary-runtime-build`. The `ac_pc` build
exited `0`; its final visible progress line was `[4012/4013]` while linking
and copying the executable and shaders. The resulting Mach-O was arm64. The
known section-alignment warning remained the only link diagnostic.

The ignored local ISO was exposed only through the build's ignored `bin/rom`
symlink and matched the expected SHA-256
`a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`.
No ISO contents or extracted assets were copied into Git or this evidence.

## LLDB setup and launch result

The one LLDB session used the generated `bin` directory as its launch working
directory, `ACGC_GRAPH_CAPTURE=1`, and `--verbose --no-framelimit`. Before
`run`, the lane verified and recorded:

- `target.launch-working-dir` was accepted;
- `GXBegin` resolved to `pc_gx.c:640`;
- `pc_gx_flush_vertices` resolved to `pc_gx.c:936`;
- both breakpoints resolved, including the inlined
  `pc_gx_commit_pending_and_flush` path.

The launch failed before an inferior was created:

```text
error: process exited with status -1 (no such process)
zsh:55: nice(5) failed: operation not permitted
```

The supervisor recorded `lldb_wait_status=1`, `timed_out=0`,
`term_sent=0`, and `kill_sent=0`. There was no inferior PID, boot marker,
graph capture, target capture, `F0002001`, breakpoint hit, TERM, or KILL.
The exact command and logs remain under
`/private/tmp/acgc-lane-live-gx-boundary-runtime-logs/`, including
`lldb-launch-command.txt`, `launch-blocker.txt`, and `termination.log`.

This is a debugger/supervisor launch blocker, not negative evidence about
the game or GX. The lane made no retry. The prior lane-68 target observer
record remains the only valid fresh target-continuation runtime record; this
lane adds no GX, complete-list, Metal encode/present, pixel/readback, input,
audio, save/load, simulator/device, clean-shutdown, or playability proof.

## Next gate

Any future GX-boundary runtime attempt must preserve the one-launch contract
and first remove the environment-specific pre-inferior blocker (including the
unprivileged `nice(5)` path) with a locally verified supervisor invocation.
It must retain the generated `bin` working directory and the exact source
identity before attempting another LLDB launch. Until then, the project
remains at live target-continuation plus source/fixture GX-boundary readiness,
not a complete game-owned frame or playable macOS port.
