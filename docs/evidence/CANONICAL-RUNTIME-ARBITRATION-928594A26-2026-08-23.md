# Canonical runtime arbitration — `928594a26` — 2026-08-23

## Outcome

PC PR [#19](https://github.com/jskoiz/ACGC-PC-Port/pull/19), **Add canonical
runtime arbitration**, is merged on `c1/macos-host-launch` as
`928594a2649e7934cee43eaaffec7f82481e969f`. The merge has first parent
`818bfe5475eddb6fba8dcebba39a829e21dffde5` and reviewed topic parent
`23b97e75d28c8e73bba2e3325845e5917596bb9b`.

The merged source adds one process-lifetime identity for every cumulative GX
flush attempt, reports publication or no-publication only after the
Texture/TLUT borrow has ended, hands a complete canonical CPU plan to the Apple
runtime as a synchronous borrowed value, and arbitrates that result against the
existing semantic callbacks. A successful canonical sink submission wins only
the current attempt. Gather, plan, prepare, and sink failures preserve semantic
V1 fallback; V2/V3/V4 remain outside the current geometry-only sink.

This is source-backed CPU and production-link evidence. No process was launched
and no game asset, Metal device, drawable, or pixel was accessed.

## Immutable scope

The exact `818bfe547..928594a26` PC first-parent diff is ten paths, 1,515
insertions and 137 deletions:

- `pc/src/pc_gx.c`
- `pc/include/pc_gx_cumulative_gatherer.h`
- `pc/src/pc_gx_cumulative_gatherer.c`
- `pc/apple/include/acgc/apple_canonical_plan_handoff.h`
- `pc/apple/src/apple_canonical_plan_handoff.c`
- `pc/apple/include/acgc/pc_metal_runtime.h`
- `pc/apple/src/pc_metal_runtime.c`
- `pc/apple/tests/test_apple_canonical_plan_handoff.c`
- `pc/apple/tests/test_pc_metal_runtime_arbitration.c` (new)
- `pc/apple/CMakeLists.txt`

No `pc_main.c`, semantic packet consumer, Objective-C Metal sink, shader,
portable canonical producer/encoder, legacy OpenGL path, or umbrella file
changed in the PC PR. `git diff --check` passed. GitHub reports the same single
topic commit, ten paths, `+1515/-137`, no reviews, and no hosted status-check
rollup. The PC tree contains no `.github/workflows` path, so all proof below is
local exact-merge evidence.

## Attempt and publication contract

`pc_gx.c` owns a bounded static cumulative workspace plus process-lifetime
`uint64_t` attempt state. Each eligible flush:

1. captures completed Geometry;
2. allocates the next nonzero attempt ID;
3. performs the synchronous cumulative gather;
4. returns from the gather only after its Texture/TLUT borrow has ended; and
5. sends exactly one `PUBLISHED` or `NO_PUBLICATION` completion notification.

IDs `1..UINT64_MAX-1` are normal. `UINT64_MAX` is reserved for one terminal
no-publication invalidation, after which gathering remains permanently fail
closed rather than wrapping or reusing an identity. The counter is not reset by
GX init/shutdown.

The gatherer installs the envelope and completion callbacks as an all-or-nothing
pair with one shared context. Registration and clear are rejected during a
Texture borrow or callback dispatch. Existing single-envelope callback entry
points remain only for the established source-backed fixtures; mixed single and
paired registration is rejected. The envelope callback runs synchronously
inside the borrow transaction, while the pointer-free attempt notification is
issued only after release.

## Borrowed plan handoff

The Apple handoff no longer exposes a reusable plan-copy API. It stages a
value-owned candidate while the envelope is valid, clears the prior plan before
each new candidate, and resolves the following completion into exactly one of:

- `NO_PUBLICATION` with a null plan;
- `PLAN_REJECTED` with the plan builder's rejection status; or
- `PLAN_PUBLISHED` with a plan pointer valid only during the synchronous
  consumer callback.

Duplicate, zero, or stale attempt IDs cannot republish an older plan. Current
and pending plan storage is zeroed after the consumer returns. Callback-active
guards reject consumer registration/clear, init/shutdown, and nested canonical
consumption during dispatch. Production lifecycle order remains GX init,
handoff init, Metal runtime init; teardown reverses runtime, handoff, then GX.

## Runtime winner and fallback policy

The Apple runtime accepts semantic output only when it is semantic V1 with
semantic source provenance. Canonical eligibility is separate: the output must
have canonical-plan source provenance, semantic version zero, and zero V2/V3/V4
extension statuses.

For a fresh attempt, the runtime clears the old winner before handling the new
result. A canonical plan establishes `canonical_won` only after both canonical
prepare and sink submission succeed. Later semantic callbacks in that attempt
are still observed for diagnostics but are not submitted. No-publication,
plan-build rejection, consumer-prepare rejection, and sink failure leave the
winner clear, so semantic V1 remains the fallback. A fresh attempt, stale-token
invalidation, shutdown, and reinit cannot carry an earlier winner forward.

The CPU-only arbitration fixture links the real handoff and runtime sources to a
fake bounded sink. It does not link `metal_sink.m`. It asserts canonical success,
all four failure tiers, semantic fallback/suppression, V2/V3/V4 fail-closed
behavior, attempt N to N+1 freshness, duplicate/stale invalidation, lifecycle
retry, callback-time reentry rejection, and direct PASS propagation.

## Independent review

Lane 347 independently reviewed exact candidate
`23b97e75d28c8e73bba2e3325845e5917596bb9b` and returned PASS with no P0/P1
blocker. It repeated the native and combined ASan/UBSan matrices in fresh roots,
compiled the affected production objects, inspected the generated source/link
graphs, verified the fake sink cannot mask an Objective-C Metal dependency, and
audited success/failure, stale-token, overflow, lifecycle, and reentry paths.

The review retained four P2 notes:

- the Apple handoff locally redeclares the callback ABI to avoid importing the
  SDL/OpenGL-backed internal header, creating a future ABI-drift maintenance
  risk even though the declarations match and both production objects compile;
- direct GX init/shutdown outside documented `pc_main` ordering can desynchronize
  the handoff's private registration observation;
- an older sink-policy fixture alone maps a zero source kind to semantic under a
  test-only macro, while production and the new arbitration fixture are strict;
  and
- terminal `UINT64_MAX` behavior and forbidden nested GX flush are source-audited
  rather than dynamically driven through unreachable fixture state.

None weakens production eligibility or the documented single-owner synchronous
contract, and none was classified as a source blocker.

## Reference crosswalk

Host implementation at the authoritative PC tip:

- `pc/src/pc_gx.c`: completed-Geometry flush order, process-lifetime attempt
  IDs, cumulative gather, post-borrow completion, semantic callbacks, and legacy
  GL continuation;
- `pc/src/pc_gx_cumulative_gatherer.c`: fourteen-section production, explicit
  encoding/assembly, Texture/TLUT borrow/revalidation, callback-pair ownership;
- `pc/apple/src/apple_canonical_plan_handoff.c`: structural parse/value-plan
  construction, stale invalidation, and borrowed-plan delivery;
- `pc/apple/src/pc_metal_runtime.c`: source-aware canonical/semantic eligibility,
  winner/fallback state, and sink submission; and
- `pc/apple/tests/test_pc_metal_runtime_arbitration.c`: bounded fake-CPU-sink
  state-machine fixture.

Original behavior and wire-layout oracle remains `upstream/ac-decomp` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. `GXAttr.c`, `GXGeometry.c`,
`GXVert.c`, `GXTransform.c`, `GXLight.c`, `GXTexture.c`, `GXTev.c`, `GXPixel.c`,
and `GXBump.c` define the original setter, FIFO, and GX state semantics
represented by the canonical sections. The cumulative envelope, resource
lease, attempt IDs, Apple plan, callback handoff, source-kind arbitration, and
CMake fixture have no direct decomp counterpart; they are host-port ownership
and delivery boundaries.

## Exact merged-tip focused verification

Authoritative detached source:

```text
/private/tmp/acgc-integrator-runtime-arbitration.D6g7Y9/source
HEAD 928594a2649e7934cee43eaaffec7f82481e969f
status: detached and clean
```

Fresh native roots:

```text
/private/tmp/acgc-merged-344-pc-native.928594a26
/private/tmp/acgc-merged-344-apple-native.928594a26
```

The top-level PC root used `PC_DARWIN_COMPILE_AUDIT=ON`, `BUILD_TESTING=ON`,
Debug, and built `acgc_pc_gx_production` plus the cumulative gatherer,
production-flush, and canonical-plan round-trip fixtures with `--parallel 1`.
Anchored discovery found exactly Tests #37-#39; the matrix passed `3/3`.

The standalone Apple root used `BUILD_TESTING=ON`, Debug, and built the runtime
arbitration, plan handoff, canonical consumer, and V2 runtime-sideband fixtures
with `--parallel 1`. Anchored discovery found exactly Tests #3, #4, #15, and
#16; the matrix passed `4/4`. Verbose direct execution printed:

```text
PC Metal runtime arbitration fixture: PASS
```

Fresh combined sanitizer roots:

```text
/private/tmp/acgc-merged-344-pc-asan.928594a26
/private/tmp/acgc-merged-344-apple-asan.928594a26
```

They used `-fsanitize=address,undefined -fno-omit-frame-pointer
-fno-sanitize-recover=all` and matching executable linker flags. The same PC
`3/3` and Apple `4/4` matrices passed. The arbitration fixture again printed
the direct PASS sentinel. CTest logs contained no AddressSanitizer,
UndefinedBehaviorSanitizer, or `runtime error:` diagnostic. Leak detection was
disabled only for these focused ASan/UBSan runs.

## Exact merged-tip production link

A separate fresh root configured with testing off:

```text
/private/tmp/acgc-merged-344-full-link.928594a26
```

The serialized command built `ac_pc` with `--parallel 1` and completed the
4,078-item Ninja graph. It produced:

```text
bin/AnimalCrossing
Mach-O 64-bit executable arm64
15,458,528 bytes
```

The Mach header reports `NOUNDEFS`. `nm` confirms strong definitions for
`pc_gx_set_cumulative_snapshot_callbacks`,
`pc_gx_notify_cumulative_snapshot_attempt`,
`acgc_apple_canonical_plan_handoff_init`,
`acgc_apple_canonical_plan_handoff_shutdown`, `pc_metal_runtime_init`, and
`pc_metal_runtime_shutdown`. The final linker emitted only the inherited common
section alignment-reduction warning. The binary was not launched.

The post-build Xcode hygiene dry-run completed with `candidates=651`,
`potential=0 KiB`, and `errors=0`; no cleanup was applied.

## Evidence boundary

This proves exact merged-source integration, focused native and combined
ASan/UBSan CPU behavior, production-object compatibility, callback-pair and
borrowed-plan ownership, source-aware winner/fallback state transitions, and a
fresh full arm64 production link.

It does **not** prove a real game process reaches the cumulative or canonical
callbacks, asset-backed boot, Metal encode/submit/present/readback, a game-owned
pixel, device behavior, textures/TLUTs or broader Geometry support, input,
audible audio, save/reload, lifecycle completion, iOS, or human playability.
The next runtime gate is one bounded current-tip callback-delivery trace. That
trace requires separate explicit authority before accessing ignored proprietary
assets or launching the game.
