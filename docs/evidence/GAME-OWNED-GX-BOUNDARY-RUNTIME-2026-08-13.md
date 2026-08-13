# Game-owned GX boundary runtime — 2026-08-13

## Scope and provenance

This is a root-owned, read-only runtime trace against the integrated Apple
source snapshot. The umbrella and local `main` were at
`c1/apple-port-bootstrap` / `2b42cef` when the trace was prepared; the
authoritative PC source was clean at `c1/macos-host-launch` /
`36910c8a9e3abbc013b39978fe52022b933aff01`; and `ac-decomp` was clean at
`master` / `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

The trace used one fresh serialized arm64 `ac_pc` build in
`/private/tmp/acgc-direct-gx-runtime-build` from the canonical PC source. The
configure and link returned `0`; the last visible Ninja line was
`[4012/4013] Linking CXX executable bin/AnimalCrossing; Copying shader files`
with the known section-alignment warning. The resulting executable was an
arm64 Mach-O with SHA-256
`ba3e60ec579c77b7b5edd167ee10001931dd3a11b857904414d59c66ee65f3f1`.
Generated `default.vert` and `default.frag` matched the source shader hashes.

The legally obtained ignored ISO was used only through
`bin/rom/Animal Crossing (USA).iso` and matched the expected SHA-256
`a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`.
No ISO contents or extracted assets were copied into tracked paths.

## Single bounded LLDB boundary trace

The final trace launched directly from the generated `bin` directory with
`ACGC_GRAPH_CAPTURE=1`, `--verbose --no-framelimit`, and the locally supported
`target.launch-working-dir` setting. It ran outside the sandbox because the
sandboxed debugserver path fails before inferior creation; the direct run did
not invoke the failing unprivileged `nice(5)` wrapper. The supervisor recorded
`lldb_wait_status=0`, `timed_out=0`, and no TERM/KILL was required because the
session intentionally stopped at the second breakpoint and quit.

Before `run`, LLDB resolved:

- `GXBegin` at `pc_gx.c:640`, with its breakpoint at the inlined
  `pc_gx_commit_pending_and_flush` path (`pc_gx.c:455:15`);
- `pc_gx_flush_vertices` at `pc_gx.c:936`, with its breakpoint at
  `pc_gx.c:937:22`.

The game then produced the existing root and target captures:

```text
[GRAPH_CAPTURE] version=2 frame=0 source_capacity=256 captured=8 words=de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000
[GRAPH_TARGET_CAPTURE] version=1 frame=0 target=f0002000 target_capacity=1024 captured=8 classification=6 terminator=4294967295 words=db060000,80000000,de010000,f0002001,00000000,00000000,00000000,00000000
```

The first boundary hit was game-owned and resolved to:

```text
GXBegin(primitive=144, vtxfmt=0, nverts=<unavailable>)
  -> emu64::dl_G_TRIN (emu64.c:4932)
  -> emu64::emu64_taskstart_r (emu64.c:6065)
  -> emu64_taskstart (emu64.c:6257)
  -> graph_task_set00 (graph.c:232)
```

The next boundary hit was:

```text
pc_gx_flush_vertices (pc_gx.c:937)
  -> pc_gx_commit_pending_and_flush (pc_gx.c:463)
  -> emu64::dl_G_TRIN (emu64.c:5047)
  -> emu64::emu64_taskstart_r (emu64.c:6065)
  -> emu64_taskstart (emu64.c:6257)
  -> graph_task_set00 (graph.c:232)
```

The process reached `graph_proc`, LOGO initialization/draw, and NEOS output
before the intentional debugger stop. This is the first current-tip,
game-owned GX submission-entry and flush-boundary proof on the direct
no-`nice` path.

## Evidence boundary and next gate

This proves launch, graph boot, root/target capture, and game-owned GX/OpenGL
submission boundaries. It does not prove a complete display list, Metal
encode/present, visible pixel readback, input, audible audio, save/reload,
clean shutdown, simulator/device behavior, or playability. The existing
`pc_gx_flush_vertices()` path still calls the synchronous semantic handoff
only when a complete packet can be built, and the production `ac_pc` runtime
does not register an Apple Metal consumer; the next bounded implementation
lane must bridge that ownership without changing the Windows/OpenGL fallback.

Raw logs are retained outside Git under
`/private/tmp/acgc-direct-gx-runtime-logs/`; they are eligible for cleanup
after the review lane records its crosswalk.
