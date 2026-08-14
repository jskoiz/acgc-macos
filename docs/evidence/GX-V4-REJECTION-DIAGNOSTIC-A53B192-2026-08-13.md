# V4 rejection reason classifier correction at `a53b192`

## Result

The V4 rejection diagnostic now removes the same alpha-test, depth, and cull
checks that the V4 builder removed at `46a8ae5`. It keeps the strict color-write
gate and then classifies the remaining contract checks as blend, channel,
stage/texture, texgen, or payload/validation. This is diagnostic-only; packet
layout, callback dispatch, and renderer behavior are unchanged.

No live callback, Metal encode/present, pixel readback, input, audio,
save/reload, device, simulator, or playability claim follows from this commit.

## Provenance and ownership

- Worker branch: `c1/lane-gx-v4-unrendered-raster`, commit `9d4138d`, based on
  the previously integrated `adaddfd` tip.
- Integrated PC branch: `c1/macos-host-launch` at `a53b192`, cherry-picked from
  `9d4138d`.
- `ac-decomp`: `master` at `09ca8e8b`.
- Changed file: `pc/src/pc_gx.c`, helper `pc_gx_v4_rejection_reason()` only.

The two-upstream crosswalk remains the PC V4 builder/flush seam in
`pc/src/pc_gx.c` and the decomp GX state APIs under `src/static/dolphin/gx`
and `src/static/JSystem/JFramework`.

## Focused verification

Distinct ignored roots were used for both the source handoff and the exact
integrated snapshot:

```text
/private/tmp/acgc-lane-gx-v4-rejection-diagnostic-fix-native
/private/tmp/acgc-lane-gx-v4-rejection-diagnostic-fix-asan
/private/tmp/acgc-integrate-gx-v4-rejection-diagnostic-fix-a53b192-native
/private/tmp/acgc-integrate-gx-v4-rejection-diagnostic-fix-a53b192-asan
```

The six focused CTest targets passed `6/6` natively and `6/6` under combined
ASan/UBSan with `--parallel 1`, `ASAN_OPTIONS=detect_leaks=0`, and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. No sanitizer diagnostic was
reported. Known AppleClang warning output was unchanged.

## Next gate

One serialized current-tip arm64 `ac_pc` link and one bounded explicit-return
LLDB launch at `a53b192` will classify the live V4 rejection. The trace remains
separate from callback, Metal device encode/readback, pixel, input, audio,
save/reload, simulator/device, and playability gates.
