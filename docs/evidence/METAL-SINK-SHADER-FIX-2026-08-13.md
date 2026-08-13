# Metal sink shader compile fix

Date: 2026-08-13 HST

The source lane started from PC `59aa655` and committed
`5db1d281e87f22a7682f60f998044f58168bd2a4`, then the integration owner
cherry-picked it into canonical `c1/macos-host-launch` as `a8f3a8f`.

## Change and crosswalk

Only `upstream/ACGC-PC-Port/pc/apple/src/metal_sink.m` changed. The embedded
MSL local named `vertex` was a reserved identifier in the macOS Metal compiler;
it is now `sink_vertex`, including its field references. CPU-side packet data,
buffer bindings, entry points, lifecycle, counters, and shutdown behavior are
unchanged. The decomp reference `09ca8e8b` has no Metal sink/MSL counterpart;
its relevant boundary remains the original GX geometry declarations and
implementation.

## Verification

The lane first reproduced the recorded pre-fix parser failure with offline
`xcrun --sdk macosx metal`: `stdin:25:32`, `expected unqualified-id`. After the
rename, offline compilation produced LLVM AIR with exit `0`.

On the integrated `a8f3a8f` source:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/apple \
  -B /private/tmp/acgc-integrate-metal-sink-shader-a8f3a8f \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-metal-sink-shader-a8f3a8f \
  --target acgc_metal_sink_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-metal-sink-shader-a8f3a8f \
  --output-on-failure -R '^acgc_metal_sink_tests$'
```

The focused Apple target compiled and linked. CTest reported `1/1` expected
skip `77` because no macOS Metal device is available; the CPU contract passed.
The lane's separate ASan/UBSan-configured sink target also built and reached
the same skip with no sanitizer diagnostics (`detect_leaks=0`).

This closes the offline shader parser blocker only. It does not prove a live
game callback, Metal encode/command-buffer completion, presentation, readback,
pixel, device rendering, input, audio, save/load, simulator/device behavior,
or playability. No full `ac_pc` link was run in the source lane or integrated
focused rerun.

Preserved source-lane artifacts for cleanup review:

- `/private/tmp/acgc-lane-metal-sink-shader-fix-source`
- `/private/tmp/acgc-lane-metal-sink-shader-fix`
- `/private/tmp/acgc-lane-metal-sink-shader-fix-asan`
