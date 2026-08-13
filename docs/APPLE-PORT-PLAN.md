# Apple Port Architecture and Milestones

## End-state architecture

```text
                         supported GAFE01_00 data
                                   |
                    checked disc and format services
                                   |
          game logic + GX semantic frontend + address resolver
                    /                         \
       current SDL/GL host                Apple shared host
                                                 |
                             +-------------------+-------------------+
                             |                                       |
                    macOS lifecycle                         iOS lifecycle
                             |                                       |
                             +---------- Metal backend --------------+
```

The shared layer owns deterministic game behavior, fixed-format parsing,
emulated-address resolution, renderer-neutral GX state/commands, mixer output,
input actions, save serialization, and monotonic game time. It must not import
AppKit, UIKit, MetalKit, SDL, OpenGL, or current-working-directory policy.

Platform hosts own process/application lifecycle, display and presentation,
physical input sampling, audio-device delivery, filesystem roots, clocks, and
foreground/background transitions. macOS is the proving host. iOS reuses the
same core and Metal renderer after the macOS gates pass.

## Stable interfaces

1. **Address resolver:** maps explicit 32-bit guest addresses or resource
   handles to validated host spans. No host pointer is serialized into a guest
   command word.
2. **Data source:** bounded reads by 64-bit host offset, with GCM/FST fields
   decoded as checked 32-bit big-endian values.
3. **Renderer:** consumes GX semantic state and draw submissions; manages
   textures, samplers, pipelines, render targets, EFB operations, and presents.
4. **Input:** immutable per-frame logical actions derived from keyboard,
   controller, or touch sources.
5. **Audio sink:** accepts mixer-format frames while the host owns device format,
   callback scheduling, interruption, and resampling policy.
6. **Filesystem/save:** resolves immutable game input separately from user data,
   cache, and logs; save commits are atomic while the on-disc/card format stays
   deterministic.
7. **Clock/lifecycle:** exposes monotonic time and explicit pause, background,
   resume, memory-pressure, and termination events.

Renderer packets use fixed-width GX enums and guest addresses, `size_t` only
for validated host buffer lengths, and opaque backend-owned texture/pipeline
handles. They contain no GL identifiers, Metal objects, SDL pointers, AppKit or
UIKit objects, or native host pointers encoded as guest words. Required backend
operations are begin/end frame, upload/update texture, submit semantic draw,
copy EFB, flush, and destroy. Presentation is deliberately a host operation.

## Milestone sequence

### M0: source and toolchain — evidenced

- Pin both upstream commits and verify the local ignored ISO hash.
- Prove `GAFE01_00` via original DOL/REL hashes.
- Reproduce `ac-decomp` until the exact missing-Wine blocker.

### M1: 64-bit portable foundation — current bounded slice passed

- Land the fixed-width endian/Yaz0 library and its focused tests. **Passed.**
- Add checked native-address arithmetic at one real allocator boundary.
  **Passed for TwoHeadArena tail allocation and free-space accounting.**
- Introduce an opaque guest-command reference registry with explicit stale,
  invalid, exhaustion, and post-consumption lifetime behavior. **Passed for the
  current synchronous GBI runtime path.**
- Move checked GCM/FST/DOL/REL access behind a bounded data-source interface.
  **Passed for synthetic readers and the supported local ISO/GCM input.**
- Add a checked 64-bit CISO map/read path with sparse-block and physical-extent
  validation while preserving plain ISO/GCM behavior. **Passed in portable
  tests and the existing PC disc adapter.**
- Move current DVD `FILE *` state behind opaque generational host handles and
  assert the documented DVD/CARD wire layouts. **Passed for the current PC
  adapter and typed public `DVDFileInfo`/`DVDCommandBlock` callers; host state is
  keyed by object identity and no longer occupies `cb.addr`.** The host CARD
  transfer boundary now has a temporary-directory roundtrip test covering
  create, offset read/write, reopen, invalid ranges, and path safety; this is
  not yet game-level Save_t/GCI persistence.
- Make TARGET_PC `s32`/`u32`, `Gwords`, and `TexRect` widths executable arm64
  contracts while preserving non-PC definitions. **Passed in C and C++ syntax
  probes.**
- Split the Darwin executable-image probe from Linux ELF handling and expose an
  opt-in arm64 compile audit without weakening the default ILP32 guard.
  **Passed; the audit is diagnostic only.**
