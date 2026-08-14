# V4 rejection diagnostic alignment at `adaddfd`

## Result

The V4 rejection classifier now matches the V4 builder predicate introduced at
`46a8ae5`: alpha-test, depth, and cull state are intentionally not encoded by
the current V4 packet and therefore are no longer reported as rejection
reasons. The strict color-write gate remains. This is a diagnostic-only
change; it does not alter packet layout, callback dispatch, or renderer
behavior.

No live callback, Metal encode/present, pixel readback, input, audio,
save/reload, device, simulator, or playability claim follows from this commit.

## Provenance and ownership

- Worker branch: `c1/lane-gx-v4-unrendered-raster`, commit `2b9807f`, based on
  the source lane's `8386830` V4 raster-state change.
- Integrated PC branch: `c1/macos-host-launch` at `adaddfd` (cherry-picked
  from `2b9807f` on top of `46a8ae5`).
- `ac-decomp`: `master` at `09ca8e8b`.
- Changed file: `pc/src/pc_gx.c`, helper `pc_gx_v4_rejection_reason()` only.

The two-upstream crosswalk remains the PC V4 builder/flush seam in
`pc/src/pc_gx.c` and the decomp GX state APIs (`GXSetAlphaUpdate`,
`GXSetAlphaCompare`, `GXSetZMode`, `GXSetCullMode`, and
`GXSetColorUpdate`) under `src/static/dolphin/gx` and
`src/static/JSystem/JFramework`.

## Focused verification

The integrated snapshot used distinct ignored roots:

```text
/private/tmp/acgc-integrate-gx-v4-rejection-diagnostic-adaddfd-native
/private/tmp/acgc-integrate-gx-v4-rejection-diagnostic-adaddfd-asan
```

The six focused CTest targets passed `6/6` natively and `6/6` under combined
ASan/UBSan with `--parallel 1`, `ASAN_OPTIONS=detect_leaks=0`, and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. No sanitizer diagnostic was
reported. The only compiler output was the known AppleClang warning about
`-Wno-builtin-declaration-mismatch` and the legacy `INT_MIN` macro
redefinition.

## Next gate

One serialized current-tip arm64 `ac_pc` link and one bounded explicit-return
LLDB launch at `adaddfd` are required to classify the live V4 rejection. The
result must remain separate from callback, Metal device encode/readback, pixel,
input, audio, save/reload, simulator/device, and playability gates.
