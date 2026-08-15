# PC raw Texgen/SU shadow integration evidence

Date: 2026-08-14

Lane: 173 / `01a002f3-0540-7db0-b2ac-052fed62f957`

PC base: `251a010b8d6167d7dd90042934d8491d1c96b040`

Worker final: `490c14d72cb76ab939c9c39740687cb7633d3e1b`

Integrated PC final: `1d48691a4fc5f672951d02815723672b2928602e` on
`c1/macos-host-launch`

Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

Source-only bundle SHA-256:
`4a614b31d894329faa45665e9e8eddcac1a7c9ae2b799aab94d3cac8371790ca`

## Integrated change

The integration owner independently reviewed and cherry-picked the worker
chain one commit at a time:

- `2e3c95dae9` — retain raw Texgen, texture/post-matrix, and manual-SU
  provenance;
- `2df84f628e` — repair setter ordering and fail-closed validation;
- `731b7ee412` — make the fixture-only flush observer non-intercepting; and
- `490c14d72c` — restore the legacy Texgen equality/dirty ordering.

The integrated commits became `ac7734c457`, `e5264ecbf8`, `bbb2eaf6df`, and
`1d48691a4f`. The exact source scope is:

- `pc/CMakeLists.txt`;
- `pc/include/pc_gx_internal.h`;
- `pc/src/pc_gx.c`; and
- `pc/tests/pc_gx_texgen_raw_shadow_fixture.c`.

The raw state records eight generators, eleven ordinary texture-matrix slots,
twenty-one post-matrix slots, and eight manual-SU records with explicit
knownness and provenance. Indexed texture-matrix loads remain unresolved until
the PC host has a safe guest-memory owner. Invalid values fail closed without
erasing the established OpenGL compatibility mirrors.

All seven owned setters now flush a completed old batch before changing raw or
effective state: `GXLoadTexMtxImm`, `GXLoadTexMtxIndx`, `GXSetNumTexGens`,
`GXSetTexCoordGen2`, `GXSetTexCoordScaleManually`, `GXSetTexCoordCylWrap`, and
`GXSetTexCoordBias`. `GXEnableTexOffsets` remains Raster-owned and outside this
shadow. `GXSetTexCoordGen2` captures raw state before its compatibility test,
but changes the legacy normalize/post mirrors only after the existing equality
check and dirty mark. The focused fixture proves normalize-only and
post-matrix-only changes dirty the legacy path, while an identical repeat does
not; the fixture observer cannot suppress the normal flush path.

## Reference crosswalk

The existing PC renderer in `pc/src/pc_gx.c` remains the OpenGL/Windows
compatibility oracle. The decomp implementation supplies the guest-facing
semantics: `src/static/dolphin/gx/GXAttr.c:471-577` for Texgen/count state,
`GXTransform.c:310-378` for immediate/indexed texture matrices,
`GXTexture.c:1036-1074` for manual scale/cylinder/bias state, and
`GXGeometry.c:99-109` for Raster-owned texture-coordinate offsets. No decomp
source change is required.

## Independent review and exact integrated verification

Two independent Luna Max/max reviews returned PASS. One reproduced the prior
legacy dirty-state regression as fixed and ran the focused native and combined
ASan/UBSan matrices. The other performed a separate Windows/OpenGL-preservation,
bounded-validation, static-analysis, ABI, and merge-conflict audit. Neither
found a candidate-owned blocker.

The integration owner then configured fresh roots on exact integrated PC
`1d48691a4f`:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-texgen-1d48691-native \
  -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-texgen-1d48691-native \
  --target acgc_pc_gx_transform_raw_shadow_fixture \
           acgc_pc_gx_depth_raw_shadow_fixture \
           acgc_pc_gx_tev_raw_shadow_fixture \
           acgc_pc_gx_texgen_raw_shadow_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-texgen-1d48691-native \
  -R '^acgc_pc_gx_(transform|depth|tev|texgen)_raw_shadow_fixture$' \
  --output-on-failure --no-tests=error --parallel 1
```

Native CTest passed `4/4`. The same targets and CTest expression passed `4/4`
in `/private/tmp/acgc-integrate-texgen-1d48691-asan` with combined
`-fsanitize=address,undefined`, `ASAN_OPTIONS=detect_leaks=0`, and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; no sanitizer diagnostic was
emitted. Leak detection was disabled, so this is not a leak-free claim. The
only diagnostics were the known Darwin compile-frontier warning, the decomp
`INT_MIN` SDK redefinition, and AppleClang's unsupported
`-Wno-builtin-declaration-mismatch` warning.

## Evidence boundary

This proves setter-owned CPU Texgen/SU provenance, bounded validation,
flush-before-mutation ordering, legacy equality/dirty preservation, fixture
non-interception, native execution, and combined ASan/UBSan execution on the
integrated snapshot. It does not implement the cumulative canonical producer
or prove a full `ac_pc` link, LLDB/runtime reachability, Windows runtime,
OpenGL visual output, Apple consumption, Metal encode/present/readback, a
game-owned pixel or frame, device behavior, or playability.
