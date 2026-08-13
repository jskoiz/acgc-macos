# Live GX-to-Metal callback seam (2026-08-13)

This source lane is integrated into authoritative PC
`c1/macos-host-launch` at `ac39d04` (`Bind validated GX packets to Apple
runtime callback`), from lane commit `1dec37f` based on `9cf9b3f`. The matching
decomp reference is `09ca8e8b`; the preceding Save_t test-only integration is
`d0e64f5`.

## Scope and ownership

The Apple side now owns one synchronous callback slot for a validated GX packet.
The callback, context, and output are borrowed for the call; registration,
replacement, and unregister are explicit; unsupported consumer output is
reported with a null output; and `pc_gx_shutdown()` clears the borrowed pair.
The legacy OpenGL flush remains the primary path and still runs after the
optional observer. No allocation, retention, disposal, Windows routing, or GL
behavior was changed.

The crosswalk remains deliberate: ac-decomp traverses N64 display lists and
emits GX commands through immediate FIFO-style GXBegin/GXEnd behavior, while
the PC port defers vertices and invokes this observer at
`pc_gx_flush_vertices()` before legacy GL state mutation.

## Exact integrated verification

Native PC focused target:

```text
cmake -S pc -B /private/tmp/acgc-integrate-live-gx-ac39d04 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-live-gx-ac39d04 \
  --target acgc_pc_gx_semantic_handoff_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-live-gx-ac39d04 \
  --output-on-failure -R acgc_pc_gx_semantic_handoff_tests
```

Result: PASS. The test covers complete-triangle routing, fail-closed quad
rejection with null output, callback replacement, unregister, and GL fallback
preservation.

Native Apple targets from `/private/tmp/acgc-integrate-live-gx-apple-ac39d04`
also passed the legacy seam test. Packet-consumer and state-fixture CPU
contracts passed and returned the declared device skip `77` because this host
has no macOS Metal device.

The paired ASan/UBSan roots
`/private/tmp/acgc-integrate-live-gx-ac39d04-asan` and
`/private/tmp/acgc-integrate-live-gx-apple-ac39d04-asan` passed the PC target
and Apple CPU contracts with `ASAN_OPTIONS=detect_leaks=0` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; the two device portions
again returned `77`.

## Evidence boundary

This proves a safe, synchronous callback seam and its CPU/fail-closed tests.
No full `ac_pc` link was run at `ac39d04`; no live game callback, Metal encode,
present, pixel readback, input, audio, save/load, simulator/device behavior,
or playability claim follows.
