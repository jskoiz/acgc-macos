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
  adapter; public host-native callback/pointer layouts still need classification
  before the complete runtime can be 64-bit.**
- Make TARGET_PC `s32`/`u32`, `Gwords`, and `TexRect` widths executable arm64
  contracts while preserving non-PC definitions. **Passed in C and C++ syntax
  probes.**

Exit: representative portable libraries compile and test on arm64 without SDL,
OpenGL, or a 32-bit process. This does not require launching the game.

### M2: macOS host shell — passed

- Add a normal windowed macOS host with explicit resource/user-data paths,
  exact explicit-disc validation, and clean lifecycle/exit. **Passed.**
- Add the project-local build/run entrypoint only when that host actually exists.
  **Passed with `script/build_and_run.sh`.**

Exit: host-launch evidence, with rendering still allowed to be absent.

### M3: Metal renderer

- Implement a Metal backend at the GX semantic boundary.
- Prove clear/present, then geometry, transforms, vertex formats, indexed draws,
  texture formats/palettes, sampler modes, blending/depth/alpha, representative
  TEV combinations, and EFB copy/readback behavior in small fixtures.
- Prove deferred-batch drain and frame presentation separately, and add a
  directed CI14x2 fixture before claiming complete documented texture coverage.
- Retain the current OpenGL backend as the Windows regression oracle.

Exit: captured representative renderer fixtures, then an identifiable game
frame. Neither is a playability claim.

### M4: macOS interaction and persistence

- Wire logical keyboard/controller actions, Apple audio delivery, and sandboxed
  atomic saves.
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

1. Split Darwin and Linux image-range/platform includes in the legacy host and
   add an explicit diagnostic-only arm64 compile frontier. Keep the default
   production ILP32 rejection intact while using each subsequent compiler error
   as evidence for one narrow ABI migration.
2. Remove the remaining public `DVDCommandBlock`/`DVDFileInfo` ambiguity on
   LP64: classify callbacks and owner pointers as host-native state, keep guest
   words fixed-width, and test real typed callers rather than only a shadow
   layout.
3. Define the smallest renderer-neutral frame contract needed by the AppKit
   host, then prove a Metal clear/present fixture before translating GX state.
4. Attach bounded disc/FST services and the portable registries to a boot-core
   facade, with explicit failure states, before selecting reconstructed game
   translation units for a first identifiable game-frame attempt.

Do not silently remove the default full-runtime ILP32 guard or add an iOS target.
The diagnostic arm64 build must remain opt-in until each exposed pointer/layout
contract is migrated. A Metal clear frame is renderer evidence only; it is not
a game-frame or playability claim.
