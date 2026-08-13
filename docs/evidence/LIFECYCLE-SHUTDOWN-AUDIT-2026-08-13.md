# Timing, retrace, and lifecycle audit — 2026-08-13

Lane 78 (`019ffbcc-9477-7333-9214-73b6f08f344b`) audited PC `f4cb491` against
decomp `09ca8e8b` without source edits, full link, launch, ISO, or asset access.

## Focused results

The repository's synthetic lifecycle contract passed: monotonic clock,
fixed-phase retrace schedule, focus-loss/resume behavior, condition-variable
worker stop/join, and deterministic termination trace. The focused PC SDL
audio device/producer probe also opened the dummy device, observed 57 callbacks
with zero underruns/overruns, and returned through `pc_audio_shutdown()`.

Those results are adapter-local. The actual PC `pc_vi.c` pacing loop, drift,
vsync interaction, and retrace callbacks were not runtime-proved.

## Integrated lifecycle blocker

The PC OS adapter's `osCreateThread2()`/`osStartThread()` path is effectively
single-threaded, while `mainproc()` calls `graph_proc()` synchronously and then
exits. `g_pc_running` can unwind the graph, but this does not reproduce the
decomp's real thread cancellation/join, message-queue wakeups, GX/VI shutdown,
and reset ordering. The SDL audio producer is the one real host worker and has
an explicit stop/wait/close path.

Historical current-tip TERM evidence shows `graph_proc` returning with status
`0`, but the supervisor has no in-process shutdown marker, worker enumeration,
join ledger, or callback-quiescence proof. That is bounded clean-return
evidence only, not normal user shutdown, complete teardown, or playability.

## Gate disposition

| Gate | Result |
| --- | --- |
| Synthetic timing/worker contract | PASS, synthetic only |
| Actual PC retrace pacing | Not independently proved |
| Isolated SDL audio worker stop/join | PASS, adapter-local |
| Historical bounded TERM return | Observed, not normal shutdown proof |
| Normal user/menu shutdown | Not proved |
| Process-wide graph/OS/audio teardown | Not proved |
| Playability | Not proved |

The next implementation, if opened, must be a narrowly owned lifecycle adapter
change with focused tests; this audit does not justify a broad thread-model
rewrite.

Unique lane root, to retire only after review, was:

```text
/private/tmp/acgc-lane-lifecycle-proof
```
