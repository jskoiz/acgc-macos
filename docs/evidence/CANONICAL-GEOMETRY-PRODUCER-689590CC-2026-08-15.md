# Canonical Geometry producer at `689590cc`

## Provenance and integration

- canonical PC base: `b9a9f355f7d62c14109f711691d8c8fa51ceb7f8`
- worker commits: `5aba10371f2d7bedd3293c2ba64d66bff3ec1cb7`, then
  `5324c8739e75f8cf093347fb3d6f1273813a59db`
- canonical integration commits: `099a66ad`, then
  `689590cc`
- decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- final review bundle SHA-256:
  `b78573c42dfa8bda2c1a09e0369539fb16e9da117a09de27673b11611fe7c9b6`

The integration owner imported the independently reviewed worker range one
commit at a time onto clean `c1/macos-host-launch`. The first independent
review blocked the candidate on strict raw metadata and fixture coverage. The
same worker branch repaired those gaps, and a fresh independent review returned
`PASS` on exact final `5324c873`.

Changed source is limited to:

- `pc/CMakeLists.txt`
- `pc/include/pc_gx_geometry_producer.h`
- `pc/src/pc_gx_geometry_producer.c`
- `pc/tests/pc_gx_geometry_producer_fixture.c`

## Implemented boundary

`pc_gx_geometry_build_canonical()` consumes one completed, pointer-free
`PCGXRawGeometryBatch` plus explicit immutable
`AcgcGxCanonicalGeometryDependencyResults`. It accepts the bounded
POS/NRM/CLR0/TEX0 triangle/quad subset and fails closed on unsupported matrix,
NBT, CLR1, TEX1-7, malformed metadata, unknown dependencies, capacity, or
arithmetic failure.

The producer requires exact raw knownness bytes, direct source-index zero,
stable indexed first-use/source metadata, and zero inactive/unused payload
tails without rejecting legitimate VAT/array sideband copied for inactive
VCD slots. Values and INDEX16 streams are serialized explicitly little-endian.
Output and scratch must be disjoint; output bytes and `output_size` are updated
only after the staged section passes both the standalone canonical validator
and dependency validator.

The focused fixture covers direct triangles and quads, INDEX8/INDEX16 with
repetition and explicit INDEX16 byte order, scalar/normal/packed-color/TEX
forms, malformed metadata, poisoned knownness/tails, dependency failure,
capacity, output-size aliasing, and exact/partial output-scratch overlap.

## Exact integrated verification

Native:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-geometry-producer-689590cc-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-geometry-producer-689590cc-native \
  --target acgc_pc_gx_geometry_producer_object \
           acgc_pc_gx_geometry_producer_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-geometry-producer-689590cc-native \
  -R '^acgc_pc_gx_geometry_producer_fixture$' \
  --output-on-failure --no-tests=error --parallel 1
```

Result: `1/1` passed.

The separate sanitizer root used the same configure/build/test commands with
combined `-fsanitize=address,undefined -fno-omit-frame-pointer` compile flags
and sanitizer linker flags:

```sh
ASAN_OPTIONS='detect_leaks=0:halt_on_error=1:abort_on_error=1' \
UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1' \
ctest --test-dir /private/tmp/acgc-integrate-geometry-producer-689590cc-asan \
  -R '^acgc_pc_gx_geometry_producer_fixture$' \
  --output-on-failure --no-tests=error --parallel 1
```

Result: `1/1` passed with no sanitizer diagnostic. Leak detection was disabled,
so this is not a leak-free claim. The only compile diagnostic was the existing
Darwin SDK `INT_MIN` macro redefinition warning.

## Evidence boundary

This proves the canonical Geometry leaf producer's CPU/source contract,
focused native execution, and combined ASan/UBSan execution on exact integrated
PC `689590cc`. The target is still a focused producer object/fixture boundary;
this does not prove production cumulative publication, a full `ac_pc` link,
game launch, callback reachability, OpenGL or Metal rendering, a presented or
read-back pixel, input, audio, save/load, Windows runtime, device behavior,
iOS, or playability.
