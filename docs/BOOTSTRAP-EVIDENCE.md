# Bootstrap Commands, Results, and Blockers

Run dates: 2026-08-11. Commands were executed from the same umbrella checkout
and owning submodules. Generated and extracted output remains ignored.

## Source/input verification

```sh
./scripts/verify-source-input.sh
```

Result: passed. The ISO exists, is ignored and untracked, has the approved
SHA-256, both submodule pins/remotes match, both `GAFE01_00/build.sha1` files
agree, and neither upstream has a nested submodule declaration.

## ac-decomp macOS path

From `upstream/ac-decomp`, an ignored symlink named
`orig/GAFE01_00/game.iso` points to the umbrella `local/roms` input.

```sh
python3 configure.py --version GAFE01_00
ninja -v
```

Results:

- configure: exit 0;
- DTK v1.6.2, compiler, binutils, configuration, extraction, and thousands of
  generated asset-conversion edges completed;
- Ninja reached approximately edge 5,071 of 9,189;
- the first Metrowerks compiler commands stopped with
  `/bin/sh: wine: command not found` (exit 127);
- reconstructed `static.dol` and `foresta.rel` were therefore not produced, so
  the matching-build hash gate was not reached.

The ignored original files produced by DTK match the expected DOL/REL SHA-1s.
That is revision evidence, not reconstructed-build evidence. Installing the
documented Wine Crossover prerequisite remains a user-authorized toolchain
decision.

## PC runtime configure probe

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /tmp/codex-acgc-pc-port-macos-audit \
  -G Ninja
```

Result: fails deliberately at the 32-bit pointer guard. Modern macOS cannot run
a 32-bit process, and removing the guard without migrating pointer encodings is
unsafe. The earlier `include/types.h` dependency on unavailable `<malloc.h>` is
now resolved narrowly for TARGET_PC, but the default full-runtime guard remains.

A diagnostic-only configure used CMake's project-include hook to override the
configure-time pointer-size value without changing tracked guards:

```sh
printf '%s\n' 'set(CMAKE_SIZEOF_VOID_P 4)' > /tmp/acgc-force-pointer-probe.cmake
cmake -S upstream/ACGC-PC-Port/pc \
  -B /tmp/codex-acgc-full-runtime-frontier-3 -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_PROJECT_INCLUDE=/tmp/acgc-force-pointer-probe.cmake
cmake --build /tmp/codex-acgc-full-runtime-frontier-3 --parallel 8
```

Configure passed with arm64 SDL2 2.32.10 and the macOS OpenGL framework. The
build then stopped at the still-tracked `pc_platform.h` pointer guard and its
Linux-only `<elf.h>` include. This is compile-frontier evidence, not authority
to weaken the default guard and not a runtime result.

## Portable core

Owning integration branch: `c1/macos-host-launch`; local commit:
`8cf37f8a94230b0f378c07779e4f2cd031f4aa5e`.

The reviewed source lineage is:

- `e826aca36ba71a1848ebe3c44d40ab506eb2c04d` - bounded endian and Yaz0 core;
- `9d5b87125b37930399f50ce4d1f26351409d1b63` - integrated arena-address,
  GBI-reference, and disc-parser lanes;
- `c3a27b68e0669f0664e11da7e5e435258e951106` - closed the independent
  review findings and added focused integration tests.
- `dc0899a9f427e0ff52a4ce6913c562feedd39fe8` - hardened TwoHeadArena
  free-space accounting for high native addresses.
- `454780cb998d7f1a42fa33c048ac099e8c690c66` - added the native AppKit host and
  focused host tests.
- `9984d25186817b9702c7a95acc6502478fca8658` - added checked 64-bit CISO maps,
  sparse reads, and host seeks.
- `830e8d9961d8309751ebe1f4b7ffec7de71fe2d1` - made the current TARGET_PC
  scalar and GX packet widths explicit.
- `8cf37f8a94230b0f378c07779e4f2cd031f4aa5e` - moved current DVD host state
  behind generational handles and added
  executable DVD/CARD layout tests.

```sh
./scripts/verify-portable-core.sh
```

Result: AppleClang arm64 configure/build passed with `-Wall -Wextra -Wpedantic`;
CTest passed 3/3 (`acgc_portable_tests`, `acgc_gbi_runtime_tests`, and
`acgc_dvd_host_state_tests`). The build also compiled the fixed-width PC ABI
probe.

The additional sanitizer lane used:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /tmp/codex-acgc-portable-sanitize -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS=-fsanitize=address,undefined \
  -DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined
cmake --build /tmp/codex-acgc-portable-sanitize --verbose
env ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1 \
  UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
  ctest --test-dir /tmp/codex-acgc-portable-sanitize --output-on-failure
```

Result: 3/3 passed under AddressSanitizer and UndefinedBehaviorSanitizer. Apple
ASan does not support `detect_leaks=1`, so the successful run used the explicit
platform-supported setting above.

