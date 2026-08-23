# LP64 N64 Mtx integration evidence — PC `2f944f1ae`

## Outcome

PC [PR #20](https://github.com/jskoiz/ACGC-PC-Port/pull/20),
`Fix LP64 N64 matrix payload layout`, merged into
`c1/macos-host-launch` as
`2f944f1aedacba2df0f0d5c15d5fadc67f8e8c54`.

- PC base: `928594a2649e7934cee43eaaffec7f82481e969f`
- Source commit: `5a8a686a5b530875dce3849b690821bf2bd3674e`
- PC merge: `2f944f1aedacba2df0f0d5c15d5fadc67f8e8c54`
- Original-behavior/wire oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Hosted checks: none configured at the PC tip

An independent immutable review accepted the source commit with no P0, P1, or
P2 finding. Fresh native and ASan/UBSan verification also passed on the exact
merge commit before this umbrella pointer update.

## Immutable scope

The PC base-to-merge diff is exactly two files, 32 insertions, and 2 deletions:

- `include/PR/gbi.h`
- `pc/portable/tests/test_gbi_runtime.c`

The change:

1. defines `Mtx_t` as `s32[4][4]` instead of host-sized
   `long[4][4]`;
2. asserts the 64-byte `Mtx_t` and `Mtx` wire sizes under `TARGET_PC`;
3. makes the focused fixture expect the N64 `G_MTX` DMA length field of
   seven; and
4. adds size, element-width, fractional-half offset, word-seven offset, and
   projection-marker regression checks.

`git diff --check` passed. No CMake, production GX source, Apple/Metal source,
umbrella history, decomp history, or proprietary asset changed in PC PR #20.

## Contract and two-upstream crosswalk

The N64 matrix payload is sixteen 32-bit packed words: eight integer-half words
followed by eight fractional-half words, for 64 bytes total. On LP64 macOS,
`long[4][4]` incorrectly made the public host payload 128 bytes and moved
`(*mtx)[1][3]` from byte offset 28 to byte offset 56. That displaced the
perspective-versus-orthographic marker consumed by the host display-list path.

PC references:

- `include/PR/gbi.h`: `Mtx_t`, `Mtx`, `gsSPMatrix`, and
  `G_MTX` payload sizing.
- `pc/src/pc_mtx.c`: `guMtxF2L` writes the integer half at offset zero and
  the fractional half at offset 32.
- `src/static/libforest/emu64/emu64.c`: `emu64::dl_G_MTX` reads the packed
  marker through `(*mtx)[1][3]`.
- `pc/portable/tests/test_gbi_runtime.c`: source-backed host layout and
  command regression.

Decomp/original references at `09ca8e8b5`:

- `include/PR/gbi.h`: the original `Mtx_t` and `Mtx` declarations, where
  the target ABI gives `long` its 32-bit N64 width.
- `src/static/libultra/gu/mtxutil.c`: integer/fraction packing.
- `src/static/libforest/emu64/emu64_utility.c`: packed-matrix conversion.
- `src/static/libforest/emu64/emu64.c`: the same word-seven projection-marker
  access under the original 32-bit ABI.

The fixed-width host representation preserves the original wire contract. The
host canonical gatherer, Apple envelope/plan path, CMake topology, and runtime
trace machinery have no decomp counterpart.

## Verification before merge

Candidate worktree:
`/private/tmp/acgc-lp64-mtx-layout.s1a9Cp`.

Focused portable gates:

```sh
cmake --build /private/tmp/acgc-lp64-mtx-native.OVeZ8d \
  --target acgc_gbi_runtime_tests --parallel 1
ctest --test-dir /private/tmp/acgc-lp64-mtx-native.OVeZ8d \
  --output-on-failure --parallel 1 -R '^acgc_gbi_runtime_tests$'

cmake --build /private/tmp/acgc-lp64-mtx-asan-ubsan.ddYNHw \
  --target acgc_gbi_runtime_tests --parallel 1
ctest --test-dir /private/tmp/acgc-lp64-mtx-asan-ubsan.ddYNHw \
  --output-on-failure --parallel 1 -R '^acgc_gbi_runtime_tests$'
```

Result: native and combined ASan/UBSan each passed `1/1`; no sanitizer
diagnostic was reported.

Affected PC focused gates:

```sh
ctest --test-dir /private/tmp/acgc-lp64-mtx-pc-native.6uEkOR \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_(transform_producer|cumulative_gatherer|cumulative_gatherer_flush)_fixture$'

ctest --test-dir /private/tmp/acgc-lp64-mtx-pc-asan-ubsan.g0ahOv \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_(transform_producer|cumulative_gatherer|cumulative_gatherer_flush)_fixture$'
```

Result: native and combined ASan/UBSan each passed `3/3`.

A final full `ac_pc` rebuild from the source commit rebuilt 3,394 affected
steps and linked `bin/AnimalCrossing`. The linker emitted only the inherited
common-section alignment-reduction warning. This is a full-link result for the
source commit whose tree is identical to the merge, not a separately repeated
full link from the merge worktree.

## Exact merged-tip verification

Detached source:
`/private/tmp/acgc-integrator-mtx-2f944f1aed`, clean at exact merge
`2f944f1aedacba2df0f0d5c15d5fadc67f8e8c54`.

Fresh native:

```sh
cmake -S /private/tmp/acgc-integrator-mtx-2f944f1aed/pc/portable \
  -B /private/tmp/acgc-integrated-mtx-native-2f944f1ae \
  -G Ninja -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrated-mtx-native-2f944f1ae \
  --target acgc_gbi_runtime_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrated-mtx-native-2f944f1ae \
  --output-on-failure --parallel 1 -R '^acgc_gbi_runtime_tests$'
```

Result: configure passed, target build passed, exact CTest passed `1/1`.

Fresh combined ASan/UBSan:

```sh
cmake -S /private/tmp/acgc-integrator-mtx-2f944f1aed/pc/portable \
  -B /private/tmp/acgc-integrated-mtx-asan-ubsan-2f944f1ae \
  -G Ninja -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-integrated-mtx-asan-ubsan-2f944f1ae \
  --target acgc_gbi_runtime_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrated-mtx-asan-ubsan-2f944f1ae \
  --output-on-failure --parallel 1 -R '^acgc_gbi_runtime_tests$'
```

Result: configure passed, target build passed, exact CTest passed `1/1` in
0.08 seconds with no ASan/UBSan diagnostic.

## Bounded live trace

The content-identical source commit was built as an arm64 Mach-O and launched
under LLDB with host-side trace configuration. The ignored local ISO was
identified by the already-recorded SHA-256 and linked only inside the ignored
build root; no disc byte entered Git.

- Inferior PID: `37956`
- Stop: exact attempt limit `20`
- Transform producer: success `20/20`
- Channels producer: success `20/20`
- Texgen producer: failure `20/20`
- Attempt result: `NO_PUBLICATION` `20/20`
- Later encoders/Geometry dependencies/assembler/canonical sink: not reached
- Sink submission/readback counts: zero
- Cleanup: scripted `process kill`; no AnimalCrossing, LLDB, or debugserver
  process remained

The trace log is
`/private/tmp/acgc-live-lp64-mtx.i2xAzb/events.log`. It contains noisy
`unknown_stage` return-breakpoint records caused by shared return addresses;
only named stage entry/return pairs and the terminal summaries are used as
evidence.

This runtime gate proves that the LP64 repair moves the first failing cumulative
producer from Transform to Texgen. It does not prove a successful cumulative
envelope, callback publication, Apple plan, Metal submission, rendered frame,
or playability.

## Adjacent topology findings

Two pre-existing focused-target topology drifts were observed outside PR #20:

- `acgc_pc_gx_transform_raw_shadow_fixture` lacked current cumulative
  gatherer/notification dependencies; a separate worker owns its CMake-only
  correction.
- `acgc_emu64_gbi_traversal_tests` currently fails to link because
  `pc_gx_texture_mark_image_converted` is omitted from that test target.

Neither undefined symbol is caused by the two-file Mtx change. They remain
separate CMake gates and are not hidden by stubs or linker flags.

## Evidence boundary and next blocker

Proved:

- fixed-width 64-byte N64 matrix layout on PC hosts;
- correct word-seven marker offset and `G_MTX` length field;
- exact source and exact-merge native plus ASan/UBSan focused execution;
- a full source-tree `ac_pc` rebuild/link on the content-identical source
  commit;
- a bounded real inferior reaching Transform and Channels successfully; and
- Texgen as the next fail-closed cumulative producer.

Not proved:

- real Windows/LLP64 execution;
- exact-merge full `ac_pc` relink;
- successful Texgen production or cumulative assembly;
- callback publication or Apple plan delivery;
- Metal encode/present/readback or an identifiable game-owned pixel;
- physical input, audible audio, live save/reload, normal end-to-end shutdown;
- iOS simulator/device behavior; or
- human playability.

The next production blocker is the live Texgen producer failure. Projection
algebra and focused CMake topology are independent successors and must remain
separate from that runtime gate.
