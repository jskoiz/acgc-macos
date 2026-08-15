# Current focused CPU matrix at `23c26e520a`

Date: 2026-08-14

Lane: 197 / task `01a002e1-540c-7693-b25d-363a1f209dd4`

Classification: verification-only CPU, sanitizer, and bounded portability
evidence

## Provenance

- ACGC-PC-Port: detached and clean at
  `23c26e520a943ac843023f0341d2670d9c7ef9fc`.
- ac-decomp: clean at
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Source-only bundle SHA-256:
  `5732e20f137ff5aa336fb07a65965afde93c269eb7f7390406bf0a7397347fec`.
- The bundle contains `23c26e520a` and requires
  `324c174ae31e06725b51d662f2645cfd8f96c835`; verification passed.
- Tracked PC and decomp worktrees remained clean and `git diff --check`
  passed. No branch, source, documentation, or umbrella mutation occurred.
- Protected ignored paths were not inspected.

## Exact test selection

The serial selection contains twelve neutral validators:

- `acgc_gx_canonical_envelope_tests`
- `acgc_gx_canonical_fog_state_tests`
- `acgc_gx_canonical_blend_state_tests`
- `acgc_gx_canonical_alpha_state_tests`
- `acgc_gx_canonical_transform_state_tests`
- `acgc_gx_canonical_geometry_state_tests`
- `acgc_gx_canonical_depth_state_tests`
- `acgc_gx_canonical_tev_state_tests`
- `acgc_gx_canonical_channel_state_tests`
- `acgc_gx_canonical_lighting_state_tests`
- `acgc_gx_canonical_dynamic_state_tests`
- `acgc_gx_canonical_texture_state_tests`

It also contains five setter-owned raw fixtures:

- `acgc_pc_gx_tev_raw_shadow_fixture`
- `acgc_pc_gx_transform_raw_shadow_fixture`
- `acgc_pc_gx_depth_raw_shadow_fixture`
- `acgc_pc_gx_texgen_raw_shadow_fixture`
- `acgc_pc_gx_geometry_raw_batch_fixture`

The targets are registered in `pc/CMakeLists.txt` and
`pc/portable/CMakeLists.txt`. Both configurations used fresh, distinct roots
and serial CTest execution (`--parallel 1` / `-j 1`) with the exact seventeen
names above.

## Results

- Native matrix: `17/17` passed.
- Combined AddressSanitizer/UndefinedBehaviorSanitizer matrix: `17/17`
  passed with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1`; no sanitizer report occurred.
- Canonical C and C++11 header/ABI probes passed.
- Bounded `-m32` C/C++ syntax probes passed.
- Host `_WIN32` and Clang `i686-w64-windows-gnu` header probes passed.
- No native i686 GCC/MinGW compiler is installed. A Windows-style CMake
  configure could not cross-link without the Windows archive/link toolchain;
  the static-library retry correctly reached the project gate that
  `PC_DARWIN_COMPILE_AUDIT` is Apple/Darwin-only. This is not Windows sign-off.

Diagnostics were limited to existing Apple `INT_MIN` redefinition,
unsupported `-Wno-builtin-declaration-mismatch`, and legacy Geometry-header
warnings. An initial target-name typo was corrected before compilation and did
not affect the executed matrix.

Generated roots at handoff were:

- `/private/tmp/acgc-lane-current-23c-matrix-native` (34 MiB);
- `/private/tmp/acgc-lane-current-23c-matrix-asan` (45 MiB);
- `/private/tmp/acgc-lane-current-23c-matrix-win` (164 KiB partial configure).

Exact remote holder checks returned no open files. All three generated roots
were then removed by exact path and rechecked absent. The protected source
worktree remains because it contains ignored local-only paths.

## Evidence boundary

This proves the focused integrated CPU baseline, compilation, and combined
sanitizer behavior at the exact source tip. Leak detection was disabled, so it
does not prove leak freedom. It does not prove a full `ac_pc` link, launch,
LLDB execution, Windows binary/runtime, resource or asset behavior, Apple/Metal
device execution, a rendered frame or pixel, iOS behavior, or playability.
