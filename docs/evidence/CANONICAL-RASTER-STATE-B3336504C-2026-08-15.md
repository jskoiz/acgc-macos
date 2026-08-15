# Canonical Raster state at `b3336504c`

## Scope and provenance

Lane 205 implemented the frozen renderer-neutral Raster value ABI on the
remote M3 Max and returned source-only Git objects for local integration-owner
review. No ISO, extracted assets, keys, proprietary game data, resource bytes,
full link, launch, or device access was part of the lane.

- project task: `01a004f3-3ae3-7560-9c9c-e1799056aad6`;
- PC integration base: `698d45d3e78f96104c2e489d78036b55ea493d37`;
- worker/final commit: `b3336504c2d1418951446f5ff3bb8b5cd214c7fc`;
- worker branch: `c1/lane-canonical-raster-m3`;
- remote source worktree: `/private/tmp/acgc-lane-canonical-raster-m3`;
- canonical integration branch: `c1/macos-host-launch` at `b3336504c`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- returned source-only bundle SHA-256:
  `99e07872debcb9213548e7fed42c022fbfc8e3a483fbfc027b91ecd06239698f`; and
- frozen contract:
  `docs/evidence/CANONICAL-DEPTH-RASTER-CONTRACT-F2B7AB153-2026-08-14.md`.

The commit changes exactly four lane-owned files:

- `include/acgc/gx_canonical_raster_state.h`;
- `src/gx_canonical_raster_state.c`;
- `pc/portable/tests/test_gx_canonical_raster_state.c`; and
- `pc/portable/CMakeLists.txt`.

It does not touch `pc_gx`, packet/cumulative-producer policy, Apple/Metal
code, resource ownership, or either upstream's unrelated source.

## Two-upstream crosswalk

The implementation was checked against both pinned references before root
integration:

- PC `pc/src/pc_gx.c` and its existing `GXSetViewport`,
  `GXSetViewportJitter`, `GXSetScissor`, `GXSetScissorBoxOffset`,
  `GXSetClipMode`, `GXSetCullMode`, `GXSetCoPlanar`, `GXSetLineWidth`,
  `GXSetPointSize`, `GXSetDither`, `GXSetDstAlpha`, `GXSetFieldMask`, and
  `GXSetFieldMode` host behavior;
- decomp `src/static/dolphin/gx/GXTransform.c`, `GXGeometry.c`, `GXPixel.c`,
  and `GXInit.c`, plus public GX declarations and representative callers;
- the common renderer-neutral envelope and adjacent canonical Depth,
  Transform, Geometry, Alpha, Blend, TEV, Channels, Lighting, Texture, and
  Dynamic validators; and
- the frozen Depth/Raster audit, which records the PC no-op, host-scaled,
  jitter, cull-override, line/point, destination-alpha, field, and knownness
  gaps that a later raw Raster owner must repair.

The neutral ABI therefore stores logical GX values, not OpenGL enums, scaled
viewport/scissor values, host booleans, pointers, bit-fields, or resource
handles.

## Implemented contract

The integrated source defines Raster as section mask `0x0400`, version `1`,
one fixed 128-byte record aligned to four bytes. Its 32 words contain:

- six exact finite IEEE-754 binary32 viewport argument bit patterns;
- four logical unsigned scissor values and two signed scissor-box offsets;
- clip, cull, and co-planar state;
- line/point sizes, texture-offset modes, and eight-bit texcoord masks;
- dither and destination-alpha state;
- field mode, half-aspect ratio, and odd/even field masks; and
- four required zero reserved words.

Compile-time assertions freeze the size, alignment, every field offset, and
the end offset. Runtime validation fails closed for null state, non-finite
viewport words, overflowing or out-of-domain scissor extents, scissor offsets
outside `-342..1705`, invalid booleans/enums/masks/sizes/alpha, and nonzero
reserved words. Metadata validation separately enforces exact present and
absent directory forms in the common canonical envelope.

The focused fixture covers valid and malformed value states, exact ABI
offsets, metadata presence/absence, reserved words, little-endian word
roundtrips, and envelope failure cases. This lane intentionally provides no
raw PC Raster shadow or cumulative producer.

## Exact integrated verification

Fresh local roots were configured from canonical `b3336504c`:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-canonical-raster-b333-native \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON

cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-canonical-raster-b333-asan \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

All thirteen registered canonical validator targets were built serially in
both roots. The exact test command was:

```sh
ctest --test-dir <root> --output-on-failure --parallel 1 \
  -R '^acgc_gx_canonical_.*_tests$'
```

For the sanitizer root it ran with:

```text
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
```

Results:

- native canonical matrix: `13/13` passed;
- combined ASan/UBSan canonical matrix: `13/13` passed;
- no sanitizer diagnostics were emitted;
- leak detection was disabled, so this is not leak-free proof; and
- `git diff --check` passed.

The worker additionally reported passing C11/C++11 header and fixture probes,
bounded `_WIN32` and ILP32 syntax probes, and static analysis. No real Windows
compiler, sysroot, PE link, or runtime was available, so this is not Windows
sign-off.

## Claim boundary and next gate

This proves a reviewed fixed-width CPU value contract, validator, envelope
metadata contract, little-endian fixture behavior, and native plus combined
ASan/UBSan behavior on the exact integrated snapshot.

It does **not** prove a raw Raster producer, cumulative packet, full `ac_pc`
link, launch, live callback, Apple consumer, Metal encode/present/readback,
pixel, input, audible audio, save/reload, device, iOS, or playability.

The next Raster-owned source gate is a setter-owned raw PC Raster shadow and
converter that preserves logical values before host mutation. The cumulative
all-or-nothing producer remains gated on that raw owner plus the separately
owned Alpha/ZCompLoc and Indirect prerequisites identified by lanes 204, 206,
and 207.
