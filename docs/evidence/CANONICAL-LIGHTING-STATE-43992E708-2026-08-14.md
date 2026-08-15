# Canonical GX Lighting value ABI

Date: 2026-08-14

## Provenance

- ACGC-PC-Port worker base: `324c174ae31e06725b51d662f2645cfd8f96c835`
- M3 Max worker branch: `c1/lane-canonical-lighting-m3`
- M3 Max worker commit: `431eb3673533425f35b07f36738280fdb9e0f612`
- Canonical integration branch: `c1/macos-host-launch`
- Canonical integration commit: `43992e708572e325f525d3ccdbec7a84793d352d`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Source-only worker bundle SHA-256:
  `d4aa10c5b2516c0236b9c51590cecc4114fe37500190f0c35d61cf88019b6305`

The worker commit was imported through a source-only Git bundle, independently
reviewed in an isolated local worktree, and cherry-picked onto the canonical
PC branch. No ISO, extracted asset, key, or proprietary game-data path was
read, copied, or added to Git.

## Exact change

The source change owns exactly:

- new `include/acgc/gx_canonical_lighting_state.h`;
- new `src/gx_canonical_lighting_state.c`;
- new `pc/portable/tests/test_gx_canonical_lighting_state.c`; and
- minimal `pc/portable/CMakeLists.txt` library/test registration.

It implements a pointer-free, fixed-width Lighting value ABI:

- canonical section ID `7`, mask `0x0040`, version `1`;
- payload size `516` bytes and alignment `4`;
- one eight-bit `loaded_mask` at offset `0`;
- eight fixed 64-byte final light-register records beginning at offset `4`;
- each record contains three required-zero words, logical packed RGBA8 color,
  and twelve IEEE-754 binary32 bit patterns for angular attenuation, distance
  attenuation, position, and direction; and
- logical wire words are little-endian and must be explicitly encoded rather
  than copied from a native struct on a big-endian host.

The validator rejects mask bits outside the eight slots, nonzero unloaded
records, nonzero reserved words, and every infinity or NaN float pattern. A
zero direction remains valid and this boundary neither normalizes nor changes
the decomp direction convention. Present metadata requires exact version,
size, count/capacity `8/8`, mask, and reserved values. Absent metadata retains
only the fixed section ID.

## Two-upstream crosswalk

- `upstream/ac-decomp/src/static/dolphin/gx/GXLight.c` defines the private
  16-word light-object order and writes that final value to the eight hardware
  light slots in `GXLoadLightObjImm`.
- `upstream/ac-decomp/include/dolphin/gx/GXPriv.h` and `GXStruct.h` confirm the
  64-byte object extent and field order.
- `upstream/ACGC-PC-Port/pc/src/pc_gx.c` has the corresponding 16-word host
  object and one-hot `GX_LIGHT0` through `GX_LIGHT7` load mapping.
- The PC host still lacks setter-owned raw Lighting knownness and exact
  producer conversion. This neutral ABI does not claim to close that source
  gap or change the legacy OpenGL path.

## Verification

Independent review passed `git diff --check`, a clean additive merge check,
`clang --analyze`, host C++11 syntax, bounded `-m32` C syntax, and the available
`i686-pc-windows-msvc` C/header syntax probes. A real Windows linker/runtime
was not available.

Fresh exact-integrated commands:

```sh
cmake -S pc/portable \
  -B /private/tmp/acgc-integrate-lighting-43992e-native \
  -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-lighting-43992e-native --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-lighting-43992e-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_gx_canonical_.*_tests$'
```

Result: native canonical matrix `10/10` passed.

```sh
cmake -S pc/portable \
  -B /private/tmp/acgc-integrate-lighting-43992e-asan \
  -DBUILD_TESTING=ON \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-integrate-lighting-43992e-asan --parallel 1
ASAN_OPTIONS=detect_leaks=0 \
  ctest --test-dir /private/tmp/acgc-integrate-lighting-43992e-asan \
  --output-on-failure --parallel 1 \
  -R '^acgc_gx_canonical_.*_tests$'
```

Result: combined ASan/UBSan canonical matrix `10/10` passed with no sanitizer
diagnostic. `detect_leaks=0`, so this is not leak-check evidence.

## Claim boundary

This proves the renderer-neutral Lighting value layout, validator, exact
metadata, additive integration, focused native execution, and combined
ASan/UBSan execution. It does not prove a raw PC Lighting producer, live
cumulative packet, callback, full `ac_pc` link, launch, Windows runtime,
OpenGL/Metal rendering, encode, present, readback, pixel, device, or
playability gate.
