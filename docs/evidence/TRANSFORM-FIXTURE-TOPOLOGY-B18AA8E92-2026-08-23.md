# Transform raw-shadow fixture topology — PC `b18aa8e92`

## Outcome

PC [PR #21](https://github.com/jskoiz/ACGC-PC-Port/pull/21),
`Repair transform fixture link topology`, merged into
`c1/macos-host-launch` as
`b18aa8e921ae9bd99c8a07728003b91c5c71ad5b`.

- PC base: `2f944f1aedacba2df0f0d5c15d5fadc67f8e8c54`
- Original worker commit:
  `e9ca89ecff575f3e327d2471878efe17cb76ca40`, based on
  `928594a2649e7934cee43eaaffec7f82481e969f`
- Current-base replay:
  `6ea409b8b58f404f0703a271d03f836a27d7a3dc`
- PC merge: `b18aa8e921ae9bd99c8a07728003b91c5c71ad5b`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Hosted PR #21 status-check rollup and reviews: empty; the PC merge tip has
  no `.github/workflows` entries. GitHub's REST surface nevertheless lists
  seven queued external suites—GitGuardian, Vercel, Cursor, Claude, Greptile,
  Expo, and Xcode Cloud—with zero check runs and no conclusions. This is not a
  hosted build, security pass, or Apple CI result.

The merge changes only `pc/CMakeLists.txt`: 14 insertions, no deletions.
It repairs a focused test executable. It does not change production source
semantics or add anything to `ac_pc`.

## Reproduced blocker

At the PC base, `acgc_pc_gx_transform_raw_shadow_fixture` compiled
`pc_gx.c` directly but did not carry the cumulative gathering dependency
closure that now belongs to that translation unit. The base control compiled
and then failed to link on:

- `pc_gx_cumulative_snapshot_gather`
- `pc_gx_notify_cumulative_snapshot_attempt`

Those symbols are defined by the existing `acgc_pc_gx_production` object
target. The failure was target-membership drift after cumulative gathering was
added to the production flush path, not a missing implementation and not a
Transform semantic defect.

## CMake correction

The focused fixture now adds the raw owners needed by the cumulative closure:

- `pc/src/pc_gx_channels_raw.c`
- `pc/src/pc_gx_lighting_raw.c`
- `pc/src/pc_gx_texture.c`
- `pc/src/pc_gx_canonical_snapshot.c`

It enables the target-private producer definitions required by those sources:

- `PC_DARWIN_COMPILE_AUDIT`
- `PC_GX_ALPHA_RAW_PRODUCER`
- `PC_GX_CHANNELS_RAW_PRODUCER`
- `PC_GX_LIGHTING_RAW_PRODUCER`
- `PC_GX_RASTER_RAW_PRODUCER`
- `PC_GX_TEXTURE_DYNAMIC_PRODUCER`

It reuses:

- `acgc_pc_gx_production`
- `acgc_portable`
- the existing semantic packet, GLAD, SDL2, platform, Foundation, and Metal
  dependencies already used by the neighboring cumulative fixtures

The direct raw-owner sources are not members of
`acgc_pc_gx_production`. The cumulative gatherer, cumulative assembler, and
standalone canonical producers remain owned by that object target exactly
once. Generated-link and static target inspection found no duplicate object or
definition.

The target remains inside:

```text
APPLE AND PC_DARWIN_COMPILE_AUDIT AND BUILD_TESTING
```

No fixture-only definition or source was promoted into production.

## Two-upstream crosswalk

PC reference:

- `pc/src/pc_gx.c`: Transform raw setters, cumulative gather invocation, and
  attempt notification at the completed-Geometry flush boundary
- `pc/src/pc_gx_cumulative_gatherer.c`: the two previously unresolved
  cumulative symbols and all-section producer order
- `pc/CMakeLists.txt`: the transform raw-shadow fixture and
  `acgc_pc_gx_production` target memberships
- `pc/tests/pc_gx_transform_raw_shadow_fixture.c`: source-backed Transform
  shadow behavior

Decomp reference at `09ca8e8b5`:

- `src/static/dolphin/gx/GXTransform.c`: projection, viewport, position,
  normal, texture-matrix, and current-matrix semantics
- `include/dolphin/gx/GXTransform.h`: original GX Transform API

The decomp tree is the Transform behavior oracle. It has no host CMake target,
cumulative gatherer, callback, or focused fixture topology counterpart.

## Candidate and merge review

The original one-file patch applied cleanly to PC `2f944f1ae`.
`git merge-tree` produced synthetic tree
`fda726cfd31b6973461f89d2b0564546930a6153` with no conflict.

The current-base replay `6ea409b8b` and hosted merge `b18aa8e92` have that
same tree. Independent reviews found:

- no P0 or P1 blocker;
- exactly one executable and one CTest registration;
- no duplicate source ownership;
- no stub or permissive-linker workaround;
- no production semantic change; and
- a material base control that fails on the exact dependency gap.

## Exact-merge verification

Detached source:
`/private/tmp/acgc-integrator-transform-fixture-b18aa8e92`, clean at exact
merge `b18aa8e921ae9bd99c8a07728003b91c5c71ad5b`.

Fresh native:

```sh
cmake -S /private/tmp/acgc-integrator-transform-fixture-b18aa8e92/pc \
  -B /private/tmp/acgc-merged-transform-fixture-native-b18aa8e92 \
  -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-merged-transform-fixture-native-b18aa8e92 \
  --target acgc_pc_gx_transform_raw_shadow_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-merged-transform-fixture-native-b18aa8e92 \
  -N -R '^acgc_pc_gx_transform_raw_shadow_fixture$'
ctest --test-dir /private/tmp/acgc-merged-transform-fixture-native-b18aa8e92 \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_transform_raw_shadow_fixture$'
```

Result: configure and 59-step target build passed; discovery found exactly one
test; exact CTest passed `1/1` in 0.01 seconds.

Fresh combined ASan/UBSan used:

```text
-fsanitize=address,undefined -fno-omit-frame-pointer
```

on C and C++ compilation plus the matching executable linker flags.

```sh
cmake -S /private/tmp/acgc-integrator-transform-fixture-b18aa8e92/pc \
  -B /private/tmp/acgc-merged-transform-fixture-asan-ubsan-b18aa8e92 \
  -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build \
  /private/tmp/acgc-merged-transform-fixture-asan-ubsan-b18aa8e92 \
  --target acgc_pc_gx_transform_raw_shadow_fixture --parallel 1
ctest --test-dir \
  /private/tmp/acgc-merged-transform-fixture-asan-ubsan-b18aa8e92 \
  -N -R '^acgc_pc_gx_transform_raw_shadow_fixture$'
ctest --test-dir \
  /private/tmp/acgc-merged-transform-fixture-asan-ubsan-b18aa8e92 \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_transform_raw_shadow_fixture$'
```

Result: configure and target build passed; discovery found exactly one test;
exact CTest passed `1/1` in 0.10 seconds with no ASan/UBSan diagnostic.

The compiler emitted inherited portability warnings, including the unknown
Apple Clang spelling of `-Wno-builtin-declaration-mismatch` and a Dolphin
`INT_MIN` macro redefinition. They were warnings, not new failures.

## Proof boundary

Proved:

- the exact dependency failure at the unmodified base;
- one-file test-only CMake correction;
- clean application after PC PR #20;
- unique source/object ownership in the focused target;
- exact-merge native and ASan/UBSan configure, compile, link, discovery, and
  execution; and
- unchanged production source and `ac_pc` membership.

Not proved:

- a full `ac_pc` link at `b18aa8e92`;
- any process launch or new live Transform behavior;
- cumulative publication, Apple callback delivery, or runtime arbitration;
- Metal encode, present, readback, or pixels;
- Windows execution, input, audio, save/reload, lifecycle, iOS, or device
  behavior; or
- human playability.

The current live frontier remains Texgen, established by the earlier bounded
trace at content-identical PC PR #20 source. Repairing this fixture does not
move that runtime frontier.

## Adjacent findings

A broader read-only audit found the same cumulative dependency drift in many
other direct-`pc_gx.c` test executables and a separate missing
`pc_gx_texture_mark_image_converted` dependency in two full-`emu64.c`
portable fixtures. Those targets are not changed by PC PR #21 and must be
repaired through separately reviewed shared topology rather than stubs or
permissive linker flags.
