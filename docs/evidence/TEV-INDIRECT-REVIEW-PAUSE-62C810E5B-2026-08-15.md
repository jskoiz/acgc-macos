# Paused TEV and Indirect independent reviews at `62c810e5b`

## Scope and provenance

Lanes 239 and 240 are the registered independent immutable reviews of the
completed-but-unintegrated Indirect and TEV canonical leaf-producer
candidates. Both paused mid-verification on 2026-08-15 without producing their
final immutable `PASS`/`BLOCK` handoffs. This file records the exact paused
state so that neither review's partial commentary is ever mistaken for a
verdict.

- Indirect review task (lane 239): `01a00669-46ec-7c50-959c-50dafe702923`;
- TEV review task (lane 240): `01a004f2-96c0-79c2-8c20-c9b028bb5018`;
- PC review base: `62c810e5b6ee7710b2904ef4733ef95a6909fe1f` on
  `c1/macos-host-launch`;
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- TEV candidate: worker `043d24822cd075b51282101669d7710b785bd01f`, exact
  one-commit parentage from `62c810e5b`, four files including minimal
  `pc/CMakeLists.txt` registration; candidate bundle SHA-256
  `ba4d9a1ca72bd18dcffd31eddfd60969d96cb1ef8cb726d4042def6c02372f40`;
- Indirect candidate: worker `2f6ba5dff300239aa509c2f5a76431cae3d4b3a3`,
  exact one-commit parentage from `62c810e5b`, three new files; candidate
  bundle SHA-256
  `aaab318c0cbe19e6d52b63107e1431489eb4a1ee6762ecf34a87c072796b30c2`.

## Paused state

Lane 239 (Indirect review): static review, source-direct native and combined
ASan/UBSan fixtures, and C11/C++11 probes passed without diagnostics. The
`-m32`/`_WIN32` probes and the final immutable `PASS`/`BLOCK` handoff remain
open.

Lane 240 (TEV review): the crosswalk, native and combined ASan/UBSan focused
fixture/object builds and `1/1` CTests, `git diff --check`, and
C11/C++11/`-m32` probes passed. The `_WIN32` probe stopped at the missing
`process.h` sysroot boundary; the final immutable `PASS`/`BLOCK` handoff
remains open.

Neither candidate is integrated, and no partial result above is a `PASS`.

## Preservation and resume

The post-pause `/private/tmp` host cleanup removed the review worktrees,
unique native/ASan build roots, and candidate bundle files on both hosts. The
candidates survive as durable refs in the `upstream/ACGC-PC-Port` submodule:

- `c1/archive/cleanup-20260815/canonical-tev-candidate` at `043d24822`,
  mirrored at `acgc-m3-cleanup/canonical-tev`;
- `c1/archive/cleanup-20260815/canonical-indirect-candidate` at `2f6ba5dff`,
  mirrored at `acgc-m3-cleanup/canonical-indirect`;
- the review base is also mirrored at `acgc-m3-cleanup/canonical-62c810e`.

On resume, re-run each review from those refs in fresh isolated roots and
accept only a final immutable `PASS` or an exact material candidate-owned
blocker. Integration order on `PASS` remains TEV first (it owns the pending
minimal CMake registration), then Indirect, each with exact-tip focused native
and combined ASan/UBSan reruns.

This record was transcribed on 2026-08-17 from the pause-time README tables
(commit `3389159`). No integration, full link, LLDB, runtime, Metal/device,
pixel, Windows sign-off, or playability claim is made.
