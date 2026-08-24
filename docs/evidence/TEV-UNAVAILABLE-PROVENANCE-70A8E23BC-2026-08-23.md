# TEV unavailable-provenance repair — PC `70a8e23bc`

## Outcome

PC [PR #25](https://github.com/jskoiz/ACGC-PC-Port/pull/25),
`Allow unused unavailable TEV registers`, merged into
`c1/macos-host-launch` as
`70a8e23bcf4bebe7deaceed5c9cb6ab70d0a94d4`.

- PC base: `ff09b1f226978237699f4a3c99678e750fd3625e`
- Reviewed source commit:
  `520c7afaf9cdf96bb4a6cc6739fac0a6776a23b8`
- PC merge: `70a8e23bcf4bebe7deaceed5c9cb6ab70d0a94d4`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PR state: merged 2026-08-23 at 21:59:03 UTC; one source commit;
  status-check rollup and hosted reviews were empty.

The exact first-parent merge diff is three paths, 434 insertions and 15
deletions:

- `pc/CMakeLists.txt`
- `pc/src/pc_gx_tev_producer.c`
- `pc/tests/pc_gx_tev_producer_fixture.c`

`git diff --check` passed. The merge parents are exactly the PC base and the
reviewed source commit. No Transform, Texgen, Texture/Dynamic, Indirect,
cumulative-gatherer, Apple consumer, decomp, umbrella, or proprietary-asset
path changed in the PC PR.

The exact PC merge tree contains no `.github/workflows` entry. No hosted Apple
workflow or paid Apple runner was triggered. The proof below is local, focused,
and tied to the exact merge object.

## Corrected TEV provenance contract

The last bounded real-process trace at exact PC `7636cc1d8` reached twenty
cumulative attempts. Transform, Channels, Texgen, and Texture/Dynamic passed
on every attempt. TEV was the first failing producer on every attempt, and a
one-attempt predicate trace found the first short circuit at
`registers[0].known_mask != 0x0F`, where the actual mask was zero.

The zero mask is not a canonical zero value. It is the setter-owned raw state
for an unavailable register that no active `GX_REPLACE` stage reads. The
merged producer now:

- accepts only the exact untouched unavailable record: zero known mask,
  invalid value bit, unavailable source, zero reserved byte, and four zero
  component words;
- keeps malformed, partially known, or contradictory records fail-closed;
- evaluates every active TEV stage in source order, with reads occurring
  before that stage's output definitions;
- tracks color and alpha definitions independently for PREV, REG0, REG1, and
  REG2;
- rejects an unavailable register or KColor only when the active dataflow
  actually reads it;
- maps full and component KColor/KAlpha selectors to the referenced KColor
  record while leaving fixed-fraction selectors independent of unavailable
  KColor storage;
- represents semantically unread unavailable records as deterministic zero in
  the value-only canonical section; and
- stages the complete output and commits it only after canonical validation,
  preserving input and output immutability on failure.

This is not a compatibility alias or a default-value fallback. Unknown raw
provenance remains unknown; the producer permits a value representation only
after proving that the active TEV program does not read that raw record.

The CMake change repairs only the existing source-backed raw-shadow fixture's
dependency closure against the current production object topology. It does not
add a new production source, callback, gather call, or renderer path.

## Two-upstream crosswalk

The host implementation and regression oracle is the exact PC merge above:

- `pc/src/pc_gx.c` owns the public TEV setters and setter-owned
  `PCGXRawTevIndirect` provenance;
- `pc/include/pc_gx_internal.h` defines unavailable, valid, and malformed raw
  TEV/KColor records plus stage knownness;
- `pc/src/pc_gx_tev_producer.c` owns the raw-to-canonical TEV value builder and
  the new source-order dependency check;
- `pc/tests/pc_gx_tev_raw_shadow_fixture.c` exercises public setter ownership;
- `pc/tests/pc_gx_tev_producer_fixture.c` exercises unavailable values,
  register dataflow, selector dependencies, malformed records, inactive tails,
  and failure immutability; and
- `pc/CMakeLists.txt` owns the two focused fixture targets.

The original-behavior and wire-layout oracle remains decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`:

- `src/static/dolphin/gx/GXTev.c` defines TEV input selection, operations,
  output registers, TEV/KColor setters, selector programming, and stage count;
- `include/dolphin/gx/GXEnum.h` fixes PREV/REG and full/component/fraction
  selector values; and
- game callers establish the source-order stage program whose reads and writes
  the host producer must preserve.

The pointer-free canonical section, raw-knownness sideband, focused host CMake
targets, and sanitizer gate have no direct decomp counterpart.

## Independent source review

An independent immutable review inspected exact candidate `520c7afa`, its
`ff09b1f22` parent, all three changed paths, the PC/decomp crosswalk, CMake
closure, the source-order dataflow, and retained focused results. It returned
PASS with no P0 or P1 finding and allowed the candidate to proceed unchanged.

The retained P2 is test coverage only: the producer fixture does not table-test
every KColor component selector from `K0_R` through `K3_A`, and the raw-shadow
fixture does not assert the entire public-setter-to-canonical-builder bridge in
one test. The shared range/modulo mapping was reviewed as correct. This P2 does
not upgrade the focused fixture to runtime or publication proof.

## Exact-merge focused verification

Detached, clean source worktree:

`/private/tmp/acgc-integrator-tev-merged.cgdSGM`

at exact merge `70a8e23bcf4bebe7deaceed5c9cb6ab70d0a94d4`.

Fresh native root:

`/private/tmp/acgc-tev-merged-native.MDIiQD`

```sh
cmake -S /private/tmp/acgc-integrator-tev-merged.cgdSGM/pc \
  -B /private/tmp/acgc-tev-merged-native.MDIiQD \
  -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-tev-merged-native.MDIiQD \
  --target acgc_pc_gx_tev_raw_shadow_fixture \
           acgc_pc_gx_tev_producer_fixture \
  --parallel 1
ctest --test-dir /private/tmp/acgc-tev-merged-native.MDIiQD \
  -N -R '^(acgc_pc_gx_tev_raw_shadow_fixture|acgc_pc_gx_tev_producer_fixture)$'
ctest --test-dir /private/tmp/acgc-tev-merged-native.MDIiQD \
  --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_tev_raw_shadow_fixture|acgc_pc_gx_tev_producer_fixture)$'
