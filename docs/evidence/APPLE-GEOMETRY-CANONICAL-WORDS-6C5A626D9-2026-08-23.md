# Apple canonical Geometry words — PC `6c5a626d9`

## Outcome

PC [PR #28](https://github.com/jskoiz/ACGC-PC-Port/pull/28),
`Consume canonical Geometry words once in Apple plan`, merged into
`c1/macos-host-launch` as
`6c5a626d958bb8e056282d4a6872770c59e20789`.

- PC base: `503194ff2209797d77cbb917c012642051d32b40`
- Reviewed source commit:
  `35a26c65893d15dc1c9feb6c4cb29cad4b59965f`
- PC merge: `6c5a626d958bb8e056282d4a6872770c59e20789`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The exact first-parent merge diff changes only:

- `pc/apple/src/apple_canonical_plan.c`
- `pc/tests/pc_gx_canonical_plan_roundtrip_fixture.c`

The source commit contains 29 insertions and 30 deletions in the Apple plan,
plus 141 fixture insertions and one deletion. `git diff --check` passed. No
CMake, production-target topology, producer, gather/flush, Metal sink,
workflow, decomp, umbrella, or proprietary-asset path changed.

The base and merge trees contain no `.github/workflows` path. PR #28 had no
hosted status-check rollup; no paid hosted Apple runner was configured or
triggered.

## Repaired contract

The live `da96bf622` discriminator proved that all fourteen producers passed,
one cumulative envelope published, and Apple rejected the first TEX0 scalar.
The descriptor recorded source U16, fraction zero, canonical
`value_encoding == 1`, and canonical binary32 word `0x43800000` (256.0).
Apple passed that final word back through the raw-U16 decoder and returned
typed `GEOMETRY_LIMIT`.

The merged source now consumes producer-emitted canonical Geometry words
exactly once:

- POS, NRM/NBT, and TEX0–TEX7 copy validated canonical binary32 words into the
  Apple plan;
- CLR0/CLR1 copy validated logical RGBA8 words without reapplying packed-color
  conversion;
- PNMTXIDX and texture-matrix IDs retain their logical-ID path;
- the local canonical-word helper accepts only `value_encoding == 1`;
- descriptor, range, stride, index, matrix-ID, section, dependency, and vertex
  limits remain unchanged; and
- plan output remains staged until every section and dependency succeeds.

The canonical Geometry validator already requires exact word counts,
four-byte strides, finite binary32 values, exact integer quantization, logical
RGBA8 representation, valid ranges/indices, and `value_encoding == 1`. The
Apple plan therefore no longer repeats source VAT or packed-color conversion.

## Source-backed regression

The existing registered root fixture now adds a GX setter/emission case with:

- nonzero S16/fraction-4 positions;
- nonzero S8 normals;
- packed RGB565 CLR0 values; and
- nonzero U16/fraction-2 TEX0 coordinates.

The case requires exact canonical plan results:

- positions `(1,2,3)`, `(4,5,6)`, and `(7,8,9)` as binary32 words;
- unit-basis normal words;
- TEX0 `(1,2)`, `(2,3)`, and `(3,4)` as binary32 words; and
- RGB565 red as logical RGBA8 `0xFF0000FF`.

The old decoder would reinterpret those final words as S16/S8/RGB565/U16
source values and fail or change them. The new case observes exactly one
envelope and a successful Apple plan. The current typed packet consumer then
returns its explicit `CANONICAL_GEOMETRY_UNSUPPORTED` status for the wider
NRM/TEX0 attribute set. That is a bounded next frontier, not a rendering
success claim. The original F32/RGBA8 source-backed round trip remains covered.

## Independent immutable review

An independent reviewer verified the exact clean candidate and base, two-path
scope, identity, remote branch state, lack of workflow exposure, producer and
canonical ABI contracts, one-pass plan conversion, retained logical matrix-ID
handling, structural and failure-immutability checks, and the fixture's exact
expected words. It returned PASS and authorized the scoped PC PR/merge.

The review also inspected the retained final native and combined ASan/UBSan
roots. Both pointed to the candidate worktree, discovered exactly Test #39,
and passed the one anchored test. An older superseded failed development root
was explicitly excluded from proof.

## Exact-merge verification

Detached, clean source worktree:

`/private/tmp/acgc-integrator-geometry-plan-merged`

at exact merge `6c5a626d958bb8e056282d4a6872770c59e20789`.

Fresh native root:

`/private/tmp/acgc-geometry-plan-merge-native`

```sh
cmake -S pc -B /private/tmp/acgc-geometry-plan-merge-native -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-geometry-plan-merge-native \
  --target acgc_pc_gx_canonical_plan_roundtrip_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-geometry-plan-merge-native -N \
  -R '^acgc_pc_gx_canonical_plan_roundtrip_fixture$'
ctest --test-dir /private/tmp/acgc-geometry-plan-merge-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_canonical_plan_roundtrip_fixture$'
```

Result: configure/generate and the serialized target build passed; discovery
found exactly one test, Test #39; execution passed `1/1` in
0.01 seconds.

Fresh combined ASan/UBSan root:

`/private/tmp/acgc-geometry-plan-merge-asan-ubsan`

The same commands were used with
`-fsanitize=address,undefined -fno-omit-frame-pointer` in `CMAKE_C_FLAGS` and
matching executable-linker flags. Configure/generate and the serialized target
build passed; discovery found exactly Test #39; execution
passed `1/1` in 0.06 seconds. `LastTest.log` contains no AddressSanitizer,
UndefinedBehaviorSanitizer, runtime-error, failed-test, or error diagnostic.

## Two-upstream crosswalk

The exact PC merge is authoritative for host canonical transport:

- `pc/src/pc_gx_geometry_producer.c` converts raw GX scalar, normal, and color
  values into canonical stream words;
- `include/acgc/gx_canonical_geometry_state.h` and
  `src/gx_canonical_geometry_state.c` define and validate
  `value_encoding == 1`;
- `pc/apple/src/apple_canonical_plan.c` owns the value-only Apple plan; and
- `pc/tests/pc_gx_canonical_plan_roundtrip_fixture.c` exercises the source GX
  setters through gather, assembly, parse, plan, and typed rejection.

The decomp oracle preserves original raw GX behavior in
`include/dolphin/gx/GXGeometry.h`, `include/dolphin/gx/GXVert.h`, and
`src/static/dolphin/gx/GXAttr.c`, `GXGeometry.c`, and `GXVert.c`. It has no
Apple canonical-plan, host cumulative-envelope, CMake/CTest, sanitizer, or
typed packet-consumer counterpart.

## Proof boundary and next gate

Proved:

- exact PC PR #28 parentage, two-path scope, and merge;
- canonical Geometry word consumption exactly once in the Apple CPU plan;
- source-backed integer scalar/normal/texture and packed-color coverage;
- retained fail-closed structure, dependencies, and output immutability; and
- exact-merge native plus combined ASan/UBSan focused execution.

Not proved:

- a full `ac_pc` link or real-process trace at `6c5a626d9`;
- live plan success after this correction;
- typed packet support for NRM/TEX0 or every canonical attribute;
- Metal encode, present, readback, pixels, device behavior, input, audio,
  save/reload, teardown, iOS, or playability.

The next gate is one serialized exact-merge full `ac_pc` link followed by the
existing bounded symbol-name trace. It must stop at the next exact Apple plan,
typed packet-consumer, or sink result. No Metal or pixel claim follows unless
that exact device path is independently observed.
