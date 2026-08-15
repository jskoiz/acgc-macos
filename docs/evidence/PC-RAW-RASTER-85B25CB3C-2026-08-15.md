# PC raw Raster provenance at `85b25cb3c` (2026-08-15)

## Scope and provenance

Lane 208 implemented setter-owned raw Raster provenance on the remote M3 Max
and returned source-only Git objects for integration-owner review. No ISO,
extracted assets, keys, proprietary resource bytes, full link, launch, LLDB,
Metal device, or pixel work was part of the lane.

- project task: `01a004f3-3ae3-7560-9c9c-e1799056aad6`;
- PC worker base: `039afce0e0773a2ad4cbb6b5d8d717c463ad8303`;
- initial worker commit: `e5b0b9fc49880382b3d8ccb306ddd03459553d2f`;
- worker repair commit: `c04ffb3856a5f94a105ed96763231b41766b0dfd`;
- worker branch: `c1/lane-raw-raster-m3`;
- remote source: `/private/tmp/acgc-lane-raw-raster-m3`;
- canonical integration base: `a42da8e15540cc4e01ed3139b84ced073def9608`;
- canonical commits: `c2b5bd92938f9548650bd03ac9b7b1e96162cde4`
  and `85b25cb3c63a68c2903155ccfd2dec05a1cb70fb`;
- canonical branch: `c1/macos-host-launch` at `85b25cb3c`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- initial source-only bundle SHA-256:
  `db1744ec72f6c454fe3815bb43f0a1aeb80fb3e22721e23856afcf15eef900f8`;
  and
- repair bundle SHA-256:
  `f7ab9e79cc2ebff9a23823c1e630e9eaa0df3cd07726d45fe1020fc1893c5e38`.

The remote and local repair-bundle hashes match, `git bundle verify` reports a
complete history, both worker commits have the declared parent relationship,
and the worker and canonical source checkouts are clean.

## Review correction and exact ownership

The initial four-file worker commit passed a read-only review for raw-shadow
knownness, strict domains, completed-batch flush ordering, host-state
separation, and fail-closed conversion. Root review then rejected one missed
decomp behavior before canonical integration: `GXSetViewportJitter(...,
field=0)` still discarded the original half-pixel top adjustment. Because the
128-byte Raster ABI has no separate jitter-field word, the omission collapsed
two distinct GX states into one. The same task repaired that behavior and added
the focused two-branch regression before the canonical branch advanced.

The accepted range changes exactly four lane-owned files:

- `pc/CMakeLists.txt`;
- `pc/include/pc_gx_internal.h`;
- `pc/src/pc_gx.c`; and
- new `pc/tests/pc_gx_raster_raw_shadow_fixture.c`.

No portable Raster ABI, packet/envelope, Indirect, Apple/Metal, shader, decomp,
resource, or runtime file changed.

## Two-upstream crosswalk and implemented behavior

The PC host reference is the existing setter and OpenGL mirror behavior in
`pc/src/pc_gx.c`, the `PCGXState` declaration in
`pc/include/pc_gx_internal.h`, and the already integrated canonical Raster
value/validator in `include/acgc/gx_canonical_raster_state.h` and
`src/gx_canonical_raster_state.c`.

The original-behavior oracle is ac-decomp:

- `src/static/dolphin/gx/GXTransform.c` for viewport jitter, viewport,
  scissor, scissor-box offsets, and clip mode;
- `src/static/dolphin/gx/GXGeometry.c` for line/point sizes and texture
  offsets, eight coordinate masks, cull mode, and co-planar state;
- `src/static/dolphin/gx/GXPixel.c` for dither, destination alpha, field
  masks, field mode, and half-aspect state;
- `src/static/dolphin/gx/GXInit.c` for startup setter coverage; and
- `src/static/libforest/emu64/emu64.c` plus JSystem/Famicom callers for the
  reconstructed game-owned state sequence.

