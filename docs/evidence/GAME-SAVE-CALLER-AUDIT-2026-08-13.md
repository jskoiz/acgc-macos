# Game-owned Save_t/CARD caller audit — 2026-08-13

This read-only audit is from visible task
`019ffaad-cd2e-7ec3-8848-f0d409c6969c`, bound to PC source
`c1/macos-host-launch` at `ac39d0449ac7e42d3b4f926c2816d50e656a96cd` and
`ac-decomp` at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. No source, umbrella,
submodule pointer, launch, full link, test, ISO, or asset was touched.

## Caller and state map

Persistence is request-driven, not dirty-flag-driven:

| State | Reconstructed caller | Boundary |
| --- | --- | --- |
| New game | `aNPS_setup_game_start` → `mCD_InitGameStart_bg(..., start_cond 0)` | `mSDI_StartDataInit` mutates live `Save_t`; PC sets `pc_save_ready` but does not write a GCI yet |
| Existing/new-player/foreigner selection | Player-select-2 maps talk choices to start conditions and calls `mCD_InitGameStart_bg` | Incremental CARD start/load phases |
| In-memory mutation | `Save_Get`/`Save_Set` macros | Direct field access; no centralized Save-specific dirty/request flag was found |
| Normal save | Restart NPC `aNRST_save` → `mCD_SaveHome_bg(param)` | `param=0` full title save; `param=1` door save |
| Travel save | Station Master → `mCD_CheckStation_bg` → `mCD_SaveStation_NextLand_bg` or `mCD_SaveStation_Passport_bg` | Travel-specific main/backup/other writes; passport is memory-only on PC |
| Reload | `second_game`, `common_data_reinit`, title actor `pc_save_reload`, and Resetti recheck | Initial load/reload are distinct from the in-memory `mCD_toNextLand` transfer |

The reconstructed phase tables are ten steps for
`mCD_InitGameStart_bg`, eighteen for `mCD_SaveHome_bg`, ten for
`mCD_SaveStation_NextLand_bg`, and fifteen for
`mCD_SaveStation_Passport_bg`. The restart path is the smallest real
game-owned persistence request beyond the existing adapter fixture.

## PC adapter boundary

The PC writer rebuilds a fresh `0x72000` GCI data region, serializes typed
`Save_t`/ARAM blocks, duplicates the main data into the embedded backup, and
atomically replaces the file. `pc_save_write_gci_to` returns success without a
write when `pc_save_ready` is false. The existing
`pc_m_card_restart_corruption_fixture.c` primes `Save_t` and sets that host
state directly, so it proves production recovery/atomicity but not game-owned
new-game creation, gameplay mutation, restart dialogue, station travel, or
playability. `mCD_LoadLand` is a PC no-op; explicit initial/title/recheck paths
perform reload.

## Smallest safe runtime gate

The next game-level save gate should:

1. Start with no GCI and reach the real new-game caller.
2. Confirm a deterministic persistent marker changes in live `Save_t`.
3. Reach the restart NPC full-save path (`aNRST_save` /
   `mCD_SaveHome_bg(0, ...)`).
4. Assert actual GCI creation and marker change.
5. Start a fresh process and verify the marker through `second_game` and the
   title/player-select reload path.

Source ownership should be limited to the restart caller, the existing
`second_game.c`/`m_common_data.c` reload entry points, and the PC adapter seam;
the host recovery fixture remains separate.

## Blockers and evidence boundary

Physical CARD/device behavior, whole-GCI opaque fidelity, and human
playability remain unproven. A successful host-adapter return is not game-level
persistence proof; no launch, frame, input, audio, device, or playability claim
was made by this audit.
