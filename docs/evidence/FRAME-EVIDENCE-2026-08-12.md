# ACGC frame evidence gate handoff — 2026-08-12

This handoff records an evidence-only run of `scripts/probes/frame_evidence.py` after the audio lane supplied its runtime log. The probe only reads existing logs and Git metadata. It does not build, launch, link, initialize a Metal device, open a window, copy an ISO, copy extracted assets, edit an upstream submodule, or change the umbrella submodule pointer.

## Result

The gate is **`NOT_CLAIMED`**. No first game-owned visible frame was claimed, because no complete current game-owned submit → renderer packet → encode → present → visible window → readback chain was captured.

| Gate | Status | Meaning |
| --- | --- | --- |
| `launch_survival` | `OBSERVED` | Current runtime log reached `[NEOS_OUT] frame=3241`; no bounded supervisor success marker was present. |
| `boot` | `PASS` | Six accepted game boot milestones were observed. |
| `game_owned_submit` | `UNPROVEN` | No current complete graph-submit marker was emitted. Heartbeats, logo draw output, GBI pointer notices, and shader output do not satisfy this gate. |
| `renderer_packet` | `OBSERVED_FIXTURE` | Synthetic CPU renderer packet/geometry fixtures passed; this is not a game-owned packet. |
| `game_encode` | `UNPROVEN` | No current game-owned encode marker. |
| `game_present` | `UNPROVEN` | No current game-owned present marker. |
| `visible_window` | `SKIP_NO_WINDOW_EVIDENCE` | No explicit visible-window marker was supplied. Fullscreen settings, shader output, swap timing, and process logs are insufficient. |
| `renderer_fixture_device` | `SKIP_NO_DEVICE` | The Metal state and packet-consumer fixture explicitly reported no macOS Metal device. |
| `game_readback` | `SKIP_NO_WINDOW_EVIDENCE` | No window gate means a visible game-surface readback cannot be claimed. |

The missing first-frame prerequisites are exactly:

```text
game_owned_submit, renderer_packet, game_encode, game_present,
visible_window, game_readback
```

## Exact inputs

The probe read these files in place. None were copied into tracked paths.

| Role | Path | Bytes | SHA-256 |
| --- | --- | ---: | --- |
| `runtime` | `/private/tmp/acgc-lane-audio-lp64-build/null-table-guard-gui.log` | 25,832 | `ba4779a1f11c944fd94c99db4bfb154b0805dfb9e7ea6561cf7dceaf45bd8102` |
| `renderer_fixture` | `/private/tmp/acgc-lane-metal-packet-consumer-build/Testing/Temporary/LastTest.log` | 8,354 | `3de90faa715784642ed80f16e22c1d79d40f70d977d5258d16489262bb14866d` |
| `historical_runtime` | `/private/tmp/acgc-lane-render-live-build/cold-run-1-stderr.log` | 3,858 | `4e30ce9a3768f05baf9d09c7c2dbb02799cd956d735dbf6ce551a1bc6d2bf789` |

Selected current evidence:

- Runtime progress: `null-table-guard-gui.log:187` (`frame=1`), `:188` (`frame=61`), `:349` (`frame=3181`), and `:351` (`frame=3241`).
- Boot milestones: `null-table-guard-gui.log:173`, `:190`, `:191`, `:192`, `:194`, and `:208`.
- Synthetic renderer packet/geometry: `LastTest.log:59` and `:123`.
- Explicit no-device skips: `LastTest.log:91` and `:107`, both reporting `SKIP (no macOS Metal device available)`.
- No-window handling: no accepted visible-window marker was present, so the probe recorded `SKIP_NO_WINDOW_EVIDENCE`; readback received the same fail-closed label.

## Source binding

- Runtime log role: `/private/tmp/acgc-lane-audio-lp64`, expected revision `671171c`. At evidence time the checkout was on `c1/lane-audio-lp64` at `5974764a0cc32d005b3b5aa0b06fcf7b457f3597`, dirty, with tree `a0db5de952d8fc01767884a529abd13e4916b06b`; expected tree was `22b98b4fac789cf9368ebbac73f66f5352477996`. Authority is **`MISMATCH_OR_UNRESOLVED`**. The runtime log therefore does not receive an exact clean-source sign-off.
- Renderer fixture: `/private/tmp/acgc-lane-metal-packet-consumer`, `c1/lane-metal-packet-consumer` at `209e95f1f7c322316c1b459b41184a583c710766`, clean, expected revision `209e95f`; authority is **`EXACT_CLEAN`**.

## Historical separation

The historical runtime log contains this legacy prefix at line 18:

```text
[GRAPH_CAPTURE] version=1 frame=0 source_capacity=256 captured=8 words=de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000
```

The harness labels it `game_owned_submit=observed`, `legacy=true`, `complete=0`: it is a game-owned graph prefix, not a complete submit and not a frame claim. It is retained as historical context only and is never joined to the current post-audio gates. In particular, it cannot be combined with the current runtime heartbeats or renderer fixture to manufacture a first frame.

## Reproduction and verification

From the umbrella worktree:

```sh
python3 -m py_compile scripts/probes/frame_evidence.py
python3 scripts/probes/frame_evidence.py --self-test

python3 scripts/probes/frame_evidence.py \
  --runtime-log /private/tmp/acgc-lane-audio-lp64-build/null-table-guard-gui.log \
  --renderer-log /private/tmp/acgc-lane-metal-packet-consumer-build/Testing/Temporary/LastTest.log \
  --historical-runtime-log /private/tmp/acgc-lane-render-live-build/cold-run-1-stderr.log \
  --runtime-source-dir /private/tmp/acgc-lane-audio-lp64 \
  --runtime-source-revision 671171c \
  --renderer-source-dir /private/tmp/acgc-lane-metal-packet-consumer \
  --renderer-source-revision 209e95f \
  --output-dir /private/tmp/acgc-lane-frame-evidence-build \
  --stem post-audio-frame-evidence
```

Verified locally:

- `py_compile`: pass.
- Probe self-test: pass, including a positive complete-chain fixture and negative heartbeat/legacy/no-device/no-window cases.
- Current evidence run: exit 0 with `NOT_CLAIMED` and the statuses above; JSON and Markdown outputs were written under `/private/tmp/acgc-lane-frame-evidence-build`.
- Same run with `--require-first-frame`: exit 2, as required while the chain is incomplete.

The probe's output root is intentionally unique: `/private/tmp/acgc-lane-frame-evidence-build`. No competing full-source link was started, and no ISO or extracted proprietary asset entered the umbrella repository.
