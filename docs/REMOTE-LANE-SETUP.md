# Remote focused-lane setup

This checklist is for moving future ACGC source, test, and audit lanes to the
configured remote M3 Max without moving proprietary game data or allowing two
expensive runtime attempts to overlap.

## Current prerequisite

The M3 Max is now reachable over key-only SSH through the local alias
`acgc-m3max` (`testtest@192.168.4.52`) using the dedicated local key
`~/.ssh/acgc-m3max`. A source-only checkout is present at
`/Users/testtest/Documents/Projects/acgc-modern-port` with these verified refs:

- umbrella `9b26810`
- `ACGC-PC-Port` `a53b192`
- `ac-decomp` `09ca8e8b`

The connection was verified with `ssh -o BatchMode=yes acgc-m3max
'hostname; uname -m; pwd; git --version'`, returning `macbook`, `arm64`, the
remote home directory, and Git 2.50.1. The source checkout was transferred as
three Git bundles containing tracked history only; no ISO, extracted assets,
keys, or proprietary game data were moved. Temporary remote bundles were
removed after the ref check.

The `acgc-modern-port` project is now visible in the signed-in M3 Max Codex app
and points at the source-only checkout. Its setup-only verification returned
the refs above, a clean umbrella ahead of its local `origin/main` by the
documentation commit, clean PC and decomp checkouts, and matching submodule
working-tree refs. No edit, build, test, launch, ISO, or asset access occurred.

The cross-host handoff service still reports `No matching saved project was
found on M3 Max` for the preserved lane, so the app project registry and the
remote-control handoff registry are not yet converged. Treat that as a hard
setup blocker: do not run the lane locally as a workaround and do not infer a
successful handoff from the project being visible in the remote app. Lane 115
is intentionally preserved and paused at this boundary:

- umbrella worktree: `/Users/jk/.codex/worktrees/3526/acgc-modern-port`
- PC worktree: `/private/tmp/acgc-lane-gx-v4-channel-diagnostic-3526`
- branch: `c1/lane-gx-v4-channel-diagnostic`
- base: PC `a53b192`, decomp `09ca8e8b`
- source edits, builds, tests, ISO access: none

Do not work around this by running lane 115 locally. Register the project on
the M3 Max first, then hand off the preserved task.

## Remote Codex CLI policy verification (2026-08-14)

The remote M3 Max CLI was updated with `npm install -g @openai/codex@latest`
and verified as `codex-cli 0.147.0`. Its lane sessions use
`gpt-5.6-luna` with max reasoning. Only the remote Codex approval policy was
changed, from `never` to `on-request`; its existing sandbox mode was left
unchanged. A read-only diagnostic and one source/test lane completed through
the direct remote CLI while the app handoff registry was stale. This is an
execution-path workaround, not permission to copy the ISO or extracted assets:
those remain local, and full links/LLDB launches remain in the integration
owner's serialized queue.

## Remote project contract

The saved remote project must provide:

1. The umbrella repository with its two upstream histories still represented
   as separate submodules.
2. Populated, clean source checkouts at the exact lane base. The current
   reference tip is PC `c1/macos-host-launch` `a53b192` and decomp `master`
   `09ca8e8b`.
3. A dedicated `c1/` branch and worktree for every source-edit lane. No lane
   may edit a detached submodule head or share a production-file owner.
4. A unique ignored build/log root under `/private/tmp` (or the remote host's
   equivalent ignored temporary directory).
5. A handoff record containing the base and final refs, changed files, the
   two-upstream crosswalk, exact commands/results, sanitizer status, and the
   claim boundary.

## Data and execution boundaries

- The ISO at `local/roms/Animal Crossing (USA).iso`, extracted assets, keys,
  and proprietary game data stay on this Mac. Do not copy, upload, mount, or
  sync them to the M3 Max or any cloud service.
- Focused source/test/audit work may run remotely only after the contract is
  recorded. True cloud tasks are limited to planning and review and must not
  build, launch, or access game data.
- Full `ac_pc` links and LLDB launches use one integration-owner queue shared
  across both hosts. A remote lane must wait for that queue rather than start
  a competing link or launch.
- A successful compile, link, boot, GX callback, or CPU fixture never implies
  Metal encode/present, pixel readback, input, audible audio, save/reload,
  simulator/device, or playability proof.

## Handoff sequence

1. Register/save the `acgc-modern-port` project on the M3 Max in Codex.
2. Verify the project appears in the remote Codex app **and** that the
   cross-host handoff service resolves it; do not proceed from a host-only SSH
   connection or an app-only project entry.
3. Hand off the preserved lane task and verify its worktree, branch, base refs,
   and empty unique roots before allowing edits.
4. Run only the lane's declared focused gate. Return the exact evidence to the
   integration owner.
5. Review and integrate source one commit at a time on the local umbrella;
   only then update the submodule pointer and board.
6. After holder checks and manifest recording, retire only the lane's exact
   completed worktree and generated roots. Preserve branches, evidence,
   stale-metadata boundaries, failed clones, unrelated dirty files, and the
   local ISO.
