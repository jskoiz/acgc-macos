# Current-tip sanitizer and Windows matrix — 2026-08-13

## Scope and exact inputs

This is a read-only verification handoff for the integrated PC source tip:

- `upstream/ACGC-PC-Port`: `c1/macos-host-launch` at `f18e7cd`
  (`Add V3 builder consumer fixture`), clean.
- `upstream/ac-decomp`: `master` at `09ca8e8b`, clean.
- No source, umbrella-document, ISO, or proprietary-asset changes were made by
  this lane. No full `ac_pc` link or LLDB launch was performed.
- Fresh ignored roots:
  - `/private/tmp/acgc-lane-current-sanitizer-windows-native`
  - `/private/tmp/acgc-lane-current-sanitizer-windows-asan`
  - `/private/tmp/acgc-lane-current-sanitizer-windows-win`

The lane also reviewed the historical worker root
`/private/tmp/acgc-lane-gx-v3-sanitizer-windows`; it is retained only as a
cleanup candidate and is not evidence for a different source tip.

## Native focused matrix

The integrated current-tip CTest matrix passed `7/7`:

1. `acgc_gx_semantic_packet_tests`
2. `acgc_gx_semantic_packet_cpp_tests`
3. `acgc_gx_semantic_packet_adapter_tests`
4. `acgc_pc_gx_semantic_handoff_tests`
5. `acgc_pc_gx_semantic_v2_handoff_tests`
6. `acgc_pc_gx_semantic_v3_handoff_tests`
7. `acgc_pc_gx_semantic_v3_consumer_fixture`

`git diff --check f18e7cd^ f18e7cd` also passed. This verifies the focused
portable packet, adapter, V1/V2/V3 handoff, and synthetic consumer fixtures on
the current arm64 macOS source tip.

## ASan/UBSan focused matrix

The same seven targets passed `7/7` in the combined sanitizer tree with:

```text
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
```

No sanitizer diagnostic match was found in the fresh ASan/UBSan root. Leak
detection is intentionally disabled for this repository's known host fixture
boundary; this is not a leak-free full-game claim.

## Windows compatibility boundary

Available host probes were run without changing the source:

- Shared packet/adapter C sources and static-GBI C probes pass under `_WIN32`
  with Apple Clang `-m32`.
- The C++ packet probe reaches the known artificial Apple libc++ locale-macro
  caveat (`_SPACE`, `_BLANK`, `_PUNCT`, `_ALPHA`, `_DIGIT`); this is not a
  Windows runtime result.
- The current `pc_gx.c` probe stops at the unavailable `process.h` header.
- Real `i686-w64-windows-gnu` and `i686-pc-windows-msvc` probes stop at the
  unavailable `string.h` header.
- No i686 MinGW compiler/binutils, `mingw32-make`, Wine/Wibo/Crossover wrapper,
  or Windows sysroot is installed; no PE link or Windows runtime was produced.

Therefore this lane preserves the existing Windows compatibility boundary and
does not grant Windows sign-off, PE/runtime proof, or playability.

## Claim boundary and next gate

The current integrated source is focused-test and sanitizer clean for the
portable GX packet/consumer slice. This evidence does **not** prove a full
game link, launch, game-owned callback, Metal encode/present/readback, pixel,
input, audio, save/device persistence, simulator, physical-device, or
playability gate. A separately authorized Metal state-encoder or current-tip
runtime trace remains the next dependency-ready gate.
