# Opt-in live target observer — 2026-08-13

## Scope and source identities

Lane 67 implemented the smallest host-side wiring needed to observe the live
indirect display-list target discovered by lanes 65–66. The source lane started
from `ACGC-PC-Port` `c1/macos-host-launch` at
`aea35157f3175512c7643e9f32b09b68c2e05b22` and `ac-decomp` `master` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

The reviewed source commit is `f25d717703db2f393da48da17838ee7f7ab9b107`
(`Install opt-in live target capture observer`). It changes only
`upstream/ACGC-PC-Port/pc/src/pc_main.c`. After review, the commit was
cherry-picked into the canonical PC branch as `36910c8a9e3abbc013b39978fe52022b933aff01`.

## Implementation

The existing Apple-only `pc_enable_graph_submission_capture()` path already
installed the root `GraphTaskSubmissionCapture` callback when
`getenv("ACGC_GRAPH_CAPTURE")` was present. The lane adds a sibling
`GraphTaskSubmissionTargetCapture` callback and installs it under that same
gate. The callback logs the fixed-width target identity, capacity, captured
word count, classification, terminator index, and bounded words, then clears
itself after the first target record.

The implementation reuses the existing API rather than adding a parser or a
second address model:

- `upstream/ACGC-PC-Port/include/acgc/graph_submission.h` — target-capture
  callback type, setter, clear function, and fixed-width record.
- `upstream/ACGC-PC-Port/src/graph_submission.c` — callback storage and
  `graph_capture_task_submission_target()` invocation after bounded registry
  resolution.
- `upstream/ACGC-PC-Port/pc/src/pc_main.c` — Apple-only opt-in installation.
- `upstream/ac-decomp/src/game.c:81` and `src/graph.c:44,54–62,137` — original
  graph construction and `sys_dynamic.new0` arena ownership.
- `upstream/ac-decomp/include/PR/gbi.h:1027,1822–1823` — `G_DL_NOPUSH`
  branch semantics used by the live continuation.

Because the new code remains inside `#ifdef __APPLE__` and the existing
environment-variable gate, the default path and Windows behavior are
unchanged.

## Integrated verification

All checks below ran after the source commit was integrated at `36910c8` and
used unique roots under `/private/tmp/acgc-integrate-live-target-observer`:

```text
cmake -S pc -B /private/tmp/acgc-integrate-live-target-observer/native -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

Configured successfully. The focused host object compile passed:

```text
ninja -C /private/tmp/acgc-integrate-live-target-observer/native \
  CMakeFiles/ac_pc.dir/src/pc_main.c.o
```

Only the existing AppleClang/decomp warnings were emitted; no full `ac_pc`
link was run.

The existing live-target fixture passed natively:

```text
cmake -S pc/portable -B /private/tmp/acgc-integrate-live-target-observer/fixture-native \
  -G Ninja -DBUILD_TESTING=ON
ninja -C /private/tmp/acgc-integrate-live-target-observer/fixture-native \
  acgc_pc_live_graph_target_capture_fixture
ctest --test-dir /private/tmp/acgc-integrate-live-target-observer/fixture-native \
  -R '^acgc_pc_live_graph_target_capture_fixture$' --output-on-failure
```

Result: `1/1` passed. The same fixture under combined ASan/UBSan also passed
`1/1` with no sanitizer diagnostics using the corresponding
`fixture-asan-ubsan` root.

## Evidence boundary and next gate

This proves the target-capture callback type, Apple host wiring, and existing
bounded `F0002000` resolver fixture at the integrated source tip. It does not
prove that a full game launch emits `[GRAPH_TARGET_CAPTURE]`; that requires a
serialized full `ac_pc` link and a fresh local runtime/LLDB launch with the
legally obtained ignored ISO. It also does not prove a complete display list,
Metal encode/present, pixel readback, input, audible audio, save/load,
clean-shutdown, simulator/device, or human playability.
