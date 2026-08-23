# emu64 projection reconstruction — PC `ff09b1f22`

## Outcome

PC [PR #24](https://github.com/jskoiz/ACGC-PC-Port/pull/24),
`Fix emu64 projection reconstruction`, merged into
`c1/macos-host-launch` as
`ff09b1f226978237699f4a3c99678e750fd3625e`.

- PC base: `de9a26fee8a89a55903b8f9dd0a0896daf41c0e3`
- Reviewed source commit:
  `1c1d2d171f9f334b6f10490c1afb43f073818a21`
- PC merge: `ff09b1f226978237699f4a3c99678e750fd3625e`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PR state: merged 2026-08-23 at 21:27:40 UTC; one source commit;
  status-check rollup and hosted reviews were empty.

The exact first-parent merge diff is four paths, 296 insertions and four
deletions:

- `pc/portable/CMakeLists.txt`
- `pc/portable/tests/emu64_projection_texture_boundary_stub.c`
- `pc/portable/tests/test_emu64_projection.cpp`
- `src/static/libforest/emu64/emu64.c`

`git diff --check` passed. The merge parents are exactly the PC base and the
reviewed source commit. The Apple Geometry paths, cumulative gatherer, TEV
producer, top-level PC CMake graph, decomp history, umbrella files, and
proprietary assets did not change in the PC PR.

The PC merge tip contains no `.github/workflows` entry. No workflow or manual
rerun was triggered for this integration. The repository returned no hosted
review or status-check result for PR #24. The proof below is local, focused,
and tied to the exact merge object.

## Corrected projection contract

The fixed-width 64-byte N64 `Mtx_t` layout was already integrated before this
PR. The remaining `emu64::dl_G_MTX` perspective reconstruction still derived
the far plane with an extra `+1`, which algebraically produced `far + near`
instead of `far`. The merged implementation:

- removes the erroneous term from finite perspective reconstruction;
- computes near, far, and GX depth coefficients in local temporaries;
- rejects non-finite or equal near/far results before mutating runtime state;
- rejects the fixed-point infinite-far limit rather than publishing NaN or
  infinity into the current finite GX/Fog state contract; and
- leaves the existing orthographic branch and legacy renderer flow intact.

The focused fixture compiles the production `emu64.c` path into its test
translation unit, links the real `mtxutil.c` fixed-point conversion, and uses a
small instrumented texture-boundary source only to prove that projection
dispatch does not cross into texture conversion. It covers:

- real 16.16 fixed-point conversion and transposed Dolphin matrix view;
- finite perspective reconstruction with finite near/far and GX coefficients;
- orthographic classification with finite state;
- infinite-far rejection with prior projection, position, dirty flags, and
  near/far preserved; and
- zero calls to `pc_gx_texture_mark_image_converted`.

The target uses strict undefined-symbol closure. The Apple linker emits its
existing deprecation warning for `-undefined error`; the focused executable
still links and runs successfully. That warning is not a hosted or production
link result.

## Two-upstream crosswalk

The host implementation and regression oracle is the exact PC merge above:

- `src/static/libforest/emu64/emu64.c` owns `emu64::dl_G_MTX`, N64 projection
  classification, finite near/far reconstruction, and fail-closed state
  publication;
- `pc/portable/tests/test_emu64_projection.cpp` drives the real production path
  through fixed-point matrices and checks state immutability;
- `pc/portable/tests/emu64_projection_texture_boundary_stub.c` instruments the
  unrelated texture boundary without substituting projection behavior; and
- `pc/portable/CMakeLists.txt` owns the Apple-only focused test target.

The original-behavior and wire-layout oracle remains decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`:

- `src/static/libultra/gu/perspective.c` defines the N64 perspective matrix
  coefficients used to verify the inverse algebra;
- `src/static/libultra/gu/mtxutil.c` defines the fixed-point matrix conversion;
- `src/static/libforest/emu64/emu64.c` identifies the original projection
  dispatch and matrix-classification behavior; and
- the Dolphin GX projection path provides the finite host coefficient target.

The focused host CMake target, texture-call counter, sanitizer gate, and
fail-closed host policy for an infinite-far fixed-point limit have no direct
decomp counterpart.

## Independent exact-merge review

Lane 365 inspected the detached, clean merge worktree, exact merge object,
four-path first-parent diff, decomp crosswalk, live PC branch and PR #24 state,
repository workflow exposure, and both retained focused roots without editing
or rerunning tests. It returned PASS with no P0/P1 finding and authorized a
separately reviewed umbrella integration.

The reviewer recorded native executable SHA-256
`b38ad7619294e86effcfaa704383c01bb85872d3bd604a27c3be82aecd016da8`
and sanitizer executable SHA-256
`3aa481f36ff5b68b4274156420fe619f4a7e6628fecfca1a143ef614aef9462a`.
Its bounded P2 note is retained: the fixture does not prove malformed
orthographic input, `G_MTX_MUL`, a full production link, process runtime, or
any renderer/device result.

## Exact-merge focused verification

Detached, clean source worktree:

`/private/tmp/acgc-integrator-projection-merged.LJVJUS`

at exact merge `ff09b1f226978237699f4a3c99678e750fd3625e`.

Fresh native root:

`/private/tmp/acgc-projection-merged-native.FF09B1F`

```sh
cmake -S /private/tmp/acgc-integrator-projection-merged.LJVJUS/pc/portable \
  -B /private/tmp/acgc-projection-merged-native.FF09B1F \
  -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-projection-merged-native.FF09B1F \
  --target acgc_emu64_projection_tests --parallel 1
ctest --test-dir /private/tmp/acgc-projection-merged-native.FF09B1F \
  -N -R '^acgc_emu64_projection_tests$'
ctest --test-dir /private/tmp/acgc-projection-merged-native.FF09B1F \
  --output-on-failure --parallel 1 \
  -R '^acgc_emu64_projection_tests$'
```

Result: configure/generate passed; the standalone portable project reported
`PC_DARWIN_COMPILE_AUDIT` as unused; the serialized target build completed 15
steps; discovery found exactly one test; it passed `1/1` in 0.00 seconds.

Fresh combined ASan/UBSan root:

`/private/tmp/acgc-projection-merged-asan-ubsan.FF09B1F`

```sh
cmake -S /private/tmp/acgc-integrator-projection-merged.LJVJUS/pc/portable \
  -B /private/tmp/acgc-projection-merged-asan-ubsan.FF09B1F \
  -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-projection-merged-asan-ubsan.FF09B1F \
  --target acgc_emu64_projection_tests --parallel 1
ctest --test-dir /private/tmp/acgc-projection-merged-asan-ubsan.FF09B1F \
  -N -R '^acgc_emu64_projection_tests$'
ctest --test-dir /private/tmp/acgc-projection-merged-asan-ubsan.FF09B1F \
  --output-on-failure --parallel 1 \
  -R '^acgc_emu64_projection_tests$'
```

Result: configure/generate passed; the serialized target build completed 15
steps; discovery found exactly one test; it passed `1/1` in 0.14 seconds. The
retained log contains no AddressSanitizer, UndefinedBehaviorSanitizer,
LeakSanitizer, runtime-error, or failed-test diagnostic.

## Proof boundary and next gate

Proved:

- exact PR #24 integration and four-path scope;
- correct finite perspective reconstruction and orthographic classification;
- fail-closed infinite-far behavior with destination/state immutability;
- real fixed-point conversion and zero texture-boundary calls; and
- exact-merge native and combined ASan/UBSan configure, compile, link,
  discovery, and execution of the focused CPU test.

Not proved:

- a full `ac_pc` link or process launch at `ff09b1f22`;
- a post-merge real-process projection trace;
- TEV repair, cumulative-envelope publication, or Apple callback delivery;
- Metal encode, present, readback, pixels, or device behavior;
- input, audible audio, save/reload, lifecycle, Windows execution, iOS, or
  playability.

The live cumulative frontier remains the TEV failure observed in the earlier
exact-`7636cc1d8` bounded process trace. The next critical-path source gate is
one source-faithful TEV correction owned by one production lane. After its PC
merge and exact-merge focused verification, one new serialized full link and
bounded trace must determine the next first-failing producer or the first
published cumulative envelope.
