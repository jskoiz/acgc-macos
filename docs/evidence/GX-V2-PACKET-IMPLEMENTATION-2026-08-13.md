# GX v2 packet implementation evidence — 2026-08-13

## Scope and refs

This lane implemented the smallest bounded, pointer-free GX v2 packet extension
identified by the two-upstream contract map. The worker started from PC
`a8f3a8fcb12ca0acb23ab668b705d35f137ea65c` (`c1/macos-host-launch`) and decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c` (`master`). Worker branch
`c1/lane-gx-v2-packet` produced `06fa74c9089019d2c4538dfacd159e5e8a0224ce`.
After review, that commit was integrated into canonical PC as
`26da235` (`Add bounded GX v2 semantic packet fixture`).

The two-upstream crosswalk uses the contract map
`docs/evidence/GX-V2-PACKET-CONTRACT-MAP-2026-08-13.md`, decomp `emu64_init()`
and GX state initialization at `09ca8e8b`, and the PC-owned `g_gx` channel,
texgen, TEV, depth, blend, alpha, fog, cull, and resolved texture state. Guest
pointers never enter the packet; texture, TLUT, and sampler fields are bounded
host-resolved keys.

## Implementation boundary

The integrated change touches exactly these five PC files:

- `include/acgc/gx_semantic_packet.h`
- `src/gx_semantic_packet.c`
- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_semantic_handoff.c`
- `pc/CMakeLists.txt`

The v2 packet embeds the unchanged v1 geometry prefix at offset zero and adds a
fixed-width version/size, bounded channel and texture-generator descriptors,
up to two TEV stages, resolved texture metadata, TEV registers/swap tables, and
strict enum/range/finite-value validation. Unused descriptors must be zero.
Unknown lighting, fog, indirect, alpha, blend/cull/depth-related dynamic state,
non-default texgen, unsupported TEV operations/selectors, invalid texture
identity, bad matrix indices, and non-finite transforms fail closed.

The existing `PCGXSemanticPacketHandoffCallback` and Apple consumer remain
v1-only. `pc_gx_try_handoff_semantic_vertices()` therefore continues to send
only v1 packets; the v2 constructor is exposed only under the Darwin audit test
definition as a focused fixture hook. No existing consumer is silently fed a
v2 prefix, and no version-aware runtime consumer was added in this lane.

## Integrated verification

All commands below ran against the exact integrated source checkout
`/Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port` at
`26da235`. Full `ac_pc` linking and live LLDB were intentionally not run.

Native focused build and tests:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-gx-v2-26da235-native -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON
cmake --build /private/tmp/acgc-integrate-gx-v2-26da235-native \
  --target acgc_pc_gx_semantic_handoff_tests \
           acgc_gx_semantic_packet_tests \
           acgc_gx_semantic_packet_cpp_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-gx-v2-26da235-native \
  --output-on-failure \
  -R '^(acgc_pc_gx_semantic_handoff_tests|acgc_gx_semantic_packet(_cpp)?_tests)$'
```

Result: 3/3 tests passed.

ASan/UBSan focused build and tests used separate root
`/private/tmp/acgc-integrate-gx-v2-26da235-asan` with
`-fsanitize=address,undefined -fno-omit-frame-pointer` for C, C++, Objective-C,
and executable linking. The same three targets passed 3/3 under
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1`, with no sanitizer diagnostics.

`git diff --check` passed for the worker commit and for the integrated PC
checkout. The integrated source checkout is clean after the commit; the
umbrella gitlink update is owned by the integration lane.

## Claims and next gate

This evidence proves a bounded CPU packet ABI, builder, validator, and
fail-closed focused fixtures. It does not prove a live game-owned callback,
Metal encode/present/readback, pixel, input, audible audio, save/device
persistence, simulator/device behavior, clean playability, or a full game link.

The next implementation gate is a separately owned, version-aware consumer and
callback boundary that can validate and consume `AcgcGxSemanticPacketV2` without
regressing the existing v1 path. Only after that boundary is proven should a
serialized current-tip runtime trace test callback reachability and then the
separate Metal encode/readback/pixel gates.
