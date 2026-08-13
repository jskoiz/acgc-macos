# iOS shared-boundary readiness: architecture and evidence lane

Date: 2026-08-12
Scope: read-only architecture/evidence crosswalk; no iOS implementation, Xcode
project, simulator, device, signing, deployment, or hosted CI.  This artifact
is a handoff for the later macOS host and iOS lanes.  It does not promote an
umbrella gitlink or claim a playable port.

## Revision and workspace boundary

The requested anchors were verified as Git commits:

| Repository | Requested reference | Verified working reference | State used by this lane |
| --- | --- | --- | --- |
| Umbrella | `04d21b8` (`Correct cleanup worktree count`) | `1456933eaa1efc34f91adff0fc1dacfb905b2459` (`Initialize modern Animal Crossing port workspace`) | This isolated worktree, branch `c1/ios-shared-boundary-readiness`; the requested umbrella anchor is an object but is not an ancestor of this detached-base snapshot. |
| ACGC-PC-Port | `724a18d` | `724a18ddcebec039ec393b98e4f0c37fda879d66` | `c1/macos-host-launch`, clean, read-only source checkout. |
| ac-decomp | `09ca8e8b` | `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c` | `master`, clean and equal to `origin/master`, read-only source checkout. |

The umbrella worktree was clean before this lane and both source checkouts were
clean before and after the probes.  No source file in either upstream was
edited.  No umbrella submodule pointer was changed.  User-owned ISO or
extracted game assets were not accessed, copied, printed, committed, uploaded,
published, or deleted.

## Boundary map

| Concern | Current portable or host seam | What is actually proven | What remains open before iOS |
| --- | --- | --- | --- |
| Portable game/data core | `pc/portable` builds `acgc_portable` from checked address arithmetic, DVD host state, GBI reference registry, bounded disc/GCM/DOL/FST readers, boot-source preparation, and Yaz0 (`pc/portable/CMakeLists.txt:8-15`). | The library and its fixed-width/ABI/reader/GBI fixtures compile and pass on arm64 without SDL, OpenGL, AppKit, UIKit, Metal, or a 32-bit process. | The reconstructed boot, graph, game, GX frontend, mixer, card/save orchestration, and lifecycle still need to consume these services through explicit shared interfaces. The portable CMake also performs an SDL header-path lookup for one Apple-only traversal test (`pc/portable/CMakeLists.txt:321-361`); the library itself does not link SDL. |
| Apple host | `pc/apple` owns AppKit/Foundation/QuartzCore/Metal framework discovery and the native host CLI/bundle (`pc/apple/CMakeLists.txt:3-25,109-137`). `host.c` accepts one explicit read-only disc path and prepares bounded disc images (`pc/apple/src/host.c:350-510`). | macOS host configuration, compile, host-core tests, game-runtime seam tests, and deterministic self-test pass. The CLI is an arm64 Mach-O. | The host must own a real shared game loop, Apple filesystem/save roots, input, audio delivery, monotonic clock, pause/background/resume, memory pressure, and termination semantics. |
| Metal renderer | Renderer-neutral fixed-width geometry and GX semantic packet/consumer libraries are separate from the host (`pc/apple/CMakeLists.txt:27-81`). The GUI fixture creates `MTLCreateSystemDefaultDevice`, a `CAMetalLayer`, command queue, pipeline, clear pass, triangle, present, and completion accounting (`pc/apple/src/main.m:219-317,413-537`). | CPU geometry/Metal-state/packet contracts pass; the host self-test passes. The native Metal tests explicitly return 77 when no device is available, and this machine produced the declared no-device skips. | A game-owned GX semantic packet must reach Metal, with transforms, textures/TLUTs, TEV, depth/blend, EFB copy/readback, deferred drain, and a captured rendered pixel/frame. The current fixture is not the game renderer. |
| Input | The legacy PC path samples SDL keyboard/mouse/controller state in `PADRead` and converts it into an 8-byte fixed-width `PCInputSnapshot` (`pc/src/pc_pad.c:55-165`, `pc/include/pc_input_snapshot.h:13-65`). | The fixed-width snapshot and PAD handoff compile/test as a host-independent seam. | There is no Apple input adapter and no proof that a physical/keyboard/touch action changes reconstructed game state. The later host should inject immutable logical actions per frame and keep SDL-specific sampling outside the shared core. |
| Audio | The legacy PC path owns a 32 kHz S16 stereo SDL device, 512-sample callback, producer thread, SPSC ring, DMA copy, and shutdown (`pc/src/pc_audio.c:16-29,54-136,138-203,260-270`). | Portable and Apple contract tests do not exercise the real mixer or an Apple audio device. No audible-output claim is made here. | Define a mixer-rate audio sink, connect reconstructed NEOS/JAUDIO output, and prove device delivery, interruption handling, nonzero PCM, underrun behavior, and audible output on macOS before iOS. |
| Filesystem/save | The legacy CARD/GCI path uses CWD-relative `save/card_a`, `save/card_b`, temp files, backups, and rename recovery (`pc/src/pc_m_card.c:46-64,203-237,409-445,712-777`). Settings/keybindings are also CWD-relative (`pc/src/pc_settings.c:25,152-175,360-396`; `pc/src/pc_keybindings.c:260-333`). | Portable disc/input parsing and focused host-core path validation pass. This is not game-level Save_t/GCI restart proof. | `pc/apple/src/main.m` creates scoped Application Support/Caches directories (`:86-115`) but the current runtime does not route card/settings saves there. Add a role-root service, atomic commit, corruption rejection, and restart roundtrip before iOS. |
| Timing | `pc_os.c` derives GC time from SDL performance counters and `pc_vi.c` drains GX, swaps SDL buffers, polls events, and paces around 60 Hz (`pc/src/pc_os.c:16-42,234-283,331-369`; `pc/src/pc_vi.c:21-140`). | The current focused tests compile these boundaries; no live Apple game-loop timing or lifecycle proof was run. | Replace host-global SDL timing with an injectable monotonic game clock/retrace scheduler. Prove deterministic frame cadence, focus loss/resume, and no catch-up burst in the actual host. |
| Lifecycle | AppKit fixture timers use `NSTimer` at 60 Hz and stop/release fixture Metal objects (`pc/apple/src/main.m:372-411,539-554`). | Host fixture cleanup and the synchronous runtime seam are tested. | The real game needs explicit initialize/step/pause/background/resume/memory-pressure/terminate ordering, worker stop/join if retained, and idempotent shutdown. iOS scene lifecycle must be a later adapter, not a second game core. |

