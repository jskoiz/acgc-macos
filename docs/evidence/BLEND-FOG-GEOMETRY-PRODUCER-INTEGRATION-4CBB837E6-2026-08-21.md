# Blend, Fog, and Geometry producer integration at `4cbb837e6`

Date: 2026-08-21 (Pacific/Honolulu)

## Scope and pinned references

This record covers the bounded canonical-producer batch after umbrella
`origin/main` was refreshed and the PC submodule became publicly fetchable
from `jskoiz/ACGC-PC-Port`.

- Umbrella integration base: `f81857759c0ba67778a167ff5282dbdedd14e57f`
- PC source base: `d50cddb1815dd640a16b3ec1c899b9f4a7fee9d0`
- Final PC source tip: `4cbb837e62f69c4cab80c1128c25b9e9bd9fb91d`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PC integration branch: `c1/macos-host-launch`

No ISO, extracted asset, key, proprietary-data, full-link, LLDB, GUI, or device
lane was used by this batch.

## Hosted source integrations

| Change | Reviewed head | Hosted PR | Merge commit | Hosted state |
| --- | --- | --- | --- | --- |
| Setter-owned raw Blend provenance and canonical leaf | `07a621428404a11bdb1a67cfa205a132b8363b01` | [PC PR #1](https://github.com/jskoiz/ACGC-PC-Port/pull/1) | `f772f0bb84572e82da597fdd19782856e84d0254` | Merged; exact six-file hosted diff; no checks configured |
| Setter-owned raw Fog provenance, exact adjustment-table generation, and canonical leaf | `e0bb5ac96e25fbb3ff43d2b2be6580f221c140ed` | [PC PR #2](https://github.com/jskoiz/ACGC-PC-Port/pull/2) | `cd55a7789ae11dca25db8832d2a2fd94b6280f42` | Merged; exact six-file hosted diff; no checks configured |
| Geometry dependency-result builder for the current PC raw-owner boundary | `09d1747994241c2e3af366a853c6bb69f78a06ca` | [PC PR #3](https://github.com/jskoiz/ACGC-PC-Port/pull/3) | `4cbb837e62f69c4cab80c1128c25b9e9bd9fb91d` | Merged; exact three-file hosted diff; no checks configured |

Each PR was created as a draft, inspected for the exact head SHA, base branch,
file list, and clean mergeability, marked ready, merged without deleting its
source branch, and then verified from the authoritative merge commit.

## Independent review outcomes

- Blend review passed the complete `07a621428` snapshot. It checked all 4,096
  valid mode/source-factor/destination-factor/logic combinations, exact enum
  domains, inactive-field zeroing, sticky invalidity, output preservation, and
  completed-batch flush ordering.
- Fog review initially blocked the candidate on incomplete-`GXBegin` mutation,
  over-broad projection validation, unaligned table access, and missing edge
  fixtures. Corrected `e0bb5ac96` passed immutable re-review: the three Fog
  operations are true no-ops during an incomplete draw, used projection
  operands alone are validated, RangeAdj input is copied with `memcpy` into
  aligned owned storage, invalid domains fail closed, and `pc_gx_init` resets
  sticky provenance.
- Geometry review blocked two earlier children before passing `09d174799`.
  The final fixture obtains real completed raw Geometry plus canonical
  Transform, Texgen, Channels, and Lighting producer results. Direct and
  INDEX16 POS/NRM/CLR0/TEX0 paths pass; missing POS, stale generation, source
  mismatch, unresolved inputs, selector errors, channel/light policy errors,
  and active BUMP all fail with output unchanged.

## Exact merged-tip verification

### Blend at `f772f0bb8`

Fresh native and combined ASan/UBSan CMake roots built
`acgc_pc_gx_blend_producer_fixture` and
`acgc_pc_gx_blend_producer_object`. Focused CTest passed `1/1` in each root
with `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. There were no sanitizer
diagnostics.

### Fog at `cd55a7789`

Fresh roots `/private/tmp/acgc-integrated-cd55-fog-native` and
`/private/tmp/acgc-integrated-cd55-fog-sanitizer` were configured from the
canonical checkout with Ninja, Debug, arm64, `BUILD_TESTING=ON`, and
`PC_DARWIN_COMPILE_AUDIT=ON`; the sanitizer root added
`-fsanitize=address,undefined -fno-omit-frame-pointer`.

Both roots built `acgc_pc_gx_fog_producer_fixture` and
`acgc_pc_gx_fog_producer_object` with `--parallel 1`. Native CTest passed
`1/1` in 0.01 seconds. Combined ASan/UBSan CTest passed `1/1` in 0.26 seconds
with leak detection disabled and fail-fast options enabled. There were no
sanitizer diagnostics. Existing decomp-header `INT_MIN`, prototype, and
unsupported-warning-option diagnostics remain warnings, not new failures.

### Geometry at `4cbb837e6`

The Geometry builder is intentionally not registered in CMake yet. From the
final canonical source tip, fresh native and combined ASan/UBSan source-direct
fixtures were compiled for arm64 with the real raw-owner seams enabled:

```text
PC_GX_GEOMETRY_RAW_BATCH_FIXTURE
PC_GX_CHANNELS_RAW_PRODUCER
PC_GX_LIGHTING_RAW_PRODUCER
```

Both binaries printed `pc_gx_geometry_dependencies_fixture: PASS` and exited
zero. The sanitizer binary used `-fsanitize=address,undefined`, leak detection
disabled, and fail-fast ASan/UBSan options; it emitted no sanitizer diagnostic.
`git diff --check` was clean across the integrated source range.

## What this proves

The final PC source tip has independently reviewed, setter-owned Blend and Fog
raw provenance, strict canonical Blend/Fog leaves, and a source-backed
Geometry dependency-result builder for the current PC raw Geometry owner.
Invalid or unresolved inputs fail closed and focused native/sanitizer behavior
passes on the exact hosted merge commits.

## What remains open

- Texture/TLUT/Dynamic resources still need one envelope-scoped atomic
  acquire, generation revalidation, publication, and release contract.
- No production cumulative assembler currently builds and publishes the full
  fourteen-section `0x3fff` envelope. The audited maximum envelope is 76,092
  bytes, but the implementation is not present.
- Geometry dependency code still needs deliberate production/CMake and
  cumulative-envelope wiring. Broader `PNMTXIDX`, `NBT`, `CLR1`, `TEX1`–`TEX7`,
  and BUMP/Indirect provenance remain explicit fail-closed successor work.
- The typed Apple CPU consumer remains blocked on the assembler and lease
  predecessor.
- No full `ac_pc` link, process launch, live callback, Metal encode/present,
  readback, identifiable pixel, physical input, audible audio, save/reload,
  lifecycle, iOS, or playability claim follows from this integration.
