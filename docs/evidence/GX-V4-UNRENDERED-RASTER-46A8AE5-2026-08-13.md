# V4 unrendered raster-state gate at `46a8ae5`

## Result

This source slice narrows the V4 contract so that live alpha-test, depth, and
cull state may pass the V4 builder even though the current Apple packet does
not encode those fields. The Apple consumer continues to use its bounded
fixture depth/raster defaults, so this is not full GX state fidelity. Color
writes remain fail-closed because the sink has no packet field for a disabled
color mask. V1/V2/V3 retain the strict predicate.

No live callback, Metal encode/present, pixel readback, input, audio,
save/reload, device, simulator, or playability claim follows from this gate.

## Provenance and ownership

- Worker branch: `c1/lane-gx-v4-unrendered-raster`, commit `8386830`, based on
  canonical PC `fbb286d`.
- Integrated PC branch: `c1/macos-host-launch` at `46a8ae5`.
- Umbrella source pointer before this integration: `83fe50c`.
- `ac-decomp`: `master` at `09ca8e8b`.
- Changed files (and only these files):
  `pc/src/pc_gx.c` and `pc/tests/pc_gx_semantic_v4_consumer_fixture.c`.

The crosswalk uses the PC V4 predicate and builder in `pc/src/pc_gx.c` and
the Apple consumer's fixed state mapping in
`pc/apple/src/metal_packet_consumer.c`. The decomp counterpart is the GX
state API contract: `GXSetAlphaCompare`, `GXSetZMode`, `GXSetCullMode`, and
`GXSetColorUpdate` in `include/dolphin/gx/GXTev.h`/`GXPixel.h`, with concrete
state writes in `src/static/dolphin/gx` and `src/static/JSystem/JFramework`.

## Focused verification

The lane's pre-commit roots were:

```text
/private/tmp/acgc-lane-gx-v4-unrendered-raster-native
/private/tmp/acgc-lane-gx-v4-unrendered-raster-asan
```

The six-target native matrix and the six-target combined ASan/UBSan matrix
each passed `6/6` with `--parallel 1` and no sanitizer diagnostics. The
fixture now demonstrates both sides of the contract: non-default alpha/depth/
cull state gives V3 `0` and V4 `1`, while disabling color writes gives V4 `0`.

After cherry-pick, the canonical integrated roots were:

```text
/private/tmp/acgc-integrate-gx-v4-unrendered-raster-46a8ae5-native
/private/tmp/acgc-integrate-gx-v4-unrendered-raster-46a8ae5-asan
```

The same six CTest targets passed `6/6` natively and `6/6` under combined
ASan/UBSan (`ASAN_OPTIONS=detect_leaks=0`,
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`). The compiler emitted only
the known AppleClang warning about `-Wno-builtin-declaration-mismatch` and
the legacy `INT_MIN` macro redefinition; no sanitizer diagnostic occurred.

## Next gate

One serialized current-tip arm64 `ac_pc` link and one bounded explicit-return
LLDB launch are required at `46a8ae5`. Even if the V4 consumer starts getting
called, that would prove callback reachability only; Metal device encoding,
presentation/readback, pixels, and playability remain separate gates.