## Crosswalk: ac-decomp entry and game lifecycle

The decomp’s platform-neutral sequence is materially deeper than the current
Apple host seam:

```text
boot_main (src/static/boot.c:477-524)
  -> OSInit / arena / JW initialization / menu and audio setup
  -> disc-backed COPYDATE, string table, and foresta REL loading
  -> HotStartEntry loop (src/static/boot.c:629-671)
       -> ac_entry (src/main.c:79-92; renamed from main by pc/CMakeLists.txt:560-564)
            -> mainproc
                 -> card, IRQ manager, pad manager, graph thread
                 -> JW/game/frame services and IRQ message wait
                 -> game_main: draw, time, exec, BGM, movement, frame counter
```

Specific platform responsibilities exposed by the decomp are:

* `src/static/boot.c:523-598` initializes console time, reset handling, the
  arena, JFramework, and fault clients; `:629-660` performs sound/menu/REL
  setup and invokes the hot-start function chain.
* `src/main.c:31-77` creates the IRQ/pad/graph structures, starts the graph
  thread, initializes JSystem/Famicom services, then waits on IRQ messages.
* `src/padmgr.c:214-266,325-364` converts retrace messages into controller
  reads, connection/rumble work, and a retrace-driven manager loop.
* `src/game.c:107-151,202-236` reads pad state and runs the per-frame draw,
  time, game execution, BGM, movement, and cleanup path.

The PC CMake split confirms that the full executable renames decomp `main`
functions (`pc/CMakeLists.txt:560-570`) and supplies a separate `pc_main.c`
plus `pc_*` host replacements (`pc/CMakeLists.txt:483-517`). The Apple host
does not currently link the reconstructed `boot_main`/`ac_entry` path. Instead,
its `run_game_runtime_lifecycle` uses a deliberately named unresolved stub:

* `pc/apple/src/main.m:646-697` says the stub is not reconstructed boot, main,
  graph, or renderer initialization; one step emits no submission.
