# V2 handoff rejection fixture — `88724cdb`

Date: 2026-08-14
Lane: remote M3 Max test-only task `01a00165-3830-73a0-a783-481af8df9bbe`
PC base: `354f33884dd4e4e75b63cdb1dd5c72bc1dddbfd5`
PC worker: `c1/lane-v2-rejection-fixture-m3` → `88724cdbbbcca2973269e1d332bdf0bfce2e76f8`
Worker worktree: `/private/tmp/acgc-lane-v2-rejection-fixture-m3`
Decomp ref: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Scope and crosswalk

The lane was test-only. It changed only
`pc/tests/pc_gx_semantic_v2_handoff.c`; the existing `pc/CMakeLists.txt`
registration was sufficient. The two-upstream crosswalk covered:

- PC `pc_gx_try_handoff_semantic_packet_v2`,
  `pc_gx_build_semantic_packet_v2`,
  `pc_gx_semantic_v2_state_is_supported`, and the Apple
  `AcgcMetalPacketConsumerV2TextureSourceProvider` seam.
- Decomp `src/static/dolphin/gx/GXInit.c` channel/blend setup and
  `src/static/libforest/emu64/emu64.c` `emu64::blend_mode()` and draw callers.

The fixture now isolates the null callback guard, non-triangle vertex count,
ordinary emu64 blend state (`GX_BM_NONE` with `SRCALPHA` /
`INVSRCALPHA` / `GX_LO_NOOP`), and disabled `GX_SRC_VTX` material channels.
It arms a synthetic texture-source provider and verifies that a builder
rejection does not call that downstream provider. No production predicate was
weakened.

## Verification

Remote M3 Max, serial focused target:

```text
cmake -S pc -B /private/tmp/acgc-lane-v2-rejection-fixture-m3-native \
  -G 'Unix Makefiles' -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
cmake --build /private/tmp/acgc-lane-v2-rejection-fixture-m3-native \
  --target acgc_pc_gx_semantic_v2_handoff_tests --parallel 1
ctest --test-dir /private/tmp/acgc-lane-v2-rejection-fixture-m3-native \
  --output-on-failure --parallel 1 -R '^acgc_pc_gx_semantic_v2_handoff_tests$'
```

Result: native `1/1` pass. The combined ASan/UBSan configure/build and the
same serial CTest passed `1/1` with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; no sanitizer diagnostics.
`git diff --check` and the committed diff check passed. Only pre-existing
AppleClang/decomp warnings were reported (`INT_MIN` redefinition and the
unsupported `-Wno-builtin-declaration-mismatch` option).

The integration owner cherry-picked the exact commit onto local
`c1/macos-host-launch`, producing PC `2b141a753ab948e9494c97daf8490673c61be9fc`,
and reran the same native and combined ASan/UBSan focused target locally:
`1/1` pass in each matrix. The umbrella pointer is intentionally updated only
after this local gate.

## Evidence boundary and next gate

This proves CPU/contract fixture behavior: the listed builder rejects remain
fail-closed and the texture-source provider is downstream of those rejects. It
does not prove a live game-owned callback, Metal encode/present/readback,
pixels, input, audible audio, save/reload, device, simulator, or playability.
No full `ac_pc` link or LLDB launch was run by this lane, and no ISO, extracted
asset, key, or proprietary data was accessed or transferred.

The next bounded gate is one serialized current-tip `ac_pc` link and one GUI
LLDB trace at PC `2b141a753`, with per-call V2 result/registration evidence.
The prior parent trace at `354f33884` remains bounded to V2 builder entry and
zero downstream Apple counts; it is not a current-tip callback claim.