- Widen `emu64::seg2k0()` and dynamic display-list consumers only at resolved
  host-pointer boundaries, while keeping GBI words and opaque references
  32-bit. **Passed for focused live-above-4-GiB and stale/malformed-reference
  tests; static display-list relocation remains a separate frontier.**
- Replace legacy CARD public/internal `long` scalars and callback spellings with
  the existing fixed-width contract. **Passed in native C/C++ probes, explicit
  ILP32 syntax probes, and the opt-in Darwin compile audit.**
- Assign legacy memory primitives to one platform owner. **Passed for native
  POSIX libc plus signature-compatible Windows PC declarations/definitions; no
  Windows execution claim.**

Exit: representative portable libraries compile and test on arm64 without SDL,
OpenGL, or a 32-bit process. This does not require launching the game.

### M2: macOS host shell — passed

- Add a normal windowed macOS host with explicit resource/user-data paths,
  exact explicit-disc validation, and clean lifecycle/exit. **Passed.**
- Add the project-local build/run entrypoint only when that host actually exists.
  **Passed with `script/build_and_run.sh`.**

Exit: host-launch evidence, with rendering still allowed to be absent.

### M3: Metal renderer — clear/present and geometry fixtures passed

- Create a native CAMetalLayer, device, queue, command buffer, render pass, and
  presentation loop with bounded completion/failure evidence. **Passed for a
  deterministic clear color; this is host plumbing, not the GX backend.**
- Implement the renderer-neutral contract and Metal backend at the GX semantic
  boundary.
- Prove clear/present, then geometry, transforms, vertex formats, indexed draws,
  texture formats/palettes, sampler modes, blending/depth/alpha, representative
  TEV combinations, and EFB copy/readback behavior in small fixtures.
  **Clear/present and one fixed-width non-indexed colored-triangle packet now
  have command-buffer completion evidence. Pixel readback, GX-derived geometry,
  transforms, and all later fixture classes remain open.**
- Prove deferred-batch drain and frame presentation separately, and add a
  directed CI14x2 fixture before claiming complete documented texture coverage.
- Retain the current OpenGL backend as the Windows regression oracle.

Exit: captured representative renderer fixtures, then an identifiable game
frame. Neither is a playability claim.

### M4: macOS interaction and persistence

- Wire logical keyboard/controller actions, the reconstructed mixer to Apple
  audio delivery, and sandboxed atomic saves. The SDL/CoreAudio device boundary
  is already measured (32 kHz S16 stereo, 512-sample callbacks, zero
  underruns/overruns), but audible game-mixer correctness is still open. The
  umbrella-owned filesystem adapter now has a standalone macOS role-root and
  atomic opaque-payload fixture, including durability fences and corruption
  rejection; this does not yet connect Save_t/GCI bytes to the game.
- Prove input, audio, and save/load in separate runs before a bounded human play
  path and performance/memory measurements.

### M5: iOS host

- Add UIKit/scene lifecycle, touch overlay and controller support, sandboxed
  files, audio-session interruptions, background/resume, and memory pressure.
- Verify Simulator first, then a separately authorized physical device.

Exit: simulator and device evidence remain distinct. Signing, TestFlight,
distribution, and App Store work require fresh authorization.

## Next bounded implementation lanes

Continue in separately reviewable ACGC-PC-Port branches:

1. Trace the post-loader `game_main`/`graph_proc` fault now exposed at
   `game.c:154`; the focused DVD-tail semantics fix already lets the 19-byte
   `COPYDATE` satisfy the GameCube 32-byte transfer rule and reaches archive
   loading.
2. Capture the first renderer-neutral game submission after `emu64` has
   produced GX semantic state. Carry fixed-width geometry, transforms, and
   material/texture state; do not substitute the existing triangle fixture for
   a game frame.
3. Introduce an injectable macOS input snapshot at the SDL pad boundary and
   prove keyboard/controller state changes without claiming game interaction.
4. Connect the real mixer and Save_t/GCI serialization to the already-proven
   audio/CARD host boundaries, with separate audible-output and restart
   roundtrip evidence.

Do not silently remove the default full-runtime ILP32 guard or add an iOS target.
The diagnostic arm64 build must remain opt-in until each exposed pointer/layout
contract is migrated. The completed Metal clear frame is renderer-fixture
evidence only; it is not a GX, game-frame, or playability claim.
