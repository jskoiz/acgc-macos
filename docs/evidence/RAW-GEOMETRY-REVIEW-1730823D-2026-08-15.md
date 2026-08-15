# Raw Geometry review at `1730823d`

Date: 2026-08-15

Result: **BLOCK — do not integrate the candidate**

## Provenance

- ACGC-PC-Port base: `85b25cb3c63a68c2903155ccfd2dec05a1cb70fb`
- Candidate: `1730823d4586375991b4be5e32ebc583809ac763`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Source-only candidate bundle SHA-256:
  `4e6ab587db263312c72156536c25e7dceced5ccb9d24b64733d33b0e8d8f7a58`
- Source task: `01a0055c-6bac-7743-84f8-6ceb8bf0daf4` (lane 211)
- Independent review task: `01a00563-bd2c-7cf0-aa82-d5773a4ccdae`
  (lane 214)
- Detached review checkout:
  `/private/tmp/acgc-lane-214-geometry-review`

The bundle hash, complete history, base ancestry, four-file ownership, clean
detached status, and `git diff --check` all passed. The candidate changes only
`pc/CMakeLists.txt`, `pc/include/pc_gx_internal.h`, `pc/src/pc_gx.c`, and
`pc/tests/pc_gx_geometry_raw_batch_fixture.c`. No build was required to prove
the source-contract defects below.

The remote visible umbrella did not have an initialized standalone decomp
submodule. The reviewer therefore crosswalked the same cited GX implementation
snapshot carried in the PC-port source bundle and explicitly did not present
that as a separately checked decomp repository.

## Blocking findings

### 1. Raw-valid indexed scalar data does not reach the host mirror

`pc_gx_raw_geometry_format_is_valid()` accepts indexed POS, NRM, and TEX0 in
U8, S8, U16, S16, or F32 forms. The candidate's
`pc_gx_raw_geometry_host_array_element()` then refuses every non-F32 scalar
form. For a raw-valid indexed position, this causes `GXPosition1x8/1x16` to
submit a zero position; indexed normal and texcoord calls leave the host vertex
stale. That is neither the original GX value nor a transparent preservation of
the existing PC host path.

The repair must retain overflow-safe array intervals and no unsafe pointer
read, while ensuring every raw-supported indexed scalar form reaches the host
vertex with its source-faithful value. Position/TexCoord fixed-point fractions
and normal signed normalization must follow the pinned GX semantics. Deferred
position commit and flush ordering must remain unchanged. Invalid or
out-of-range raw data must still fail publication without an out-of-bounds host
read.

### 2. Packed-color FIFO width and RGBX8 ignored-byte semantics are lost

The candidate rejects RGBX8 whenever its low X byte is nonzero. The frozen
canonical Geometry contract explicitly treats that byte as ignored and assigns
RGB/RGBX canonical alpha 255. A nonzero X byte is therefore valid source data.

The raw producer also does not retain direct color entry-point width:

- `GXColor3u8` aliases `GXColor4u8`, losing the three-byte versus four-byte
  distinction;
- `GXColor1u16` forwards to the u32 handler, losing the two-byte distinction;
  and
- the handler can accept an API-width/VAT-format mismatch when the numeric
  value happens to fit.

The GX FIFO entry points are the provenance boundary: 16-bit packed forms,
three-byte packed forms, and four-byte forms must be distinguished before raw
publication. RGBX8's ignored byte must not invalidate direct or indexed input.
The existing fixture covers indexed RGBA8 only, so it does not close this
contract.

## Required child repair

The same source task and branch may add a child commit limited to the existing
four-file ownership. The focused fixture must cover:

- raw-valid indexed U8/S8/U16/S16/F32 POS, NRM, and TEX0 host mirroring,
  including fraction/normal interpretation and bounded source intervals;
- all six packed-color VAT forms through matching direct FIFO-width entry
  points, plus rejection of mismatched entry widths;
- indexed RGBX8 with a nonzero ignored X byte; and
- unchanged invalid-index fail-closed publication, host safety, and position
  commit/flush ordering.

Fresh native and combined ASan/UBSan focused tests and the production object
compile are required after the repair. The integration owner must independently
review the child range before importing it.

## Claim boundary

This is a read-only CPU/source review. It proves that candidate `1730823d`
must not be integrated. It provides no full `ac_pc` link, launch, LLDB,
callback, OpenGL/Metal encode or present, pixel readback, Windows runtime,
device, input, audio, save/reload, iOS, or playability evidence.

