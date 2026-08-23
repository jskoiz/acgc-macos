# Cumulative GX flush integration — `1c8781d76` — 2026-08-23

## Outcome

PC PR [#14](https://github.com/jskoiz/ACGC-PC-Port/pull/14), **Wire
cumulative gatherer into GX flush**, is merged on `c1/macos-host-launch` as
`1c8781d762cdbd202aa9d388c62d112d290553c8`. The authoritative merge contains
the source commit `c2f557e3430d169a0f7cab367c1f53cfa9e89b9b` and lifecycle/reentrancy
corrective child `a986c7007fa4b10124642d79173eb766857160dc` on parent
`d6a22182b2aebdab5da06e3b874788097af0f010`.

The merge calls the existing lease-owning fourteen-section gatherer once from
`pc_gx_flush_vertices`, immediately after completed Geometry capture. It
removes the older live Texture/Dynamic-only publication from that seam while
preserving subsequent fixture observers, semantic handoffs, and the unchanged
legacy GL path. Publication remains fail closed: a missing callback or any raw
producer, dependency, lease, encoder, revalidation, or assembly failure emits
no cumulative callback.

## Immutable scope

The exact `d6a22182b..1c8781d76` PC diff is four files, 696 insertions and four
deletions:

- `pc/CMakeLists.txt` — focused source-backed fixture executable and CTest
  registration;
- `pc/include/pc_gx_cumulative_gatherer.h` — synchronous callback lifetime and
  explicit read-only/non-reentrant consumer contract;
- `pc/src/pc_gx.c` — aligned file-static snapshot storage, lifecycle reset,
  guarded single gather attempt, callback cleanup, and older publication
  removal; and
- `pc/tests/pc_gx_cumulative_gatherer_flush_fixture.c` — real
  `GXBegin`/`GXEnd` flush-path coverage.

The fixture proves one cumulative callback per successful completed-Geometry
flush, a valid pointer-free envelope while the Texture/TLUT borrow is active,
older Texture/Dynamic callback suppression, callback-time nested-gather and
registration/clear rejection, callback-time lifecycle no-op behavior, normal
lifecycle callback/context clearing, fail-closed gather failure, and continued
observer/semantic ordering. No Apple or renderer source changed.

The PC repository has no hosted workflow at this tip. GitHub reports PR #14 as
merged with no status-check or review rollup; the verification below is local
exact-merge evidence.

## Lifecycle correction

Independent review of the first source commit found three P1 hazards: callback
and context could survive a normal GX lifetime, lifecycle reset could destroy
live envelope/storage while the callback was running, and the callback contract
did not forbid GX reentry. Corrective child `a986c7007` closes them by:

- clearing callback and context before resetting cumulative storage on normal
  initialization/shutdown;
- making initialization/shutdown return before state or GL cleanup while a
  cumulative gather or Texture/TLUT borrow is active;
- documenting the callback as a synchronous read-only, non-reentrant consumer
  that may copy the envelope but may not call GX lifecycle/state/submission,
  begin/end/flush, callback registration/clear, or nested gather APIs; and
- exercising attempted lifecycle reentry inside the callback and proving the
  live envelope and guard are unchanged, then proving a normal later lifecycle
  clears stale callback state.

The final two-commit chain passed independent re-review with no P0, P1, or P2
finding before PR creation and merge.

## Reference crosswalk

Host/Windows oracle and implementation:

- `pc/src/pc_gx.c`: `pc_gx_flush_vertices`, completed raw Geometry capture,
  callback ownership, fixture/semantic handoffs, and legacy GL continuation;
- `pc/include/pc_gx_cumulative_gatherer.h` and
  `pc/src/pc_gx_cumulative_gatherer.c`: synchronous envelope-only callback,
  one Texture/TLUT borrow, all-section production/encoding/assembly, final
  revalidation, and release;
- `pc/include/pc_gx_texture_raw_state.h` and `pc/src/pc_gx_texture.c`:
  exact-token borrow ownership and guarded mutation; and
- `pc/CMakeLists.txt`: production GX object membership and focused fixture gate.

Original-behavior/wire-layout oracle is `upstream/ac-decomp` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`:

- `src/static/dolphin/gx/GXAttr.c`, `GXGeometry.c`, and `GXVert.c` cover VCD/VAT,
  array state, dirty-state ordering, `GXBegin`, and typed vertex FIFO emission;
- `GXTransform.c`, `GXLight.c`, `GXTexture.c`, `GXTev.c`, `GXPixel.c`, and
  `GXBump.c` cover the original Transform, Channels/Lighting, Texture/TLUT,
  TEV/Alpha, Blend/Depth/Fog/Raster, and Indirect setter semantics; and
- the host cumulative envelope, Texture/TLUT lease, callback, and CMake fixture
  have no decomp counterpart. Decomp is the guest semantic oracle, not a source
  for these host ownership mechanisms.

## Exact merged-tip focused verification

Authoritative source:

```text
/private/tmp/acgc-integrator-flush-merged
HEAD 1c8781d762cdbd202aa9d388c62d112d290553c8
status: detached and clean
```

Fresh native root:

```bash
cmake -S /private/tmp/acgc-integrator-flush-merged/pc \
  -B /private/tmp/acgc-flush-merged-native-20260823 \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON

cmake --build /private/tmp/acgc-flush-merged-native-20260823 \
  --target acgc_pc_gx_production \
           acgc_pc_gx_cumulative_gatherer_flush_fixture \
  --parallel 1

ctest --test-dir /private/tmp/acgc-flush-merged-native-20260823 \
  -N -R '^acgc_pc_gx_cumulative_gatherer_flush_fixture$'

ctest --test-dir /private/tmp/acgc-flush-merged-native-20260823 \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_cumulative_gatherer_flush_fixture$'
```

Results: configuration passed; the serialized 59-step focused build passed;
CTest discovered exactly test #38; the exact test passed `1/1` in 0.01 seconds.

Fresh combined ASan/UBSan root:

```bash
cmake -S /private/tmp/acgc-integrator-flush-merged/pc \
  -B /private/tmp/acgc-flush-merged-asan-ubsan-20260823 \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer -O1' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'

cmake --build /private/tmp/acgc-flush-merged-asan-ubsan-20260823 \
  --target acgc_pc_gx_production \
           acgc_pc_gx_cumulative_gatherer_flush_fixture \
  --parallel 1

ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
ctest --test-dir /private/tmp/acgc-flush-merged-asan-ubsan-20260823 \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_cumulative_gatherer_flush_fixture$'
```

Results: configuration passed; the serialized 59-step focused build passed;
CTest discovered exactly test #38; the exact test passed `1/1` in 0.08 seconds.
`LastTest.log` contained no AddressSanitizer, UndefinedBehaviorSanitizer,
runtime-error, `ERROR`, or `FAILED` diagnostic. Both caches identify the exact
merged source directory and requested flags.

## Exact merged-tip production link

The native exact-merge root then ran the serialized production link:

```bash
cmake --build /private/tmp/acgc-flush-merged-native-20260823 \
  --target ac_pc --parallel 1
```

All 4,025 planned steps passed. The result is a 15,177,520-byte arm64 Mach-O:

```text
bin/AnimalCrossing: Mach-O 64-bit executable arm64
_pc_gx_set_cumulative_snapshot_callback
_pc_gx_clear_cumulative_snapshot_callback
_pc_gx_cumulative_snapshot_gather
_pc_gx_cumulative_snapshot_assemble
```

The linker emitted only the inherited `__DATA,__common` maximum-alignment
reduction warning. The Xcode hygiene dry-run completed with 651 candidates,
zero potential KiB, and zero errors; no cleanup was applied.

## Evidence boundary

This proves exact-merge source/CMake integration, focused native and combined
ASan/UBSan behavior, one source-backed publication attempt at the real
completed-Geometry flush seam, guarded callback/lifecycle behavior, continued
legacy ordering in the fixture, and production link/symbol availability.

It does **not** prove a process launch, that a real game execution successfully
produces all fourteen sections, a callback observed in a real inferior, Apple
parser or CPU-plan consumption, Metal encode/present/readback, pixels, device
behavior, input, audio, save/reload, normal end-to-end teardown, iOS, or human
playability. The next dependency-ready source gate is the pure-C typed Apple
canonical CPU plan; a later serialized runtime trace must separately prove a
game-owned envelope reaches it.
