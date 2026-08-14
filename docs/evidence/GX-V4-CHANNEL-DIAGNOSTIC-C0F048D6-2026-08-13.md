# GX V4 channel rejection diagnostic — integrated `c0f048d6`

Date: 2026-08-13

## Provenance

- Remote M3 Max worker branch: `c1/lane-gx-v4-channel-diagnostic-m3`
- Worker base: `a53b192247aab2c4f6e58b1f2dda41efdf8d1cad`
- Worker commit: `e8155c654075a5c44edbc6e090d8ba84b5ce66d6`
- Local canonical PC after review/cherry-pick: `c1/macos-host-launch` at
  `c0f048d6`
- `ac-decomp`: `master` at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Umbrella source-only base used by the worker: `ee31f535`

The worker worktree was isolated on the M3 Max at
`/private/tmp/acgc-lane-gx-v4-channel-diagnostic-m3`. The ISO, extracted assets,
keys, and proprietary data were not accessed or transferred. The umbrella
checkout was not edited by the worker.

## Change and crosswalk

The worker changed only:

- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_semantic_v4_alpha_state.c`

The prior V4 predicate reused the stricter V2 channel predicate and rejected
the observed disabled channel state. The PC-port crosswalk is
`pc/src/pc_gx.c:pc_gx_v2_channel_state_is_supported`; the decomp counterpart
is the generic `GXSetChanCtrl` contract in `include/dolphin/gx/GXInit.c`,
`include/dolphin/gx/GXEnum.h`, `include/dolphin/gx/GXLighting.h`, and the
`JUTResFont.cpp` caller. The decomp uses disabled channels with
`GX_SRC_REG`/`GX_SRC_VTX` material sources; V4 carries vertex colors but no
channel-source payload. The V4-only predicate now accepts those disabled
material sources while retaining enabled/lighting rejection. V1/V2 remain
strict and no V4 semantic counterpart exists in `ac-decomp` beyond the generic
GX channel API.

## Verification

The remote worker reported native and combined ASan/UBSan focused matrices of
`4/4` each, serially (`--parallel 1`), with no sanitizer diagnostics. The
macOS leak detector was disabled with `ASAN_OPTIONS=detect_leaks=0` because
LeakSanitizer is unsupported on this host.

On the integrated local PC `c0f048d6`, the smallest gate was rerun with unique
ignored roots:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrated-v4-channel-c0f048d6-native -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
cmake --build /private/tmp/acgc-integrated-v4-channel-c0f048d6-native \
  --target acgc_pc_gx_semantic_v4_alpha_state --parallel 1 --verbose
ctest --test-dir /private/tmp/acgc-integrated-v4-channel-c0f048d6-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_semantic_v4_alpha_state$'
```

Result: native `1/1` passed. The same configure/build used combined
`-fsanitize=address,undefined -fno-omit-frame-pointer` compile/link flags in
`/private/tmp/acgc-integrated-v4-channel-c0f048d6-asan`; with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`, sanitizer CTest was `1/1`
passed with no diagnostics. Existing AppleClang warnings were limited to the
known `INT_MIN` macro redefinition and unsupported
`-Wno-builtin-declaration-mismatch` option.

## Claim boundary and next gate

This proves a focused CPU/contract correction and its integrated native and
ASan/UBSan fixture. It does **not** prove a live V4 callback, Metal encode or
present, pixel readback, input, audible audio, save/device persistence,
simulator/device behavior, or playability. Full `ac_pc` links and LLDB launches
remain serialized. The next runtime trace must use the integrated source tip
and be explicitly authorized after the remaining remote CPU lanes return.
