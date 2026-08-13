# Exact-tip sanitizer refresh — 2026-08-13

This read-only verification is from visible task
`019ffaad-cd4e-75d1-9e66-fdba9881de79`. It used the populated canonical PC
source `c1/macos-host-launch` at
`ac39d0449ac7e42d3b4f926c2816d50e656a96cd` and decomp reference `master` at
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The generated umbrella worktree
was detached with empty submodules; it was not initialized or modified.

## Focused matrix

Unique build roots:

- `/private/tmp/acgc-lane-sanitizer-ac39d04-native`
- `/private/tmp/acgc-lane-sanitizer-ac39d04-asan`

| Fixture | Native | ASan/UBSan |
| --- | --- | --- |
| `acgc_pc_gx_semantic_handoff_tests` | PASS | PASS |
| `acgc_legacy_seam_tests` | PASS | PASS |
| `acgc_metal_state_fixture_tests` | CPU PASS; device skip `77` | CPU PASS; device skip `77` |
| `acgc_metal_packet_consumer_tests` | CPU PASS; device skip `77` | CPU PASS; device skip `77` |
| `pc_save_bswap_roundtrip` | PASS, exit `0` | PASS, exit `0` |

The CMake-registered portion was two passes and two declared device skips per
matrix. The standalone Save_t fixture is not registered by the current PC
CMake project, so it was compiled directly with the canonical PC `include/` and
`src/` overlays. Totals per matrix are three passes, two declared skips, and
zero failures; across both matrices, six passes and four skips.

Expected warnings include the existing `PC_DARWIN_COMPILE_AUDIT` frontier
warning, unused `CMAKE_OBJC_FLAGS` in the PC sanitizer configure, legacy macro
redefinitions, and visibility/typedef warnings in the standalone Save_t
compile. No ASan/UBSan diagnostic or runtime error occurred.

## Evidence boundary

This proves the current callback, graph seam, Apple CPU contracts, and Save_t
codec/checksum/restart fixtures at `ac39d04`. It does not prove a full `ac_pc`
link, launch, rendered frame, pixel readback, input, audible audio,
device-persistent save, simulator/device behavior, or playability.
