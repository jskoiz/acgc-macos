# Geometry dependency fixture gate at `f77d5ec86`

Date: 2026-08-22 (Pacific/Honolulu)

## Scope and pinned references

This record covers the focused CMake/CTest registration of the already-merged
Geometry dependency-result builder and its source-backed fixture.

- Umbrella integration base: `af1523400d7f50cc41c6336af09c0fa7b50b3a1e`
- PC source base: `4cbb837e62f69c4cab80c1128c25b9e9bd9fb91d`
- Reviewed PC candidate: `35c0dd350f61492e669dbd4567ec634eb52c287f`
- Final PC source tip: `f77d5ec8696c90d8beedea622110260d65369177`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PC integration branch: `c1/macos-host-launch`

No ISO, extracted asset, key, proprietary data, full `ac_pc` link, LLDB, GUI,
Metal, or device lane was used for this integration.

## Hosted source integration

[PC PR #4](https://github.com/jskoiz/ACGC-PC-Port/pull/4), “Register Geometry
dependency fixture gate,” merged candidate `35c0dd350f61492e669dbd4567ec634eb52c287f`
into `c1/macos-host-launch` as
`f77d5ec8696c90d8beedea622110260d65369177`.

The hosted diff was exactly one file, `pc/CMakeLists.txt`, with 49 additions.
It added the direct-source/test-only executable and CTest entry
`acgc_pc_gx_geometry_dependencies_fixture`. It did not modify the builder,
header, fixture, production `ac_pc` target, Apple runtime, or umbrella files.
The PR was mergeable with a clean merge state and had no hosted checks because
the repository contains no GitHub workflow files.

## Two-upstream crosswalk

The PC host/Windows oracle contributes the build boundary and implementation:

- `pc/CMakeLists.txt` supplies the neighboring raw Geometry and Geometry
  producer fixture conventions.
- `pc/src/pc_gx.c` owns the source-backed VCD, VAT, array, and completed-batch
  capture seam.
- `pc/src/pc_gx_geometry_dependencies.c` and
  `pc/include/pc_gx_geometry_dependencies.h` define
  `pc_gx_geometry_build_dependency_results`.
- `pc/src/pc_gx_geometry_producer.c` defines
  `pc_gx_geometry_build_canonical`.
- `pc/src/pc_gx_channels_raw.c`, `pc/src/pc_gx_lighting_raw.c`,
  `pc/src/pc_gx_transform_producer.c`, and
  `pc/src/pc_gx_texgen_producer.c` supply the cross-section inputs exercised by
  the fixture.
- `pc/tests/pc_gx_geometry_dependencies_fixture.c` obtains real source-backed
  state and validates the dependency results and canonical Geometry output.

The decomp oracle grounds the guest GX semantics in
`src/static/dolphin/gx/GXAttr.c`, `GXGeometry.c`, and `GXVert.c`, plus the
corresponding `include/dolphin/gx` declarations for VCD, VAT, arrays, geometry,
and vertex emission. CMake and CTest registration are host build
infrastructure and have no decomp counterpart.

## Focused verification

The worker configured fresh native and combined ASan/UBSan Ninja roots with
`PC_DARWIN_COMPILE_AUDIT=ON`, `BUILD_TESTING=ON`, and Debug configuration. Each
root built only `acgc_pc_gx_geometry_dependencies_fixture` with
`--parallel 1`; exact CTest discovery found one test, and exact regex execution
passed `1/1`. The sanitizer run used
`-fsanitize=address,undefined -fno-omit-frame-pointer` and emitted no sanitizer
finding.

The integration owner independently repeated the fresh native and combined
ASan/UBSan configure, target-only build, and exact CTest run on candidate
`35c0dd350`; both passed `1/1`. After PR merge, a detached worktree at exact
merge `f77d5ec86` received a new native configure, serialized target build, and
exact CTest run; it also passed `1/1`. The candidate and merge trees have no
`pc/CMakeLists.txt` difference.

Existing decomp-header diagnostics such as `INT_MIN` redefinition,
old-style prototype warnings, and an unsupported warning-suppression option
remain compile warnings. They were present in the focused source surface and
did not become sanitizer or test failures.

## What this proves

The existing Geometry dependency-result builder now has a reproducible,
discoverable, source-backed CMake/CTest gate. Its exact source and producer
definitions compile, link, execute, and pass in native and combined ASan/UBSan
focused configurations on the reviewed candidate; the smallest focused gate
also passes on the authoritative merge commit.

## What remains open

- The Geometry dependency builder is not yet linked into production `ac_pc` or
  a cumulative snapshot gatherer.
- Texture/TLUT/Dynamic resources still need one envelope-scoped atomic borrow,
  generation revalidation, publication, and release contract.
- No production cumulative assembler publishes the complete fourteen-section
  `0x3fff` envelope.
- The typed cumulative Apple CPU plan and live callback remain open.
- No full `ac_pc` link, process launch, live callback, Metal encode/present,
  readback, identifiable pixel, physical input, audible audio, save/reload,
  lifecycle, iOS, or playability claim follows from this integration.