* `pc/apple/src/main.m:699-753` proves only
  `create -> initialize -> one nonblocking step -> dispose` and explicitly
  declines a reconstructed game-rendering claim.

This is the principal architecture blocker. The right next seam is an actual
platform-neutral game-runtime owner that consumes the bounded data, input,
renderer, audio, save, clock, and lifecycle services. The Apple host should own
Metal presentation and platform events around that owner; it should not replace
the game loop with the current triangle or unresolved stub.

## Static boundary inventory

The full runtime remains intentionally separate from the Apple-safe surface:

* `pc/CMakeLists.txt:28-40` rejects an 8-byte pointer process unless the
  opt-in `PC_DARWIN_COMPILE_AUDIT` is enabled, and labels that mode a compile
  frontier rather than a 64-bit runtime port.
* `pc/CMakeLists.txt:483-517` puts SDL window/input/timing, OpenGL GX, DVD,
  VI, audio, card, settings, keybindings, assets, and disc adapters in the
  full PC source set. `:627-641` links `ac_pc` to the portable library, glad,
  SDL2, OpenGL, and platform libraries.
* `pc/apple/CMakeLists.txt:20-25` intentionally consumes only the portable
  subproject; its native targets are the host shell, renderer fixtures, packet
  consumer, and runtime seam rather than the full `ac_pc` source set.
* `pc/include/pc_platform.h:8-15` independently preserves the legacy pointer
  width guard outside the CMake policy.
* SDL responsibilities remain embedded in the legacy host: `pc_main.c` owns
  SDL/OpenGL window creation and event polling (`:49-246`), `pc_vi.c` owns
  swap/poll/pacing, `pc_pad.c` owns physical input, `pc_audio.c` owns the audio
  callback/thread, and `pc_os.c` owns SDL timing/sleep.

The `pc/portable` and `pc/apple` public headers provide a usable direction for
the successor lane: bounded logical disc readers (`pc/portable/include/acgc/disc.h`),
owned DOL/REL boot images (`pc/portable/include/acgc/boot_source.h`),
renderer-neutral geometry (`pc/apple/include/acgc/renderer_geometry.h`),
fixed-width Metal packet consumption (`pc/apple/include/acgc/metal_packet_consumer.h`),
and an opaque game-runtime ownership/callback shape
(`pc/apple/include/acgc/game_runtime.h`). They do not yet connect the decomp’s
`mainproc`/graph/game path.

## Focused probes and exact results

All generated builds and logs were isolated under this unique lane root:

```text
/private/tmp/acgc-lane-ios-boundary/
```

No command below reads user-owned game assets.

### Portable and Apple configuration/build/test

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-lane-ios-boundary/portable-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-lane-ios-boundary/portable-build --parallel 2
ctest --test-dir /private/tmp/acgc-lane-ios-boundary/portable-build \
  --output-on-failure -j2
```

Result: AppleClang 21 configured and built successfully; **18/18 tests passed**.
The produced test binary is a Mach-O 64-bit arm64 executable.

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc/apple \
  -B /private/tmp/acgc-lane-ios-boundary/apple-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-lane-ios-boundary/apple-build --parallel 2
ctest --test-dir /private/tmp/acgc-lane-ios-boundary/apple-build \
  --output-on-failure -j2
/private/tmp/acgc-lane-ios-boundary/apple-build/acgc_macos_native_host_cli --self-test
```

Result: configuration/build succeeded; **10/12 Apple tests passed**, with the
two Metal-device tests declared skipped by CTest. Direct output was:

```text
Metal state fixture: CPU contract PASS; SKIP (no macOS Metal device available)
Metal packet consumer: CPU packet/state/fixture contract PASS; SKIP (no macOS Metal device available)
host self-test: PASS (options, exact GAFE01_00, bounded raw/Yaz0 REL, rejection paths)
```

This is CPU-contract and native-host compile evidence. It is not a live Metal
device, rendered-pixel, input, audio, save, or game-playability result.

### Sanitizer probes

The portable and Apple focused suites were configured with
`-fsanitize=address,undefined -fno-omit-frame-pointer` for C, C++, and (where
applicable) Objective-C, with matching executable linker flags. The commands
were the corresponding `cmake -S/-B`, `cmake --build`, and `ctest` invocations
using these isolated build directories:

