# Bounded graph terminator fixture — integrated edc323ea

Date: 2026-08-13 (Honolulu)

## Scope and provenance

The remote M3 Max test-only lane started from PC
`a53b192247aab2c4f6e58b1f2dda41efdf8d1cad` on
`c1/lane-graph-terminator-fixture-m3` and returned
`b3c7a9d52b2cb12d0ce8ec5293f55c31ebad2dac`. The integration owner
cherry-picked it onto canonical `c1/macos-host-launch`, producing `edc323ea`.
The only changed files are `pc/tests/pc_graph_terminator_fixture.c` and its
`pc/portable/CMakeLists.txt` registration. The ac-decomp reference was
`master` at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

## Two-upstream crosswalk

The PC `emu64::dl_G_DL`/`graph_submission.c` path resolves opaque registry
targets and classifies exact `DF000000,0` termination. Indirect G_DL/branch
commands are classified separately, and an eight-word capture becomes
`PREFIX_ONLY` when the terminator lies beyond the snapshot. The decomp
`dl_G_DL`, `emu64_taskstart_r`, and `dl_G_ENDDL` implement segmented target
resolution, push/no-push stack behavior, command dispatch, and end/pop
semantics. Decomp callers include `graph_task_set00`, `graph.c`,
`initial_menu.c`, and `dvderr.c`. There is no decomp counterpart for the PC
opaque registry identity or bounded observer classifier.

## Verification

The fixture is registered in the portable subproject, whose test block is only
instantiated when it is configured standalone. The first umbrella-superproject
target lookup correctly reported no target; this was not treated as a source
failure. The integrated snapshot was then configured directly from the
portable subproject:

```text
cmake -S upstream/ACGC-PC-Port/pc/portable -B /private/tmp/acgc-integrated-graph-terminator-edc323ea-standalone-native -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 -DBUILD_TESTING=ON -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
cmake --build /private/tmp/acgc-integrated-graph-terminator-edc323ea-standalone-native --target acgc_pc_graph_terminator_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrated-graph-terminator-edc323ea-standalone-native --output-on-failure --parallel 1 -R '^acgc_pc_graph_terminator_fixture$'
```

Native result: `1/1` passed. The same target was built in
`/private/tmp/acgc-integrated-graph-terminator-edc323ea-standalone-asan` with
`-fsanitize=address,undefined -fno-omit-frame-pointer` and run with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; sanitizer result: `1/1`
passed with no diagnostics. Leak detection is disabled on this Apple runtime.
`git diff --check` passed.

The synthetic 12-word arena proves `COMPLETE`, `PREFIX_ONLY`, `UNTERMINATED`,
and `MALFORMED` classification only. No full `ac_pc` link, LLDB, live graph
traversal, GX draw, frame, Metal, pixel, input, audio, save/device,
simulator, physical-device, or playability claim follows. The remote
worktree/roots are retired only after holder-free checks; branch and commit
remain preserved. No ISO, ROM, or extracted asset was accessed or transferred.
