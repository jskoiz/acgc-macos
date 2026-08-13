# Game-owned Save_t restart/reload gate — 2026-08-13

The reviewed source/test commit `fcc3e7d0d8ea1569f0dab1b2784e15a87ec9a901`
was integrated into the authoritative PC branch as
`02a003e6c5d4bb9ac5a64812ac3f751d1740d8c4`. It is based on PC
`ac39d0449ac7e42d3b4f926c2816d50e656a96cd` and crosswalked against decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

## What the fixture proves

`pc/tests/pc_m_card_restart_runtime_fixture.c` invokes the production
`aNRST_save` caller, which enters `mCD_SaveHome_bg`, writes a changed `Save_t`
scene marker into a GCI, then forks/execs a fresh process and exercises
`common_data_reinit`/`pc_save_reload` to verify that marker is restored. The
initial GCI is only a valid seed; the tested persistence operation is not
replaced by a direct `pc_m_card_test_write_gci` shortcut.

## Integrated verification

Using the exact integrated source `02a003e`, with generated output under
`/private/tmp/acgc-integrate-save-runtime-02a003e`:

- Native fixture: PASS, exit `0`.
- Combined AddressSanitizer/UndefinedBehaviorSanitizer fixture with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`: PASS, exit `0`.
- Both runs printed:
  `game-owned restart caller -> GCI marker -> common_data_reinit fresh-process reload: PASS`.
- Only the existing `vi.h` visibility and `m_actor.h` unnamed-enum warnings
  appeared; no sanitizer diagnostic or runtime error occurred.

## Boundary

This is a focused caller-driven persistence/reload fixture, not full game
launch or playability proof. It does not establish physical CARD behavior,
whole-GCI opaque fidelity, device persistence, input, audio, Metal/pixel
readback, simulator/device operation, or human playability.
