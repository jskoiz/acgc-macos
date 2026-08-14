# Current V2 rejection runtime — PC 59d13a98

## Gate and provenance

Root-owned lane 145 consumed one serialized full `ac_pc` build and one LLDB
inferior launch from the canonical populated checkout:

- umbrella registration base: `19a6dcadd57ecddfab984e9b564e2e887ddd44ce`
- PC: `c1/macos-host-launch` at
  `59d13a98e06c4a67c67b5936f5257a6ff82c0d7a`
- decomp oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- build root:
  `/private/tmp/acgc-current-v2-rejection-runtime-59d13a98-build`
- log root:
  `/private/tmp/acgc-current-v2-rejection-runtime-59d13a98-logs`

The local ignored disc input was verified as GAFE01_00 by SHA-256
`a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`.
Only the established ignored symlink under the generated `bin/rom` directory
was used. No ISO bytes, extracted assets, keys, or proprietary data entered Git
or moved to the M3 Max or cloud.

## Build

The single build was invoked with:

```sh
ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v2-rejection-runtime-59d13a98-build \
  ./script/build_and_run_game.sh --build
```

The filesystem reached `No space left on device` while compiling
`m_rcp.c` at the first pass's `[3824/4019]` frontier. Six exact holder-free
generated roots from completed historical lanes were retired, freeing about
1.5 GiB; source worktrees, commits, the retained historical frame screenshot,
the ISO, and active lane roots were preserved. The same build root was resumed,
not replaced by a second clean build. Ninja completed its remaining 183-edge
graph and linked:

```text
/private/tmp/acgc-current-v2-rejection-runtime-59d13a98-build/bin/AnimalCrossing:
Mach-O 64-bit executable arm64
SHA-256 0c160340695e687bd290d8179d7f70e6a59d5ddbbfd6e833a5d069335aaa993a
```

The generated shader files and ignored ISO symlink were present in the
executable working directory. A no-inferior LLDB preflight resolved the three
optimized/static source-line breakpoints plus the public/internal packet and
runtime symbols before the one launch.

## Live result

The one direct `/usr/bin/lldb --batch --no-lldbinit` launch used
`target.launch-working-dir`, explicit-return Python breakpoint callbacks, and
`ACGC_METAL_REJECTION_TRACE=1`. It created real arm64 inferior PID `38037`,
opened the local GAFE01 disc, enumerated `COPYDATE`, mounted both forest
archives, entered `graph_proc`, and reached `[LOGO] draw` plus `[NEOS_OUT]`
through frame `2761`.

The classifier's 64-record cap covered 32 paired builder attempts:

| First bounded reason | `result=-1` records | `result=0` records |
| --- | ---: | ---: |
| `alpha_test` | 18 | 18 |
| `global_count` | 14 | 14 |

The first live pair was:

```text
reason=alpha_test first=0 count=3 expected=6
alpha=7/7/0 refs=8/144 update=0
blend=1/4/5/5 z=0/7/0 color=1 cull=2
chans=1 texgens=1 tev=1 ind=0 fog=0
```

Both alpha comparisons are `GX_ALWAYS`, but the remembered reference bytes are
nonzero. The current V2 predicate rejects those reference bytes before it can
classify blend, depth, write masks, or cull. This contradicts the earlier
source-only prediction that `blend` would be first. It is live evidence of the
predicate order and tuple, not yet proof that the reference-byte rule may be
relaxed.

The first later `global_count` record had two texgens/two TEV stages and
nonzero fog:

```text
reason=global_count first=0 count=3 expected=6
chans=1 texgens=2 tev=2 ind=0 fog=2
```

Those two cohorts require separate contract analysis; the 64-record cap does
not characterize every later draw.

The final explicit-return breakpoint summary was:

```text
graph_task_set00                                      73
emu64_taskstart                                      73
GXBegin                                            3541
pc_gx_flush_vertices                               3541
pc_gx_try_handoff_semantic_packet_v2                  0
pc_gx_try_handoff_semantic_packet_v2_batch          3529
pc_gx_build_semantic_packet_v2_internal             3529
pc_gx_semantic_v2_state_is_supported                3528
acgc_gx_semantic_packet_v2_init                        0
acgc_gx_semantic_packet_v2_validate                    0
acgc_metal_packet_consumer_handoff_v2                  0
acgc_metal_packet_consumer_prepare_v2                  0
acgc_metal_packet_consumer_prepare_v2_texture_source_tev 0
pc_metal_runtime_get_v2_texture_source                 0
pc_metal_runtime_observe                               0
pc_gx_try_handoff_semantic_packet_v3                3540
pc_gx_try_handoff_semantic_packet_v4                3540
```

The supervisor initially recorded `inferior_pid=NOT_FOUND` because LLDB's
redirected formal `Process 38037 launched` line was buffered until process
exit. The already-running inferior was identified from its PID-tagged runtime
output and then verified with `ps` against the exact generated binary and
`--verbose` argument. Manual TERM did not end it within the three-second grace
period, so exact PID `38037` received KILL. LLDB then returned `0` and reported
inferior status `9`. There was no retry, no second inferior, no natural
shutdown, and no clean TERM claim.

## Claim boundary and next gate

Proved:

- current `59d13a98` links as a native arm64 executable and boots the local
  GAFE01_00 input;
- the game reaches real graph/GX/grouped-triangle work;
- the first capped live V2 rejection is `alpha_test`, followed by a distinct
  `global_count` cohort;
- packet initialization, validation, Apple preparation/provider/observer, and
  the Metal sink remain downstream and uncalled in this run.

Not proved: a valid V2 or canonical packet, callback, Apple render-state
mapping, Metal encode/present/readback, a pixel, clean shutdown, physical
input, audible audio, save/reload, simulator/device behavior, or playability.

Next, before any predicate edit, run two bounded reference-first crosswalks:

1. prove whether alpha reference bytes are semantically irrelevant when both
   comparisons are `GX_ALWAYS`, and add a focused predicate/builder parity
   fixture if the PC/decomp contract supports canonicalization;
2. characterize the observed two-texgen/two-TEV/nonzero-fog `global_count`
   cohort against the canonical renderer contract.

Any source change must remain test-first and fail closed for active alpha
comparisons. A successful CPU fixture would still require a new separately
authorized serialized current-tip runtime trace before any callback or Metal
claim.
