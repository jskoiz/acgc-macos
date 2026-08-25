# ACGC rendering handoff — 2026-08-25

This is the restart-safe execution handoff for the shortest path from the
current game-owned canonical submission to a first window-backed presented
frame. It deliberately replaces broad audit/review loops with one serialized
vertical cycle:

> observe the first live failure -> implement one coherent fix -> run one
> focused gate -> obtain one independent review -> integrate when authorized ->
> run one bounded trace -> repeat

Do not create prerequisite, topology, or completeness tasks unless the live
failure cannot be resolved without one. Record P2 documentation or theoretical
coverage findings and defer them. A demonstrated live-path correctness or
safety failure is the only reason to stop the next rendered-frame step.

## Published checkpoint

The authoritative source references for this handoff are:

- umbrella base: `878c2d52ff69f48fa1fc578613af55ab52b912d1`
  (`origin/main` when this handoff branch was created);
- PC integration checkpoint:
  `e431cde18f9dc5cba1420abf11e1eaa31f4c740d` on remote branch
  `c1/metal-sink-invalid-output`;
- typed sink-rejection telemetry candidate:
  `f4f38b331eccf2dc35a7931260404206653f58ee` on remote branch
  `c1/metal-sink-reason`, based directly on `e431cde18`;
- decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`;
- prior resource-stage milestone:
  `586cf7a616cd38149c911bd4bc8fb2f1de638de4`;
- prior public PC baseline:
  `c7f835f325ea5e061f492213da9ddce5349b269d`.

The non-overlapping secure-downloader candidate is separately published at
`f6387253588427c72464776071f7e5336228a79e` on remote branch
`c1/lane-download-integrity-c7`. It is not an ancestor of the rendering
checkpoint and is intentionally not selected by the umbrella gitlink.

The PC checkpoint contains this ordered, linear chain after `c7f835f32`:

1. `fc6f0d4e0` — admit canonical Texture resources by attempt;
2. `ab7831809` — pass the resource stage to the canonical-plan fixture;
3. `ad824f24a` — stage canonical TEV output by value;
4. `bfdeefcc9` — map canonical Blend to the Metal sink;
5. `e8c4af77d` — classify canonical Alpha for the Apple sink;
6. `5b2d1b98c` — stage canonical Raster values before sink support;
7. `8f0728fae` — stage canonical Fog for the Apple sink;
8. `4b03fa86d` — support bounded dynamic Raster sink targets;
9. `cf88d169c` — tighten Raster admission shapes;
10. `d032d5603` — restore typed GX render modes;
11. `c2f8d2aab` — render canonical GX texture replacement in the Metal sink;
12. `e431cde18` — use the selected texture map's upload sizing.

The branch pushes publish source history only. They do not mean that a PC PR
exists, that anything was merged, that hosted checks ran, or that Metal/pixel/
device/playability behavior was proved.

## Exact live frontier

The latest bounded process artifact is local-only:

- report:
  `/private/tmp/acgc-v4-texture-trace-01a0352f-r27/report.json`;
- report SHA-256:
  `2d90a920c7d814b1d0f554f84516d2654e0bc6a5a3f5bd8d1dcf310c46b5c3f0`;
- exact PC source: `e431cde18f9dc5cba1420abf11e1eaa31f4c740d`;
- binary UUID: `3C20EB92-B11E-3EF6-88D8-44D3063495FC`;
- binary SHA-256:
  `c729e6cc58ff12608f4f359a414d106e48dbd317ebc8227c112d181692fe047c`;
- DWARF SHA-256:
  `dda27aa73a940fde03529bfe2e9b4fe5ed249176d5ce6877e2a7972fd5a1794f`.

One serialized attempt produced the following decision surface:

- attempt `1` completed the lifecycle
  `assigned -> resource_staged -> published -> typed_consumer -> completed`;
- all fourteen producer results were `1`;
- Texture header: active/required/known masks `0xff`, known/record count `8`,
  indexed map mask `0x01`, and TLUT-present mask `0x01`;
- map 0 was a 128x32 C4 image with 2,048 source bytes and TLUT slot 15;
  maps 1-7 were 8x4 I8 images with 32 source bytes each;
- Dynamic, borrow-lease, and value-owned resource-stage data matched attempt 1;
  image masks were `0xff`, TLUT mask was `0x8000`, and the decoded image mask
  was `0xff`;
- the typed consumer returned `0/ACGC_METAL_PACKET_CONSUMER_OK`;
- the sink was called exactly once and returned
  `3/ACGC_METAL_SINK_INVALID_OUTPUT`;
- the structured error list was empty;
- LLDB PID 28109 and inferior PID 28123 were waited and absent, the run did not
  time out, and `final_no_owned_process` was true;
- the singular generated link `bin/rom` was absent after cleanup; no plural
  `bin/roms` path was created.

This proves source/test integration through a real game-owned sink call and
identifies the first live predicate only as aggregate sink status 3. It does
not prove a successful Metal submission, command-buffer completion, pixels,
window presentation, physical-device behavior, or playability.

The focused `e431cde18` receipts are:

- native `acgc_metal_sink_tests` plus
  `acgc_pc_metal_runtime_arbitration_fixture`, `2/2`:
  `99105a16ddf4104bcfb7ea122d96f5971007c38a0a07973cdb7fde6d316cbf56`;
- combined ASan/UBSan, the same exact `2/2`, with no skip or diagnostic:
  `f23634abb9a93c17e683d6acfc04a712f99881c7480b9ef2822cab6d8bb26764`;
- independent review task `01a03976-44f8-7ed3-b4c5-5c516c595894`:
  PASS, no P0/P1.

The handoff integration owner also configured a fresh exact-detached
`e431cde18` Apple build and reran only `acgc_metal_sink_tests` plus
`acgc_pc_metal_runtime_arbitration_fixture`; both passed (`2/2`). The earlier
one-time combined sanitizer receipt was reused rather than repeated.

The selected-map sizing correction is therefore a real local correctness fix,
but r27 proves it was not the cause of the live status 3.

## Safety and evidence rules for every successor task

Every successor is one user-visible Codex task using `gpt-5.6-luna` with
thinking `max`. Give it one non-overlapping contract and do not let it delegate.
Start only the next dependency-ready task; do not keep duplicate root-cause
lanes alive.

Before editing or running, every task must record `pwd`, repository root,
branch/detached state, exact `HEAD`, `git status -sb`, current diff, the exact
PC/decomp references above or their explicitly accepted successors, and its
unique worktree/build/evidence roots.

The following constraints are invariant:

- production-file ownership is exclusive; a trace or review task is read-only;
- Texture/TLUT bytes are borrowed only during the active token and copied into
  bounded, value-owned stage storage before publication; never retain a raw
  borrow or pointer in output/telemetry;
- attempt, plan, resource stage, typed consumer, and sink result must correlate
  atomically and fail closed on mismatch;
- use the source-faithful PC/decomp crosswalk when behavior is ambiguous;
- for C/Objective-C changes involving memory, pointers, serialization,
  resource lifetime, or array bounds, run one combined ASan/UBSan gate after
  the focused native gate; do not rerun sanitizers on every integration step;
- a real-process trace owns exact LLDB/inferior PIDs, has one bounded stop,
  serializes against other full links/traces, waits/revalidates exact ownership,
  and fails if cleanup cannot prove no owned process remains;
- only the singular generated link `bin/rom` may be handled by the runner;
  never invent or clean `bin/roms`;
- never commit, upload, enumerate, traverse, read, hash, copy, or report the
  contents of proprietary asset directories; Git/evidence contains no assets;
- source, fixture, trace, sink, Metal submission, Metal completion, pixel,
  window present, physical device, and human playability are separate claims;
- no worker pushes, opens PRs, merges, deploys, or triggers paid hosted Apple
  CI unless a later active user instruction grants that exact action;
- advance the umbrella gitlink/evidence only at a meaningful milestone:
  active Texture acceptance, first sink call, first sink success, or first
  presented game-owned frame.

## Task 1 — immutable review of typed sink-rejection telemetry

The telemetry source lane is complete and published. Create this review from
the exact immutable commit and evidence below.

- **Type:** independent read-only review; no edits.
- **Exact candidate:** `f4f38b331eccf2dc35a7931260404206653f58ee` on
  `c1/metal-sink-reason`, based on `e431cde18`.
- **Candidate task:** `01a03986-610e-7ca3-ad8f-b51f493cf7d9`.
- **Owned scope:** read only
  `pc/apple/include/acgc/metal_sink.h`,
  `pc/apple/src/metal_sink.m`,
  `pc/apple/tests/test_metal_sink.m`, and
  `pc/apple/tests/test_pc_metal_runtime_arbitration.c` if changed, plus the
  local semantic harness at
  `/private/tmp/acgc-texture-harness-v4-r5-sink-reason-01a0352f`.
- **Out of scope:** production edits, full `ac_pc` link, launch/trace, umbrella,
  decomp, assets, remote actions, and broad Geometry/TEV/Indirect validation.
- **Review question:** does every existing sink INVALID_OUTPUT path map to one
  stable first-failure enum without weakening evaluation order, reading an
  array before its bounds predicate, retaining a borrow, or recording raw data?
  Does every non-INVALID_OUTPUT status reset the reason to NONE? Does the
  v4-r3 sink shape correlate exactly one status/reason result event?
- **Evidence to inspect:** exact four-file source diff; focused native receipt
  `304de0af2c70af67868dd4e2baea54bf2a1296f6946487531e8383c67e0b6202`;
  combined ASan/UBSan receipt
  `a7de64b137d4fe62c3bfc52c1eaa7428c4a96798f1e01956607d05a7a85ec94c`;
  one schema-selftest result; the nine-file v4-r3 harness at the path above;
  protected hashes `f36f9a45...` for `cleanup-selftest.zsh`, `e6887b4d...`
  for `run-trace.zsh`, and `5d963f2b...` for `trace.lldb`; and the PC/decomp
  symbol crosswalk in the source-lane handoff. Both focused CTest receipts must
  show exactly `2/2` passing with zero skipped.
- **Stop condition:** any P0/P1, unknown enum mapping, unbounded snapshot copy,
  lost atomicity, widened acceptance, protected harness drift, or source/gate
  ref mismatch. P2 documentation/naming findings are recorded and deferred.
- **Proof boundary:** review can accept attribution mechanics and fixture
  coverage only; it cannot identify the live reason or prove sink/Metal/pixel
  behavior.
- **Useful successor:** Task 2, exactly one v4-r3 bounded trace.

## Task 2 — one exact-build typed-reason trace

- **Type:** trace-only/read-only; no repository edits.
- **Dependency:** Task 1 PASS with no P0/P1.
- **Exact source:** the reviewed
  `f4f38b331eccf2dc35a7931260404206653f58ee` and decomp
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- **Owned files:** a new ignored build root, a new ignored report directory, and
  a mechanical copy of the reviewed v4-r3 harness. No source file is owned.
- **Execution:** rebind only source commit, source-tree hash, binary UUID/hash,
  DWARF hash, and new exact output paths; verify the nine-file inventory; build
  `ac_pc` once; run exactly one 20-second/one-attempt serialized LLDB trace.
- **Required report surface:** attempt ID and lifecycle; fourteen producer
  results; Texture header masks/count plus relevant records; Dynamic and borrow
  result; same-attempt value-owned resource-stage masks; typed consumer status;
  sink called/status/validation reason; empty or explicit errors; exact cleanup.
  Do not add unrelated Geometry/TEV/Indirect DWARF payloads.
- **Stop condition:** preflight drift, non-unique result event, source/binary/
  DWARF mismatch, attempt/status/reason mismatch, timeout, asset-path access,
  or inability to prove exact-PID cleanup.
- **Focused verification:** schema selftest once, harness verifier once, exact
  build once, trace once, report validation once, then hash the final report.
- **Proof boundary:** identifies one live first-failing sink predicate if the
  correlated report is valid. It does not prove the predicate's fix or Metal.
- **Useful successor:** Task 3, a source lane for exactly the emitted reason.

## Task 3 — one coherent fix for the emitted sink predicate

Instantiate this task with the exact reason and exact Task 2 source commit. Do
not guess the owner before the trace names the predicate.

- **Type:** isolated source-edit lane.
- **Exact base:** the Task 2 source commit; create a fresh `c1/` topic branch
  and exact-tip `/private/tmp` worktree.
- **Owned production files:** only the smallest files that implement the named
  predicate. For a sink-local validation/encode reason this should normally be
  `pc/apple/src/metal_sink.m` and, only if the typed value ABI must change,
  `pc/apple/include/acgc/metal_sink.h`. For a value-construction mismatch,
  transfer ownership instead to the exact producer/consumer file named by the
  source/decomp crosswalk. Never give two tasks the same production file.
- **Owned tests:** the existing focused fixture beside the owned production
  file, plus CMake registration only if no focused target already exists.
- **Required implementation:** one source-faithful behavior correction with
  focused positive and negative fixtures and any required typed telemetry in
  the same coherent commit. Preserve value ownership, first-failure reporting,
  and fail-closed mismatches. Do not simply bypass the status/reason.
- **Reference crosswalk:** cite exact PC symbols/callers and the matching
  `ac-decomp` symbols/layout, or explicitly record that the host-only behavior
  has no decomp counterpart.
- **Focused gate:** build and run only the directly affected native fixture(s)
  once. If memory, pointers, serialization, resource lifetime, or bounds are
  touched, run one combined ASan/UBSan configuration of those same tests.
- **Stop condition:** the live reason implies a different owner, the references
  disagree without a source-supported choice, the fix requires a retained
  borrow, or the focused negative fixture cannot distinguish the bug.
- **Proof boundary:** focused source/fixture correctness only. No live sink,
  Metal, pixel, or presentation claim.
- **Useful successor:** Task 4, one independent immutable review.

## Task 4 — independent review of the coherent source fix

- **Type:** read-only independent review.
- **Dependency:** Task 3 clean commit and exact receipts.
- **Owned scope:** no edits; inspect the exact base-to-candidate diff, only the
  affected PC/decomp symbols, focused receipts, and any schema compatibility.
- **Decision:** PASS only with no P0/P1. A P2 is recorded/deferred and does not
  restart the review loop.
- **Focused verification:** rerun the smallest native regression only if the
  supplied receipt is missing, mismatched, or non-reproducible. Do not repeat
  sanitizers merely for review when their exact one-time receipt is valid.
- **Stop condition:** widened acceptance, unsafe lifetime/bounds behavior,
  missing negative control, ref mismatch, or a false-green test.
- **Proof boundary:** review acceptance only; no runtime claim.
- **Useful successor:** integrate only under active authorization, then Task 5.

## Task 5 — one bounded post-fix trace

- **Type:** trace-only/read-only.
- **Dependency:** authorized integration of the Task 4-accepted commit.
- **Execution:** mechanically rebind the already-reviewed minimal harness to the
  exact integrated source/binary/DWARF; build once; run one serialized bounded
  attempt; require exact-PID and singular-link cleanup.
- **Decision:** if a new typed sink reason is first, return to Task 3 with that
  one reason. If the sink returns OK, record the first sink-success milestone
  and proceed to Task 6. Do not add a duplicate root-cause task.
- **Proof boundary:** sink OK means only that the game-owned typed output was
  accepted/submitted at the sink boundary. Command completion, pixels, window
  presentation, physical device, and playability remain unproved.

Repeat Tasks 3-5 only against the next demonstrated first-failing predicate.
Do not advance umbrella evidence for every microscopic correction; advance it
at first sink success.

## Task 6 — first window-backed game-owned presentation

Create this task only after a bounded trace proves sink OK. Substitute the
exact sink-success source commit for `<SINK_OK_COMMIT>` in its prompt.

- **Type:** one coherent source-edit lane; no separate topology audit.
- **Exact base:** `<SINK_OK_COMMIT>` and decomp
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- **Owned production files:**
  `pc/apple/include/acgc/metal_sink.h`,
  `pc/apple/src/metal_sink.m`,
  `pc/src/pc_main.c`, and the exact Apple membership block in
  `pc/CMakeLists.txt`. Own no canonical producer/consumer files.
- **Owned tests:** `pc/apple/tests/test_metal_sink.m` and one existing or new
  narrow host-window/drawable fixture registered in `pc/apple/CMakeLists.txt`
  only if needed.
- **Implementation contract:** attach the game process's real window-backed
  Metal drawable boundary to the existing sink; encode the already-owned typed
  output into that drawable; present exactly once per accepted game-owned
  submission; keep offscreen focused tests; make drawable absence/size/lifetime
  failure explicit and fail closed; do not introduce a second renderer or
  duplicate canonical ABI.
- **Lifetime rules:** no borrowed drawable/texture survives its command-buffer
  ownership window; shutdown cannot race a queued submission; no game resource
  pointer is stored in telemetry.
- **Focused gate:** narrow native sink/host fixture once, plus one combined
  ASan/UBSan run of the C/Objective-C lifetime/bounds fixtures. Do not launch
  the game in this task.
- **Stop condition:** window access requires an unsafe cross-thread object,
  presentation would bypass game-owned sink correlation, or a second
  architectural renderer becomes necessary. Report the concrete blocker.
- **Proof boundary:** source and fixture readiness for a window-backed present,
  not a real presented frame or pixel.
- **Useful successor:** Task 7 independent review.

## Task 7 — independent window-presentation review

- **Type:** read-only independent review; no edits or launch.
- **Exact candidate:** the Task 6 commit against `<SINK_OK_COMMIT>`.
- **Review focus:** drawable ownership, command-buffer/presentation ordering,
  shutdown/race behavior, game-owned attempt correlation, fail-closed missing
  drawable/size paths, and preservation of offscreen fixtures/Windows build
  membership.
- **Decision:** no P0/P1; record/defer P2. Reuse valid focused and sanitizer
  receipts instead of creating a second immutable review.
- **Proof boundary:** accepted source, not live presentation.
- **Useful successor:** Task 8, one bounded real-process presentation trace.

## Task 8 — one bounded first-present trace

- **Type:** trace-only/read-only.
- **Dependency:** Task 7 PASS and authorized integration.
- **Required telemetry:** exact game attempt and sink call; command-buffer
  creation/commit/completion status; drawable acquisition; exactly one
  `presentDrawable` request correlated with that game-owned submission; window
  dimensions; exact errors; exact-PID/singular-link cleanup.
- **Execution:** one exact build and one bounded serialized run. Do not add
  pixel readback unless presentation itself succeeds; do not infer pixels from
  a present request.
- **Stop condition:** any mismatch, completion error, no drawable, no present,
  timeout, or cleanup failure becomes the next single demonstrated blocker.
- **Proof boundary:** a successful correlated command completion and present
  request is the first window-backed game-owned presented-frame milestone. It
  still does not identify pixel content, physical-device behavior, or
  playability.
- **Useful successor:** one separate bounded pixel/readback task, then later
  physical-device and human-playability tasks. Do not combine those claims.

## Deferred non-rendering lane

The secure-downloader work remains separate. Final candidate `f63872535`
changes only the coherent downloader/configuration/test chain from baseline
`c7f835f32`; final independent review task
`01a0356e-1b0f-7560-a551-f43f488b18f3` reported PASS with no actionable P1.
Its 70 downloader-integrity tests had no failure in the review archive, while
the combined command returned nonzero because the archive lacked `.git` for
the separate Git-dependent ignore cases. The review did not rerun. This proves
local source plus POSIX and injected/fake-Windows behavior only, not native
Windows/NTFS, network acquisition, payload execution, hosted state, PR, merge,
or release. Recovery-root documentation and native Windows proof are deferred.

Any continuation must own no rendering production file and must not consume
the serialized link/trace slot. Neither downloader completeness nor native
Windows proof may block the rendering critical path unless a demonstrated live
rendering dependency requires it.

## Remote-action boundary

This handoff authorizes no successor task to push, open or update a PR, merge,
deploy, or run paid hosted Apple CI. Those are integration-owner actions that
require the active user's exact authorization. Local source/test/trace evidence
must remain separate from remote branch, hosted check, merged, device, pixel,
and playable states.
