# ACGC Modern Port Guidance

## Repository boundaries

- Treat `upstream/ACGC-PC-Port` and `upstream/ac-decomp` as separate upstream
  histories represented by Git submodules.
- Do not vendor, flatten, or rewrite either upstream history.
- Put umbrella documentation, reproducible scripts, and cross-repository evidence
  in this repository. Put source changes in the owning submodule on an explicit
  topic branch.
- Never commit, upload, publish, or redistribute the ISO or extracted proprietary
  game assets. Keep them under `local/`, which is ignored by Git.

## Reference-first implementation

- Treat `upstream/ac-decomp` as the original-behavior and wire-layout oracle,
  and `upstream/ACGC-PC-Port` as the existing host implementation and Windows
  regression oracle. Record the exact commit of both references for every
  implementation lane.
- Before designing or editing a subsystem, search both upstreams for the same
  symbol, callers, data layout, tests, and platform implementation. A lane must
  cite the relevant paths and symbols from both upstreams, or explicitly record
  that one has no counterpart.
- Prefer adapting an existing, verified PC-port implementation over inventing a
  parallel implementation. Preserve decompiled game semantics when host behavior
  differs. If the references disagree, document the discrepancy and the chosen
  behavior before editing source.
- Do not introduce a new parser, address model, renderer command, audio decoder,
  save codec, or platform abstraction until the lane has shown why the existing
  implementation cannot be reused or narrowly extended.
- A crash frontier identifies where to investigate; it is not by itself a design
  specification. Characterize the guest/wire contract and add a focused
  regression fixture before landing a host-width or platform fix.

## Orchestrator and parallel lanes

- The orchestration ceiling is fifteen active visible lanes total: one
  integration/evidence owner and up to fourteen worker lanes. Fifteen is a
  ceiling, not an occupancy requirement; never create filler work to reach it.
- Keep no more than seven simultaneous production source-edit lanes. Use the
  remaining capacity for dependency-ready reference audits, narrow fixtures,
  read-only runtime traces, platform probes, and independent verification.
- Refill completed lanes promptly only when a useful successor is ready. Park or
  close lanes that are waiting on the same unresolved dependency instead of
  keeping duplicate investigations active.
- Give every source-edit lane a unique worktree, branch, production-file owner,
  and ignored build root. Two active lanes must not own the same production file
  or symbol. Test-only and read-only lanes must say so explicitly and must not
  expand into production edits.
- Serialize full `ac_pc` links, LLDB launch traces, and other expensive shared-host
  runs. Focused builds and independent read-only analysis may run in parallel
  from unique build directories.
- Before a lane is started, its task contract must name:
  1. the exact gate or question it will resolve;
  2. its dependency-ready evidence and stop condition;
  3. owned files and symbols, plus explicit out-of-scope files;
  4. the `ACGC-PC-Port` and `ac-decomp` reference paths/symbols;
  5. whether it is source-edit, test-only, verification, or read-only;
  6. the focused verification command and the claim that command can prove; and
  7. the useful successor unblocked by success.
- Count a lane as active only after it has a durable task ID, concrete worktree or
  read-only scope, and the complete task contract above. A requested task or
  client ID without an initialized worker is setup-pending, not active.
- If two lanes converge on the same blocker or proposed fix, the orchestrator
  selects one owner, transfers any unique evidence, and stops the duplicate.

## Integration discipline

- The integration owner alone updates the umbrella submodule pointer,
  cross-repository evidence, scheduler state, and current-status documentation.
  Worker lanes return commits and evidence; they do not integrate themselves.
- Every lane handoff must include its base and final commits, changed files,
  two-upstream reference crosswalk, exact commands and results, sanitizer status
  where applicable, evidence boundaries, and the next observed blocker.
- Review and integrate source commits one at a time. Re-run the smallest focused
  gate on the exact integrated source snapshot before updating the umbrella
  gitlink or marking a lane complete.
