# Raw Geometry closure at `b9a9f355`

Date: 2026-08-15  
Evidence class: reviewed CPU/source implementation and focused native plus
combined ASan/UBSan execution

## Provenance

- Canonical PC base: `85b25cb3c63a68c2903155ccfd2dec05a1cb70fb`
- Blocked worker parent: `1730823d4586375991b4be5e32ebc583809ac763`
- Repaired worker child: `5679bff6562031c620aa1206e27baf7a9da7146f`
- Canonical end-state squash: `b9a9f355` on `c1/macos-host-launch`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Preserved worker branch: `c1/lane-raw-geometry-closure-m3`
- Source-only repair bundle:
  `/private/tmp/acgc-lane-211-raw-geometry-repair.bundle`
- Bundle SHA-256:
  `344e76694b94c25f9e29eb9de99f9d136dbb842c72fcafc4760fa8615adb67fc`

The first worker parent was not integrated. Lane 214 independently blocked it
because raw-valid indexed non-F32 POS/NRM/TEX0 values did not reach the legacy
host mirror and because packed-color FIFO width plus RGBX8 ignored-byte
semantics were lost. Lane 211 added one child without rewriting the parent.
Lane 215 then reviewed the exact parent-to-child range and returned `PASS`.
The integration owner applied the reviewed cumulative end state as one squash
commit so the canonical branch never records the blocked intermediate state.

## Exact source scope

The final canonical commit changes exactly:

- `pc/CMakeLists.txt`
- `pc/include/pc_gx_internal.h`
- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_geometry_raw_batch_fixture.c`

The repair child itself changes only `pc/src/pc_gx.c` and the focused fixture.
It adds:

- one overflow-safe array reader shared by raw capture and host scalar decode;
- indexed POS/TEX0 U8/S8/U16/S16 scaling as `q * 2^-fraction`;
- finite F32 decoding and signed S8/S16 normal normalization by 127/32767;
- explicit invalid-index behavior: position takes the existing deferred zero
  fallback while NRM/TEX0/CLR0 leave legacy host state unchanged;
- exact 2/3/4-byte packed-color entry provenance;
- RGBX8 ignored-byte acceptance and raw normalization without changing the
  subsequent legacy host color update; and
- positive and fail-closed fixture coverage for the supported scalar, color,
  interval, generation, mutation, lifetime, and ordering boundaries.

## Two-upstream crosswalk

The PC owner is `pc/src/pc_gx.c`, including
`pc_gx_raw_geometry_read_array_words()`,
`pc_gx_raw_geometry_set_indexed()`, the typed host scalar decoder, the direct
color width validator, and the typed/indexed GX entry points.

The independent review read the clean canonical decomp tree directly:

- `GXAttr.c`: `GXSetVtxDesc`, `GXSetVtxAttrFmt`, and `GXSetArray` define VCD,
  VAT count/type/fraction, array selection, and NRM/NBT exclusivity. The PC
  byte-size and generation checks are host-specific because decomp's
  `GXSetArray` has no size argument.
- `GXGeometry.c`: `GXBegin` supplies primitive/format/count ordering and the
  dirty VCD/VAT flush boundary. The PC copied raw shadow has no decomp
  counterpart.
- `GXVert.c`: typed and indexed position, normal, color, and texcoord FIFO
  macros establish the exact index8/index16 and 2/3/4-byte entry widths.
- `GXTransform.c`: matrix loads and `GXSetCurrentMtx` remain separate state;
  matrix/NBT payloads therefore remain fail-closed in this bounded producer.

## Independent review

Lane 215 verified the bundle hash and Git bundle, clean detached child
checkout, exact ancestry, two changed child files, cumulative four-file scope,
and `git diff --check`. It found no material candidate-owned UB, alignment,
endianness, overflow, stale-state, ordering, or fixture-scope defect. It also
verified decomp `09ca8e8b` was clean and did not use the stale task worktree's
uninitialized submodule.

## Exact integrated verification

Native configuration:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-raw-geometry-b9a-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++
cmake --build /private/tmp/acgc-integrate-raw-geometry-b9a-native \
  --parallel 1 \
  --target acgc_pc_gx_geometry_raw_batch_fixture \
           acgc_pc_gx_geometry_raw_producer_object
ctest --test-dir /private/tmp/acgc-integrate-raw-geometry-b9a-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_geometry_raw_batch_fixture$'
```

Result: both targets built; focused CTest passed `1/1`.

Combined ASan/UBSan used the same configuration plus:

```sh
-DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer'
-DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer'
-DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
```

The build root was
`/private/tmp/acgc-integrate-raw-geometry-b9a-asan`; both focused targets built.
The test command was:

```sh
env ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
    UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
  ctest --test-dir /private/tmp/acgc-integrate-raw-geometry-b9a-asan \
    --output-on-failure --parallel 1 \
    -R '^acgc_pc_gx_geometry_raw_batch_fixture$'
```

Result: `1/1` passed with no sanitizer diagnostic. Leak detection was disabled,
so this is not leak-free evidence. Configuration emitted the documented Darwin
compile-frontier warning and builds emitted existing SDK/decomp-header warnings.

## Claim boundary and next gate

This closes the bounded setter-owned raw Geometry CPU/source contract for
POS/NRM/CLR0/TEX0. It does not add a canonical Geometry converter, cumulative
envelope producer, live callback, full `ac_pc` link, LLDB launch, Windows
runtime, Metal encode/present/readback, pixel, device, or playability proof.

The next dependency-ready source lane is a separately owned canonical Geometry
producer/converter using new PC converter files and a focused fixture. It must
consume the copied raw batch, preserve unsupported matrix/NBT and extra
color/texture slots as fail-closed, and must not overlap the released
`pc_gx.c` owner.
