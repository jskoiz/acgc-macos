# Save_t/CARD recovery fixture at `f19c73f`

Lane 112 (`019ffdba-e4f1-71d1-82fd-573f767a436b`) completed the required
two-upstream crosswalk from PC `dbf6986` and ac-decomp `09ca8e8b`. The existing
production `pc/src/pc_m_card.c` checksum validation and embedded main/backup
fallback already matched the oracle; no production implementation change was
justified.

## Integrated source

- Worker branch: `c1/lane-card-production-recovery`, `3d3204e`.
- Canonical integration branch: `c1/macos-host-launch`, `f19c73f` (cherry-pick).
- Decomp oracle: `master`, `09ca8e8b`.
- Changed files, and only these files:
  - `upstream/ACGC-PC-Port/pc/CMakeLists.txt`
  - `upstream/ACGC-PC-Port/pc/tests/pc_m_card_restart_corruption_fixture.c`
- `pc/src/pc_m_card.c` is unchanged.

The CMake registration makes the existing production recovery fixture
executable and changes only its disposable temporary-root prefix to the lane
name. The fixture exercises atomic generation replacement, fresh-process
reload, corrupted embedded main-slot fallback to backup, and whole-current-GCI
fallback to `.bak1`.

## Integrated verification

Fresh roots:

- Native: `/private/tmp/acgc-integrate-card-recovery-f19c73f-native`
- ASan/UBSan: `/private/tmp/acgc-integrate-card-recovery-f19c73f-asan`

Commands used the registered target with `--parallel 1`:

```sh
cmake --build <root> --target acgc_pc_m_card_restart_corruption_fixture --parallel 1
ctest --test-dir <root> -V --parallel 1 \
  -R '^acgc_pc_m_card_restart_corruption_fixture$'
```

Results:

- Native CTest: `1/1` passed.
- Combined ASan/UBSan CTest: `1/1` passed with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`.
- Fixture output: `production m_card atomic/restart/corruption recovery: PASS`.
- Only existing legacy header/prototype warnings were emitted during compile;
  no sanitizer diagnostics occurred.

## Claim boundary

This proves the host-side production save orchestration and corruption/reload
fixture at the integrated source tip. It does not prove a physical CARD,
device persistence, full game launch, input, audio, Metal, pixels, simulator,
or playability. A future device/persistence gate remains separate.
