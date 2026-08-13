# Save_t/GCI restart gate — 2026-08-13

Lane 77 (`019ffbcc-9406-7a23-9847-2f19196bdad0`) ran read-only focused
fixtures against PC `f4cb491` and decomp `09ca8e8b`. The later integrated PC
tip `54b840c` changes only Apple Metal files, so this save boundary is
unchanged; no source, docs, gitlink, ISO, or asset was modified.

## Results

Native and combined ASan/UBSan runs all passed with zero-byte stderr:

- `pc_save_bswap_roundtrip`: codec/checksum/restart round-trip;
- `pc_m_card_restart_corruption_fixture`: production generation replacement,
  `.bak1` retention, fresh-process reload, and corrupted-main/current-GCI
  recovery;
- `pc_m_card_restart_runtime_fixture`: actual game-owned
  `aNRST_save → mCD_SaveHome_bg`, changed `Save_t` scene marker in GCI, fork/exec
  `common_data_reinit`, and fresh-process marker reload.

The fixtures use the PC production caller and crosswalk the decomp's original
`mCD_SaveHome_bg` state machine. No missing normal-restart caller seam was
found.

## Boundary

This proves focused codec, host-adapter atomicity/recovery, and one
game-owned restart/reload orchestration seam. It does not prove full
`second_game_init`/new-game creation, physical GameCube CARD/Dolphin/device
persistence, whole-GCI opaque-byte fidelity, input, audio, Metal/pixel
readback, simulator/device behavior, or playability.

The next owner, if opened, is a narrowly scoped game-start/runtime lane for
no-GCI new-game creation and actual `mCD_InitGameStart_bg`/title-player-select
re-entry—not another codec or CARD-recovery lane.

Unique lane roots, to retire only after review, were:

```text
/Users/jk/.codex/worktrees/7419/acgc-modern-port
/private/tmp/acgc-lane-save-proof
/private/tmp/acgc-lane-save-proof-asan
```
