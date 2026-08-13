# GX V3 Apple consumer boundary audit

Date: 2026-08-13  
Lane: 105 (`019ffd51-9466-75e3-b9f9-c27b43bda87f`)  
PC snapshot: `042cbf75fc136725769786443b40a1fd3ad82a7a`  
Decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Result

The live `549 → 0 → 0` sequence is upstream of the Apple consumer:

```text
pc_gx_flush_vertices()
  -> V2 handoff fails
  -> V3 builder/state predicate
  -> Apple V3 consumer only after a successful builder result
  -> consumer preparation and runtime callback
  -> pc_metal_runtime_observe()
```

The consumer invokes its runtime callback for both accepted and rejected
preparation statuses, and the observer increments its handoff count before
sink submission. Therefore consumer validation or Metal sink availability could
not explain both downstream counts remaining zero. Lane 104's
`alpha_update_enable` finding is the first source-backed V3 predicate; this
lane made no Apple production change.

## Crosswalk

- `pc/src/pc_gx.c`: V3 builder returns before the consumer call when state or
  packet construction fails.
- `pc/apple/src/metal_packet_consumer.c`: typed V3 consumer and callback are
  downstream of builder success.
- `pc/apple/src/pc_metal_runtime.c`: observer is downstream of consumer
  preparation and before sink submission.
- `upstream/ac-decomp/src/static/libforest/emu64/emu64.c`: original GX/TEV,
  blend, texture, and display-list state reaches the PC flush boundary; there
  is no decomp counterpart for the Apple observer.

## Verification

The isolated audit worktree was `/private/tmp/acgc-lane-gx-v3-apple-consumer/pc`
on branch `c1/lane-gx-v3-apple-consumer-audit`, with no source changes or
commit. Native and ASan/UBSan focused roots were:

- `/private/tmp/acgc-lane-gx-v3-apple-consumer-native`
- `/private/tmp/acgc-lane-gx-v3-apple-consumer-asan`

Both roots configured and built the V3 CPU handoff and runtime-registration
targets. The V3 CPU fixture passed `1/1` natively and `1/1` under ASan/UBSan,
with no diagnostics. The runtime-registration fixture was not executed because
it initializes the Metal sink; its production sources compiled successfully.

No full `ac_pc` link, LLDB launch, device run, Metal encode/present/readback,
pixel, input, audio, save/device, simulator, or playability evidence follows.
The next gate is the dedicated alpha-toggle builder-to-consumer fixture, not an
Apple consumer patch.
