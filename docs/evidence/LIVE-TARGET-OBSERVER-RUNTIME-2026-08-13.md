# Live target observer runtime — 2026-08-13

## Scope and identities

Lane 68 performed one correctly rooted, read-only arm64 runtime verification at
the integrated umbrella `ec189997a6dab0e72380eb19ef2a8970d2c2d06b`, canonical
PC source `36910c8a9e3abbc013b39978fe52022b933aff01`, and `ac-decomp`
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. It did not edit source/docs or
integrate a pointer. The ignored ISO was verified against the expected
SHA-256 and was exposed only through an ignored runtime symlink.

## Build and launch

The lane configured once and ran one serialized `ninja -C ... -j 1 ac_pc` in
`/private/tmp/acgc-lane-live-target-observer-runtime-build`. Configure and
build exited `0`, and the produced binary was arm64 Mach-O. The terminal Ninja
progress line for the executable link/shader-copy edge was `[4012/4013]`; no
literal `[4013/4013]` line was emitted. This is recorded as a progress-counter
caveat, not a failed build. The only linker diagnostic was the known
section-alignment warning.

The local LLDB setting check accepted `target.launch-working-dir` and pointed it
at the generated `bin` directory. Exactly one bounded launch ran with
`ACGC_GRAPH_CAPTURE=1 --verbose --no-framelimit` from that directory. At the
20-second deadline the supervisor sent TERM to LLDB, debugserver, and the game;
the three-second grace completed without KILL (`lldb_wait_status=143`,
`term_sent=1`, `kill_sent=0`). The final process check was empty.

## Fresh game-owned target record

Boot reached shader loading, ISO indexing, DOL/REL loading, 14,495 ROM-direct
assets, `graph_proc`, and logo execution. The root callback emitted:

```text
[GRAPH_CAPTURE] callback=enabled
[GRAPH_CAPTURE] version=2 frame=0 source_capacity=256 captured=8 words=de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000
```

The new Apple target observer then emitted:

```text
[GRAPH_TARGET_CAPTURE] version=1 frame=0 target=f0002000 target_capacity=1024 captured=8 classification=6 terminator=4294967295 words=db060000,80000000,de010000,f0002001,00000000,00000000,00000000,00000000
```

The source contract maps classification `6` to `INDIRECT`; terminator
`4294967295` is the no-terminator sentinel. `F0002001` is present in the
bounded target words, proving that the live continuation handle was observed.
This closes the “observer installed but unobserved” gap and supplies the first
fresh game-owned target continuation record.

The LOGO actor progressed through actions `0 → 1 → 2 → 3`, and NEOS markers
reached at least frame `781`. This is boot/target-observation evidence only.
The launch produced no `GXBegin` or `pc_gx_flush_vertices` markers; because
the lane did not install GX breakpoints, GX status is `UNOBSERVED`, not
inferred.

## Evidence boundary

This run does not prove a complete display list or terminator across the child
arena, GX/Metal encode or present, pixel/readback, input, audible audio,
save/load, device persistence, clean game exit, simulator/device behavior, or
human playability. The run was intentionally terminated at the bounded
deadline. Retained logs are under
`/private/tmp/acgc-lane-live-target-observer-runtime-logs/`:
`build.log`, `lldb-runtime.log`, `supervisor.log`, `termination.log`,
`lldb-syntax.log`, and `final-process-check.txt`.
