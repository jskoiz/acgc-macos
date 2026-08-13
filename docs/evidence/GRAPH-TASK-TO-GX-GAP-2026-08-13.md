# Graph-task to GX submission gap — 2026-08-13

## Scope and references

Lane 95 was a read-only two-upstream source crosswalk. It performed no build,
launch, source/test/umbrella edit, ISO access, or commit. The handoff snapshot
was umbrella `72ddc05`; the canonical references were `ACGC-PC-Port`
`c1/macos-host-launch` at `d1e812c` (clean) and `ac-decomp` `master` at
`09ca8e8b` (clean). The prior runtime evidence is
[the corrected GX v2 trace](CORRECTED-GX-V2-CALLBACK-TRACE-2026-08-13.md).

The retained LLDB directory from lane 94 is no longer present, so this record
does not reconstruct a command-by-command runtime transcript. It records only
the source crosswalk and the bounded interpretation supported by the existing
counts.

## Source crosswalk

| Boundary | ACGC-PC-Port | ac-decomp oracle | Result |
| --- | --- | --- | --- |
| Graph task entry | `src/graph.c`, `graph_task_set00` (around lines 192–260) | `src/graph.c`, same lifecycle around lines 109–135 | Both set up the task and ucode state. The PC adds capture/profiling and calls `graph_submit_task`; the oracle calls `emu64_taskstart` directly. |
| Submission selector | `src/graph_submission.c`, `graph_submit_task` (around lines 324–337) | No separate layer | The PC chooses an installed callback or the supplied legacy fallback once, synchronously. There is no task queue or deferred continuation. |
| Legacy fallback | `src/graph.c`, `graph_legacy_emu64_submission` (around lines 38–67) | Direct call from `graph_task_set00` | The normal PC path falls through to `emu64_taskstart((Gfx *)work_display_list)`. A source search found no production callback registration. |
| Command traversal | `src/static/libforest/emu64/emu64.c`, `emu64_taskstart_r` (around lines 5965–6122) | `src/static/libforest/emu64/emu64.c` (around lines 5377–5427) | Both execute a synchronous command loop. `G_DL_NOPUSH` advances the inline `gfx_p`; it does not enqueue another task. |
| Display-list continuation | `dl_G_DL` / `dl_G_ENDDL` in the PC `emu64.c` (around lines 3493–3581 / 3637–3656) | Corresponding oracle handlers (around lines 3328–3363 / 3414–3429) | The chain follows arena pointers. `G_ENDDL`, invalid commands, null/invalid targets, malformed host pointers, or cancellation can terminate it. |
| GX draw boundary | `dl_G_TRIN`, `dl_G_QUADN`, `dl_G_TRI2`, `dl_G_TRI1`, `dl_G_QUAD`, and `dl_G_TEXRECT` in `emu64.c` | Corresponding oracle handlers | Draw handlers call `GXBegin`; the scheduler does not. |
| PC flush boundary | `pc/src/pc_gx.c`, `GXBegin`/`GXEnd` and `pc_gx_flush_vertices` (around lines 1171 / 1467–1495) | No PC Metal sink | Without a draw handler, the flush and v2 consumer cannot run. |

The graph topology also agrees: `graph_draw_finish` appends `G_DL_NOPUSH`
branches through the new0, shadow, opaque/translucent, light, font, and
overlay lists before the final overlay `G_ENDDL` (PC `src/graph.c` around
262–332; oracle around 137–207).

## Interpretation of lane 94

Lane 94 recorded:

```text
graph_task_set00       1
emu64_taskstart        1  (one location; the second remained 0)
GXBegin                0
pc_gx_flush_vertices   0
v2 / Apple observers   0
```

This proves graph-task entry and one `emu64_taskstart` location were reached.
It does not prove that `emu64_taskstart_r` completed its command loop, that a
`G_DL` target resolved, that a draw opcode executed, or that the task returned
normally.

- A missing task queue is not supported: submission is synchronous and
  `G_DL_NOPUSH` is inline traversal.
- An initialization-only first segment is possible, but it does not by itself
  explain the whole task if all inline branches were traversed.
- A sentinel that fired before later graph work remains possible. The lane-94
  document names `graph.c:328`, while the checked `d1e812c` source puts that
  line inside `graph_draw_finish` and the graph-task call sites near lines 385
  and 451. With the old LLDB logs gone, exact sentinel placement cannot be
  independently reconstructed.
- Runtime termination before draw work remains the live explanation: normal
  `G_ENDDL`, run-mode/cancellation (`FrameCansel`), an unexpected command, or
  failed/null target resolution are all source-supported possibilities.

## Evidence boundary and next gate

The static path exists from graph task → synchronous fallback →
`emu64_taskstart_r` → display-list continuation → draw handler → `GXBegin` /
`GXEnd` → PC flush. Runtime evidence reaches only graph-task entry and one
`emu64_taskstart` location. There is no game-owned complete-list, GX frame,
Metal encode/present/readback, pixel, input, audio, save/device, simulator,
clean-shutdown, or playability claim here.

The smallest useful successor is one serialized current-tip trace at `d1e812c`
that instruments `emu64_taskstart_r` entry/return, its dispatch/advance state
(`gfx_cmd`, `w0/w1`, `gfx_p`, `gfx_width`, `DL_stack_level`, `end_dl`,
`FrameCansel`, and `err_count`), plus `dl_G_DL`, `dl_G_ENDDL`, and `GXBegin`.
Every LLDB callback must explicitly return `False`. The result distinguishes a
draw opcode, a clean no-draw `G_ENDDL`, target/command validation failure, and
run-mode/cancellation termination without changing production code.
