# GX v3 state handoff evidence — 2026-08-13

## Scope

PC source `c1/macos-host-launch` is integrated at `042cbf7` (`Add bounded GX
v3 state handoff`), based on `8a19f23`. The matching decomp reference remains
`upstream/ac-decomp` `09ca8e8b`. The change is a bounded state-forwarding slice;
it is not a renderer implementation and makes no game-frame, Metal encode,
present, pixel, input, audio, save, device, simulator, or playability claim.

The new fixed-width `AcgcGxSemanticPacketV3` keeps a validated v1 geometry
payload and adds only the live rejection state proven by the preceding
diagnostic: blend mode/factors/logic operation and up to two resolved
texture-generator matrices. The Apple callback is separately typed. V3 is
attempted only after the existing V2 builder fails, and the Apple consumer
marks `V3_EXTENSION_NOT_RENDERED`; the runtime does not submit V3 to the Metal
sink. V1/OpenGL behavior remains the default path.

## Two-upstream crosswalk

- `ACGC-PC-Port/pc/src/pc_gx.c`: existing v1/v2 packet builders and
  `pc_gx_flush_vertices` are the host submission boundary. V3 reuses the
  existing vertex/transform construction and state checks, retaining the
  existing v2 channel/TEV/texture validation rather than weakening it.
- `ACGC-PC-Port/pc/apple/src/metal_packet_consumer.c` and
  `pc/apple/src/pc_metal_runtime.c`: existing typed V2 consumer and borrowed
  runtime callback are extended with a V3 validation/observation route. The
  V3 extension is explicitly not rendered and is excluded from sink submit.
- `ac-decomp/src/static/libforest/emu64/emu64.c`: `GXSetTexCoordGen` setup at
  lines 511–518 and `emu64::dl_G_DL`/`emu64_taskstart_r` at 3328/5377 describe
  the original GX texture-generator and display-list flow. The V3 packet does
  not alter that guest path.
- `ac-decomp/include/dolphin/gx/GXEnum.h`: the stable enum values distinguish
  `GX_BM_BLEND`, source-alpha factors, `GX_LO_NOOP` (raw value `5`),
  `GX_TEXMTX0`, and `GX_PTIDENTITY`; the packet maps those values into a
  pointer-free host contract.

## Verification

All commands were run from the integrated PC checkout at `042cbf7`; build
roots are ignored and outside tracked paths.

Native focused build/test:

```sh
cmake -S pc -B /private/tmp/acgc-integrate-gx-v3-042cbf7-native \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-gx-v3-042cbf7-native \
  --target acgc_pc_gx_semantic_v3_handoff_tests \
           acgc_pc_gx_semantic_handoff_tests \
           acgc_pc_gx_semantic_v2_handoff_tests -j1
ctest --test-dir /private/tmp/acgc-integrate-gx-v3-042cbf7-native \
  --output-on-failure \
  -R '^acgc_pc_gx_semantic_(v3_handoff|handoff|v2_handoff)_tests$'
```

Result: `3/3` tests passed. The V3 fixture proves live blend/matrix state
serialization, a typed callback, prefix preparation, and fail-closed invalid
logic-op rejection. The existing V1 and V2 fixtures also remain green.

ASan/UBSan focused build/test:

```sh
cmake -S pc -B /private/tmp/acgc-integrate-gx-v3-042cbf7-asan \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-integrate-gx-v3-042cbf7-asan \
  --target acgc_pc_gx_semantic_v3_handoff_tests \
           acgc_pc_gx_semantic_handoff_tests \
           acgc_pc_gx_semantic_v2_handoff_tests -j1
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1 \
ctest --test-dir /private/tmp/acgc-integrate-gx-v3-042cbf7-asan \
  --output-on-failure \
  -R '^acgc_pc_gx_semantic_(v3_handoff|handoff|v2_handoff)_tests$'
```

Result: `3/3` tests passed with no sanitizer diagnostics. `detect_leaks=0`
is intentional for this Darwin fixture lane; no leak claim follows.

The existing Apple handoff fixture target also rebuilt the production
`pc/apple/src/pc_metal_runtime.c` registration path successfully. No full
`ac_pc` link or LLDB launch was run for this source slice, and no runtime
callback count has been attributed to V3 yet.

## Next gate

The next bounded lane must be a serialized current-tip full link/launch that
counts `pc_gx_try_handoff_semantic_packet_v3` and
`pc_metal_runtime_observe` separately. A V3 callback hit would prove only
state-packet reachability. A subsequent Metal state encoder must consume blend
and texture-matrix fields, pass device-gated encode/present/readback tests, and
remain a separate gate before any game-owned pixel or playability claim.
