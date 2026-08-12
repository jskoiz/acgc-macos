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
`e826aca36ba71a1848ebe3c44d40ab506eb2c04d`.

```sh
./scripts/verify-portable-core.sh
```

Result: AppleClang arm64 configure/build passed with `-Wall -Wextra -Wpedantic`;
CTest passed 1/1.

The additional sanitizer lane used:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /tmp/codex-acgc-portable-sanitize -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS=-fsanitize=address,undefined \
  -DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined
cmake --build /tmp/codex-acgc-portable-sanitize --verbose
ctest --test-dir /tmp/codex-acgc-portable-sanitize --output-on-failure
```

Result: 1/1 passed under AddressSanitizer and UndefinedBehaviorSanitizer.
Synthetic tests cover endian loads, literal/short/extended Yaz0 copies,
overlapping references, empty output, truncated inputs, invalid references,
short headers, output-size limits, invalid arguments, and bad headers.

Independent re-review found the short-header, allocation-bound, empty-REL, and
CMake-scoping issues resolved with no new high-confidence defect. A synthetic
`pc_disc_extract_rel`/FST/CISO/GCM integration harness is still missing, and the
broader existing disc parser still trusts FST-declared input sizes and raw REL
offsets. Those remain explicit follow-up debt rather than proof supplied by the
portable unit test.

For source-data compatibility, DTK copied the compressed REL to an exact
temporary path outside Git, the portable decoder streamed its result into
`shasum -a 1`, and the hash matched
`c59d278ad8542bb05d6cbb632f60a0db05bef203`. The temporary compressed copy,
harness source, and harness binary were then removed and their absence checked.

## Proof ledger

| Gate | State | Evidence/limitation |
| --- | --- | --- |
| Source/revision | Passed | ISO SHA-256 plus original DOL/REL SHA-1s. |
| ac-decomp configure/extract | Passed | Configure and DTK extraction completed. |
| ac-decomp matching build | Blocked | Wine absent before Metrowerks compilation. |
| Portable arm64 library | Passed | Native + ASan/UBSan CTest, real REL decode hash. |
| Existing Windows build | Not run | No local 32-bit Windows/MinGW execution lane. |
| macOS host build | Not reached | 64-bit ABI migration remains. |
| macOS launch/frame/input/audio/save | Not reached | No host exists yet. |
| iOS simulator/device | Not reached | Begins after shared macOS proof. |

No commit, push, PR, binary publication, deployment, TestFlight upload, or App
Store action is implied by this ledger.
