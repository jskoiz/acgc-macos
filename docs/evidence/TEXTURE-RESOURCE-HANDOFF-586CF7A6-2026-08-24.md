# Texture resource handoff integration — `586cf7a6` — 2026-08-24

## Outcome

PC PR [#35](https://github.com/jskoiz/ACGC-PC-Port/pull/35) merged the reviewed canonical Texture/TLUT resource-handoff chain as
`586cf7a616cd38149c911bd4bc8fb2f1de638de4`. The production gatherer now calls
a separately owned resource callback while the exact Texture/TLUT borrow is
active, revalidates the raw state and lease after that synchronous callback,
ends the borrow, and only then commits and publishes the pointer-free cumulative
envelope. The Apple side stages bounded owned image, TLUT, and decoded RGBA
bytes for the same attempt. Runtime initialization owns its plan consumer and
resource callback as one fail-closed transaction.

This is CPU ownership, lifetime, copy, decode, and arbitration proof. It does
not show a new full `ac_pc` link, real-process resource callback, canonical sink
entry, Metal encode/present, pixel, device behavior, or playability.

## Exact revisions

- Umbrella integration base: `94cdee0b3e9f6badeff1871fdc27b07a18d21520`.
- PC target branch before PR #35: `d472c6bd32443015b0db8e285e1070b4f60539ee`.
- Reviewed PC candidate tip: `024206d3697ea5c77e3f3b036f749a773f0204bf`.
- PC merge: `586cf7a616cd38149c911bd4bc8fb2f1de638de4`.
- PC merge parents: `d472c6bd32443015b0db8e285e1070b4f60539ee`
  and `024206d3697ea5c77e3f3b036f749a773f0204bf`.
- PC merge tree: `348302fe0e9cde220780a0ab1477b2edd7184654`,
  identical to the pre-merge synthetic tree.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

The PC repository has no `.github/workflows` entries at this ref. PR #35 had an
empty hosted status-check rollup. No hosted build or test result is claimed.

## Reviewed PC source chain

The five commits were reviewed together and merged without scope drift:

1. `2fcfe1121fa3756398fe124c269347edbb3fc019` — add canonical Texture resource staging;
2. `22b200dd16da10791775f96772d835d6f9477d04` — close resource-handoff failure paths;
3. `485027fcf85638703e6a6c7309aca5d6b1a73783` — make resource clearing owner-aware;
4. `73e72a8d1ebad5b09dd138203385c9808251f022` — preserve separately owned resource callbacks across pointer-free clears;
5. `024206d3697ea5c77e3f3b036f749a773f0204bf` — make runtime ownership initialization atomic.

The exact `d472c6bd3..586cf7a6` diff is 11 paths, `+1614/-58`:

- `pc/CMakeLists.txt`
- `pc/apple/CMakeLists.txt`
- `pc/apple/include/acgc/metal_packet_consumer.h`
- `pc/apple/src/metal_packet_consumer.c`
- `pc/apple/src/pc_metal_runtime.c`
- `pc/apple/tests/test_apple_canonical_texture_resource_consumer.c`
- `pc/apple/tests/test_pc_metal_runtime_arbitration.c`
- `pc/include/pc_gx_cumulative_gatherer.h`
- `pc/src/pc_gx.c`
- `pc/src/pc_gx_cumulative_gatherer.c`
- `pc/tests/pc_gx_cumulative_gatherer_flush_fixture.c`

## Contract proved by source and fixtures

- A non-null exact callback/context pair owns the resource callback.
- The resource callback runs only inside the active Texture/TLUT borrow.
- Post-callback raw-state and lease revalidation must pass before borrow release.
- Borrow release must succeed before envelope storage, pointer-free callback,
  and attempt notification are committed.
- Resource rejection or any producer, assembly, revalidation, or release failure
  preserves the previously published envelope and metadata.
- Apple staging clears the full destination on entry and every failure path,
  validates resource IDs, generations, epochs, formats, byte order, source
  kind, masks, and sizes, and bounds image/TLUT copies plus base-level decode.
- Runtime initialization acquires the plan consumer before the resource
  callback. A foreign plan owner causes no resource mutation; a foreign
  resource owner rolls back only runtime-owned partial state. Repeated shutdown
  and reinitialization clear only exact owned pairs.
- The existing public status 17, `CANONICAL_TEXTURE_UNSUPPORTED`, and no-sink
  policy are unchanged. Resource admission is necessary but is not renderer
  submission.

## Exact merged-snapshot verification

Source worktree:

`/private/tmp/acgc-integrator-texture-586cf7a`

It was detached, clean, and exactly at `586cf7a616cd38149c911bd4bc8fb2f1de638de4`.
Four new build roots were configured from that worktree; candidate roots were
not reused as merge proof.

### PC native

Root: `/private/tmp/acgc-texture-merged-586cf7a-pc-native`

Targets and exact CTest selection:

```text
acgc_pc_gx_cumulative_gatherer_flush_fixture
acgc_pc_gx_texture_dynamic_producer_fixture
acgc_pc_gx_canonical_plan_roundtrip_fixture
^acgc_pc_gx_(cumulative_gatherer_flush|texture_dynamic_producer|canonical_plan_roundtrip)_fixture$
```

Fresh configure and serialized target-only build passed. Discovery was exactly
3 and CTest passed `3/3`.

### PC combined ASan/UBSan

Root: `/private/tmp/acgc-texture-merged-586cf7a-pc-asan`

The same exact three targets discovered and passed `3/3` with
`-fsanitize=address,undefined`, frame pointers, fail-fast sanitizer options,
and matching linker flags. The CTest and `LastTest.log` scan found no ASan,
UBSan, runtime-error, LeakSanitizer, `ERROR`, `FAILED`, or `SUMMARY` diagnostic.

### Apple native

Root: `/private/tmp/acgc-texture-merged-586cf7a-apple-native`

Targets and exact CTest selection:

```text
acgc_apple_canonical_texture_resource_consumer_fixture
acgc_apple_canonical_plan_consumer_fixture
acgc_pc_metal_runtime_arbitration_fixture
^(acgc_apple_canonical_(texture_resource_consumer|plan_consumer)_fixture|acgc_pc_metal_runtime_arbitration_fixture)$
```

Fresh configure and serialized target-only build passed. Discovery was exactly
3 and CTest passed `3/3`. An initial local shell assertion expected one space
before CTest's test number, while Apple CTest aligns single-digit numbers with
two. The assertion was corrected to accept whitespace; the build and tests did
not fail. The umbrella runner includes the corrected parser.

### Apple combined ASan/UBSan

Root: `/private/tmp/acgc-texture-merged-586cf7a-apple-asan`

The same exact three targets discovered and passed `3/3` with combined
ASan/UBSan instrumentation and fail-fast options. The diagnostic scan was
clean.

Two independent immutable reviews found no P0/P1 in the final candidate or the
exact merge and its fresh roots.

## Two-upstream crosswalk

The PC host owns resource lifetime and publication in
`pc/src/pc_gx_cumulative_gatherer.c`, `pc/include/pc_gx_cumulative_gatherer.h`,
`pc/apple/src/metal_packet_consumer.c`, and `pc/apple/src/pc_metal_runtime.c`.
The original-behavior oracle remains decomp `GXTexture.h`/`GXTexture.c` for
Texture/TLUT initialization, loading, and invalidation; `GXTev.h`/`GXTev.c` for
TEV/alpha state; and `GXBump.h`/`GXBump.c` for indirect texture state. The host
borrow token, cumulative envelope, callback ownership, bounded CPU stage, and
attempt arbitration have no direct decomp counterpart.

## Verification runner and cleanup

`scripts/verify-canonical-pipeline.zsh` now pins exact PC merge `586cf7a6` and
runs the same PC `3/3` plus Apple `3/3` matrix natively and with combined
ASan/UBSan, serialized and from fresh roots. The runner still excludes a full
`ac_pc` link, process launch, assets, production callback dispatch, Metal,
pixels, devices, and playability.

The updated runner itself passed from fresh root
`/private/tmp/acgc-umbrella-texture-runner-586cf7a`: PC native `3/3`, Apple
native `3/3`, PC ASan/UBSan `3/3`, and Apple ASan/UBSan `3/3`, with exact
discovery, zero skips, and clean diagnostic scans.

The current orchestrator is the only unarchived visible ACGC task in the latest
app listing; older ACGC lanes remain archived, and unrelated project and
automation tasks were not touched. Cumulative cleanup now records 75 clean or
integrated registered worktrees plus one broken decomp registration removed,
two detached audit clones retired, and 353 audited generated/temporary directory
roots moved recoverably to Trash. This continuation removed three clean
registered worktrees and also moved 17 stale PR-body/list/dry-run files
(64,369 bytes) to `/Users/jk/.Trash/acgc-cleanup-20260824.vP1Xfo`.
The retained exact-`9860ebc5c` trace import chain, runtime dependency, active
source/proof roots, dirty or ambiguous roots, and asset-linked roots were
preserved. No ISO/GCM/CISO/RVZ/WBFS material was moved or deleted.

## Remaining boundary

The latest real-process evidence is still the sole exact-`9860ebc5c` attempt:
all fourteen producers, cumulative publication, Apple plan construction,
Geometry, Channels, and Texgen pass before status 17; the sink is not entered.
A later gate must perform one fresh exact-`586cf7a6` full link and one bounded,
serialized, exact-PID trace. Success is either a same-attempt Texture resource
stage followed by the next precisely classified rejection, or a first real
sink entry. Neither outcome by itself proves Metal encode/present or pixels.
