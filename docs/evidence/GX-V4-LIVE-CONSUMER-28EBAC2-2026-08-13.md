# GX V4 live-consumer wiring — 2026-08-13

This record covers the narrow V4 builder-to-Apple-consumer wiring change. It
proves a typed CPU/runtime seam and Apple sink compilation; it does not claim a
live game callback, Metal device output, pixel readback, or playability.

## Provenance and ownership

- Root-owned source lane: `/private/tmp/acgc-lane-gx-v4-live-consumer`.
- Worker branch: `c1/lane-gx-v4-live-consumer` at `3571f0e`.
- Worker base: PC `f19c73f` (`c1/macos-host-launch`).
- Integrated canonical PC: `c1/macos-host-launch` at `28ebac2`, clean after
  focused verification.
- Decomp oracle: `master` at `09ca8e8b`, clean.

The umbrella gitlink is intentionally updated only after the integrated gates
listed below. No ISO, extracted asset, or proprietary game data is included.

## Two-upstream crosswalk

The PC port's V4 builder at `f19c73f` carries the V3 payload and appends the
fixed-width `alpha_update_enable` state. Its flush path previously stopped
after V3 failed closed on the live alpha-disabled state. This lane adds a
separate typed V4 callback and tries it only after V2 and V3 fail, leaving the
legacy V1/OpenGL path unchanged when the callback is absent.

The decomp oracle at `09ca8e8b`, `src/static/libforest/emu64/emu64.c:619`, calls
`GXSetAlphaUpdate(GX_FALSE)` during initialization. The same source sets the
observed `GX_BM_BLEND`/source-alpha factors and initializes two texture
generators/TEV stages. There is no decomp-side Apple packet or consumer
counterpart, so the Apple side remains a bounded host adapter rather than a
new guest contract.

## Implementation boundary

The source commit changes exactly six PC-port files:

- `pc/apple/include/acgc/metal_packet_consumer.h`
- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/src/metal_sink.m`
- `pc/apple/src/pc_metal_runtime.c`
- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_semantic_v4_consumer_fixture.c`

The V4 consumer maps only the supported blend subset (none or blend with
zero/one/source-alpha/inverse-source-alpha factors), carries alpha-write state
to the Metal color write mask, and leaves V3 texture-matrix state explicitly
`NOT_RENDERED`. Unsupported modes, factors, malformed alpha values, and state
masks fail closed. Runtime registration and teardown now include the typed V4
callback, while V1/V2/V3 dispatch remains separate.

## Verification

The source lane was configured with the Darwin compile-audit flags and built
serially (`--parallel 1`) in native and combined ASan/UBSan roots. The affected
focused CTest targets were:

```text
acgc_pc_gx_semantic_handoff_tests
acgc_pc_gx_semantic_v2_handoff_tests
acgc_pc_gx_semantic_v3_handoff_tests
acgc_pc_gx_semantic_v3_consumer_fixture
acgc_pc_gx_semantic_v4_alpha_state
acgc_pc_gx_semantic_v4_consumer_fixture
```

After cherry-picking `3571f0e` as `28ebac2`, the same six targets were rebuilt
from the canonical PC checkout in fresh roots:

- Native: `6/6` focused CTest passed.
- Combined ASan/UBSan (`ASAN_OPTIONS=detect_leaks=0`,
  `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`): `6/6` passed.
- No sanitizer diagnostics; only the existing AppleClang warnings were
  emitted (`INT_MIN` redefinition and the unsupported
  `-Wno-builtin-declaration-mismatch` option).

The direct `pc/apple` CMake entrypoint was also configured from the source
lane. `acgc_metal_packet_consumer_tests` and `acgc_metal_sink_tests` passed
`2/2` in both native and combined ASan/UBSan roots. The sink test is device
gated on this host and does not turn a CPU pass into device evidence.

## Claim boundary and next gate

This milestone proves typed V4 builder-to-consumer wiring, bounded blend/alpha
state mapping, and compile/test coverage of the Apple sink. It does not prove
that the reconstructed game reaches the V4 callback, that a Metal device
encodes or presents a game-owned packet, that a pixel can be read back, or that
input, audio, save persistence, simulator/device operation, or playability
works.

The next gate is one explicitly authorized serialized current-tip `ac_pc` link
and one bounded LLDB trace at the V4 builder/consumer/runtime symbols. Keep
that runtime attempt separate from device-gated Metal encode/readback and
frame evidence.
