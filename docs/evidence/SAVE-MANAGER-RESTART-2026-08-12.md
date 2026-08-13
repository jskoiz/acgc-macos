# Game-owned save-manager restart boundary (2026-08-12)

This evidence is bound to `upstream/ACGC-PC-Port` source commit
`a7b9dff` (`Exercise mCD_SaveHome_bg in CARD fixture`), whose tree is identical
to lane commit `0465f54` on `c1/lane-full-save-manager`, with
`upstream/ac-decomp` at `09ca8e8b`. The lane worktree was
`/private/tmp/acgc-lane-full-save-manager/source`; its branch is preserved for
provenance after retirement.

## Scope

The focused fixture now sends generation 2 through the existing production
`mCD_SaveHome_bg(0, &chan)` request boundary instead of calling the writer seam
directly. It then exercises the existing fork/exec restart child and production
loader seam. The only changed file is
`upstream/ACGC-PC-Port/pc/tests/pc_m_card_restart_corruption_fixture.c`;
`pc/src/pc_m_card.c` and `pc/src/pc_save_bswap.c` are unchanged.

The crosswalk is intentionally narrow: decomp `src/game/m_card.c` models an
18-phase CARD state machine, while the PC implementation supplies a synchronous
filesystem adapter with atomic GCI replacement, embedded main/backup slots, and
`.bakN` generations. This fixture proves the request boundary reaches that
adapter; it does not recreate the full CARD state machine.

## Exact verification

The lane's final native binary was run from the integrated source tree:

```text
/private/tmp/acgc-lane-full-save-manager/fixture-native/pc_m_card_restart_corruption_fixture
```

Result: `production m_card atomic/restart/corruption recovery: PASS`, exit `0`.

The sanitizer binary was run with leak detection disabled because Darwin's
allocator does not support that check in this focused lane:

```text
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1 \
/private/tmp/acgc-lane-full-save-manager/fixture-asan-ubsan/pc_m_card_restart_corruption_fixture
```

Result: the same `PASS`, exit `0`. Native and sanitizer stderr logs were both
zero bytes. The authoritative and lane trees were compared before this rerun;
their tree IDs matched exactly.

## Proven and not proven

Proven here: a game-owned save request reaches the production Card A adapter;
the transaction selects slot A; the replacement leaves no `.tmp`; a fork/exec
restart reloads generation 2; embedded-backup recovery handles a damaged main
`Save_t`; and a damaged current GCI falls back to the prior `.bak1` generation.

Not proven: the complete decomp CARD state machine, NPC/scene restart flow,
full title launch/save persistence, whole-GCI losslessness, physical-card or
device behavior, or human playability. The next save successor must drive real
startup/restart callers before any game-level persistence claim.
