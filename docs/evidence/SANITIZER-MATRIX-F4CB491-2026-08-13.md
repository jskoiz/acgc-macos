# Native and ASan/UBSan verification matrix (historical `f4cb491`)

Date: 2026-08-13 HST

This read-only matrix was configured and run against PC `f4cb491` and decomp
`09ca8e8b`. The populated canonical PC checkout advanced to `54b840c` while
the lane was running, so no result below is a current-tip claim. No source,
docs, gitlink, ISO, or proprietary asset was changed, and no full `ac_pc` link
or launch was run.

## Results

| Slice | Native | ASan/UBSan |
| --- | --- | --- |
| Portable focused CTest | 12 passed, 0 failed | 10 passed, 2 failed on the same pre-existing UBSan issue |
| PC focused CTest | 6 passed, 1 declared CoreAudio skip | 6 passed, 1 declared CoreAudio skip |
| Apple focused CTest | 6 passed, 2 declared Metal-device skips | 6 passed, 2 declared Metal-device skips |

The direct Save_t, CARD restart/corruption, cleanup allocator, audio DMA,
native command-pointer, audio-bank, platform, and ARAM fixtures passed in both
modes with leak detection disabled where required by Apple’s sanitizer runtime.
The live CoreAudio device probe remains skip `77` (`AudioDeviceGetProperty`
reported `560947818`). Metal CPU contracts passed; device-backed tests skipped
because no macOS Metal device was available.

## Sanitizer blocker

The only sanitizer failures are the legacy emu64 `aflags_c` object/ABI issue at
`src/static/libforest/emu64/emu64.c:6134:14`, reproduced by both
`acgc_emu64_gbi_traversal_tests` and
`acgc_pc_live_graph_target_capture_fixture`. Recovery mode lets both fixtures
reach their own `PASS` output while reporting repeated UBSan violations; no
separate AddressSanitizer heap report was emitted. The owning source lane is
the emu64 LP64/object-sizing boundary, not the later Apple sink or input
fixture.

## Claim boundary

This matrix is fixture/build evidence only. It does not establish current-tip
sanitizer status, live launch, a rendered frame, Metal encode/present/readback,
input, audible audio, Save_t device persistence, simulator/device behavior, or
playability. Exact logs were retained during review under:

- `/private/tmp/acgc-lane-sanitizer-matrix-native`
- `/private/tmp/acgc-lane-sanitizer-matrix-asan`
