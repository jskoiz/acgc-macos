# GBI indirect-target audit — 2026-08-13

This read-only audit is from visible task
`019ffaad-ca28-7c62-bd0f-0176ceb55e52`, bound to PC source
`c1/macos-host-launch` at `ac39d0449ac7e42d3b4f926c2816d50e656a96cd` and
`ac-decomp` at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. No source, test,
umbrella, ISO, or asset files were changed.

## Result

The observed prefix is a runtime branch-list command, not a complete display
list and not a guest segmented address:

```text
word 0: 0xDE010000 = G_DL, G_DL_NOPUSH (1), length 0
word 1: 0xF0002000 = first-generation-1, slot-0 PC runtime handle
```

In both trees, `graph_draw_finish` emits this edge with
`gSPBranchList(NOW_WORK_DISP++, this->Gfx_list10)`. The root
`Gfx_list05` is `sys_dynamic.work`; the target `Gfx_list10` is the separate
`sys_dynamic.new0` arena. `WORK_SIZE` is 128 `Gfx` entries (256 `uint32_t`
words), while `NEW0_SIZE` is 512 `Gfx` entries (1024 words). Therefore the
target bytes cannot be inferred from the bounded 256-word root capture.

`F0002000` is a process-local PC registry capability, not an N64 segmented
pointer. The `G_DL` handler resolves it through the live registry and jumps to
the target with `G_DL_NOPUSH`; `GXCallDisplayList` is the parameter-2 path and
is not the observed branch. After registry reset, a saved F-handle must fail
closed.

## Existing and required contract

Existing fixtures cover the low-level pieces:

- `pc/portable/tests/test_gbi_runtime.c:48` constructs `DE010000,F0002000`,
  resolves a live target, and checks the complete `DF000000,0` terminator.
- `pc/portable/tests/test_emu64_seg2k0.cpp:18` proves that registry reset
  invalidates the handle.
- `pc/apple/tests/test_legacy_seams.c:144` and
  `pc/portable/tests/test_gx_semantic_packet_adapter.c:166` keep the observed
  `8/256` capture indirect/incomplete instead of decoding it as a complete
  list.

The smallest resolving successor must retain `Gfx_list10`/`sys_dynamic.new0`
identity and an explicit target capacity while the registry is live, resolve
`F0002000` through that registry, traverse only the declared span, and require
the exact `DF000000,0` pair. If target identity, capacity, or terminator proof
is unavailable, preserve `INDIRECT`/`PREFIX_ONLY` and stop. Never reinterpret
the F-handle as a guest segment.

## Evidence boundary

This audit proves why the eight-word observer cannot resolve the live target by
flat-copying `sys_dynamic.work`, and it defines a dependency-ready bounded
fixture or graph-edge observation. It does not prove a draw, complete packet,
GX/Metal encode, present, pixel readback, input, audio, save/load, simulator,
device, or playability.
