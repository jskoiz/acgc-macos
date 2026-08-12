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
  GCM/DOL/FST/REL parsing, typed LP64 DVD callers backed by an owner-keyed host
  side table, fixed-layout DVD/CARD wire probes, and width-correct `emu64`
  pointer resolution with stale-reference rejection. The public CARD leaf ABI
  and its owning implementations now use the existing fixed-width `s32`/`u32`
  and `CARDCallback` contracts instead of LP64 host `long`. A host-owned boot
  source facade now accepts only the exact eight-byte `GAFE01_00` revision,
  requires one `foresta.rel.szs`, enforces DOL/REL allocation ceilings, and
  prepares the DOL plus raw or Yaz0 REL entirely in memory.
- The portable targets pass native arm64 and ASan/UBSan CTest (`13/13`). The
  suite now includes fixed-width JKR stream contracts, a native-width PC MRAM
  to fixed-width ARAM transport round trip using real arm64 heap addresses,
  runtime-built source-local GBI lists, and repeated nested traversal through
  the real `emu64_taskstart` interpreter and registry-reset boundary. A
  tracked proof command drives the boot-source facade against the approved
  local disc, validates its exact revision and bounded DOL/FST/REL metadata,
  reproduces the expected decoded REL SHA-1, and removes all temporary output.
  C and C++ CARD ABI probes also compile natively and with explicit `-m32`
  syntax checks; a JSystem probe proves that its prefixed stream enums coexist
  with the ordinary stdio `SEEK_*` and `EOF` macros.
- The opt-in Darwin compile audit now also passes the source-local field culling
  lists, the Haniwa palette list, and the JKR native ARAM transport. A fresh
  one-job audit at source commit `e64c1be` reaches step `178/4021` and stops at
  the fail-closed `_GBI_STATIC_PTR` guard for the two nested
  `post_flag_saki_common_DL` references in `src/actor/ac_mailbox.c`. The
  source-local lists already converted for PC are rebuilt at submission time;
  no pointer is truncated or replaced with a dummy value, and the default
  full-runtime ILP32 rejection remains intact.
- A native AppKit/Metal host now builds, routes its explicit read-only disc
  through the same bounded boot-source facade, accepts exact `GAFE01_00`, and
  reports the prepared 918,720-byte DOL and 6,137,393-to-15,640,056-byte Yaz0
  REL before disposing both buffers. It resolves scoped Application Support and
  cache paths, opens a normal foreground window, and exits 0 only after two
  requested Metal command buffers containing clear/triangle/present work
  complete. Native host CTest and its ASan/UBSan lane pass `4/4`. The triangle
  comes from a fixed-width, pointer-free geometry packet consumed by an
  Apple-owned Metal pipeline. This passes boot-source preflight, host launch,
  and a deterministic command-buffer-completed geometry fixture—not game
  execution, pixel readback, representative GX, or a reconstructed game frame.
  Input, audio, save/load, and playability remain open; iOS remains gated behind
  the shared macOS core and renderer.

Re-run the tracked checks from this directory:

```sh
./scripts/verify-source-input.sh
./scripts/verify-portable-core.sh
./scripts/verify-disc-core.sh
./script/build_and_run.sh --headless
./script/build_and_run.sh --verify
```

The final command runs the AppKit executable directly with a five-second
deadline, requests two Metal clear/triangle/present command buffers, checks the
renderer fixture's own completion evidence and exit status, and confirms no
process remains. It is a native geometry-fixture gate without pixel readback,
not a representative GX, reconstructed game-frame, or playability claim.

## Project record

- [Source, revision, licensing, and toolchain audit](docs/SOURCE-AUDIT.md)
- [Measured PC portability audit](docs/PORTABILITY-AUDIT.md)
- [Apple architecture and evidence-gated milestones](docs/APPLE-PORT-PLAN.md)
- [Exact bootstrap commands, results, and blockers](docs/BOOTSTRAP-EVIDENCE.md)
- [Porting charter](docs/PORTING-CHARTER.md)
