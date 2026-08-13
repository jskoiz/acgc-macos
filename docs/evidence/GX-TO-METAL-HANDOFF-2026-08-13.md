# GX-to-Metal handoff seam (2026-08-13)

This evidence is bound to `upstream/ACGC-PC-Port` lane branch
`c1/lane-gx-metal-handoff`, whose final commits are `19d5f4e` plus the shader
identifier fix `26bcc02`. They were reviewed into the authoritative
`c1/macos-host-launch` history as `e22cbc5` and `9cf9b3f`. The matching
`upstream/ac-decomp` reference is `09ca8e8b`.

## Scope

The PC GX flush boundary can optionally translate a validated fixed-width
renderer-neutral packet into the existing Apple packet consumer. The adapter
does not replace the Windows/OpenGL path, does not infer a draw from an
incomplete observer prefix, and keeps packet/state ownership explicit. The
embedded Metal fixture shaders use non-reserved local identifiers so the host
compiler can parse the CPU/device test sources.

## Exact verification

Integrated Apple tests from the authoritative source:

```text
cmake -S apple -B /private/tmp/acgc-integrate-gx-metal-9cf9b3f \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-gx-metal-9cf9b3f \
  --target acgc_legacy_seam_tests acgc_metal_packet_consumer_tests \
  acgc_metal_state_fixture_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-gx-metal-9cf9b3f \
  --output-on-failure
```

Result: all three CTest targets passed. The direct packet-consumer and state
fixture binaries report their CPU contracts as PASS and return the declared
skip `77` for the device portion because this host has no available macOS
Metal device. Offline shader compilation checks passed after the
`geometry_vertex` identifier fix.

The PC handoff target also passed natively and under ASan/UBSan in the paired
`/private/tmp/acgc-integrate-pc-handoff-9cf9b3f` and
`/private/tmp/acgc-integrate-pc-handoff-9cf9b3f-asan` roots.

## Evidence boundary

This proves the CPU packet/state contract and a compilable, device-gated Apple
consumer. It does not prove that the live game graph reaches this consumer,
that a command buffer encoded or presented, that pixels were read back, or
that input, audible audio, save/load, simulator/device behavior, or
playability works. The next useful lane is a serialized post-link runtime
trace that binds a complete game-owned submission to the optional consumer.
