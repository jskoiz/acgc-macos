# GX V4 Apple consumer validation — 2026-08-13

This record covers the reviewed V4 typed-consumer/validation seam. It does not
claim a live V4 callback, Metal output, pixel, device, or playability result.

## Provenance and ownership

- Visible lane: `019ffd9e-1fb9-7153-bf9b-2d7dea3f3eed`.
- Worker branch: `c1/lane-gx-v4-consumer` at `63b772e`.
- Worker base: PC `4fc6f00`.
- Integrated canonical PC: `c1/macos-host-launch` at `dbf6986`, clean after
  focused verification.
- Decomp oracle: `master` at `09ca8e8b`, clean.
- Worker worktree: `/Users/jk/.codex/worktrees/6756/acgc-modern-port`.
- Worker roots:
  - `/private/tmp/acgc-lane-gx-v4-consumer-native-4fc6f00`
  - `/private/tmp/acgc-lane-gx-v4-consumer-asan-4fc6f00`
- Integrated verification roots:
  - `/private/tmp/acgc-integrate-v4-consumer-dbf6986-native`
  - `/private/tmp/acgc-integrate-v4-consumer-dbf6986-asan`

## Two-upstream crosswalk

The PC V4 builder at `4fc6f00` preserves the V3 payload and appends
`alpha_update_enable`, producing the fixed `4972`-byte V4 ABI with state mask
`0x7`. The live PC flush path still dispatches only the established V1/V2/V3
handoffs, so this lane does not claim a live V4 callback.

The decomp oracle at `09ca8e8b` has `GXSetAlphaUpdate(GX_FALSE)` at
`src/static/libforest/emu64/emu64.c:619`, with related true/false transitions
in initialization, cleanup, and z-mode paths. It has no packet or Apple
consumer counterpart; the consumer therefore validates the host packet without
inventing a decomp-side adapter.

## Implementation boundary

The integrated commit changes exactly five files:

- `pc/CMakeLists.txt`
- `pc/apple/include/acgc/metal_packet_consumer.h`
- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/src/pc_metal_runtime.c`
- `pc/tests/pc_gx_semantic_v4_consumer_fixture.c`

The consumer now has a typed V4 prepare/handoff path that validates the full
packet, accepts explicit alpha-write values `0` and `1`, reuses only the
existing V1 geometry fixture, and marks V3/V4 state extensions
`NOT_RENDERED`. The runtime sink guard recognizes both non-rendered extension
statuses. The fixture covers enabled and disabled alpha writes plus malformed
alpha-value and unsupported-state-mask rejection. V1, V2, V3, and legacy
OpenGL behavior remain separate. No `pc_gx.c`, packet-builder, decomp, or
renderer-builder file changed in this lane.

## Integrated verification

Both roots were configured from canonical PC `dbf6986` with
`PC_DARWIN_COMPILE_AUDIT=ON`, `BUILD_TESTING=ON`, and `CMAKE_BUILD_TYPE=Debug`.
The sanitizer root used combined AddressSanitizer/UndefinedBehaviorSanitizer
compile and link flags:

```text
-fsanitize=address,undefined -fno-omit-frame-pointer
ASAN_OPTIONS=detect_leaks=0
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
```

Six targets were built serially with `cmake --build ... --parallel 1`:

```text
acgc_pc_gx_semantic_handoff_tests
acgc_pc_gx_semantic_v2_handoff_tests
acgc_pc_gx_semantic_v3_handoff_tests
acgc_pc_gx_semantic_v3_consumer_fixture
acgc_pc_gx_semantic_v4_alpha_state
acgc_pc_gx_semantic_v4_consumer_fixture
```

Focused CTest was run with `--output-on-failure --parallel 1` on the same six
test names:

- Native: `6/6` passed.
- Combined ASan/UBSan: `6/6` passed.
- No ASan or UBSan diagnostics.
- Known non-fatal warnings only: the existing `INT_MIN` macro redefinition and
  AppleClang's unsupported `-Wno-builtin-declaration-mismatch` option.
- `git diff --check` passed.

No full `ac_pc` link, LLDB launch, live callback count, device run, Metal
encode/present/readback, pixel/frame, input, audio, save/device persistence,
simulator, or playability claim follows.

## Next gate

The next useful step is a separately authorized serialized current-tip runtime
trace that wires the V4 builder at the PC flush boundary and measures whether
the typed consumer is reached. Keep that trace separate from device-gated
Metal encode/readback and frame proof.