```text
/private/tmp/acgc-lane-ios-boundary/portable-asan-build
/private/tmp/acgc-lane-ios-boundary/apple-asan-build
```

Result: **portable 18/18 passed; Apple 10/12 passed with the same two declared
Metal-device skips; no ASan or UBSan report**. Build logs are retained only in
the ignored lane root, including `logs/portable-asan-build.log` and
`logs/apple-asan-build.log`.

### Full-runtime guard, serialized compile-audit link, and static LLDB

Default full-runtime configuration was intentionally probed:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-ios-boundary/full-default-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug
```

Result: configuration failed closed at `pc/CMakeLists.txt:29` with the
pointer-to-`u32` 32-bit-process guard.

The opt-in diagnostic configuration and serialized full link were then run:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-ios-boundary/full-darwin-audit-build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DPC_DARWIN_COMPILE_AUDIT=ON
cmake --build /private/tmp/acgc-lane-ios-boundary/full-darwin-audit-build \
  --target ac_pc --parallel 1 \
  > /private/tmp/acgc-lane-ios-boundary/logs/full-ac_pc-darwin-audit.log 2>&1
file /private/tmp/acgc-lane-ios-boundary/full-darwin-audit-build/bin/AnimalCrossing
```

Result: configuration succeeded with the explicit compile-frontier warning;
the serialized build completed **4,011/4,011** and produced a Mach-O 64-bit
arm64 `AnimalCrossing`. The log contains existing AppleClang/header warnings
and one linker section-alignment warning; the link exit code was zero. This is
not a runtime launch or playability result, and the default 32-bit guard was
not removed.

Static symbol loading was checked without launching a process:

```sh
lldb --batch \
  -o 'settings set target.load-script-from-symbol-file false' \
  -o 'target create /private/tmp/acgc-lane-ios-boundary/full-darwin-audit-build/bin/AnimalCrossing' \
  -o 'image lookup -n main' \
  -o 'image lookup -n ac_entry' \
  -o 'quit'
```

Result: LLDB loaded the arm64 executable and resolved `main` at
`pc_main.c:436` and `ac_entry` at decomp `main.c:136`. No process was launched,
no breakpoint was run, and no runtime state was inferred.

## macOS-before-iOS gate

The current lane **does not unblock iOS implementation yet**. The exact
remaining macOS evidence gates are:

1. Reconnect the decomp `boot_main -> HotStartEntry -> ac_entry -> mainproc ->
   graph/pad/game` sequence to an explicit platform-neutral runtime owner.
2. Produce a real game-owned renderer-neutral submission, route it through a
   native Metal device, and capture completed command buffers plus actual pixel
   readback. The deterministic triangle is only a host fixture.
3. Prove injected logical input changes running game state, separately from the
   fixed-width snapshot unit test.
4. Connect the reconstructed mixer to an Apple audio sink and prove nonzero
   PCM, device delivery, interruption/stop behavior, and audible output.
5. Route Save_t/GCI through scoped application data with atomic/corruption-safe
   writes and prove a restart roundtrip.
6. Prove actual macOS pause/background/resume, memory pressure, and clean
   termination ordering for the running game, not only the synthetic runtime
   seam and fixture timer cleanup.

Only after those macOS gates are separately evidenced should the successor add
the iOS host adapter: UIKit/scene lifecycle, touch/controller mapping,
application sandbox paths, audio-session interruption handling, background/
resume, and memory pressure. Simulator and physical-device evidence must stay
separate; this lane contains neither.

## Handoff and successor

The integration owner can review this artifact and merge/cherry-pick the
umbrella documentation onto the owning integration line without changing the
upstream source branches or gitlinks. The next source-edit lane should use an
explicit owning-submodule `c1/` branch, preserve the default Windows/full-PC
behavior, and land one reviewable boundary at a time. It must keep build,
launch, rendered-frame, pixel, input, audio, save, lifecycle, simulator, and
device claims separate.

Evidence boundary: this lane proves architecture, source ownership, arm64
portable/Apple compile and focused tests, sanitizer cleanliness for those
tests, a serialized opt-in full arm64 compile/link, and static symbol loading.
It does not prove a launched game, a rendered game frame, a pixel, gameplay,
physical input, audio output, persistent save/load, iOS, Simulator, or device
acceptance.
