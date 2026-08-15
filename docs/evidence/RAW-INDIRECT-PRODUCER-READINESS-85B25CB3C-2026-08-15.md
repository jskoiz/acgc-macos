# Raw Indirect producer readiness at PC 85b25cb3c

Date: 2026-08-15  
Lane: 212 / task `01a00562-c9bc-7b70-9d2e-de9232703062`  
Mode: read-only M3 Max crosswalk (`gpt-5.6-luna`, max reasoning)

## Result

Raw Indirect is the next dependency-ordered GX producer after raw Geometry,
but it is not concurrently ready. Its data contract is independent of
Geometry; its implementation must wait for lane 211 to release overlapping
`pc/src/pc_gx.c`, `pc/include/pc_gx_internal.h`, and common pre-mutation flush
ownership.

This audit changed no source or documentation in either upstream and ran no
build, test, link, launch, LLDB, Metal, or device command.

## Exact references

- Authoritative umbrella at dispatch: `78bbdea116b29b32e2db6d5241201c61a1025654`.
- ACGC-PC-Port: `85b25cb3c63a68c2903155ccfd2dec05a1cb70fb`,
  inspected from clean detached
  `/private/tmp/acgc-lane-raw-indirect-crosswalk-m3`.
- ac-decomp: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`,
  clean and read-only.
- Source-only PC bundle SHA-256:
  `5aa5c6bf21b4e1ed9f254139802a886dc5f649ca78bc2b69f1b8ee106142bc46`.
- Accepted section-13 contract copy SHA-256:
  `5706ae2cb688ebb0473f5e60b986d63e4197f9d8f627fb8d3aefd8e043521e1f`.
- The task's visible umbrella worktree was a clean but stale detached snapshot
  at `ee31f535`; it was recorded only as provenance and not used as source
  evidence.

## Two-upstream crosswalk

ACGC-PC-Port `pc/src/pc_gx.c` currently owns:

- `GXSetNumIndStages`
- `GXSetIndTexOrder`
- `GXSetIndTexCoordScale`
- `GXSetIndTexMtx`
- `GXSetTevIndirect` / `GXSetTevDirect`
- host fields `PCGXState.num_ind_stages`, `ind_order`, `ind_mtx`, and
  `ind_mtx_scale`
- TEV-owned per-stage Indirect fields in `PCGXTevStage`

Those PC setters mark `PC_GX_DIRTY_INDIRECT` and mutate host state directly.
They do not retain guest-quantized values, per-field knownness, sticky invalid
provenance, or source-faithful pre-mutation draw flushing.

ac-decomp `src/static/dolphin/gx/GXBump.c` is the behavior oracle for the same
setters. It validates domains, rejects mutation during `GXBegin`, and emits BP
fields. `GXSetIndTexMtx` quantizes coefficients as
`int(1024.0f * value) & 0x7ff`, adds `0x11` to the exponent, and packs the
resulting six-bit scale encoding. `GXSetTevIndirect` owns only its TEV-stage
tuple, while `GXSetTevDirect` resets that same TEV tuple. `GXInit.c` establishes
Indirect defaults through setters; the PC `GXInit` no-op means a new raw shadow
must begin unknown rather than infer valid zero state.

Representative decomp callers include `J2DGrafContext.cpp`, `emu64.c`, and
`Famicom/ks_nes_draw.cpp`; they exercise zero, one, and two active stages and
real matrix/TEV Indirect combinations.

## Frozen future source lane

The smallest source lane should add a dedicated pointer-free
`PCGXRawIndirect` shadow and narrow setter hooks. Preferred ownership:

- new `pc/src/pc_gx_indirect_raw.c` for the shadow, validation, snapshot, and
  conversion helper;
- raw declarations only in `pc/include/pc_gx_internal.h`;
- narrow hooks in `pc/src/pc_gx.c` for the four shared-state setters;
- new `pc/tests/pc_gx_indirect_raw_shadow_fixture.c`;
- minimal existing `pc/CMakeLists.txt` registration.

The raw shadow owns only:

- Indirect stage count;
- four texture-coordinate/map order records;
- four coordinate scale pairs;
- three copied and guest-quantized matrix slots;
- per-field knownness and sticky invalid provenance;
- a synchronous immutable snapshot at the common flush boundary.

Every owned setter must flush a completed draw before mutating raw or host
state. Matrix data is copied during the setter; no caller pointer may be
retained. Null, non-finite, invalid selectors, and out-of-domain values must
fail closed without aliasing slot zero or manufacturing known values.

`GXSetTevIndirect`, `GXSetTevDirect`, and derived TEV helpers remain TEV-owned.
The raw lane must not duplicate their nine per-stage fields. Texture bytes,
sampler/TLUT state, and TEV payloads are also out of scope.

## Converter dependencies

The later canonical producer consumes:

1. the immutable raw Indirect snapshot;
2. validated canonical TEV state;
3. required Texture and Texgen dependency results for active orders;
4. an optional Geometry dependency only where the cumulative assembler needs
   it; and
5. caller-owned section-13 output validated by the existing portable
   Indirect validator.

It must reject unknown active-order dependencies, missing referenced matrices,
TEV stages outside the active count, and direct/Indirect texture-map
collisions.

## Focused regression contract

The future fixture should cover:

- initial unknown state versus explicit setter-produced zero;
- maximum stage/order/scale domains;
- matrix selector families, scale encoding, and quantization endpoints;
- invalid count, stage, coordinate/map, scale, matrix selector, null, and
  non-finite inputs;
- sticky invalid provenance without slot-zero aliasing;
- flush-before-mutation ordering across a completed draw;
- `GXSetTevIndirect` / `GXSetTevDirect` changing TEV state only;
- snapshot lifetime and pointer independence.

Proposed focused target: `acgc_pc_gx_indirect_raw_shadow_fixture`, run serially
in native and combined ASan/UBSan roots. No such target was built or run by
this audit.

## Claim boundary

This evidence proves only exact-source crosswalk and dependency/ownership
readiness. It does not prove an implementation, canonical packet production,
full link, runtime callback, Metal encode/present/readback, pixel, device,
Windows runtime, or playability.
