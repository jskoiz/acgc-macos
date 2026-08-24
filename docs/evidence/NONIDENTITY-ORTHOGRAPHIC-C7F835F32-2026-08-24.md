# Nonidentity orthographic reconstruction — `c7f835f32` — 2026-08-24

## Outcome

PC PR [#36](https://github.com/jskoiz/ACGC-PC-Port/pull/36) merged a
test-only, source-faithful nonidentity orthographic reconstruction case as
`c7f835f325ea5e061f492213da9ddce5349b269d`. The existing Apple canonical-plan
consumer fixture now validates all sixteen exact output words produced from a
six-word GX orthographic projection and a nonidentity row-major 3x4 position
matrix. It also checks finiteness and that the input plan remains unchanged.

The merge changes no production source, public header, CMake file, link input,
runtime path, or workflow. It adds CPU fixture coverage only. The latest
real-process proof remains the single exact-`586cf7a6` attempt that published a
14,104-byte cumulative envelope and then returned typed status 17,
`CANONICAL_TEXTURE_UNSUPPORTED`, before the sink.

## Exact revisions and hosted state

- Umbrella integration base:
  `27f92b038b5da8bd46ebe323e416b8c203e6c822`.
- PC integration base:
  `586cf7a616cd38149c911bd4bc8fb2f1de638de4`.
- Reviewed PC source candidate:
  `2013ea3107df358a34df9b409f08003f8f77d1d8`.
- PC merge:
  `c7f835f325ea5e061f492213da9ddce5349b269d`.
- PC merge parents:
  `586cf7a616cd38149c911bd4bc8fb2f1de638de4` and
  `2013ea3107df358a34df9b409f08003f8f77d1d8`.
- PC merge tree:
  `469e36a72322bf7bc2081d2882174a28bc98a88d`, identical to the
  reviewed candidate tree.
- Decomp oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

PR #36 was merged to `c1/macos-host-launch` with one commit, one changed file,
55 additions, and no deletions. Its status-check rollup and review list were
empty, and the exact PC tree contains no `.github/workflows` files. No hosted
build, test, review, or Apple CI result is claimed.

## Exact source scope

The entire `586cf7a6..c7f835f3` diff is:

```text
M pc/apple/tests/test_apple_canonical_plan_consumer.c
```

The added fixture input is:

```text
orthographic projection = [0.25, -0.5, 0.5, 0.5, -0.125, -0.875]
row-major 3x4 position  = [2, 0, 0, 1,
                           0, 3, 0, -2,
                           0, 0, 4, 0.5]
```

The expected column-major 4x4 result is checked word-for-word:

```text
[ 0.5,   0,    0,       0,
  0,     1.5,  0,       0,
  0,     0,   -0.5,     0,
 -0.25, -0.5, -0.9375,  1 ]
```

The assertion uses exact float bit patterns for all sixteen words, rejects
non-finite results, and compares a saved copy of the input plan after the call.
It does not weaken the existing perspective, identity, alias, malformed-input,
Geometry, Channels, Texgen, Texture, or sink-admission controls.

## Two-upstream crosswalk

The host reconstruction remains in
`pc/apple/src/metal_packet_consumer.c`. It expands the canonical six-word GX
projection, extends the row-major 3x4 position matrix to 4x4, multiplies the
projection and view matrices, validates finite output, and serializes the result
in the consumer's column-major form. The new case exercises that unchanged
implementation through
`pc/apple/tests/test_apple_canonical_plan_consumer.c`.

The original-behavior oracle remains decomp
`src/static/dolphin/gx/GXTransform.c` for the GX projection state,
`src/static/dolphin/mtx/mtx44.c` for orthographic matrix construction, and
`src/static/JSystem/J2DGraph/J2DOrthoGraph.cpp` for a real orthographic caller.
The Apple canonical plan, CPU packet consumer, and host fixture have no direct
decomp counterpart.

## Candidate and exact-merge fixture gates

The candidate was built from a unique source worktree and fresh build roots.
The exact fixture regex was:

```text
^acgc_apple_canonical_plan_consumer_fixture$
```

The candidate fixture discovered and passed `1/1` natively and `1/1` with
combined ASan/UBSan. Independent immutable candidate review found no P0, P1, or
P2 issue.

After PR #36 merged, the exact clean detached source was:

```text
/private/tmp/acgc-integrator-projection-c7f835f
```

Fresh exact-merge roots were:

```text
/private/tmp/acgc-projection-merged-c7f-native
/private/tmp/acgc-projection-merged-c7f-asan
```

Each root discovered exactly one matching test and passed `1/1`. The sanitizer
root used combined address and undefined-behavior instrumentation and emitted
no sanitizer or runtime diagnostic. Independent exact-merge review confirmed
the expected parents, the one-file `+55/-0` scope, candidate/merge tree
identity, clean diff checks, and the CPU-only proof boundary.

## Synchronized exact-tip runner

The umbrella runner now pins exact PC merge `c7f835f3`. It was executed from
the exact detached source with fresh roots under:

```text
/private/tmp/acgc-canonical-pipeline-c7f-umbrella
```

The selected PC regex was:

```text
^acgc_pc_gx_(cumulative_gatherer_flush|texture_dynamic_producer|canonical_plan_roundtrip)_fixture$
```

The selected Apple regex was:

```text
^(acgc_apple_canonical_(texture_resource_consumer|plan_consumer)_fixture|acgc_pc_metal_runtime_arbitration_fixture)$
```

Fresh configure, serialized target-only builds, exact discovery, and exact
CTest runs passed as follows:

| Configuration | PC | Apple |
| --- | ---: | ---: |
| Native Debug | `3/3` | `3/3` |
| Combined ASan/UBSan Debug | `3/3` | `3/3` |

The combined sanitizer roots used
`-O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined
-fno-sanitize-recover=all` with matching linker instrumentation. Exact reruns
of the same four selections again passed `3/3`, `3/3`, `3/3`, and `3/3`.
Focused scans of the sanitizer logs found no AddressSanitizer,
UndefinedBehaviorSanitizer, LeakSanitizer, runtime-error, `ERROR`, or `FAILED`
diagnostic. The runner reported exact discovery, zero skips, and final `PASS`.

This matrix proves the selected pointer-free gather/publication, Texture lease,
round-trip, Apple resource stage, Apple CPU consumer, and runtime-arbitration
fixtures continue to coexist at the new test-only tip. It is not a full-suite,
full-link, launch, callback, renderer, or device gate.

## Production-equivalence boundary

A mechanical `586cf7a6..c7f835f3` tree audit excluded the one changed fixture and
found all remaining 6,710 entries byte-identical. Selected production source,
public-header, CMake, and link-input blobs were identical, as were the
`PC_SOURCES` and `ac_pc` link blocks. The fixture is a separately registered
test target and is not an `ac_pc` input.

This establishes source/link-input equivalence for selecting the next Texture
fix. It does not turn the retained exact-`586cf7a6` binary or its trace into an
exact-`c7f835f3` runtime result. A new link and process trace would be required
before making that claim.

## Proof boundary and successor

This integration proves the exact test-only PC merge, the nonidentity
orthographic CPU reconstruction case, exact native and combined sanitizer
fixture execution, synchronized selected-gate execution, and unchanged
production/link inputs.

It does not prove live projection consumption, a new `ac_pc` link or launch,
Texture admission, TEV evaluation, sink entry, Metal encode/present, readback,
pixels, assets, device behavior, input, audio, save/reload, lifecycle behavior,
or playability. The primary successor remains the smallest source-faithful
typed Texture predicate repair, informed by one independently approved bounded
trace and followed by its own focused native and ASan/UBSan gates.
