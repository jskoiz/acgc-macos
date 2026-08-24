# Typed canonical Geometry consumer — PC `d40ca1c2c`

## Outcome

PC [PR #29](https://github.com/jskoiz/ACGC-PC-Port/pull/29),
`Accept canonical normal and texcoord geometry words`, merged into
`c1/macos-host-launch` as
`d40ca1c2caeedf4ebf1ef0315d211cc88dee2c34`.

- PC base: `6c5a626d958bb8e056282d4a6872770c59e20789`
- Reviewed source commit:
  `9161049d6c74c65b34292b000f66443d3c5117f6`
- PC merge: `d40ca1c2caeedf4ebf1ef0315d211cc88dee2c34`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The exact first-parent merge diff changes only:

- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/tests/test_apple_canonical_plan_consumer.c`
- `pc/tests/pc_gx_canonical_plan_roundtrip_fixture.c`

The merge has parents `6c5a626d9` and `9161049d6`; `git diff --check`
passes. Neither tree contains `.github/workflows`, and PR #29 reported no
hosted checks. No paid hosted Apple runner was configured or triggered.

## Exact `6c5a626d9` link and bounded trace

Before changing the typed consumer, the integration owner serialized one full
`ac_pc` link from exact clean PC `6c5a626d9`.

- build root: `/private/tmp/acgc-6c5-acpc`
- binary: `/private/tmp/acgc-6c5-acpc/bin/AnimalCrossing`
- format: arm64 Mach-O
- byte size: `15,264,720`
- SHA-256:
  `b6d8dd31ba26f4a45679ffd6fe7caf33f2e63a04d76aeefc30b966dd247b2088`
- UUID: `2E339581-9D43-3F58-A301-234BCE4FCB4C`
- link result: `NOUNDEFS`, with zero unresolved internal `_pc_`, `_GX`, or
  `_acgc_` symbols

One bounded LLDB run used `--verbose --no-framelimit`,
`ACGC_GRAPH_CAPTURE=1`, a 20-attempt/60-second ceiling, symbol-name
breakpoints, exact PID ownership, and exact-PID cleanup. The retained trace is
under `/private/tmp/acgc-6c5-live-trace.FNn6pd`. LLDB PID `12523` and inferior
PID `12530` both exited; no inferior survived.

The first real cumulative attempt produced:

- all fourteen producer results equal to `1`, in canonical order;
- gather result `1` and attempt notification result `1`;
- Apple handoff `2` (`PLAN_PUBLISHED`);
- Apple plan `0` (`OK`);
- Geometry decode `0` (`OK`) for one triangle-list batch with 51 vertices,
  `vtxfmt == 0`, `indexed_mask == 0`, and `present_mask == 0x2e00`;
- typed consumer entry; and
- typed consumer status `13`,
  `CANONICAL_GEOMETRY_UNSUPPORTED`.

The live attribute set was `POS|NRM|CLR0|TEX0`. The sink was not entered. This
proved that the prior Apple-plan double decode was repaired and moved the
frontier to the typed Geometry predicate. It did not prove Metal submission,
presentation, or pixels.

## Repaired typed-consumer contract

The merged consumer keeps POS and CLR0 required and preserves the existing
optional PNMTXIDX behavior. It now also accepts optional NRM and TEX0,
including the exact live contract:

- `present_mask == 0x2e00`;
- `component_mask == 0x53`; and
- finite canonical binary32 position, normal, and TEX0 words.

NRM and TEX0 are validated input only. The existing renderer-neutral output
still contains position and color; no lighting, texture binding, sampler,
shader, or Metal output ABI was added.

The bounded predicate still requires:

- global and per-vertex present/component masks to match;
- absent NRM/TEX0 and every wider field to remain zero;
- NBT, CLR1, TEX1+, TEXnMTXIDX, malformed selectors, non-finite words, and
  unsupported topologies to fail closed;
- exact position-matrix IDs and Transform knownness;
- bounded triangle/quad counts and zero trailing vertex storage; and
- staged output publication with unchanged input/output on failure.

Effective ordinary texture selectors accept only normalized zero or the GX
logical selector set `30, 33, ... 60`. The decomp oracle defines
`GX_TEXMTX0..9` in `30..57` and `GX_IDENTITY == 60`. An absent raw
`TEXnMTXIDX` may therefore retain a valid effective Texgen selector without
being mistaken for a raw vertex matrix attribute. The later typed Texgen
predicate remains responsible for renderability.

The source-backed root fixture now proves that its wider canonical Geometry
passes the Geometry predicate and stops at
`CANONICAL_TEXGENS_UNSUPPORTED`. That is an explicit next frontier, not a
claim that active Texgen or textures render.

## Independent review

An independent immutable reviewer found no P0, P1, or P2 issue. It verified
the exact clean three-path scope, PC/decomp crosswalk, selector domain,
finite-word checks, absent/wider-field rejection, topology and matrix
constraints, trailing-zero checks, input/output immutability, and the unchanged
position-plus-color output ABI.

The reviewer independently rebuilt and ran both focused fixtures with
`--parallel 1` in fresh native and combined ASan/UBSan roots. Every anchored
regex discovered exactly one test and passed `1/1`; no sanitizer finding was
reported.

## Exact-merge focused verification

Detached, clean source worktree:

`/private/tmp/acgc-integrator-typed-geometry-merged`

at exact merge `d40ca1c2caeedf4ebf1ef0315d211cc88dee2c34`.

Fresh native roots:

- `/private/tmp/acgc-typed-geometry-merge-apple-native`
- `/private/tmp/acgc-typed-geometry-merge-pc-native`

Fresh combined ASan/UBSan roots:

- `/private/tmp/acgc-typed-geometry-merge-apple-asan-ubsan`
- `/private/tmp/acgc-typed-geometry-merge-pc-asan-ubsan`

The Apple roots built only
`acgc_apple_canonical_plan_consumer_fixture`; the PC roots built only
`acgc_pc_gx_canonical_plan_roundtrip_fixture`. Builds used `--parallel 1`,
and CTest used anchored exact regexes plus `--parallel 1`.

Results:

- native Apple consumer: exactly Test #4, `1/1` passed;
- native PC source-backed round trip: exactly Test #39, `1/1` passed;
- ASan/UBSan Apple consumer: exactly Test #4, `1/1` passed in 0.05 seconds;
- ASan/UBSan PC source-backed round trip: exactly Test #39, `1/1` passed in
  0.05 seconds; and
- no AddressSanitizer, UndefinedBehaviorSanitizer, or runtime-error diagnostic.

## Verification-runner boundary

The corrected umbrella verification runner is not integrated yet. Its first
exact-`6c5a626d9` full matrix correctly exposed a stale Apple-plan fixture
expectation: the fixture writes final logical RGBA8 words `0x11223344` and
`0x55667788` but still expected their old byte-swapped forms. A separate
fixture-only candidate changes those two expectations, has independent PASS
review, and is being replayed after `d40ca1c2c` before integration. Production
Apple-plan code is not changed for that stale test.

Consequently this evidence claims the two focused exact-merge gates above,
not a green complete runner matrix.

## Two-upstream crosswalk

The PC host implementation owns:

- canonical raw Geometry production in `pc/src/pc_gx_geometry_producer.c`;
- value normalization in `pc/apple/src/apple_canonical_plan.c`;
- the bounded typed predicate in
  `pc/apple/src/metal_packet_consumer.c`; and
- the focused Apple and root source-backed fixtures in the two changed test
  files.

The decomp oracle preserves original GX attribute and selector behavior in
`include/dolphin/gx/GXEnum.h`, `GXGeometry.h`, and `GXVert.h`, plus
`src/static/dolphin/gx/GXAttr.c`, `GXGeometry.c`, and `GXVert.c`. J2D source
callers include `J2DGrafContext.cpp` and `JUTResFont.cpp`. The decomp tree has
no host cumulative envelope, Apple canonical plan, typed CPU consumer, CMake
fixture, sanitizer, or Metal handoff counterpart.

## Proof boundary and next gate

Proved:

- exact PC PR #29 parentage, scope, and merge;
- one bounded exact-`6c5a626d9` real process reaching a successful cumulative
  gather, Apple plan, and the typed Geometry predicate;
- bounded canonical NRM/TEX0 validation without widening the renderer output;
- retained fail-closed topology, selector, Transform, zero-storage, and
  immutability constraints; and
- exact-merge native plus combined ASan/UBSan focused execution.

Not proved:

- a full `ac_pc` link or real-process trace at `d40ca1c2c`;
- active Texgen, texture, lighting, or TEV rendering;
- a call to the Metal sink from this canonical attempt;
- Metal encode, present, readback, pixels, device behavior, input, audio,
  save/reload, teardown, iOS, or playability.

After the independently reviewed stale color expectation lands, the next live
gate is one serialized exact-tip full link and the same bounded trace. It must
stop at the next typed section or sink result. The source-backed fixture
predicts `CANONICAL_TEXGENS_UNSUPPORTED`, but only the exact process trace can
establish the live result.
