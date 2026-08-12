# Animal Crossing Modern Port Workspace

This umbrella repository keeps the two upstream histories separate while
recording the evidence and cross-repository plan for a modern Apple port.
Current work targets macOS first; iOS begins only after the shared 64-bit core
and Apple renderer have their own evidence.

## Layout

- `upstream/ACGC-PC-Port` - the existing PC port codebase.
- `upstream/ac-decomp` - the matching decompilation project.
- `local/roms` - local game-disc input. Its contents are ignored by Git.
- `script/build_and_run.sh` - the single native macOS build/run/verify entrypoint.
- `scripts` - reproducible, non-distributing bootstrap checks.
- `docs` - source audit, measured portability risks, architecture, and gates.

The ISO is local development input only. Do not commit, publish, upload, or
redistribute it or extracted proprietary assets.

## Current evidence

- Both submodules and the local input identify the supported `GAFE01_00`
  revision. The expected original DOL and REL hashes match.
- The documented `ac-decomp` macOS configuration and extraction path runs until
  the first Metrowerks compiler command, where the absent Wine runtime is the
  exact blocker.
- The complete PC runtime remains intentionally guarded as a 32-bit target. The
  reviewed portable foundation now includes fixed-width PC scalars and GX word
  records, checked native-address and arena free-space arithmetic, an opaque
  generational GBI reference registry, checked 64-bit CISO reads, bounded
  GCM/DOL/FST/REL parsing, and a DVD host-state side table with fixed-layout
  DVD/CARD probes.
- The portable targets pass native arm64 and ASan/UBSan CTest (`3/3`). A tracked
  proof command validates the approved local disc, visits its FST, decodes its
  Yaz0 REL, reproduces the expected SHA-1, and removes all temporary output.
- A native AppKit host now builds, validates the exact `GAFE01` disc through the
  portable reader, resolves scoped Application Support and cache paths, opens a
  normal foreground window, and passes an observed timed-exit launch check. It
  is a host shell, not the reconstructed game: no rendered game frame, input,
  audio, or save/load gate has passed. iOS work remains gated behind the shared
  macOS runtime and renderer.

Re-run the tracked checks from this directory:

```sh
./scripts/verify-source-input.sh
./scripts/verify-portable-core.sh
./scripts/verify-disc-core.sh
./script/build_and_run.sh --headless
./script/build_and_run.sh --verify
```

The final command opens the AppKit application for two seconds and proves that
its process was observed and exited cleanly. It is launch evidence only; it does
not claim a rendered game frame or playability.

## Project record

- [Source, revision, licensing, and toolchain audit](docs/SOURCE-AUDIT.md)
- [Measured PC portability audit](docs/PORTABILITY-AUDIT.md)
- [Apple architecture and evidence-gated milestones](docs/APPLE-PORT-PLAN.md)
- [Exact bootstrap commands, results, and blockers](docs/BOOTSTRAP-EVIDENCE.md)
- [Porting charter](docs/PORTING-CHARTER.md)
