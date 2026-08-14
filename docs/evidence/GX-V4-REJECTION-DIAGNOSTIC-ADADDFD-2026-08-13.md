# V4 rejection diagnostic attempt at `adaddfd`

## Result

The `adaddfd` source change removed the relaxed alpha-test, depth, and cull
checks from the V4 builder's common predicate and added an alignment comment to
the diagnostic helper. The helper itself still retained those checks. The
subsequent current-tip runtime exposed that mismatch because all records were
still labeled `global_state`; the complete helper correction is the separate
`a53b192` follow-up.

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

The one current-tip `adaddfd` link/LLDB attempt is recorded separately; it
reached live V4 builder calls but demonstrated that this helper still emitted
the old `global_state` label. The next exact-tip trace is authorized only after
the `a53b192` correction is integrated.
