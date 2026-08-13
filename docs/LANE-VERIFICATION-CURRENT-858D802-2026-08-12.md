# Current HEAD native arm64 and sanitizer verification

Run date: 2026-08-12 (Honolulu). This is a successor evidence lane for the
authoritative `ACGC-PC-Port` source at
`858d802c2bf95117a7c173419478fc4fc8493691` (`Test PCInputSnapshot PADRead
handoff`) on branch `c1/macos-host-launch`.

The earlier report
[`LANE-VERIFICATION-MATRIX-2026-08-12.md`](LANE-VERIFICATION-MATRIX-2026-08-12.md)
is intentionally unchanged and remains scoped to `4f77dab`. This document is
current-HEAD evidence only; it does not retroactively update or replace the
older snapshot’s claims.

## Workspace and source truth

The evidence worktree is:

```text
/Users/jk/.codex/worktrees/2232/acgc-modern-port
branch: c1/lane-verification-matrix
HEAD:   4e50d2b88c16d2ed79010c5b6e08f408e9b4cf78
status: clean before this document was added
```

The lane’s nested upstream directories remained empty and uninitialized. No
submodule initialization or gitlink update occurred. The lane’s recorded
gitlinks remain:

```text
upstream/ACGC-PC-Port  3a6582d0d4e7955c67458f40f9bf6cf3f97c3d26
upstream/ac-decomp     09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c
```

The source was consumed read-only from the already checked-out authoritative
submodule in the main project checkout:

```text
/Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port
branch: c1/macos-host-launch
HEAD:   858d802c2bf95117a7c173419478fc4fc8493691
status: clean for the completed matrix
```

The source stayed at this exact commit for configuration, compilation, runtime
execution, sanitizer scanning, and the final source check for the completed
matrix. During a later attempt to add two supplemental CARD ABI object builds,
another lane advanced the same shared checkout to
`8b6849f0a783f05de81f07ab30c477d1b24b6faf` (`Add SDL input path smoke
harness`). The snapshot guard stopped before either supplemental build invoked
CMake, so this report is scoped to `858d802`, not `8b6849f`.

Relative to the older tested snapshot `4f77dab`, the current source contains
21 changed files with 3,389 insertions and 52 deletions. The integrated commits
cover:

```text
e03ffed  Capture bounded graph submission prefix
e5442de  Add injectable PC input snapshot boundary
83fa889  Add renderer-neutral GX semantic packet contract
866dd94  Add Metal geometry state encoder fixtures
766ad96  Add synthetic audio mixer PCM probe
ddbb498  Add Apple texture and TEV fixtures
858d802  Test PCInputSnapshot PADRead handoff
```

No ISO, `local/` disc input, extracted proprietary assets, or asset-copying
path was accessed by this successor lane. No disc verification or full-game
asset build was run. The PC CMake configuration only established the existing
focused target graph; the full `ac_pc` target was not built or linked.

Host/toolchain:

```text
arm64
macOS 26.5.1
AppleClang 21.0.0 (clang-2100.1.1.101)
CMake 4.3.3
Ninja 1.13.2
SDL2 2.32.10 (Homebrew arm64)
```

All generated output and logs are under the unique ignored root:

```text
/private/tmp/acgc-lane-verification-current-build
```

The native build directories are `native-portable`, `native-pc`, and
`native-apple`; the sanitizer directories are `sanitizer-portable`,
`sanitizer-pc`, and `sanitizer-apple`.

## Exact configurations and build commands

Native portable configuration:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-lane-verification-current-build/native-portable \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++
```

Native focused PC configuration:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-verification-current-build/native-pc \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
```

Native focused Apple configuration:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/apple \
  -B /private/tmp/acgc-lane-verification-current-build/native-apple \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++
```

For each target below, the exact serialized build command was:

```sh
cmake --build <build-directory> --target <target> --parallel 1 --verbose
```

The native target set was:

```text
native-portable:
  acgc_gx_semantic_packet_tests
  acgc_gx_semantic_packet_cpp_tests
  acgc_portable_tests
  acgc_boot_source_tests
  acgc_boot_source_cpp_header_tests
  acgc_dvd_host_state_tests
  acgc_dvd_public_abi_c_tests
  acgc_dvd_public_abi_cpp_tests
  acgc_static_gbi_compile_c_probe
  acgc_static_gbi_compile_cpp_probe
  acgc_static_gbi_legacy_c_probe
  acgc_pc_abi_probe
  acgc_npc_actor_slot_probe
  acgc_pc_libc_memory_probe_c
  acgc_pc_libc_memory_probe_cpp
  acgc_jkr_aram_stream_abi_probe
  acgc_jkr_exp_heap_probe
  acgc_jsu_stream_enum_probe

