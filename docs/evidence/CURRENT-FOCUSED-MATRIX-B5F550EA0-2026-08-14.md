# Focused sanitizer and Windows matrix at `b5f550ea0`

Date: 2026-08-14

## Provenance and scope

- Remote M3 Max task: `01a0029d-475c-7a31-a6f9-708e60cb4201`
- PC baseline: `b5f550ea028ab933b8433ec2e9d29768252cabdc`
- ac-decomp: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Verification-only detached worktree:
  `/private/tmp/acgc-lane-current-matrix-b5f550`

The lane made no edit and did not build/link `ac_pc`, access the ISO/assets,
launch, attach LLDB, publish, or perform a device operation.

## Baseline results

The selected top-level PC, standalone portable graph/GBI, and Apple CPU targets
produced:

- native: 44 passed, 0 failed, 3 declared Metal-device skips;
- combined ASan/UBSan: 44 passed, 0 failed, 3 declared Metal-device skips; and
- bounded Windows host probes: 4 passed, 5 blocked.

The three code-77 skips were `acgc_metal_state_fixture_tests`,
`acgc_metal_packet_consumer_tests`, and `acgc_metal_sink_tests` because the
lane had no usable Metal device. Sanitized runs used
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; final logs contained no
ASan/UBSan/runtime-error diagnostics. Leak detection was disabled, so this is
not leak-free proof.

The four passing `_WIN32 -m32 -fsyntax-only` host probes covered packet C,
packet-adapter C, canonical-state C, and the canonical fog test. The blocked
probes were:

- the C++ packet probe under Apple libc++ `_WIN32` locale macros;
- `pc_pad.c` and `pc_gx.c` at missing SDL `<process.h>`; and
- i686 GNU/MSVC Clang targets at missing Windows `<string.h>`/sysroot.

MinGW i686 GCC/G++, `windres`, `mingw32-make`, and `wibo` were unavailable.
Wine was present but deliberately unused. This is host syntax/layout evidence,
not Windows, i686, PE, runtime, or sign-off proof.

## Exact post-integration delta at `4dbb71065`

Because the broad matrix predates lanes 156 and 157, the integration owner ran
the exact changed-contract subset on canonical PC `4dbb71065`:

- portable canonical fog plus envelope: native 2/2 and combined ASan/UBSan
  2/2;
- Apple V2 runtime-sideband/V4 sink-policy fixture: native 1/1 and combined
  ASan/UBSan 1/1.

All six executions passed serially with no sanitizer diagnostics. The unique
roots were:

```text
/private/tmp/acgc-post-envelope-sink-4dbb710-native/{portable,apple}
/private/tmp/acgc-post-envelope-sink-4dbb710-asan/{portable,apple}
```

## Evidence boundary

This is focused CPU/build verification. It does not prove a full `ac_pc` link,
game launch, live canonical snapshot, callback, Metal encode/present/readback,
pixel, physical input, audible audio, save/reload, simulator, device, Windows
runtime, or playability.
