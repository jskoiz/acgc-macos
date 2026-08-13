# macOS lifecycle lane evidence

This lane is deliberately a host-contract probe, not a claim that the
reconstructed game runtime has been wired to macOS lifecycle services.

## Revision and checkout boundary

The umbrella checkout for this lane is branch `c1/lane-timing-lifecycle` at
`82732fe` (`Record Apple runtime boundary evidence`). Its recorded
`upstream/ACGC-PC-Port` gitlink is `3a6582d`. The umbrella submodules are
intentionally uninitialized in this worktree; no source checkout or full
runtime link is required for the probe.

The current source-side reference was verified read-only in the separate
upstream checkout at `4f77dab` (`Allow sector-tail reads for PC DVD files`).
That source commit is not promoted into the umbrella pointer by this lane.
The DVD/file-loader wait and the separate DVD/graph crash remain outside this
evidence.

## Current host boundary

The source-side Apple host at `4f77dab` provides useful ownership and cleanup
seams, but it does not yet provide the lifecycle contract this lane needs:

- `pc/apple/src/main.m` drives the geometry fixture with an `NSTimer` at
  `1.0 / 60.0`, rather than an injected monotonic clock and explicit VI/retrace
  scheduler.
- `applicationWillTerminate:` invalidates the fixture timers and releases
  Metal objects, but no worker-thread stop/join or focus-loss pause/resume path
  is present.
- `acgc_game_runtime_step` is a synchronous nonblocking callback seam. The
  current app still calls an explicitly unresolved game-systems stub; it is
  not a reconstructed game loop or a worker-backed runtime.

These observations are source-boundary findings only. They do not turn the
synthetic result below into host, rendered-frame, input, audio, save/load, or
playability proof.

## Bounded synthetic probe

Run:

```sh
./scripts/verify-lifecycle.sh
```

The script compiles only
`scripts/probes/verify_lifecycle_contract.c` with Apple Clang and writes the
ignored binary/log to `/private/tmp/acgc-lane-lifecycle-build` (override with
`ACGC_LIFECYCLE_BUILD_DIR`). It does not initialize either submodule, invoke
CMake, link the host, or start the 4,000-object runtime build.

The probe covers four narrow contracts:

1. `CLOCK_MONOTONIC` reads are nondecreasing, and an injected synthetic clock
   rejects reverse time.
2. A fixed-phase 60 Hz VI/retrace schedule emits only while focused. Focus
   loss suppresses ticks; resume re-anchors the next deadline rather than
   replaying the paused interval as a catch-up burst.
3. A condition-variable worker receives a stop request and is joined before
   the lifecycle records termination completion.
4. A fixed event sequence is run twice. The exact event trace and FNV-1a hash
   must match, termination is idempotent, and no retrace is emitted after
   termination.

The deterministic sequence is: five active retraces across two focused
intervals, focus loss, focus gain, a termination request, worker join, and
termination completion. This is executable contract evidence, not proof that
the existing AppKit host currently implements those semantics.

On 2026-08-12 the strict-warning probe emitted `events=9 hash=6e4a5d94e1b0dd80`.
The same result held across five immediate repetitions,
and an AddressSanitizer/UndefinedBehaviorSanitizer build passed the same
sequence. The generated binaries and logs remain under the isolated `/private/tmp`
directory and are not tracked.

## Gate result

| Gate | Result | Boundary |
| --- | --- | --- |
| Monotonic clock and reverse-time rejection | Passed | Synthetic probe only |
| VI/retrace pacing | Passed | Synthetic fixed-phase 60 Hz schedule only |
| Focus loss and resume | Passed | Synthetic pause/re-anchor behavior only |
| Worker stop and join | Passed | One synthetic condition-variable worker only |
| Deterministic termination trace | Passed | Repeated synthetic sequence only |
| Existing macOS host integration | Not reached | Current host has the gaps listed above; no host build was started |
| Reconstructed game frame / DVD loader | Not reached | Separate runtime and DVD/graph boundaries |

The probe can be used as a focused contract gate for a later owning-submodule
implementation. It must not be reported as host lifecycle, game-loop,
rendered-frame, or playability acceptance.
