# Valid-LLDB live target runtime trace — 2026-08-13

## Scope and refs

Lane 65 was a read-only, single-attempt runtime gate after two earlier
pre-launch blockers. The canonical populated sources were:

- `upstream/ACGC-PC-Port`, branch `c1/macos-host-launch`,
  `aea35157f3175512c7643e9f32b09b68c2e05b22`, clean.
- `upstream/ac-decomp`, branch `master`,
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`, clean.
- Umbrella integration-owner tip at review time: `ba38b6b`; the lane's
  delegated worktree was a detached historical umbrella snapshot and made no
  repository changes.

No source, docs, gitlinks, branches, ISO, or extracted assets were changed by
the lane. The retained ISO was exposed only through an ignored symlink under
the generated `bin/rom` directory.

## Build gate

Because prior binaries were stale relative to the source tip, the lane ran one
fresh canonical configure and one serial build:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-valid-lldb-runtime-build \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_OSX_ARCHITECTURES=arm64 -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON
ninja -C /private/tmp/acgc-lane-valid-lldb-runtime-build -j 1 ac_pc
```

Configure passed and all `4,013/4,013` build steps, including the final link
and shader copy, passed. The only diagnostic was the known alignment warning.
The resulting `AnimalCrossing` binary is arm64 Mach-O with SHA-256
`83e7540a2f2b72b49fd7bada08954837aa798651bda365db1f955de2b987fadc`.
Generated `default.vert` and `default.frag` matched their canonical source
hashes byte-for-byte.

## Live runtime evidence

The supervisor and LLDB both used cwd
`/private/tmp/acgc-lane-valid-lldb-runtime-build/bin`. The supported LLDB
setting `target.launch-working-dir` was syntax-checked before launch; the
unsupported `target.process.working-dir` setting was not used. Exactly one
bounded launch ran with `ACGC_GRAPH_CAPTURE=1` and `--verbose --no-framelimit`.

Observed boundaries:

- `graph_proc` at `graph.c:486`.
- Inlined `graph_task_set00` at `graph.c:196`.
- Root graph submission at `graph_submission.c:225`, source capacity `256`,
  frame `0`, first words `DE010000 F0002000 ...`.
- Root capture record: version `2`, eight captured words, classification `6`
  (`INDIRECT`), terminator index `0xffffffff` (none), with the same eight-word
  prefix as prior runs.
- Live target call at `graph_submission.c:277`: identity `0xF0002000`, target
  pointer `0x1016e7be0`, capacity `1024`, frame `0`.
- The observed target extent began `DB060000 80000000 DE010000 F0002001`.
  No exact `DF000000 00000000` pair appeared in the observed 1024-word extent.
  The optional target-capture callback therefore did not emit a runtime target
  classification/terminator record; no callback was injected.
- `GXBegin` was independently hit from `emu64::dl_G_TRIN` (primitive `144`,
  vertex format `0`). `pc_gx_flush_vertices` was hit from
  `pc_gx_commit_pending_and_flush`, also through `emu64::dl_G_TRIN`.
- The runtime loaded shaders, indexed the ISO, extracted DOL/REL data, reported
  `14495` ROM-direct assets, and reached logo rendering. No `EXC_BAD_ACCESS`,
  fatal runtime fault, or crash was observed before the bounded termination.

This is the first current-tip live game-owned target/GX boundary evidence, but
it is not proof of a complete display list, Metal encode/present, pixel
readback, input, audible audio, save/load, simulator/device behavior, clean
shutdown, or playability.

## Termination

- LLDB PID `12777`; debugserver PID `12818`; game PID `12817`.
- Deadline reached at 20 seconds; TERM sent to all three exact PIDs.
- All exited within the 3-second grace period; KILL fallback was not used.
- LLDB wait status `143`; clean game exit was not observed.
- Final exact-comm process check found no AnimalCrossing, debugserver, LLDB,
  Ninja, or CMake process.

Detailed logs were retained under
`/private/tmp/acgc-lane-valid-lldb-runtime-logs/`, including the runtime log,
syntax check, build/configure logs, and termination ledger. The exact build and
log roots are eligible for retirement after this evidence is integrated.

## Next gate

The next bounded implementation/evidence lane should consume the live target
and GX boundary facts to resolve the missing target terminator and bind a
complete game-owned submission to the Apple renderer. Until that occurs, this
run must remain classified as launch/boot/live-target/GX-boundary evidence only.
