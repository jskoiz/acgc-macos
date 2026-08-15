# M3 Max Metal-device fixtures at `251a010b8`

Date: 2026-08-14

Remote M3 Max task: `019fff43-def1-7bd2-8e1a-f7e72a6aac5b`

References:

- detached PC base/final: `251a010b8d6167d7dd90042934d8491d1c96b040`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- worktree: `/private/tmp/acgc-lane-current-metal-device-fixtures`
- native root: `/private/tmp/acgc-lane-current-metal-device-fixtures-build`
- sanitizer root: `/private/tmp/acgc-lane-current-metal-device-fixtures-build-asan`

No source, documentation, ref, full-game build, asset, or proprietary input was
changed or accessed by this verification-only lane.

## Device and native result

The lane queried the ordinary Metal device class without recording a hardware
identifier:

```sh
swift -e 'import Metal; if let d = MTLCreateSystemDefaultDevice() { print("device=\(d.name)"); print("lowPower=\(d.isLowPower) removable=\(d.isRemovable) unified=\(d.hasUnifiedMemory)") } else { print("device=NONE") }'
```

The available device reported as `Apple M3 Max` with unified memory. The
existing Apple fixture set was then configured and built serially:

```sh
cmake -S pc/apple \
  -B /private/tmp/acgc-lane-current-metal-device-fixtures-build \
  -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON

cmake --build /private/tmp/acgc-lane-current-metal-device-fixtures-build \
  --target acgc_renderer_geometry_tests \
           acgc_renderer_geometry_cpp_tests \
           acgc_renderer_fixture_tests \
           acgc_metal_state_fixture_tests \
           acgc_metal_packet_consumer_tests \
           acgc_metal_sink_tests \
           acgc_metal_packet_consumer_v2_texture_tev_tests \
           acgc_metal_packet_consumer_v2_runtime_sideband_tests \
           acgc_metal_packet_consumer_v2_channel_source_tests \
  --parallel 1

ctest --test-dir /private/tmp/acgc-lane-current-metal-device-fixtures-build \
  --output-on-failure --parallel 1 \
  -R '^(acgc_renderer_geometry_tests|acgc_renderer_geometry_cpp_tests|acgc_renderer_fixture_tests|acgc_metal_state_fixture_tests|acgc_metal_packet_consumer_tests|acgc_metal_sink_tests|acgc_metal_packet_consumer_v2_texture_tev_tests|acgc_metal_packet_consumer_v2_runtime_sideband_tests|acgc_metal_packet_consumer_v2_channel_source_tests)$'
```

Result: `9/9` selected tests passed, with no skip or failure. All nine built
executables were separately observed returning zero with `PASS` output, but
the exact direct-invocation command text was not retained and is not
reconstructed here.

The device-backed state and packet-consumer fixtures compiled their embedded
MSL and completed offscreen command buffers. The Metal sink fixture completed
synchronous offscreen command buffers and passed its existing readback-count,
nonzero-checksum, opaque-pixel, and deterministic repeated-pixel/checksum
assertions.

## Offline shader compilation

Read-only extraction of the three existing embedded shader literals was fed to
these commands:

```sh
xcrun metal --version
xcrun metal -x metal -c \
  -o /private/tmp/acgc-lane-current-metal-device-fixtures-build/acgc_metal_sink_shader.air -
xcrun metal -x metal -c \
  -o /private/tmp/acgc-lane-current-metal-device-fixtures-build/acgc_metal_state_fixture_shader.air -
xcrun metal -x metal -c \
  -o /private/tmp/acgc-lane-current-metal-device-fixtures-build/acgc_metal_packet_consumer_shader.air -
```

All three offline compilations passed with no diagnostic. The AIR output stayed
under the ignored build root.

## Combined ASan/UBSan result

The six CPU-compatible fixtures were configured separately:

```sh
cmake -S pc/apple \
  -B /private/tmp/acgc-lane-current-metal-device-fixtures-build-asan \
  -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON \
  -DCMAKE_C_FLAGS="-fsanitize=address,undefined -fno-omit-frame-pointer -g" \
  -DCMAKE_CXX_FLAGS="-fsanitize=address,undefined -fno-omit-frame-pointer -g" \
  -DCMAKE_EXE_LINKER_FLAGS="-fsanitize=address,undefined"

cmake --build /private/tmp/acgc-lane-current-metal-device-fixtures-build-asan \
  --target acgc_renderer_geometry_tests \
           acgc_renderer_geometry_cpp_tests \
           acgc_renderer_fixture_tests \
           acgc_metal_packet_consumer_v2_texture_tev_tests \
           acgc_metal_packet_consumer_v2_runtime_sideband_tests \
           acgc_metal_packet_consumer_v2_channel_source_tests \
  --parallel 1

ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
ctest --test-dir /private/tmp/acgc-lane-current-metal-device-fixtures-build-asan \
  --output-on-failure --parallel 1 \
  -R '^(acgc_renderer_geometry_tests|acgc_renderer_geometry_cpp_tests|acgc_renderer_fixture_tests|acgc_metal_packet_consumer_v2_texture_tev_tests|acgc_metal_packet_consumer_v2_runtime_sideband_tests|acgc_metal_packet_consumer_v2_channel_source_tests)$'
```

Result: `6/6` passed with no ASan/UBSan diagnostic. The earlier
`detect_leaks=1` attempt produced the expected macOS platform message that leak
detection is unsupported, so this is not a leak-free claim.

## Evidence boundary

This closes a useful hardware question: on the remote M3 Max, the existing
synthetic fixtures can compile their shaders, execute offscreen Metal work, and
read back deterministic fixture pixels. It does **not** prove a cumulative
game snapshot, a live game callback, a game-owned Metal encode, window
presentation, a game-owned pixel, input, audible audio, save/reload, iOS, or
playability. The next rendering proof still requires the renderer-neutral
cumulative producer and typed Apple consumer to carry a real game-owned draw
through encode, present, and readback as separately recorded gates.
