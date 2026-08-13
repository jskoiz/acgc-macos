# GX V3 builder-to-consumer fixture

Date: 2026-08-13  
Lane: 106 (`019ffd51-9466-75e3-b9f9-c29b09289e91`)  
PC base: `042cbf75fc136725769786443b40a1fd3ad82a7a`  
Worker commit: `51ef7e48c7174b1684dfb588e749a785762a11b9`  
Integrated PC: `f18e7cdb5bbf82f55397cb7bfdd8b0aa282b8d3f`  
Decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Fixture scope

The fixture owns only `pc/tests/pc_gx_semantic_v3_consumer_fixture.c` and its
narrow `pc/CMakeLists.txt` registration. It exercises a synthetic live-like
state and keeps the production V3 and Apple sources unchanged.

It proves four CPU boundaries:

1. `GXSetAlphaUpdate(GX_FALSE)` sets `alpha_update_enable == 0`, asserts the
   color-mask dirty state, and rejects the V3 builder before any callback.
2. Enabling alpha writes builds a valid V3 packet carrying the observed blend
   and texture-matrix state.
3. The typed Apple consumer accepts that packet while reporting
   `V3_EXTENSION_NOT_RENDERED`.
4. A post-builder malformed packet is rejected by the consumer independently,
   and the existing V1 callback seam remains separate and usable.

The decomp crosswalk covers the original `GXSetAlphaUpdate` declaration/API
and the `emu64` alpha-write call sites. It has no V3 packet or Apple consumer
counterpart; it remains the original-behavior oracle.

## Verification

The worker's exact-base native and ASan/UBSan roots both configured and built
the fixture; registered CTest passed `1/1` in each matrix. On the integrated
current PC snapshot `f18e7cd`, the focused regression pair was rerun:

```text
native:
  acgc_pc_gx_semantic_v3_handoff_tests ........ PASS
  acgc_pc_gx_semantic_v3_consumer_fixture .... PASS
  2/2 passed

ASan/UBSan (ASAN_OPTIONS=detect_leaks=0:halt_on_error=1,
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1):
  acgc_pc_gx_semantic_v3_handoff_tests ........ PASS
  acgc_pc_gx_semantic_v3_consumer_fixture .... PASS
  2/2 passed
```

No sanitizer diagnostics were emitted. Leak detection was disabled because
Darwin's ASan runtime does not support `detect_leaks=1`; no leak-free claim
follows. Existing AppleClang/decomp warning text is non-fatal and unchanged.

No full `ac_pc` link, LLDB launch, game runtime, Metal device, encode/present,
readback, pixel, input, audio, save/device, simulator, or playability evidence
follows. The fixture establishes only synthetic CPU builder/consumer contract
behavior.
