# Persistent raw GX Lighting producer

Date: 2026-08-14

## Result

The reviewed raw Lighting implementation is integrated in the owning
`ACGC-PC-Port` history as canonical commit
`97aebd8a2df935ebfc8d69dfc9419b54d063ddeb` on
`c1/macos-host-launch`. It adds a pointer-free eight-slot raw Lighting shadow,
tracks per-field known and invalid provenance, preserves the existing
OpenGL/Windows-facing light arrays, and converts only complete referenced
state into the existing 516-byte canonical Lighting value ABI.

This is focused CPU/source evidence. It is not a cumulative GX snapshot,
live callback, Metal encode/present/readback, rendered pixel, device, or
playability result.

## Provenance and review

- Canonical PC base: `38343a5eb5159471d5ffb472578dadd8e479199e`.
- Worker branch: `c1/lane-raw-lighting-m3`.
- Worker and canonical commit: `97aebd8a2df935ebfc8d69dfc9419b54d063ddeb`.
- Final tree: `84987f4c78fecc283788af0ae03cdc50485a7fe1`.
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Git-only worker bundle SHA-256:
  `6a2ba66a08968c73889ff45aa639856c6629c6a1abf8bcc7d2c266624ab78165`.
- Frozen plan:
  `docs/evidence/RAW-LIGHTING-PRODUCER-PLAN-43992E708-2026-08-14.md`.

The M3 Max worker returned a clean five-file commit and reported native and
combined ASan/UBSan `9/9` focused passes. A separate read-only M3 Max review
inspected the complete base-to-candidate diff against both upstreams and the
frozen plan and returned `PASS`. Root then imported the Git-only bundle,
reviewed the exact tree, fast-forwarded the canonical PC branch, and reran the
same focused matrix on the integrated snapshot.

The independent review initially questioned host-endian color handling, then
withdrew that finding after checking the actual PC ABI: callers pass a
four-byte `GXColor` object by value and the PC implementation deliberately
interprets its object bytes as R, G, B, A. For bytes `10 20 30 40`, both a
little-endian numeric representation (`0x40302010`) and a big-endian numeric
representation (`0x10203040`) convert to the same logical canonical RGBA8 word
`0x40302010`.

## Exact source ownership

The integrated commit changes exactly:

- `pc/CMakeLists.txt`
- `pc/include/pc_gx_internal.h`
- `pc/src/pc_gx.c`
- `pc/src/pc_gx_lighting_raw.c`
- `pc/tests/pc_gx_lighting_raw_shadow_fixture.c`

The new private state contains eight fixed slots with no retained caller
pointers. It tracks loaded and unresolved slots, per-group known and invalid
masks, generations, and sticky malformed provenance. Initialization is
known-empty. Immediate load is the ownership event and copies the complete
logical light object synchronously; indexed load remains unresolved until a
later immediate load repairs that slot.

Mutation retains the established old-batch rule: a completed old batch is
flushed before raw or legacy Lighting state changes. Invalid or nonfinite raw
values fail closed for canonical publication without inventing replacement
state or changing the legacy host path. Canonical conversion is all-or-nothing
and validates the active Channels light masks before emitting Lighting.

## Two-upstream crosswalk

The PC host path is `PCGXLightObjInternal`, `GXInitLight*`,
`GXInitSpecularDir*`, `GXLoadLightObjImm`, `GXLoadLightObjIndx`, light-array
dirtying, and `pc_gx_flush_vertices` in `pc/include/pc_gx_internal.h` and
`pc/src/pc_gx.c`. The new shadow implementation is
`pc/src/pc_gx_lighting_raw.c`; canonical validation remains in
`include/acgc/gx_canonical_lighting_state.h` and
`src/gx_canonical_lighting_state.c`.

The original-behavior oracle is ac-decomp
`src/static/dolphin/gx/GXLight.c`, with startup state in
`src/static/dolphin/gx/GXInit.c`, validation references in
`src/static/dolphin/gx/GXVerify.c`, public/private GX types and enums, and
representative emu64/game callers.

The implementation preserves these reference distinctions:

- `GX_LIGHT0..GX_LIGHT7` must be exactly one-hot and map to slots `0..7`;
- constructors and getters remain caller-object operations and retain no
  caller-owned pointer;
- immediate load copies one complete logical object, while indexed load is
  unresolved rather than guessed;
- angular, distance, position, final direction, and color knownness are
  independent;
- nonfinite inputs invalidate raw publication instead of being normalized;
- spot and distance fallback coefficients follow the original GX domains;
- specular state requires effective `GX_DF_NONE`; and
- disabled Channels controls do not create a Lighting dependency.

`GXInitLightDir` now stores the decomp-faithful final-register negated
direction. The existing OpenGL path currently uploads light position and
color, not that direction field, so this correction does not create a current
host-renderer behavior change. Legacy equality, dirtying, copying, and light
array updates otherwise remain intact.

## Integrated verification

Fresh ignored roots were configured from canonical `97aebd8a2d`:

```sh
cmake -S pc \
  -B /private/tmp/acgc-integrate-raw-lighting-97a-native \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON

cmake -S pc \
  -B /private/tmp/acgc-integrate-raw-lighting-97a-asan \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

Both roots built these nine focused targets plus the production
`pc_gx.c` and `pc_gx_lighting_raw.c` objects:

```text
acgc_gx_canonical_channel_state_tests
acgc_gx_canonical_lighting_state_tests
acgc_pc_gx_tev_raw_shadow_fixture
acgc_pc_gx_transform_raw_shadow_fixture
acgc_pc_gx_depth_raw_shadow_fixture
acgc_pc_gx_texgen_raw_shadow_fixture
acgc_pc_gx_geometry_raw_batch_fixture
acgc_pc_gx_channels_raw_shadow_fixture
acgc_pc_gx_lighting_raw_shadow_fixture
```

Serial focused CTest results:

- native: `9/9` passed;
- combined ASan/UBSan: `9/9` passed with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1`;
- no sanitizer diagnostics were emitted; leak detection was disabled, so this
  is not leak-free proof;
- both production objects compiled in both roots; and
- `git diff --check` passed.

Known warnings are the existing Darwin compile-frontier warning, decomp
`INT_MIN` redefinition, old `vi.h` prototypes, and unsupported warning-option
notice. No full `ac_pc` target was built or linked.

The worker also reports bounded C11/C++11, analyzer, `-m32`, and public
`_WIN32` ABI probes. A real Windows/private-PC build remains blocked by absent
headers and toolchain, so this is not Windows sign-off.

## Remaining limits and next gate

The fixture covers core immediate/indexed loading, repair, generations,
one-hot IDs, invalid/nonfinite provenance, cross-section dependencies, and
all-or-nothing conversion. Additional valid spot/distance modes, every
nonfinite field group, direct big-endian execution, getter lifetime, indexed
observer timing, and reserved-sideband corruption remain useful later matrix
additions; source review found no candidate-owned defect in those gaps.

Raw Lighting releases shared `pc_gx` ownership. The next dependency-ready
source gate is the pointer-free raw Texture/TLUT generation, invalidation, and
synchronous lease implementation frozen in
`RAW-TEXTURE-TLUT-PRODUCER-PLAN-23C26E520-2026-08-14.md`. A cumulative
all-or-nothing snapshot and Apple consumer follow only after that resource
boundary is reviewed and integrated.
