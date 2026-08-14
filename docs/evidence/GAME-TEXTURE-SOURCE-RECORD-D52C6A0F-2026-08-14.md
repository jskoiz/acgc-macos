# Game texture source record — `d52c6a0f` / `80e80df`

## Gate and provenance

This lane closes the CPU-side source-availability gate identified by the
game-owned texture audit. The remote M3 Max worker started from the Apple V2
sideband content `a10fed8e01482a8097744b79e01c1e4c76feb4fe` and produced
`d52c6a0f590b610377d5773a655e376de03a7ad6`. The integration owner imported
that source-only history and cherry-picked it onto the canonical local PC
branch, producing `80e80dfebe6c78ee5ad99eb418cf79b874e70e1e`. A follow-up
test-only branch `c1/fix-v2-sideband-test` produced `7c9299755`, which was
cherry-picked onto the final canonical tip
`a96f3586587976b489cbd8045c92f7c9e6a4dc8a`. The decomp oracle was
`upstream/ac-decomp` `09ca8e8b`.

The two-upstream crosswalk was kept explicit:

- `upstream/ACGC-PC-Port/pc/src/pc_gx_texture.c` owns the host loader, cache,
  texture-pack/EFB/fallback paths, and the current TLUT table. The new record is
  populated only from validated CPU image/TLUT metadata and is cleared on cache
  invalidation, TLUT replacement, texture-object destruction, external/replaced
  GL objects, malformed/stale handles, and failed decode/upload paths.
- `upstream/ACGC-PC-Port/pc/include/pc_gx_internal.h` adds a host-pointer-safe,
  fixed-width metadata record to `PCGXState`; `pc/src/pc_gx.c` exposes a
  metadata-only V2 accessor that copies no image or TLUT bytes.
- `upstream/ac-decomp/include/dolphin/gx/GXStruct.h` keeps `GXTexObj` and
  `GXTlutObj` as fixed-width guest layouts, while
  `upstream/ac-decomp/src/static/dolphin/gx/GXTexture.c` and
  `upstream/ac-decomp/src/static/libforest/emu64/emu64.c` establish the
  guest-side object/TLUT initialization and load callers. The record therefore
  retains host pointers only at the PC adapter boundary; it does not alter the
  decomp wire layout or claim ownership of guest bytes.

## Exact source scope

The lane-132 integrated commit changes exactly five PC files:

```text
pc/CMakeLists.txt
pc/include/pc_gx_internal.h
pc/src/pc_gx.c
pc/src/pc_gx_texture.c
pc/tests/pc_gx_texture_source_record_fixture.c
```

The follow-up test-only correction changes only
`pc/tests/pc_gx_semantic_v2_handoff.c`: it initializes the new borrowed
sideband fields and expects a textured packet without a bound source to fail
closed. No production file was changed by that correction.

The record carries image/TLUT pointers and byte sizes, dimensions, format,
wrap/filter state, TLUT metadata, an explicit source-kind tag, and a monotonic
generation. It uses host pointers rather than packed guest or GL handles. The
fixture checks aligned raw metadata, indexed/TLUT validation, malformed-size
and unaligned rejection, TLUT invalidation, and generation advancement. It
does not dereference or copy proprietary image/TLUT bytes.

## Verification

All commands ran from the integrated local snapshot and used unique ignored
roots; full `ac_pc` linking and LLDB were not run in this lane.

Native:

```text
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrated-v2-source-a96f358-native \
  -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON
cmake --build /private/tmp/acgc-integrated-v2-source-a96f358-native \
  --target acgc_pc_gx_texture_source_record_fixture acgc_pc_gx_semantic_v2_handoff_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrated-v2-source-a96f358-native \
  --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_texture_source_record_fixture|acgc_pc_gx_semantic_v2_handoff_tests)$'
```

Result: build succeeded and `2/2` focused tests passed. The expected legacy
header warnings (`INT_MIN`, old GX prototypes, and one unknown warning option)
were non-fatal.

Combined ASan/UBSan:

```text
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrated-v2-source-a96f358-asan \
  -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined' \
  -DCMAKE_CXX_FLAGS='-fsanitize=address,undefined' \
  -DCMAKE_OBJC_FLAGS='-fsanitize=address,undefined' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-integrated-v2-source-a96f358-asan \
  --target acgc_pc_gx_texture_source_record_fixture acgc_pc_gx_semantic_v2_handoff_tests --parallel 1
ASAN_OPTIONS='detect_leaks=0:halt_on_error=1:abort_on_error=1' \
UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1' \
ctest --test-dir /private/tmp/acgc-integrated-v2-source-a96f358-asan \
  --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_texture_source_record_fixture|acgc_pc_gx_semantic_v2_handoff_tests)$'
```

Result: build succeeded and `2/2` focused tests passed with no sanitizer
diagnostics. Leak detection was disabled as required for this repository's
Darwin sanitizer fixtures; this is not a leak-free claim.

The exact pre-sideband parent `08c27de5` passed the original V2 handoff test.
The Apple sideband intentionally changed textured packets to require an
explicit source, so the old test's uninitialized sideband fields made the
`3c08c7f71` and `80e80df` snapshots nondeterministic/incorrect. The isolated
`7c9299755` test-only correction makes that contract explicit; the final
`a96f358` snapshot is green in both matrices.

## Boundary and next gate

This proves a CPU/contract record and fail-closed invalidation matrix only. It
does not prove that a live game callback supplies a record, that the Apple
consumer binds it, that Metal encodes or presents it, that a pixel can be read
back, or that the game is playable. Input, audible audio, save/device
persistence, simulator, and physical-device gates are unchanged.

The next bounded gate is an Apple-side CPU binder that consumes
`pc_gx_get_v2_texture_source()` synchronously at the existing V2 sideband seam,
with explicit generation/lifetime checks and focused native plus ASan/UBSan
fixtures. A separately authorized serialized current-tip link/LLDB trace must
follow that review; no device or pixel claim is implied.
