# Apple multi-vertex canonical Geometry — PC `de9a26fee`

## Outcome

PC [PR #23](https://github.com/jskoiz/ACGC-PC-Port/pull/23),
`Expand Apple canonical geometry replay`, merged into
`c1/macos-host-launch` as
`de9a26fee8a89a55903b8f9dd0a0896daf41c0e3`.

- PC base: `7636cc1d801a8b0108ce3d8e3f2c761b009f5fa5`
- Reviewed source commit:
  `25ff63fca18a124967b64560c1c77cb6db12233f`
- PC merge: `de9a26fee8a89a55903b8f9dd0a0896daf41c0e3`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PR state: merged 2026-08-23 at 20:31:29 UTC.

The exact first-parent merge diff is seven Apple paths, 500 insertions and 67
deletions:

- `pc/apple/include/acgc/renderer_geometry.h`
- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/src/metal_sink.m`
- `pc/apple/src/renderer_geometry.c`
- `pc/apple/tests/test_apple_canonical_plan_consumer.c`
- `pc/apple/tests/test_metal_sink.m`
- `pc/apple/tests/test_renderer_geometry.c`

`git diff --check` passed. The exact merge parents are the PC base and the
reviewed source commit, and the merge tree matches the reviewed candidate
tree. No PC gatherer, raw-state, cumulative-envelope, CMake, decomp, umbrella,
or proprietary-asset path changed in the PC PR.

The PC merge tip contains no `.github/workflows` entry. No workflow or manual
rerun was triggered for this integration. GitHub returned an empty
status-check rollup, zero check runs for the source commit, and no hosted
reviews. The claims below are based on the exact local merge worktree, focused
native execution, and focused combined ASan/UBSan execution.

## End-state CPU Geometry behavior

The merged Apple path replaces the canonical consumer's exact-three-vertex
limit with one bounded value-owned Geometry contract:

- canonical triangle lists accept a nonzero vertex count divisible by three;
- canonical quads accept a nonzero input count divisible by four;
- each quad expands in source order as `0,1,2,0,2,3`;
- at most 192 renderer vertices are staged;
- 128 canonical quad vertices expand to the 192-vertex renderer maximum;
- the sink validates the dynamic vertex count, copies exactly that count, and
  draws the validated count; and
- the pre-existing V1/V2 semantic paths remain exactly three vertices, one
  draw, and triangle topology.

Unsupported attributes or selectors, unknown transform slots, invalid counts
or capacities, non-finite source or transformed positions, nonzero trailing
storage, and input/output overlap fail closed. The consumer stages a local
candidate and publishes caller output only after complete validation, so
failure preserves the destination. The fixtures cover triangle batches, quad
expansion, the 128-to-192 bound, malformed topology/counts, aliasing,
transform overflow, output immutability, sink copy length, and legacy V1/V2
non-interference.

This is a CPU-side conversion of an already-decoded canonical plan to the
existing renderer-neutral packet shape. It does not gather game state, parse
guest command bytes, acquire Texture/TLUT leases, publish a cumulative
envelope, or prove that a real game process reaches the Apple consumer.

## Two-upstream crosswalk

The host implementation and regression oracle is the exact PC merge above:

- `pc/apple/src/metal_packet_consumer.c` owns canonical-plan validation,
  bounded triangle/quad conversion, staging, and destination publication;
- `pc/apple/include/acgc/renderer_geometry.h` and
  `pc/apple/src/renderer_geometry.c` own the 192-vertex renderer-neutral
  Geometry capacity;
- `pc/apple/src/metal_sink.m` owns the checked dynamic copy/draw count; and
- the three modified Apple fixtures exercise the source-backed CPU contracts.

The original-behavior/wire oracle remains decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`:

- `include/dolphin/gx/GXGeometry.h` declares vertex descriptor/format setup and
  `GXBegin`;
- `src/static/dolphin/gx/GXGeometry.c` emits the primitive, vertex format, and
  `nverts` at `GXBegin`;
- `include/dolphin/gx/GXVert.h` and
  `src/static/dolphin/gx/GXVert.c` define direct and indexed position, color,
  and texture-coordinate emission; and
- `include/dolphin/gx/GXEnum.h` defines `GX_TRIANGLES`, `GX_QUADS`, descriptor
  modes, and vertex attributes.

The bounded Apple plan-to-packet representation, immutable staging policy,
and host CMake/CTest targets have no direct decomp counterpart.

## Independent source and exact-merge reviews

The source candidate was independently reviewed before PR creation. That
review found no P0/P1/P2 issue in the seven-path scope, bounded topology and
capacity rules, failure immutability, sink count agreement, or legacy-path
preservation.

After PR #23 merged, a separate read-only review inspected detached, clean
source worktree:

`/private/tmp/acgc-integrator-apple-geometry-merged`

at exact merge `de9a26fee8a89a55903b8f9dd0a0896daf41c0e3`.
It verified the merge object, PR state, exact seven-path `+500/-67` scope,
candidate/merge tree equality, source semantics, retained build roots, test
logs, and sanitizer flags. The final verdict was PASS with no P0/P1 blocker
and explicit authorization for umbrella integration.

## Exact-merge focused verification

Fresh native root:

`/private/tmp/acgc-apple-geometry-merged-native.ENzcal`

```sh
cmake -S /private/tmp/acgc-integrator-apple-geometry-merged/pc/apple \
  -B /private/tmp/acgc-apple-geometry-merged-native.ENzcal \
  -G Ninja \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-apple-geometry-merged-native.ENzcal \
  --target acgc_apple_canonical_plan_consumer_fixture \
           acgc_renderer_geometry_tests \
           acgc_renderer_geometry_cpp_tests \
           acgc_metal_packet_consumer_tests \
           acgc_metal_sink_tests \
           acgc_metal_packet_consumer_v2_texture_tev_tests \
           acgc_metal_packet_consumer_v2_runtime_sideband_tests \
           acgc_metal_packet_consumer_v2_channel_source_tests \
  --parallel 1
ctest --test-dir /private/tmp/acgc-apple-geometry-merged-native.ENzcal \
  -N -R '^(acgc_apple_canonical_plan_consumer_fixture|acgc_renderer_geometry_tests|acgc_renderer_geometry_cpp_tests|acgc_metal_packet_consumer_tests|acgc_metal_sink_tests|acgc_metal_packet_consumer_v2_texture_tev_tests|acgc_metal_packet_consumer_v2_runtime_sideband_tests|acgc_metal_packet_consumer_v2_channel_source_tests)$'
ctest --test-dir /private/tmp/acgc-apple-geometry-merged-native.ENzcal \
  --output-on-failure --parallel 1 \
  -R '^(acgc_apple_canonical_plan_consumer_fixture|acgc_renderer_geometry_tests|acgc_renderer_geometry_cpp_tests|acgc_metal_packet_consumer_tests|acgc_metal_sink_tests|acgc_metal_packet_consumer_v2_texture_tev_tests|acgc_metal_packet_consumer_v2_runtime_sideband_tests|acgc_metal_packet_consumer_v2_channel_source_tests)$'
```

Result: configure/generate passed; the serialized target build completed 61
steps; discovery found exactly eight tests; all eight passed in 0.47 seconds.

Fresh combined ASan/UBSan root:

`/private/tmp/acgc-apple-geometry-merged-asan-ubsan.c2qB61`

```sh
cmake -S /private/tmp/acgc-integrator-apple-geometry-merged/pc/apple \
  -B /private/tmp/acgc-apple-geometry-merged-asan-ubsan.c2qB61 \
  -G Ninja \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_OBJC_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-apple-geometry-merged-asan-ubsan.c2qB61 \
  --target acgc_apple_canonical_plan_consumer_fixture \
           acgc_renderer_geometry_tests \
           acgc_renderer_geometry_cpp_tests \
           acgc_metal_packet_consumer_tests \
           acgc_metal_sink_tests \
           acgc_metal_packet_consumer_v2_texture_tev_tests \
           acgc_metal_packet_consumer_v2_runtime_sideband_tests \
           acgc_metal_packet_consumer_v2_channel_source_tests \
  --parallel 1
ctest --test-dir /private/tmp/acgc-apple-geometry-merged-asan-ubsan.c2qB61 \
  -N -R '^(acgc_apple_canonical_plan_consumer_fixture|acgc_renderer_geometry_tests|acgc_renderer_geometry_cpp_tests|acgc_metal_packet_consumer_tests|acgc_metal_sink_tests|acgc_metal_packet_consumer_v2_texture_tev_tests|acgc_metal_packet_consumer_v2_runtime_sideband_tests|acgc_metal_packet_consumer_v2_channel_source_tests)$'
ctest --test-dir /private/tmp/acgc-apple-geometry-merged-asan-ubsan.c2qB61 \
  --output-on-failure --parallel 1 \
  -R '^(acgc_apple_canonical_plan_consumer_fixture|acgc_renderer_geometry_tests|acgc_renderer_geometry_cpp_tests|acgc_metal_packet_consumer_tests|acgc_metal_sink_tests|acgc_metal_packet_consumer_v2_texture_tev_tests|acgc_metal_packet_consumer_v2_runtime_sideband_tests|acgc_metal_packet_consumer_v2_channel_source_tests)$'
```

Result: configure/generate passed; the serialized target build completed 61
steps; discovery found exactly eight tests; all eight passed in 0.86 seconds.
The retained logs contain no AddressSanitizer, UndefinedBehaviorSanitizer,
LeakSanitizer, runtime-error, or failed-test diagnostic.

## Concurrent post-Texgen runtime frontier

The Apple PR is independent of the serialized real-process producer trace. A
separate bounded trace used the exact `7636cc1d8` arm64 `ac_pc` binary at:

`/private/tmp/acgc-postfix-7636-full.UIutEh/bin/AnimalCrossing`

Binary SHA-256:
`26ea9ff04e15b275b622b221dfac645f199961eab8851c0fd70ac89bc9864e18`.

The final trace root is:

`/private/tmp/acgc-live-lane350-postfix-final.H9Up9C`

- `events.log` SHA-256:
  `00601b62d14fb7493530a16d7540c8535762eb42f4af214a9d5d3cde7c23374d`
- `pid.log` SHA-256:
  `02495b343580b783d7ad997245e1619523842a010441a2aa8b2470d3f1e0242c`
- `lldb.log` SHA-256:
  `8059a0a1aa3988bf4767701f46c504f61e4b6ceae7aab92c1445252be0ac00f8`

The trace recorded exactly 20 process-lifetime attempts and 306 events. On all
20 attempts:

- Transform succeeded;
- Channels succeeded;
- Texgen's raw predicates, canonical validator, and producer succeeded;
- Texture/Dynamic succeeded;
- TEV failed at `pc_gx_raw_tev_build_canonical`;
- the cumulative notify result was no-publication; and
- no envelope or Apple callback delivery occurred.

The harness stopped at the requested attempt limit and cleaned up the exact
recorded inferior PID. No material correlation, preflight, or cleanup failure
was recorded. This moves the live first-failing producer from Texgen to TEV.
It does not diagnose TEV's exact source predicate, authorize a fix, or prove
cumulative publication, Apple dispatch, Metal encode, pixels, device behavior,
or playability.

## Proof boundary and next gate

Proved:

- exact PR #23 integration and seven-path Apple scope;
- bounded canonical triangle and quad conversion to at most 192 renderer
  vertices;
- source-backed CPU fixture coverage, legacy-path preservation, and failure
  immutability;
- exact-merge native and combined ASan/UBSan configure, compile, link,
  discovery, and execution of the eight focused tests; and
- the independent real-process fact that TEV is now the first failing
  canonical producer after Texgen and Texture/Dynamic succeed.

Not proved:

- a full `ac_pc` link at `de9a26fee`;
- cumulative-envelope publication or a real Apple callback;
- Metal encode, present, readback, pixels, or device behavior;
- input, audible audio, save/reload, lifecycle, Windows execution, iOS, or
  playability.

The next critical-path source gate is one source-faithful TEV correction owned
by exactly one production lane, with a focused fixture, fresh native and
combined ASan/UBSan execution, independent immutable review, one PC PR/merge,
and exact-merge verification. Only after that merge should another bounded
serialized process trace identify the next producer failure or first envelope
publication.
