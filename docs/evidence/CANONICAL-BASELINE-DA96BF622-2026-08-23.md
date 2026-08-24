# Canonical CPU baseline correction — PC `da96bf622`

## Outcome

PC [PR #26](https://github.com/jskoiz/ACGC-PC-Port/pull/26),
`Accept dormant canonical plan state`, merged into `c1/macos-host-launch` as
`da96bf622523728729a7052e605cda19666462e1`.

- PC base: `70a8e23bcf4bebe7deaceed5c9cb6ab70d0a94d4`
- Reviewed source commit:
  `5c62286b7110134db79705d8922ff464f5503036`
- PC merge: `da96bf622523728729a7052e605cda19666462e1`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PR state: merged 2026-08-24 at 07:38:03 UTC; one source commit; the
  status-check rollup and human approval reviews were empty, while one
  automated `chatgpt-codex-connector` review was recorded as `COMMENTED`.

The exact first-parent merge diff is four paths, 421 insertions and 148
deletions:

- `pc/apple/include/acgc/metal_packet_consumer.h`
- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/tests/test_apple_canonical_plan_consumer.c`
- `pc/tests/pc_gx_canonical_plan_roundtrip_fixture.c`

The merge parents are exactly the PC base and reviewed source commit.
`git diff --check` passed. No CMake, producer, gatherer, flush, runtime
arbitration, renderer, Metal sink, viewport, depth, workflow, decomp, umbrella,
or proprietary-asset path changed in the PC PR.

The exact merge contains no `.github/workflows` entry. No hosted Apple workflow
or paid Apple runner was triggered. The proof below is local, focused, and tied
to the exact merge object.

## Reproduced failure and corrected contract

The registered source-backed round trip was freshly configured and built at
the former exact PC tip `70a8e23bc`. It failed deterministically during Apple
canonical-plan preparation. The captured plan had:

- zero active Texgens;
- one dormant known Texgen selector;
- initialized `GX_IDENTITY` and `GX_PTIDENTITY` 3x4 matrix provenance; and
- a disabled vertex-color channel using source-faithful `REG` ambient and
  `VTX` material controls.

The producer was correct to preserve those setter-owned values. The Apple
consumer incorrectly required every Texgen count, mask, selector, matrix,
word, and SU record to be byte-zero whenever the active count was zero. Its
channel predicate also accepted only a byte-zero record rather than the
disabled control state used by GX initialization and J2D.

The merged correction now:

- requires the full canonical Texgen validator and
  `active_texgen_count == 0`, while allowing valid dormant selector, matrix,
  and SU provenance;
- retains the surrounding Geometry, Texture, and TEV predicates that prohibit
  texture attributes, matrix selectors, known/required Texture records, and
  non-null TEV texture inputs, so accepted dormant Texgen state is not consumed;
- accepts exactly one valid disabled `COLOR0A0` channel record with `REG`
  ambient source, `VTX` material source, zero light mask, no diffuse function,
  and no attenuation for both color and alpha;
- leaves disabled ambient/material color payload values semantically dormant
  rather than requiring arbitrary byte-zero payloads;
- appends typed Geometry, Transform, Channels, Texgens, Texture, TEV,
  Lighting, Blend, Alpha, Depth, Raster, Fog, Indirect, Dynamic, and resource
  dependency rejection statuses after the unchanged legacy values `0..12`;
- preserves the prior dependency-first Transform-before-Geometry predicate
  order and stages output until every check succeeds;
- repairs the multi-vertex helper so internal `CHECK` failures return nonzero
  and its caller requires zero for success; and
- adds a negative control that corrupts one prepared vertex bit and requires
  the shared per-vertex verifier to reject it.

The root fixture relies on `pc_gx_init()` for source-faithful identity and
post-identity matrix provenance, then installs a J2D-style dormant selector
after `GXSetNumTexGens(0)`. It asserts exact logical IDs, counts, masks, matrix
types, word counts, known-word masks, words, disabled channel controls, and a
valid active-Texgen rejection. Rejection preserves both input and output.

## Two-upstream crosswalk

The host implementation and Windows regression oracle is the exact PC merge:

- `pc/src/pc_gx.c` owns GX initialization, `GXSetNumTexGens`,
  `GXSetTexCoordGen2`, identity/post-identity provenance, channel setters, and
  the source-backed flush/gather topology;
- `pc/src/pc_gx_texgen_producer.c` preserves validated dormant Texgen values;
- `pc/src/pc_gx_channels_raw.c` maps combined `COLOR0A0` controls into the
  canonical record;
- `pc/src/pc_gx_geometry_dependencies.c` gates Geometry Texgen dependencies by
  active count and actual attributes;
- `pc/apple/src/apple_canonical_plan.c` builds the value-only plan and derives
  cross-section dependencies;
- `pc/apple/src/metal_packet_consumer.c` owns the bounded CPU consumer and the
  typed section rejection contract; and
- the two changed fixtures own source-backed composition and bounded
  multi-vertex/quad rejection coverage.

The original-behavior and wire-layout oracle remains decomp `09ca8e8b5`:

- `src/static/dolphin/gx/GXInit.c` initializes identity texture matrices and
  disabled channel state;
- `src/static/dolphin/gx/GXAttr.c`, `GXTransform.c`, and `GXLight.c` define the
  selector, matrix, active-count, and channel setter semantics; and
- `src/static/JSystem/J2DGraph/J2DGrafContext.cpp` configures one disabled
  `COLOR0A0` channel, zero active Texgens, identity matrix provenance, and a
  dormant Texgen selector for the 2D path.

The Apple value-plan ABI, typed host status values, CMake/CTest topology, and
sanitizer fixtures have no direct decomp counterpart.

The source-backed fixture is deliberately described as J2D-style rather than
an exact full J2D TEV round trip. Its TEV channel selector is the existing
host-normalized bounded pass-through value. Reconciling a live exact J2D TEV
selector remains trace-driven successor work and is not silently claimed here.

## Independent reviews

An independent source review inspected the exact four-file candidate, its
`70a8e23bc` parent, status ABI, predicate order, failure immutability, fixture
return convention, negative control, and PC/decomp crosswalk. A separate
semantic audit checked that the accepted Geometry, Texture, and TEV predicates
make dormant Texgen provenance unconsumed. Both returned PASS with no P0 or P1.

The immutable review then inspected exact commit `5c62286b7`, its parent,
clean worktree, exact four-path scope, `git diff --check`, append-only status
ABI, and retained focused logs. It returned PASS with no P0 or P1 and
authorized the scoped PR.

One non-blocking P2 remains: the resource-dependency rejection status is not
currently reachable after the stricter inactive Texture and Dynamic predicates.
It is a future-proof guard, not a claimed exercised branch. No production or
freeze patch was required for this bounded lane.

## Exact-merge root verification

Detached, clean source worktree:

`/private/tmp/acgc-integrator-baseline-merged.RYBgtn`

at exact merge `da96bf622523728729a7052e605cda19666462e1`.

Fresh native root:

`/private/tmp/acgc-baseline-merge-native-5vGqfN`

```sh
cmake -S /private/tmp/acgc-integrator-baseline-merged.RYBgtn/pc \
  -B /private/tmp/acgc-baseline-merge-native-5vGqfN \
  -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-baseline-merge-native-5vGqfN \
  --target acgc_pc_gx_canonical_plan_roundtrip_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-baseline-merge-native-5vGqfN \
  -N -R '^acgc_pc_gx_canonical_plan_roundtrip_fixture$'
ctest --test-dir /private/tmp/acgc-baseline-merge-native-5vGqfN \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_canonical_plan_roundtrip_fixture$'
```

Result: configure/generate and serialized target build passed; discovery found
exactly one test; it passed `1/1` in 0.01 seconds.

Fresh combined ASan/UBSan root:

`/private/tmp/acgc-baseline-merge-asan-ubsan-H3kLmP`

The same commands were used with
`-fsanitize=address,undefined -fno-omit-frame-pointer` in `CMAKE_C_FLAGS` and
the matching linker flags. Configure/generate and the serialized target build
passed; discovery found exactly one test; it passed `1/1` in 0.05 seconds. The
retained log contains no AddressSanitizer, UndefinedBehaviorSanitizer,
runtime-error, failed-test, or error diagnostic.

## Exact-merge Apple verification

Fresh native root:

`/private/tmp/acgc-baseline-apple-native-da96bf`

Fresh combined ASan/UBSan root:

`/private/tmp/acgc-baseline-apple-asan-ubsan-da96bf`

Both roots were configured from `pc/apple` with Ninja, `BUILD_TESTING=ON`, and
Debug. The sanitizer root used matching address/undefined flags for C, C++,
Objective-C, and the executable linker. The following exact targets were built
with `--parallel 1`:

- `acgc_apple_canonical_plan_consumer_fixture`
- `acgc_renderer_geometry_tests`
- `acgc_renderer_geometry_cpp_tests`
- `acgc_metal_packet_consumer_tests`
- `acgc_metal_sink_tests`
- `acgc_metal_packet_consumer_v2_texture_tev_tests`
- `acgc_metal_packet_consumer_v2_runtime_sideband_tests`
- `acgc_metal_packet_consumer_v2_channel_source_tests`

The exact combined CTest regex discovered eight tests in each root. Native
execution passed `8/8` in 0.08 seconds. Combined ASan/UBSan execution passed
`8/8` in 0.51 seconds. The sanitizer log contains no AddressSanitizer,
UndefinedBehaviorSanitizer, runtime-error, failed-test, or error diagnostic.

The Xcode hygiene dry-run was read-only and reported `candidates=655`,
`potential=0 KiB`, and `errors=0`.

## Proof boundary and next gate

Proved:

- exact PR #26 integration, parentage, identity, and four-path scope;
- acceptance of canonical-valid dormant inactive Texgen provenance only inside
  the retained unconsumed resource-free subset;
- source-faithful disabled vertex-color channel control acceptance;
- append-only typed canonical section rejection and output immutability;
- real propagation of multi-vertex fixture failures plus a corruption negative
  control; and
- exact-merge native plus combined ASan/UBSan configure, compile, link,
  discovery, and execution of root `1/1` and Apple `8/8` focused CPU gates.

Not proved:

- a full `ac_pc` link or process launch at `da96bf622`;
- a later-producer result, cumulative envelope, callback, or live Apple plan;
- an exact full J2D TEV selector contract or target-sized viewport/scissor/depth
  support;
- Metal encode, present, readback, pixels, or device behavior; or
- input, audible audio, save/reload, lifecycle, Windows execution, iOS, or
  playability.

The next critical-path gate is one serialized full `ac_pc` link from exact
`da96bf622` and one bounded real-process trace. It must resolve symbols by name,
retain exact binary/source identity, correlate attempt IDs, stop at the next
first-failing producer or one real cumulative publication, and terminate only
the recorded LLDB/inferior PIDs. It must not infer Metal or pixel work from CPU
callback reachability.