- Keep `docs/LANE-BOARD.md`, `README.md`, and milestone language synchronized
  with the integrated source pointer. Do not leave a superseded crash frontier
  described as current.
- Distinguish implementation from proof: compile, link, process launch, boot
  progress, packet capture, Metal encode/present, pixel readback, input, audible
  audio, save/reload, simulator, physical device, and human playability are
  separate gates.

## Porting posture

- Target modern macOS first as the desktop proving ground, then iOS using shared
  portable game logic and narrow platform adapters.
- Preserve deterministic game behavior while isolating renderer, windowing,
  input, audio, filesystem/save, timing, and lifecycle dependencies.
- Prefer a native Metal-capable rendering path for Apple platforms. Do not treat
  deprecated desktop OpenGL 3.3 as an iOS solution.
- Keep upstream Windows behavior working unless a scoped porting decision says
  otherwise. Avoid compatibility shims that permanently duplicate architecture.
- Do not claim a platform works from compilation alone. Separate build, launch,
  rendered-frame, input, audio, save/load, and device proof.

## Git and verification

- Before editing, verify the umbrella root, active submodule, branch, status, and
  current diff. Never edit a detached submodule HEAD.
- Use focused branches and reviewable commits in the owning repository, then
 update the umbrella submodule pointer only after verification.
- Keep generated extraction, build, cache, and log output outside Git.

## Cursor Cloud specific instructions

Cloud Agents run on **Linux x86_64**, but this project's real deliverables
(`ac_pc` game + the `pc/apple` AppKit/Metal host) are **macOS/Metal-first** and
**cannot build or run on this Linux VM**. Set expectations accordingly:

- `pc/CMakeLists.txt` hard-fails on 64-bit builds (ILP32 pointer guard) and
 `pc/apple/CMakeLists.txt` `FATAL_ERROR`s off Apple; the Metal/AppKit host,
 Metal fixtures, and `script/build_and_run*.sh` are macOS-only. The full macOS
 story (build, Metal encode/present, launch, save) must be proven on Apple
 hardware — see `docs/BOOTSTRAP-EVIDENCE.md` and `docs/REMOTE-LANE-SETUP.md`.
- The **Linux-viable dev/test surface is the portable core**:
 `./scripts/verify-portable-core.sh` (CMake + Ninja + CTest). On Linux it
 currently passes ~30/34 tests (GX canonical state, boot-source, DVD ABI, GBI
 runtime, disc parsing, JSU enums, etc.). The 4 non-runnable targets
 (`acgc_emu64_seg2k0_tests`, `acgc_pc_libc_memory_probe_cpp`,
 `acgc_jkr_aram_stream_abi_probe`, `acgc_jkr_exp_heap_probe`) fail to *compile*
 on glibc because the port's `MSL_C/string.h` redeclares libc functions with
 non-const returns that clash with glibc's C++ `const`-returning overloads.
 This is an Apple-vs-glibc header gap, **expected on Linux, not a regression** —
 do not "fix" it as part of unrelated work.
- `./scripts/verify-lifecycle.sh` is pure C11 and **passes on Linux** (real
 monotonic-clock / VI-retrace / focus / worker-shutdown / deterministic
 termination-trace logic); good quick smoke test.
- `./scripts/verify-filesystem-save.sh` and `./scripts/verify-save-gci.sh` are
 **macOS-only** (require `F_FULLFSYNC` / `xcrun`); they will not run on Linux.
- Toolchain notes: default `cc`/`c++` is **clang 18**, which selects the gcc-14
 libstdc++, so `libstdc++-14-dev` must be present; `ninja` is required for the
 `-G Ninja` builds. Both are baked into the environment snapshot.
- The two upstream submodules under `upstream/` must be initialized before any
 build; the startup update script runs `git submodule update --init` for them.
- No ISO is needed to build or run the test suites. An ISO (gitignored under
 `local/roms/`, SHA-256 pinned) is only needed to actually launch the game/host
 on macOS. Never commit or redistribute it.
