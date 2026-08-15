# PC raw TEV and Indirect provenance at `62c810e5b`

## Scope and provenance

Lane 234 implemented setter-owned, pointer-free raw TEV and Indirect state on
the remote M3 Max. Lane 235 independently reviewed the initial candidate,
blocked invalid current-call writes into legacy mirrors, reviewed the
production repair, blocked one stale legacy-fixture expectation, and finally
returned `PASS — no material candidate-owned blocker` on the complete repaired
chain.

- source task: `01a00640-960d-7d41-9320-721f26037d8a`;
- independent review task: `01a00669-46ec-7c50-959c-50dafe702923`;
- PC integration base: `c832fb862e934806888488e0dbc288aefeae5a10`;
- worker commits: `34da318d470db797ca96319361a1b0e7e6497d8a`,
  `638f91fa2c9f9afdc6b64ac901439e2db056a835`, and
  `62a9f5b23d8691658855f9262b2a401e9356ab74`;
- preserved worker branch: `c1/lane-raw-tev-m3` at `62a9f5b23`;
- canonical commits: `e036cc947`, `6e797744a`, and `62c810e5b` on
  `c1/macos-host-launch`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- final source-only bundle SHA-256:
  `dd6b9b22d994acce275fe13c16569552ca042b9079c7e38636bfd970a04a29d5`.

The final bundle was copied as tracked Git objects only. Its hash, branch ref,
complete history, parent chain, base ancestry, and clean status were verified
both remotely and locally. No ISO, extracted assets, keys, or proprietary game
data were transferred.

## Exact source ownership

The reviewed integration changes exactly five files:

- `pc/CMakeLists.txt`;
- `pc/include/pc_gx_internal.h`;
- `pc/src/pc_gx.c`;
- `pc/tests/pc_gx_tev_indirect_raw_shadow_fixture.c`; and
- `pc/tests/pc_gx_tev_raw_shadow_fixture.c`.

The new raw owner captures active TEV count, all 16 logical TEV stages, swap
tables, PREV/REG/KONST state, per-stage indirect tuples, four Indirect
orders/scales, and three copied Indirect matrices. Per-field knownness remains
distinct from zero values, invalid provenance is sticky, and a candidate is
not publishable until its required observed state is complete and valid.

Every owned public setter flushes a completed draw before raw or legacy host
mutation. Validation reports validity for the current call separately from the
sticky invalid epoch: malformed current input records attempted provenance in
the new raw owner, then returns before legacy dirty state or mirrors change;
later valid calls retain the existing PC-host behavior even after the raw epoch
is sticky-invalid.

`GXSetTevOp` records the decomp expansion, including stage-zero and later-stage
CPREV/APREV behavior and `GX_BLEND` ordering, while preserving the legacy PC
host expansion. `GXSetIndTexMtx` copies all six coefficients, retains no input
pointer, preserves selector families, applies the decomp quantization
`(int)(1024.0f * value) & 0x7ff`, and preserves the encoded scale
`(scale + 0x11) & 0x3f`.

## Two-upstream crosswalk

The host reference is the existing PC implementation in
`pc/include/pc_gx_internal.h`, the TEV/Indirect setter regions of
`pc/src/pc_gx.c`, and the pre-existing raw TEV shadow fixture. The new fixture
exercises invalid IDs and domains, legacy-mirror immutability, copied matrix
lifetime and quantization, knownness, sticky invalidity, later-valid legacy
behavior, and flush-before-mutation.

The original-behavior oracle is ac-decomp:

- `src/static/dolphin/gx/GXTev.c` and `include/dolphin/gx/GXTev.h`;
- `src/static/dolphin/gx/GXBump.c` and `include/dolphin/gx/GXBump.h`; and
- `src/static/dolphin/gx/GXInit.c` for setter-established initialization.

The reviewed implementation does not manufacture known defaults from zeroed
host storage and does not reconstruct Indirect matrix provenance from legacy
floating-point mirrors.

## Exact integrated verification

Fresh ignored roots were configured from canonical PC `62c810e5b`:

```sh
cmake -S pc \
  -B /private/tmp/acgc-integrate-raw-tev-indirect-62c810e-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++

cmake --build /private/tmp/acgc-integrate-raw-tev-indirect-62c810e-native \
  --target acgc_pc_gx_tev_raw_shadow_fixture \
           acgc_pc_gx_tev_indirect_raw_shadow_fixture --parallel 1

ctest --test-dir /private/tmp/acgc-integrate-raw-tev-indirect-62c810e-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_tev_(raw_shadow_fixture|indirect_raw_shadow_fixture)$'
```

The sanitizer root used the same configure/build/test selection plus:

```text
CMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer
CMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer
CMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
```

Results:

- native focused CTest: `2/2` passed;
- combined ASan/UBSan focused CTest: `2/2` passed;
- `pc/src/pc_gx.c` compiled through the legacy fixture target without the new
  fixture macro in both roots;
- no sanitizer diagnostics were emitted;
- leak detection was disabled, so this is not leak-free proof; and
- `git diff --check` passed for every imported commit and the complete range.

Known output is limited to the existing Darwin compile-frontier warning, decomp
`INT_MIN` redefinition, and unsupported
`-Wno-builtin-declaration-mismatch`. Real i686/MinGW compilers and sysroots were
unavailable, so this is not Windows sign-off.

## Claim boundary and next gate

This proves setter-owned PC CPU raw TEV/Indirect provenance, fail-closed
current-call behavior, preserved legacy valid-call behavior, and focused native
plus combined ASan/UBSan evidence on the exact integrated snapshot.

It does **not** prove a canonical TEV leaf, canonical Indirect leaf, cumulative
GX snapshot, full `ac_pc` link, launch, live callback, Apple consumer, Metal
encode/present/readback, pixel, input, audible audio, save/reload, device, iOS,
Windows runtime, or playability.

The next dependency-ready source gates are separate canonical TEV and canonical
Indirect leaf producers. They must use disjoint new files or serialized build
registration, preserve the reviewed raw owner unchanged, and receive independent
review before any cumulative assembler or runtime gate.
