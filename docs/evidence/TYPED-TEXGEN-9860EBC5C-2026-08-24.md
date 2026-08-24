# Typed Texgen admission and Texture runtime frontier

Date: 2026-08-24

## Outcome

PC PR #32 merged the independently reviewed, exact-profile Texgen admission as
`9860ebc5c3628426da74222aef4448ed6f86bec6`. Fresh exact-merge native and
combined ASan/UBSan Apple consumer and source-backed PC round-trip fixtures
each discover exactly one selected test and pass `1/1`. The complete umbrella
canonical-pipeline runner also freshly passes PC `1/1` and Apple `4/4` in both
native and combined-sanitizer configurations.

A serialized full link from the exact clean merge produced an arm64
`AnimalCrossing` binary. Exactly one bounded real-process attempt passed all
fourteen producers, assembled and published the cumulative envelope, built a
value-owned Apple plan, and advanced through Geometry, Channels, and Texgen.
The public typed consumer then returned status `17`,
`CANONICAL_TEXTURE_UNSUPPORTED`; no sink call occurred.

This is bounded CPU conversion and real-process frontier evidence. It is not a
Texgen coordinate transformation, texture decode, TEV evaluation, Metal
encode, present, readback, pixel, device, or playability claim.

## Immutable references

- Umbrella base before this integration:
  `581e8269420e86961e281c1825aaa0240911889c`.
