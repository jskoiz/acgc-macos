# Graph indirect-target contract — 2026-08-13

This source/test handoff is from visible task
`019ffaad-ca28-7c62-bd0f-0176ceb55e52`. The reviewed PC lane commit
`e501d4b21abdf425e663cd1a6475a5f375f00f93` was integrated into the authoritative
`c1/macos-host-launch` branch as `71a701299e9a612c295b29986bf16b44ad25a2c7`.
The decomp reference remains `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

## Narrow implementation

The graph submission contract now has a fixed-width, pointer-free target
capture. It retains only the opaque F-handle identity, declared target
capacity, classification, terminator index, and bounded words. It accepts at
most the `sys_dynamic.new0` bound of 1024 `uint32_t` words, traverses only the
caller-declared span, and requires the exact `DF000000,0` terminator. A target
terminator outside the copied eight-word snapshot is downgraded to
`PREFIX_ONLY`; native pointers are never retained.

Changed PC files:

- `include/acgc/graph_submission.h`
- `src/graph_submission.c`
- `pc/portable/CMakeLists.txt`
- `pc/portable/tests/test_graph_indirect_target.c`

The fixture uses separate `sys_dynamic.work` and `sys_dynamic.new0` arrays,
verifies `DE010000,F0002000`, live registry resolution and stale-handle
invalidation, explicit capacities, exact terminator handling, malformed and
unterminated spans, and oversized rejection.

## Integrated verification

Against the exact integrated source `71a7012`, native and ASan/UBSan focused
builds under `/private/tmp/acgc-integrate-graph-target-71a7012-native` and
`/private/tmp/acgc-integrate-graph-target-71a7012-asan` each pass:

```text
acgc_graph_indirect_target_tests
acgc_gbi_runtime_tests
acgc_emu64_seg2k0_tests
```

Result: **3/3 passed** in each matrix. ASan used
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1`; UBSan used
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; no sanitizer diagnostics
were reported.

## Evidence boundary

This proves the bounded target-resolution contract and focused fixtures. It
does not prove that the live game emitted a complete target list, a draw,
GX/Metal encode, present, pixel readback, input, audio, save/load, simulator,
device behavior, or playability.
