# V2 base-state rejection classifier — PC 59d13a98

## Scope and provenance

This is a CPU/source diagnostic gate. It adds a bounded reason classifier that
mirrors, but does not replace or relax, the existing V2 acceptance predicate.
It does not prove that a live packet reaches the Apple consumer or Metal.

- Worker host: remote M3 Max (`macbook`)
- Worker branch: `c1/lane-v2-base-rejection-reason-m3`
- Worker base/final: `c973dbee8b4461e23aa5e63eeb3178fb256cf6e8` ->
  `6d5b3c89347e58805f15be968998eb50c9138b67`
- Integrated PC branch/final: `c1/macos-host-launch` at
  `59d13a98e06c4a67c67b5936f5257a6ff82c0d7a`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Source-only bundle SHA-256:
  `3e551a754391c079263269953b625676b1053ab32d2d4cd607dc5da396ccfe86`

No ISO, extracted assets, keys, or proprietary data went to the remote host or
entered Git.

## Source change

The worker commit changes exactly:

- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_v2_rejection_reason_fixture.c`
- `pc/CMakeLists.txt`

The classifier preserves the original `pc_gx_semantic_v2_state_is_supported()`
body as the acceptance authority. Its ordered diagnostic reasons are:

```text
vertex_or_count
global_count
alpha_test
blend
depth
color_alpha_update
cull
matrix_projection
channel
stage_or_texture
texgen
supported
```

Both direct and grouped V2 paths use the existing opt-in
`ACGC_METAL_REJECTION_TRACE` switch. Output is capped at 64 records and contains
bounded numeric state only, with no host addresses. The grouped path now records
the whole-list expected count while classifying each exact-three slice.

The fixture independently compares the new classifier with the unchanged
predicate and packet-builder outcome. It covers every reason group, precedence
when several later failures are also armed, malformed vertex/count inputs, and
the supported state.

## Two-upstream crosswalk

The PC state is captured by setters in `pc/src/pc_gx.c`: alpha compare, blend,
depth/write masks, cull, projection/matrices, channel controls, TEV/stage and
texture state, and texgen state. Matching original producers are in:

- `upstream/ac-decomp/src/static/dolphin/gx/GXPixel.c`
- `upstream/ac-decomp/src/static/dolphin/gx/GXGeometry.c`
- `upstream/ac-decomp/src/static/dolphin/gx/GXTransform.c`
- `upstream/ac-decomp/src/static/dolphin/gx/GXLight.c`
- `upstream/ac-decomp/src/static/dolphin/gx/GXTev.c`
- `upstream/ac-decomp/src/static/dolphin/gx/GXTexture.c`
- `upstream/ac-decomp/src/static/dolphin/gx/GXAttr.c`
- `upstream/ac-decomp/src/static/libforest/emu64/emu64.c`

There is no decomp counterpart for the semantic packet, its PC predicate and
builders, grouped handoff, or Apple consumer APIs. The decomp terminates at GX
state and FIFO/register production.

The source-alpha tuple observed in the existing PC/decomp path classifies as
`blend` because V2 still requires `GX_BM_NONE`, `GX_BL_ONE`, `GX_BL_ZERO`, and
`GX_LO_CLEAR`. This is a source/fixture classification, not a fresh current-tip
runtime observation. One separately serialized runtime trace is required to
confirm the first live reason and exact state tuple.

## Verification

Remote native and combined ASan/UBSan focused CTest passed `2/2` each. The
integration owner repeated the same two targets on exact integrated PC
`59d13a98`:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-v2-rejection-59d13a98-native \
  -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-v2-rejection-59d13a98-native \
  --target acgc_pc_gx_semantic_v2_rejection_reason_tests \
           acgc_pc_gx_semantic_v2_batch_handoff_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-v2-rejection-59d13a98-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_semantic_v2_(rejection_reason|batch_handoff)_tests$'
```

Result: `2/2` passed. The equivalent combined ASan/UBSan root
`/private/tmp/acgc-integrate-v2-rejection-59d13a98-asan` also passed `2/2` with
no sanitizer diagnostics. `ASAN_OPTIONS=detect_leaks=0` was used, so no
leak-free claim is made. Only known project/toolchain warnings appeared.
`git diff --check` passed.

## Claim boundary and next gate

Proved: the reason classifier preserves the original fail-closed predicate,
the direct and grouped traces can name the first bounded reason, and focused
native/sanitized behavior remains green.

Not proved: live `reason=blend`, a successful V2 packet, callback, Apple
preparation, provider use, Metal encode/present/readback, a pixel, device
behavior, or playability.

Next: one serialized current-tip `59d13a98` link and bounded GUI/LLDB launch
with `ACGC_METAL_REJECTION_TRACE=1`, recording the first live grouped reason
and tuple before any packet or consumer contract is broadened.
