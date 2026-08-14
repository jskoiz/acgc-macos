# GX V4 handoff fixture — integrated 13c0e0cf

Date: 2026-08-13 (Honolulu)

## Scope

This lane was a remote M3 Max test/source lane for a synthetic V4 builder-to-
consumer handoff. It owns only `pc/tests/pc_gx_v4_handoff_fixture.c` and its
minimal `pc/CMakeLists.txt` registration. It does not change `pc/src/pc_gx.c`,
the packet headers, the Apple runtime, or either upstream decomp history.

The lane started from PC `a53b192247aab2c4f6e58b1f2dda41efdf8d1cad` and
returned worker commit `ce06b5b0648f0120c1326dda1f8deb3c52ccab46` on
`c1/lane-gx-v4-fixture-m3`. After review, the integration owner cherry-picked
that commit onto canonical `c1/macos-host-launch`, producing `13c0e0cf`.

The corresponding ac-decomp reference was `master` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

## Two-upstream crosswalk

The fixture reuses the PC-port V3/V4 packet and typed-consumer contracts:

- `pc/tests/pc_gx_semantic_v2_handoff.c` and
  `pc/tests/pc_gx_semantic_v3_handoff.c` establish the existing typed handoff
  shape and state validation.
- `include/acgc/gx_semantic_packet.h` and
  `pc/apple/include/acgc/metal_packet_consumer.h` define the V3/V4 ABI and
  consumer seam; `pc/apple/src/metal_packet_consumer.c` supplies the bounded
  V4 mapping/rejection behavior exercised by the fixture.
- ac-decomp has generic GX state counterparts in `GXPixel.h`, `GXTev.h`,
  `GXGeometry.h`, and `GXLighting.h`, with callers in `GXInit.c`,
  `JUTResFont.cpp`, `J2DGrafContext.cpp`, and `emu64.c`. It has no counterpart
  for the PC-port packet, consumer, or fixture APIs.

## Verification

On the integrated PC `13c0e0cf`, using unique ignored roots:

```text
cmake -S upstream/ACGC-PC-Port/pc -B /private/tmp/acgc-integrated-v4-fixture-13c0e0cf-native -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
cmake --build /private/tmp/acgc-integrated-v4-fixture-13c0e0cf-native --target acgc_pc_gx_v4_handoff_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrated-v4-fixture-13c0e0cf-native --output-on-failure --parallel 1 -R '^acgc_pc_gx_v4_handoff_fixture$'
```

Native result: `1/1` passed. The combined AddressSanitizer/UndefinedBehaviorSanitizer
build used the same target with `-fsanitize=address,undefined` and ran with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; sanitizer result: `1/1`
passed with no diagnostics. Leak detection is disabled because this Apple
runtime does not support LeakSanitizer.

`git diff --check` passed. The only build noise was the existing AppleClang
unknown-warning-option warning for `-Wno-builtin-declaration-mismatch`.

## Evidence boundary and next gate

This proves synthetic CPU packet construction, ABI checks, typed consumer
preparation, callback registration, and focused native/sanitized tests. It does
not prove a live game callback, full `ac_pc` link, LLDB launch, Metal encode or
present, pixel readback, input, audio, save/device persistence, simulator,
physical device, or playability. The next runtime gate remains separately
serialized and must use a current integrated snapshot.

The remote source branch and commit remain preserved; its exact worktree and
focused roots were retired only after holder-free checks. No ISO, ROM, or
extracted asset was accessed or transferred.
