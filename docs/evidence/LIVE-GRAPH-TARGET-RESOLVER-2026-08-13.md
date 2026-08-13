# Live graph target resolver (2026-08-13)

This source/test lane started from PC `02a003e5c9917861cfc1faed51face26dee6f98f`
(`c1/macos-host-launch`) and decomp `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
(`master`). The reviewed source commit is `7baf34dbef5cce45676778f588966c34ad39ba3d`,
integrated into the authoritative PC branch as `aea35157f3175512c7643e9f32b09b68c2e05b22`.

## Change boundary

The lane changes only the production `emu64::dl_G_DL`/graph-frame handoff and
adds one focused fixture plus its CMake registration:

- `src/static/libforest/emu64/emu64.c` re-resolves only registered `F…`
  handles, checks alignment and containment in `sys_dynamic.new0`, computes the
  remaining bounded span, and synchronously calls the existing pointer-free
  target capture seam. Null, stale, unknown, or out-of-arena handles fail closed.
- `src/graph.c` carries the active graph frame into that observer without
  changing the decomp graph layout or the public packet contract.
- `pc/tests/pc_live_graph_target_capture_fixture.c` drives the production
  `emu64_taskstart → dl_G_DL` path with the real `sys_dynamic.work →
  sys_dynamic.new0` relationship and verifies stale-handle behavior.

The decomp crosswalk is unchanged: `Gfx_list05` is the 128-entry work arena,
`Gfx_list10` is the 512-entry `new0` arena, and `graph_draw_finish` branches the
work list into `new0`. The PC registry represents `F0002000` as a live process
capability, never as a guest segmented pointer.

## Verification

On the integrated PC source `aea3515`:

- Native CMake configure/build passed for the live-target fixture, the existing
  indirect-target seam, and the existing emu64 traversal test.
- Native CTest passed `3/3`:
  `acgc_pc_live_graph_target_capture_fixture`,
  `acgc_graph_indirect_target_tests`, and
  `acgc_emu64_gbi_traversal_tests`.
- ASan/UBSan configure/build and CTest passed `3/3` with
  `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
  `UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; no sanitizer, leak, or
  runtime-error diagnostics were reported.

The fixture observes the opaque `F0002000` handle on the real traversal path,
resolves the live `new0` target, reports its actual 1024-word span, and finds
the exact `DF000000,00000000` terminator at word index 10. The bounded copied
prefix remains pointer-free. After the registry is reset, the stale handle
produces no second capture.

This is source/fixture evidence only. It does not establish a full `ac_pc`
link or launch, a complete live game packet, GX or Metal encode/present,
pixel readback, input, audio, save/load, clean shutdown, simulator/device
behavior, or playability. A new serialized current-tip runtime trace is needed
to determine whether the observer fires in the actual game process.
