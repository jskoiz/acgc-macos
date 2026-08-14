# Current V2 triangle-batch runtime — PC c973dbee

## Scope and provenance

This record covers exactly one serialized native arm64 `ac_pc` link and one
bounded logged-in GUI-session LLDB launch at the integrated triangle-batch
snapshot. It proves that grouped game-owned triangle lists enter the new batch
path and identifies the next fail-closed builder tier. It does not prove a
successful V2 packet, Apple callback, Metal work, a pixel, or playability.

- Umbrella before this evidence: `066e798dacc939ea4f7cd1399a6a3bb4d70cf601`
- PC: `c973dbee8b4461e23aa5e63eeb3178fb256cf6e8`
- Decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Build root: `/private/tmp/acgc-current-v2-triangle-runtime-c973dbee`
- Trace root: `/private/tmp/acgc-current-v2-triangle-runtime-c973dbee-logs`
- Local ignored ISO SHA-256:
  `a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`

The build used a symlink from the ignored build tree to the ignored local ISO.
No ISO bytes, extracted assets, keys, or proprietary data entered Git or the
remote M3 Max.

## Link and launch

The one full-link command was:

```sh
ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v2-triangle-runtime-c973dbee \
  ./script/build_and_run_game.sh --build
```

It returned `0`, reached Ninja `[4018/4019]`, and produced:

```text
Mach-O 64-bit executable arm64
SHA-256 69ce23a0917fa19e06e658abfec9c1385df9834228e0a815d13fc6eb08d46b7a
```

The one launch ran through the logged-in Terminal GUI, with the build `bin`
directory as the working directory, `ACGC_METAL_REJECTION_TRACE=1`, and
explicit-return Python breakpoint callbacks. The real processes were LLDB PID
`99278` and game PID `99306`. All requested function and source-line
breakpoints resolved before launch.

The run opened the local GAFE01 disc, listed all ten FST entries, loaded
COPYDATE and the forest/Famicom data, entered `graph_proc`, created/drew the
LOGO actor, and reached `[NEOS_OUT]` through frame `901`. No fatal signal,
`EXC_BAD_ACCESS`, sanitizer diagnostic, or runtime error was captured.

At the bounded stop the supervisor sent TERM to the game. KILL was not needed;
`graph_proc` returned and the inferior exited status `0`:

```text
GAME_TERM_SENT=1
GAME_KILL_SENT=0
LLDB_TERM_SENT=0
LLDB_KILL_SENT=0
LLDB_WAIT_STATUS=0
GAME_ALIVE_POSTCHECK=0
```

This is a clean response to an external bounded TERM, not natural-shutdown or
playability proof.

## Durable reachability counts

The explicit-return callbacks recorded:

| Boundary | Hits |
| --- | ---: |
| `pc_metal_runtime_init` | 1 |
| `pc_gx_set_semantic_packet_v2_handoff` | 1 |
| `graph_task_set00` | 19 |
| `emu64_taskstart` | 19 |
| `GXBegin` | 218 |
| `pc_gx_flush_vertices` | 218 |
| direct exact-three V2 entry | 0 |
| grouped V2 batch entry | 213 |
| grouped V2 batch guard passed | 213 |
| first grouped slice attempted | 213 |
| `pc_gx_build_semantic_packet_v2_internal` | 213 |
| initial V2 base-state predicate passed | 0 |
| V2 channel/stage predicate passed | 0 |
| V2 packet initialization reached | 0 |
| V2 packet validation reached | 0 |
| grouped V2 callback invocation | 0 |
| `acgc_metal_packet_consumer_handoff_v2` | 0 |
| `acgc_metal_packet_consumer_prepare_v2` | 0 |
| texture/TEV prepare variants | 0 |
| GX/runtime texture-source providers | 0 |
| `pc_metal_runtime_observe` | 0 |
| V3 fallback entry | 218 |
| V4 fallback entry | 218 |

The grouped list sizes were:

| Vertices | Batch entries |
| ---: | ---: |
| 6 | 102 |
| 9 | 11 |
| 12 | 8 |
| 18 | 12 |
| 21 | 16 |
| 24 | 8 |
| 27 | 12 |
| 30 | 16 |
| 39 | 8 |
| 54 | 4 |
| 57 | 8 |
| 66 | 4 |
| 81 | 4 |

Every eligible batch reached its first exact-three builder call. No batch
reached a second slice or any callback because the first slice failed.

## Next blocker

The batch guard proves that topology, bounds, completed `GXBegin`, pending
vertex state, whole-batch expected count, and callback registration were valid.
The internal builder then rejected every first slice before the source-line
milestone immediately after the initial compound state predicate in
`pc_gx_semantic_v2_state_is_supported()`. Later channel/stage, texgen, packet
initialization, TEV, vertex, validation, Apple-consumer, provider, and observer
milestones therefore remained unreachable.

This narrows the next blocker from geometry size to the initial V2 base-state
contract. The single trace intentionally does not guess which member of that
compound predicate rejected the live state. The next dependency-ready source
gate is a bounded, test-backed V2 base-state reason classifier/diagnostic that
also covers the grouped path. A later serialized runtime may then identify the
exact field before any packet ABI or Apple renderer contract is broadened.

## Claim boundary

Proved: current-tip arm64 link, GUI launch, GAFE01 boot, game-owned graph/GX,
live grouped-triangle batch entry, first-slice builder entry, fail-closed
base-state rejection tier, V3/V4 fallback, TERM response, and holder-free game
postcondition.

Not proved: a successful V2 packet, V2 Apple consumer/provider/runtime-observer
call, Metal encode/command completion/present/readback, a game-owned pixel,
physical input, audible audio, save/reload, simulator/device behavior, natural
shutdown, or human playability.
