# Cumulative snapshot and Apple CPU-boundary audit at `62c810e5b`

## Scope and provenance

Lane 238 was the independent read-only cumulative snapshot and Apple
CPU-boundary audit registered against the exact paused canonical tip. It
completed before the 2026-08-15 pause and returned three independent `BLOCK`
verdicts.

- audit task: `01a00563-bd2c-7cf0-aa82-d5773a4ccdae` (reused project-owned
  M3 Max task);
- PC source tip: `62c810e5b6ee7710b2904ef4733ef95a6909fe1f` on
  `c1/macos-host-launch`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- verified source-only bundle SHA-256:
  `7e8c25348f11fdb124e8c5ad75d78b0b4de1d139cd37e435ac535f303e2617e5`;
- detached read-only source root:
  `/private/tmp/acgc-lane-238-cumulative-apple-audit-m3` (no branch, no owned
  files, no build/test/log roots, no runtime authority).

No ISO, extracted assets, keys, or proprietary game data were transferred.

## Verdicts

The audit judged its three gates separately and returned `BLOCK` for each:

1. **Cumulative CPU assembler — BLOCK.** No all-or-nothing assembler exists
   that captures every section at the committed-vertex boundary, validates
   cross-section dependencies and resource leases, and publishes exactly once
   or not at all.
2. **Typed Apple CPU consumer — BLOCK.** No typed consumer exists for the
   cumulative canonical envelope; only the older per-version packet seams and
   an optional Texture callback seam are present.
3. **Serialized live callback trace — BLOCK.** With both upstream gates
   blocked, a live trace has no cumulative snapshot or consumer to observe and
   must not be scheduled.

Missing prerequisites named by the audit: truthful Blend and Fog setter-owned
raw owners, complete production/envelope wiring for the already-implemented
leaf producers, a Geometry dependency-result builder, atomic resource-lease
publication, the cumulative assembler itself, and the Apple consumer and
registration code. The completed-but-unintegrated TEV (`043d24822`) and
Indirect (`2f6ba5dff`) leaf candidates do not change these verdicts on their
own.

## Record boundary

This file transcribes the pause-time record of the lane's final result, first
captured in the umbrella README at the pause (commit `3389159`, 2026-08-15)
and transcribed here on 2026-08-17. The lane's raw final handoff transcript
and its detached source root were not preserved through the post-pause
`/private/tmp` host cleanup; this transcription, the README pause tables, and
the lane board are the surviving record. Any resumed successor must treat the
three `BLOCK` verdicts as standing until a fresh audit at the then-current
integrated tip supersedes them.

No edit, build, test, CMake, full link, LLDB, runtime, Metal/device/pixel,
input/audio/save, iOS, or playability claim was authorized for this lane or is
made by this record.