native-pc:
  acgc_pc_input_snapshot_tests
  acgc_pc_dvd_read_boundary_tests
  acgc_pc_card_roundtrip_tests
  acgc_pc_platform_link_probe
  acgc_pc_audio_device_probe
  acgc_pc_audio_mixer_pcm_probe
  acgc_pc_aram_native_roundtrip

native-apple:
  acgc_macos_host_core_tests
  acgc_game_runtime_probe
  acgc_legacy_seam_tests
  acgc_renderer_geometry_tests
  acgc_renderer_geometry_cpp_tests
  acgc_renderer_fixture_tests
  acgc_metal_state_fixture_tests
```

No full `ac_pc` game link, AppKit host bundle launch, or asset-dependent target
was included. The selected larger targets were still built one at a time.

The object-only targets `acgc_card_public_abi_c_probe` and
`acgc_card_public_abi_cpp_probe` were identified but were not part of the
completed `858d802` matrix. The snapshot guard stopped the attempted
supplemental build before source movement could mix them into the evidence.
The PC CARD roundtrip and DVD/CARD public boundary tests above are current
snapshot proof; these two additional CARD declarations remain unproven at
`858d802`. The older `4f77dab` report's CARD object-probe result must not be
reused as current proof.

The sanitizer configurations used the same source roots and target lists. The
sanitizer flags were:

```text
-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g
```

Portable sanitizer configuration:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-lane-verification-current-build/sanitizer-portable \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

PC sanitizer configuration:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-verification-current-build/sanitizer-pc \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

Apple sanitizer configuration, including the Objective-C fixture compiler:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/apple \
  -B /private/tmp/acgc-lane-verification-current-build/sanitizer-apple \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_OBJC_COMPILER=/usr/bin/clang \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_OBJC_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

Every sanitizer target used the same serialized `cmake --build` command. The
runtime environment for all sanitized CTest and direct runs was:

```sh
ASAN_OPTIONS='detect_leaks=0:halt_on_error=1:abort_on_error=1:print_summary=1'
UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1'
```

Leak detection was disabled as a macOS sanitizer runtime-noise control; no
other sanitizer suppression was used.

## Exact test commands and results

Native portable focused CTest:

```sh
ctest --test-dir /private/tmp/acgc-lane-verification-current-build/native-portable \
  --output-on-failure \
  -R '^(acgc_gx_semantic_packet_tests|acgc_gx_semantic_packet_cpp_tests|acgc_portable_tests|acgc_boot_source_tests|acgc_boot_source_cpp_header_tests|acgc_dvd_host_state_tests|acgc_dvd_public_abi_c_tests|acgc_dvd_public_abi_cpp_tests|acgc_npc_actor_slot_probe|acgc_pc_libc_memory_probe_c|acgc_pc_libc_memory_probe_cpp|acgc_jkr_aram_stream_abi_probe|acgc_jkr_exp_heap_probe|acgc_jsu_stream_enum_probe)$'
```

Result: 14/14 passed. The direct unregistered probe
`native-portable/acgc_pc_abi_probe` exited 0. The three static GBI targets
were compile-only object probes and built successfully.

Native PC focused CTest:

```sh
ctest --test-dir /private/tmp/acgc-lane-verification-current-build/native-pc \
  --output-on-failure \
  -R '^(acgc_pc_input_snapshot_tests|acgc_pc_dvd_read_boundary_tests|acgc_pc_card_roundtrip_tests|acgc_pc_audio_device_probe|acgc_pc_audio_mixer_pcm_probe)$'
```

Result: 4 passed and `acgc_pc_audio_device_probe` skipped with its configured
return code 77. Direct probes:

```sh
/private/tmp/acgc-lane-verification-current-build/native-pc/acgc_pc_platform_link_probe
/private/tmp/acgc-lane-verification-current-build/native-pc/acgc_pc_aram_native_roundtrip
SDL_AUDIODRIVER=dummy /private/tmp/acgc-lane-verification-current-build/native-pc/acgc_pc_audio_device_probe
```

The platform-link probe passed for SDL 2.32.10, OpenGL, pthread, and dlsym;
the ARAM probe exited 0. The dummy audio run passed with 57 callbacks, 32 kHz
stereo, 0 underruns, and 0 overruns. The direct live-audio result was:

```text
pc_audio device probe: SDL audio device unavailable: CoreAudio error
(AudioDeviceGetProperty (kAudioDevicePropertyDeviceIsAlive)): 560947818
return code: 77
```

The software mixer probe passed independently without opening a device:

```text
pc_audio mixer PCM probe: PASS (software mixer -> DAC -> callback; device not opened)
```

Native Apple focused CTest:

```sh
ctest --test-dir /private/tmp/acgc-lane-verification-current-build/native-apple \
  --output-on-failure \
  -R '^(acgc_macos_host_core_tests|acgc_game_runtime_probe|acgc_legacy_seam_tests|acgc_renderer_geometry_tests|acgc_renderer_geometry_cpp_tests|acgc_renderer_fixture_tests|acgc_metal_state_fixture_tests)$'
