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
unsafe. The default production guard remains unchanged.

The tracked diagnostic-only Darwin audit is explicit and opt-in:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /tmp/codex-acgc-darwin-audit-card-745a3c2 -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DPC_DARWIN_COMPILE_AUDIT=ON
cmake --build /tmp/codex-acgc-darwin-audit-card-745a3c2 --parallel 1
```

Configure passed with arm64 SDL2 2.32.10 and the macOS OpenGL framework. The
Darwin host-image split, typed DVD implementation, and first GBI pointer-width
barrier compiled. `Padclamp.c` and the CARD boundary now compile after the 12
public/owning signatures were made fixed-width. The single-job build then
stopped deterministically at step 20 of 4,009 in `pc_audio.c`, through
`libultra.h`: `bcmp` conflicts with Darwin's const/`size_t` declaration, while
`bcopy` and `bzero` collide with Darwin fortified macros. This is compile-
frontier evidence, not authority to weaken the default guard and not a runtime
result.

## Portable core

Owning integration branch: `c1/macos-host-launch`; local commit:
`745a3c2f10c58f81ed14a979f6943719ce533826`.

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
- `d169164726c62836b464b28401523bad87f2df0c` - split Darwin Mach-O image-range
  probing from Linux ELF handling and added the opt-in compile audit.
- `7c7d8ad6137a0ad0007e482da0107ac73e991abe` - classified the typed public DVD
  ABI and keyed native host state by `DVDFileInfo` owner identity.
- `f344c165f1a5599f4b75146cc84d0311a474c658` - added a native CAMetalLayer
  clear/present fixture with bounded completion and failure evidence.
- `f9d1a26d5f19e05a17e4236b3dfabaf5e087409e` - widened resolved `emu64` host
  pointers, guarded pointer consumers, and retained 32-bit GBI command words.
- `745a3c2f10c58f81ed14a979f6943719ce533826` - made the public and owning CARD
  scalar/callback declarations fixed-width and added C/C++ ABI probes.

```sh
./scripts/verify-portable-core.sh
```

Result: AppleClang arm64 configure/build passed with `-Wall -Wextra -Wpedantic`;
CTest passed 6/6 (`acgc_portable_tests`, `acgc_gbi_runtime_tests`,
`acgc_emu64_seg2k0_tests`, `acgc_dvd_host_state_tests`, and the C/C++ typed DVD
public-ABI tests). The build also compiled the fixed-width PC and CARD C/C++
ABI probes.

The additional sanitizer lane used:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /tmp/codex-acgc-portable-sanitize -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS=-fsanitize=address,undefined \
  -DCMAKE_CXX_FLAGS=-fsanitize=address,undefined \
  -DCMAKE_EXE_LINKER_FLAGS=-fsanitize=address,undefined
cmake --build /tmp/codex-acgc-portable-sanitize --verbose
env ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1 \
  UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
  ctest --test-dir /tmp/codex-acgc-portable-sanitize --output-on-failure
```

Result: 6/6 passed under AddressSanitizer and UndefinedBehaviorSanitizer. Apple
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
- typed C and C++ `DVDFileInfo`/`DVDCommandBlock` layouts on LP64, owner-keyed
  host-state lifecycle, duplicate-owner rejection, typed callback dispatch, and
  preservation of the ILP32 public layout;
- exact TARGET_PC scalar widths and the 8-byte `Gwords`/16-byte `TexRect`
  contracts on native arm64, plus C/C++ and `-m32` syntax probes;
- direct `emu64::seg2k0()` resolution of a live native address above 4 GiB,
  stale/malformed-handle rejection, width-correct dynamic display-list stacks,
  and null guards at resolved pointer consumers;
- public and internal CARD signatures expressed as `s32`/`u32`/`BOOL` plus
  `CARDCallback`, with the fixed CARD records unchanged and C/C++ native and
  ILP32 syntax probes passing.

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
default. The tracked opt-in Darwin audit now passes the earlier platform-header,
DVD, GBI, and CARD barriers and exposes the Darwin `bcmp`/`bcopy`/`bzero`
declaration and ownership collision next.

## Native macOS host build and launch

The owning source target is `upstream/ACGC-PC-Port/pc/apple`. It is independent
of the legacy SDL/OpenGL build graph and links AppKit, Foundation, Metal, and
QuartzCore plus the dependency-free portable library. It accepts an explicit
ISO/GCM path, opens it read-only, accepts exact disc ID `GAFE01`, validates
bounded GCM/DOL/FST data, and creates only bundle-scoped Application Support and
cache directories.

```sh
./script/build_and_run.sh --headless
./script/build_and_run.sh --verify
```

Headless result: host CTest passed 2/2, the approved ignored ISO was accepted,
the DOL size was 918,720 bytes, and 10 FST files were visited. Foreground result:
the same build/tests passed; the app executable opened a normal AppKit window,
created a CAMetalLayer and native Metal device/queue/render pass, completed and
presented two requested deterministic clear frames before the five-second
deadline, emitted the exact completion record, returned exit 0, and left no
process behind. Generated build/runtime state stayed under ignored `local/`
paths; `/local/runtime/` is explicitly ignored.

This passes host build, host launch, and the first Metal clear/present fixture.
It does not yet prove representative GX semantics, an identifiable game frame,
input, audio, save/load, or playability. A targeted window-only screenshot was
attempted, but macOS `screencapture` returned the error
`could not create image from window`; no visual-capture claim is made.

## Proof ledger

| Gate | State | Evidence/limitation |
| --- | --- | --- |
| Source/revision | Passed | ISO SHA-256 plus original DOL/REL SHA-1s. |
| ac-decomp configure/extract | Passed | Configure and DTK extraction completed. |
| ac-decomp matching build | Blocked | Wine absent before Metrowerks compilation. |
| Portable arm64 library | Passed | Native + ASan/UBSan CTest, 6/6 in each lane, plus fixed-width ABI probe. |
| Supported-disc data path | Passed | Bounded GCM/DOL/FST parse and expected real REL hash. |
| Existing Windows build | Not run | Source-compatible branches and `-m32` syntax passed; no Windows execution lane. |
| Full runtime arm64 compile | In progress | Opt-in audit passes Darwin/DVD/GBI/CARD barriers and stops at the libultra/Darwin libc memory-primitive collision in `pc_audio.c`; default ILP32 guard remains. |
| macOS host build | Passed | Native AppKit target and focused CTest, 2/2. |
| macOS host launch | Passed | Direct app process accepted GAFE01, returned 0, and left no surviving process. |
| Metal clear/present | Passed | Two requested command buffers completed and presented before the bounded deadline; screenshot capture was unavailable. |
| Representative GX/game frame | Not reached | The Metal fixture is not connected to GX semantics or the reconstructed game loop. |
| Input/audio/save | Not reached | Adapters are not wired to a running game. |
| iOS simulator/device | Not reached | Begins after shared macOS proof. |

No commit, push, PR, binary publication, deployment, TestFlight upload, or App
Store action is implied by this ledger.
