# Live target terminator forensic — 2026-08-13

## Question and scope

This read-only lane explains the difference between the live lane-65 target
call and the integrated resolver fixture. It did not launch the game, run a
full `ac_pc` link, edit source, or change the ISO/assets. The authoritative PC
source was `c1/macos-host-launch` at `aea3515`; `ac-decomp` was `master` at
`09ca8e8b`.

## Finding

The mismatch is a live graph-shape difference, with a separate observer-install
difference. It is not an offset/span bug, and the inspected source provides no
evidence that the target list was rewritten after capture.

`sys_dynamic.new0` is `NEW0_SIZE=512` `Gfx` entries. On `TARGET_PC`, each `Gfx`
is 8 bytes, so the arena is exactly:

```text
512 Gfx × 8 bytes ÷ 4 bytes/uint32_t = 1024 uint32_t words
```

The production resolver in `src/static/libforest/emu64/emu64.c` first requires
alignment and containment, then computes capacity as arena-end minus resolved
pointer. Therefore the live capacity of exactly `1024` proves the observed
pointer is `&sys_dynamic.new0[0]`; a positive entry offset would reduce the
capacity by two words per entry.

The live bytes match normal graph construction:

```text
DB060000 80000000   # G_MOVEWORD/segment emitted by game_draw_first
DE010000 F0002001   # G_DL_NOPUSH branch emitted by graph_draw_finish
```

`NOW_BG_OPA_DISP` is the `new0` arena. `graph_draw_finish()` appends an
arena-to-arena continuation branch to that arena, while its explicit `G_ENDDL`
is appended to `NOW_OVERLAY_DISP`, not to `new0`. Thus the live `new0` span is
an arena segment in a larger continuation graph, not an independently
terminated display list. The `F0002001` word is the expected downstream branch
to `Gfx_list08`/the shadow arena.

Relevant source crosswalk:

- `include/sys_dynamic.h:35-50` — `new0` size and arena declaration.
- `include/PR/gbi.h:1932-1940` — target-PC `Gfx` width.
- `src/static/libforest/emu64/emu64.c:55-73,3514-3532` — registry resolution,
  containment, capacity, and observer call.
- `src/game.c:87-92` — first graph segment emission.
- `include/graph.h:135-159`, `src/graph.c:75-98,262-276,371-385,407-451` —
  arena ownership, continuation branches, and frame construction order.
- `include/PR/gbi.h:2062-2066` — `G_DL_NOPUSH` encoding.

## Fixture versus live graph

The integrated fixture deliberately constructs a different target:

```text
new0[0..4] = NOOP
new0[5]     = DF000000, 00000000
work[0]     = G_DL_NOPUSH F0002000
```

That gives the fixture a terminator at word index `10` and proves the resolver’s
bounded-span arithmetic and exact-terminator contract. It does not assert that
the first live `new0` arena has the same contents.

The live target begins with another `G_DL` at word index `2`. The existing
`graph_classify_task_submission_target()` implementation classifies this as
`INDIRECT`; it does not recursively follow `F0002001` looking for a terminator
in another arena. The runtime therefore correctly exposed a 1,024-word target
extent with no local `DF000000,00000000` pair.

## Observer condition

The live application installs the root capture callback when
`ACGC_GRAPH_CAPTURE=1`, but it does not install the target-capture callback:

- `pc/src/pc_main.c:251-274` — root callback setup.
- `src/graph_submission.c:271-283` — target callback is optional and returns
  immediately when unset.
- `src/static/libforest/emu64/emu64.c:3527` — production caller invokes the
  target observer only after successful registry resolution.

Lane 65’s LLDB run therefore observed the target function arguments and memory,
but no runtime `GraphTaskSubmissionTargetCapture` record was produced. The
focused fixture explicitly installs that callback and passes the synthetic
terminated-list case.

## Focused verification

Using the retained resolver binaries only (no rebuild, full link, or game
launch), the lane reran:

```text
/private/tmp/acgc-lane-live-target-resolver-build/native/acgc_pc_live_graph_target_capture_fixture
  exit 0 / PASS

ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
/private/tmp/acgc-lane-live-target-resolver-build/sanitizer/acgc_pc_live_graph_target_capture_fixture
  exit 0 / PASS

/private/tmp/acgc-lane-live-target-resolver-build/native/acgc_graph_indirect_target_tests
  exit 0 / PASS

ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
/private/tmp/acgc-lane-live-target-resolver-build/sanitizer/acgc_graph_indirect_target_tests
  exit 0 / PASS
```

The fixture again proves live `emu64_taskstart → dl_G_DL` resolution, bounded
capacity, and stale-handle failure after reset. It does not prove a complete
game-owned graph or frame.

## Smallest next lane

The next useful lane is a narrow opt-in live observer/continuation implementation:
install the existing target callback only under `ACGC_GRAPH_CAPTURE`, capture
first-level target metadata and child handle `F0002001`, then resolve the
downstream arena chain with explicit cycle, span, and registry-lifetime limits.
The next lane should search across graph arenas rather than require a terminator
inside `new0` alone. No Metal, pixel, input, audio, save/load, device, clean
shutdown, or playability claim follows from this forensic result.