- PC merge: `9860ebc5c3628426da74222aef4448ed6f86bec6`.
- PC first parent: `dabc78208b68c24805054f740f6b82ea0c855822`.
- Reviewed source commit: `2fd013273040cc91e3f446791aa37a66d87a9742`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- PC PR: [#32, Admit the exact active Texgen canonical profile](https://github.com/jskoiz/ACGC-PC-Port/pull/32).

The merge has exactly those two parents and changes only:

- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/tests/test_apple_canonical_plan_consumer.c`

Its first-parent diff is `+398/-10`; `git diff --check` passes. The source
commit uses `jskoiz <20649937+jskoiz@users.noreply.github.com>`. The PC tip
contains no `.github/workflows` entries, PR #32 reports no hosted checks or
reviews, and no paid hosted Apple workflow was triggered.

## Bounded source contract

The existing canonical validator and zero-active-generator path remain intact.
The added branch accepts only the one fully captured cumulative profile:

- Geometry is the already-supported 51-vertex triangle-list
  `POS|NRM|CLR0|TEX0` shape with normalized component mask `0x53`;
- active Texgen count is exactly two, all eight source records are known, and
  only the two observed ordinary matrices and one post matrix are known;
- record 0 is `MTX2x4`, source `TEX0`, ordinary selector `30`, post selector
  `125`, normalization disabled, and all components known;
- record 1 is the same regular `TEX0` function with ordinary selector `60`;
- ordinary selector `30` is the exact observed eight-word `MTX2x4` payload,
  ordinary selector `60` and post selector `125` are exact finite identity
  `MTX3x4` payloads, and all SU state is inactive;
- every live vertex carries effective selector pair `[30, 60]` and zero for
  selectors 2 through 7.

The consumer still emits only position and materialized color. It does not
transform or emit texture coordinates, and it does not claim the later
Texture/TEV state is renderable. The focused fixture retains input and failure
immutability and rejects changes to counts, masks, functions, sources,
selectors, matrix forms, matrix words, nonfinite words, SU state, reserved
fields, per-vertex selectors, and the Geometry component shape.

## Two-upstream crosswalk

PC host ownership is in:

- `pc/apple/src/metal_packet_consumer.c` for the bounded normalized-plan
  Texgen predicate and typed section status;
- `pc/apple/tests/test_apple_canonical_plan_consumer.c` for the accepted
  profile and adversarial mutation controls;
- `pc/src/pc_gx.c` and `pc/src/pc_gx_texgen_producer.c` for raw matrix/Texgen
  ownership and canonical production; and
- `src/static/libforest/emu64/emu64.c` for the source call sequence that loads
  the two ordinary selectors, post identity, and two active generators.

The original-behavior oracle is:

- `src/static/dolphin/gx/GXAttr.c` for `GXSetTexCoordGen2` and
  `GXSetNumTexGens`;
- `src/static/dolphin/gx/GXTransform.c` for texture and post-transform matrix
  load semantics;
- `include/dolphin/gx/GXGeometry.h` and `GXTransform.h` for the public GX
  selector/matrix contract; and
- `src/static/libforest/emu64/emu64.c` for the game-owned setup order.

The normalized Apple admission predicate and renderer-facing CPU output have
no direct decomp counterpart. The change therefore stays tied to the exact
observed state and explicitly does not present itself as a general Texgen or
texture renderer.

## Exact focused verification

The fresh exact-merge focused roots use clean detached source
`/private/tmp/acgc-texgen-merge-986-source`:

- `/private/tmp/acgc-texgen-merge-986-gates.2CZxlj/apple-native`
- `/private/tmp/acgc-texgen-merge-986-gates.2CZxlj/apple-asan-ubsan`
- `/private/tmp/acgc-texgen-merge-986-gates.2CZxlj/pc-native`
- `/private/tmp/acgc-texgen-merge-986-gates.2CZxlj/pc-asan-ubsan`

The exact selected commands were:

```sh
ctest --test-dir <apple-root> --output-on-failure --parallel 1 \
  -R '^acgc_apple_canonical_plan_consumer_fixture$'
ctest --test-dir <pc-root> --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_canonical_plan_roundtrip_fixture$'
```

Exact discovery reports one test in every root. Native Apple, native PC,
ASan/UBSan Apple, and ASan/UBSan PC each pass `1/1`; retained logs contain no
AddressSanitizer, UndefinedBehaviorSanitizer, LeakSanitizer, or runtime-error
diagnostic.

The synchronized umbrella runner was then executed from this integration
worktree against the same exact source:

```sh
scripts/verify-canonical-pipeline.zsh \
  --pc-root /private/tmp/acgc-texgen-merge-986-source \
  --build-root /private/tmp/acgc-canonical-pipeline-986-umbrella
```

It freshly configured and serialized the source-backed PC round-trip and all
four Apple parser/plan/handoff/consumer fixtures. Exact discovery found PC `1`
and Apple `4` tests in each mode; native PC passed `1/1`, native Apple passed
`4/4`, sanitizer PC passed `1/1`, and sanitizer Apple passed `4/4`, with zero
skips or sanitizer diagnostics.

## Exact full link

The clean exact-merge source was configured with Ninja, Debug,
`PC_DARWIN_COMPILE_AUDIT=ON`, and `BUILD_TESTING=OFF`, then built serially:

```sh
cmake --build /private/tmp/acgc-texgen-merge-986-acpc \
  --target AnimalCrossing --parallel 1
```

The link completed successfully. The resulting artifact is:

- path: `/private/tmp/acgc-texgen-merge-986-acpc/bin/AnimalCrossing`
- type: Mach-O 64-bit executable arm64
- size: 15,237,616 bytes
- SHA-256: `cd6832a6e2fc5e54193abb55550434cc0150d1b6bfb9b00b28be8d189fcbcb24`
- UUID: `04012134-67AA-3C5F-BB39-E3E6F3D35F91`

This proves source compilation and final symbol resolution only, not launch or
renderer behavior.

## Bounded runtime trace

The retained trace root is
`/private/tmp/acgc-texgen-merge-986-trace.TEpBo5`. The harness pins the exact
source commit, binary SHA-256, binary UUID, runtime directory, one-attempt
limit, and required symbols. A no-launch preflight resolved all 47 named and
line-derived breakpoints exactly once. Because the compiler inlined the
section-status helper, the harness records ordered Geometry/Channels/Texgen
reachability and uses the public typed consumer return; it does not fabricate a
helper return from volatile argument registers.

The only process attempt records:

- all fourteen producer results equal `1`, in the expected dependency order;
- plan status `0` (`OK`), gather result `1`, and notification result `1`;
- handoff result `2` (`PLAN_PUBLISHED`) for attempt ID `1`;
- published and consumer plan pointer `0x100558290` with matching digest
  `b557da7b37b4060b5c6b33cc28e7bda945446f00f325145f02d7a42edc391062`;
- ordered typed reachability through Geometry, Channels, and Texgen;
- the public consumer return `17`, `CANONICAL_TEXTURE_UNSUPPORTED`;
- no sink call and a null sink status;
- an empty structured error list, LLDB exit `0`, and no live LLDB or inferior
  PID after cleanup.

The published Texture section is canonical-valid and active, not the previous
all-zero fixture state: known and required map masks are `0xff`, all eight map
records are nonzero, map 0 is indexed and TLUT-backed, and the existing plan
dependency validator accepts its matching Dynamic metadata. The captured TEV
state has two active stages and stage 0 references texcoord/map 0. These facts
prevent the integration record from describing Texture as harmless inactive
metadata or from authorizing Texture-only admission that would silently keep
emitting vertex color.

Independent immutable review passed the trace with no P0/P1 finding. It
rechecked the exact source parents and cleanliness, binary identity, 155
contiguous schema-1 events, 47 uniquely resolved successor symbols, all
fourteen producer pairs, one-attempt correlation, matching plan digests,
ordered section gates, public status 17, absence of a sink event, LLDB exit 0,
and exact PID cleanup. Two P2 limits remain explicit: the unsupported-bump
check entered but its return event was not captured even though the plan
returned `OK`, and the headless log contains display/link-service warnings
that did not correlate with a structured failure. Neither is upgraded into
exhaustive per-check proof or renderer proof.

## Proof boundary and next gate

This evidence proves the exact PC merge, fresh focused native/sanitizer CPU
gates, the full umbrella canonical runner, full arm64 link, one bounded
cumulative publication, matching value-plan handoff, repaired Texgen predicate,
and the next typed Texture frontier.

It does not prove transformed/emitted texture coordinates, Texture/TLUT byte
consumption, TEV evaluation, a sink submission, Metal command encoding,
presentation, readback, pixels, audio, input, save/reload, device behavior, or
playability.

The immediate successor is a single source owner selected only after the
Texture/TEV/Dynamic dependency audit determines the smallest atomic
source-faithful contract. A Texture-only predicate relaxation is not authorized
by this trace. The separate J2D quad-plan fixture, projection audit, nested-ROM
hygiene, and immutable download replay remain non-overlapping work and do not
displace this live path.
