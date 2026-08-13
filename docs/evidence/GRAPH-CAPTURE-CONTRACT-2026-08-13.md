# Bounded game-owned graph capture contract (2026-08-13)

This evidence is bound to `upstream/ACGC-PC-Port` source commit
`6e4aded` (`Classify bounded graph submissions safely`) on lane branch
`c1/lane-complete-graph-capture`, integrated into the authoritative
`c1/macos-host-launch` history at `6e4aded` (current tip `9cf9b3f`). The
matching reference checkout is `upstream/ac-decomp` at `09ca8e8b`.

## Contract

The capture observer still copies only eight fixed-width words. The classifier
uses the bounded `GRAPH.Gfx_list05 = sys_dynamic.work` extent (256 `uint32_t`
words) to distinguish an exact `DF000000 00000000` terminator from a prefix-only
observer record. Zero padding in the eight-word observer is never treated as a
terminator. Indirect `G_DL`/`G_BRANCH_Z` edges, malformed commands, oversized
lists, and unterminated bounded sources fail closed. On LP64, static-reference
payloads are redacted to the pointer-free `0x50545200` marker; the Windows and
ILP32 paths retain their existing fixed-width behavior.

The cross-repository reading is deliberately narrow: both upstreams place the
work list in `GRAPH.Gfx_list05` with `WORK_SIZE=128`, and the decomp's
`graph_draw_finish` branches to a separate `new0` list rather than appending a
terminator to the observer prefix. The live `DE010000 F0002000` pair is thus an
indirect edge, not a complete draw list.

## Exact verification

From the integrated PC source checkout:

```text
cmake -S pc/apple -B /private/tmp/acgc-integrate-graph-6e4aded \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-graph-6e4aded \
  --target acgc_legacy_seam_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-graph-6e4aded --output-on-failure
```

Result: focused native Apple seam tests passed. A separate build root
`/private/tmp/acgc-integrate-graph-6e4aded-asan` passed the same focused target
under ASan/UBSan with `ASAN_OPTIONS=detect_leaks=0` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`.

The exact integrated PC tip was then linked serially:

```text
cmake -S pc -B /private/tmp/acgc-integrated-post-graph-metal-9cf9b3f \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrated-post-graph-metal-9cf9b3f \
  --target ac_pc --parallel 1
```

Result: all objects compiled and `AnimalCrossing` linked successfully. The
result is a Mach-O arm64 executable. This is link proof only; no current
game-owned complete list, Metal encode/present, pixel readback, input, audio,
save/load, simulator, device, or playability claim follows.

## Evidence boundary

The earlier live LLDB observer remains an incomplete eight-word prefix
(`de010000 f0002000` plus zero-valued captured words, count `8`, capacity
`256`). The contract now classifies that shape as `PREFIX_ONLY` and refuses to
submit it to a renderer decoder. A future runtime lane must capture the full
bounded source or an explicit indirect-list resolution before claiming a draw.
