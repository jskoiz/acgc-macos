# Root-owned live launch — 2026-08-13

## Scope and refs

This root-owned bounded run used the integrated PC source
`c1/macos-host-launch` at `f4cb491327bfdab39f1775c78cfaaa2742484e9f` and
`upstream/ac-decomp` at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. It was
performed after the earlier delegated LLDB attempts stopped before creating an
inferior because the environment rejected `nice(5)`.

## Build gate

The ignored build root was `/private/tmp/acgc-root-live-f4cb491`.

Command:

```text
env ACGC_GAME_BUILD_DIR=/private/tmp/acgc-root-live-f4cb491 \
  ./script/build_and_run_game.sh --build
```

Result:

- configure and build exited `0`;
- all `4,018` Ninja steps completed, ending with
  `[4017/4018] Linking CXX executable bin/AnimalCrossing`;
- the result was a native arm64 Mach-O executable;
- the ISO was verified against the expected SHA-256 and exposed only through
  the generated ignored `bin/rom` symlink.

The only link diagnostic was the known section-alignment warning. No source,
umbrella docs, tracked asset, or ISO bytes were changed.

## Single elevated LLDB launch

Exactly one launch was made from the generated `bin` directory with:

```text
/usr/bin/lldb -- ./AnimalCrossing --verbose
```

The local elevated shell was used solely to bypass the previously observed
pre-inferior `nice(5)` permission failure. LLDB resolved and installed
breakpoints for `pc_metal_runtime_observe`, `pc_gx_flush_vertices`, `GXBegin`,
`graph_capture_task_submission_target`, and `graph_task_set00`. The inferior
was created successfully and the runtime output showed:

- shader variants compiled and the GAFE01 FST indexed 10 files;
- 14,495 ROM-direct assets loaded, sound initialization, and the hot-start
  path into `mainproc`;
- repeated `[NEOS_OUT]` frames and `graph_proc` execution;
- an actual LLDB stop at `pc_gx_flush_vertices` (`pc_gx.c:946`).

The run was bounded after the launch/boot gate. A SIGTERM was sent to the
single inferior, LLDB was configured to pass the signal, and the process
returned through `graph_proc` before reporting exit status `0`. This is a
bounded clean-return observation, not a normal user-initiated shutdown proof.

## Evidence boundary

This run proves a current-tip arm64 launch, boot progression beyond the loader,
game-owned GX/OpenGL submission reachability, and a bounded TERM return. It
does not prove a registered Apple callback hit count, Metal encoding,
command-buffer completion, presentation, pixel readback, input, audible audio,
save/reload, simulator/device behavior, or playability. The interactive LLDB
transcript did not retain per-breakpoint hit counts, so callback reach remains
unclaimed pending a later focused capture with explicit hit logging.
