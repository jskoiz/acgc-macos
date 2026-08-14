# GX V4 alpha-write state contract — 2026-08-13

This record covers the reviewed CPU/contract implementation that follows the
current-tip live V3 rejection trace. It does not claim Apple consumer,
renderer, or playability behavior.

## Provenance and crosswalk

- Worker branch: `c1/lane-gx-alpha-state` at `6ef4df7`
  (`Add GX V4 alpha-state packet builder`), based on PC `f18e7cd`.
- Integrated canonical PC: `c1/macos-host-launch` at `4fc6f00`, clean after
  focused verification.
- Decomp oracle: `master` at `09ca8e8b`, clean.
- Worker worktree: `/private/tmp/acgc-lane-gx-alpha-state/source`.
- Focused roots:
  - `/private/tmp/acgc-integrate-v4-alpha-state-native`
  - `/private/tmp/acgc-integrate-v4-alpha-state-asan`

The live lane-108 trace showed `alpha_update_enable == 0` for every captured
V3 rejection record. The PC path maps this state to the alpha channel of
`glColorMask`; the decomp uses `GXSetAlphaUpdate(GX_FALSE)` in the main
`emu64` initialization and in the z-mode paths, with explicit true transitions
elsewhere. Since the fixed V3 packet cannot grow without changing its ABI, this
lane adds a distinct V4 packet rather than changing V3 in place.

## Contract

- `AcgcGxSemanticPacketV3` remains unchanged at `4968` bytes and continues to
  reject disabled alpha writes.
- `AcgcGxSemanticPacketV4` is `4972` bytes: it preserves the V3 field order
  and appends `uint32_t alpha_update_enable`.
- V4's state mask is `V3_SUPPORTED | ALPHA_UPDATE_KNOWN` (`0x7`).
- Validation accepts only explicit `0` or `1`; unsupported or malformed state
  fails closed and zeroes the builder output.
- The V4 builder reuses the proven V3 payload mapping and accepts both alpha
  write-enabled and alpha write-disabled state.
- No V4 handoff callback or Apple consumer was added.

Changed files, all within the lane contract:

- `include/acgc/gx_semantic_packet.h`
- `src/gx_semantic_packet.c`
- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_semantic_v4_alpha_state.c`
- `pc/CMakeLists.txt`

## Integrated verification

The integrated canonical PC checkout was configured separately for native and
combined ASan/UBSan focused builds. Both built these five targets with
`--parallel 1`:

```text
acgc_pc_gx_semantic_v4_alpha_state
acgc_pc_gx_semantic_handoff_tests
acgc_pc_gx_semantic_v2_handoff_tests
acgc_pc_gx_semantic_v3_handoff_tests
acgc_pc_gx_semantic_v3_consumer_fixture
```

Native CTest:

```text
ctest --test-dir /private/tmp/acgc-integrate-v4-alpha-state-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_semantic_(handoff_tests|v2_handoff_tests|v3_handoff_tests|v3_consumer_fixture|v4_alpha_state)$'
```

Result: `5/5` passed.

Combined sanitizer CTest used `-fsanitize=address,undefined` for C/C++/ObjC
and executable link flags, with `ASAN_OPTIONS=detect_leaks=0` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`.

Result: `5/5` passed with no ASan, UBSan, or leak diagnostics.

The only build diagnostics were the pre-existing `INT_MIN` macro redefinition
and AppleClang's unknown `-Wno-builtin-declaration-mismatch` warning. No full
`ac_pc` link or LLDB launch was run for this lane. `git diff --check` passed;
the canonical PC and decomp checkouts remained clean after verification.

## Evidence boundary and successor

This proves a reference-backed, versioned CPU packet/builder contract and
preservation of the existing V3 ABI under focused native and sanitizer tests.
It does not prove V4 consumer acceptance, live callback delivery, Metal
encode/present/readback, a pixel or frame, input, audio, Save_t/device
persistence, simulator/physical-device behavior, or playability.

The next useful successor is a separately owned V4 consumer/validation lane
for the Apple boundary. It must remain CPU/contract scoped until a separately
authorized serialized runtime or device gate.
