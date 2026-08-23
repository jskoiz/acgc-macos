# Texgen identity provenance — PC `7636cc1d8`

## Outcome

PC [PR #22](https://github.com/jskoiz/ACGC-PC-Port/pull/22),
`Restore Texgen identity provenance at GX init`, merged into
`c1/macos-host-launch` as
`7636cc1d801a8b0108ce3d8e3f2c761b009f5fa5`.

- PC base: `b18aa8e921ae9bd99c8a07728003b91c5c71ad5b`
- Reviewed source commit:
  `5032a36bfa757daf12d8bcfba2128fd1e8c93caa`
- PC merge: `7636cc1d801a8b0108ce3d8e3f2c761b009f5fa5`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PR state: merged 2026-08-23 at 19:25:20 UTC; one source commit;
  status-check rollup and hosted reviews were empty.
- The PC merge tip has no `.github/workflows` entries. No hosted build,
  hosted security scan, Windows run, or paid Apple CI result is claimed.

The first-parent merge diff is exactly four paths, 332 insertions and two
deletions:

- `pc/CMakeLists.txt`
- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_texgen_producer_fixture.c`
- `pc/tests/pc_gx_texgen_raw_shadow_fixture.c`

`git diff --check` passed. The merge parents are exactly the PC base and the
reviewed source commit.

## Pre-fix real-process predicate

One serialized, bounded real-process trace on exact pre-fix PC `b18aa8e92`
recorded 20 true process-lifetime cumulative attempts. Every attempt produced:

- Transform: success
- Channels: success
- Texgen: failure
- cumulative publication: none

The first source-order Texgen failure was
`pc_gx_texgen_producer.c`'s `active[0].post_range_unknown` predicate. Canonical
Texgen validation was not reached. The active selector used:

- function `GX_TG_MTX2x4`
- source `GX_TG_TEX0`
- ordinary matrix `GX_TEXMTX0`
- post matrix `GX_PTIDENTITY`

The ordinary slot was known as an immediate 2x4 load. The selected
`GX_PTIDENTITY` slot, logical ID 125, remained entirely unknown:
`slot_known=0`, provenance/load type/word count/mask all zero, and all stored
words zero. This was a missing initialization provenance record, not evidence
that the producer should fabricate identity for arbitrary unknown slots.

Durable trace root:
`/private/tmp/acgc-live-lane350-texgen-retry.K3mpF2`.

- `events.log` SHA-256:
  `4b49de1a04810ff60f6cb989b8acfe1204229b5388f55b55f4c4d14ac3c3cc97`
- `lldb.log` SHA-256:
  `a997227f71f8c6172645a2158aa7478e7c0705981518e4c5ea0f0c7424bba40d`
- `raw-snapshots.jsonl` SHA-256:
  `171c55cfba96a70a3efbbcd5a0c2d777eafff1deef7bdb7b8015ac71d34b1e95`
- `selected-fields.jsonl` SHA-256:
  `2dc80a8468e3f1f003f309b1e47db27292128bdd829ba68c4193a36344f3b545`

The trace stopped at the requested 20-attempt bound and cleaned up the exact
inferior. It did not inspect later producers or prove callback delivery.

## Source-faithful correction

The decomp oracle's `src/static/dolphin/gx/GXInit.c` performs initial Texgen
selector setup and then explicitly loads both `GX_IDENTITY` and
`GX_PTIDENTITY` as `GX_MTX3x4`. `GXAttr.c` owns selector behavior, while
`GXTransform.c` defines the 2x4/3x4 texture-matrix load forms. The corresponding
PC paths are `pc_gx_init`, `GXSetTexCoordGen2`, `GXLoadTexMtxImm`, and the
`emu64` initialization callers.

The merged correction adds the file-static
`pc_gx_raw_texgen_initialize_identity_provenance` helper and calls it only from
`pc_gx_init`, immediately after the setter-owned Texgen shadow is reset and its
logical matrix IDs are initialized. The helper records exactly two immediate
3x4 identity matrices through the existing
`pc_gx_raw_texgen_matrix_store_immediate` primitive:

- ordinary `GX_IDENTITY`
- post `GX_PTIDENTITY`

It does not call the public setter, flush, mirror host-rendering state, infer
identity from a selector, or weaken the producer. Every other ordinary and post
matrix slot remains unknown until an actual load owns it. Unknown and indexed
unresolved matrices therefore continue to fail closed.

## Focused fixtures and CMake closure

The raw-shadow fixture now exercises the real `pc_gx_init` boundary and checks:

- both identity slots are immediate, 3x4, twelve-word, fully known finite
  identities;
- all non-identity slots remain unknown;
- repeated initialization is deterministic;
- fixture reset removes provenance;
- selector calls do not materialize matrix contents; and
- indexed unresolved loads remain rejected.

The producer fixture separately accepts complete known identity records and
checks unknown/indexed rejection plus destination immutability on failure.

Because the raw fixture compiles `pc_gx.c` directly, its test-only CMake target
also receives the cumulative dependency closure already required by that
translation unit: Channels, Lighting, Texture, canonical snapshot, the
production GX object, portable library, target-private raw definitions, and
the existing platform libraries. The producer executable and production
`ac_pc` source membership are otherwise unchanged. The target remains under
`APPLE AND PC_DARWIN_COMPILE_AUDIT AND BUILD_TESTING`.

## Independent immutable review

The reviewer used detached, clean worktree
`/private/tmp/codex-acgc-texgen-review-jh6Co0` at exact source commit
`5032a36bfa757daf12d8bcfba2128fd1e8c93caa` and parent `b18aa8e92`.

The review passed with no P0, P1, or P2 finding after checking:

- exact four-path scope and clean diff;
- GX initialization order against both upstreams;
- identity-only provenance and continued unknown/indexed fail-closed behavior;
- target-local CMake source/object ownership and duplicate-symbol safety;
- positive, negative, reset, repeat, selector-only, and failure-immutability
  coverage; and
- fresh native plus combined ASan/UBSan execution of both focused fixtures.

## Exact-merge verification

Detached source:
`/private/tmp/acgc-integrator-texgen-merged-7636`, clean at exact merge
`7636cc1d801a8b0108ce3d8e3f2c761b009f5fa5`.

Fresh native:

```sh
cmake -S /private/tmp/acgc-integrator-texgen-merged-7636/pc \
  -B /private/tmp/acgc-merged-texgen-native-7636 \
  -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-merged-texgen-native-7636 \
  --target acgc_pc_gx_texgen_raw_shadow_fixture \
           acgc_pc_gx_texgen_producer_fixture \
  --parallel 1
ctest --test-dir /private/tmp/acgc-merged-texgen-native-7636 \
  -N -R '^(acgc_pc_gx_texgen_raw_shadow_fixture|acgc_pc_gx_texgen_producer_fixture)$'
ctest --test-dir /private/tmp/acgc-merged-texgen-native-7636 \
  --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_texgen_raw_shadow_fixture|acgc_pc_gx_texgen_producer_fixture)$'
