# GX V4 texture-map alias gate — 2026-08-13

This narrow source change advances the V4 builder past the exact live state
identified by the current-tip trace. It allows a resolved GX texture-map alias
to reach the V4 packet while the Apple consumer continues to mark the
texture/TEV extension as unrendered. V1, V2, and V3 keep their stricter
map-index predicate.

## Provenance and crosswalk

- Worker branch: `c1/lane-gx-v4-live-texture-map` at `1ed4e4a`.
- Worker base: PC `28ebac2` (`c1/macos-host-launch`).
- Integrated canonical PC: `c1/macos-host-launch` at `83fe50c`, clean after
  focused verification.
- Decomp oracle: `master` at `09ca8e8b`, clean.
- Source worktree: `/private/tmp/acgc-lane-gx-v4-live-texture-source`.

The PC port's V2 stage predicate required `stage->tex_map == stage_index`,
which is a safe identity assumption for the V2 packet because its texture
generator and sampler keys are fully rendered by that contract. The V4 Apple
consumer does not render the V3 texture-matrix/TEV extension yet; it only maps
the bounded vertex-color, blend, and alpha-write subset. The V4 predicate now
keeps the V2 safety checks and requires a resolved host texture handle, but
allows a valid non-indexed GX map alias. This does not copy a guest pointer or
claim that the texture effect is rendered.

The decomp oracle initializes texture/TEV ordering with explicit
`GXSetTevOrder` calls in `src/static/libforest/emu64.c:559-574` and
reconfigures active stages at `:648-658`; it also initializes the two texture
generators at `:641-642` and the alpha/blend state at `:604-619`. Those calls
show why map identity is not a universal guest invariant. The source change
does not alter the decomp history or the Windows/OpenGL V1/V2/V3 paths.

## Exact source boundary

Only these two PC files changed:

- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_semantic_v4_consumer_fixture.c`

The new V4-only stage helper retains channel, indirect-state, texture-format,
matrix, blend-factor, and alpha validation. The fixture uses a resolved map
`2` for stage `0`, confirms V3 still fails closed, and confirms V4 builds the
packet with alpha writes disabled. No Apple consumer files or packet ABI were
changed.

## Focused verification

From the worker source worktree, the six affected semantic targets passed in a
serial native matrix and a combined ASan/UBSan matrix (`--parallel 1`):

```text
acgc_pc_gx_semantic_handoff_tests
acgc_pc_gx_semantic_v2_handoff_tests
acgc_pc_gx_semantic_v3_handoff_tests
acgc_pc_gx_semantic_v3_consumer_fixture
acgc_pc_gx_semantic_v4_alpha_state
acgc_pc_gx_semantic_v4_consumer_fixture
```

Integrated from canonical `83fe50c`, the same matrix passed `6/6` native and
`6/6` combined ASan/UBSan with `ASAN_OPTIONS=detect_leaks=0` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; no sanitizer diagnostics
were emitted. Only the existing AppleClang warnings (`INT_MIN` redefinition
and the unsupported `-Wno-builtin-declaration-mismatch` option) appeared.

## Claim boundary and next gate

This is a CPU/contract change. It does not prove a current-tip full link, live
V4 callback, Metal encode/present/readback, pixel, input, audio, save/reload,
device, simulator, or playability gate. The next bounded action is one
serialized `ac_pc` link and one LLDB trace against `83fe50c` to measure whether
the live V4 handoff now reaches the typed Apple consumer. Do not infer a frame
until callback, sink submission, and readback are separately observed.
