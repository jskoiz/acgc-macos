# Immutable PC GX Geometry raw-batch provenance

Date: 2026-08-14

## Provenance

- ACGC-PC-Port worker base: `324c174ae31e06725b51d662f2645cfd8f96c835`
- M3 Max worker branch: `c1/lane-geometry-raw-batch-m3`
- Initial worker commit: `9ec853b0fb69195d17a29d66dbc0ae1e9ebed994`
- Reviewed scalar/index repair: `401ef1f1953512572f1d4db0f2a022d3075621c6`
- Canonical integration branch: `c1/macos-host-launch`
- Initial canonical integration: `b315e57071d3343169f255a46a0ccfcf22f46442`
- Final canonical integration: `23c26e520a943ac843023f0341d2670d9c7ef9fc`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Repaired source-only bundle SHA-256:
  `3a0cae0b88137cdf328795ba8b83e6dc26816a95e59b217e8db82ff31c9b1700`

The M3 Max worker returned its source through a Git bundle. Independent review
rejected the first candidate because direct `GX_TEX_S` calls were captured as
two-component values and because INDEX8/INDEX16 entry-point width was not
cross-checked against the active descriptor. The child repair closed both
findings before integration. Root reviewed the exact repaired diff, repeated
the focused native and sanitizer matrices in an isolated worktree, then
cherry-picked the original and repair commits one at a time onto the canonical
PC branch. No ISO, extracted asset, key, or proprietary game-data path was
read, copied, or added to Git.

## Exact change

The integrated source change owns exactly:

- `pc/include/pc_gx_internal.h` for pointer-free raw Geometry descriptors,
  arrays, current vertex, live batch, and completed-batch storage;
- `pc/src/pc_gx.c` for VCD/VAT/array provenance, per-call value capture,
  batch boundaries, old-batch-before-new-state ordering, and immutable
  completed-batch observation;
- new `pc/tests/pc_gx_geometry_raw_batch_fixture.c`; and
- minimal `pc/CMakeLists.txt` fixture registration.

The raw batch copies descriptor and value state rather than retaining caller
pointers. It captures topology, VTXFMT, expected and observed vertex counts,
descriptor/VAT facts, array generation and extent, direct words, indexed
source identities, and a bounded maximum of 128 vertices. Array reads require
known size/stride, a matching generation, overflow-safe extents, and enough
bytes for the selected element. Completed batches are copied before observer,
semantic-packet, or legacy GL submission.

The first producer subset is intentionally fail-closed. It supports triangle
and quad batches with direct or indexed position, optional normal, CLR0, TEX0,
and PNMTXIDX provenance. CLR1, TEX1–7, NBT/NBT3, unsupported matrix-index
attributes, malformed formats, out-of-range arrays, excess vertices, and
incomplete calls invalidate publication instead of inventing data. Invalidity
is deliberately sticky until `pc_gx_init`; valid later calls do not silently
repair malformed global provenance.

The reviewed repair makes two representation boundaries exact:

- `GXTexCoord1f32/u16/s16/u8/s8` now record one emitted S component and a
  canonical zero T in raw state while preserving the PC compatibility ABI's
  second argument and unchanged legacy host T value; and
- every indexed position, normal, color, and texture-coordinate entry point
  carries its emitted `GX_INDEX8` or `GX_INDEX16` width into the shared raw
  decoder. A descriptor/API-width mismatch fails before any array read.

## Two-upstream crosswalk

- `upstream/ac-decomp/src/static/dolphin/gx/GXAttr.c` defines VCD/VAT domains,
  normal/NBT exclusion, array registration, and validation behavior.
- `upstream/ac-decomp/src/static/dolphin/gx/GXGeometry.c` defines `GXBegin`
  topology, VTXFMT, and expected-vertex boundaries.
- `upstream/ac-decomp/src/static/dolphin/gx/GXVert.c` distinguishes one- and
  two-component texture-coordinate emission and separate eight- and
  sixteen-bit index streams.
- `upstream/ac-decomp/src/static/dolphin/gx/GXTransform.c` supplies current
  position-matrix selector provenance.
- `upstream/ACGC-PC-Port/pc/src/pc_gx.c` remains the Windows/OpenGL behavior
  oracle. Its existing `PCGXVertex`, GL buffers, dirty-state logic, and host
  array decoding continue after the new observation-only raw capture.

The legacy host path still borrows caller arrays and assumes its historical
float/color shapes. The new raw producer adds bounded truth for later portable
serialization; it does not retroactively make every legacy caller safe or
support every GX attribute form.

## Verification

Independent review passed `git diff --check`, additive merge analysis against
the then-current canonical tip, native C/C++ ABI and syntax probes,
`clang --analyze`, and bounded `-m32` syntax. The `_WIN32` host probe stopped at
the unavailable SDK `process.h`; no real Windows compiler, PE link, or runtime
sign-off is claimed.

Fresh exact-integrated commands:

```sh
cmake -S pc \
  -B /private/tmp/acgc-integrate-geometry-23c26e-native \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON
cmake --build /private/tmp/acgc-integrate-geometry-23c26e-native \
  --parallel 4 \
  --target acgc_pc_gx_transform_raw_shadow_fixture \
           acgc_pc_gx_depth_raw_shadow_fixture \
           acgc_pc_gx_tev_raw_shadow_fixture \
           acgc_pc_gx_texgen_raw_shadow_fixture \
           acgc_pc_gx_geometry_raw_batch_fixture
ctest --test-dir /private/tmp/acgc-integrate-geometry-23c26e-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_(transform_raw_shadow_fixture|depth_raw_shadow_fixture|tev_raw_shadow_fixture|texgen_raw_shadow_fixture|geometry_raw_batch_fixture)$'
```

Result: native raw-state matrix `5/5` passed.

```sh
cmake -S pc \
  -B /private/tmp/acgc-integrate-geometry-23c26e-asan \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-integrate-geometry-23c26e-asan \
  --parallel 4 \
  --target acgc_pc_gx_transform_raw_shadow_fixture \
           acgc_pc_gx_depth_raw_shadow_fixture \
           acgc_pc_gx_tev_raw_shadow_fixture \
           acgc_pc_gx_texgen_raw_shadow_fixture \
           acgc_pc_gx_geometry_raw_batch_fixture
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
  ctest --test-dir /private/tmp/acgc-integrate-geometry-23c26e-asan \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_(transform_raw_shadow_fixture|depth_raw_shadow_fixture|tev_raw_shadow_fixture|texgen_raw_shadow_fixture|geometry_raw_batch_fixture)$'
```

Result: combined ASan/UBSan raw-state matrix `5/5` passed with no sanitizer
diagnostic. `detect_leaks=0`, so this is not leak-check evidence. Configuration
emits the expected `PC_DARWIN_COMPILE_AUDIT` compile-frontier warning; build
warnings are pre-existing decomp/header warnings.

## Claim boundary

This proves the bounded CPU-side Geometry raw-batch representation, copied
lifetime, supported direct/indexed capture, fail-closed malformed cases,
additive integration, native execution, and combined ASan/UBSan execution. It
does not prove a cumulative canonical packet, callback, full `ac_pc` link,
launch, Windows runtime, OpenGL/Metal encoding, present, readback, pixel,
device, or playability gate.
