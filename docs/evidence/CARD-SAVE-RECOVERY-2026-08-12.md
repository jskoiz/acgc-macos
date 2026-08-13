# Production CARD/Save_t recovery (2026-08-12)

The production save lane was integrated into `upstream/ACGC-PC-Port` as
`55485701225353b0bfc1e46bf2dd167992e18594` (`Validate GCI Save_t recovery
slots`) on `c1/macos-host-launch`, from base `09dd1827b845cd311ee0c79df2d25ac8c855e35c`.
The source checkout was clean after integration. The reference decomp checkout
was clean at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

Changed source files are limited to:

- `upstream/ACGC-PC-Port/pc/src/pc_m_card.c`
- `upstream/ACGC-PC-Port/pc/tests/pc_m_card_restart_corruption_fixture.c`

## What changed

`pc_m_card.c` now validates each encoded `Save_t` slot using the existing codec
and checksum implementation, save identity, supported version (5/6), land-ID
consistency, and land-ID validity. Card A, Card B, and station land-info reads
select the valid main slot first and the embedded GameCube backup slot second.
The fixture exercises the production writer/loader through a narrow
`PC_M_CARD_TEST` seam; it does not add a second save codec.

## Evidence

The pre-fix fixture deterministically loaded the corrupted main marker
`0xDE222222` instead of recovering the intact embedded backup marker
`0x22222222`. After the fix, the exact integrated source snapshot passes:

- native production fixture: `production m_card atomic/restart/corruption recovery: PASS`;
- ASan+UBSan production fixture: same pass, with Darwin leak detection disabled
  because `detect_leaks` is unsupported on this platform;
- existing host CARD adapter round-trip: native pass and ASan/UBSan pass.

The fixture verifies that a completed temporary replacement leaves no `.tmp`,
generation 2 becomes the main file, generation 1 is retained as `.bak1`, a
fresh child process reloads generation 2, a damaged main `Save_t` falls back to
the embedded backup slot, and a damaged whole GCI falls back to the prior
atomic `.bak1` generation.

The focused integrated rerun used the authoritative checkout and compiled
`pc_m_card.c`, `pc_save_bswap.c`, and the fixture with `PC_M_CARD_TEST`,
function/data sections, and `-Wl,-dead_strip`; native and
`-fsanitize=address,undefined` executions both returned 0. The temporary
integration root `/private/tmp/acgc-integrate-card-5548570` was retired after
review.

## Proof boundary

This closes the production CARD file/slot recovery gate. It does not prove the
full game save-manager orchestration, whole-GCI losslessness, physical
GameCube/Dolphin behavior, simulator/device persistence, or general playability.
The ISO and extracted proprietary assets were not copied, extracted, committed,
or changed.
