# Canonical plan source-backed round trip — `818bfe547` — 2026-08-23

## Outcome

PC PR [#18](https://github.com/jskoiz/ACGC-PC-Port/pull/18), **Add
source-backed canonical plan round-trip gate**, is merged on
`c1/macos-host-launch` as
`818bfe5475eddb6fba8dcebba39a829e21dffde5`. The merge has first parent
`bd660f754a9706100b357c62af5213eea00ec680` and reviewed topic parent
`2e20eaa47220c9d330b23f049f25acf25968ea60`.

The merged fixture proves that one deliberately bounded producer-compatible
case can be constructed from actual PC GX setter state and carried through the
complete CPU value path: completed raw Geometry, fourteen-section cumulative
gathering, explicit little-endian encoding and assembly, Apple structural
parsing, normalized canonical-plan construction, and preparation of the
existing Metal packet-consumer output.

The change is test-only. It does not alter production source membership,
callback registration, runtime arbitration, semantic-path fallback, the Metal
sink, shaders, or legacy rendering.

## Immutable scope

The exact `bd660f754..818bfe547` PC diff is two paths, 810 insertions and no
deletions:

- `pc/CMakeLists.txt` registers
  `acgc_pc_gx_canonical_plan_roundtrip_fixture` under the existing
  `APPLE AND PC_DARWIN_COMPILE_AUDIT AND BUILD_TESTING` condition; and
- `pc/tests/pc_gx_canonical_plan_roundtrip_fixture.c` owns the source-backed
  setup, synchronous observation, assertions, failure cases, and PASS sentinel.

No production implementation or public header changed. GitHub reports one
topic commit, those two paths, `+810/-0`, no reviews, and no hosted status-check
rollup. The merged PC tree contains no `.github/workflows` path, so all proof
below is local exact-merge evidence.

## Source-backed contract

The fixture establishes the supported no-resource subset through actual PC GX
setter entry points. It does not write `g_gx` fields directly. It configures
known projection/model, channel, TEV, blend, depth, raster, viewport/scissor,
texture-owner epoch, and disabled optional-state predicates; emits exactly one
direct, non-indexed POS+CLR0 three-vertex triangle with real `GXBegin` and
`GXEnd`; and observes the synchronous cumulative callback.

Inside that callback, caller-owned envelope bytes are copied while valid and
then passed through:

1. the production cumulative gatherer and assembler;
2. `acgc_apple_canonical_plan_build`; and
3. `acgc_metal_packet_consumer_prepare_canonical_plan`.

The successful result asserts the expected complete envelope, normalized
three-vertex plan, canonical source provenance, transform, positions, colors,
primitive/count, and bounded raster state. This closes Lane 337's conditional
producer-reachability question only for the no-`PNMTXIDX`, direct POS+CLR0
triangle subset. Explicit `PNMTXIDX`, textures, TLUTs, texgens, lighting, fog,
indirect state, dynamic resources, larger batches, and other attributes remain
outside this gate.

## Failure and ownership coverage

The fixture also verifies that:

- mutating an otherwise successful plan into a consumer-rejected form leaves
  the caller's packet-consumer output byte-for-byte unchanged;
- clearing the cumulative callback makes a later source-backed publication a
  successful no-op and leaves no Texture/TLUT borrow active;
- a source-backed composition failure publishes zero callbacks and releases
  the borrow before returning;
- re-registering the callback after that failure permits a valid retry; and
- final callback clear and GX shutdown leave no callback or borrow state held.

The fixture therefore exercises synchronous callback and resource-lifetime
reuse, but it does not establish cross-thread safety or asynchronous ownership.

## Independent review

Lane 341 independently reviewed candidate
`2e20eaa47220c9d330b23f049f25acf25968ea60` and returned PASS with no
P0/P1/P2 finding. The review confirmed the exact two-file/test-only scope,
actual setter and `GXBegin`/`GXEnd` provenance, complete gatherer-to-consumer
composition, direct PASS-sentinel behavior, failure output immutability,
callback clear/re-registration, zero publication and borrow release on failed
composition, retry success, and absence of duplicate linked objects or an
obvious false-green path.

The integration owner then repeated the focused gates on the authoritative
merge commit rather than relying only on the topic-branch roots.

## Reference crosswalk

Host/Windows and canonical source at the authoritative PC tip:

- `pc/src/pc_gx.c` owns GX setters, completed Geometry capture, the guarded
  flush publication seam, and callback lifecycle;
- `pc/src/pc_gx_cumulative_gatherer.c` builds and encodes all fourteen
  canonical sections under the Texture/TLUT borrow transaction;
- `pc/src/pc_gx_cumulative_snapshot.c` assembles the explicit little-endian
  envelope;
- `pc/apple/src/apple_canonical_envelope_parser.c` structurally parses that
  envelope;
- `pc/apple/src/apple_canonical_plan.c` decodes and normalizes the complete
  value plan; and
- `pc/apple/src/metal_packet_consumer.c` prepares the bounded packet-consumer
  output.

Original behavior and wire-layout oracle remains `upstream/ac-decomp` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`:

- `src/static/dolphin/gx/GXAttr.c`, `GXGeometry.c`, and `GXVert.c`, together
  with `include/dolphin/gx/GXGeometry.h` and `GXVert.h`, define the original
  descriptor, format, array, begin, and vertex FIFO behavior; and
- `GXTransform.c`, `GXLight.c`, `GXTexture.c`, `GXTev.c`, `GXPixel.c`, and
  `GXBump.c` define original setter/state semantics represented by the
  canonical sections.

The cumulative envelope, borrow protocol, Apple parser/plan, packet-consumer
adapter, test CMake target, and source-backed host fixture have no direct
decomp counterpart.

## Exact merged-tip verification

Authoritative source:

```text
/private/tmp/acgc-integrator-roundtrip-merged.4OciEp
HEAD 818bfe5475eddb6fba8dcebba39a829e21dffde5
status: detached and clean
```

Fresh native root:

```bash
cmake -S /private/tmp/acgc-integrator-roundtrip-merged.4OciEp/pc \
  -B /private/tmp/acgc-roundtrip-merged-native.q5kozw \
  -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug

cmake --build /private/tmp/acgc-roundtrip-merged-native.q5kozw \
  --target acgc_pc_gx_canonical_plan_roundtrip_fixture --parallel 1
```

The fresh target build completed 65 steps. Direct execution printed
`pc GX canonical plan source-backed round trip: PASS`. Anchored CTest discovery
found exactly Test #39 and one total test; the exact regex passed `1/1` in
0.01 seconds.

Fresh combined ASan/UBSan root
`/private/tmp/acgc-roundtrip-merged-asan-ubsan.kaxqFW` used the same commands
with:

```text
-fsanitize=address,undefined -fno-omit-frame-pointer
```

and matching executable linker flags. Its fresh 65-step target build passed,
direct execution printed the same PASS sentinel, exact discovery found only
Test #39, and the exact CTest passed `1/1` in 0.05 seconds. `LastTest.log`
contains no AddressSanitizer, UndefinedBehaviorSanitizer, runtime-error,
`ERROR`, or `FAILED` diagnostic.

The builds emitted only existing compile-time diagnostics, including legacy
prototype warnings, an `INT_MIN` macro warning, and an AppleClang warning that
one requested option is unsupported. None produced a compile, link, test, or
sanitizer failure.

Because the change is test-only and leaves the normal production target graph
unchanged from `bd660f754`, this integration did not repeat the full serialized
`ac_pc` link. No process was launched and no asset was accessed.

## Evidence boundary

This proves the exact merged source/CMake integration and one narrow
source-backed CPU composition from actual GX setters through cumulative
gather/assembly, Apple parsing/normalization, and bounded packet-consumer
preparation. It also proves the documented output-immutability,
no-callback/failure publication, borrow cleanup, callback re-registration, and
retry cases in fresh native and combined ASan/UBSan builds.

It does **not** prove production runtime arbitration, retained-plan freshness,
semantic-path fallback, one real game envelope reaching the adapter, process
launch, Metal encode/submit/present/readback, pixels, device behavior,
textures/TLUTs or broader Geometry support, input, audible audio, save/reload,
lifecycle completion, iOS, or human playability. The next source gate is a
reviewed production arbitration/freshness contract that preserves the existing
semantic path. A real-process delivery trace remains a separate later gate and
requires explicit authority before accessing ignored proprietary assets.
