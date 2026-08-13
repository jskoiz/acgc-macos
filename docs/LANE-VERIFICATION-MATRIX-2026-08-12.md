# Native arm64 and sanitizer verification matrix

Run date: 2026-08-12 (Honolulu). This is an evidence-only lane for the
integrated `ACGC-PC-Port` source at `4f77dab413e4fe29264cfc68b0f7fac1ade74d01`
(`Allow sector-tail reads for PC DVD files`). It does not modify source, the
ISO, either upstream history, or the umbrella gitlink.

## Workspace and input truth

The evidence worktree is:

```text
/Users/jk/.codex/worktrees/2232/acgc-modern-port
```

Its final Git state is branch `c1/lane-verification-matrix`, umbrella
`82732fe41e510d0685ea80491bba8062d3c694b9`, clean except for this document.
The lane checkout intentionally has empty, uninitialized directories at
`upstream/ACGC-PC-Port` and `upstream/ac-decomp`; no submodule initialization
was performed. Its recorded gitlinks remain:

```text
upstream/ACGC-PC-Port  3a6582d0d4e7955c67458f40f9bf6cf3f97c3d26
upstream/ac-decomp     09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c
```

The exact integrated source was therefore consumed read-only from the already
checked-out submodule in the main project checkout:

```text
/Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port
branch: c1/macos-host-launch
HEAD:   4f77dab413e4fe29264cfc68b0f7fac1ade74d01
source status: clean
```

That source checkout was not edited. The main project checkout’s umbrella
gitlink points at `4f77dab`; this lane deliberately does not copy that pointer
back to the lane umbrella, per the delegation boundary.

Snapshot boundary: the source was at `4f77dab` for configuration, compilation,
runtime execution, the post-run source check, and evidence capture. During the
final handoff recheck, another lane advanced that shared read-only source
checkout on `c1/macos-host-launch` through `e5442de` to `e03ffed` at 16:04:27
with two cherry-picks. `4f77dab` is an ancestor of that newer commit. This
report remains scoped to the tested `4f77dab` snapshot and is not evidence for
the later `e03ffed` source; the newer checkout was not switched, edited, or
rebuilt by this lane.

The ignored disc input was read-only and matched the expected SHA-256:

```text
/Users/jk/Documents/Projects/acgc-modern-port/local/roms/Animal Crossing (USA).iso
a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d
```

Host/toolchain:

```text
arm64
macOS 26.5.1
AppleClang 21.0.0 (clang-2100.1.1.101)
CMake 4.3.3
Ninja 1.13.2
SDL2 2.32.10 (Homebrew arm64)
```

All generated build directories and logs are under the unique ignored lane
root `/private/tmp/acgc-lane-verification-matrix`:

```text
/private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native
/private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc
/private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/portable
/private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/pc
/private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/disc
```

## Exact command set

The native dependency-free portable configuration was:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++
```

The selected native portable targets were built one at a time with
`--parallel 1` and `--verbose`, with each invocation logged below the build
directory:

```sh
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_portable_tests --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_boot_source_tests --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_boot_source_cpp_header_tests --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_dvd_host_state_tests --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_dvd_public_abi_c_tests --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_dvd_public_abi_cpp_tests --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_card_public_abi_c_probe --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_card_public_abi_cpp_probe --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_pc_abi_probe --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_npc_actor_slot_probe --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_pc_libc_memory_probe_c --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_pc_libc_memory_probe_cpp --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_jkr_aram_stream_abi_probe --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_jkr_exp_heap_probe --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --target acgc_jsu_stream_enum_probe --parallel 1 --verbose
```

The focused native portable execution was:

```sh
ctest --test-dir /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native \
  --output-on-failure \
  -R '^(acgc_portable_tests|acgc_boot_source_tests|acgc_boot_source_cpp_header_tests|acgc_dvd_host_state_tests|acgc_dvd_public_abi_c_tests|acgc_dvd_public_abi_cpp_tests|acgc_npc_actor_slot_probe|acgc_pc_libc_memory_probe_c|acgc_pc_libc_memory_probe_cpp|acgc_jkr_aram_stream_abi_probe|acgc_jkr_exp_heap_probe|acgc_jsu_stream_enum_probe)$'
/private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-native/acgc_pc_abi_probe
```

The macOS SDL/OpenGL focused configuration was:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
```

Only these existing focused host targets were built, serially; the full
`ac_pc` game target was not requested or linked:

```sh
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc \
  --target acgc_pc_dvd_read_boundary_tests --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc \
  --target acgc_pc_card_roundtrip_tests --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc \
  --target acgc_pc_platform_link_probe --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc \
  --target acgc_pc_audio_device_probe --parallel 1 --verbose
cmake --build /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc \
  --target acgc_pc_aram_native_roundtrip --parallel 1 --verbose
```

The focused host execution was:

```sh
ctest --test-dir /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc \
  --output-on-failure \
  -R '^(acgc_pc_dvd_read_boundary_tests|acgc_pc_card_roundtrip_tests|acgc_pc_platform_link_probe|acgc_pc_audio_device_probe)$'
/private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc/acgc_pc_aram_native_roundtrip
/private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc/acgc_pc_platform_link_probe
SDL_AUDIODRIVER=dummy /private/tmp/acgc-lane-verification-matrix/lane-82732fe-arm64-pc/acgc_pc_audio_device_probe
```

The sanitizer configurations used arm64 ASan+UBSan flags on both C and C++
compilation and executable links:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/portable \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'

cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/pc \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  '-DCMAKE_C_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g' \
  '-DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined'
```

The sanitizer portable target list was the native list without the unregistered
`acgc_pc_abi_probe`; the sanitizer PC target list was the five focused PC
targets above. Each was built with the corresponding `cmake --build ...
--target ... --parallel 1 --verbose` command. Runtime checks used:

```sh
ASAN_OPTIONS='detect_leaks=0:halt_on_error=1:abort_on_error=1:print_summary=1' \
UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1' \
  ctest --test-dir /private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/portable \
  --output-on-failure \
  -R '^(acgc_portable_tests|acgc_boot_source_tests|acgc_boot_source_cpp_header_tests|acgc_dvd_host_state_tests|acgc_dvd_public_abi_c_tests|acgc_dvd_public_abi_cpp_tests|acgc_npc_actor_slot_probe|acgc_pc_libc_memory_probe_c|acgc_pc_libc_memory_probe_cpp|acgc_jkr_aram_stream_abi_probe|acgc_jkr_exp_heap_probe|acgc_jsu_stream_enum_probe)$'

ASAN_OPTIONS='detect_leaks=0:halt_on_error=1:abort_on_error=1:print_summary=1' \
UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1' \
  ctest --test-dir /private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/pc \
  --output-on-failure \
  -R '^(acgc_pc_dvd_read_boundary_tests|acgc_pc_card_roundtrip_tests|acgc_pc_audio_device_probe)$'
```

The sanitized direct probes were run with the same two environment variables,
including `SDL_AUDIODRIVER=dummy` for the supplemental audio run.

Finally, the existing disc verification script was run read-only from the
checkout whose umbrella gitlink already points at `4f77dab`:

```sh
sh /Users/jk/Documents/Projects/acgc-modern-port/scripts/verify-disc-core.sh
```

An equivalent sanitized copy of the existing probe was compiled into the
temporary lane directory with:

```sh
/usr/bin/clang -std=c11 -D_DARWIN_C_SOURCE -Wall -Wextra -Wpedantic -Werror \
  -fsanitize=address,undefined -fno-omit-frame-pointer -O1 -g \
  -I /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/portable/include \
  /Users/jk/.codex/worktrees/2232/acgc-modern-port/scripts/probes/verify_disc_core.c \
  /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/portable/src/boot_source.c \
  /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/portable/src/disc.c \
  /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/portable/src/yaz0.c \
  -fsanitize=address,undefined \
  -o /private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/disc/verify-disc-core
ASAN_OPTIONS='detect_leaks=0:halt_on_error=1:abort_on_error=1:print_summary=1' \
UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1' \
  /private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/disc/verify-disc-core \
  '/Users/jk/Documents/Projects/acgc-modern-port/local/roms/Animal Crossing (USA).iso' \
  /private/tmp/acgc-lane-verification-matrix/lane-82732fe-asan-ubsan/disc/foresta.rel
