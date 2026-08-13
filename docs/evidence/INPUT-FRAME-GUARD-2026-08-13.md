# Game-owned input frame guard

Date: 2026-08-13 HST

The source/test handoff is branch `c1/input-frame-guard` at worker commit
`799a016`, based on PC `f4cb491`. It was reviewed and cherry-picked into the
canonical `c1/macos-host-launch` branch as `59aa655` on top of the integrated
Apple Metal sink. The decomp crosswalk is `09ca8e8b`.

## Scope and crosswalk

Only these PC files changed:

- `pc/tests/pc_padmgr_frame_guard_fixture.c`
- `pc/CMakeLists.txt`

The fixture links the production `src/padmgr.c` and owns a deterministic
`PADRead` seam. PC `game_get_controller()` requests `padmgr_RequestPadData()`;
the production manager applies the `pc_frame_counter` once-per-frame guard
before polling and copying controller state. The decomp path retains the same
request/copy shape through `JUTGamePad::read()` and `m_controller.c`, without
the PC host's inline polling guard.

## Proof

On the integrated `59aa655` checkout:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-input-frame-guard-59aa655-native \
  -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-input-frame-guard-59aa655-native \
  --target acgc_pc_padmgr_frame_guard_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-input-frame-guard-59aa655-native \
  --output-on-failure -R '^acgc_pc_padmgr_frame_guard_fixture$'
```

Native CTest: `1/1` passed. The same target under combined ASan/UBSan in
`/private/tmp/acgc-integrate-input-frame-guard-59aa655-asan` passed `1/1` with
no sanitizer diagnostics using `detect_leaks=0`; Apple leak detection is not
supported by this runtime and was disabled for the passing run.

The fixture proves that frame `N` performs one `PADRead`, exposes the expected
`last`/`now`/`on`/`off` values, a second request in the same frame leaves that
state byte-identical, and frame `N+1` performs exactly one new read and
advances the release transition. It does not prove OS/human input, a physical
controller, game-state change in a full launch, audio, Metal, save/load, or
playability.
