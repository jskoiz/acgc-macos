# Graph-capture activation evidence — 2026-08-13

This evidence is from visible task `019ffaad-ca28-7c62-bd0f-018d6d82d6d3`.
It is bound to the authoritative PC source `c1/macos-host-launch` at
`ac39d0449ac7e42d3b4f926c2816d50e656a96cd` and `ac-decomp` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The delegated umbrella worktree
was detached and had empty submodule placeholders; no source or umbrella files
were changed by the lane.

## Bounded command and result

The single permitted launch used the source-supported presence-based switch:

```text
ACGC_GRAPH_CAPTURE=1 \
/private/tmp/acgc-integrated-post-graph-metal-9cf9b3f/bin/AnimalCrossing \
  --verbose --no-framelimit
```

The existing ignored ISO symlink was used in place; no ISO or extracted asset
was copied, printed, or committed. The child received `TERM` and exited `0`
without a signal. The complete combined log remains outside Git at:

`/private/tmp/acgc-lane-graph-capture-activation/attempt.6oVSFY/combined.log`

## Evidence gates

| Gate | Result | Evidence |
| --- | --- | --- |
| Opt-in observer enabled | PASS | `[GRAPH_CAPTURE] callback=enabled` |
| Game-owned capture emitted | PASS | One record, `version=2`, `frame=0` |
| Complete graph submission | **NOT PROVEN** | `captured=8` of `source_capacity=256`; no terminator or resolved indirect target |
| Submit → encode → present → readback | **NOT PROVEN** | No complete encode, present, pixel-readback, or terminator marker |
| Bounded termination | PASS | `TERM` grace path returned status `0` |

Exact emitted record:

```text
[GRAPH_CAPTURE] version=2 frame=0 source_capacity=256 captured=8 \
words=de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000
```

The PC source enables the observer whenever `getenv("ACGC_GRAPH_CAPTURE")` is
non-NULL (`pc/src/pc_main.c`); `graph_task_set00` observes `GRAPH.Gfx_list05`
before legacy emu64 setup (`src/graph.c`), and the decomp maps that field to
`sys_dynamic.work` (`upstream/ac-decomp/src/graph.c`). The fixed-width
classifier recognizes the `0xDE`/`0xF0002000` shape as an indirect display-list
edge, but the eight-word observer output is still evidence-level
`PREFIX_ONLY`: it does not establish the target list, a complete terminator,
or a draw.

## Boundary and next gate

This closes the “hook disabled” question and proves a deterministic live
game-owned prefix with clean bounded termination. It does **not** prove a
rendered frame, Metal encode/present/readback, input, audible audio, save/load,
simulator/device behavior, or playability. The next useful lane is a
source-backed resolution/capture of the `F0002000` indirect target or the full
`GRAPH.Gfx_list05` work arena, followed by separate GX/Metal encode, present,
and pixel-readback gates.
