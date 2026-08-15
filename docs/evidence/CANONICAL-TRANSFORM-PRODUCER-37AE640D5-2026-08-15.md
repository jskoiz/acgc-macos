# Canonical Transform producer at `37ae640d5`

## Provenance

- Worker branch: `c1/lane-transform-producer-m3` at
  `4fde6d94ed9955fd99a05f025c8449e45b1fb363`.
- Worker base: `689590cc9696daeae55e73f5bf749c28317b6693`.
- Integrated canonical PC: `c1/macos-host-launch` at
  `37ae640d582264dfadac1db75ecab25b1fe52796`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Source-only review bundle SHA-256:
  `f4c9b0b33de7a8713fe8732ae820a686cf1b851b739a67357855301e25c393e5`.

Lane 226 independently reviewed the immutable bundle and returned `PASS`.
It verified exact ancestry, a clean four-file scope, both-upstream semantics,
destination-preserving fail-closed behavior, C/C++ portability, and focused
coverage before integration.

## Result

The integrated source adds a pure value-to-value Transform leaf producer:

```c
int pc_gx_raw_transform_build_canonical(
    const PCGXRawTransform *input,
    AcgcGxCanonicalTransformState *output);
```

The producer copies the six projection words, ten position-matrix records, ten
normal-matrix records, and current position ID from the setter-owned raw
snapshot. It rejects null arguments, sticky invalid state, malformed
knownness or reserved bytes, unresolved indexed loads, non-finite known words,
illegal projection or matrix IDs, and a current matrix whose position slot is
unknown. It builds and validates a local candidate, then publishes once, so
every failure preserves the caller destination. It does not reconstruct host
projection values, derive normal matrices, read Texgen state, invoke a callback,
or assemble a cumulative packet.

PC reference points are `PCGXRawTransform` in `pc/include/pc_gx_internal.h`
and the `pc_gx_transform_store_*` / `pc_gx_transform_mark_indexed_unknown`
setters in `pc/src/pc_gx.c`. Decomp reference points are `GXSetProjection`,
`GXSetProjectionv`, the immediate and indexed position/normal loads, and
`GXSetCurrentMtx` in `src/dolphin/gx/GXTransform.c`. The project-specific
canonical producer has no decomp counterpart.

Exact source delta:

- `pc/include/pc_gx_transform_producer.h`;
- `pc/src/pc_gx_transform_producer.c`;
- `pc/tests/pc_gx_transform_producer_fixture.c`; and
- `pc/CMakeLists.txt`.

## Verification

The worker reported native focused CTest `2/2` and combined ASan/UBSan focused
CTest `2/2`, with no sanitizer diagnostics and leak detection disabled. The
production producer object and native C11/C++11 syntax probes passed. The
bounded i686 `_WIN32` probe remained blocked by the absent MinGW
`sys/types.h`/sysroot, so this is not Windows sign-off.

The integration owner reran the exact producer and canonical Transform tests
from fresh roots on `37ae640d5`:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-transform-37ae-native \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-transform-37ae-native \
  --target acgc_pc_gx_transform_producer_fixture \
  acgc_gx_canonical_transform_state_tests \
  acgc_pc_gx_transform_producer_object --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-transform-37ae-native \
  --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_transform_producer_fixture|acgc_gx_canonical_transform_state_tests)$'
```

Native passes `2/2`. The same focused targets pass `2/2` under combined
ASan/UBSan from `/private/tmp/acgc-integrate-transform-37ae-asan` with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; there are no sanitizer
diagnostics. The only compiler diagnostic is the pre-existing `INT_MIN` macro
redefinition warning. This is not a leak-free claim.

## Evidence boundary

This proves the CPU Transform leaf converter, focused fixture, and production
object compilation only. It does not wire the producer into a cumulative
snapshot or live callback and does not prove a full `ac_pc` link, launch,
Metal encode/present/readback, pixel, input, audio, save, simulator, device,
Windows runtime, or playability.