```

Result: configure passed; the serialized two-target build completed 62 steps;
discovery found exactly tests 25 and 26; both tests passed `2/2`. A final
read-only rerun passed `2/2` in 0.04 seconds.

Fresh combined ASan/UBSan used
`-fsanitize=address,undefined -fno-omit-frame-pointer` on C and C++ compilation
and matching executable linker flags:

```sh
cmake -S /private/tmp/acgc-integrator-texgen-merged-7636/pc \
  -B /private/tmp/acgc-merged-texgen-asan-ubsan-7636 \
  -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-merged-texgen-asan-ubsan-7636 \
  --target acgc_pc_gx_texgen_raw_shadow_fixture \
           acgc_pc_gx_texgen_producer_fixture \
  --parallel 1
ctest --test-dir /private/tmp/acgc-merged-texgen-asan-ubsan-7636 \
  -N -R '^(acgc_pc_gx_texgen_raw_shadow_fixture|acgc_pc_gx_texgen_producer_fixture)$'
ctest --test-dir /private/tmp/acgc-merged-texgen-asan-ubsan-7636 \
  --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_texgen_raw_shadow_fixture|acgc_pc_gx_texgen_producer_fixture)$'
```

Result: configure passed; the serialized two-target build completed 62 steps;
discovery found exactly tests 25 and 26; both tests passed `2/2`. A final
read-only rerun passed `2/2` in 0.45 seconds with no AddressSanitizer,
UndefinedBehaviorSanitizer, or runtime-error diagnostic.

## Proof boundary and next gate

Proved:

- the exact first pre-fix live Texgen predicate and its raw state;
- source fidelity of initialization-time identity provenance;
- identity-only positive behavior and strict negative behavior;
- exact four-file hosted integration;
- independent immutable source review; and
- exact-merge native and ASan/UBSan configure, compile, link, discovery, and
  execution of both focused fixtures.

Not proved:

- a full `ac_pc` link at `7636cc1d8`;
- a post-fix process launch or successful live Texgen production;
- the next first-failing producer;
- a cumulative envelope, callback, Apple plan, or sink submission;
- Windows execution;
- Metal encode, present, readback, pixels, or device behavior;
- input, audible audio, save/reload, lifecycle, iOS, or playability.

The next serialized gate is one bounded, exact-merge real-process trace. It
must verify whether Texgen now succeeds and then stop at the next first-failing
producer or the first cumulative publication. It must not infer later-stage
success from fixture coverage.
