# Post-fix game-owned GX submission trace (2026-08-12)

This read-only runtime lane used the authoritative `ACGC-PC-Port`
`c1/macos-host-launch` checkout at `09dd1827b845cd311ee0c79df2d25ac8c855e35c`
before the production CARD commit advanced that branch to `5548570`. The
reference `ac-decomp` checkout was `master`
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The source checkouts were clean;
the umbrella stale gitlink was not used. The later `5548570` change is limited
to `pc_m_card.c` and its save fixture and does not alter this graph/GX audit.

## Live capture

The serialized arm64 `ac_pc` link completed all 4,011 objects. A bounded LLDB
launch reached the live game-owned path and captured this sanitized observer
record:

```text
version=1
frame=0
source_word_capacity=256
captured_word_count=8
words[0..7] = de010000 f0002000 00000000 00000000 00000000 00000000 00000000 00000000
```

The observer is bounded to eight copied words. The count `8` is therefore not a
display-list length, and the zero words are ordinary captured values rather
than a terminator. `F0002000` remains an opaque/segmented display-list target;
the observer does not follow it. The live emu64 backtrace reaches
`emu64::dl_G_TRIN`, proving traversal reaches triangle processing, but it does
not prove a complete target list or a valid terminator.

## Renderer boundary

The sanitized LLDB markers were:

```text
first_capture_callback=pc_graph_submission_capture
first_texture_boundary=GXLoadTexObj
first_gx_boundary=GXBegin
first_renderer_boundary=pc_gx_flush_vertices
```

The observed handoff is:

```text
game-owned Gfx list
  -> emu64_taskstart
  -> GXBegin / GXEnd geometry state
  -> pc_gx_commit_pending_and_flush
  -> pc_gx_flush_vertices
  -> pc_gx_draw_pending
  -> legacy OpenGL draw call
```

This is the existing OpenGL path, not a Metal handoff. The value-only semantic
adapter and Metal packet consumer are not wired into the live graph/emu64/PC GX
path. The incomplete capture therefore fails closed at the adapter boundary.

## Focused checks and limits

- LP64 texture-pointer fixture: native PASS.
- Same texture-pointer fixture under ASan+UBSan: PASS.
- Metal packet-consumer CPU contract: PASS; runtime skip `77` because no macOS
  Metal device is available.
- LLDB stop at `pc_gx_flush_vertices` was intentional; no game crash was
  attributed to that breakpoint.
- No Metal encode/present/pixel-readback, visible current-snapshot frame,
  input, audio, save/load, simulator, device, or playability claim follows.

The temporary root `/private/tmp/acgc-lane-postfix-gx-submission` contained only
the isolated build, runtime symlink, command file, and sanitized logs. It was
retired after this evidence was recorded; no ISO bytes were copied, printed,
extracted, committed, uploaded, or deleted.
