# Correctly rooted current-tip runtime successor — 2026-08-13

## Scope and refs

Lane 64 was a read-only, single-attempt successor to the lane-63 shader-path
blocker. It used the canonical populated PC source at
`c1/macos-host-launch` commit `aea35157f3175512c7643e9f32b09b68c2e05b22`
and `ac-decomp` `master` commit
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The umbrella was
`3b700a88a3d1578da31401b8ab756594b5afb002` at prelaunch; only the known
unrelated user dirt was preserved. No source, docs, gitlinks, branches, ISO, or
assets were changed by the lane.

## Build gate

The lane configured and built exactly once from the canonical PC checkout:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-correct-rooted-runtime-build \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_OSX_ARCHITECTURES=arm64 -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-lane-correct-rooted-runtime-build \
  --target ac_pc --parallel 1
```

Configure and all `4,013/4,013` build steps passed. The resulting Mach-O arm64
binary SHA-256 was
`97c04258077a94811a0fa7f312038293a393e90893d414c779ff56faf80994fe`.

## Single launch gate and blocker

The supervisor was correctly rooted at
`/private/tmp/acgc-lane-correct-rooted-runtime-build/bin`, and the generated
shaders and ignored ISO symlink were present. Exactly one LLDB session was
attempted. The command file then issued the unsupported setting
`target.process.working-dir`, and LLDB stopped before `run` with:

```text
error: invalid value path 'target.process.working-dir'
```

This is a pre-launch debugger-command blocker, not a game runtime result. No
inferior or debugserver was created; `graph_proc`, `graph_task_set00`, root
capture, live `F0002000` target capture, `GXBegin`, and any runtime fault were
not reached. The live target callback is therefore inconclusive, not negative.
No retry was made in this lane.

Termination accounting: LLDB PID `95900`, LLDB wait status `1`, supervisor exit
`0` after cleanup, no deadline, no TERM/KILL, and no surviving AnimalCrossing,
LLDB, debugserver, Ninja, CMake, or ACGC linker process.

Detailed logs were retained under
`/private/tmp/acgc-lane-correct-rooted-runtime-logs/`, including
`evidence-summary.txt`, `launch-blocker.txt`, `lldb-runtime.log`, and
`termination.log`. The exact build and log roots are eligible for retirement
after this evidence is integrated; no frame, Metal, input, audio, save/load,
device, clean-shutdown, or playability claim follows.

## Corrected successor requirement

Any next runtime lane must validate the LLDB launch command against the local
LLDB help/settings surface before consuming its one launch. It must set the
working directory through the supervisor/process invocation (or another
locally verified supported mechanism), omit the invalid setting, and preserve
the same single-run and evidence boundaries.
