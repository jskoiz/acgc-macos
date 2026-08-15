# Current focused matrix at PC `38343a5eb5`

Date: 2026-08-14
Classification: independent M3 Max verification-only evidence
Result: PASS for the selected CPU matrix; no Windows, runtime, Metal, or
playability sign-off

## Pinned provenance

- ACGC-PC-Port base: `23c26e520a943ac843023f0341d2670d9c7ef9fc`
- ACGC-PC-Port final: `38343a5eb5159471d5ffb472578dadd8e479199e`
- Final tree: `3df0df428aeb1a2502eccb2302b50d64934a9b0b`
- ac-decomp: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Tracked-source bundle SHA-256:
  `11f1631915c8e97ae9d48b79ef3132b8083cfc756a2efe1e2b4f1d258fdfa0ce`
- M3 Max task: `01a002e1-540c-7693-b25d-363a1f209dd4`
- Detached source worktree:
  `/private/tmp/acgc-lane-current-383-matrix-source`

The bundle verified successfully, contained exact final `38343a5eb5`, and
required exact base `23c26e520a`. The source worktree remained detached and
tracked-clean. The lane made no source, branch, documentation, gitlink, ISO,
asset, key, or proprietary-resource change.

## Selected matrix

The twelve neutral validators were:

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
```

The six setter-owned raw fixtures were:

```text
acgc_pc_gx_tev_raw_shadow_fixture
acgc_pc_gx_transform_raw_shadow_fixture
acgc_pc_gx_depth_raw_shadow_fixture
acgc_pc_gx_texgen_raw_shadow_fixture
acgc_pc_gx_geometry_raw_batch_fixture
acgc_pc_gx_channels_raw_shadow_fixture
```

## Commands and results

Native configuration:

```sh
cmake -S /private/tmp/acgc-lane-current-383-matrix-source/pc \
  -B /private/tmp/acgc-lane-current-383-matrix-native \
  -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

This exited `0` with the expected Darwin compile-frontier warning. Each of the
18 named targets above was then built separately using this exact command form:

```sh
cmake --build /private/tmp/acgc-lane-current-383-matrix-native \
  --target "$target" -- -j1
```

All 18 builds exited `0`. The exact serial test command was:

```sh
ctest --test-dir /private/tmp/acgc-lane-current-383-matrix-native \
  --output-on-failure --parallel 1 \
  -R '^(acgc_gx_canonical_fog_state_tests|acgc_gx_canonical_envelope_tests|acgc_gx_canonical_blend_state_tests|acgc_gx_canonical_alpha_state_tests|acgc_gx_canonical_transform_state_tests|acgc_gx_canonical_geometry_state_tests|acgc_gx_canonical_depth_state_tests|acgc_gx_canonical_tev_state_tests|acgc_gx_canonical_channel_state_tests|acgc_gx_canonical_lighting_state_tests|acgc_gx_canonical_dynamic_state_tests|acgc_gx_canonical_texture_state_tests|acgc_pc_gx_tev_raw_shadow_fixture|acgc_pc_gx_transform_raw_shadow_fixture|acgc_pc_gx_depth_raw_shadow_fixture|acgc_pc_gx_texgen_raw_shadow_fixture|acgc_pc_gx_geometry_raw_batch_fixture|acgc_pc_gx_channels_raw_shadow_fixture)$'
```

Result: exit `0`, `18/18` passed in 5.08 seconds.

Combined ASan/UBSan configuration added:

```sh
-DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer'
-DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer'
-DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
-DCMAKE_SHARED_LINKER_FLAGS='-fsanitize=address,undefined'
```

to the same configure command with build root
`/private/tmp/acgc-lane-current-383-matrix-asan`. Configuration and all 18
serial target builds exited `0`. The exact test invocation was:

```sh
ASAN_OPTIONS='detect_leaks=0:halt_on_error=1' \
UBSAN_OPTIONS='halt_on_error=1' \
ctest --test-dir /private/tmp/acgc-lane-current-383-matrix-asan \
  --output-on-failure --parallel 1 \
  -R '^(acgc_gx_canonical_fog_state_tests|acgc_gx_canonical_envelope_tests|acgc_gx_canonical_blend_state_tests|acgc_gx_canonical_alpha_state_tests|acgc_gx_canonical_transform_state_tests|acgc_gx_canonical_geometry_state_tests|acgc_gx_canonical_depth_state_tests|acgc_gx_canonical_tev_state_tests|acgc_gx_canonical_channel_state_tests|acgc_gx_canonical_lighting_state_tests|acgc_gx_canonical_dynamic_state_tests|acgc_gx_canonical_texture_state_tests|acgc_pc_gx_tev_raw_shadow_fixture|acgc_pc_gx_transform_raw_shadow_fixture|acgc_pc_gx_depth_raw_shadow_fixture|acgc_pc_gx_texgen_raw_shadow_fixture|acgc_pc_gx_geometry_raw_batch_fixture|acgc_pc_gx_channels_raw_shadow_fixture)$'
```

