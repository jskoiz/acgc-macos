# Apple canonical plan handoff — `a4ee15c1d` — 2026-08-23

## Outcome

PC PR [#16](https://github.com/jskoiz/ACGC-PC-Port/pull/16), **Add Apple
canonical plan handoff**, is merged on `c1/macos-host-launch` as
`a4ee15c1d607994919aef4c32b6e08267b65d3d1`. The authoritative merge has first
parent `2d4bc2b7e9241af4a8886b655ce9d8bd7d7caede` and reviewed topic parent
`4f327606e41c24cbd27cde5affe4ba9883c8a24e`.

The merged component registers one process-lifetime Apple callback after
`pc_gx_init()`, builds the complete value-owned Apple canonical plan
synchronously while each cumulative envelope is valid, and retains only the
last successfully published plan. Apple shutdown stops the Metal runtime,
clears the GX callback, and only then invalidates the retained plan before
`pc_gx_shutdown()`.

This closes production callback registration, synchronous callback-lifetime
copy/build ownership, and production link availability. It does not prove that
a real game process has delivered an envelope to the callback or that Metal has
consumed a plan.

## Immutable scope

The exact `2d4bc2b7e..a4ee15c1d` PC diff is six paths, 475 insertions and no
deletions:

- `pc/CMakeLists.txt` adds the handoff source once to Apple production sources;
- `pc/apple/CMakeLists.txt` adds the normal static library, focused fixture,
  warning policy, and CTest registration;
- `pc/apple/include/acgc/apple_canonical_plan_handoff.h` defines the bounded
  observation snapshot, lifecycle API, and value-copy API;
- `pc/apple/src/apple_canonical_plan_handoff.c` owns callback registration,
  synchronous plan building, counters, failure preservation, and clearing;
- `pc/apple/tests/test_apple_canonical_plan_handoff.c` exercises lifecycle,
  publication, rejection, output immutability, and retry behavior with link-time
  stubs; and
- `pc/src/pc_main.c` establishes the Apple init/shutdown order.

No GX producer, gatherer, flush, canonical wire ABI, plan decoder, Metal
consumer, renderer, decomp source, or proprietary asset path changed. GitHub
reports exactly one topic commit, those six paths, `+475/-0`, and no hosted
status-check or review rollup. The PC tip contains no hosted workflow; the proof
below is local exact-merge execution.

## Ownership and lifecycle contract

The handoff owns one file-static `AcgcAppleCanonicalPlan` and bounded counters.
It never retains the callback envelope, a section span, a Texture/TLUT borrow,
or a raw host pointer. The GX owner must use the component serially:

1. call `pc_gx_init()`;
2. call `acgc_apple_canonical_plan_handoff_init()`;
3. start the Apple Metal runtime;
4. drive GX and copy the last successful plan only from the same owner;
5. stop the Apple Metal runtime;
6. call `acgc_apple_canonical_plan_handoff_shutdown()`; and
7. call `pc_gx_shutdown()`.

`pc_main.c` now follows that ordering. Registration is idempotent. The callback
validates the exact context and registered state, increments saturating bounded
counters, invokes `acgc_apple_canonical_plan_build` synchronously, and marks a
publication only on complete success. A rejected build increments its rejection
counter while preserving the previously valid plan and publication count.

Shutdown calls `pc_gx_clear_cumulative_snapshot_callback` before resetting any
handoff state. If clear fails, registration, observations, and plan bytes remain
intact so the same owner can retry. A successful clear zeroes the plan and
invalidates it. Copy failure and null-output paths leave the destination
unchanged. The API intentionally makes no concurrent-reader guarantee.

## Focused fixture coverage

The source-backed handoff fixture supplies narrow link-time stubs for callback
set/clear and plan build, then covers:

- registration failure followed by retry;
- idempotent duplicate init;
- wrong and null callback contexts;
- successful synchronous publication and value copying;
- plan-build rejection preserving the previous published value;
- null API inputs and failed-copy destination immutability;
- clear failure preserving the complete state for retry;
- successful clear, state invalidation, and reinitialization; and
- a PASS sentinel emitted only after every assertion succeeds, with nonzero
  process exit on failure.

Independent Lane 326 review found no P0 or P1 issue after static source and
two-upstream review plus fresh native, sanitizer, normal-library, and production
compile-graph verification. It recorded two bounded P2 maintenance limits:

- the handoff redeclares the exact cumulative callback ABI locally to avoid
  pulling the SDL/OpenGL-backed internal GX state into the pure-C fixture; the
  declarations match today, but a future callback-ABI change must update both;
  and
- repeated unpaired `pc_gx_init()` calls are outside the documented one-owner
  lifecycle. Such a call could clear the GX callback while the handoff still
  records itself registered, so future platform reinitialization requires a
  separately designed contract.

## Reference crosswalk

Host/Windows and canonical source at the authoritative PC tip:

- `pc/include/pc_gx_cumulative_gatherer.h` defines the synchronous cumulative
  callback lifetime and registration/clear surface;
- `pc/src/pc_gx_cumulative_gatherer.c` owns all-section gathering, the
  Texture/TLUT borrow transaction, and synchronous callback invocation;
- `pc/src/pc_gx.c` owns one guarded gather attempt after completed Geometry
  capture and lifecycle callback clearing;
- `pc/apple/src/apple_canonical_plan.c` structurally parses, explicitly decodes,
  validates, and value-copies all fourteen canonical sections;
- `pc/apple/src/apple_canonical_plan_handoff.c` is the new ownership adapter;
  and
- `pc/src/pc_main.c` is the production Apple lifecycle owner.

Original behavior and wire-layout oracle remains `upstream/ac-decomp` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`:

- `GXAttr.c`, `GXGeometry.c`, and `GXVert.c` define original descriptor,
  format, array, begin, and FIFO behavior;
- `GXTransform.c`, `GXLight.c`, `GXTexture.c`, `GXTev.c`, `GXPixel.c`, and
  `GXBump.c` define the original state/setter semantics carried by the canonical
  sections; and
- the cumulative envelope, host callback, borrow protocol, Apple value plan,
  handoff ownership, and CMake topology have no direct decomp counterpart.

## Exact merged-tip verification

Authoritative source:

```text
/private/tmp/acgc-integrator-handoff-merged
HEAD a4ee15c1d607994919aef4c32b6e08267b65d3d1
status: detached and clean
```

Fresh native root:

```bash
cmake -S /private/tmp/acgc-integrator-handoff-merged/pc/apple \
  -B /private/tmp/acgc-handoff-merged-native-20260823 \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON

cmake --build /private/tmp/acgc-handoff-merged-native-20260823 \
  --target acgc_apple_canonical_plan_handoff \
           acgc_apple_canonical_envelope_parser_fixture \
           acgc_apple_canonical_plan_fixture \
           acgc_apple_canonical_plan_handoff_fixture \
  --parallel 1

./acgc_apple_canonical_plan_handoff_fixture

ctest --output-on-failure --parallel 1 \
  -R '^(acgc_apple_canonical_envelope_parser_fixture|acgc_apple_canonical_plan_fixture|acgc_apple_canonical_plan_handoff_fixture)$'
```

Results: fresh configuration and the serialized 42-step build passed; direct
handoff execution printed `Apple canonical plan handoff tests: PASS`; CTest
discovered exactly three tests and passed `3/3` in 0.01 seconds.

Fresh combined ASan/UBSan root used the same command shape with:

```text
-O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined
-fno-sanitize-recover=all
```

and matching executable linker flags. Direct execution printed the same PASS
sentinel; exact parser/plan/handoff CTest discovery was three tests and passed
`3/3` in 0.12 seconds. `LastTest.log` contains no `CHECK failed`,
AddressSanitizer, UndefinedBehaviorSanitizer, runtime-error, `ERROR`, or `FAILED`
diagnostic.

Fresh production root:

```bash
cmake -S /private/tmp/acgc-integrator-handoff-merged/pc \
  -B /private/tmp/acgc-handoff-merged-acpc-20260823 \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=OFF

cmake --build /private/tmp/acgc-handoff-merged-acpc-20260823 \
  --target ac_pc --parallel 1
```

Results: fresh configuration and all 4,078 serialized build steps passed. The
only final-link diagnostic was the inherited Mach-O common-section alignment
reduction warning. The result is a 15,245,936-byte arm64 Mach-O executable.
`nm` confirms the linked executable contains the handoff init/shutdown/copy
symbols, Apple plan builder, cumulative callback registration, and cumulative
gatherer. No process was launched.

The post-build Xcode hygiene dry-run reported 651 candidates, 0 KiB potential
recovery, and zero errors; nothing was deleted.

## Evidence boundary

This proves exact-merge source and CMake integration, one-owner lifecycle
registration/clearing, synchronous envelope-to-value-plan construction in the
focused fixture, prior-plan preservation on rejection, clear retry semantics,
normal static-library compilation, exact native and combined ASan/UBSan
execution, and a complete production arm64 link with the required symbols.

It does **not** prove process launch, one real game envelope reaching the
callback, current-tip boot progression, plan reads by the Metal runtime,
renderer command generation, Metal encode/present/readback, pixels, device
behavior, input, audible audio, save/reload, lifecycle completion, iOS, or human
playability. The next serialized gate is a bounded real-process callback trace;
Metal consumption remains a separate successor after that trace.
