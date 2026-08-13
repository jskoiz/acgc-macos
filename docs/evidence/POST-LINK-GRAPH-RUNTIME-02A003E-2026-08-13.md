# Exact-tip post-link graph runtime trace (2026-08-13)

This is the current-tip successor to the earlier `9cf9b3f` trace. It used the
authoritative PC source `02a003e5c9917861cfc1faed51face26dee6f98f` on
`c1/macos-host-launch`, decomp `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`,
and umbrella `b48f646078048814ad1623116b2738b613a39290`. The source and both
submodules were clean before and after the run; no source, umbrella, ISO, or
asset files were edited.

## Build and launch

- `cmake` configure: exit `0`.
- Serialized `ac_pc` link: exit `0` (`4013/4013`), producing an arm64
  `AnimalCrossing` Mach-O.
- The prior `ac39d04` and `71a7012` generated trees were not launched and were
  retained as quarantined generated-only roots.
- One bounded LLDB launch used the existing disc only through an ignored
  `bin/rom/Animal Crossing (USA).iso` symlink, with `ACGC_GRAPH_CAPTURE=1`,
  `--verbose`, and `--no-framelimit`.

## Runtime result

The game reached the real boot and graph path:

- `[PC] boot: calling sound_initial...`, `JW_Init2`, and `HotStartEntry`;
- `mainproc: calling graph_proc directly (single-threaded)`;
- `[GRAPH_CAPTURE] callback=enabled`; and
- one game-owned capture with `captured=8`, `source_capacity=256`, and
  `de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000`.

The recorded root is `INDIRECT`, not `COMPLETE`: `0xDE010000` is the G_DL
branch opcode and `0xF0002000` is the opaque PC registry handle. No target-list
capture, target frame/register dump, or separately resolved target was seen, so
the target did not reach either `COMPLETE` or runtime `PREFIX_ONLY` status. The
configured `GXBegin` and `pc_gx_flush_if_begin_complete` breakpoints resolved
during setup, but no LLDB stop reason, frame, or register output independently
proves a direct GX entry hit.

There is no complete packet → encode → present → readback chain. This run makes
no rendered-frame, Metal-device, pixel, input, audio, save/load, simulator,
physical-device, clean-shutdown, or playability claim.

## Termination and retained evidence

The supervisor sent TERM at its bounded deadline; LLDB KILL was not required.
The inferior briefly remained as the exact recorded command-line PID `44492`,
was verified and sent TERM, and exited during the three-second grace period;
no KILL was required and no game or LLDB process remains. Because the debugger
and inferior were terminated by the bounded supervisor, this is not a general
clean-shutdown proof.

Authoritative generated evidence is retained outside Git:

- `/private/tmp/acgc-lane-exact-tip-runtime-logs/evidence-summary-02a003e.txt`
- `/private/tmp/acgc-lane-exact-tip-runtime-logs/lldb-02a003e.log`
- `/private/tmp/acgc-lane-exact-tip-runtime-logs/classifier-02a003e.txt`
- `/private/tmp/acgc-lane-exact-tip-runtime-logs/termination-02a003e.txt`
- `/private/tmp/acgc-lane-exact-tip-runtime-build`

The next bounded frontier is a live resolver observer around the
`graph_task_set00`/`emu64::dl_G_DL` transition: retain the opaque target
identity and capacity while the registry is live, call the target-capture seam,
and require the exact `DF000000,00000000` terminator before forwarding anything
to GX or Metal.
