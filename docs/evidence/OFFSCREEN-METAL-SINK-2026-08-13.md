# Offscreen Metal packet sink — 2026-08-13

## Integration

Lane 74 (`019ffbc8-1f2b-7513-9c1c-7ddde5114f97`) supplied PC-submodule commit
`d7facdd` based on `f4cb491`. After review, it was cherry-picked into the
canonical `c1/macos-host-launch` branch as `54b840c` (`Add bounded Apple Metal
packet sink`). The umbrella gitlink now points to `54b840c`; `ac-decomp`
remains `09ca8e8b`.

The commit adds seven Apple-only paths: `pc/CMakeLists.txt`,
`pc/apple/CMakeLists.txt`, `pc/apple/include/acgc/metal_sink.h`,
`pc/apple/include/acgc/pc_metal_runtime.h`, `pc/apple/src/metal_sink.m`,
`pc/apple/src/pc_metal_runtime.c`, and `pc/apple/tests/test_metal_sink.m`.

## Behavior

The sink owns a Metal device/queue, bounded 64×64 RGBA8/depth targets,
pipeline setup from the existing semantic packet/state contract, synchronous
command-buffer completion, center-pixel readback, and an FNV-1a checksum. The
C-facing API is value-only with atomic counters/status and no retained guest
pointers. Runtime initialization/shutdown is idempotent and the existing
OpenGL path remains unconditional.

## Integrated verification

On the exact integrated canonical source, the production Apple configure and
the `acgc_pc_gx_semantic_handoff_tests` target built with Ninja and CTest
passed `1/1` under `/private/tmp/acgc-integrate-metal-sink-54b840c`. The
Apple-only entrypoint also built `acgc_metal_sink_tests` under
`/private/tmp/acgc-integrate-metal-sink-54b840c-apple`; its CPU contract passed
and its device portion was declared skip `77` because
`MTLCreateSystemDefaultDevice()` is unavailable on this host. The worker's
ASan/UBSan-configured sink test passed the same CPU contract and skip path.
Production `metal_sink.m` and `pc_metal_runtime.c` object compilation passed
with Objective-C/ARC and Metal framework wiring.

## Evidence boundary

This is an integrated renderer implementation and CPU/build/device-gate proof.
There is no command-buffer-completed/readback result on this host, and no live
game callback, game-owned Metal frame, pixel, input, audio, save/load,
simulator, device, or playability claim follows. A later device-backed lane
must run the sink test and a current-tip game callback before any frame claim.
