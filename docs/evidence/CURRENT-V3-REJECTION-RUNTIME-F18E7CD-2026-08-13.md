# Current-tip V3 rejection runtime — 2026-08-13

This is a read-only runtime verification record for the exact integrated PC
source tip. It closes the source/fixture-to-live gap for the V3 builder
predicate only; it does not claim a renderer frame.

## Provenance and scope

- Umbrella at lane preflight: `4cdc08d`; final inspection observed
  `03bcb7b` on both `main` and `c1/apple-port-bootstrap`; the lane made no
  umbrella changes.
- `ACGC-PC-Port`: `c1/macos-host-launch` at `f18e7cda`
  (`Add V3 builder consumer fixture`), clean before and after.
- `ac-decomp`: `master` at `09ca8e8b`, clean before and after.
- Lane type: read-only verification; no source, submodule, documentation, or
  ISO/asset changes.
- Retained roots:
  - `/private/tmp/acgc-lane-current-v3-rejection-runtime-build`
  - `/private/tmp/acgc-lane-current-v3-rejection-runtime-logs`

## Link gate

The lane ran exactly one configure and one serialized `ac_pc` build:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-current-v3-rejection-runtime-build \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON

cmake --build /private/tmp/acgc-lane-current-v3-rejection-runtime-build \
  --target ac_pc --parallel 1
```

Configure and build both returned `0`; Ninja reached `[4018/4019]`. The output
is a native arm64 Mach-O at
`.../bin/AnimalCrossing` (SHA-256
`410c92e711e2d7a50347004fb64b2dcd9dc2d9b31354f9433ce616ca795fa4c0`). The
generated `bin/shaders/` directory was present. The local disc was exposed
only through the ignored `bin/rom/Animal Crossing (USA).iso` symlink; no ISO
bytes were copied or committed.

## One bounded launch

The lane ran exactly one unprivileged supervisor invocation, from the generated
`bin` directory:

```sh
/bin/zsh /private/tmp/acgc-lane-current-v3-rejection-runtime-logs/run-bounded-lldb.zsh
```

The launch created a real `AnimalCrossing` inferior (PID `41563`) and reached
the reconstructed runtime. The LLDB supervisor reached its 20-second bound:

- LLDB PID `41485`; wait status `143`.
- `timed_out=1`, TERM sent to LLDB `1`, KILL sent `0`.
- The supervisor's parser did not associate the already-running inferior and
  recorded `inferior_pid=none`; the LLDB/runtime log independently identified
  PID `41563`.
- The exact inferior PID then received TERM, a three-second grace period
  completed, KILL was not needed, and the final alive check was `0`.
- No elevated retry was attempted.

This was a real launch, not the earlier pre-inferior `nice(5)` failure. It was
externally bounded, so natural shutdown and clean process exit remain
unproven.

## Live counts

| Probe | Hits |
| --- | ---: |
| `graph_task_set00` | 29 |
| `emu64_taskstart` | 29 |
| `GXBegin` | 532 |
| `pc_gx_flush_vertices` | 532 |
| `pc_gx_try_handoff_semantic_packet_v2` | 531 |
| `pc_gx_try_handoff_semantic_packet_v3` | 531 |
| `acgc_metal_packet_consumer_handoff_v3` | 0 |
| `pc_metal_runtime_observe` | 0 |

With `ACGC_METAL_V3_REJECTION_TRACE=1`, the diagnostic emitted its hard cap
of 64 records:

- `reason=alpha_update_disabled alpha_update_enable=0`: `64/64`.
- `reason=other_v3_predicate`: `0`.

The cap means the diagnostic classifies the first 64 captured rejection
records, not all 531 V3 builder entries. The live evidence nevertheless
identifies the captured fail-closed predicate and shows no typed Apple V3
consumer or runtime-observer call followed it.

## Claims and non-claims

Proven here:

- current-tip arm64 configure/build/link;
- real unprivileged process launch and reconstructed boot/graph reachability;
- repeated game-owned GX submission and V3 builder entry;
- live V3 fail-closed diagnostics for `alpha_update_enable == 0`.

Not proven here:

- successful V3 packet construction or Apple consumer acceptance;
- `pc_metal_runtime_observe`, Metal encode/command completion/presentation,
  pixel readback, or a rendered frame;
- input transitions, audible audio, full Save_t/device persistence, simulator,
  physical-device behavior, or playability;
- natural shutdown or clean exit.

Retained raw logs are under the lane log root: `configure.log`, `build.log`,
`lldb-runtime.log`, `supervisor.log`, and `final-counts-and-cleanup.txt`.