The combined synthetic suites now cover:

- fixed-width endian loads and bounded raw/Yaz0 decoding;
- high native addresses, checked alignment/ranges, overflow/underflow, and the
  TwoHeadArena downward-allocation formula;
- opaque GBI reference registration, generation/reuse, stale and malformed
  handles, exhaustion, reset invalidation, direct words, odd pointers, and an
  even native value above 4 GiB through the real pack/unpack wrapper;
- bounded GCM headers, DOL spans, FST traversal/types/parents/subtree bounds,
  callback failure, entry limits, raw/Yaz0 REL extraction, short reads,
  truncated input, and input/output limits.
- checked CISO block geometry, sparse reads, physical truncation, invalid map
  flags, arbitrary bounded block sizes, and overflow rejection;
- DVD host handle allocation/reuse/staleness/exhaustion, checked read ranges,
  bounded path copies, and fixed DVD/CARD record sizes and offsets;
- exact TARGET_PC scalar widths and the 8-byte `Gwords`/16-byte `TexRect`
  contracts on native arm64, plus C/C++ and `-m32` syntax probes.

The first integrated commit was independently reviewed. The review reproduced
six defects: an above-4-GiB wrapper truncation, missing registry reclamation,
reserved-handle fallthrough, silent FST adapter overflow, a DOL span inside its
header, and invalid FST entry types. The follow-up commit closes all six. A
second independent pass found no new actionable defect; focused harnesses also
proved stale/malformed references fail closed and the 1,025th adapter file and
overlong adapter paths are rejected.

The current tracked real-input command is:

```sh
./scripts/verify-disc-core.sh
```

Result: the approved ignored ISO passed bounded GCM/DOL/FST parsing; DOL size was
918,720 bytes; 10 files were visited; exactly one 6,137,393-byte
`foresta.rel.szs` was found; Yaz0 output was 15,640,056 bytes; and its SHA-1
matched `c59d278ad8542bb05d6cbb632f60a0db05bef203`. The script builds its probe
and writes the decoded REL only in a private temporary directory, then removes
both automatically.

Clang and the installed `gcc` driver (Apple Clang on this host) also passed
`-m32` syntax probes for the portable sources, tests, `pc_gbi_runtime.c`, and
the revised DVD/CARD shims. A 32-bit executable cannot be linked on this arm64
macOS host. The full CMake project still stops at the unchanged ILP32 guard by
default; the diagnostic bypass exposes the separate Darwin/ELF platform-header
boundary next.

## Native macOS host build and launch

The owning source target is `upstream/ACGC-PC-Port/pc/apple`. It is independent
of the legacy SDL/OpenGL build graph and links only AppKit/Foundation plus the
dependency-free portable library. It accepts an explicit ISO/GCM path, opens it
read-only, accepts exact disc ID `GAFE01`, validates bounded GCM/DOL/FST data,
and creates only bundle-scoped Application Support and cache directories.

```sh
./script/build_and_run.sh --headless
./script/build_and_run.sh --verify
```

Headless result: host CTest passed 2/2, the approved ignored ISO was accepted,
the DOL size was 918,720 bytes, and 10 FST files were visited. Foreground result:
the same build/tests passed, LaunchServices opened a new normal AppKit app, its
exact executable process was observed, and `--verify-seconds 2` produced a clean
exit. Generated build/runtime state stayed under ignored `local/` paths.

This passes the host-build and host-launch gates only. The shell explicitly
reports rendering, game frame, input, audio, and save/load as unimplemented; it
does not execute reconstructed game logic and is not a playability result.

## Proof ledger

| Gate | State | Evidence/limitation |
| --- | --- | --- |
| Source/revision | Passed | ISO SHA-256 plus original DOL/REL SHA-1s. |
| ac-decomp configure/extract | Passed | Configure and DTK extraction completed. |
| ac-decomp matching build | Blocked | Wine absent before Metrowerks compilation. |
| Portable arm64 library | Passed | Native + ASan/UBSan CTest, 3/3 in each lane, plus fixed-width ABI probe. |
| Supported-disc data path | Passed | Bounded GCM/DOL/FST parse and expected real REL hash. |
| Existing Windows build | Not run | Source-compatible branches and `-m32` syntax passed; no Windows execution lane. |
| macOS host build | Passed | Native AppKit target and focused CTest, 2/2. |
| macOS host launch | Passed | Exact app process observed; two-second timed exit was clean. |
| Rendered/game frame | Not reached | Host shell has no renderer or reconstructed game loop. |
| Input/audio/save | Not reached | Adapters are not wired to a running game. |
| iOS simulator/device | Not reached | Begins after shared macOS proof. |

No commit, push, PR, binary publication, deployment, TestFlight upload, or App
Store action is implied by this ledger.
