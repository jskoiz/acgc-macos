# Apple texture/TLUT/TEV CPU seam — `a6c5e0c8`

## Scope

Remote M3 Max lane `019fff43-def1-7bd2-8e1a-f7e72a6aac5b` worked from PC base
`894ac5f8` on branch `c1/lane-texture-tev-m3`. The umbrella checkout remained
at its older submodule pointer; no umbrella files were edited by the lane. The
lane crosswalked the PC packet/consumer symbols against decomp GX geometry,
texgen, TLUT, TEV, selector, and caller symbols. Decomp has no counterpart for
the portable semantic packet or Apple consumer APIs.

The final commit `a6c5e0c8` adds an opt-in, caller-owned CPU seam for resolving
validated V2 texture/TLUT fixtures and a bounded subset of TEV inputs, swaps,
operations, constants, and stage output. The existing typed V2 handoff remains
`NOT_RENDERED`; the new result is explicitly `CPU_RESOLVED`. Unsupported packet,
fixture, sampler, or TEV state fails closed. No Metal object or draw submission
is created.

Changed files are limited to:

- `upstream/ACGC-PC-Port/pc/apple/include/acgc/metal_packet_consumer.h`
- `upstream/ACGC-PC-Port/pc/apple/src/metal_packet_consumer.c`
- `upstream/ACGC-PC-Port/pc/apple/tests/test_metal_packet_consumer_v2_texture_tev.c`
- `upstream/ACGC-PC-Port/pc/apple/CMakeLists.txt`

## Integrated verification

After cherry-picking onto canonical PC `c1/macos-host-launch` as `08c27de5`:

```sh
cmake -S upstream/ACGC-PC-Port/pc/apple \
  -B /private/tmp/acgc-integrated-texture-tev-08c27de5 \
  -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrated-texture-tev-08c27de5 \
  --target acgc_metal_packet_consumer_v2_texture_tev_tests \
           acgc_renderer_fixture_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrated-texture-tev-08c27de5 \
  --output-on-failure --parallel 1 \
  -R '^(acgc_renderer_fixture_tests|acgc_metal_packet_consumer_v2_texture_tev_tests)$'
```

Result: native `2/2` passed.

The same two targets were configured with combined `-fsanitize=address,undefined`
flags and run with `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1`
and `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`, `--parallel 1`.
Result: ASan/UBSan `2/2` passed with no diagnostics. As established by prior
Apple lanes, `detect_leaks=1` is unsupported by this platform runtime.

## Evidence boundary and next gate

This proves only a synthetic CPU decode/evaluation and typed consumer contract.
It does not prove a live game-owned callback, Metal encode/present/readback,
pixel, device, input, audio, save/reload, simulator, or playability gate. The
next bounded gate is a separately owned runtime-forwarding audit that proves
where resolved texture/TLUT/sampler data is sourced and forwarded before any
serialized full `ac_pc` link or LLDB launch.
