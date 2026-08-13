# Current-tip live target runtime trace — 2026-08-13

## Scope

This was one read-only, serialized arm64 runtime attempt at the integrated PC
source tip. It was intended to answer only whether the live game process reaches
the graph target-capture path after the `aea3515` resolver integration. It does
not establish a complete display list, a GX submission, Metal encode/present,
pixel readback, input, audio, save/load, simulator/device behavior, clean
shutdown, or playability.

## Refs and provenance

- Umbrella preflight: `e224a458a1d3f1d44f414f5353771b514697cbfd`.
- Umbrella after the integration-owner board commit: `818572ee94a4e6b3721da20889a22b3d6adfafea`.
  The advance changed only `docs/LANE-BOARD.md`; the source gitlinks stayed
  unchanged.
- `upstream/ACGC-PC-Port`: branch `c1/macos-host-launch`,
  `aea35157f3175512c7643e9f32b09b68c2e05b22`, clean before and after.
- `upstream/ac-decomp`: branch `master`,
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`, clean before and after.

The retained ISO was exposed only through an ignored symlink under the generated
`bin/rom` directory. No ISO bytes or extracted assets were copied, printed, or
added to Git.

## Build gate

The lane configured the Darwin arm64 target from the canonical populated PC
checkout and ran the full link with one worker:

```sh
cmake -S /Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-lane-current-target-runtime-build \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_OSX_ARCHITECTURES=arm64 -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-lane-current-target-runtime-build \
  --target ac_pc --parallel 1
```

Configure passed and all `4,013/4,013` build steps, including the final
`ac_pc` link, passed. The binary was verified as a Mach-O arm64 executable with
SHA-256 `30c92df8e4e183b284ae3e0350b2ba149227794331c34ea2a8ba83587b2236cb`.
The only build diagnostic was the known alignment warning.

## Runtime gate and blocker

Exactly one LLDB launch was attempted with `ACGC_GRAPH_CAPTURE=1`,
`--verbose`, and `--no-framelimit`, under a supervisor with a 20-second deadline,
3-second TERM grace, and 1-second KILL fallback. The supervisor launched LLDB
from the delegated umbrella worktree instead of the generated binary directory.
Because the game resolves shader paths relative to its working directory, it
exited before boot with:

```text
FATAL: Could not load shader: shaders/default.vert
FATAL: Could not load shader: shaders/default.frag
FATAL: Shader files missing from shaders/ directory.
```

The generated shaders existed under
`/private/tmp/acgc-lane-current-target-runtime-build/bin/shaders/`; the launch
working-directory mismatch prevented the game from reaching `graph_proc`.
Therefore the target callback result is inconclusive, not a negative result.
No retry was made in this lane.

Termination accounting: LLDB PID `76164`, inferior PID `76210`, LLDB wait
status `0`, inferior status `1`, TERM sent `no`, KILL sent `no`, and the final
exact-process check found no `AnimalCrossing`, LLDB, or debugserver process.

Detailed retained logs are under
`/private/tmp/acgc-lane-current-target-runtime-logs/`, including
`launch-blocker.txt`, `build.log`, `lldb-runtime.log`, `supervisor.log`, and
`termination.log`.

## Next gate

The next bounded successor may perform one correctly rooted runtime attempt from
`/private/tmp/acgc-lane-current-target-runtime-build/bin`, after the integration
owner confirms the prior roots are retired. It must preserve the same single-run
and evidence boundaries and must not infer frame or playability from a successful
launch alone.
