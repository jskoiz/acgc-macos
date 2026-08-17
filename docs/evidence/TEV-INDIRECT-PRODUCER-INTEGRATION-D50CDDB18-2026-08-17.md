# Canonical TEV and Indirect leaf-producer integration at `d50cddb18`

## Scope and provenance

Work resumed on 2026-08-17 from the 2026-08-15 pause. The paused lane-239 and
lane-240 review states were lost with the `/private/tmp` cleanup, so both
reviews were re-run from scratch against the archived candidates, and both
candidates were integrated after passing.

Process boundary: unlike the pre-pause workflow, these resumed reviews were
performed by the single integration owner in one session, not by separate
independent immutable review lanes. The review content (source review against
the recorded contracts, fresh focused native and combined ASan/UBSan gates,
production-object compiles, and `git diff --check`) matches the recorded lane
scope, but the two-party independence property does not apply to this
integration and is not claimed.

- review base: PC `62c810e5b6ee7710b2904ef4733ef95a6909fe1f` on
  `c1/macos-host-launch`; ac-decomp oracle
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- TEV candidate: `043d24822cd075b51282101669d7710b785bd01f` from archive ref
  `c1/archive/cleanup-20260815/canonical-tev-candidate` (four files including
  minimal `pc/CMakeLists.txt` registration);
- Indirect candidate: `2f6ba5dff300239aa509c2f5a76431cae3d4b3a3` from archive
  ref `c1/archive/cleanup-20260815/canonical-indirect-candidate` (three new
  files, no CMake edit);
- integrated commits on `c1/macos-host-launch`: `043d24822` (fast-forward),
  `b83a6f6e37d0a444c6cfbac546847ac1a52c50ff` (Indirect cherry-pick), and
  `d50cddb1815dd640a16b3ec1c899b9f4a7fee9d0` (integration-owner CMake
  registration of the Indirect fixture and production object);
- both worker commits and all integration commits are authored and committed
  as the repository owner; `git diff --check` over `62c810e5b..d50cddb18` is
  clean.

## Review findings

TEV producer (`pc_gx_tev_producer.c`): stages into caller-independent local
storage, treats `acgc_gx_canonical_tev_state_validate` as the single domain
authority, requires exact active-stage/register/KONST/swap provenance and
sticky-invalidity absence, zeroes inactive and reserved output state, and
copies to the destination only after canonical validation, preserving every
destination byte on failure. The hard-coded per-stage knownness walk matches
the raw contract: `PC_GX_RAW_TEV_STAGE_KNOWN_MASK` is 34 bits and the
144-byte (36-word) stage record leaves words 34–35 as a zero-required tail.

Indirect producer (`pc_gx_indirect_producer.c`): same staged fail-closed
pattern; active orders must be fully known, inactive order fields must be
zero when unknown, matrices are all-or-nothing known with a derived
`matrix_valid_mask`, the header masks derive from the active count, and
`acgc_gx_canonical_indirect_state_validate` gates publication.

No blocker was found in either candidate.

## Exact verification

Review-worktree gates from the archived candidates (fresh ignored roots,
`-G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
-DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_OSX_ARCHITECTURES=arm64`, sanitizer
roots adding `-fsanitize=address,undefined -fno-omit-frame-pointer` with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`):

- TEV `acgc_pc_gx_tev_producer_fixture`: native CTest `1/1`, combined
  ASan/UBSan CTest `1/1`, `acgc_pc_gx_tev_producer_object` compiles;
- Indirect source-direct harness (fixture + producer +
  `gx_canonical_indirect_state.c` and its dependency validators, compiled
  with `clang -std=c11 -arch arm64 -Wall -Wextra -Wpedantic
  -DPC_DARWIN_COMPILE_AUDIT`): native pass and combined ASan/UBSan pass, no
  diagnostics.

Exact integrated-tip gates at `d50cddb18` from the canonical checkout, run
serially in fresh ignored roots:

- native focused CTest
  `-R '^acgc_pc_gx_(tev|indirect)_producer_fixture$'`: `2/2` passed;
- combined ASan/UBSan focused CTest, same selection: `2/2` passed;
- `acgc_pc_gx_tev_producer_object` and `acgc_pc_gx_indirect_producer_object`
  both compile in the native root;
- no sanitizer diagnostics; leak detection disabled, so this is not
  leak-free proof.

Windows `_WIN32` probes remain blocked by the absent i686 sysroot/`process.h`
toolchain, exactly as recorded pre-pause; no Windows sign-off is claimed.

## Claim boundary and next gate

This integrates the canonical TEV and Indirect leaf producers as CPU
contracts with focused native and combined ASan/UBSan evidence on the exact
integrated snapshot. No full link, LLDB, runtime, live snapshot, callback,
Metal/device operation, pixel, input, audio, save, iOS, or playability claim
follows. The next gates are the lane-238 `BLOCK` closures: truthful Blend and
Fog raw owners and leaves, the Geometry dependency-result builder,
production/envelope wiring, atomic resource-lease publication, the
all-or-nothing cumulative assembler, and the typed Apple CPU consumer.
