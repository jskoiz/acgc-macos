# PC raw Alpha and ZCompLoc provenance at `039afce0e`

## Scope and provenance

Lane 204 implemented setter-owned PC Alpha provenance on the remote M3 Max and
returned source-only Git objects for integration-owner review. No ISO,
extracted assets, keys, proprietary data, resource bytes, full link, launch,
LLDB, Metal device, or pixel work was part of the lane.

- project task: `01a004f3-1941-7731-a310-d5ad1f52011b`;
- PC integration base: `698d45d3e78f96104c2e489d78036b55ea493d37`;
- initial worker commit: `35b1e7a2dac33ef4cef09d03d4f624b4af1d6fd8`;
- reviewed worker final: `ae5102de3992fbb4d22f6745e4b4f72850f909f4`;
- worker branch: `c1/lane-raw-alpha-zcomp-m3`;
- remote source worktree: `/private/tmp/acgc-lane-raw-alpha-zcomp-m3`;
- canonical integration branch: `c1/macos-host-launch` at
  `039afce0e0773a2ad4cbb6b5d8d717c463ad8303`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- initial source-only bundle SHA-256:
  `5a4eb97470576dfe3be131a97904e693bc82c2706f01a222a59cf2320056d132`;
  and
- repair bundle SHA-256:
  `c04314f1bfb26129b6e787f8efa5fb1c88abe965fca11667c70dcd941543560a`.

The integration owner reviewed the final two-commit worker range, squashed its
accepted end state onto the newer canonical PC tip `b3336504c`, clarified that
the negative fixture exercises an out-of-range `GXCompare` through its real
`u32` API rather than manufacturing an invalid `GXBool` call, and reran the
focused native and sanitizer gates. The root clarification changes test naming
and comments only; it does not change production behavior.

## Exact source ownership

The canonical squash changes exactly four files:

- `pc/CMakeLists.txt`;
- `pc/include/pc_gx_internal.h`;
- `pc/src/pc_gx.c`; and
- `pc/tests/pc_gx_alpha_raw_shadow_fixture.c`.

It adds a pointer-free `PCGXRawAlpha` shadow containing the existing canonical
Alpha value, an exact eight-bit known mask, and sticky invalid provenance.
Host defaults do not establish canonical knownness. `GXSetAlphaCompare`,
`GXSetColorUpdate`, `GXSetAlphaUpdate`, and `GXSetZCompLoc` populate only their
owned fields, including setter calls whose values equal the existing host
state. Complete state is published only when all eight fields are known, no
invalid compare/operator value has occurred, and the existing canonical Alpha
validator accepts the candidate.

`GXSetZCompLoc` is no longer a PC no-op: it flushes a completed old vertex
batch before changing raw provenance, then stores the logical before/after-TEV
boolean. The legacy OpenGL-facing behavior is otherwise unchanged. Under
`TARGET_PC`, `GXBool` is C `bool`; the implementation therefore normalizes only
the typed boolean values the API can represent. The fixture deliberately does
not use an ABI-mismatched declaration, raw-width call, `noinline` trick, or
other undefined behavior to fabricate malformed boolean input.

The production `ac_pc` target now defines `PC_GX_ALPHA_RAW_PRODUCER` and links
`acgc_gx_canonical_alpha_state`. A narrow object-only target compiles the real
production `pc_gx.c` path so the producer cannot pass solely because the
fixture supplied different compile definitions. This lane does not yet attach
the Alpha builder to a cumulative envelope or Apple callback.

## Two-upstream crosswalk

The host reference is the existing PC implementation and declarations in
`pc/src/pc_gx.c`, `pc/include/pc_gx_internal.h`,
`include/dolphin/gx/GXTev.h`, and `include/dolphin/gx/GXPixel.h`. The portable
value contract remains `include/acgc/gx_canonical_alpha_state.h` and
`src/gx_canonical_alpha_state.c`.

The original-behavior oracle is ac-decomp:

- `src/static/dolphin/gx/GXTev.c` for `GXSetAlphaCompare`;
- `src/static/dolphin/gx/GXPixel.c` for color update, alpha update, and
  `GXSetZCompLoc`;
- `src/static/dolphin/gx/GXInit.c` for startup state;
- `src/static/libforest/emu64/emu64.c` for the live translated renderer state;
  and
- `src/static/JSystem/JFramework/JFWDisplay.cpp` and
  `src/static/Famicom/famicom.cpp` for representative state transitions.

The crosswalk preserves the logical compare/reference/operator values, typed
booleans, setter ordering, and the distinction between host convenience state
and observed game-owned provenance. Out-of-domain compare/operator values can
be represented by the PC port's `u32` setter surface and therefore mark the raw
epoch invalid. Typed `GXBool` inputs cannot carry an additional malformed
integer domain on the PC build and are not tested through undefined behavior.

## Exact integrated verification

Fresh ignored roots were configured from the canonical staged end state and
rerun after the final fixture clarification:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-raw-alpha-zcomp-native \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON

cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-raw-alpha-zcomp-asan \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

Both roots built these targets serially:

```text
acgc_pc_gx_alpha_raw_shadow_fixture
acgc_gx_canonical_alpha_state_tests
acgc_pc_gx_alpha_raw_producer_object
```

The exact focused test selection was:

```sh
ctest --test-dir <root> --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_alpha_raw_shadow_fixture|acgc_gx_canonical_alpha_state_tests)$'
```

For the sanitizer root it ran with:

```text
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
```

Results:

- native focused CTest: `2/2` passed;
- combined ASan/UBSan focused CTest: `2/2` passed;
- the production `pc_gx.c` object target compiled in both roots;
- no sanitizer diagnostics were emitted;
- leak detection was disabled, so this is not leak-free proof; and
- `git diff --check` passed.

Known output is limited to the existing Darwin compile-frontier warning and
decomp `INT_MIN` redefinition. The worker also reported passing bounded C/C++,
ILP32, and `_WIN32` syntax probes. No real Windows toolchain, PE link, or
runtime was available, so this is not Windows sign-off.

## Claim boundary and next gate

This proves setter-owned CPU Alpha/ZCompLoc provenance, all-or-nothing
conversion to the existing portable Alpha section, completed-batch
flush-before-mutation ordering, production-object availability, and native
plus combined ASan/UBSan focused behavior on the integrated source snapshot.

It does **not** prove a cumulative GX envelope, full `ac_pc` link, launch,
live callback, Apple consumer, Metal encode/present/readback, pixel, input,
audible audio, save/reload, device, iOS, or playability.

Alpha/ZCompLoc is no longer a cumulative-producer prerequisite. The remaining
dependency-ready source prerequisites recorded by lanes 206 and 207 are raw
Raster provenance, the portable and raw Indirect section, complete Geometry
serialization, and then an all-or-nothing envelope plus paired resource lease.
