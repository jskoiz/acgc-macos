# Current V4 runtime reachability: `dbf6986`

Lane 111 (`019ffdb2-129d-7900-98f5-837ffe100fbc`) performed exactly one
serialized arm64 `ac_pc` link and exactly one bounded no-`nice` LLDB launch at
the integrated PC tip `dbf6986`. The lane made no source, submodule-pointer,
ISO, or extracted-asset changes. Its retained raw logs are under
`/private/tmp/acgc-lane-current-v4-runtime-logs/` and the ignored build is under
`/private/tmp/acgc-lane-current-v4-runtime-build/`.

## Refs and build

- Umbrella snapshot used by the lane: `99919f1` (detached lane worktree).
- PC source: `c1/macos-host-launch` `dbf6986dc9ca570f157434936ddfd09d176978e6`.
- Decomp oracle: `master` `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Configure: `cmake -S upstream/ACGC-PC-Port/pc -B /private/tmp/acgc-lane-current-v4-runtime-build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`.
- Link: `cmake --build /private/tmp/acgc-lane-current-v4-runtime-build --target ac_pc --parallel 1`.
- Result: `BUILD_STATUS=0`, Ninja `[4019/4019]`, arm64 Mach-O.
- Binary SHA-256: `6448c091675a08dc19c2326b0e08a7d0530bb984c14d8a7561e07beb1cb482b3`.
- The runtime used the ignored local ISO symlink under `bin/rom/`; no ISO bytes
  or extracted assets were copied.

## One launch

The launch was real and reached reconstructed boot output and NEOS frames
(`1`, `61`, and `121`). The supervisor recorded LLDB PID `51753` and inferior
PID `51962`; the deadline was not reached, and no supervisor TERM or KILL was
issued. LLDB stopped at the first explicit `graph_task_set00` breakpoint and
quit. Natural application shutdown was not proven.

The final explicit LLDB counts were:

| Symbol | Hits |
| --- | ---: |
| `graph_task_set00` | 1 |
| `emu64_taskstart` | 0 |
| `GXBegin` | 0 |
| `pc_gx_flush_vertices` | 0 |
| `pc_gx_build_semantic_packet_v3` | 0 |
| `pc_gx_build_semantic_packet_v4` | 0 |
| `acgc_metal_packet_consumer_handoff_v3` | 0 |
| `acgc_metal_packet_consumer_handoff_v4` | 0 |
| `acgc_metal_packet_consumer_prepare_v4` | 0 |
| `pc_metal_runtime_observe` | 0 |

The Python callback failed on the first stop with:

```text
AttributeError: 'SBBreakpoint' object has no attribute 'GetName'
```

Therefore the downstream zeros are not independent dynamic reachability proof:
the inferior remained stopped before GX/flush. Static crosswalk at this tip
does independently show that the live flush path dispatches V1/V2/V3 only and
that V4 handoff/prepare are not registered in `pc_metal_runtime_init`.

## Claim boundary

This lane proves the exact source refs, one successful arm64 link and binary
hash, correctly rooted shaders/ISO symlink, one real boot/NEOS launch, and one
explicit graph-task breakpoint hit. It does **not** prove a game-owned callback,
V4 dynamic reachability, Metal encode/present/readback, a pixel or rendered
frame, input, audible audio, save/device persistence, simulator/device
behavior, natural shutdown, or playability. No retry is authorized by the lane
contract.

Raw handoff: `/private/tmp/acgc-lane-current-v4-runtime-logs/lane-111-handoff.txt`.
