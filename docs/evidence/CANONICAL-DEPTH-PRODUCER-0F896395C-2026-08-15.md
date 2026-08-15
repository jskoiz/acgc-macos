# Canonical Depth producer at `0f896395c`

## Provenance

- Worker branch: `c1/lane-depth-producer-m3` at
  `dfef13a23ebe021eef29dd46b734b47ad5c2f2e7`.
- Worker base: `590b2bd7373859ed62518cd2ff5fca382de4fd24`.
- Integrated canonical PC: `c1/macos-host-launch` at
  `0f896395c84bdcb238ccd0f8ac3c85632d7a8ede`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Source-only review bundle SHA-256:
  `c4c6d0e191ec12e89154b1d87a9ba0c7d112c17828461e4351372ca8fafb21bd`.

Lane 228 independently reviewed the immutable candidate and returned `PASS`.
It verified direct ancestry, the exact four-file scope, clean status,
raw/canonical/decomp field mapping, destination-preserving fail-closed
behavior, portability, and focused coverage before integration.

## Result

The integrated source adds the pure CPU converter:

```c
int pc_gx_raw_depth_build_canonical(
    const PCGXRawDepth *input,
    AcgcGxCanonicalDepthState *output);
```

It copies the setter-owned logical `compare_enable`, `compare_func`, and
`update_enable` values into the fixed-width canonical Depth state. It requires
exact raw knownness, zero raw reserved bytes, boolean domains `0/1`, and compare
domain `0..7`; it constructs and validates a zeroed local candidate before the
sole output assignment. Null or malformed input therefore fails closed while
preserving the destination. Disabled comparison retains its compare function,
matching the raw and decomp contracts.

PC reference points are `PCGXRawDepth` in `pc/include/pc_gx_internal.h` and the
flush-before-mutation `GXSetZMode` path in `pc/src/pc_gx.c`. Canonical reference
points are `include/acgc/gx_canonical_depth_state.h` and
`src/gx_canonical_depth_state.c`. Decomp `GXSetZMode` in
`src/static/dolphin/gx/GXPixel.c` writes the same three logical fields into BP
state. The project-specific producer has no decomp counterpart.

The raw PC owner has no persistent invalid-history bit: malformed setter input
clears the snapshot to unknown, and a later valid call can recover. The producer
truthfully rejects unknown/malformed snapshots but does not claim sticky-invalid
history the input cannot encode.

Exact source delta:

- `pc/include/pc_gx_depth_producer.h`;
- `pc/src/pc_gx_depth_producer.c`;
- `pc/tests/pc_gx_depth_producer_fixture.c`; and
- `pc/CMakeLists.txt`.

## Verification

The worker reported native focused CTest `3/3` and combined ASan/UBSan focused
CTest `3/3`, with no sanitizer diagnostics and leak detection disabled. The
production producer object built in both roots. Native C11/C++11 and `-m32`
header probes passed; the `_WIN32` probe stopped at missing `process.h`, so this
is not Windows sign-off.

The integration owner reran the raw Depth, producer, and canonical Depth tests
from fresh roots on `0f896395c`:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-depth-0f89-native \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-depth-0f89-native \
  --target acgc_pc_gx_depth_raw_shadow_fixture \
  acgc_pc_gx_depth_producer_fixture \
  acgc_gx_canonical_depth_state_tests \
  acgc_pc_gx_depth_producer_object --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-depth-0f89-native \
  --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_depth_raw_shadow_fixture|acgc_pc_gx_depth_producer_fixture|acgc_gx_canonical_depth_state_tests)$'
```

Native passes `3/3`. The same focused targets pass `3/3` under combined
ASan/UBSan from `/private/tmp/acgc-integrate-depth-0f89-asan` with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; there are no sanitizer
diagnostics. Existing diagnostics are the decomp `INT_MIN` macro redefinition
and AppleClang's unsupported `-Wno-builtin-declaration-mismatch` suppression.
This is not a leak-free claim.

## Evidence boundary

This proves CPU/raw-to-canonical Depth conversion, focused fixtures, and the
production object only. It does not wire the producer into a cumulative
snapshot or live callback and does not prove a full `ac_pc` link, launch,
renderer, Metal encode/present/readback, pixel, input, audio, save, simulator,
device, Windows runtime, or playability.
