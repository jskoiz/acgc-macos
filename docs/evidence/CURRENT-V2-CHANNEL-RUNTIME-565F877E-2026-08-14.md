# Current V2 channel-contract runtime — PC 565f877e

## Scope

This record covers one serialized native arm64 `ac_pc` link and one bounded
logged-in GUI-session LLDB launch at the integrated V2 channel-source snapshot.
It proves boot and live game-owned GX/V2-builder reachability and identifies
the first V2 builder rejection. It does not claim a successful V2 packet,
Apple consumer call, Metal work, a pixel, device behavior, or playability.

- Umbrella: `91f7aeb1515554b4f8fbfb87ff6a3456048c475a`
- PC: `565f877e175ee8d3deae174ba5b0f8edb85ce0b0`
- Decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Build root: `/private/tmp/acgc-current-v2-channel-runtime-565f877e`
- Trace root: `/private/tmp/acgc-current-v2-channel-runtime-565f877e-logs`
- Local ignored ISO SHA-256:
  `a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`

The build used a symlink from the ignored build tree to the ignored local ISO.
No ISO bytes, extracted assets, keys, or proprietary data were copied into Git
or transferred to the remote M3 Max.

## Build and launch

The single full-link command was:

```sh
ACGC_GAME_BUILD_DIR=/private/tmp/acgc-current-v2-channel-runtime-565f877e \
  ./script/build_and_run_game.sh --build
```

It returned `0`, reached Ninja `[4018/4019]`, and produced this native binary:

```text
Mach-O 64-bit executable arm64
SHA-256 d1b7a32817ae6e3b6f78aa1f2245e887e11eb1d87dd3951124621689222d34e4
```

The one LLDB launch used the logged-in Terminal GUI, the build directory as the
working directory, explicit-return Python breakpoint callbacks, and
`ACGC_METAL_REJECTION_TRACE=1`. All requested symbols resolved before launch.
The real processes were LLDB PID `1602` and game PID `1622`.

The disc/FST opened as GAFE01, all ten FST entries were listed, COPYDATE and the
Famicom archive mounted, and the run reached `graph_proc`, LOGO actor/draw, and
`[NEOS_OUT]` through at least frame `841`. No fatal signal or
`EXC_BAD_ACCESS` was captured.

At the bounded stop, the supervisor sent TERM and did not need KILL:

```text
LLDB_TERM_SENT=1
LLDB_KILL_SENT=0
LLDB_WAIT_STATUS=143
GAME_TERM_SENT=1
GAME_KILL_SENT=0
GAME_ALIVE_POSTCHECK=0
```

This is a bounded external stop, not natural-shutdown proof.

## Durable runtime counts

The explicit-return breakpoint callbacks recorded:

| Symbol | Hits |
| --- | ---: |
| `pc_metal_runtime_init` | 1 |
| `pc_gx_set_semantic_packet_v2_handoff` | 1 |
| `graph_task_set00` | 26 |
| `emu64_taskstart` | 26 |
| `GXBegin` | 510 |
| `pc_gx_flush_vertices` | 510 |
| `pc_gx_try_handoff_semantic_packet_v2` | 509 |
| `acgc_metal_packet_consumer_handoff_v2` | 0 |
| `acgc_metal_packet_consumer_prepare_v2` | 0 |
| `acgc_metal_packet_consumer_prepare_v2_texture_tev` | 0 |
| `acgc_metal_packet_consumer_prepare_v2_texture_source_tev` | 0 |
| `pc_gx_get_v2_texture_source` | 0 |
| `pc_metal_runtime_get_v2_texture_source` | 0 |
| `pc_metal_runtime_observe` | 0 |

The bounded V2 diagnostic emitted exactly 64 records: 32 preflight records
with `result=-1`, followed by the same 32 attempts rejected with `result=0`.
There was no `result=1`. Among the 32 rejected batches, vertex counts were:

| Vertices | Rejected batches |
| ---: | ---: |
| 4 | 1 |
| 6 | 21 |
| 9 | 2 |
| 18 | 1 |
| 21 | 4 |
| 27 | 2 |
| 66 | 1 |

Thirty-one samples were `GX_TRIANGLES` (`0x90`) and every count was a multiple
of three. One sample was `GX_QUADS` (`0x80`) with four vertices. No sampled
batch contained exactly three vertices.

## First live blocker

`pc_gx_build_semantic_packet_v2` rejects before packet construction when
`vertex_count != 3`. That is the first live predicate for every sampled batch,
so the integrated disabled-channel contract is not reached by this runtime.

The fixed-width semantic packet already has capacity for 128 vertices and its
generic validator recognizes triangle lists, but the Apple renderer-neutral
geometry and typed consumer intentionally accept exactly three vertices and
one draw. Broadening only the builder would therefore move the rejection into
the Apple consumer.

The narrow dependency-ready source gate is instead a preflighted triangle-list
handoff in `pc_gx`: keep the direct three-vertex V2 builder and Apple consumer
unchanged, validate every three-vertex slice before any callback, then emit one
synchronous V2 packet per triangle. Nonmultiples, quads, unsupported state, or
any failed slice must produce no V2 callback. Legacy OpenGL remains the real
submission path.

## Claim boundary

Proved here: current-tip full arm64 link, logged-in GUI launch, GAFE01 boot,
game-owned graph/GX flush, V2 callback registration, V2 builder attempts,
bounded rejection records, and holder-free post-stop process state.

Not proved: a successful V2 packet, Apple typed-consumer/provider/runtime-
observer call, Metal encode/present/readback, a game-owned pixel, physical
input, audible audio, save/reload, simulator/device behavior, natural shutdown,
or playability.
