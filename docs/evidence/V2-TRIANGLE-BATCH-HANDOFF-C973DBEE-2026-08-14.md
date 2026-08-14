# V2 triangle-list batch handoff — integrated c973dbee

## Scope

This record covers the focused source/test lane that converts one eligible
grouped `GX_TRIANGLES` run into ordered, exact-three V2 callback packets without
broadening the existing Apple consumer. It is CPU/contract evidence only: no
full link, game launch, live callback, Metal work, pixel, device behavior, or
playability is claimed.

- PC base: `565f877e175ee8d3deae174ba5b0f8edb85ce0b0`
- Remote worker commits: `c7495259354bd97a957c2217ecfefb358926963e`
  and review follow-up `c1dbf9fea8deda13a45ab7dcf4c103f54e55d0da`
- Integrated PC commits: `90cb22154` and final `c973dbee8b4461e23aa5e63eeb3178fb256cf6e8`
- Decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Worker task: `01a001ea-3ea3-7c01-903e-b3c10236b73e`
- Worker branch/worktree: `c1/lane-v2-triangle-batch-m3` at
  `/private/tmp/acgc-lane-v2-triangle-batch-m3` on the remote M3 Max

No ISO, extracted asset, key, or proprietary game data was transferred or
accessed by this source-only lane.

## Two-upstream crosswalk

The PC ownership is the optional observer boundary in
`pc/src/pc_gx.c`: `pc_gx_flush_vertices`, the direct exact-three
`pc_gx_try_handoff_semantic_packet_v2`, and its internal V2 builder. The packet
contract in `include/acgc/gx_semantic_packet.h` and
`src/gx_semantic_packet.c` already bounds decoded geometry to 128 vertices and
validates triangle-list multiples, while
`pc/apple/src/metal_packet_consumer.c` and the renderer-neutral geometry keep
the actual Apple consumer at one three-vertex draw.

The decomp reference defines `GX_TRIANGLES` and `GX_QUADS` separately in
`include/dolphin/gx/GXEnum.h`; `src/static/dolphin/gx/GXGeometry.c` carries the
declared `GXBegin` vertex count, and the concrete emu64 callers in
`src/static/libforest/emu64/emu64.c` emit grouped triangle lists (including
two-triangle and `n_faces * 3` runs) separately from grouped quads.

## Owned implementation

The lane changed exactly:

1. `pc/src/pc_gx.c`
2. `pc/tests/pc_gx_semantic_v2_batch_handoff.c`
3. `pc/CMakeLists.txt`

The direct V2 handoff remains exact-three. At flush, a single triangle uses
that direct path. A list with more than three vertices may enter the separate
batch path only when it is `GX_TRIANGLES`, divisible by three, within the
existing 128-vertex and PC buffer bounds, complete, and supported by the V2
state contract.

The batch helper allocates one bounded packet array, builds and validates every
three-vertex slice before the first callback, then calls the existing
synchronous V2 callback once per triangle in source order. Any failed slice,
allocation, topology, count, bound, or state check invokes no V2 callback and
leaves the existing V3/V4 fallback in place. Quads and nonmultiples remain
fail-closed, and legacy OpenGL remains the real submission path.

During integration review, the first worker commit was found to route
`count == 3` through the batch branch, making its later direct branch
unreachable. The same remote task added the separate `c1dbf9fe` follow-up so a
single triangle now uses the direct path without allocating a batch array.

## Verification

The worker and the exact integrated `c973dbee` snapshot both ran the existing
direct V2 handoff target plus the new batch target serially. The final tests
cover direct exact-three compatibility, ordered 6/9-vertex slicing, null
callback, unsupported state, invalid later-slice vertex with zero partial
callbacks, bounds, nonmultiple triangles, and quads.

Integrated native commands:

```sh
/opt/homebrew/bin/cmake -S pc \
  -B /private/tmp/acgc-integrate-v2-triangle-batch-c973dbee-native \
  -G "Unix Makefiles" -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++
/opt/homebrew/bin/cmake --build \
  /private/tmp/acgc-integrate-v2-triangle-batch-c973dbee-native \
  --target acgc_pc_gx_semantic_v2_handoff_tests \
  acgc_pc_gx_semantic_v2_batch_handoff_tests --parallel 1
/opt/homebrew/bin/ctest --test-dir \
  /private/tmp/acgc-integrate-v2-triangle-batch-c973dbee-native \
  --output-on-failure --parallel 1 \
  -R 'acgc_pc_gx_semantic_v2_(handoff|batch_handoff)_tests'
```

Result: native `2/2` passed.

The combined ASan/UBSan root used the same configure/build targets with
`-fsanitize=address,undefined -fno-omit-frame-pointer`, then:

```sh
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
/opt/homebrew/bin/ctest --test-dir \
  /private/tmp/acgc-integrate-v2-triangle-batch-c973dbee-asan \
  --output-on-failure --parallel 1 \
  -R 'acgc_pc_gx_semantic_v2_(handoff|batch_handoff)_tests'
```

Result: combined ASan/UBSan `2/2` passed with no sanitizer diagnostics.
`detect_leaks=0` means there is no leak-free claim. Known AppleClang macro and
unsupported-warning-option warnings remain unchanged. `git diff --check`
passes and canonical PC is clean at `c973dbee`.

## Claim boundary and next gate

Proved: the exact CPU builder/flush contract can atomically split supported
triangle lists into ordered, exact-three V2 callback packets while preserving
direct single-triangle, fallback, and legacy OpenGL behavior.

Not proved: a live game-owned successful packet or callback, Apple consumer or
texture-provider reachability, Metal encode/present/readback, a pixel, input,
audible audio, save/reload, simulator/device behavior, natural shutdown, or
playability. The dependency-ready next gate is one separately serialized
current-tip arm64 link and bounded logged-in GUI/LLDB trace at `c973dbee`.
