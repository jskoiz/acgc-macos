# Apple legacy V4 sink guard at `62ef6638d`

## Provenance and ownership

- M3 Max task: `01a00297-d95c-7742-8feb-a275b16b4b88`
- PC base: `b5f550ea028ab933b8433ec2e9d29768252cabdc`
- Remote branch: `c1/lane-v4-sink-failclosed-m3`
- Remote worker commit: `0bda49d23ec6b933c3e08892fedec81a5d7040d6`
- Canonical PC integration: `62ef6638d3dbeaed6fe75733d9f4c0357866ba7b`
- ac-decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The source-only handoff changed exactly:

- `pc/apple/src/pc_metal_runtime.c`
- `pc/apple/tests/test_metal_packet_consumer_v2_runtime_sideband.c`

No packet ABI/builder, `pc_gx`, canonical-state source, shader, encoder, decomp,
ISO, or asset file changed.

## Two-upstream decision

The current Apple sink is geometry-only. `acgc_metal_packet_consumer_prepare_v4`
maps a bounded blend/alpha subset and deliberately leaves texture-matrix state
unrendered. PC `pc_gx_semantic_v4_state_is_supported` also documents live
texture, TEV, and raster semantics that V4 does not carry cumulatively.

The decomp behavior oracle configures viewport, cull, channels, texgens, TEV
stages/orders/ops, alpha comparison, fog, blend, and depth through the GX state
setters used by `emu64_init2` and `emu64::emu64_init`. A well-formed V4 typed
handoff therefore cannot safely represent the complete draw state expected by
the game.

`pc_metal_runtime_sink_eligible` now preserves the existing status-tuple
validation but admits only semantic V1 to the legacy geometry sink. V2, V3,
and V4 fail closed until the new cumulative canonical snapshot has been
validated and converted to an immutable CPU render plan. This is an end-state
safety boundary, not a fallback parser or another packet version.

## Exact verification

The remote lane first added a V4 fixture that failed against the old policy
(CTest exit `8`), then passed the corrected implementation:

- native focused CTest: `1/1` pass;
- combined ASan/UBSan focused CTest: `1/1` pass with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`;
- production `pc_metal_runtime.c` syntax compile: pass;
- `git diff --check`: pass.

The integration owner repeated the exact canonical gate from clean source
`62ef6638d`:

```sh
cmake -S pc/apple \
  -B /private/tmp/acgc-integrate-v4-sink-failclosed-native \
  -G "Unix Makefiles" \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-v4-sink-failclosed-native \
  --target acgc_metal_packet_consumer_v2_runtime_sideband_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-v4-sink-failclosed-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_metal_packet_consumer_v2_runtime_sideband_tests$'
```

Result: native `1/1` pass. The same configure/build/test in
`/private/tmp/acgc-integrate-v4-sink-failclosed-asan`, with combined
AddressSanitizer/UndefinedBehaviorSanitizer flags and the environment above,
passed `1/1` with no sanitizer diagnostic. Leak detection was disabled, so no
leak-free claim is made. The production-path Clang syntax compile also passed.

## Evidence boundary and next gate

This proves a CPU policy and deterministic fixture only. It does not prove a
live callback, full `ac_pc` link, Metal device, encode, present, readback,
pixel, frame, or playability gate. The next rendering dependency is the strict
canonical envelope, followed by exact state sections, snapshot producer,
owned resource sideband, immutable Apple CPU plan, and only then a separate
device-gated Metal encoder/pixel proof.
