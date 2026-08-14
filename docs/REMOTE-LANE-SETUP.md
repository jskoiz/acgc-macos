# Remote focused-lane setup

This checklist is for moving future ACGC source, test, and audit lanes to the
configured remote M3 Max without moving proprietary game data or allowing two
expensive runtime attempts to overlap.

## Current prerequisite

Codex currently knows the M3 Max host, but it does not have a saved
`acgc-modern-port` project on that host. A remote handoff cannot begin until
that project is registered and visible to Codex. Lane 115 is intentionally
preserved and paused at this boundary:

- umbrella worktree: `/Users/jk/.codex/worktrees/3526/acgc-modern-port`
- PC worktree: `/private/tmp/acgc-lane-gx-v4-channel-diagnostic-3526`
- branch: `c1/lane-gx-v4-channel-diagnostic`
- base: PC `a53b192`, decomp `09ca8e8b`
- source edits, builds, tests, ISO access: none

Do not work around this by running lane 115 locally. Register the project on
the M3 Max first, then hand off the preserved task.

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

1. Register/save the `acgc-modern-port` project on the M3 Max.
2. Verify the project appears in Codex's remote project list; do not proceed
   from a host-only connection without a matching saved project.
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