```

## Results

| Surface | Build | Runtime result | Evidence |
| --- | --- | --- | --- |
| Portable core and boot source | 3 native arm64 targets | Pass | `acgc_portable_tests`, `acgc_boot_source_tests`, and C++ header test all passed. |
| DVD host state and public ABI | 3 native arm64 targets | Pass | C and C++ DVD tests passed. |
| CARD public ABI | 2 native arm64 object probes | Compile pass | C and C++ fixed-layout/callback probes compiled; they are object-only compile probes, not hardware tests. |
| Existing portable host probes | 7 native arm64 targets | Pass | NPC actor, libc memory C/C++, JKR ARAM, JKR expansion heap, and JSU stream probes passed; PC ABI probe also exited 0. |
| Portable CTest aggregate | Native arm64 | 12/12 passed | No selected portable runtime test failed. |
| PC DVD boundary | Native arm64 | Pass | Sector-tail read rounded 19 bytes to 32, malformed ranges rejected, and malformed reads did not touch the disc boundary. |
| PC CARD round-trip | Native arm64 | Pass | Host save directory creation, fixed-offset write/read, reopen, range rejection, unmount, and traversal rejection passed. |
| SDL/OpenGL/pthread/dlsym link | Native arm64 | Pass | `platform link probe: PASS SDL 2.32.10, OpenGL symbol, pthread, dlsym`. |
| ARAM native round-trip | Native arm64 | Pass | Existing probe exited 0. |
| Audio adapter, live CoreAudio | Native arm64 | Skipped / unproven | CTest honored skip code 77; direct probe reported no live device with CoreAudio error `560947818`. |
| Audio adapter, SDL dummy device | Native arm64 | Pass, supplemental only | 59 callbacks, 32 kHz stereo, 0 underruns, 0 overruns; this is not CoreAudio/device proof. |
| Disc parse and REL extraction | Native arm64 | Pass | `gcm=ok dol_size=918720 fst_files=10 rel_entries=1 rel_input=6137393 rel_output=15640056 rel_format=yaz0`; REL SHA-1 `c59d278ad8542bb05d6cbb632f60a0db05bef203`. |
| Portable ASan+UBSan | arm64 | 12/12 passed | No ASan or UBSan diagnostics; leak detection was disabled as a macOS runtime-noise control. |
| PC DVD/CARD/host ASan+UBSan | arm64 | 2 pass, audio skipped | DVD and CARD passed; platform-link and ARAM direct probes passed; live audio skipped; dummy audio passed. |
| Sanitized real-disc probe | arm64 | Pass | Same GCM/DOL/FST/REL summary and REL SHA-1; no ASan or UBSan diagnostic. |

The native and sanitizer build result TSVs report zero build failures. The
focused build logs are retained under the temporary directories above.

## Warnings and non-product failures

The focused builds completed successfully but emitted pre-existing warnings in
the legacy headers and small probe sources. The native and sanitizer portable
logs each contain 72 warning lines across four target logs. The native and
sanitizer PC logs each contain 99 warning lines across four target logs. The
recurring classes include missing C prototypes, legacy exception-specification
mismatches, multi-character constants, unknown pragmas, unused legacy helper
functions, flexible/zero-length arrays, macro redefinitions, an ignored GCC
warning option under AppleClang, and a `u32`/`unsigned long` format mismatch.
These warnings were not promoted to errors by the CMake targets and did not
produce a runtime sanitizer finding.

The first local build wrapper attempt stopped before CMake because zsh reserves
the variable name `status` (`zsh:2: read-only variable: status`). It was rerun
with a non-reserved result filename; this was a lane-wrapper error, not a
source/build failure.

## Gates that remain unproven

- The full `ac_pc` game target was intentionally not linked. The CMake warning
  states that `PC_DARWIN_COMPILE_AUDIT` is an experimental compile frontier,
  not a 64-bit runtime port. No claim is made for the complete legacy PC game
  build, launch, rendering, input, save/load, or gameplay loop.
- `acgc_gbi_runtime_tests`, `acgc_emu64_seg2k0_tests`, and the Apple-only
  `acgc_emu64_gbi_traversal_tests` were registered by the portable CMake
  project but intentionally not built in this bounded lane. `ctest -N`
  reported their executables as absent; they are not included in the 12-test
  pass count.
- A live CoreAudio device was unavailable. The dummy SDL pass establishes the
  ring/callback adapter behavior only; it does not prove CoreAudio device
  opening, physical output, audible mixer correctness, or long-duration device
  stability.
- CARD evidence is a host-file round-trip and public ABI/compile surface. It
  does not prove a physical GameCube memory-card device, filesystem behavior on
  hardware, or external save compatibility.
- Disc evidence parses the supplied ignored ISO and extracts the expected REL;
  it does not prove a full game launch or legacy decomp rebuild. The source
  input and ISO hash gates are separate from runtime/platform proof.
- No AppKit/Metal windowed launch, rendered-frame capture, input interaction,
  iOS build, device run, or human gameplay acceptance was performed by this
  lane.
- No umbrella submodule pointer update, source commit, remote action, upload,
  or publish occurred. The only intended repository change is this evidence
  document on `c1/lane-verification-matrix`.
