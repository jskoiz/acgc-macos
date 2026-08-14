# Input trigger digital/analog parity at `afb1cac3c`

Date: 2026-08-14

## Provenance

- Umbrella integration owner: local `main`
- PC base: `5157ac1cbcdc3a0074a407c08874a0861ba20c72`
- Remote M3 Max worker branch: `c1/lane-input-trigger-parity-m3`
- Remote worker commit: `047ec513474fb7a51a346e4d62d913c0ce80d5bf`
- Canonical PC integration commit: `afb1cac3c1c1167678af20a4085aecd614b857bd`
- ac-decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Source-only bundle SHA-256: `d617e2206b5075417c728c6ea8567ab2f6bab28e73f6a9afd025b01a0df4779d`

No ISO, extracted assets, keys, or proprietary game data were transferred to
or accessed by the worker.

## Two-upstream crosswalk

The PC host `pc/src/pc_pad.c` previously used `PC_PAD_AXIS_PRESS` for the
digital L/R bits while independently preserving the normalized analog trigger
values. The decomp path in `src/static/libultra/contreaddata.c` sets
`BUTTON_L`/`BUTTON_R` when either the JUT digital bit is present or the
corresponding analog trigger value is nonzero. The host's `src/padmgr.c` consumes
the `PADRead` digital mask at its current handoff, so a sub-threshold nonzero
axis value could retain analog pressure but lose the game-visible L/R button.

The narrow fix adds trigger-specific pressed semantics: an axis-bound L/R is
digital when its existing normalized analog value is nonzero. Digital button
and keyboard bindings still use `pad_code_pressed`; trigger scaling, sticks,
face buttons, and unrelated thresholds are unchanged.

## Exact source delta

- `pc/src/pc_pad.c`
- `pc/tests/pc_input_sdl_smoke.c`

No CMake registration changed because the existing focused target already owns
both files.

## Exact integrated verification

Native root:
`/private/tmp/acgc-integrate-input-trigger-afb1cac3-native`

```sh
cmake -S pc -B /private/tmp/acgc-integrate-input-trigger-afb1cac3-native \
  -G "Unix Makefiles" \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-input-trigger-afb1cac3-native \
  --target acgc_pc_input_sdl_smoke_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-input-trigger-afb1cac3-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_input_sdl_smoke_tests$' -V
```

Result: `1/1` passed. The virtual SDL controller proved zero, normalized
analog `88` below the former threshold, above-threshold analog, released and
pressed digital bindings, and byte-identical consecutive `PADRead` snapshots.

Combined ASan/UBSan root:
`/private/tmp/acgc-integrate-input-trigger-afb1cac3-asan`

The same focused target was configured with
`-fsanitize=address,undefined -fno-omit-frame-pointer` and run serially with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. Result: `1/1` passed with
no sanitizer diagnostics. Leak detection was deliberately disabled, so this is
not a leak-free claim.

A bounded `_WIN32` host syntax probe stopped at the existing missing
`process.h` boundary in SDL. No MinGW/sysroot dependency was added and this is
not Windows sign-off.

## Claim boundary

This proves the focused host input mapping and deterministic virtual-controller
snapshot only. It does not prove an OS keyboard transition, physical
controller, running-game input response, full `ac_pc` link, device behavior,
iOS input, Metal rendering, pixels, or playability.
