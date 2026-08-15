# Canonical GX Channels value ABI

Date: 2026-08-14

## Provenance

- ACGC-PC-Port worker base: `1d48691a4fc5f672951d02815723672b2928602e`
- M3 Max worker branch: `c1/lane-canonical-channels-m3`
- M3 Max worker commit: `325ecd3625249a04bc81e8c2151b63e2255fd03b`
- Canonical integration parent: `9f149b6fd99947795e9ba806a61359176e4517f1`
- Canonical integration branch: `c1/macos-host-launch`
- Canonical integration commit: `324c174ae31e06725b51d662f2645cfd8f96c835`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Source-only worker bundle SHA-256:
  `50cc09711c93539cf7298880a4a11bcb7c9bfb43fb109d209cbaffed42577ddf`

The worker commit was independently reviewed in an isolated local worktree and
then cherry-picked onto the newer canonical Depth-order tip. The four-file
Channels change does not overlap the four-file Depth repair. No ISO, extracted
asset, key, or proprietary game-data path was read, copied, or added to Git.

## Exact change

The source change owns exactly:

- new `include/acgc/gx_canonical_channel_state.h`;
- new `src/gx_canonical_channel_state.c`;
- new `pc/portable/tests/test_gx_canonical_channel_state.c`; and
- minimal `pc/portable/CMakeLists.txt` library/test registration.

It implements a pointer-free, fixed-width Channels value ABI:

- canonical section ID `3`, mask `0x0004`, version `1`;
- payload size `136` bytes and alignment `4`;
- `active_count` at offset `0` and exact-prefix `record_valid_mask` at `4`;
- two 64-byte records at offsets `8` and `72`;
- each record contains `channel_index`, a zero reserved word, six-word color
  control, six-word alpha control, and logical packed RGBA8 ambient/material
  colors; and
- logical wire words are little-endian and must be explicitly encoded rather
  than copied as a native struct on a big-endian host.

The strict validator rejects counts above two, non-prefix masks, wrong active
indices, nonzero inactive records, nonzero reserved fields, non-`0/1`
booleans, unknown sources, high light-mask bits, unknown diffuse or attenuation
functions, and `GX_AF_SPEC` with an effective diffuse function other than
`GX_DF_NONE`. Disabled channel controls retain and validate their values, so
disabled `GX_SRC_VTX` is valid. Present and absent directory entries use the
existing canonical envelope's exact metadata rules.

## Two-upstream crosswalk

- Existing PC value references remain in `pc/include/pc_gx_internal.h` and
  `pc/src/pc_gx.c`, including channel counts, combined/separate channel
  setters, material/ambient colors, and the V2/V4 channel records. This lane
  does not treat their current rendering limits as canonical limits and does
  not edit those files.
- ac-decomp `src/static/dolphin/gx/GXLight.c` supplies the channel setter and
  register semantics. Its specular attenuation path forces the effective
  diffuse field to `GX_DF_NONE`.
- ac-decomp `src/static/dolphin/gx/GXInit.c` establishes disabled channel
  controls using both `GX_SRC_REG` and `GX_SRC_VTX`.
- ac-decomp public GX enums define the exact boolean, source, light-mask,
  diffuse, attenuation, and combined/separate channel domains.

The neutral ABI does not infer canonical values from OpenGL uniforms. Raw PC
Channels provenance and the cumulative producer remain separate later owners.

## Review and exact integrated verification

An independent Luna Max/max review returned PASS with no candidate-owned
finding. It confirmed every size/offset assertion, strict validation rule,
present/absent metadata behavior, decomp semantics, C/C++11 header use, static
analysis, and conflict-free integration on top of the Depth repair.

The integration owner configured fresh roots on exact canonical PC
`324c174ae3`:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-integrate-channels-324c174-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-channels-324c174-native \
  --target acgc_gx_canonical_fog_state_tests \
           acgc_gx_canonical_envelope_tests \
           acgc_gx_canonical_blend_state_tests \
           acgc_gx_canonical_alpha_state_tests \
           acgc_gx_canonical_transform_state_tests \
           acgc_gx_canonical_geometry_state_tests \
           acgc_gx_canonical_depth_state_tests \
           acgc_gx_canonical_tev_state_tests \
           acgc_gx_canonical_channel_state_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-channels-324c174-native \
  -R '^acgc_gx_canonical_(fog_state|envelope|blend_state|alpha_state|transform_state|geometry_state|depth_state|tev_state|channel_state)_tests$' \
  --output-on-failure --no-tests=error --parallel 1
```

Native CTest passed `9/9`. The same targets and expression passed `9/9` in
`/private/tmp/acgc-integrate-channels-324c174-asan` with combined
`-fsanitize=address,undefined`,
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1`, and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. No sanitizer diagnostic was
emitted. Leak detection was disabled, so this is not a leak-free claim.

The worker and independent review also passed `git diff --check`, C and C++11
ABI probes, `clang --analyze`, host `-m32` syntax, and bounded Windows-target
header syntax. The host lacks a real i686 Windows standard library, sysroot,
linker, and runtime, so this is not Windows sign-off.

## Evidence boundary

This proves the frozen value ABI, validators, exact metadata behavior, native
execution, combined ASan/UBSan execution, available host ABI/syntax probes, and
integration with the current Depth repair. It does not prove raw PC Channels
capture, a cumulative producer, full `ac_pc` link, game launch, callback,
OpenGL or Metal rendering, encode/present/readback, a game-owned pixel or
frame, input, audio, save/reload, device behavior, Windows runtime, iOS, or
playability.
