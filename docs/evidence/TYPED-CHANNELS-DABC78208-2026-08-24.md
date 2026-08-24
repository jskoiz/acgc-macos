# Typed Channels AF_NONE integration and Texgen runtime frontier

Date: 2026-08-24

## Outcome

PC PR #31 merged the independently reviewed bounded active-Channel correction
as `dabc78208b68c24805054f740f6b82ea0c855822`. Fresh exact-merge native and
combined ASan/UBSan Apple consumer and source-backed root fixtures each discover
exactly one selected test and pass `1/1`. A serialized full link from that exact
clean source produced an arm64 `AnimalCrossing` binary, and one bounded real
attempt advanced the first typed consumer frontier from Channels status 15 to
Texgen status 16. A second attempt using the same exact source and binary was
then bounded to capturing the two Texgen fields omitted by the first harness;
it did not advance or change the frontier.

This is CPU conversion and bounded real-process frontier evidence. It is not a
Metal encode, present, readback, pixel, device, or playability claim.

## Immutable references

- Umbrella base before this integration:
  `1c0763ef8cb2a11b7a962c0d84709645d1b1c660`.
- PC merge: `dabc78208b68c24805054f740f6b82ea0c855822`.
- PC first parent: `621a4d548b0f6f82004c44654713751461dff3c9`.
- Reviewed source commit: `25195dfd8e0c5642e67b505e373d01f9de2f01fb`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- PC PR: [#31, Support typed AF_NONE canonical channel lighting](https://github.com/jskoiz/ACGC-PC-Port/pull/31).

The merge has exactly those two parents and changes only:

- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/tests/test_apple_canonical_plan_consumer.c`

Its first-parent diff is `+623/-28`; `git diff --check` passes. The source commit
uses `jskoiz <20649937+jskoiz@users.noreply.github.com>`. The PC tip contains no
`.github/workflows` files, PR #31 reports no hosted checks or reviews, and no
paid hosted Apple workflow was triggered.

## Bounded source contract

The pre-existing disabled vertex-color path remains unchanged. The added mode
accepts exactly one valid channel record whose color half is enabled,
REG/REG-sourced, has a nonzero light mask, uses `DF_CLAMP` and `AF_NONE`, while
its alpha half remains disabled REG/VTX with no lights, diffuse, or attenuation.
The second channel record must remain zero.

Before writing output, the consumer requires the referenced canonical Lighting
slots, a known normal matrix, finite nonzero light-position vectors, and finite
nonzero transformed vertex normals. It normalizes the matrix-transformed normal
and selected light positions, clamps their dot products, accumulates ambient and
diffuse RGB, multiplies by material RGB, clamps and rounds to 8-bit components,
and preserves the source vertex alpha. Candidate output remains staged so every
rejection leaves the caller output unchanged.

The focused fixture checks deterministic RGB values and rejects, among other
controls, VTX material/ambient sources, SPOT/SPEC attenuation, enabled alpha,
zero masks, missing loaded lights, zero/nonfinite light vectors, absent/zero
normal matrices, missing normals, nonfinite vertex normals, and a nonzero second
record.

## Two-upstream crosswalk

PC host ownership is in:

- `pc/apple/src/metal_packet_consumer.c` for typed section acceptance and
  pointer-free CPU vertex-color materialization;
- `pc/src/pc_gx.c` for `GXSetChanCtrl`, `GXSetChanAmbColor`,
  `GXSetChanMatColor`, and `GXLoadLightObjImm` raw ownership;
- `pc/src/pc_gx_channels_raw.c` and `pc/src/pc_gx_lighting_raw.c` for canonical
  production; and
- `src/static/libforest/emu64/emu64.c` for the active REG/REG, light-mask,
  `GX_DF_CLAMP`, `GX_AF_NONE`, disabled-alpha call sequence.

The original-behavior oracle is:

- `src/static/dolphin/gx/GXLight.c` for light-object load and channel
  ambient/material/control register semantics;
- `include/dolphin/gx/GXLighting.h` for the public GX lighting API; and
- `src/static/libforest/emu64/emu64.c` for loading lights, ambient/material
  values, active `GX_COLOR0`, and disabled `GX_ALPHA0`.

The host-side normalized CPU materialization and Metal packet adapter have no
direct decomp counterpart; the change therefore stays bounded to the exact
observed source state rather than presenting itself as a general GX lighting
renderer.

## Exact focused verification

All four roots point to the clean detached exact merge source at
`/private/tmp/acgc-channels-merge-dabc-source`:

- `/private/tmp/acgc-channels-merge-dabc-apple-native`
- `/private/tmp/acgc-channels-merge-dabc-apple-asan`
- `/private/tmp/acgc-channels-merge-dabc-pc-native`
- `/private/tmp/acgc-channels-merge-dabc-pc-asan`

The exact selected commands were:

```sh
ctest --test-dir <apple-root> --output-on-failure --parallel 1 \
  -R '^acgc_apple_canonical_plan_consumer_fixture$'
ctest --test-dir <pc-root> --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_canonical_plan_roundtrip_fixture$'
```

The sanitizer roots use:

```text
-O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined
-fno-sanitize-recover=all
```

and fail-fast `ASAN_OPTIONS`/`UBSAN_OPTIONS`. Exact discovery reports one test in
each root. Native Apple, native PC, ASan/UBSan Apple, and ASan/UBSan PC each pass
`1/1`; retained sanitizer logs contain no AddressSanitizer,
UndefinedBehaviorSanitizer, LeakSanitizer, or runtime-error diagnostic.

The synchronized umbrella runner was also executed from this integration
worktree against the exact `dabc78208` gitlink:

```sh
scripts/verify-canonical-pipeline.zsh \
  --pc-root /private/tmp/acgc-channels-merge-dabc-source \
  --build-root /private/tmp/acgc-canonical-pipeline-dabc-umbrella
```

It freshly configured and built the source-backed PC round-trip plus all four
Apple parser/plan/handoff/consumer fixtures in native and combined ASan/UBSan
trees. Exact discovery found PC `1` and Apple `4` tests in each mode; native PC
passed `1/1`, native Apple passed `4/4`, sanitizer PC passed `1/1`, and
sanitizer Apple passed `4/4`, with zero skipped tests or sanitizer diagnostics.

## Exact full link

The serialized build was:

```sh
cmake --build /private/tmp/acgc-channels-merge-dabc-acpc \
  --target AnimalCrossing --parallel 1
```

It completed 4,077 steps. The only final-link diagnostic was the known Mach-O
`__DATA,__common` alignment reduction warning. The resulting artifact is:

- path: `/private/tmp/acgc-channels-merge-dabc-acpc/bin/AnimalCrossing`
- type: Mach-O 64-bit executable arm64
- size: 15,290,128 bytes
- SHA-256: `91c1875cce09b220d0a92afccc350147ba0c4f8976dc7fc657cdb048feb7ca48`
- UUID: `BDBA00DA-5DF5-3109-9508-1802D085FEF4`

This proves source compilation and final symbol resolution only, not launch or
renderer behavior.

## Bounded runtime traces

The fresh trace root is
`/private/tmp/acgc-channels-merge-dabc-trace.GdylJL`. Its runner pins the source
commit, binary SHA-256, binary UUID, runtime directory, one-attempt limit, and a
60-second wall limit. LLDB resolved every required producer, validator, plan,
handoff, consumer, and sink symbol exactly once before launch.

The single attempt records:

- all fourteen producer results equal `1`, with no first producer failure;
- plan status `0` (`OK`) and no first plan failure;
- gather result `1`, notification result `1`, attempt ID `1`;
- handoff result `2` (`PLAN_PUBLISHED`);
- published and consumer plan SHA-256 both
  `b557da7b37b4060b5c6b33cc28e7bda945446f00f325145f02d7a42edc391062`;
- a 51-vertex triangle-list Geometry batch with `POS|NRM|CLR0|TEX0` passes;
- Channels passes the new bounded mode;
- canonical Texgen validation passes, but the typed consumer returns status
  `16`, `CANONICAL_TEXGENS_UNSUPPORTED`;
- the captured Texgen header has active count `2`, known mask `0xff`, ordinary
  matrix count `2`/mask `0x401`, post-matrix count `1`/mask `0x100000`, and no
  active SU record; record 0 is regular function `1`, source `4`, ordinary
  selector `30`, normalize `0`, post selector `125`;
- no sink call occurs, the trace error list is empty, no watchdog fires, LLDB
  exits `0`, and both recorded LLDB/inferior PIDs have exited.

The trace reads only bounded process memory and records canonical values. It
does not copy or publish proprietary assets and does not establish the semantic
contract of an unrecorded field by inference.

The first trace intentionally omitted Texgen record 1 and the ordinary matrix
at logical selector 30. Rather than infer either value, a second one-attempt,
60-second field-completion trace used the same exact source, binary SHA-256, and
UUID. Its root is
`/private/tmp/acgc-dabc-texgen-complete-trace.Zul418`. It again passes all
fourteen producers, plan construction, gather, publication, Geometry, and
Channels before returning the same typed status 16, with no sink call,
structured harness error, watchdog, or live PID after cleanup. It records:

- record 1 as regular function `1`, source `4`, ordinary selector `60`,
  normalize `0`, post selector `125`, and complete component-known mask
  `0x1f`;
- ordinary selector 30 as an eight-word `MTX2x4` load with known-word mask
  `0xff` and words
  `0x39800000, 0, 0, 0, 0, 0x3a800000, 0, 0`, with the remaining four storage
  words zero;
- the same values in the setter-owned raw state and canonical section; and
- effective Geometry selectors `[30, 60, 0, 0, 0, 0, 0, 0]` for every vertex.

This second run exists only to close the first harness's field-coverage gap. It
does not count as a retry, broader runtime sample, or evidence that Texgen is
applied to renderer output.

Independent read-only review passed both retained traces with no P0/P1 blocker.
It confirmed contiguous monotonic events, exact source/binary identity,
raw-to-canonical equality for the added record and matrix fields, one-attempt
correlation, and exact PID cleanup. Two P2 limits remain explicit: the traces
sample one owner-thread attempt rather than every frame or caller, and their
optional source-line breakpoint is stale for this source revision. The named
Texgen gate, validator result, typed return status, and absence of a sink call
are the authoritative frontier evidence.

## Proof boundary and next gate

This evidence proves the exact merge, the complete fresh native/sanitizer CPU
matrix, full arm64 link, bounded cumulative publication, matching value-plan
handoff, the repaired Geometry and Channels predicates, and the next typed
Texgen frontier plus its exact observed input fields.
It does not prove a sink submission, Metal command encoding, presentation,
readback, pixels, audio, input, save/reload, device behavior, or playability.

The immediate successor is the source-faithful active-Texgen correction now
owned by exactly one lane after the independent trace and predicate audits
converged.
Texture, TEV, Depth, Raster, sink, and Metal changes remain out of that lane.
