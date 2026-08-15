# PC raw Depth shadow at `251a010b8`

Date: 2026-08-14

Remote M3 Max task: `01a00358-efb5-7f43-b28a-337c0d8ad584`

References:

- PC base: `59714a1fd8dd8e6a346e28a24b9fd4c35c05db78`
- Remote worker commits: `7debdfb79d8d2d481fb6ba8b524adbcee1b5714b`
  and repair `3a574f6b4fa649f88e1d4e8279094bad4f3a9e22`
- Integrated PC commits: `eeec2301c1` and `251a010b8d`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Integrated result

The reviewed two-commit series changes exactly:

- `pc/include/pc_gx_internal.h`
- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_depth_raw_shadow_fixture.c`
- `pc/CMakeLists.txt`

`PCGXRawDepth` is a setter-owned sideband separate from the legacy OpenGL-facing
`z_*` fields. It starts unknown even though the host renderer keeps its existing
defaults. Every valid `GXSetZMode` call records normalized logical
`compare_enable`, exact compare function `GX_NEVER` through `GX_ALWAYS`, and
normalized `update_enable` before the existing flush and equality-return paths.
Disabled comparison retains its logical compare function. An invalid compare
function clears the provenance rather than making it canonically renderable.

The first worker commit temporarily widened the two boolean parameters to
`u32` so its fixture could inject impossible values. Root review rejected that
cross-translation-unit ABI change. The repair restores
`GXSetZMode(GXBool, u32, GXBool)`, removes malformed-boolean injection, and
checks that the PC `bool` boundary converts `(GXBool)2` to `GX_TRUE`. Invalid
compare function `8` remains representable and remains fail-closed. The public
GX header, canonical Depth ABI, V1-V4 packets, producer, and Apple code are
unchanged.

## Two-upstream crosswalk and review

The PC source reference is `PCGXState`, `pc_gx_init`, `GXSetZMode`, the existing
raw Transform and raw TEV sidebands, and current packet rejection paths in
`pc/include/pc_gx_internal.h` and `pc/src/pc_gx.c`. The decomp oracle is
`include/dolphin/gx/GXPixel.h`, `src/static/dolphin/gx/GXPixel.c`,
`GXInit.c`, private `__gx` state, and representative emu64, J2D, JFW, and
Famicom callers. The decomp stores compare enable, the three-bit compare
function, and update enable; its callers use typed booleans and compare enums.

An independent Luna Max review returned PASS on the complete two-commit range.
It confirmed the repaired typed boundary, pre-flush ownership, initial
unknownness, valid-function domain, equality-path behavior, Transform/TEV
isolation, narrow CMake registration, and clean diff. The review made no source
or ref mutation and ran no build or runtime command.

## Exact integrated verification

On canonical PC `251a010b8`, the integration owner configured fresh native and
combined ASan/UBSan roots:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-depth-251a010-native \
  -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-depth-251a010-native \
  --target acgc_pc_gx_depth_raw_shadow_fixture \
           acgc_pc_gx_transform_raw_shadow_fixture \
           acgc_pc_gx_tev_raw_shadow_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-depth-251a010-native \
  -R '^acgc_pc_gx_(depth|transform|tev)_raw_shadow_fixture$' \
  --output-on-failure --parallel 1
```

Native passed `3/3`. The same matrix passed `3/3` in
`/private/tmp/acgc-integrate-depth-251a010-asan` with
`-fsanitize=address,undefined`, `ASAN_OPTIONS=detect_leaks=0`, halt-on-error,
and no sanitizer diagnostic. Leak detection was deliberately disabled, so
this is not a leak-free claim. Build output contained only the already-known
AppleClang unsupported-warning-option and SDK/decomp `INT_MIN` redefinition
warnings.

The remote lane separately reported native `3/3`, combined ASan/UBSan `3/3`,
fixed-width ABI and legacy compile probes passing, plus bounded `-m32` and
`_WIN32` frontend checks. A real MinGW/i686 sysroot and Windows runtime were
unavailable, so this is not Windows sign-off.

## Evidence boundary

This proves only setter-owned CPU Depth provenance on the exact integrated
source snapshot and isolation from the existing raw Transform and raw TEV
sidebands. It does not prove a cumulative canonical producer, live callback,
full `ac_pc` link, launch, OpenGL or Metal rendering, encode/present/readback,
pixel, physical device, Windows runtime, iOS, or playability. The next relevant
producer must consume this known-gated sideband together with the separate
canonical Depth validator.
