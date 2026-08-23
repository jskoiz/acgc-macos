# Apple canonical envelope parser at `8e55df64e`

Date: 2026-08-22 (Pacific/Honolulu)

## Scope and pinned references

This record covers the independently reviewed pure-C Apple canonical V1
envelope parser, its focused CMake/CTest registration, and exact-merge proof.

- Umbrella integration base: `3bcacc1038052dc538b4d9b94d6b91ea910944d4`
- PC source base: `c7ce553d78de595320b2ef826366a9a17f8b6017`
- Reviewed source lineage: `6ae7aec1d05bff0017ab75a4d88bd0f39434577d`
  and `6410b40fbfbff91f23ce9fe65b2f65e999704ef2`
- Integrated PC commits: `33843a6ee4b1025f2559eee5dddace1d8af6aad1`
  and `9c7603c55e0ff24a226ffac85697b0371177aaa8`
- Final PC source tip: `8e55df64e51d68fbec7dfe84c486253f98914338`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PC integration branch: `c1/macos-host-launch`

No ISO, extracted asset, key, proprietary data, full `ac_pc` link, live
gatherer, callback, LLDB, GUI, Metal, or device lane was used for this
integration.

## Hosted source integration

[PC PR #7](https://github.com/jskoiz/ACGC-PC-Port/pull/7), “Add Apple canonical
envelope wire parser,” merged the reviewed two-commit content into
`c1/macos-host-launch` as
`8e55df64e51d68fbec7dfe84c486253f98914338`.

The hosted diff contains exactly four files and 1,275 additions:

- `pc/apple/CMakeLists.txt`
- `pc/apple/include/acgc/apple_canonical_envelope_parser.h`
- `pc/apple/src/apple_canonical_envelope_parser.c`
- `pc/apple/tests/test_apple_canonical_envelope_parser.c`

The repository has no GitHub workflow files, so this PR had no hosted CI
result. Local focused proof and the hosted merge are recorded separately.

## Contract integrated

`acgc_apple_canonical_envelope_parse` consumes one exact byte extent and reads
the canonical V1 header and fourteen-entry directory explicitly as
little-endian words. It never casts input bytes to native metadata structs,
allocates memory, or retains an input pointer. The caller-owned output contains
only decoded fixed-width metadata and payload offsets/sizes.

The parser validates magic, version, header and directory layout, known/present
and required masks, required-subset rules, reserved words, checked total sizes,
alignment, exact input extent, fixed section order, absent-entry zeroing,
present versions, valid masks, canonical byte sizes/counts/capacities, contiguous
payload offsets, overflow, range bounds, gaps, overlaps, and trailing bytes.
Geometry uses its canonical variable size bounds, TEV uses its bounded active
stage count, and Fog requires canonical version 1 with 80 bytes, count 1, and
capacity 1.

The full output object is staged locally and remains byte-for-byte unchanged on
every error. A caller output range that overlaps the input extent is rejected
before input reads or output writes. Section IDs, masks, and metadata bounds are
sourced from canonical headers in the fixed order: Geometry, Transforms,
Channels, Texgens, Textures, TEV, Lighting, Blend, Alpha, Depth, Raster, Fog,
Indirect, Dynamic.

This is structural validation only. The parser does not semantically decode
section payload values, call canonical value validators, own or revalidate a
Texture/TLUT lease, build an Apple draw/state plan, replace older packet
consumers, gather live GX state, invoke callbacks, or render. Its focused target
is in `pc/apple/CMakeLists.txt`; it is not production-linked into `ac_pc`.

The first parser candidate was blocked because it accepted a four-byte Fog
section. The corrective child added the canonical metadata table, explicit
canonical masks, a real 80-byte Fog fixture span, and immutable-output
regressions for wrong Fog size/count/capacity. Independent re-review returned
PASS with no P0/P1 finding. A new-tip merge-tree audit separately returned PASS
against the landed cumulative assembler at `c7ce553d7`.

## Two-upstream crosswalk

The PC host/Windows oracle provides the canonical wire and Apple host boundary:

- `include/acgc/gx_canonical_state.h` owns the V1 header, directory constants,
  section IDs/masks, and fixed fourteen-section order.
- `include/acgc/gx_canonical_*_state.h` owns section sizes, counts, capacities,
  Geometry bounds, and TEV count bounds.
- `src/gx_canonical_state.c` provides the common metadata validator crosswalk,
  including Fog 80/1/1.
- `pc/include/pc_gx_cumulative_snapshot.h` and
  `pc/src/pc_gx_cumulative_snapshot.c` define the already-integrated writer
  whose little-endian header, directory, and contiguous payload shape the
  parser accepts.
- `pc/apple/include/acgc/apple_canonical_envelope_parser.h` defines the
  pointer-free view and status API.
- `pc/apple/src/apple_canonical_envelope_parser.c` implements checked structural
  parsing.
- `pc/apple/tests/test_apple_canonical_envelope_parser.c` covers a full
  fourteen-section envelope, empty envelope, truncation, corruption, overflow,
  aliases, canonical metadata, and output immutability.

The decomp oracle grounds section meaning in `GXAttr.c`, `GXGeometry.c`,
`GXVert.c`, `GXTransform.c`, `GXLight.c`, `GXTexture.c`, `GXTev.c`, `GXPixel.c`,
and `GXBump.c`, plus the corresponding `include/dolphin/gx` declarations. The
host cumulative envelope, Apple structural parser, CMake target, and
Texture/TLUT borrow protocol have no direct decomp counterpart.

## Focused verification

The integration owner ran fresh native and combined ASan/UBSan roots on the
reviewed integration branch, then repeated both gates from a detached worktree
at exact merge `8e55df64e`.

Native exact-merge gate:

```sh
cmake -S pc/apple -B /private/tmp/acgc-parser-merged-native-4hHjPL -G Ninja \
  -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-parser-merged-native-4hHjPL \
  --target acgc_apple_canonical_envelope_parser_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-parser-merged-native-4hHjPL -N \
  -R '^acgc_apple_canonical_envelope_parser_fixture$'
ctest --test-dir /private/tmp/acgc-parser-merged-native-4hHjPL \
  --output-on-failure --parallel 1 \
  -R '^acgc_apple_canonical_envelope_parser_fixture$'
```

Discovery found exactly one test and execution passed `1/1`.

Combined ASan/UBSan exact-merge gate:

```sh
cmake -S pc/apple -B /private/tmp/acgc-parser-merged-asan-ubsan-JxUw3F -G Ninja \
  -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer -O1' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-parser-merged-asan-ubsan-JxUw3F \
  --target acgc_apple_canonical_envelope_parser_fixture --parallel 1
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 \
ctest --test-dir /private/tmp/acgc-parser-merged-asan-ubsan-JxUw3F \
  --output-on-failure --parallel 1 \
  -R '^acgc_apple_canonical_envelope_parser_fixture$'
```

Discovery found exactly one test and execution passed `1/1` in 0.13 seconds,
with no ASan or UBSan finding. Leak detection was disabled because
LeakSanitizer is unsupported in this Apple runtime; address and undefined
behavior instrumentation remained enabled.

## Evidence boundary and next blocker

This proves the pure structural parser API, explicit little-endian reads,
canonical directory metadata checks, error-path output immutability, focused
CTest registration, hosted merge, and exact-merge native plus combined
ASan/UBSan execution. It does not prove section payload semantics, an
assembler-to-parser round trip, production linkage, live state gathering,
resource-lease ownership, flush publication, typed Apple plan construction,
callback delivery, Metal encode/present/readback, a pixel, input, audio,
save/reload, lifecycle, iOS, or playability.

The next dependency-ready work is production all-section producer membership
and a lease-owning cumulative gatherer at the audited flush boundary, followed
by semantic Apple section decoding and immutable typed plan construction. A
focused assembler-to-parser round-trip fixture is also useful before live
wiring.
