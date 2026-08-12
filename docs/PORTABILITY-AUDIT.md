# ACGC-PC-Port Portability Audit

This audit measures the pinned `4099d24` PC architecture before broad source
changes. The existing Windows/Linux behavior remains the compatibility baseline.

## Primary blocker: host pointers are part of the emulated ABI

The full CMake project rejects `CMAKE_SIZEOF_VOID_P == 8`, and
`pc/include/pc_platform.h` independently rejects non-32-bit pointers. This is
not an incidental build flag: runtime pointers are cast to `u32`, written into
display-list words, stored in fixed-layout overlays, and recovered later.
Modern macOS and iOS are 64-bit-only, so bypassing either guard would produce an
unsafe build rather than a port.

The first migration must distinguish three concepts that ILP32 currently makes
look interchangeable:

- fixed 32-bit GameCube/N64 wire addresses and command words;
- offsets or opaque handles into emulated/resource address spaces;
- native host pointers, represented by `uintptr_t` only at host boundaries.

## Measured baseline assumptions

| Area | Current evidence | Required boundary |
| --- | --- | --- |
| Scalar ABI | `u32`/`s32` aliases use `unsigned long`/`signed long` in several headers. `long` is 64-bit on arm64 macOS. | Fixed-width wire types plus compile-time size/layout assertions. |
| Display lists | `include/PR/gbi.h` and `include/libforest/gbi_extensions.h` assert pointer and `unsigned int` parity and pack pointers into 32-bit command fields. `TexRect` uses four `unsigned long` fields, becoming 32 bytes instead of its required 16 on LP64. | Fixed-width packet fields and explicit command-address/handle resolver; never truncate a host pointer. |
| JSystem/decomp | Numerous pointer-to-`u32` casts, label encodings, alignment operations, and ARAM-style addresses. | Classify each use as wire address, offset, handle, or host pointer before editing. |
| DVD file state | `pc_dvd.c` overlays a `FILE *` inside the fixed GameCube `DVDFileInfo` layout. | Host-side object table keyed by an explicit handle. |
| CARD/save state | CARD/GCI records document fixed offsets, while native `sizeof` values help derive PC on-disk layout. `CARDControl` also mixes fixed offsets with host pointers/callbacks. | Explicit byte codecs or pointer-free fixed-width wire records with `sizeof`/`offsetof` assertions; host state stays in side tables. |
| Allocators/ARAM | `TwoHeadArena.c` performs alignment arithmetic through `u32`/`int`; ARAM APIs mix offsets and reconstructed host pointers in `u32`. | `uintptr_t`/`size_t` for checked host arithmetic, plus separate bounded address-domain APIs. |
| Executable image | `pc_main.c` parses `Elf32_Ehdr`/`Elf32_Phdr` for image bounds. | Mach-O/64-bit-independent resource and symbol ownership. |
| Disc I/O | `fseek`/`ftell` and `u32` offsets are mixed; FST/DOL offsets are trusted broadly. | Checked 64-bit host file offsets with validated 32-bit disc fields. |
| Headers | `include/types.h` includes `<malloc.h>` for `TARGET_PC`, which blocks a direct macOS syntax probe. | Standard allocation headers isolated from platform-only includes. |
| Renderer | SDL creates an OpenGL 3.3 context; GL calls are concentrated in `pc_gx*.c`, texture-pack, and FixNES paths. | GX semantic frontend plus independent OpenGL and Metal backends. |
| Window/input | SDL event polling, window state, keyboard, and game-controller mappings are embedded in the host path. | Host lifecycle and input snapshots, with SDL retained for the existing host. |
| Audio/timing | SDL callback/ring-buffer behavior and performance counters/spin pacing are direct dependencies. | Game clock and audio-sink interfaces with Apple implementations. |
| Files/save | ROM, settings, texture-pack, and card paths are current-working-directory relative. | Path service with application resources, user data, cache, and atomic save roles. |
| Endian | Big-endian disc/game fields coexist with host-order runtime state and explicit swaps. | Typed fixed-width loads/stores at serialization boundaries; no bulk swap assumption. |

The PC documentation has a build-policy contradiction to resolve separately:
CMake currently uses `-O2` with `-fno-strict-aliasing` and `-fwrapv`, while
`pc/DOCUMENTATION.md` also warns that optimization must be `-O0`. Passing one
focused test lane is not evidence that either statement is universally correct.

## Current render and host shape

The documented render path is:

```text
game/N64 display lists -> emu64 -> GX semantics -> OpenGL 3.3
```

The appropriate Apple seam is after GX semantics, not a second interpretation
inside game logic. Metal must own pipeline creation, texture/sampler resources,
draw submission, render targets, readback/copy behavior, and presentation while
the current OpenGL backend remains available to prove Windows behavior.

The source trace makes the seam concrete:

- `graph_task_set00()` hands game display lists to `emu64_taskstart()`;
- emu64 interprets N64 opcodes and emits GX state, vertices, textures, TEV
  stages, matrices, copy commands, and `GXCallDisplayList` operations;
