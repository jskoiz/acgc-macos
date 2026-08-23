# Production GX compilation topology at `52019da76`

Date: 2026-08-22 (Pacific/Honolulu)

## Scope and pinned references

This record covers the independently reviewed production CMake topology that
makes every existing standalone canonical GX producer and the cumulative
assembler available to `ac_pc` without adding a gatherer or changing runtime
behavior.

- Umbrella integration base: `946613f916666d85f852d4189679c0caccd814b1`
- PC source base: `8e55df64e51d68fbec7dfe84c486253f98914338`
- Reviewed source commit: `acee7d71deb7a221fe9997d6748b7c841527ec69`
- Final PC merge: `52019da76cb7539230f913681d1d062d517cf0cd`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PC integration branch: `c1/macos-host-launch`

No ISO, extracted asset, key, proprietary data, process launch, LLDB, GUI,
Metal, device, input, audio, or save lane was used for this integration.

## Hosted source integration

[PC PR #8](https://github.com/jskoiz/ACGC-PC-Port/pull/8), “Register production
GX producer topology,” merged the one-file source commit into
`c1/macos-host-launch` as
`52019da76cb7539230f913681d1d062d517cf0cd`.

The hosted diff contains exactly one file with 56 additions and no deletions:

- `pc/CMakeLists.txt`

The repository has no GitHub workflow files. The PR therefore had no hosted CI
result; local compile/link proof and the hosted merge are recorded separately.

## Production topology integrated

The new unconditional `acgc_pc_gx_production` OBJECT target owns these ten
standalone translation units exactly once:

- `pc/src/pc_gx_geometry_dependencies.c`
- `pc/src/pc_gx_geometry_producer.c`
- `pc/src/pc_gx_transform_producer.c`
- `pc/src/pc_gx_texgen_producer.c`
- `pc/src/pc_gx_tev_producer.c`
- `pc/src/pc_gx_blend_producer.c`
- `pc/src/pc_gx_depth_producer.c`
- `pc/src/pc_gx_fog_producer.c`
- `pc/src/pc_gx_indirect_producer.c`
- `pc/src/pc_gx_cumulative_snapshot.c`

The raw-owner files remain at their existing, single `PC_SOURCES` ownership
sites: `pc_gx.c`, Channels, Lighting, TEV, Texture, and
`pc_gx_canonical_snapshot.c`. The production executable links the grouped
OBJECT target and enables the existing `PC_GX_RASTER_RAW_PRODUCER` implementation
in `pc_gx.c`. No audit or fixture OBJECT target is linked into production.

The grouped target propagates the complete existing canonical library graph:

- base canonical state, which also owns Fog/common/envelope validation;
- Geometry, Transform, Channels, Texgen, Texture, TEV, and Lighting;
- Blend, Alpha, Depth, Raster, Indirect, and Dynamic.

It preserves C11, the project `TARGET_PC`/`VERSION` definitions, decomp and PC
include paths, project warnings, function/data sectioning, and the Apple-only
OpenGL deprecation definition. It does not enable fixture, raw-shadow, observer,
callback, or test-only definitions on the grouped producer sources.

Generated Ninja and `nm` inspection found one object edge and one externally
defined producer/assembler API for each promoted source. The `ac_pc` link rule
consumed all ten objects, propagated all fourteen canonical archives, and did
not include an audit-only object target. Raster remained defined only by the
raw owner in `pc_gx.c`.

This establishes production link availability, not production calls. The new
objects are currently unused by the live flush path because no all-section
gatherer or cumulative publication call exists.

## Two-upstream crosswalk

The PC host/Windows oracle provides the host build and canonical producer
surface:

- `pc/CMakeLists.txt` owns `PC_SOURCES`, the audit fixture/object targets,
  `acgc_pc_gx_production`, production definitions, and `ac_pc` linkage.
- `pc/portable/CMakeLists.txt` owns the canonical state libraries and their
  dependency relationships.
- `pc/src/pc_gx.c` owns the production raw state, Raster/Alpha builders, raw
  Geometry capture, and the current flush topology.
- `pc/src/pc_gx_channels_raw.c`, `pc_gx_lighting_raw.c`, `pc_gx_tev.c`,
  `pc_gx_texture.c`, and `pc_gx_canonical_snapshot.c` remain existing raw-owner
  production sources.
- The ten grouped sources define Geometry dependencies, Geometry, Transform,
  Texgen, TEV, Blend, Depth, Fog, Indirect, and cumulative assembly.
- `pc/include/pc_gx_*` and `include/acgc/gx_canonical_*` retain the named value,
  lifetime, metadata, and validation contracts.

The decomp oracle grounds original GX setter and state semantics in
`GXAttr.c`, `GXGeometry.c`, `GXVert.c`, `GXTransform.c`, `GXLight.c`,
`GXTexture.c`, `GXTev.c`, `GXPixel.c`, and `GXBump.c`, with the corresponding
`include/dolphin/gx` declarations. It has no host CMake OBJECT topology,
canonical producer library graph, token-scoped resource lease, or cumulative
envelope counterpart.

## Independent review

Lane 294 reviewed the complete CMake file and source graph rather than only the
new hunk. It returned PASS with no P0 or P1 finding after independently
checking:

- one-file scope and clean whitespace;
- unconditional target placement outside Apple audit/testing blocks;
- global and target-local definitions/includes/options;
- single production ownership for every promoted and raw-owner source;
- OBJECT target consumption and transitive canonical link propagation;
- exact canonical dependency closure, including Fog in base state;
- production-only Raster definition and absence of fixture/shadow definitions;
- generated graph and symbol uniqueness; and
- fresh native and combined ASan/UBSan compile-only builds.

The remaining P2 observations are inherited warning/configuration hygiene:
AppleClang does not recognize the shared
`-Wno-builtin-declaration-mismatch` option, decomp headers redefine `INT_MIN`,
and an ordinary non-audit arm64 configure is blocked by the unchanged
project-wide 32-bit runtime guard. No supported 32-bit Windows/Linux build was
available, so that portability surface is unproved rather than failed.

## Focused and link verification

The source and review lanes each ran fresh serialized native and combined
ASan/UBSan builds of only `acgc_pc_gx_production`. The integration owner then
ran the serialized production link on the reviewed PR tree:

```sh
cmake --build /private/tmp/acgc-lane-294-production-gx-native \
  --target ac_pc --parallel 1
```

Result: all 4,064 steps passed and
`/private/tmp/acgc-lane-294-production-gx-native/bin/AnimalCrossing` was
produced as a 64-bit arm64 Mach-O executable. No unresolved or duplicate symbol
was reported. The linker emitted the inherited warning that `__DATA,__common`
alignment was reduced from `0x8000` to the segment maximum `0x4000`.

The reviewed candidate tree and final merge tree are byte-identical. The
integration owner nevertheless repeated the smallest focused gate from a fresh
detached worktree at exact merge `52019da76`.

Native exact-merge gate:

```sh
cmake -S pc -B /private/tmp/acgc-topology-merged-native -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=OFF \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build /private/tmp/acgc-topology-merged-native \
  --target acgc_pc_gx_production --parallel 1
```

Result: configure/generate passed and all ten grouped translation units
compiled.

Combined ASan/UBSan exact-merge gate:

```sh
cmake -S pc -B /private/tmp/acgc-topology-merged-asan-ubsan -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=OFF \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer -O1' \
  -DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer -O1' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined' \
  -DCMAKE_SHARED_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-topology-merged-asan-ubsan \
  --target acgc_pc_gx_production --parallel 1
```

Result: configure/generate passed and all ten grouped translation units
compiled with address/undefined-behavior instrumentation. This was compile-only
instrumentation; no sanitizer runtime was executed.

After the serialized full link, the Xcode hygiene dry-run reported
`candidates=651`, `potential=0 KiB`, and `errors=0`. No cleanup was applied.

## Evidence boundary and next blocker

This proves production CMake membership, C11 translation-unit compatibility,
canonical dependency closure, Raster macro availability, object consumption,
duplicate-symbol avoidance, one serialized arm64 candidate-tree full link, and
fresh native plus sanitizer-instrumented object builds at the exact merge. It
does not prove that any producer is called, live raw-state gathering, explicit
little-endian section encoding, Texture/TLUT lease ownership/revalidation,
cumulative flush publication, callback delivery, Apple semantic decoding,
typed plan construction, process launch, Metal encode/present/readback, a
pixel, input, audio, save/reload, lifecycle, iOS, or playability.

The next blocker is the one-call all-section gatherer and its synchronous
lease/failure/publication transaction. That implementation must prove explicit
section encoding and zero callbacks on every early failure before a single
flush insertion or Apple consumer can be claimed.
