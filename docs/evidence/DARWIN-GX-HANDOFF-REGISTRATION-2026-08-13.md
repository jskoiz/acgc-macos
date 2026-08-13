# Darwin GX handoff registration — 2026-08-13

## Scope

This handoff integrates the bounded Apple-only registration slice from
`c1/lane-darwin-gx-registration` into the canonical PC source. It makes the
existing synchronous `pc_gx_flush_vertices()` callback reach the existing CPU
packet consumer on Apple builds, while preserving the legacy OpenGL draw path.
It does not add Metal objects or claim a rendered frame.

## Revisions

- PC lane base: `c1/macos-host-launch` at `36910c8a9e3abbc013b39978fe52022b933aff01`.
- Lane commit: `9174404b7864bb69ea1a6a4ff67e5c22afadc03b`.
- Integrated canonical PC: `c1/macos-host-launch` at `f4cb491` (`Register Apple GX packet consumer bridge`).
- Reference decomp: `master` at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

## Changed source

- `pc/apple/include/acgc/pc_metal_runtime.h` and
  `pc/apple/src/pc_metal_runtime.c` own fixed storage and saturating atomic
  handoff/accepted/rejected/status counters.
- `pc/src/pc_main.c` registers the borrowed consumer after `pc_gx_init()` and
  clears the GX callback before platform teardown.
- `pc/CMakeLists.txt` includes the Apple consumer/fixture sources only in the
  Apple `ac_pc` graph and leaves Windows source/link inputs unchanged.
- `pc/src/pc_gx.c` now distinguishes resident-but-inactive GL texture objects
  from active texture-coordinate/map state. Active texture, TEV, lighting, fog,
  and other unsupported state still fails closed.
- `pc/tests/pc_gx_semantic_handoff.c` covers registration lifecycle, status
  counters, inactive resident textures, active texture rejection, and the
  existing unsupported-state cases.

The bridge never allocates or retains Metal objects, command buffers, textures,
or borrowed packet output. Consumer rejection remains observable and
`pc_gx_flush_vertices()` always continues through OpenGL.

## Verification

On the integrated `f4cb491` checkout:

```text
cmake -S pc -B /private/tmp/acgc-integrated-darwin-gx-registration-f4cb491 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrated-darwin-gx-registration-f4cb491 \
  --target acgc_pc_gx_semantic_handoff_tests -j1
ctest --test-dir /private/tmp/acgc-integrated-darwin-gx-registration-f4cb491 \
  -R '^acgc_pc_gx_semantic_handoff_tests$' --output-on-failure
```

Result: configure and focused build passed; CTest `1/1` passed. A matching
integrated ASan/UBSan build under
`/private/tmp/acgc-integrated-darwin-gx-registration-f4cb491-asan`, with
`ASAN_OPTIONS=detect_leaks=0` and `UBSAN_OPTIONS=halt_on_error=1`, also passed
`1/1` with no sanitizer diagnostics. Production-rule object compilation for
`pc_main.c`, the bridge, and the existing consumer/fixture sources passed.
AppleClang emitted the existing warning for the GCC-only warning suppression
and legacy decomp macro redefinitions; no build or test failed.

## Evidence boundary

This proves Apple production registration and CPU packet-consumer reachability
as a source/test seam, plus fail-closed state handling. It does not prove that
a live game draw invokes the callback, and it does not prove Metal encoding,
command-buffer completion, presentation, pixel readback, input, audible audio,
save/reload, device behavior, clean shutdown of the full game, or playability.
The next bounded gate is one serialized current-tip `ac_pc` LLDB run with a
breakpoint on `pc_metal_runtime_observe` (or equivalent status observation),
without changing packet v1 or adding a renderer in that lane.

No ISO, extracted asset, key, or proprietary game data was copied or committed.
