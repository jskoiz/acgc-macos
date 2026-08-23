# Pure Apple canonical CPU plan — `2d4bc2b7e` — 2026-08-23

## Outcome

PC PR [#15](https://github.com/jskoiz/ACGC-PC-Port/pull/15), **Add pure
Apple canonical CPU plan builder**, is merged on `c1/macos-host-launch` as
`2d4bc2b7e9241af4a8886b655ce9d8bd7d7caede`. The authoritative merge has first
parent `1c8781d762cdbd202aa9d388c62d112d290553c8` and reviewed topic parent
`deaaa64316258807fcb3db45e416acbacbfe80d0`.

The topic chain is:

- `a497ed0d26e749344af5cb4da5f960f4d692d421` — add the pure Apple canonical
  plan API, implementation, CMake targets, and fixture; and
- `deaaa64316258807fcb3db45e416acbacbfe80d0` — repair false-green fixture
  failure propagation and make all fixture state/mutations canonical.

The merged API accepts one explicit little-endian cumulative-envelope byte
span, structurally parses it, decodes and validates every canonical section,
normalizes bounded Geometry, derives cross-section dependencies, and stages one
caller-owned pointer-free `AcgcAppleCanonicalPlan`. It updates the caller's
output only after all fourteen sections and dependencies succeed.

## Immutable scope

The exact `1c8781d76..2d4bc2b7e` PC diff is four Apple paths, 2,463 insertions
and one deletion:

- `pc/apple/CMakeLists.txt` — parser/plan libraries, focused fixtures, canonical
  links, and two CTest registrations;
- `pc/apple/include/acgc/apple_canonical_plan.h` — status contract, normalized
  Geometry value types, complete value-owned plan, and builder API;
- `pc/apple/src/apple_canonical_plan.c` — explicit decoding, validation,
  dependency derivation, and staged output; and
- `pc/apple/tests/test_apple_canonical_plan.c` — all-section success/failure,
  ownership, alias, Geometry, dependency, resource, BUMP, and bounds coverage.

No `pc_gx.c`, gatherer, callback, production `ac_pc`, renderer, Metal, runtime,
platform, or decomp path changed. The plan library is an Apple pure-C target and
is not registered with the cumulative callback or any live runtime target.

GitHub reports PR #15 as merged with two commits, exactly those four paths,
`+2463/-1`, and no hosted status-check or review rollup. The PC tip contains no
hosted workflow; the evidence below is exact-merge local execution.

## Public plan contract

`AcgcAppleCanonicalPlan` contains only fixed-size values:

- normalized Geometry primitive/vtxfmt/count, aggregate masks, and up to 128
  normalized vertices;
- logical position and texture-matrix IDs, never host addresses;
- canonical binary32 bit patterns, RGBA8 values, and normalized vertex
  components; and
- value-owned Transform, Channels, Texgens, Texture, TEV, Lighting, Blend,
  Alpha, Depth, Raster, Fog, Indirect, and Dynamic states.

It contains no pointer, retained byte span, encoded offset, resource payload,
lease, borrow token, callback, renderer, Metal object, GL handle, or native
wire-struct alias. Callers own the output and must expose a successful value as
immutable.

The status contract distinguishes invalid arguments, input/output overlap,
structural envelope failure, section decode/semantic failure, dependency
failure, resource-metadata failure, unsupported BUMP, Geometry bounds, and
arithmetic overflow. All failures leave output unchanged.

## Fourteen-section handling

| ID | Section | Plan behavior |
|---:|---|---|
| 1 | Geometry | Explicit descriptor/stream decoding; bounded scalar, normal/NBT, color, texcoord, and matrix-selector normalization; maximum 128 vertices. |
| 2 | Transforms | Explicit little-endian fixed-word decode plus canonical validation. |
| 3 | Channels | Explicit decode/validation and Geometry color-channel dependency checks. |
| 4 | Texgens | Canonical little-endian decoder/validator; active BUMP semantics fail closed; matrix dependencies are derived. |
| 5 | Textures | Explicit decode and canonical metadata/value validation; no resource bytes or pointers enter the plan. |
| 6 | TEV | Explicit decode/validation with Texture, Texgen, Channel, and stage dependencies. |
| 7 | Lighting | Explicit decode/validation plus loaded-light dependency checks. |
| 8 | Blend | Explicit decode and canonical validation. |
| 9 | Alpha | Explicit decode and canonical validation. |
| 10 | Depth | Explicit decode and canonical validation. |
| 11 | Raster | Explicit decode and canonical validation. |
| 12 | Fog | Explicit decode and canonical validation. |
| 13 | Indirect | Explicit decode/validation plus TEV, Texture, and Geometry dependencies. |
| 14 | Dynamic | Explicit decode, canonical validation, and Texture/Dynamic cross-validation; invalid ownership metadata fails closed. |

The implementation uses explicit little-endian 16-/32-bit readers, checked
`size_t` arithmetic, input/output range-overlap rejection, local decoded-word
buffers, local normalized Geometry, and one final output assignment.

## Independent BLOCK and correction

The first independent review correctly refused the original green CTest result:

- the initial Texgen setup failed canonical encoding before the plan builder was
  called; and
- the fixture's `CHECK` macro returned zero from `main`, converting that failure
  into process success. Both native and sanitizer CTests therefore appeared
  green without executing plan assertions.

Corrective child `deaaa6431` changes only the fixture. It:

- routes the test sequence through `run_tests`, where helper failure remains
  zero, then maps zero to nonzero process exit in `main`;
- prints `Apple canonical plan tests: PASS` only after every test completes;
- makes Texgen known counts match masks, assigns canonical logical IDs to
  unknown matrix slots, and derives a consistent component summary;
- fixes the BUMP mutation's Texgen header and record offsets; and
- makes the Transform dependency mutation exercise the intended rich-Geometry
  missing-normal dependency.

The corrective re-review found no remaining P0, P1, or P2 issue and confirmed
that production plan source/CMake semantics were unchanged.

## Reference crosswalk

Host/Windows and canonical source:

- `pc/apple/src/apple_canonical_envelope_parser.c` owns structural envelope
  parsing and pointer-free directory/range views;
- `include/acgc/gx_canonical_*_state.h` and
  `src/gx_canonical_*_state.c` define each explicit wire/value contract,
  decoder, validator, and dependency rule;
- `pc/include/pc_gx_cumulative_snapshot.h` and
  `pc/src/pc_gx_cumulative_snapshot.c` define the all-section envelope layout;
- `pc/include/pc_gx_cumulative_gatherer.h` defines the synchronous envelope
  lifetime that a later callback-to-plan handoff must obey; and
- `pc/apple/CMakeLists.txt` is the current pure Apple target authority.

Original-behavior/wire-layout oracle is `upstream/ac-decomp` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`:

- `GXAttr.c`, `GXGeometry.c`, and `GXVert.c` cover descriptors, formats,
  arrays, `GXBegin`, and typed FIFO emission;
- `GXTransform.c`, `GXLight.c`, `GXTexture.c`, `GXTev.c`, `GXPixel.c`, and
  `GXBump.c` cover the original state/setter semantics represented by plan
  sections; and
- the cumulative envelope, Apple plan, host dependency status, callback, lease,
  and CMake targets have no direct decomp counterpart. Decomp remains the guest
  behavior oracle, not a source for host ownership or plan topology.

## Exact merged-tip verification

Authoritative source:

```text
/private/tmp/acgc-integrator-plan-merged
HEAD 2d4bc2b7e9241af4a8886b655ce9d8bd7d7caede
status: detached and clean
```

Fresh native root:

```bash
cmake -S /private/tmp/acgc-integrator-plan-merged/pc/apple \
  -B /private/tmp/acgc-plan-merged-native-20260823 \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON

cmake --build /private/tmp/acgc-plan-merged-native-20260823 \
  --target acgc_apple_canonical_envelope_parser_fixture \
           acgc_apple_canonical_plan_fixture \
  --parallel 1

./acgc_apple_canonical_plan_fixture

ctest --output-on-failure --parallel 1 \
  -R '^(acgc_apple_canonical_envelope_parser_fixture|acgc_apple_canonical_plan_fixture)$'
```

Results: fresh configuration passed; the serialized 37-step build passed;
direct plan execution printed the exact PASS sentinel; CTest discovered exactly
two tests and passed `2/2` in 0.01 seconds.

Fresh combined ASan/UBSan root:

```bash
cmake -S /private/tmp/acgc-integrator-plan-merged/pc/apple \
  -B /private/tmp/acgc-plan-merged-asan-ubsan-20260823 \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DCMAKE_C_FLAGS='-O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=all' \
  -DCMAKE_CXX_FLAGS='-O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=all' \
  -DCMAKE_OBJC_FLAGS='-O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=all' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'

cmake --build /private/tmp/acgc-plan-merged-asan-ubsan-20260823 \
  --target acgc_apple_canonical_envelope_parser_fixture \
           acgc_apple_canonical_plan_fixture \
  --parallel 1

ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
./acgc_apple_canonical_plan_fixture

ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
ctest --output-on-failure --parallel 1 \
  -R '^(acgc_apple_canonical_envelope_parser_fixture|acgc_apple_canonical_plan_fixture)$'
```

Results: fresh configuration passed; the serialized 37-step build passed;
direct execution printed the PASS sentinel; CTest discovered exactly two tests
and passed `2/2` in 0.09 seconds. `LastTest.log` contains the PASS sentinel and
no `CHECK failed`, AddressSanitizer, UndefinedBehaviorSanitizer, runtime-error,
`ERROR`, or `FAILED` diagnostic. Both caches point to the exact merged source
and carry the stated flags.

## Evidence boundary

This proves exact-merge source/CMake integration, structural parsing, explicit
all-section CPU decoding/validation, bounded Geometry normalization,
cross-section dependency derivation, unsupported/resource/alias/failure paths,
output immutability in the focused fixture, and fresh native plus combined
ASan/UBSan execution.

It does **not** prove production `ac_pc` linkage, cumulative callback
registration, callback-lifetime copying or publication, a plan observed from a
real game process, renderer/Metal consumption, encode/present/readback, pixels,
device behavior, input, audio, save/reload, lifecycle, iOS, or playability. The
next source gate is a narrow owned callback-to-plan handoff that copies/builds
synchronously within the existing cumulative callback lifetime and publishes
one immutable plan without changing renderer behavior.
