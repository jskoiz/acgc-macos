# V2 disabled-channel source contract — integrated 565f877e

## Scope

This record covers the focused CPU/contract lane that extends the fixed-width
V2 semantic packet boundary for decomp-compatible disabled material channels.
It does not claim a live game callback, Metal encoding, presentation, pixel
readback, device behavior, or playability.

- PC base: `2b141a753ab948e9494c97daf8490673c61be9fc`
- Worker commit: `112c7cd2ef39ea01d898e23973b4a11b5adf782b`
- Integrated PC tip: `565f877e175ee8d3deae174ba5b0f8edb85ce0b0`
- Decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Worker branch: `c1/lane-v2-channel-source-contract-m3`
- Worker placement: remote M3 Max source/test lane; no ISO or extracted data

## Owned change

The worker changed exactly these seven files:

1. `include/acgc/gx_semantic_packet.h`
2. `src/gx_semantic_packet.c`
3. `pc/apple/include/acgc/metal_packet_consumer.h`
4. `pc/apple/src/metal_packet_consumer.c`
5. `pc/apple/src/pc_metal_runtime.c`
6. `pc/apple/CMakeLists.txt`
7. `pc/apple/tests/test_metal_packet_consumer_v2_channel_source.c`

The fixed-width V2 ABI is unchanged. The validator accepts only the bounded
disabled-channel forms represented by the decomp: register or vertex material
source with the supported ambient/material source combinations. Enabled,
lighted, unknown, or malformed channel state fails closed. The Apple consumer
repeats the channel gate before consuming the V2 prefix; vertex-source V2
remains `V2_EXTENSION_NOT_RENDERED`. V1 dispatch and the existing V2 handoff
fixture were not broadened.

## Two-upstream crosswalk

- The PC builder's existing register/register V2 encoding is in
  `pc/src/pc_gx.c` around the V2 handoff construction (`pc_gx` channel state).
- The decomp enum definitions are in `src/include/GXEnum.h` (`GX_SRC_REG` and
  `GX_SRC_VTX`), with disabled-channel initialization in `src/GXInit.c` and
  callers in `src/JUTResFont.cpp`, `src/J2DGrafContext.cpp`, and the emu64 GX
  state path in `src/emu64.c`.

The lane stopped at this narrow contract because the existing Apple seam does
not yet render the richer V2 state; it did not edit `pc/src/pc_gx.c` or the
decompilation.

## Verification

On the worker, and again after integration at `565f877e`, the three focused
consumer targets were run with serialized test execution:

- Native CTest: `3/3` passed.
- Combined ASan/UBSan CTest: `3/3` passed with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`.
- No sanitizer diagnostics; `detect_leaks=0` means no leak-free claim.

No full `ac_pc` link or LLDB launch was run for this lane. The next runtime
gate is one separately serialized current-tip link/trace at `565f877e` to
measure whether the live builder now reaches the typed consumer. That trace
must remain distinct from any later Metal device, encode/readback, pixel, or
playability gate.
