# iOS shared-boundary readiness audit

Date: 2026-08-13 HST

This was a read-only audit of the portable/core and Apple host boundaries.
The lane verified PC `f4cb491` and decomp `09ca8e8b`; the canonical PC source
has since advanced with Apple-only and fixture-only commits. No iOS source,
umbrella docs, gitlink, ISO, or proprietary asset was changed.

## Result

The dependency-free portable C slice configured, built, and passed `20/20`
CTest tests. The current repository still has no iOS target, UIKit/MetalKit
host, simulator run, or physical-device run. The existing `pc/apple` target
is a macOS AppKit/Foundation/Metal/QuartzCore host, and its lifecycle runner
still uses a synthetic/unresolved game-systems owner rather than the complete
`boot_main → mainproc → graph_proc → game_main` path.

The proven reusable boundaries are fixed-width portable C contracts, the
pointer-free GX semantic packet, bounded graph root/target capture, the
`AcgcGameRuntime` ownership shape, CPU renderer fixtures, and the logical
`PCInputSnapshot`/PAD conversion seam. They do not prove that the reconstructed
game produces a complete packet, reaches a Metal encoder, presents pixels, or
changes game state from Apple input.

## MacOS-only or still synthetic

- `pc/apple/src/main.m` is AppKit-specific and drives a deterministic triangle
  and clear/present fixture, not the game renderer.
- Input remains SDL sampling at the host boundary; no touch/controller adapter
  or game-state transition is proven.
- Audio remains SDL/host or synthetic mixer evidence; no iOS audio-session or
  human-audible game output is proven.
- Save paths remain PC/CWD-oriented; focused Save_t/GCI and sandbox fixtures
  are not an iOS persistence service.
- Timing/background/resume and shutdown evidence is synthetic or bounded host
  evidence, not iOS lifecycle proof.

## Smallest future iOS slice

After macOS game-owned Metal submission and pixel/readback proof, the next
bounded iOS lane can compile the pure-C portable/GX/graph/runtime/CPU-renderer
slice for `iphonesimulator`, then add a thin UIKit/MetalKit host that drives
`AcgcGameRuntime` through one frame, pause/resume, and disposal. Touch or
controller snapshots, an iOS audio sink, sandboxed Save_t/GCI roots, and
physical-device proof must remain separate gates. A triangle or synthetic
packet may validate the host shell only and must not be called gameplay.

## Claim matrix

| Gate | Status |
| --- | --- |
| iOS source compile | Not proven; no iOS target was configured |
| Simulator lifecycle/rendering | Not run |
| Physical device | Not run |
| iOS input/audio/save | Not proven |
| Game-owned Metal encode/present/readback/pixel | Not proven |
| Playability | Not claimed |

The exact lane scratch root was `/private/tmp/acgc-lane-ios-readiness`.
