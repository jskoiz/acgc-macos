# Live Apple GX callback observation — 2026-08-13

## Scope

Read-only lane 73 (`019ffbc7-01e9-7b32-b5b1-f0abaada1b09`) tested one current-tip
arm64 build and one LLDB launch at umbrella `a2fcae8`, PC `f4cb491`, and
decomp `09ca8e8b`. The lane used the canonical populated PC/decomp checkouts
because its delegated worktree had uninitialized submodule directories. No
source, umbrella pointer, ISO, or asset was changed.

The ISO was verified in place at
`local/roms/Animal Crossing (USA).iso` against the approved SHA-256
`a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d`.

## Build gate

The lane configured and built the canonical PC source with:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-current-apple-callback-build \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-lane-current-apple-callback-build \
  --target ac_pc --parallel 1
```

Configure and build returned `0`; all `4018/4018` steps completed and the
generated executable was an arm64 Mach-O. The only diagnostic was the known
section-alignment warning.

## Runtime gate

The one normal-shell LLDB launch resolved the requested symbols but failed
before inferior creation with `process exited with status -1 (no such
process)`; its wrapper also hit a zsh `status` bookkeeping error. The lane did
not retry that path.

The single permitted elevated fallback created an arm64 inferior (`pid 70518`)
from the generated `bin` directory, but the command file stopped at the
stop-at-entry state and never reached `continue`. It produced no boot markers,
runtime markers, termination events, or callback hits. The exact inferior was
gone afterward; an unrelated prior process was left untouched.

| Symbol | Explicit runtime hits |
| --- | ---: |
| `pc_metal_runtime_observe` | 0 |
| `pc_gx_flush_vertices` | 0 |
| `GXBegin` | 0 |
| `graph_capture_task_submission_target` | 0 |
| `graph_task_set00` | 0 |

## Evidence boundary

This lane does not prove or disprove callback reachability: it did not reach
the game runtime after the elevated stop-at-entry point. Symbol resolution is
not callback execution. There is no Metal encode/present, pixel/readback,
input, audible audio, Save_t/device persistence, simulator/device, or
playability claim. The prior root-owned launch remains separately classified
as launch/boot/GX-boundary/bounded clean-return only.

The lane removed only its unique generated roots after capture:

```text
/private/tmp/acgc-lane-current-apple-callback-build
/private/tmp/acgc-lane-current-apple-callback-logs
```
