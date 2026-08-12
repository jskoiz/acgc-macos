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

## Measured assumptions

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

`pc_gbi_runtime.c` already prototypes a 32-bit token table for some pointers.
Its fixed 8,192-entry namespace is useful evidence for the handle direction,
but it does not yet define lifetime, collision, reuse, exhaustion, or invalid
token behavior, and other paths still narrow native addresses directly.

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

## First completed slice

`pc/portable` is a dependency-free C11 library with fixed-width endian loads and
a bounded, checked Yaz0 decoder. It builds directly on native arm64 macOS, has
synthetic malformed-input tests, and is linked into the existing PC target. The
REL caller rejects short/truncated Yaz0 headers, enforces a 64 MiB output bound,
and rejects an empty REL.

This proves only a portable library and its data-format behavior. The full
runtime still fails the intentional 32-bit configure guard, and no macOS window,
Metal frame, input, audio, or save path exists yet.

The focused tests do not yet exercise `pc_disc_extract_rel`, synthetic
FST/CISO/GCM parsing, or the full PC target's link path. Existing FST-declared
input allocations and raw REL asset offsets also need explicit bounds before the
disc service can be considered hardened.
