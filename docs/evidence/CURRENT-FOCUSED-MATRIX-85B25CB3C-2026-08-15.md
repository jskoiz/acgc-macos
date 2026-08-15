# Current focused matrix at PC `85b25cb3c`

Date: 2026-08-15

Classification: independent M3 Max verification-only evidence

Result: PASS for the selected CPU matrix; no Windows, runtime, Metal, or
playability sign-off

## Pinned provenance

- ACGC-PC-Port: `85b25cb3c63a68c2903155ccfd2dec05a1cb70fb`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Source-only bundle SHA-256:
  `5aa5c6bf21b4e1ed9f254139802a886dc5f649ca78bc2b69f1b8ee106142bc46`
- M3 Max task: `01a00563-bd2c-7cf0-aa82-d5773a4ccdae` (lane 213)
- Detached source:
  `/private/tmp/acgc-lane-current-85b-matrix-source`
- Native, sanitizer, and Windows-probe roots:
  `/private/tmp/acgc-lane-current-85b-matrix-{native,asan,win}`

The bundle hash and `git bundle verify` passed, and the detached source was
clean at the exact PC commit. The task's visible umbrella worktree was a stale
detached setup snapshot at `ee31f535`; it was recorded only as provenance and
was not edited or used as source evidence. No ISO, extracted asset, key, or
proprietary game-data path was transferred or used.

Toolchain: AppleClang 21.0.0, CMake/CTest 3.31.5, Git 2.50.1, GNU Make 3.81,
Darwin 25.6.0 arm64.

## Selected matrix

The fourteen neutral validators were:

```text
acgc_gx_canonical_fog_state_tests
acgc_gx_canonical_envelope_tests
acgc_gx_canonical_blend_state_tests
acgc_gx_canonical_alpha_state_tests
acgc_gx_canonical_transform_state_tests
acgc_gx_canonical_geometry_state_tests
acgc_gx_canonical_depth_state_tests
acgc_gx_canonical_tev_state_tests
acgc_gx_canonical_channel_state_tests
acgc_gx_canonical_lighting_state_tests
acgc_gx_canonical_dynamic_state_tests
acgc_gx_canonical_texture_state_tests
acgc_gx_canonical_raster_state_tests
acgc_gx_canonical_indirect_state_tests
```

The seven setter-owned raw fixtures were:

```text
acgc_pc_gx_tev_raw_shadow_fixture
acgc_pc_gx_transform_raw_shadow_fixture
acgc_pc_gx_depth_raw_shadow_fixture
acgc_pc_gx_texgen_raw_shadow_fixture
acgc_pc_gx_geometry_raw_batch_fixture
acgc_pc_gx_channels_raw_shadow_fixture
acgc_pc_gx_raster_raw_shadow_fixture
```

## Native and sanitizer commands

Native configuration used:

```sh
cmake -S /private/tmp/acgc-lane-current-85b-matrix-source/pc \
  -B /private/tmp/acgc-lane-current-85b-matrix-native \
  -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

Each of the 21 named targets was built separately and serially:

```sh
cmake --build /private/tmp/acgc-lane-current-85b-matrix-native \
  --target "$target" -- -j1
```

All 21 native target builds passed. The selected tests ran serially with the
exact 21 names listed above:

```sh
ctest --test-dir /private/tmp/acgc-lane-current-85b-matrix-native \
  --output-on-failure --parallel 1 -R "$selected_test_regex"
```

Result: `21/21` passed in 5.66 seconds.

The combined sanitizer configuration used the same source and target list at
`/private/tmp/acgc-lane-current-85b-matrix-asan`, adding:

```sh
-DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer'
-DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer'
-DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
-DCMAKE_SHARED_LINKER_FLAGS='-fsanitize=address,undefined'
```

All 21 sanitizer target builds passed. The selected tests ran serially under:

```sh
ASAN_OPTIONS='detect_leaks=0:halt_on_error=1:abort_on_error=1' \
UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1' \
ctest --test-dir /private/tmp/acgc-lane-current-85b-matrix-asan \
  --output-on-failure --parallel 1 -R "$selected_test_regex"
```

Result: `21/21` passed in 7.17 seconds with no ASan or UBSan diagnostic.
Leak detection was disabled, so this is not leak-free evidence. Expected
Darwin/decomp warnings remained warnings and did not mask a target failure.

## Bounded syntax and Windows boundary

Public C and C++ ABI translation units passed `8/8` across native, `-m32`,
`_WIN32`, and `--target=i686-w64-windows-gnu` syntax-only invocations. The
production Channels source/fixture and Raster fixture passed `6/6` native and
`-m32` syntax-only probes with the CMake-derived include/define set.

This does not establish a Windows build. For the explicit i686 target,
`process.h`, `string.h`, and `sys/types.h` were unavailable; no MinGW/i686 GCC
or Clang toolchain was installed. Bounded CMake Windows generation returned
status 1 because the host SDL2 package imports Apple `FRAMEWORK` and
`WEAK_FRAMEWORK` link features. No PE link or Windows runtime was attempted.

## Claim boundary

This proves the exact `85b25cb3c` selected CPU/source fixtures, validators,
ABI syntax, and combined ASan/UBSan execution before lane 211. It does not
validate lane 211's later Geometry change and proves no full `ac_pc` link,
launch, LLDB hit, callback, OpenGL/Metal encode or present, pixel readback,
input, audible audio, save/reload, lifecycle, Windows runtime, simulator,
physical device, iOS, or playability gate.

