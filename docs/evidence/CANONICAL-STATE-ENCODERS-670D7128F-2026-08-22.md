# Canonical state encoder integration evidence

Date: 2026-08-22 (Pacific/Honolulu)

## Outcome

PASS for the explicit canonical section encoder prerequisite.

Four independently reviewed PC source lanes added the twelve explicit
little-endian encoders that were missing from the cumulative-gatherer contract.
Geometry and Texgen already had explicit encoders. The authoritative PC merge
tip is `670d7128fbb2295d266c175e1f7bedecc6f6b39c`; the decomp behavior and wire
oracle remains `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

This milestone does not implement or call the cumulative gatherer. It does not
publish a callback, parse an Apple envelope, render, launch the game, or prove a
Metal/device pixel or playability.

## Integrated source chain

The PC base was production-topology merge
`52019da76cb7539230f913681d1d062d517cf0cd`.

| Sections | Reviewed source | Pull request | Merge |
| --- | --- | --- | --- |
| Transform, Channels, Lighting | `134296f3546a9d6ac43a49a12ee74e2f8b70d0a3` | [PC PR #9](https://github.com/jskoiz/ACGC-PC-Port/pull/9) | `29fa239a6f3e387bb098dea7a19ca73b6657235a` |
| Texture, Dynamic | `5a66938de91005f89371c0f4b9c52556c9b4fc7f` | [PC PR #10](https://github.com/jskoiz/ACGC-PC-Port/pull/10) | `24c1f6b8aae36e787670abfafbe376093c76387d` |
| Blend, Alpha, Depth, Raster, Fog | `a80c4d90966542161ee35aa001695f09126f899c` | [PC PR #11](https://github.com/jskoiz/ACGC-PC-Port/pull/11) | `51f8c791c38a2a28b3011819bbb0aa701dc20378` |
| TEV, Indirect | `3a29fe8b9106f833d6b6ca6ef6d0313d834932ad` | [PC PR #12](https://github.com/jskoiz/ACGC-PC-Port/pull/12) | `670d7128fbb2295d266c175e1f7bedecc6f6b39c` |

Each PR targeted `c1/macos-host-launch`, was reported `MERGED`, and had an empty
hosted status-check rollup. The PC tip contains no `.github/workflows` files, so
no hosted CI is claimed. The integration owner reviewed and merged the source
PRs serially.

The exact base-to-tip diff is 36 files, 2,413 insertions, and 66 deletions. It
is limited to canonical public headers, canonical implementation sources, and
their portable fixtures. `git diff --check` passed. No PC production gatherer,
flush call, Apple parser, renderer, or umbrella file is part of that source
range.

## Contract proved

The new APIs encode validated canonical values into explicit little-endian byte
spans suitable for `pc_gx_cumulative_snapshot_assemble`. They do not serialize
native C struct memory. The focused fixtures cover representative nontrivial
values, exact byte order and size, required zero/padding behavior, alias or
overlap rejection where applicable, invalid-state rejection, and destination
immutability on failure.

The completed fourteen-section encoder set is:

1. Geometry — previously present.
2. Transform — added by PR #9.
3. Channels — added by PR #9.
4. Texgen — previously present.
5. Texture — added by PR #10.
6. TEV — added by PR #12.
7. Lighting — added by PR #9.
8. Blend — added by PR #11.
9. Alpha — added by PR #11.
10. Depth — added by PR #11.
11. Raster — added by PR #11.
12. Fog — added through the common canonical state implementation in PR #11.
13. Indirect — added by PR #12.
14. Dynamic — added by PR #10.

The encoder APIs are value-only. Texture and Dynamic encoding does not acquire
or own a Texture/TLUT borrow. A future live gatherer must hold the already
integrated exact-token borrow across canonical construction, encoding,
assembly, final revalidation, and synchronous consumption, then release it on
every path.

## Independent review

- Lane 301 returned PASS for Transform/Channels/Lighting with no P0/P1 finding.
- Lane 302 returned PASS for Texture/Dynamic with no P0/P1/P2 finding.
- Lane 303 returned PASS for TEV/Indirect with no P0/P1/P2 finding and confirmed
  that the 62 deleted fixture lines were a coverage-preserving refactor rather
  than lost validation.
- Lane 304 returned PASS for Blend/Alpha/Depth/Raster/Fog with no P0/P1
  finding.

These reviews checked the immutable candidates before their respective PRs were
merged. The root owner then reran the combined exact-tip gate rather than
promoting the isolated candidate results to merged-tip proof.

## Exact merged-tip focused verification

The clean detached source worktree was:

```text
/private/tmp/acgc-integrator-encoders-merged
HEAD 670d7128fbb2295d266c175e1f7bedecc6f6b39c
```

The native root was
`/private/tmp/acgc-encoders-exact-native.992def`. Its cache records:

```text
CMAKE_HOME_DIRECTORY=/private/tmp/acgc-integrator-encoders-merged/pc
BUILD_TESTING=ON
PC_DARWIN_COMPILE_AUDIT=ON
CMAKE_BUILD_TYPE=Debug
CMAKE_C_FLAGS=
CMAKE_EXE_LINKER_FLAGS=
```

The combined sanitizer root was
`/private/tmp/acgc-encoders-exact-asan-ubsan.NDgIyv`. Its cache records the
same exact source and audit/test settings plus:

```text
CMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer
CMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined
```

CTest discovery with this exact regex found exactly twelve tests in each root:

```text
^acgc_gx_canonical_(transform|channel|lighting|texture|dynamic|blend|alpha|depth|raster|fog|tev|indirect)_state_tests$
```

The exact command was:

```sh
ctest --test-dir <root> --output-on-failure --parallel 1 \
  -R '^acgc_gx_canonical_(transform|channel|lighting|texture|dynamic|blend|alpha|depth|raster|fog|tev|indirect)_state_tests$'
