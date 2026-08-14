# Apple V2 texture-source binder — `08998d0` (2026-08-14)

## Scope and provenance

Remote M3 Max task `01a00127-b749-7021-bb08-a8b1485773df` implemented the
bounded Apple V2 CPU texture-source binder from the registered worktree
`/private/tmp/acgc-lane-v2-texture-source-binder-m3` on branch
`c1/lane-v2-texture-source-binder-m3`.

- Base: `a96f3586587976b489cbd8045c92f7c9e6a4dc8a`
- Worker final: `08998d0bd3ab9e9159ab8828eaaccdc43b9c2ff2`
- PC crosswalk: `PCGXTextureSource`, `pc_gx_get_v2_texture_source`, GX texture
  generator/TEV state in `ACGC-PC-Port`
- Decomp crosswalk: `GXTexObj`, `GXTexGen`, and GX TEV state in
  `ac-decomp` `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`; no decomp-side
  source-metadata counterpart exists

The source-only commit changes exactly four Apple files:

- `pc/apple/include/acgc/metal_packet_consumer.h`
- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/src/pc_metal_runtime.c`
- `pc/apple/tests/test_metal_packet_consumer_v2_runtime_sideband.c`

No packet-builder, decomp, shader, sink, device, ISO, or asset files changed.

## What is proven

The Apple V2 CPU seam now synchronously queries the PC-owned texture-source
metadata for each validated generator/stage map, checks source kind, pointer
alignment, dimensions, format, image/TLUT sizes, sampler fields, and generation,
then re-queries the borrowed record after CPU fixture decode. Any provider,
metadata, or generation/lifetime mismatch fails closed. The existing synthetic
fixture path and `V2_EXTENSION_NOT_RENDERED` boundary remain intact. No source
bytes are copied or retained beyond the synchronous handoff.

## Verification

Both configurations used the exact worker worktree and `--parallel 1`:

```sh
cmake -S /private/tmp/acgc-lane-v2-texture-source-binder-m3/pc/apple \
  -B /private/tmp/acgc-lane-gx-texture-binder-m3/native \
  -G 'Unix Makefiles' -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DCMAKE_OBJC_COMPILER=/usr/bin/clang

cmake --build /private/tmp/acgc-lane-gx-texture-binder-m3/native \
  --target acgc_renderer_fixture_tests \
  acgc_metal_packet_consumer_v2_texture_tev_tests \
  acgc_metal_packet_consumer_v2_runtime_sideband_tests --parallel 1

ctest --test-dir /private/tmp/acgc-lane-gx-texture-binder-m3/native \
  --output-on-failure --parallel 1 -R \
  'acgc_(renderer_fixture_tests|metal_packet_consumer_v2_texture_tev_tests|metal_packet_consumer_v2_runtime_sideband_tests)'
```

The same configure/build/test sequence was repeated in the sanitized root
`/private/tmp/acgc-lane-gx-texture-binder-m3/sanitized` with
`-fsanitize=address,undefined -fno-omit-frame-pointer` and:

```sh
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 ctest ... --parallel 1
```

The focused native matrix passed `3/3`; the combined ASan/UBSan matrix passed
`3/3`; no compiler or sanitizer diagnostics were reported. The worker source
worktree was clean after the commit. The integrated local snapshot was then
re-run in `/private/tmp/acgc-integrate-v2-texture-binder-native` and
`/private/tmp/acgc-integrate-v2-texture-binder-asan`, with native `3/3` and
combined ASan/UBSan `3/3` passing and no diagnostics.

## Claim boundary and next gate

This is CPU/contract evidence only. It does not prove a full `ac_pc` link,
launch, live game callback, Metal encode/present, device availability, pixel
readback, input, audio, save/load, simulator, or playability. The next gate is
one separately serialized current-tip runtime trace after root review; no
second full link or LLDB launch is opened by this lane.