The integrated `PCGXRawRaster` contains the existing 128-byte canonical Raster
value, an exact 28-bit field-known mask, independent eight-bit line/point
coordinate-known masks, and sticky invalid state. Host defaults do not
establish provenance. Every owned setter first flushes a completed old batch,
then records logical GX state before widescreen scaling, Y flipping, OpenGL
calls, equality shortcuts, or the model-viewer cull override.

Viewport words preserve exact finite binary32 bits. `field == 0` applies the
decomp `top -= 0.5f` jitter adjustment before both raw and host viewport
capture; other field values preserve the supplied top. Scissor origin and
exclusive edge limits, signed offsets, clip/cull/texture-offset enums,
booleans, line/point sizes, destination alpha, and coordinate masks are checked
before mutation. Any malformed value makes the epoch sticky-invalid while
preserving the last accepted raw value.

The producer writes through a local candidate only after all required setters
and all sixteen coordinate-mask bits are known and the existing canonical
Raster validator accepts the value. Failure leaves the caller's destination
unchanged. The production object target compiles the real `pc_gx.c` producer
definition separately from the fixture-only observer seam.

The fixture covers initial unknownness and unchanged destination output,
complete publication, equal host values establishing provenance, partial
state, formerly no-op setters, malformed and non-finite inputs, both viewport
jitter branches, logical state before host overrides, and flush-before-raw
mutation.

## Exact integrated verification

The integration owner applied the accepted worker range onto the newer
canonical `a42da8e155` tip in the isolated
`/private/tmp/acgc-integrate-raw-raster-source` worktree and configured fresh
native and sanitizer roots:

```sh
cmake -S pc -B /private/tmp/acgc-integrate-raw-raster-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON

cmake -S pc -B /private/tmp/acgc-integrate-raw-raster-asan \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined' \
  '-DCMAKE_SHARED_LINKER_FLAGS=-fsanitize=address,undefined'
```

Both roots built serially:

```text
acgc_pc_gx_raster_raw_shadow_fixture
acgc_pc_gx_raster_raw_producer_object
acgc_gx_canonical_raster_state_tests
```

The exact focused test selection was:

```sh
ctest --test-dir <root> --output-on-failure --parallel 1 \
  -R '^(acgc_gx_canonical_raster_state_tests|acgc_pc_gx_raster_raw_shadow_fixture)$'
```

The sanitizer run used `ASAN_OPTIONS=detect_leaks=0` and
`UBSAN_OPTIONS=print_stacktrace=1`.

Results after the jitter repair:

- fresh local native focused CTest: `2/2` passed;
- fresh local combined ASan/UBSan focused CTest: `2/2` passed;
- the production `pc_gx.c` Raster object compiled in both roots;
- no sanitizer diagnostic was emitted;
- leak detection was disabled, so this is not leak-free proof; and
- `git diff --check` passed.

Known output is limited to the existing Darwin compile-frontier warning,
decomp `INT_MIN` redefinition, and unsupported Clang spelling of one inherited
warning-suppression flag. The worker also reported passing bounded C/C++11,
ILP32, and `_WIN32` public-header probes. No real Windows compiler, sysroot, PE
link, or runtime was available, so this is not Windows sign-off.

## Claim boundary and next gate

This proves setter-owned CPU Raster provenance, source-faithful viewport-jitter
behavior, strict knownness/domain handling, completed-batch
flush-before-mutation ordering, conversion to the existing portable Raster
section, production-object availability, and native plus combined ASan/UBSan
focused behavior on the exact integrated source snapshot.

It does **not** prove raw Indirect ownership, complete Geometry conversion, a
cumulative GX envelope, full `ac_pc` link, launch, live callback, Apple
consumer, Metal encode/present/readback, pixel, input, audible audio,
save/reload, device, iOS, Windows runtime, or playability.

Raster no longer blocks the raw Geometry closure identified by lane 210. The
next source gate may now close raw Geometry mutation ordering, array lifetime,
attribute coverage, and completed-copy lifetime under separate ownership. Raw
Indirect conversion and the all-or-nothing cumulative producer remain separate
later gates; no successor is started by this integration itself.