```

Results:

```text
native:     12/12 passed, 0 failed, 0.02 sec
ASan/UBSan: 12/12 passed, 0 failed, 0.54 sec
```

No sanitizer diagnostic was reported.

An early native invocation had accidentally configured from the stale populated
PC checkout. That result was explicitly discarded. Every result above is from
a cache whose `CMAKE_HOME_DIRECTORY` names the exact `670d7128f` detached
worktree.

## Exact-tip production link

The integration owner serialized one full production link from the exact native
root:

```sh
cmake --build /private/tmp/acgc-encoders-exact-native.992def \
  --target ac_pc --parallel 1
```

Result: PASS after 4,050 Ninja steps. The output is a 14 MiB arm64 Mach-O
executable at `bin/AnimalCrossing`. The final linker diagnostic was:

```text
ld: warning: reducing alignment of section __DATA,__common from 0x8000 to
0x4000 because it exceeds segment maximum alignment
```

That warning is inherited and did not prevent the link. There were no unresolved
or duplicate encoder symbols. The executable was not launched.

The required post-build Xcode hygiene dry-run reported 651 candidates, 0 KiB
potential reclaim, and 0 errors. No cleanup was applied.

## Two-upstream crosswalk

The PC host and Windows regression oracle is the exact `670d7128f` tree:

- `include/acgc/gx_canonical_*_state.h` owns the public value and encoder APIs;
- `src/gx_canonical_*_state.c` owns validation and explicit wire encoding;
- `pc/portable/tests/test_gx_canonical_*_state.c` owns focused byte-contract
  fixtures;
- `pc/src/pc_gx*.c` and `pc/include/pc_gx*.h` own the raw state, producer, and
  Texture/TLUT borrow contracts that a later gatherer must use; and
- `pc/src/pc_gx_cumulative_snapshot.c` owns the already integrated envelope
  assembler.

The original behavior and GX wire oracle remains decomp `09ca8e8b`:

- `src/static/dolphin/gx/GXAttr.c`, `GXGeometry.c`, and `GXVert.c` cover
  Geometry and vertex formats;
- `GXTransform.c` covers Transform and Raster inputs;
- `GXLight.c` covers Channels and Lighting;
- `GXTexture.c` covers Texture/TLUT behavior;
- `GXTev.c` and `GXBump.c` cover TEV, Alpha, and Indirect behavior; and
- `GXPixel.c` covers Blend, Depth, Fog, and Raster inputs.

The host canonical envelope, explicit little-endian encoder APIs, Texture/TLUT
borrow tokens, CMake topology, and future cumulative gatherer have no direct
decomp counterpart. They are host-side ownership and transport boundaries and
must not be described as original game APIs.

## Proof boundary and next gate

This evidence proves the exact merged encoder source range, independent review,
focused native and ASan/UBSan execution, and exact-tip production link
compatibility. It does not prove live raw-state gathering, borrow ownership,
assembler invocation at the flush seam, callback delivery, Apple semantic
decoding, Metal encode/present/readback, device behavior, input, audio,
save/load, lifecycle, or playability.

The useful successor is Lane 305: implement and fixture the lease-owning,
single-publication cumulative gatherer without editing `pc_gx_flush_vertices`.
A later serialized lane must own the sole flush insertion and replacement of the
older Texture/Dynamic-only publication path.