Result: exit `0`, `18/18` passed in 5.83 seconds, with no ASan or UBSan
diagnostic. Leak detection was disabled and this evidence therefore makes no
leak-free claim.

Corrected public ABI translation units asserted the canonical Channels sizes
and offsets (`24`, `64`, `136`; offsets `0/4/8/32/56/60`) and Lighting sizes
and offsets (`64`, `516`; offsets `0/4`). The same stdin translation unit was
accepted by all eight compiler invocations:

```sh
/usr/bin/clang -std=c11 -Wall -Wextra -pedantic-errors -Iinclude -x c -fsyntax-only -
/usr/bin/clang++ -std=c++11 -Wall -Wextra -pedantic-errors -Iinclude -x c++ -fsyntax-only -
/usr/bin/clang -std=c11 -Wall -Wextra -pedantic-errors -m32 -Iinclude -x c -fsyntax-only -
/usr/bin/clang++ -std=c++11 -Wall -Wextra -pedantic-errors -m32 -Iinclude -x c++ -fsyntax-only -
/usr/bin/clang -std=c11 -Wall -Wextra -pedantic-errors -D_WIN32 -Iinclude -x c -fsyntax-only -
/usr/bin/clang++ -std=c++11 -Wall -Wextra -pedantic-errors -D_WIN32 -Iinclude -x c++ -fsyntax-only -
/usr/bin/clang --target=i686-w64-windows-gnu -std=c11 -Wall -Wextra -pedantic-errors -D_WIN32 -Iinclude -x c -fsyntax-only -
/usr/bin/clang++ --target=i686-w64-windows-gnu -std=c++11 -Wall -Wextra -pedantic-errors -D_WIN32 -Iinclude -x c++ -fsyntax-only -
```

Here `include` was the absolute
`/private/tmp/acgc-lane-current-383-matrix-source/include`. All eight corrected
commands exited `0`. An earlier wrapper referenced two nonexistent header names
and printed misleading PASS labels because it lacked `set -e`; that attempt is
superseded and is not evidence.

Native and `-m32` syntax-only compilation of
`pc_gx_channels_raw.c` and its fixture also exited `0` with the production
include/define set. `git diff --check` passed.

## Windows boundary

The bounded Windows configure command used `CMAKE_SYSTEM_NAME=Windows`, the
host Clang pair, `i686-w64-windows-gnu` compiler targets, and
`CMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY` with root
`/private/tmp/acgc-lane-current-383-matrix-win`. It returned status `1` during
generation because the host SDL2 package imports Apple `FRAMEWORK` and
`WEAK_FRAMEWORK` link features that the Windows generator cannot support. The
conditional fixture build was not executed. Private PC syntax is also blocked
by missing `process.h`/`sys/types.h`; no MinGW or i686 Linux compiler is
installed. This is not Windows build, link, PE, runtime, or regression sign-off.

## Two-upstream crosswalk

The verified raw Channels producer symbols are
`pc_gx_raw_channels_initialize`, `pc_gx_raw_channels_set_num`,
`pc_gx_raw_channels_set_control`, `pc_gx_raw_channels_set_color`, and
`pc_gx_raw_channels_build_canonical`. State declarations are in
`pc/include/pc_gx_internal.h`; initialization, flush ordering, and legacy
setters are in `pc/src/pc_gx.c`; the pointer-free producer is in
`pc/src/pc_gx_channels_raw.c`.

The decomp crosswalk used `GXLight.c`, `GXInit.c`, `GXEnum.h`, and `GXVerify.c`
for combined/separate channel semantics, initialization, domains, disabled
`GX_SRC_VTX`, light masks, and specular/diffuse validation. The six raw fixture
registrations exercise TEV, Transform, Depth, Texgen/SU, Geometry, and Channels
against the twelve neutral validators on the exact integrated tree.

## Cleanup and claim boundary

Reviewed generated roots are:

- `/private/tmp/acgc-lane-current-383-matrix-native` (40 MB)
- `/private/tmp/acgc-lane-current-383-matrix-asan` (53 MB)
- `/private/tmp/acgc-lane-current-383-matrix-win` (25 MB)
- `/private/tmp/acgc-lane-current-383-matrix-source`

They may be retired only after exact holder/clean checks. The shared source-only
bundle remains protected while raw Lighting lane 200 is active.

This is CPU-only source compilation, ABI, focused fixture, sanitizer, and
bounded syntax evidence. It proves no full `ac_pc` link, launch, LLDB hit,
resource access, callback, Metal encode/present/readback, pixel, input, audible
audio, save/reload, lifecycle, Windows runtime, simulator, physical device,
iOS, or playability behavior.
