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
a 32-bit process, and removing the guard before migrating pointer encodings is
unsafe. A direct `pc_disc.c` AppleClang syntax probe also reaches the existing
`include/types.h` dependency on unavailable `<malloc.h>`.

## Portable core

Owning branch: `c1/macos-portable-disc-core`; local commit:
`c3a27b68e0669f0664e11da7e5e435258e951106`.

The reviewed source lineage is:

- `e826aca36ba71a1848ebe3c44d40ab506eb2c04d` - bounded endian and Yaz0 core;
- `9d5b87125b37930399f50ce4d1f26351409d1b63` - integrated arena-address,
  GBI-reference, and disc-parser lanes;
- `c3a27b68e0669f0664e11da7e5e435258e951106` - closed the independent
  review findings and added focused integration tests.

```sh
./scripts/verify-portable-core.sh
```

Result: AppleClang arm64 configure/build passed with `-Wall -Wextra -Wpedantic`;
CTest passed 2/2 (`acgc_portable_tests` and `acgc_gbi_runtime_tests`).

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

Result: 2/2 passed under AddressSanitizer and UndefinedBehaviorSanitizer. Apple
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

Clang and the installed GCC driver also passed `-m32` syntax probes for all
portable sources, both test files, and `pc_gbi_runtime.c`. A 32-bit executable
cannot be linked on this arm64 macOS host. Full-PC translation units still reach
the pre-existing `include/types.h` dependency on unavailable `<malloc.h>`, and
the full CMake project still stops at the unchanged ILP32 guard.

## Proof ledger

| Gate | State | Evidence/limitation |
| --- | --- | --- |
| Source/revision | Passed | ISO SHA-256 plus original DOL/REL SHA-1s. |
| ac-decomp configure/extract | Passed | Configure and DTK extraction completed. |
| ac-decomp matching build | Blocked | Wine absent before Metrowerks compilation. |
| Portable arm64 library | Passed | Native + ASan/UBSan CTest, 2/2 in each lane. |
| Supported-disc data path | Passed | Bounded GCM/DOL/FST parse and expected real REL hash. |
| Existing Windows build | Not run | Source-compatible branches and `-m32` syntax passed; no Windows execution lane. |
| macOS host build | Not reached | 64-bit ABI migration remains. |
| macOS launch/frame/input/audio/save | Not reached | No host exists yet. |
| iOS simulator/device | Not reached | Begins after shared macOS proof. |

No commit, push, PR, binary publication, deployment, TestFlight upload, or App
Store action is implied by this ledger.