- `pc_gx.c` currently combines the GX state machine and deferred batching with
  GL buffers, uniforms, draw calls, and readback;
- `pc_gx_internal.h` mixes semantic state with `GLuint`, `GLint`, VAO/VBO/EBO,
  and shader identifiers;
- `GXCopyTex` flushes and uses `glReadPixels`, while `GXCopyDisp` prepares the
  frame and VI/SDL separately drains, swaps, polls, and paces.

A backend seam around `glDraw*` alone is therefore too low. The renderer-neutral
layer must submit immutable semantic draw packets, decoded texture/TLUT
descriptions, and first-class EFB-copy operations. Presentation stays in the
host interface. The current three-stage TEV shader limit is an observed OpenGL
backend constraint, not a portable GX contract. Documentation also claims
CI14x2 texture support that is not visible in the current decoder dispatch;
that format remains an explicit fixture gap.

`pc_gbi_runtime.c` now routes odd, reserved-prefix, and non-32-bit native
pointers through a generational 8,192-entry reference registry. Status-based
unpacking rejects stale or malformed handles, and the current synchronous
interpreter resets the registry after a submitted task is consumed. The finite
capacity, 15-bit generation wrap, single-thread ownership, and synchronous
lifetime are explicit current-runtime limits. `emu64::seg2k0()` now returns
`uintptr_t` on TARGET_PC, dynamic display-list return addresses are native
pointers, image command words remain `u32` until resolution, and invalid
reserved references are guarded before the audited pointer consumers. Static
display-list pointer initializers and other pointer/`u32` paths still require
classification and migration.

SDL responsibilities must be split rather than globally removed:

- presentation/window lifecycle;
- keyboard/controller input snapshot;
- monotonic clock and frame pacing;
- audio sink/callback;
- filesystem/save directories.

The current audio adapter is a 32 kHz stereo producer/ring buffer feeding an SDL
callback. The shared contract should preserve mixer-rate frames; Apple hosts own
device format, resampling, interruptions, and callback scheduling.

The shared game core consumes these narrow services. The macOS host supplies
Apple implementations first; the later iOS host adds UIKit lifecycle and
touch/controller mapping without forking game logic.

## Completed portable-foundation slices

The reviewed `pc/portable` library and focused C/C++ probes now exercise six
dependency-light boundaries:

- fixed-width endian loads and a bounded Yaz0 decoder;
- checked `uintptr_t` alignment/range operations used by TwoHeadArena's
  downward allocation path;
- a generational 32-bit GBI reference registry plus a status-based runtime
  wrapper that round-trips native pointers above 4 GiB and rejects stale or
  malformed reserved handles;
- callback-driven, bounded GCM/DOL/FST parsing and raw/Yaz0 REL extraction;
- owner-keyed DVD host state, fixed DVD/CARD wire probes, and typed public DVD
  ABI behavior on both LP64 and ILP32;
- fixed-width public/internal CARD signatures and callbacks without changing
  the fixed CARD file/directory layouts.

Native arm64 and ASan/UBSan CTest pass all six registered test executables. The
approved ignored disc also passes the tracked bounded parser and reproduces the
expected REL SHA-1. FST-declared entry counts no longer cause proportional
allocation, DOL sections inside the header are rejected, invalid FST types and
parent/subtree relationships fail closed, and the PC adapter rejects capacity
or path truncation rather than reporting an incomplete table as success.

The real GBI wrapper now distinguishes a normal word, a resolved reference, and
an invalid reserved reference. Its registry is reset only after the external
`emu64_taskstart()` call returns, when that synchronous interpreter has consumed
the submitted command words. A direct `emu64::seg2k0()` test proves a live
address above 4 GiB and stale/malformed failure. This is a bounded
current-runtime contract, not a future asynchronous renderer lifetime design.

This evidence still does not make the full runtime 64-bit. The CMake and header
guards remain intentional. The opt-in Darwin audit has passed the earlier
platform-image, TwoHeadArena, checked-CISO, public-DVD, and first GBI
pointer-width barriers. It now also compiles the corrected CARD leaf/owning ABI
and stops in `pc_audio.c`, where project `bcmp`/`bcopy`/`bzero` declarations
conflict with Darwin libc declarations and fortified macros. CARD host state,
static display-list relocation, and further pointer domains remain open.

A separate native AppKit host now validates the supported disc and proves two
completed command buffers containing CAMetalLayer clear, a deterministic
fixed-width colored-triangle packet, and presentation submission. Metal objects
remain Apple-owned and no native pointer enters the packet. This is not pixel
readback and is not connected to representative GX semantics or the
reconstructed game loop; input, audio, save/load, and game-frame proof do not
exist yet.

The real-disc proof covers the supported plain ISO/GCM data path. CISO geometry
and sparse/physical bounds are synthetic-test evidence; full-PC linking, game
launch, and gameplay remain unproved.