```

Result: configure/generate passed; the serialized target build completed 61
steps; discovery found exactly two tests; both passed `2/2` in 0.01 seconds.

Fresh combined ASan/UBSan root:

`/private/tmp/acgc-tev-merged-asan-ubsan.mQoixG`

```sh
cmake -S /private/tmp/acgc-integrator-tev-merged.cgdSGM/pc \
  -B /private/tmp/acgc-tev-merged-asan-ubsan.mQoixG \
  -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-tev-merged-asan-ubsan.mQoixG \
  --target acgc_pc_gx_tev_raw_shadow_fixture \
           acgc_pc_gx_tev_producer_fixture \
  --parallel 1
ctest --test-dir /private/tmp/acgc-tev-merged-asan-ubsan.mQoixG \
  -N -R '^(acgc_pc_gx_tev_raw_shadow_fixture|acgc_pc_gx_tev_producer_fixture)$'
ctest --test-dir /private/tmp/acgc-tev-merged-asan-ubsan.mQoixG \
  --output-on-failure --parallel 1 \
  -R '^(acgc_pc_gx_tev_raw_shadow_fixture|acgc_pc_gx_tev_producer_fixture)$'
```

Result: configure/generate passed; the serialized target build completed 61
steps; discovery found exactly two tests; both passed `2/2` in 0.14 seconds.
The retained log contains no AddressSanitizer, UndefinedBehaviorSanitizer,
runtime-error, or failed-test diagnostic.

Executable SHA-256 values:

- native raw shadow: `c85721f92247885f437dfcd01936a8313d29e7a0000619c1be3878f97be4bc11`
- native producer: `02d397ba002e852dbf1d8206d1f27e76a7012bb85d9fd21b6778b607723e527d`
- sanitizer raw shadow: `92aa2f3b29f74d0387e3cdaee18f3cb3335b880a1a3fb421a4afcda41ee322ac`
- sanitizer producer: `083353e2de5a87c578561a1d7dd001c66bcf41ce17b46539f4db0a9ae2c6b7e2`

The existing AppleClang `INT_MIN` redefinition and unsupported warning-option
messages remain non-fatal compile warnings. They are not sanitizer findings or
production-runtime proof.

## Proof boundary and next gate

Proved:

- exact PR #25 integration and three-path scope;
- strict acceptance of untouched unavailable TEV/KColor records;
- source-order, color/alpha-independent dependency rejection;
- deterministic canonical output for unread unavailable records;
- malformed-input and failure-immutability behavior; and
- exact-merge native plus combined ASan/UBSan configure, compile, link,
  discovery, and execution of the two focused CPU tests.

Not proved:

- a full `ac_pc` link or process launch at `70a8e23bc`;
- that the real process now passes TEV or reaches a later producer;
- cumulative-envelope publication or Apple callback/plan delivery;
- Indirect production or semantic validity beyond the focused TEV value gate;
- Metal encode, present, readback, pixels, or device behavior; or
- input, audible audio, save/reload, lifecycle, Windows execution, iOS, or
  playability.

The next critical-path gate is one serialized full `ac_pc` link from this exact
merge and one bounded real-process trace using process-lifetime attempt IDs.
It must stop at the next first-failing producer or the first cumulative
publication, preserve exact-PID cleanup, and must not infer Metal or pixel work
from CPU callback reachability.