```

Result: 6 passed and `acgc_metal_state_fixture_tests` skipped with return code
77. Its direct output was:

```text
Metal state fixture: CPU contract PASS; SKIP (no macOS Metal device available)
return code: 77
```

The renderer fixture passed synthetic fixed-width texture/TLUT, CI14x2,
sampler, and TEV coverage without Metal or game rendering:

```text
renderer fixture tests: PASS (synthetic fixed-width texture/TLUT, CI14x2,
sampler, and TEV coverage; no Metal or game rendering)
```

The sanitized CTest commands were the same commands with each corresponding
sanitizer build directory and the two environment variables above. Results:

| Sanitized surface | Result |
| --- | --- |
| Portable/GX/DVD/ABI/probes | 14/14 passed |
| PC input/DVD/CARD/mixer/audio | 4 passed; live audio skipped with 77 |
| Apple host/geometry/renderer/TEV | 6 passed; Metal skipped with 77 |
| Sanitized platform-link and ARAM probes | Both passed |
| Sanitized PC ABI probe | Exit 0 |
| Sanitized dummy audio | Passed; 58 callbacks, 0 underruns, 0 overruns |
| Sanitized Metal fixture | CPU contract passed; skipped with 77 for no device |

The sanitizer log scan found no `AddressSanitizer`, `UndefinedBehaviorSanitizer`,
`runtime error:`, or sanitizer summary diagnostics. All 32 native and all 32
sanitizer selected targets built successfully; the result TSVs report zero
build failures. A later supplemental CARD object-build wrapper stopped before
invoking CMake when its snapshot guard observed `8b6849f`; this was not a build
failure and produced no post-`858d802` evidence.

## Warnings, skips, and regressions

The selected compiler build logs contain no `warning:` diagnostics. The native
PC and sanitizer PC configure logs each contain the deliberate CMake warning:

```text
PC_DARWIN_COMPILE_AUDIT is experimental: this is a compile frontier, not a
64-bit runtime port
```

This is an existing policy warning, not a failed configure or a new runtime
finding. No warning was promoted to an error in the selected targets.

The following registered targets were intentionally not built or run in the
bounded lane: `acgc_gbi_runtime_tests`, `acgc_emu64_seg2k0_tests`, and
`acgc_emu64_gbi_traversal_tests`. They would require additional larger links;
their absence is not counted as a pass. The full `ac_pc` game target and the
AppKit host self-test were also not run.

Compared with the older `4f77dab` report:

- The older 12/12 portable focused pass remains green in the current source;
  the current run adds GX semantic packet coverage and the static GBI compile
  probes without a regression.
- The older DVD, CARD, platform-link, ARAM, and dummy audio boundaries remain
  green. The current input snapshot and software-mixer PCM probes also pass.
- The older live CoreAudio skip remains the same environmental limitation; no
  new audio failure appeared.
- The current Apple renderer geometry, texture/TLUT/CI14x2/TEV, legacy seam,
  and Metal CPU-contract fixtures all build and pass their available portions.
  The Metal device-dependent portion remains skipped, not failed.
- No ASan/UBSan finding or selected-target build regression was observed.
- The shared source checkout is now `8b6849f0a783f05de81f07ab30c477d1b24b6faf`.
  Its new SDL input smoke harness was not built or run by this report; a
  separate lane is needed for evidence against that later HEAD.

## Gates still unproven

- Full `ac_pc` game linking, launch, rendering, input interaction, audio in the
  game loop, save/load in the game, and gameplay remain unproven. This lane did
  not use game assets or the ISO.
- `acgc_gbi_runtime_tests`, both emu64 runtime targets, and the AppKit host
  self-test remain outside this bounded matrix.
- No live CoreAudio device was available. Dummy SDL audio and the software
  mixer probe prove adapter/mixer behavior only, not physical output or audible
  mixer correctness.
- No macOS Metal device was available. The Metal fixture proves the CPU state
  contract and compiles the device-dependent fixture target, but no device was
  available for command-buffer completion or rendered output.
- `acgc_card_public_abi_c_probe` and `acgc_card_public_abi_cpp_probe` were not
  run at `858d802`; the later shared-checkout movement stopped the guarded
  supplemental attempt before CMake. Their current-snapshot status remains
  unproven.
- No windowed AppKit launch, frame capture, iOS build, device run, physical
  CARD hardware, or human gameplay acceptance was performed.
- The evidence worktree’s umbrella gitlink remains at its older recorded
  pointer. No source commit, nested submodule initialization, ISO/asset copy,
  remote action, upload, or publish occurred. The only intended repository
  change is this evidence document on `c1/lane-verification-matrix`.
