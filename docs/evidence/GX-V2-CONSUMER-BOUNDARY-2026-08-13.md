# GX v2 consumer boundary evidence — 2026-08-13

## Scope and refs

This lane adds the smallest version-aware consumer boundary for the bounded
GX v2 packet. It started from canonical PC `26da235` on
`c1/macos-host-launch` and decomp `09ca8e8b` on `master`. The worker branch
`c1/lane-versioned-gx-v2-consumer` produced `cd881b7`; after review that
commit was integrated into canonical PC as `d1e812c` (`Add versioned GX v2
consumer handoff`).

The two-upstream crosswalk remains the packet contract map: decomp `emu64`
GX state and display-list semantics are the original-behavior reference, while
the PC port's `pc_gx.c` and Apple packet consumer own the host callback
boundary. No decomp source or proprietary asset was changed.

## Implementation boundary

The integrated change touches exactly six PC files:

- `pc/src/pc_gx.c`
- `pc/apple/include/acgc/metal_packet_consumer.h`
- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/src/pc_metal_runtime.c`
- `pc/tests/pc_gx_semantic_v2_handoff.c`
- `pc/CMakeLists.txt`

The existing v1 callback remains isolated and unchanged in behavior. A
separately typed v2 callback validates the complete v2 packet, prepares only
the bounded v1-compatible base geometry for the Apple consumer, and reports
`V2_EXTENSION_NOT_RENDERED` rather than fabricating texture, TLUT, sampler, or
TEV rendering. Invalid version, unsupported fog, and reserved TEV state fail
closed before the callback. Runtime registration and shutdown clear the v2
callback independently from v1.

## Integrated verification

All commands below ran from the exact integrated checkout
`/Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port` at
`d1e812c`. No full `ac_pc` link or LLDB launch was run in this lane.

Native focused build and tests used
`/private/tmp/acgc-integrate-gx-v2-consumer-d1e812c-native`:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-gx-v2-consumer-d1e812c-native -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON
cmake --build /private/tmp/acgc-integrate-gx-v2-consumer-d1e812c-native \
  --target acgc_pc_gx_semantic_handoff_tests \
           acgc_pc_gx_semantic_v2_handoff_tests \
           acgc_gx_semantic_packet_tests \
           acgc_gx_semantic_packet_cpp_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-gx-v2-consumer-d1e812c-native \
  --output-on-failure \
  -R '^(acgc_pc_gx_semantic_handoff_tests|acgc_pc_gx_semantic_v2_handoff_tests|acgc_gx_semantic_packet(_cpp)?_tests)$'
```

Result: 4/4 tests passed.

ASan/UBSan used the same targets and separate root
`/private/tmp/acgc-integrate-gx-v2-consumer-d1e812c-asan`, with
`-fsanitize=address,undefined -fno-omit-frame-pointer` for C, C++, Objective-C,
and executable linking. Under
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1`, 4/4 tests passed with no sanitizer
diagnostics. `git diff --check` passed and the integrated PC checkout is
clean.

## Claims and next gate

This proves a bounded CPU-side version-aware callback/consumer boundary,
preserves the v1 route, and proves fail-closed v2 acceptance/rejection. It
does not prove a game-owned v2 callback, Metal encode/present/readback, a
pixel, input, audible audio, save/device persistence, simulator/device
behavior, clean playability, or a full game link.

The next bounded gate is one serialized current-tip runtime trace to determine
whether the game-owned `pc_gx_flush_vertices` path reaches the v2 callback.
That trace must keep callback reachability separate from subsequent Metal
encode/readback/pixel proof.
