# Canonical Blend/logic state at `216d1e24b`

Date: 2026-08-14

## Provenance

- Remote M3 Max task: `01a002af-5e39-7e40-b83e-86323c7786c6`
- Worker branch: `c1/lane-canonical-blend-m3`
- Worker base/final: `4dbb710653ee76dd6d547b1a352a447e7124b9b8`
  -> `a170654b0d910bfdcd377d184fbd87ae611b182a`
- Reviewed canonical integration: `216d1e24b`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The exact four-file change is:

- `include/acgc/gx_canonical_blend_state.h`
- `src/gx_canonical_blend_state.c`
- `pc/portable/tests/test_gx_canonical_blend_state.c`
- `pc/portable/CMakeLists.txt`

## Implemented contract

The renderer-neutral `0x0080` Blend/logic section is version 1, 16 bytes,
four-byte aligned, count/capacity 1, and four logical little-endian `uint32`
words:

```text
offset 0   mode                 0..3
offset 4   source_factor        0..7
offset 8   destination_factor   0..7
offset 12  logic_op             0..15
```

Static size/alignment/offset assertions protect the C ABI. Null, sentinel, and
unknown values fail closed. Bounded inactive factor/logic words remain
transported without mode-dependent normalization.

A Blend-local metadata helper composes the common envelope validator and
tightens the present entry to exact version, 16-byte size, count/capacity 1,
mask `0x0080`, and zero reserved metadata. Absent Blend retains its fixed
section ID with every other directory word zero. Common envelope semantics,
V1-V4, `pc_gx`, and Apple code are unchanged.

The PC crosswalk covered `PCGXState`, `GXSetBlendMode`, the V3 mapper/validator,
and the V3/V4 ABI. ac-decomp `GXPixel.c`, `GXEnum.h`, emu64, and J2D confirm
the same four numeric domains and their separation from Alpha/update and
Raster state.

## Verification

Remote focused results:

- native CTest: `1/1`, serial;
- combined ASan/UBSan: `1/1`, no diagnostics;
- C and C++ ABI/syntax probes: pass;
- bounded `_WIN32` header/CPU probe: pass; and
- `git diff --check`: pass before and after commit.

The exact integrated snapshot `216d1e24b` was configured from
`pc/portable` and ran the fog, envelope, and Blend targets serially:

- native: `3/3` passed;
- combined ASan/UBSan: `3/3` passed with no diagnostics.

Sanitizers used `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1`
and `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. Because leak detection
was disabled, this is not leak-free proof. The bounded `_WIN32` probe is not
Windows/i686/PE/runtime sign-off.

## Evidence boundary

This proves only a portable CPU Blend/logic value ABI, validator, and malformed
metadata fixture. It does not prove a live snapshot producer, callback, Apple
consumer, Metal encode/present/readback, pixel, device behavior, or
playability. The independent Alpha/update and TEV audits determine the next
neutral sections; missing PC shadow state still gates the live producer.
