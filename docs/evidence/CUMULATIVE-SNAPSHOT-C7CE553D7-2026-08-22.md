# Cumulative GX envelope assembler at `c7ce553d7`

Date: 2026-08-22 (Pacific/Honolulu)

## Scope and pinned references

This record covers the independently reviewed pure cumulative GX envelope
assembler, its focused CMake/CTest registration, and exact-merge verification.

- Umbrella integration base: `fd029757113c4873d823dae17b639792b27a6418`
- PC source base: `c91873521474057cb5faea8867a92a8122ff3e16`
- Reviewed source lineage: `7acc786e79f012ca17f37f5792e2c4113058e3c3`,
  `ded31c017ba11100a4bec327f5cb0b1d2c770ca1`, and
  `81995528a5842c20e7b1c7bdf312e8d64a89e8b4`
- Integrated PC commits: `1d3a51485f71f246eb65e59034d27a09996210e7`,
  `46eee8c757003a1fa72620b89ae82e88275856ba`, and
  `cfb61d67da8e9d7a08057da8a1a25e8987bbed6e`
- Final PC source tip: `c7ce553d78de595320b2ef826366a9a17f8b6017`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PC integration branch: `c1/macos-host-launch`

No ISO, extracted asset, key, proprietary data, full `ac_pc` link, live
gatherer, callback, LLDB, GUI, Metal, or device lane was used for this
integration.

## Hosted source integration

[PC PR #6](https://github.com/jskoiz/ACGC-PC-Port/pull/6), “Add cumulative GX
envelope assembler gate,” merged the reviewed three-commit content into
`c1/macos-host-launch` as
`c7ce553d78de595320b2ef826366a9a17f8b6017`.

The hosted diff contains exactly four files and 1,055 additions:

- `pc/CMakeLists.txt`
- `pc/include/pc_gx_cumulative_snapshot.h`
- `pc/src/pc_gx_cumulative_snapshot.c`
- `pc/tests/pc_gx_cumulative_snapshot_fixture.c`

The repository has no GitHub workflow files, so this PR had no hosted CI
result. Local focused proof and the hosted merge are recorded separately.

## Contract integrated

`pc_gx_cumulative_snapshot_assemble` accepts exactly fourteen caller-supplied,
already encoded little-endian byte spans plus value-only section metadata in
canonical directory order. It validates header/directory metadata, fixed
section IDs and versions, byte sizes, counts, capacities, valid masks, checked
sizes, alignment, capacity, contiguity, and range disjointness before copying
the complete envelope into caller-owned storage.

The function stages the complete result in local storage and leaves both the
destination and the full aligned `size_t` output object unchanged on failure.
The size output must be disjoint from the destination, section metadata array,
and every input span. The public maximum is 76,092 bytes and is checked against
the canonical section-size formula at compile time.

The payload contract is transport-only: every byte span must already be an
explicitly encoded canonical little-endian section. The assembler does not cast
or serialize native value structs, semantically decode section payloads, build
canonical leaf values, validate cross-section value dependencies, acquire or
revalidate Texture/TLUT leases, gather live GX state, invoke a callback, or
render. Its CMake target is focused and test-only; it is not a member of
production `PC_SOURCES` or `ac_pc`.

Independent source review returned PASS after the output-size alias boundary
was corrected. Independent CMake review returned PASS. A separate new-tip audit
used revision-qualified merge-tree inspection and proved that the three-commit
chain applies cleanly to the token-scoped lease tip `c91873521`, changing only
the expected three new files plus the CMake registration and introducing no
lease API dependency.

## Two-upstream crosswalk

The PC host/Windows oracle provides the canonical envelope and host assembly
boundary:

- `include/acgc/gx_canonical_state.h` defines the V1 envelope header, fixed
  fourteen-section order, IDs, masks, directory shape, and common metadata.
- `include/acgc/gx_canonical_*_state.h` defines section sizes, counts,
  capacities, Geometry bounds, and TEV count bounds.
- `pc/include/pc_gx_cumulative_snapshot.h` defines the value-only byte-span API
  and its ownership, little-endian, disjointness, and failure contracts.
- `pc/src/pc_gx_cumulative_snapshot.c` performs checked metadata validation and
  all-or-nothing byte assembly.
- `pc/tests/pc_gx_cumulative_snapshot_fixture.c` covers the full directory,
  little-endian bytes, corruption, capacity, overlap, aliases, and output
  immutability.
- `pc/CMakeLists.txt` owns the focused source-direct fixture registration and
  canonical-library links.

The decomp oracle grounds section meaning and ordering inputs in the GX source:
`GXAttr.c`, `GXGeometry.c`, `GXVert.c`, `GXTransform.c`, `GXLight.c`,
`GXTexture.c`, `GXTev.c`, `GXPixel.c`, and `GXBump.c`, plus their corresponding
`include/dolphin/gx` declarations. The cumulative little-endian host envelope,
assembler API, CMake target, and Texture/TLUT borrow protocol have no direct
decomp counterpart.

## Focused verification

The integration owner ran fresh native and combined ASan/UBSan roots on the
reviewed integration branch, then repeated both gates from a detached worktree
at exact merge `c7ce553d7`.

Native exact-merge gate:

```sh
cmake -S pc -B /private/tmp/acgc-assembler-merged-native-ZmvE1S -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-assembler-merged-native-ZmvE1S \
  --target acgc_pc_gx_cumulative_snapshot_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-assembler-merged-native-ZmvE1S -N \
  -R '^acgc_pc_gx_cumulative_snapshot_fixture$'
ctest --test-dir /private/tmp/acgc-assembler-merged-native-ZmvE1S \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_cumulative_snapshot_fixture$'
```

Discovery found exactly one test and execution passed `1/1`.

Combined ASan/UBSan exact-merge gate:

```sh
cmake -S pc -B /private/tmp/acgc-assembler-merged-asan-ubsan-bPeVN0 -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-assembler-merged-asan-ubsan-bPeVN0 \
  --target acgc_pc_gx_cumulative_snapshot_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-assembler-merged-asan-ubsan-bPeVN0 -N \
  -R '^acgc_pc_gx_cumulative_snapshot_fixture$'
ctest --test-dir /private/tmp/acgc-assembler-merged-asan-ubsan-bPeVN0 \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_cumulative_snapshot_fixture$'
```

Discovery found exactly one test and execution passed `1/1` in 0.10 seconds,
with no ASan or UBSan finding. The linker emitted the already-reviewed warning
about repeated transitive canonical archives; there were no duplicate
definitions, unresolved symbols, or test failures.

## Evidence boundary and next blocker

This proves the pure API contract, metadata validation, caller-supplied
little-endian byte-copy assembly, error-path output immutability, focused CTest
registration, hosted merge, and exact-merge native plus combined ASan/UBSan
execution. It does not prove semantically valid payload values, production
linkage, live state gathering, resource-lease ownership, flush publication,
callback delivery, Apple parsing/planning, Metal encode/present/readback, a
pixel, input, audio, save/reload, lifecycle, iOS, or playability.

The corrected pure Apple envelope parser has now received independent PASS and
is the next serialized source integration. Production producer membership, a
lease-owning cumulative gatherer, the single flush call, typed Apple CPU plan,
and live callback remain later gates.
