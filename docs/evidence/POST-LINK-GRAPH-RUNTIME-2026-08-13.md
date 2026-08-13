# Post-link graph runtime trace (2026-08-13)

This read-only lane used the existing exact arm64 binary built from PC source
`9cf9b3f` and the matching decomp reference `09ca8e8b`. The authoritative PC
source has since advanced to `d0e64f5` with a test-only Save_t fixture; no
runtime source was changed by this lane. Logs were kept under
`/private/tmp/acgc-lane-runtime-post-link-graph`.

## Runtime result

The first sandboxed LLDB attempt was blocked before process creation by
`nice(5) failed: operation not permitted` and LLDB status `-1`. A bounded
escalated trace that had already started before the no-retry instruction was
stopped at the intentional `GXBegin` breakpoint. It reached a real arm64 game
process and emitted `[NEOS_OUT]` frames `1`, `61`, and `121`, plus
`initial_menu_init`, `dvderr_init`, `sound_initial2`, `COPYDATE`, and
`HotStartEntry`.

The configured `pc_graph_submission_capture` and `graph_task_set00`
breakpoints did not fire, and no `[GRAPH_CAPTURE]` record appeared. The
renderer frontier reached `GXBegin`, inlined through
`pc_gx_commit_pending_and_flush` at `pc_gx.c:454`; the wrapper then stopped
without TERM/KILL. No complete packet, encode, present, or readback marker was
observed.

## Classification

The known live record remains `PREFIX_ONLY`: `DE010000 F0002000` followed by
zero-valued observer words, captured `8/256`. `F0002000` is still an opaque
indirect target; no target-list resolution or exact `DF000000 00000000`
terminator was captured. The parser labels were:

```text
RESULT_SUPERVISOR=PASS bounded_lldb_completed
RESULT_LAUNCH=PASS real_game_process_launched_under_lldb
RESULT_BOOT=PASS game_boot_boundary_reached
RESULT_GAME_OWNED_PACKET=FAIL no_complete_game_owned_packet
RESULT_PRESENT=FAIL no_complete_game_owned_presentation
RESULT_FRAME=FAIL no_identifiable_game_frame_with_complete_readback
RESULT_GATE=NOT_RUN classify_only
```

## Evidence boundary

This advances the current runtime to the intentional GXBegin boundary and
confirms the game remains alive through boot markers in a bounded trace. It
does not prove a complete game-owned submission, Metal encode/present, pixel
readback, clean shutdown, input, audio, save/load, simulator/device behavior,
or playability. The next runtime lane must obtain the full bounded
`GRAPH.Gfx_list05` contents or explicitly resolve the `F0002000` indirect list.
