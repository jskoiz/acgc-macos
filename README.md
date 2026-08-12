# Animal Crossing Modern Port Workspace

This umbrella repository keeps the two upstream histories separate while
recording the evidence and cross-repository plan for a modern Apple port.
Current work targets macOS first; iOS begins only after the shared 64-bit core
and Apple renderer have their own evidence.

## Layout

- `upstream/ACGC-PC-Port` - the existing PC port codebase.
- `upstream/ac-decomp` - the matching decompilation project.
- `local/roms` - local game-disc input. Its contents are ignored by Git.
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
- The complete PC runtime remains intentionally 32-bit and does not configure
  on arm64 macOS. A dependency-free endian/Yaz0 library now builds and tests
  natively as the first narrow portability slice.
- No macOS host has launched or rendered a frame. Input, audio, save/load, iOS
  simulator, and physical-device gates are all still open.

Re-run the tracked checks from this directory:

```sh
./scripts/verify-source-input.sh
./scripts/verify-portable-core.sh
```

## Project record

- [Source, revision, licensing, and toolchain audit](docs/SOURCE-AUDIT.md)
- [Measured PC portability audit](docs/PORTABILITY-AUDIT.md)
- [Apple architecture and evidence-gated milestones](docs/APPLE-PORT-PLAN.md)
- [Exact bootstrap commands, results, and blockers](docs/BOOTSTRAP-EVIDENCE.md)
- [Porting charter](docs/PORTING-CHARTER.md)
