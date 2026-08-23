# Apple canonical plan Metal consumer — `bd660f754` — 2026-08-23

## Outcome

PC PR [#17](https://github.com/jskoiz/ACGC-PC-Port/pull/17), **Add bounded
canonical plan Metal consumer**, is merged on `c1/macos-host-launch` as
`bd660f754a9706100b357c62af5213eea00ec680`. The authoritative merge has first
parent `a4ee15c1d607994919aef4c32b6e08267b65d3d1` and reviewed topic parent
`a13af24bafbe9e1bae8f4903b8920a82e2004956`.

The merged component adds a pure Apple-side adapter from one normalized
`AcgcAppleCanonicalPlan` to the existing `AcgcMetalPacketConsumerOutput`. It
accepts only an intentionally narrow, resource-free three-vertex triangle
subset and stages the output before publication. The legacy semantic-packet
consumer remains intact, and the output records whether it came from the
semantic path or the canonical-plan path.

This closes the focused value-adaptation contract and production link
availability. It does not connect the retained lifecycle plan to the live
Metal runtime, choose between the old and new paths at runtime, execute a
render command, or prove a game-owned pixel.

## Immutable scope

The exact `a4ee15c1d..bd660f754` PC diff is four paths, 1,302 insertions and no
deletions:

- `pc/apple/CMakeLists.txt` links the canonical-plan library into the normal
  packet-consumer library and registers the focused fixture;
- `pc/apple/include/acgc/metal_packet_consumer.h` adds source-kind constants,
  appends source provenance to the consumer output, and declares the pure
  canonical-plan prepare function;
- `pc/apple/src/metal_packet_consumer.c` implements strict plan validation,
  matrix/color/raster conversion, and staged output publication; and
- `pc/apple/tests/test_apple_canonical_plan_consumer.c` proves the supported
  subset plus representative fail-closed mutations and legacy-path
  provenance.

No PC GX producer, gatherer, flush callback, lifecycle handoff, canonical wire
format, runtime sink, Metal encoder, shader, decomp source, or proprietary
asset path changed. GitHub reports exactly two topic commits, those four paths,
`+1302/-0`, and no hosted status-check rollup. The PC tip contains no hosted
workflow, so all proof below is local exact-merge evidence.

## Supported subset and fail-closed boundary

`acgc_metal_packet_consumer_prepare_canonical_plan` accepts only a complete,
already normalized value plan with:

- one three-vertex triangle and position plus `CLR0` vertex data;
- optional `PNMTXIDX`, with known position-matrix identifiers in the canonical
  `0, 3, ..., 27` set and the same identifier on all three vertices;
- finite position and matrix values;
- the prescribed sparse GX projection combined with one row-major 3x4 model
  matrix and emitted in the consumer's column-major transform layout;
- one raster-color TEV stage with no textures, TLUTs, texgens, lighting, fog,
  indirect state, or dynamic resources;
- explicit supported blend, depth, cull, and alpha-update state; and
- the exact 64x64 viewport/scissor and canonical near/far range `0.0/1.0`.

Canonical packed color `0x44332211` is mapped to the consumer's
`0x11223344` representation. Unknown selectors, unsupported state, non-finite
values, malformed matrices, input/output aliasing, resources, or any larger
geometry fail closed. The function stages a candidate and leaves the caller's
output unchanged on failure. It retains no input pointer and invokes no
callback or sink.

The output's `source_kind` field was appended at the structure tail so existing
member offsets remain stable. The older semantic prepare function now marks
successful output as `ACGC_METAL_PACKET_CONSUMER_SOURCE_SEMANTIC`; the new
adapter marks it as `ACGC_METAL_PACKET_CONSUMER_SOURCE_CANONICAL_PLAN`.

## Review history

Independent Lane 333 blocked the first candidate
`b74e2f8d9f604e106b47e7269216720d47b149c7` on two P1 findings:

1. the adapter did not require the exact `0.0/1.0` viewport near/far values
   expected by the downstream sink; and
2. it reconstructed synthetic direct/non-indexed Geometry/VCD/VAT wire state
   after normalization had erased that provenance.

Corrective child `a13af24bafbe9e1bae8f4903b8920a82e2004956` adds exact near/far
checks and independent rejection cases, deletes the synthetic descriptor and
dependency-result reconstruction, and moves `source_kind` to the output tail.
Independent Lane 336 re-reviewed that exact child and returned PASS with no
P0/P1 finding after fresh native and ASan/UBSan execution of the canonical
fixture and all four neighboring packet-consumer regression fixtures.

## Static reachability audit

Read-only Lane 337 returned **PASS-CONDITIONAL** for the claim that this bounded
adapter is structurally useful for a future production path. Revision-qualified
inspection found a static producer route through raw setters, the cumulative
gatherer/assembler, Apple parser, and plan builder for the no-`PNMTXIDX`
three-vertex subset. The explicit `PNMTXIDX` variant is contradicted by the
current PC raw Geometry producer, which rejects matrix-selector attributes, but
that attribute is optional in the accepted subset.

The remaining predicates are reachable only after their bounded setters have
established known provenance: projection/current position matrix, a disabled
`COLOR0A0` channel, zero texgens and resources with a nonzero texture owner
epoch, one exact `RASC`/`RASA` pass-through TEV stage, supported blend/alpha/
depth, exact 64x64 viewport/scissor with `0.0/1.0` depth, and zero raster side,
fog, lighting, and indirect state. Raw zero values are not interchangeable with
known zero values.

No source-backed fixture currently composes those setters and a real
`GXBegin`/`GXEnd` batch through assembler, parser, plan, and consumer. Therefore
actual producer-to-consumer reachability remains unproved. The next proof before
production arbitration is an exact round-trip fixture for the no-`PNMTXIDX`
subset; it must establish knownness through the real setter seams rather than
constructing a normalized plan by direct field assignment.

## Reference crosswalk

Host/Windows and canonical source at the authoritative PC tip:

- `pc/apple/include/acgc/apple_canonical_plan.h` and
  `pc/apple/src/apple_canonical_plan.c` define the value-owned normalized input;
- `pc/apple/include/acgc/metal_packet_consumer.h` and
  `pc/apple/src/metal_packet_consumer.c` define the existing renderer command
  output and both pure prepare paths;
- `pc/apple/src/apple_canonical_plan_handoff.c` owns the last successful plan
  but does not call this new adapter;
- `pc/apple/src/pc_metal_runtime.c` remains the existing runtime sink and is
  unchanged; and
- `pc/src/pc_gx.c` and `pc/src/pc_gx_cumulative_gatherer.c` own completed
  Geometry capture and cumulative publication, also unchanged here.

Original behavior and wire-layout oracle remains `upstream/ac-decomp` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`:

- `GXAttr.c`, `GXGeometry.c`, and `GXVert.c` define original descriptor,
  format, array, begin, and FIFO behavior;
- `GXTransform.c`, `GXLight.c`, `GXTexture.c`, `GXTev.c`, `GXPixel.c`, and
  `GXBump.c` define the original state/setter semantics represented in the
  canonical plan; and
- the cumulative envelope, normalized Apple plan, packet-consumer output,
  source provenance, and CMake topology have no direct decomp counterpart.

## Exact merged-tip verification

Authoritative source:

```text
/private/tmp/acgc-integrator-consumer-merged.DIpr8N
HEAD bd660f754a9706100b357c62af5213eea00ec680
status: detached and clean
```

Fresh native root:

```bash
cmake -S /private/tmp/acgc-integrator-consumer-merged.DIpr8N/pc/apple \
  -B /private/tmp/acgc-consumer-merged-native.IjGDrY \
  -G Ninja -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug

cmake --build /private/tmp/acgc-consumer-merged-native.IjGDrY \
  --target acgc_apple_canonical_plan_consumer_fixture \
           acgc_metal_packet_consumer_tests \
           acgc_metal_packet_consumer_v2_texture_tev_tests \
           acgc_metal_packet_consumer_v2_runtime_sideband_tests \
           acgc_metal_packet_consumer_v2_channel_source_tests \
  --parallel 1
```

The fresh 53-step build passed. Exact CTest discovery found five tests and the
anchored matrix passed `5/5` in 0.10 seconds.

Fresh combined ASan/UBSan root
`/private/tmp/acgc-consumer-merged-asan-ubsan.4YEKuk` used the same command
shape with:

```text
-fsanitize=address,undefined -fno-omit-frame-pointer
```

and matching executable linker flags. Its fresh 53-step build passed, exact
discovery again found five tests, and the matrix passed `5/5` in 0.34 seconds
without AddressSanitizer, UndefinedBehaviorSanitizer, or runtime-error
diagnostics. Independent direct fixture execution printed
`Apple canonical plan consumer fixture: PASS`.

Fresh production root:

```bash
cmake -S /private/tmp/acgc-integrator-consumer-merged.DIpr8N/pc \
  -B /private/tmp/acgc-consumer-merged-acpc.mSoytM \
  -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=OFF \
  -DCMAKE_BUILD_TYPE=Debug

cmake --build /private/tmp/acgc-consumer-merged-acpc.mSoytM \
  --target ac_pc --parallel 1
```

The complete 4,078-item serialized production target graph linked; an immediate
repeat reported `ninja: no work to do`. The only final-link diagnostic was the
inherited Mach-O `__DATA,__common` alignment-reduction warning. The resulting
`bin/AnimalCrossing` is a 15,323,616-byte arm64 Mach-O executable. `nm`
confirms it contains:

```text
_acgc_apple_canonical_plan_build
_acgc_metal_packet_consumer_prepare
_acgc_metal_packet_consumer_prepare_canonical_plan
_pc_gx_cumulative_snapshot_gather
```

No process was launched. The post-build Xcode hygiene dry-run reported 651
candidates, 0 KiB potential recovery, and zero errors; nothing was deleted.

## Evidence boundary

This proves the exact merged source/CMake integration, strict pure-value
adaptation for the documented three-vertex no-resource subset, preserved
legacy prepare behavior with explicit source provenance, failure immutability,
focused native and combined ASan/UBSan regression execution, and a complete
production arm64 link containing both prepare paths plus the plan and gatherer.

It does **not** prove complete producer-to-consumer reachability of the
supported subset, process launch, one real game plan entering this adapter,
lifecycle-to-runtime arbitration, command submission, Metal
encode/present/readback, pixels, device behavior, input, audible audio,
save/reload, lifecycle completion, iOS, or human playability. The next gate is
the source-backed assembler-to-parser-to-plan-to-consumer round trip described
above. A separately reviewed runtime arbitration/handoff follows that gate and
must preserve the legacy semantic path; a real process trace remains separately
blocked on explicit authority to use the ignored local asset root.
