# Apple V2 sink guard at `5157ac1cb`

## Provenance and ownership

Remote M3 Max lane 150 (`01a0025c-9d0d-71d3-9be3-7b01da10cfa2`) started from
ACGC-PC-Port `59d13a98e06c4a67c67b5936f5257a6ff82c0d7a` on branch
`c1/lane-v2-sink-policy-m3`. Its clean worker commit is
`a4d90512c98a0ccd160eff6fb6e090cf92b64a07`; the integration owner
cherry-picked it after `820906439` as canonical `c1/macos-host-launch`
`5157ac1cbcdc3a0074a407c08874a0861ba20c72`. The ac-decomp reference was
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

The exact source delta is:

- `pc/apple/CMakeLists.txt`
- `pc/apple/src/pc_metal_runtime.c`
- `pc/apple/tests/test_metal_packet_consumer_v2_runtime_sideband.c`

No packet/header ABI, `pc_gx`, consumer production code, Metal sink, decomp,
ISO, or asset file changed. The source-only Git bundle SHA-256 is
`a98c5d18728aaef133b0f5c61b5301e547baada64902a479419b7434f2c838a2`.

## Behavior

`pc_metal_runtime_observe` now submits to the Metal sink only after a pure,
testable semantic-version/status policy accepts the output. It preserves the
existing V1 value-only path and bounded V4 path. Ordinary V2 marked
`V2_EXTENSION_NOT_RENDERED`, provider-backed V2 marked
`V2_EXTENSION_CPU_RESOLVED`, V3, unknown versions, malformed status tuples,
null output, and non-`OK` handoffs fail closed before sink submission.

This fixes the prior geometry-prefix defect: a V2 packet can contain meaningful
channel, texgen, texture/TLUT, sampler, and TEV state that the geometry-only
sink cannot consume. The legacy OpenGL draw remains independent.

The Apple CMake target now compiles `pc_metal_runtime.c` in a bounded
`ACGC_PC_METAL_RUNTIME_SINK_POLICY_FIXTURE` mode so the test calls the actual
production policy without pulling in the live runtime and Metal device path.

## Verification

The remote worker passed the exact focused target from unique native and
combined ASan/UBSan roots. Both direct execution and CTest passed `1/1`; the
sanitizer run used `detect_leaks=0` and emitted no sanitizer diagnostics. A
normal production-path syntax compile of `pc_metal_runtime.c` passed.

The integration owner repeated the exact canonical gate:

- `/private/tmp/acgc-integrate-v2-sink-policy-5157ac1cb-native`: `1/1` pass;
- `/private/tmp/acgc-integrate-v2-sink-policy-5157ac1cb-asan`: combined
  ASan/UBSan `1/1` pass with `detect_leaks=0` and no diagnostics;
- production-path `cc -fsyntax-only pc/apple/src/pc_metal_runtime.c`: pass.

## Evidence boundary and next gate

This proves CPU-side sink eligibility only. It does not prove a live callback,
full `ac_pc` link, Metal device, encode/present/readback, pixel, frame, or
playability gate. V2 must remain blocked until a cumulative renderable packet
and native Apple consumer preserve every required semantic section.
