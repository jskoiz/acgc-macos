# ACGC visible lane board

Updated 2026-08-24. The fourteen prior durable visible Luna/max worker tasks
were archived during the requested stale-task cleanup. Visible-task creation
remains account-quota-gated until the reported 2026-08-26 reset. The active
integration owner is using at most three bounded internal collaboration workers
under the current four-slot runtime cap; those workers are not represented as
replacement visible tasks. Source PRs, merges, and exact-tip verification
remain serialized, and completed workers are refilled only for concrete,
dependency-ready work. The current canonical PC tip is `dabc78208`; see
`docs/evidence/TYPED-CHANNELS-DABC78208-2026-08-24.md`.
The historical entries below remain evidence records; an old task described as
active does not imply that its gate passed or that it is active now.

## 2026-08-22 cumulative-publication orchestration

| Lane | Kind | Current state | Exact contract/result |
| --- | --- | --- | --- |
| 260 | Source-edit | Complete and integrated | The corrected three-commit chain ending at `27e16b460` passed final Lane 286 review, was integrated as `00d06cc20` + `168d713ba` + `f140aa186`, and merged in [PC PR #5](https://github.com/jskoiz/ACGC-PC-Port/pull/5) as `c91873521`; exact-merge native and ASan/UBSan gates passed. |
| 261 | Source-edit | Complete and integrated | Registered the source-backed Geometry dependency fixture; candidate `35c0dd350` merged in [PC PR #4](https://github.com/jskoiz/ACGC-PC-Port/pull/4) as `f77d5ec86`, then passed the exact-merge focused CTest gate. |
| 262 | Source-edit | Complete and integrated | Reviewed assembler chain `7acc786e7` + `ded31c017` + `81995528a` was integrated as `1d3a51485` + `46eee8c75` + `cfb61d67d` and merged in [PC PR #6](https://github.com/jskoiz/ACGC-PC-Port/pull/6) as `c7ce553d7`; exact-merge native and ASan/UBSan gates passed. |
| 263 | Read-only review | Complete | Found exact-token ownership, mutation-coverage, and public-builder lifetime defects in successive lease candidates; corrections were accepted by final Lane 286 review. |
| 264 | Read-only oracle/review | Complete | Froze explicit little-endian envelope transport, bounds, corruption, output-immutability, and maximum-size expectations used by the corrected assembler review. |
| 265 | Read-only/test-only review | Complete | Verified the Geometry dependency target's source, definitions, links, native gate, and sanitizer gate without expanding production membership. |
| 266 | Read-only audit | Complete | Mapped all fourteen sections and proved that only Channels, Lighting, and Alpha are fully linked into `ac_pc`; none is production-flush-called, while Texture/Dynamic are only conditionally called with missing canonical links. |
| 267 | Read-only audit | Complete | Froze the raw-state freeze, dependency-topological build, lease revalidation, fixed-order envelope, final revalidation, and single-publication order. |
| 268 | Read-only audit | Complete | Located the future gatherer immediately after completed Geometry capture in `pc_gx_flush_vertices`, before the existing Texture/Dynamic callback, observers, and legacy path. |
| 269 | Read-only audit then source-edit | Complete and integrated | Parser `6ae7aec1d` plus corrective child `6410b40fb` was integrated as `33843a6ee` + `9c7603c55` and merged in [PC PR #7](https://github.com/jskoiz/ACGC-PC-Port/pull/7) as `8e55df64e`; exact-merge native and ASan/UBSan gates passed. |
| 270 | Read-only audit | Complete | Mapped the current Apple sink as position/color/limited-transform only; no cumulative plan or fourteen-section render capability is claimed. |
| 271 | Test-only verification | Complete | Lane 277 reran the exact-`f77d5ec86` focused matrix: 41/41 registered executable tests and 11/11 object targets passed in native and combined ASan/UBSan roots. |
| 272 | Read-only audit | Complete | Fixed-width leaf contracts passed the bounded portability audit, while pointer leases, cumulative parsing, production wiring, and real Windows targets remain separately unproved. |
| 273 | Read-only integration review | Complete | Ranked lease before assembler before parser/consumer, with one source PR, exact merged-tip gate, and umbrella pointer update serialized at each accepted step. |
| 274 | Read-only successor | Complete | Defined the smallest Geometry production source/library prerequisite without confusing production linkage with production calls. |
| 275 | Read-only successor | Complete | Defined the grouped all-section production object topology, canonical library bundle, raster definition, and duplicate-symbol hazards later implemented by Lane 293. |
| 278 | Source-edit corrective child | Complete and integrated | `ded31c017` closes the assembler output-size alias corruption and adds a formula-backed assertion for the 76,092-byte public maximum; integrated equivalent `46eee8c75` is in PC PR #6. |
| 280 | Independent review | Complete, PASS | Re-reviewed the corrected assembler chain with no P0/P1/P2 blocker and fresh native plus ASan/UBSan execution. |
| 282 | Test-only CMake source edit | Complete and integrated | `81995528a` registers `acgc_pc_gx_cumulative_snapshot_fixture`; integrated equivalent `cfb61d67d` is in PC PR #6 after Lane 285 PASS. |
| 283 | Source-edit corrective child | Complete and accepted | `27e16b460` removes the unsafe auto-borrowing public builder and requires caller-owned active-token lifetime through consume, revalidate, and release. |
| 284 | Source-edit corrective child | Complete and integrated | `6410b40fb` enforces canonical metadata for all sections, including Fog 80/1/1, and explicit canonical mask mapping; integrated equivalent `9c7603c55` is in PC PR #7. |
| 285 | Independent review | Complete, PASS | Accepted `81995528a`; repeated canonical archives are a warning-only transitive-link-graph observation, not a duplicate-definition failure. |
| 286 | Independent review | Complete, PASS | Accepted the final lease chain with no P0/P1/P2 finding under the documented synchronous single-threaded guarded-API contract. |
| 287 | Independent re-review | Complete, PASS | Confirmed the corrected parser closes the Fog 80/1/1 metadata blocker, preserves exact canonical order/masks and output immutability, and passes fresh native plus ASan/UBSan. |
| 288 | Read-only integration audit | Complete, PASS | Proved the accepted assembler chain applies cleanly to `c91873521`, has no lease-API dependency, and changes exactly its three files plus CMake registration. |
| 289 | Immutable umbrella review | Complete, PASS | Accepted the Texture/TLUT lease umbrella commit and exact focused native plus sanitizer roots before umbrella PR #4. |
| 290 | Immutable umbrella review | Complete, PASS | Accepted the cumulative assembler umbrella commit and exact focused native plus sanitizer roots before umbrella PR #5. |
| 291 | Read-only integration audit | Complete, PASS | Proved the corrected parser chain applies cleanly to `c7ce553d7`, matches the landed assembler directory contract, and has no lease or production dependency. |
| 292 | Immutable umbrella review | Complete, PASS | Accepted the Apple parser umbrella commit `a71890569` with exact four-path scope and no P0/P1/P2 finding before umbrella PR #6. |
| 293 | Source-edit | Complete and integrated | Added the ten standalone producers/assembler to one unconditional production OBJECT target, enabled Raster, and propagated all canonical libraries; candidate `acee7d71d` merged in [PC PR #8](https://github.com/jskoiz/ACGC-PC-Port/pull/8) as `52019da76`. |
| 294 | Independent review | Complete, PASS | Accepted `acee7d71d` with no P0/P1 finding after fresh native and ASan/UBSan object builds, generated-link-graph inspection, symbol uniqueness checks, and a serialized 4,064-step candidate-tree `ac_pc` link. |
| 295 | Read-only gatherer audit | Complete, BLOCK then dependency closed | Froze the lease-owning, single-publication gatherer contract and found twelve missing explicit little-endian encoders. PC PRs #9-#12 close exactly that prerequisite; live gathering remains separate. |
| 296 | Immutable umbrella review | Complete, PASS | Accepted production-topology umbrella commit `cf2e2900e` before umbrella PR #7, with exact pointer/evidence scope and no P0/P1 blocker. |
| 297 | Source-edit | Complete and integrated | Added explicit Transform, Channels, and Lighting encoders in candidate `134296f35`; Lane 301 passed it and [PC PR #9](https://github.com/jskoiz/ACGC-PC-Port/pull/9) merged it as `29fa239a6`. |
| 298 | Source-edit | Complete and integrated | Added explicit Blend, Alpha, Depth, Raster, and Fog encoders in candidate `a80c4d909`; Lane 304 passed it and [PC PR #11](https://github.com/jskoiz/ACGC-PC-Port/pull/11) merged it as `51f8c791c`. |
| 299 | Source-edit | Complete and integrated | Added explicit Texture and Dynamic encoders in candidate `5a66938de`; Lane 302 passed it and [PC PR #10](https://github.com/jskoiz/ACGC-PC-Port/pull/10) merged it as `24c1f6b8a`. |
| 300 | Source-edit | Complete and integrated | Added explicit TEV and Indirect encoders in candidate `3a29fe8b9`; Lane 303 passed it and [PC PR #12](https://github.com/jskoiz/ACGC-PC-Port/pull/12) merged it as `670d7128f`. |
| 301 | Independent review | Complete, PASS | Accepted the Transform/Channels/Lighting encoder candidate with no P0/P1 finding after source, contract, and focused native/sanitizer evidence review. |
| 302 | Independent review | Complete, PASS | Accepted the Texture/Dynamic encoder candidate with no P0/P1/P2 finding, including fixed-size encoding, padding, alias, failure-immutability, and lease-boundary review. |
| 303 | Independent review | Complete, PASS | Accepted the TEV/Indirect encoder candidate with no P0/P1/P2 finding; the fixture refactor retained validation coverage and the explicit encoders fail closed. |
| 304 | Independent review | Complete, PASS | Accepted the fixed-state encoder candidate with no P0/P1 finding after exact-domain, little-endian, alias, padding, and failure-immutability review. |
| 305 | Source-edit successor | Complete and integrated | Added the lease-owning fourteen-section cumulative gatherer and focused fixture in candidate `ac4237eec`; Lane 308 passed it and [PC PR #13](https://github.com/jskoiz/ACGC-PC-Port/pull/13) merged it as `d6a22182b`. It intentionally does not wire `pc_gx_flush_vertices`. |
| 306 | Immutable umbrella review | Complete, PASS | Accepted encoder umbrella commit `d98e1bf9b` with exact pointer/evidence scope before umbrella PR #8. |
| 307 | Read-only Apple plan audit | Complete, BLOCK with bounded successor | Found the typed Apple CPU plan still needs twelve fixed-section little-endian decoders, a full Geometry stream decoder, and pure dependency derivation; it defined a pure-C successor without claiming Metal or runtime readiness. |
| 308 | Independent gatherer review | Complete, PASS | Accepted `ac4237eec` with no P0/P1 blocker, including one-borrow cleanup, fourteen-section order, callback-time fail-closed registration, output immutability, and retained native plus ASan/UBSan evidence. |
| 309 | Read-only flush-integration audit | Complete, READY | Located exactly one gather attempt after completed Geometry capture, required removal of the older live Texture/Dynamic-only publication, froze file-static non-reentrant storage ownership, and designed the real GXBegin/GXEnd source-backed fixture. |
| 310 | Source-edit successor | Complete and integrated | Added one guarded cumulative gather attempt at the completed-Geometry flush seam plus a source-backed fixture in `c2f557e34`; corrective child `a986c7007` closes callback lifecycle/reentrancy findings. Lane 314 passed the final chain and [PC PR #14](https://github.com/jskoiz/ACGC-PC-Port/pull/14) merged it as `1c8781d76`. |
| 311 | Immutable umbrella review | Complete, PASS | Accepted gatherer umbrella candidate `19b76cce` with exact pointer/evidence scope before umbrella PR #9. |
| 312 | Independent flush review | Complete, BLOCK resolved | Blocked the first Lane 310 commit on stale callback/context and callback-time lifecycle reset/reentrancy hazards; `a986c7007` closes each finding. |
| 313 | Source-edit Apple plan successor | Complete and integrated | Added the pure-C, value-owned all-section Apple canonical plan in `a497ed0d2`; corrective child `deaaa6431` repairs the fixture's false-green failure propagation and canonical setup. Lane 318 passed the final chain and [PC PR #15](https://github.com/jskoiz/ACGC-PC-Port/pull/15) merged it as `2d4bc2b7e`. |
| 314 | Independent flush re-review | Complete, PASS | Accepted `c2f557e34` + `a986c7007` with no P0/P1/P2 finding, including guarded lifecycle reset, non-reentrant callback contract, one publication per successful flush, older callback suppression, and legacy continuation. |
| 315 | Immutable umbrella review | Complete, PASS | Accepted flush umbrella candidate `f45bbdb7` with exact four-path scope, retained native/sanitizer/full-link evidence, and no P0/P1/P2 finding before umbrella PR #10. |
| 316 | Read-only Apple handoff audit | Completed without durable handoff | The worker returned no usable report, so no source decision or readiness claim relies on this lane. Lane 321 later froze the contract and Lane 324 implemented the independently reviewed successor. |
| 317 | Independent Apple plan review | Complete, BLOCK resolved | Found the initial plan fixture false-green: invalid Texgen setup failed before the builder while `CHECK` returned process success. It accepted the static four-path/pure-value scope but withheld executable proof. |
| 318 | Independent Apple plan re-review | Complete, PASS | Accepted `a497ed0d2` + `deaaa6431` after direct PASS-sentinel execution and exact native plus ASan/UBSan parser/plan `2/2`; no remaining P0/P1/P2 finding. |
| 319 | Immutable umbrella review | Complete, PASS | Accepted Apple-plan umbrella candidate `bc901db4c` with exact four-path scope, current merged-tip native and ASan/UBSan `2/2`, and no P0/P1/P2 finding before umbrella PR #11. |
| 320 | Read-only successor | Completed without durable handoff | The worker returned no usable report; no lifecycle, callback, or source decision relies on it. |
| 321 | Read-only callback-to-plan audit | Complete, READY | Froze a process-lifetime same-owner adapter: build synchronously inside the envelope lifetime, retain only the value plan, preserve the prior plan on rejection, and clear before invalidation and GX shutdown. |
| 322 | Read-only successor | Completed without durable handoff | The worker returned no usable report; no source decision or proof claim relies on it. |
| 323 | Verification successor | Completed without durable handoff | The worker returned no usable report; exact merged-tip gates were performed and recorded by the integration owner instead. |
| 324 | Source-edit Apple handoff | Complete and integrated | Added the lifecycle-owned callback-to-plan adapter, focused fixture, production Apple source membership, and `pc_main` ordering in candidate `4f327606e`; [PC PR #16](https://github.com/jskoiz/ACGC-PC-Port/pull/16) merged it as `a4ee15c1d`. |
| 325 | Read-only downstream audit | Completed without durable handoff | The worker returned no usable report; no Metal-consumer or runtime-readiness claim relies on it. |
| 326 | Independent Apple handoff review | Complete, PASS | Accepted `4f327606e` with no P0/P1 after fresh native and ASan/UBSan parser/plan/handoff `3/3`, normal-library build, production compile-graph review, lifecycle/failure inspection, and two bounded P2 maintenance notes. |
| 331 | Source-edit canonical-plan packet consumer | Complete and integrated | Added a pure bounded adapter from the normalized Apple plan to the existing Metal packet-consumer output in `b74e2f8d9`; corrective child `a13af24ba` closes exact near/far validation and synthetic-provenance findings. [PC PR #17](https://github.com/jskoiz/ACGC-PC-Port/pull/17) merged the chain as `bd660f754`. |
| 333 | Independent packet-consumer review | Complete, BLOCK resolved | Blocked the first candidate because it omitted the downstream sink's exact `0.0/1.0` near/far requirement and reconstructed synthetic Geometry/VCD/VAT provenance after normalization. Both P1 findings are removed by `a13af24ba`. |
| 336 | Independent packet-consumer re-review | Complete, PASS | Accepted the corrected chain with no P0/P1 after fresh native and ASan/UBSan canonical plus four neighboring consumer tests passed `5/5`, direct PASS execution, ABI/layout review, and confirmation that runtime remains unwired. |
| 337 | Read-only producer-reachability audit | Complete, PASS-CONDITIONAL; successor closed | Found a static setter/producer route for the no-`PNMTXIDX` three-vertex subset and confirmed that explicit `PNMTXIDX` is optional but currently rejected by raw Geometry. Lane 338 supplies the required source-backed composition proof for that narrow subset. |
| 338 | Test-only source edit | Complete and integrated | Added a real-setter, real-`GXBegin`/`GXEnd` no-`PNMTXIDX` POS+CLR0 round-trip fixture in `2e20eaa47`; [PC PR #18](https://github.com/jskoiz/ACGC-PC-Port/pull/18) merged it as `818bfe547`, and exact-merge native plus ASan/UBSan execution passes `1/1`. No production source or runtime wiring changed. |
| 341 | Independent round-trip review | Complete, PASS | Accepted `2e20eaa47` with no P0/P1/P2 finding after exact two-file scope, real setter provenance, callback/borrow failure recovery, false-green, duplicate-object, and retained native/sanitizer review. |
| 342 | Immutable umbrella review | Complete, PASS | Accepted umbrella candidate `ab4635f3e` with exact four-path scope, retained exact-merge native/sanitizer evidence, synchronized claims, and no P0/P1/P2 finding before the umbrella PR. |
| 343 | Read-only runtime-freshness audit | Complete, BLOCK with successor closed | Proved the prior handoff retained the last successful plan, made failed/no-publication attempts invisible, and could not distinguish canonical output from semantic V1 at the sink. Froze process-lifetime attempt identity, all-attempt completion, borrowed-plan delivery, source-aware eligibility, and same-attempt fallback/suppression. |
| 344 | Source-edit runtime arbitration | Complete and integrated | Added cumulative attempt IDs and post-borrow completion, atomic callback-pair registration, borrowed canonical-plan consumption, source-aware winner/fallback policy, and the CPU-only arbitration fixture in `23b97e75d`; [PC PR #19](https://github.com/jskoiz/ACGC-PC-Port/pull/19) merged it as `928594a26`. Exact-merge native PC `3/3`, Apple `4/4`, combined ASan/UBSan `3/3` + `4/4`, and one serialized 4,078-item `ac_pc` link passed. |
| 347 | Independent runtime-arbitration review | Complete, PASS | Accepted `23b97e75d` with no P0/P1 blocker after adversarial attempt/fallback/reentry/lifecycle review, fresh native and ASan/UBSan matrices, production-object and generated-link checks, and four bounded P2 maintenance notes. |
| 348 | Immutable umbrella review | Complete, PASS | Accepted umbrella candidate `8f3d6261d` with exact four-path `+302/-23` scope, correct PC/decomp pins, authoritative PR #19 metadata, retained native and ASan/UBSan `3/3` + `4/4`, verified arm64 `NOUNDEFS` artifact/symbols, and no P0/P1 or new umbrella P2 finding. |
| 349 | Projection integration replay | Complete and integrated | Replayed the accepted projection behavior onto `de9a26fee` as source commit `1c1d2d171`; [PC PR #24](https://github.com/jskoiz/ACGC-PC-Port/pull/24) merged it as `ff09b1f22`. |
| 350 | Post-Texgen trace classifier | Complete | Accepted the bounded exact-`7636cc1d8` trace as 20/20 success through Texture/Dynamic followed by 20/20 TEV failure and no publication; it did not diagnose the source predicate. |
| 351 | Independent integration reviews | Complete, PASS | Accepted exact Apple Geometry merge `de9a26fee` and later authorized PC PR #24 after immutable four-path, hosted-boundary, and retained focused-proof review. |
| 352 | Projection current-tip semantic review | Complete, PASS | Accepted finite perspective/orthographic reconstruction, singular fail-closed state, real 16.16 packing, and the instrumented zero-texture-call boundary. |
| 353 | Typed-result corrective contract | Complete; successor active | Froze the enum-to-legacy callback mapping amendment now owned by Lane 373 on a fresh `ff09b1f22` worktree. |
| 354 | Typed-result ABI/merge review | Complete; successor active | Established the non-overlapping five-file replay order, borrow cleanup, callback compatibility, and two-fixture gate now re-audited by Lane 374. |
| 355 | TEV predicate trace | Complete; source owner selected | A one-attempt exact-binary trace found the first TEV short circuit at `register[0].known_mask != 0x0F`, with actual mask zero. Unique source evidence was transferred to Lane 364. |
| 356 | Apple umbrella evidence crosswalk | Complete and integrated | Supplied synchronized PC PR #23, exact-merge focused, and no-Metal/no-pixel claims used by umbrella PR #19. |
| 357 | Final trace unwind integrity | Complete | Verified attempt ordering, stop, exact-PID cleanup, and no-publication semantics without expanding into a duplicate TEV investigation. |
| 358 | Projection fixture-topology review | Complete, PASS | Accepted real `guMtxF2L`/`mtxutil` inclusion, strict undefined-symbol closure, instrumented texture-boundary zero calls, and no dead-strip false green. |
| 359 | Reusable CMake topology audit | Complete; successor active | Froze the first reusable target/helper partition; Lane 375 refreshes it at `ff09b1f22` while shared CMake ownership remains parked behind TEV. |
| 360 | Apple PR #23 hosted audit | Complete, PASS | Verified exact refs/files/stats plus absent repository workflows and separated local focused proof from hosted state. |
| 361 | Apple umbrella topology audit | Complete, PASS | Accepted the reviewed four-path Apple Geometry umbrella scope before umbrella PR #19 merged as `b381bb444`. |
| 362 | TEV readiness audit | Complete; ownership transferred | Converged the TEV root-cause and source-fidelity prerequisites, then transferred sole production ownership to Lane 364; no duplicate TEV source owner remains. |
| 363 | Projection PC integration | Complete and integrated | Source commit `1c1d2d171` merged through PC PR #24 as `ff09b1f22`; fresh exact-merge native and combined ASan/UBSan builds each discover and pass `1/1` focused projection test. |
| 364 | Sole TEV source owner | Complete and integrated | Replayed the source-order unavailable-register/KColor provenance fix onto exact `ff09b1f22` as candidate `520c7afaf`; [PC PR #25](https://github.com/jskoiz/ACGC-PC-Port/pull/25) merged it as `70a8e23bc`. Exact-merge native and ASan/UBSan raw-shadow/producer gates pass `2/2`. |
| 365 | Projection exact-merge review | Complete, PASS | Accepted exact merge `ff09b1f22` with no P0/P1, the exact four-path `+296/-4` scope, retained exact-source native and sanitizer `1/1`, zero repository workflows/check runs, and authorization for a separately reviewed umbrella integration. |
| 366 | TEV fixture oracle | Completed without durable handoff | Worker turns ended without a usable report and the focused follow-up was rejected by the usage ceiling. No decision relies on this lane; the independent candidate review separately covered selector mapping and retained one non-blocking component-selector coverage P2. |
| 367 | Projection umbrella evidence | Completed without durable handoff | Worker turns ended without a usable report and the refill was quota-rejected. The integration owner created the evidence from exact PR/merge objects and fresh roots, then obtained a separate immutable review. |
| 368 | Projection artifact audit | Completed without durable handoff | Worker turns ended without a usable report. Exact source identity, flags, logs, hashes, and sanitizer diagnostics were rechecked by the integration owner and independent review. |
| 369 | Apple Geometry tip audit | Completed without durable handoff | Worker turns ended without a usable report; no new Apple Geometry claim relies on this lane. The already integrated `de9a26fee` proof remains unchanged. |
| 370 | Apple consumer contract | Completed without durable handoff | Worker turns ended without a usable report; no future consumer design or readiness claim relies on this lane. |
| 371 | Post-TEV trace protocol | Completed without durable handoff | Worker turns ended without a usable report. The next trace remains owner-serialized with exact source/binary identity, bounded attempts, and exact-PID cleanup. |
| 372 | Projection hosted audit | Completed without durable handoff | Worker turns ended without a usable report. Live PR #24 state and zero-workflow exposure were independently rechecked before projection umbrella integration. |
| 373 | Typed gatherer result replay | Setup incomplete; quota-blocked | Worker turns ended without a durable source handoff and the replay retry was quota-rejected. No typed-result commit is integrated; this lane remains subordinate to the post-TEV trace. |
| 374 | Typed replay audit | Completed without durable handoff | Worker turns ended without a usable report; no ABI or integration decision relies on this lane. |
| 375 | Reusable CMake topology | Completed without durable handoff | Worker turns ended without a usable report; no shared CMake refactor is claimed or integrated. |
| 376 | Texture frontier refresh | Completed without durable handoff | Worker turns ended without a usable report; no later-producer reachability claim relies on this lane. |
| 377 | TEV gate topology review | Completed without durable handoff | Worker turns ended without a usable report and the refill was quota-rejected. Exact target/link closure and focused commands were verified on the candidate and exact merge by the integration owner. |
| 378 | Projection umbrella immutable review | Complete, PASS | Independently accepted umbrella commit `7c1afd0a3` with exact four-path scope, synchronized claims, PC `ff09b1f22`, unchanged decomp pin, retained focused native/sanitizer evidence, and no P0/P1 before [umbrella PR #20](https://github.com/jskoiz/acgc-macos/pull/20) merged as `a1d86575a`. Not counted as a replacement visible task. |
| 379 | TEV candidate immutable review | Complete, PASS | Independently accepted exact candidate `520c7afaf` with no P0/P1; retained a non-blocking P2 for non-exhaustive KColor component-selector table coverage and preserved the focused CPU-only boundary. Not counted as a replacement visible task. |
| 380 | TEV PC integration | Complete and integrated | PC PR #25 merged candidate `520c7afaf` onto `ff09b1f22` as `70a8e23bc`; exact first-parent scope is three paths `+434/-15`, and fresh exact-merge native plus ASan/UBSan target-only gates pass `2/2`. |
| 381 | TEV umbrella integration | Complete and integrated | Independent review accepted the four-path umbrella candidate `2d8b7288c`; [umbrella PR #21](https://github.com/jskoiz/acgc-macos/pull/21) merged it as `962737ede`, pinning PC `70a8e23bc` with synchronized README, lane board, and evidence. |
| 382 | Stale task/worktree cleanup | Complete, continued | Archived all fourteen prior visible worker tasks and later archived the superseded pinned predecessor integration task. The registered passes removed 65 clean/integrated worktrees plus one broken decomp registration; the latest conservative pass moved 23 explicitly audited superseded `/private/tmp/acgc-*` roots to macOS Trash and removed one additional merged worktree registration. Current candidates, exact-merge proof roots, populated oracles, dirty/unique objects, and this task's active worktree remain preserved. Git-backed removals are reproducible; the latest temporary-root removals are recoverable from Trash. |
| 383 | Canonical baseline source owner | Complete and integrated | Reproduced the registered root round-trip failure at exact `70a8e23bc`, repaired dormant Texgen and disabled `COLOR0A0` acceptance, added typed section rejection, repaired the multi-vertex false-green helper plus negative control, and merged candidate `5c62286b7` through [PC PR #26](https://github.com/jskoiz/ACGC-PC-Port/pull/26) as `da96bf622`. |
| 384 | Baseline semantic/source reviews | Complete, PASS | Two independent read-only reviews found no P0/P1: canonical validation plus zero active Texgens is safe only inside the retained Geometry/Texture/TEV no-consumption predicates; disabled channel controls match PC and decomp/J2D. The root fixture remains J2D-style rather than a claim of an exact full J2D TEV selector contract. |
| 385 | Baseline immutable review | Complete, PASS | Accepted exact candidate `5c62286b7`, parent `70a8e23bc`, clean four-path `+421/-148` scope, append-only legacy status ABI, input/output immutability, and retained root `1/1` plus Apple `8/8` native and combined-sanitizer evidence with no P0/P1. |
| 386 | Baseline PC exact-merge verification | Complete, PASS | PC merge `da96bf622` has exact parents `70a8e23bc` and `5c62286b7`, no workflows/check runs, and the exact four-path scope. Fresh exact-merge root native/ASan gates pass `1/1`; fresh Apple native/ASan matrices pass `8/8`; no sanitizer finding was observed. |
| 387 | Post-baseline trace contract | Complete, READY | Froze one serialized exact-merge `ac_pc` full link plus a 60-second/20-attempt LLDB trace with symbol-by-name resolution, typed consumer status mapping, exact-PID cleanup, and a stop at the next first-failing producer or one real cumulative publication. No process or asset was touched by the audit. |
| 388 | Proprietary-disc ignore hygiene | Complete and integrated | Replayed the narrow policy on exact `da96bf622` as `3eed70d30`, retained the one-path 12-line scope and 24 representative positive controls, passed independent immutable review and live pre-push checks, and merged it through [PC PR #27](https://github.com/jskoiz/ACGC-PC-Port/pull/27) as `503194ff2`. No disc image was added, removed, moved, hashed, or published. |
| 389 | Supply-chain and verification audit | Candidate reviewed; replay queued | Found P1 mutable/unhashed binary and `ultralib/main` downloads. Exact-`621a4d548` replay candidate `2f4e278aa` changes four files, pins the ultralib revision, validates sizes/SHA-256, stages archives safely, and supports a verified offline cache; independent review passed, 13/13 tooling tests pass, and root plus Apple native/ASan gates pass. It must be replayed and rerun on the current PC tip after the live Texgen path. |
| 390 | Exact-baseline full link and live trace | Complete, PASS to publication | Serialized exact `da96bf622` into a 15,313,376-byte arm64 binary with SHA-256 `e0e358b3a432178a30a49105a7582984da2930432fbee07994a50977aba1bc01`. One bounded real attempt passed all fourteen producers, returned gather success, notified attempt 1, and dispatched the Apple callback. No Metal/device/pixel claim follows. |
| 391 | Live Apple-plan discriminator | Complete | Envelope parsing, every non-Geometry plan validator, canonical Geometry validation, and the first position/normal/color values passed. The first TEX0 scalar failed: descriptor source U16/fraction 0/value-encoding 1 supplied canonical word `0x43800000`, which Apple reinterpreted as raw U16 and rejected with typed `GEOMETRY_LIMIT`. Texgen is not the blocker. |
| 392 | Apple Geometry-plan source owner | Complete and integrated | Candidate `35a26c658` changes only Apple plan decoding and the source-backed root fixture, consumes `value_encoding=1` Geometry words once, and covers integer POS/TEX0, integer NRM, and packed RGB565. Independent review passed, and [PC PR #28](https://github.com/jskoiz/ACGC-PC-Port/pull/28) merged it as `6c5a626d9`. |
| 393 | Canonical verification runner | Complete and integrated | Corrected runner `35734a491` is merged through [umbrella PR #27](https://github.com/jskoiz/acgc-macos/pull/27) as `1c0763ef8`. It fail-closes on the wrong/attached/dirty PC root and existing build roots, covers the exact root `1/1` and Apple `4/4` native plus combined-ASan/UBSan matrix with serialized builds, and passed independent immutable review. This Channels integration advances its exact expected PC pin to `dabc78208` and reruns the fresh matrix. |
| 394 | Immutable public-download manifest data | Complete, read-only | Downloaded the 28 current public tool archives/executables and six exact-commit ultralib headers into a private temporary cache without execution; recorded exact URLs/asset IDs, sizes, SHA-256 values, safe archive-member inventories, header source/final hashes, and unsupported Darwin Orthrus. Publisher corroboration remains absent for binutils, sjiswrap, Orthrus, and the compiler archive; no repository or proprietary asset was touched. |
| 395 | Geometry-plan immutable and exact-merge gates | Complete, PASS | Independent review found no P0/P1/P2 and confirmed one-pass canonical words without weakening address/index/matrix/immutability checks. Exact merge `6c5a626d9` has the reviewed two-path scope; fresh merge-tip native and combined ASan/UBSan roots each discover exactly Test #39 and pass `1/1`. |
| 396 | Post-Geometry bounded live trace | Complete; typed frontier identified | Exact `6c5a626d9` linked a 15,264,720-byte arm64 binary with SHA-256 `b6d8dd31ba26f4a45679ffd6fe7caf33f2e63a04d76aeefc30b966dd247b2088`. One bounded attempt passed all fourteen producers, gather, publication, callback dispatch, and Apple plan construction; typed status 13 rejected a 51-vertex triangle list with `POS|NRM|CLR0|TEX0`, and the sink was not entered. Exact PID cleanup passed; no Metal/pixel claim follows. |
| 397 | Typed Geometry source owner | Complete and integrated | Candidate `9161049d6` validates the exact live `POS|NRM|CLR0|TEX0` shape, finite canonical NRM/TEX0 words, and bounded ordinary matrix selectors while retaining POS+CLR0-only renderer output and fail-closed wider-state rejection. [PC PR #29](https://github.com/jskoiz/ACGC-PC-Port/pull/29) merged it as `d40ca1c2c`. |
| 398 | Typed Geometry immutable and exact-merge reviews | Complete, PASS | Independent review found no P0/P1/P2. Fresh exact-merge Apple consumer and source-backed root fixtures each discover and pass `1/1` in native and combined ASan/UBSan trees with serialized builds; no full exact-`d40ca1c2c` process, Metal, pixel, or device proof follows. |
| 399 | Logical RGBA8 fixture correction | Complete and integrated | The verification matrix exposed two stale Apple plan expectations that decoded already-canonical logical RGBA8 words a second time. Independently reviewed replay `b716a46db` merged through [PC PR #30](https://github.com/jskoiz/ACGC-PC-Port/pull/30) as `621a4d548`; exact-merge Apple plan and root round-trip fixtures each discover and pass `1/1` natively and under combined ASan/UBSan. Production source is unchanged. |
| 400 | Active Texgen consumer predicate audit | Complete; sole source owner appointed | All production Texgen builders/validators and Apple plan construction pass. The only production owner is `pc/apple/src/metal_packet_consumer.c`; no duplicate Texgen edit may proceed. The source/oracle audit and immutable trace review converged, and the follow-up field capture supplied record 1 plus ordinary selector 30 without inference. |
| 401 | Exact-`621a4d548` full link and Channels trace | Complete; typed frontier identified | The serialized exact-tip arm64 link passed. One bounded attempt passed all fourteen producers, gather, publication, callback, Apple plan, and Geometry, then returned typed Channels status 15. The captured live mode is one `COLOR0` REG/REG channel with mask 7, `DF_CLAMP`/`AF_NONE`, disabled REG/VTX alpha, ambient `0x00965050`, material `0xffffffff`, and loaded lights mask 7. No sink/Metal/pixel claim follows. |
| 402 | Active Channels source owner and PC integration | Complete and integrated | Candidate `25195dfd8` adds only the exact observed AF_NONE CPU-lighting mode and its focused fixture, with normal/light validation, deterministic vertex-RGB materialization, preserved vertex alpha, failure immutability, and no output-ABI or sink expansion. Independent review passed; [PC PR #31](https://github.com/jskoiz/ACGC-PC-Port/pull/31) merged it as `dabc78208`, and fresh exact-merge Apple/root native plus ASan/UBSan gates each discover and pass `1/1`. |
| 403 | Exact-`dabc78208` full link and Texgen traces | Complete; typed frontier advanced and fields closed | The exact merge completed a 4,077-step arm64 link. One 60-second/one-attempt LLDB run passed all fourteen producers, plan build, gather, publication, callback, Geometry, and Channels; published/consumer plan SHA-256 values match. Typed status 16 rejects active Texgen count 2. A second one-attempt field-completion trace on the same exact binary captured record 1 and ordinary selector 30 in raw and canonical state; it did not change the frontier. Neither run called the sink or left a watchdog/PID alive. |
| 404 | Texgen predicate and trace reviews | Complete, PASS; sole source lane active | The independent source/oracle audit plus both exact-trace reviews found no P0/P1 blocker. The integration owner transferred their unique evidence and the completed-field trace to exactly one source owner for `pc/apple/src/metal_packet_consumer.c` and its existing fixture. Duplicate Texgen investigations are stopped. |
| 405 | Nested ROM ignore policy | Candidate; clean exact merge-tree gate | Local candidate `f690adbf8` adds only mixed-case recursive `.iso`/`.gcm`/`.ciso` ignore rules under any `rom` directory, with positive/nonmatch checks, zero tracked-image matches, and focused native/ASan fixture passes. Independent review found no patch defect; exact `git merge-tree --write-tree --messages dabc78208 f690adbf8` succeeded with synthetic tree `190030c10a520f73104440d7873488d4ad686d28`. It remains unpushed for ordered replay after the Texgen owner stabilizes. No image was read, moved, deleted, hashed, or published. |

PC PR #20 fixes the LP64 N64 matrix payload at source commit `5a8a686a5`
and merges it as `2f944f1ae`. Exact-merge native and ASan/UBSan
`acgc_gbi_runtime_tests` pass `1/1`. A bounded content-identical
source-tree launch reaches 20 cumulative attempts: Transform and Channels pass
`20/20`, Texgen fails `20/20`, and no envelope or canonical sink submission
occurs. This moves the live frontier; it does not prove publication, Metal,
pixels, or playability.

PC PR #21 repairs only the test-only
`acgc_pc_gx_transform_raw_shadow_fixture` dependency closure. Candidate
`6ea409b8b` changes `pc/CMakeLists.txt` by 14 insertions and merges as
`b18aa8e92`. Fresh exact-merge native and combined ASan/UBSan configuration,
serial target build, one-test discovery, and exact CTest each pass `1/1`;
no production source, `ac_pc` membership, launch, renderer, Metal, device, or
playability claim follows.

PC PR #22 restores source-faithful Texgen identity provenance at the GX
initialization boundary. Candidate `5032a36bf` changes exactly `pc_gx.c`, the
two existing Texgen fixtures, and their test-only CMake closure, then merges as
`7636cc1d8`. The independent source review passed with no P0/P1/P2 finding.
Fresh exact-merge native and combined ASan/UBSan builds discover exactly the
raw-shadow and producer tests and pass `2/2` each. A pre-fix bounded process
trace established `GX_PTIDENTITY`'s entirely unknown slot as Texgen's first
predicate. A separate post-fix exact-binary trace now passes Texgen and
Texture/Dynamic `20/20`, fails TEV `20/20`, and publishes no envelope. The
runtime result is not a PR #22 fixture claim and does not prove callback,
Metal/device, pixel, or playability behavior.

PC PR #23 expands only the Apple canonical Geometry replay path. Candidate
`25ff63fca` changes exactly seven Apple paths and merges as `de9a26fee` with
`+500/-67`. Canonical triangle lists and quads are bounded to 192 renderer
vertices; quads expand as `0,1,2,0,2,3`; legacy V1/V2 remains exactly three
vertices. The independent source and exact-merge reviews found no P0/P1.
Fresh exact-merge native and combined ASan/UBSan target builds each complete 61
steps, discover exactly eight selected Apple tests, and pass `8/8`. This is
CPU/offscreen source-backed proof only: no full `ac_pc` link at `de9a26fee`,
live Apple callback, Metal/device, pixel, or playability claim follows.

PC PR #24 corrects finite `emu64` projection reconstruction and adds one
focused Apple-host CPU fixture. Candidate `1c1d2d171` changes exactly
`src/static/libforest/emu64/emu64.c`, `pc/portable/CMakeLists.txt`, and two new
portable test sources, then merges as `ff09b1f22` with `+296/-4`. The extra
`+1` in the far-plane inverse is removed; derived values stage before state
mutation; singular/infinite-far input fails closed; real 16.16 conversion,
orthographic classification, prior-state immutability, and zero texture calls
are covered. Fresh exact-merge native and combined ASan/UBSan target builds
each complete 15 steps, discover exactly one test, and pass `1/1`. This is a
focused CPU contract only: no full `ac_pc` link, process launch, TEV repair,
cumulative publication, Apple callback, Metal/device, pixel, or playability
claim follows.

PC PR #25 repairs source-order handling of unavailable TEV register/KColor
provenance. Candidate `520c7afaf` changes exactly `pc/CMakeLists.txt`,
`pc/src/pc_gx_tev_producer.c`, and its focused producer fixture, then merges as
`70a8e23bc` with `+434/-15`. Exact untouched unavailable records may be
represented as zero only when no active stage reads them before a matching
color or alpha definition; malformed, partially known, and contradictory
records remain fail-closed. The independent immutable review found no P0/P1
and retained one non-blocking component-selector table-coverage P2. Fresh
exact-merge native and combined ASan/UBSan builds each complete 61 steps,
discover exactly the raw-shadow and producer tests, and pass `2/2`. No full
`ac_pc` link, process launch, post-fix producer frontier, cumulative
publication, Apple callback, Metal/device, pixel, or playability claim follows.

PC PR #26 repairs the registered canonical CPU baseline without changing a
producer, gatherer, flush call, renderer, or Metal sink. Candidate `5c62286b7`
changes exactly the Apple consumer header/implementation, its focused fixture,
and the source-backed root round-trip fixture, then merges as `da96bf622` with
`+421/-148`. Legacy consumer status values `0..12` remain unchanged; canonical
section rejections are appended and returned at the first predicate. The
bounded resource-free consumer now accepts canonical-valid dormant Texgen
selector/matrix/SU provenance only when the active count is zero and the
existing Geometry, Texture, and TEV predicates prove it unconsumed. It accepts
the disabled `COLOR0A0` REG/VTX/no-light/no-diffuse/no-attenuation controls used
by GX initialization/J2D. The multi-vertex helper now returns failure to its
caller and a bit-corruption negative control proves that path is test-red.
Fresh exact-merge native and combined ASan/UBSan roots discover and pass the
root fixture `1/1`; fresh Apple roots discover and pass the selected matrix
`8/8`, with no sanitizer findings. This is focused CPU proof only: no full
`ac_pc` link, process launch, live publication, exact full J2D TEV selector,
target-sized raster/depth support, Metal/device, pixel, or playability claim
follows.

PC PR #8 adds production compilation/link membership for every standalone GX
producer and the cumulative assembler, plus Raster and the complete canonical
library graph. Fresh native and combined ASan/UBSan object builds passed on the
authoritative merge `52019da76`; a serialized 4,064-step arm64 `ac_pc` link
passed on the reviewed candidate tree, whose content is identical to the merge.
The PR does not add a gatherer, lease transaction, flush call, callback, parser
consumer, or renderer behavior. No hosted workflow was configured, and no
process launch, cumulative publication, Metal/device, pixel, input, audio,
save/load, or playability claim follows.

PC PRs #9-#12 add the twelve explicit little-endian section encoders that the
Lane 295 gatherer audit identified as missing; Geometry and Texgen already had
encoders. At authoritative merge tip `670d7128f`, the exact twelve-test matrix
passes `12/12` in fresh native and combined ASan/UBSan trees. A fresh serialized
4,050-step arm64 `ac_pc` link also passes at that exact tip and produces a 14 MiB
arm64 Mach-O executable. The link emitted only the inherited common-section
alignment reduction warning. This proves encoder contracts and production link
compatibility, not process launch, live gathering, callback publication,
Apple/Metal consumption, pixels, device behavior, or playability.

PC PR #13 adds the lease-owning cumulative gatherer to the production GX object
and a focused source-backed fixture. At authoritative merge tip `d6a22182b`,
the exact gatherer CTest passes `1/1` in fresh native and combined ASan/UBSan
trees. A fresh serialized 4,025-item `ac_pc` build also links a 15,213,680-byte
arm64 Mach-O containing both gather and assemble symbols. The gatherer fixture
proves raw builders, explicit encoders, fourteen-section assembly, one
synchronous envelope-only callback, failure immutability, and Texture/TLUT
borrow cleanup/reuse. It does not prove a live flush call, legacy GL execution,
process launch, Apple/Metal consumption, pixels, device behavior, or
playability.

PC PR #14 calls that gatherer once from `pc_gx_flush_vertices` immediately
after completed Geometry capture. It removes the older live
Texture/Dynamic-only publication from that seam, keeps fixture/semantic/legacy
ordering intact, uses file-static aligned storage, rejects callback-time nested
gather/registration/clear and GX lifecycle mutation, and clears callback/context
at normal lifecycle boundaries. At authoritative merge tip `1c8781d76`, the
exact flush CTest passes `1/1` in fresh native and combined ASan/UBSan trees. A
fresh serialized 4,025-item `ac_pc` build links a 15,177,520-byte arm64 Mach-O
containing callback registration/clear, gather, and assemble symbols. This
proves the source-backed production flush contract and production link, not a
real-process callback, launch, Apple plan/Metal consumption, pixels, device
behavior, or playability.

PC PR #15 adds a pure-C Apple canonical CPU plan library and focused fixture.
The plan structurally parses one cumulative envelope, explicitly decodes and
validates all fourteen sections, normalizes at most 128 Geometry vertices,
derives cross-section dependencies, rejects unsupported BUMP and invalid
resource metadata, and writes one pointer-free value plan only after complete
success. The initial independent review blocked a false-green fixture and
invalid Texgen setup; corrective child `deaaa6431` makes failures exit nonzero
and repairs every subsequently exposed malformed fixture mutation. At
authoritative merge tip `2d4bc2b7e`, fresh native and combined ASan/UBSan roots
build 37 steps, direct execution prints the PASS sentinel, and exact parser plus
plan CTests pass `2/2` in each root. At the PR #15 tip, the plan remained outside
`ac_pc`, callback, runtime, and Metal targets; that PR alone made no live
delivery, production link, launch, GPU, pixel, device, or playability claim.

PC PR #16 adds one process-lifetime Apple plan handoff, registers it after
`pc_gx_init`, builds synchronously within the cumulative envelope callback
lifetime, retains only the last successful value plan, preserves that plan on
rejection, and clears the callback before invalidating state and shutting down
GX. At authoritative merge tip `a4ee15c1d`, fresh native and combined
ASan/UBSan roots build the normal library plus parser/plan/handoff fixtures;
direct handoff execution prints the PASS sentinel and the exact matrix passes
`3/3` in both roots. A fresh serialized 4,078-step `ac_pc` build also links a
15,245,936-byte arm64 Mach-O containing the handoff, plan builder, callback
registration, gatherer, and assembler symbols. The independent review found no
P0/P1; the local callback-ABI redeclaration must track future ABI changes, and
repeated unpaired GX reinitialization remains outside the documented one-owner
lifecycle. This proves focused ownership/failure behavior and production link,
not process launch, real game callback delivery, Metal consumption, pixels,
device behavior, input/audio/save, iOS, or playability.

PC PR #17 adds a pure canonical-plan prepare path beside the existing semantic
packet-consumer path. It accepts only one value-owned, resource-free,
three-vertex triangle with the documented transform/color/TEV/raster subset,
requires exact `0.0/1.0` near/far values, rejects aliases and non-finite or
unsupported state, and publishes output only after complete validation. The
first independent review blocked synthetic Geometry/VCD/VAT reconstruction and
the missing near/far predicate; corrective child `a13af24ba` deletes that
reconstruction, adds the exact checks, and appends source provenance without
moving existing output fields. At authoritative merge tip `bd660f754`, fresh
native and combined ASan/UBSan roots build 53 steps and the canonical fixture
plus four neighboring consumer fixtures pass `5/5` in each root. A fresh
serialized 4,078-item `ac_pc` target also links a 15,323,616-byte arm64 Mach-O
containing both prepare paths, the Apple plan builder, and the cumulative
gatherer. This proves the bounded pure adapter and production link, not live
handoff/runtime arbitration, process launch, Metal encode/present/readback,
pixels, device behavior, input/audio/save, iOS, or playability.
Lane 337 independently traced every accepted predicate through raw
initialization/setters and classified the no-`PNMTXIDX` subset as statically
compatible but not yet composed.

PC PR #18 closes that narrow composition gate without changing production
implementation. Its focused fixture configures the known-state subset through
real GX setters, emits one direct POS+CLR0 triangle with real
`GXBegin`/`GXEnd`, and synchronously traverses cumulative gather, explicit
encoding/assembly, Apple structural parsing, normalized plan construction, and
canonical-plan packet preparation. It also proves consumer-output immutability,
unregistered-callback no-op behavior, zero publication on composition failure,
borrow release, callback clear/re-registration, and a valid retry. At
authoritative merge tip `818bfe547`, fresh native and combined ASan/UBSan
65-step target builds pass; exact CTest discovery finds only the named fixture
and it passes `1/1` in both roots. The two-file `+810/-0` change is test-only
under the Apple compile-audit/CTest condition; no production source, runtime
arbitration, process delivery, Metal encode/present/readback, pixel, device,
asset, input/audio/save, iOS, or playability claim follows.

PC PR #19 closes the source-only runtime-arbitration gate. Each production
flush attempt receives a nonzero process-lifetime ID; publication or
no-publication is reported exactly once after the Texture/TLUT borrow ends. The
Apple adapter clears stale plans, exposes a successful plan only as a
synchronous borrowed callback, and distinguishes `NO_PUBLICATION`,
`PLAN_REJECTED`, and `PLAN_PUBLISHED`. The runtime accepts canonical output only
with canonical source provenance, semantic version zero, and zero extension
statuses. A successful canonical sink submission suppresses later semantic
callbacks for that attempt only; gather, plan, prepare, and sink failures retain
semantic V1 fallback, while V2/V3/V4 policy remains fail closed. At authoritative
merge tip `928594a26`, fresh native PC `3/3` and Apple `4/4` matrices pass; the
same `3/3` + `4/4` pass under combined ASan/UBSan with no diagnostics. A fresh
serialized 4,078-item `ac_pc` link produces a 15,458,528-byte arm64 Mach-O with
`NOUNDEFS` and strong cumulative/handoff/runtime symbols. No process was
launched, no asset was accessed, and no game-owned callback, Metal encode,
present/readback, pixel, device, input/audio/save, iOS, or playability claim
follows.

PC PR #20 closes the LP64 N64 matrix wire-layout fault. Source commit
`5a8a686a5` changes only `include/PR/gbi.h` and the focused GBI runtime
fixture; merge `2f944f1ae` passes fresh native and combined ASan/UBSan
`acgc_gbi_runtime_tests` `1/1` on the exact integrated snapshot. A full
`ac_pc` affected rebuild linked on the source commit whose tree is identical
to the merge. A bounded real inferior reached 20 gather attempts with Transform
and Channels succeeding `20/20`; Texgen failed `20/20`, all attempts
reported `NO_PUBLICATION`, and no later encoder, assembler, callback, or sink
submission occurred. This proves a moved runtime frontier, not successful
delivery, Metal, pixels, input/audio/save, iOS, or playability.

## 2026-08-21 orchestrated canonical-producer batch

| Lane | Kind | Final state | Exact result |
| --- | --- | --- | --- |
| 241 | Source-edit, then dependency-ready successor | Complete and integrated | Blend candidate `07a621428` passed lane 249 review and merged in PC PR #1 as `f772f0bb8`. The same durable task later produced the reviewed Fog chain ending at `e0bb5ac96`. |
| 242 | Source-edit | Complete and integrated | Geometry dependency-result chain ending at `09d174799` passed lane 250 review and merged in PC PR #3 as `4cbb837e6`. |
| 244 | Read-only producer audit, then Fog review | Complete | Mapped all fourteen producer ABIs, identified the missing cumulative publication boundary, blocked the first Fog candidate on four concrete issues, and passed corrected `e0bb5ac96`. |
| 245 | Read-only atomic resource-lease audit | Complete, successor ready | A dedicated lease implementation is dependency-ready; cumulative publication remains blocked until one envelope-scoped acquire/revalidate/release contract exists. |
| 246 | Read-only cumulative assembler contract | Complete, implementation blocked | Froze a fourteen-section, `0x3fff` full-mask build order and 76,092-byte maximum envelope. Implementation still depends on atomic lease publication and production-ready section inputs. |
| 247 | Read-only Apple consumer audit | Complete, implementation blocked | Defined the pure-C Metal-independent consumer boundary; implementation waits for the cumulative assembler and lease predecessor. |
| 249 | Independent Blend oracle/review | Complete, PASS | Exhaustively checked 4,096 valid Blend tuples, sticky invalidity, exact domains, and flush ordering for `07a621428`. |
| 250 | Independent Geometry oracle/review | Complete, PASS | Verified source-backed direct and INDEX16 Geometry, Transform/Texgen/Channels/Lighting dependencies, isolated failure fixtures, and native plus ASan/UBSan execution for `09d174799`. |

Requested lane numbers 243 and 248 remained setup-pending client requests with
no durable task ID or initialized worker. They performed no work, owned no
files, and are not active lanes.

The integration owner opened and merged three source PRs against
`c1/macos-host-launch`: Blend
[`#1`](https://github.com/jskoiz/ACGC-PC-Port/pull/1), Fog
[`#2`](https://github.com/jskoiz/ACGC-PC-Port/pull/2), and Geometry dependencies
[`#3`](https://github.com/jskoiz/ACGC-PC-Port/pull/3). The exact merged tip
passed the focused native and combined ASan/UBSan Blend/Fog CTest gates and the
source-backed Geometry fixture. No full `ac_pc` link, LLDB launch, callback,
Metal/device, pixel, input, audio, save/load, or playability claim follows.

The post-pause host cleanup removed the temporary `/private/tmp` worktrees,
build roots, bundles, and logs on both hosts, so every `/private/tmp` path in
this board is a provenance record only and no longer exists. The paused TEV
and Indirect candidates survive as durable refs in the
`upstream/ACGC-PC-Port` submodule:
`c1/archive/cleanup-20260815/canonical-tev-candidate` (worker `043d24822`)
and `c1/archive/cleanup-20260815/canonical-indirect-candidate` (worker
`2f6ba5dff`), mirrored by the `acgc-m3-cleanup` remote refs `canonical-tev`,
`canonical-indirect`, and `canonical-62c810e`.

The pre-pause scheduler ceiling was fifteen visible lanes with production
source editing capped at seven simultaneous lanes. On resume, follow the
README's recommended four-to-seven useful lanes instead; the fifteen-lane
ceiling is historical. Full `ac_pc` links and LLDB launches remain serialized
across both hosts. True cloud tasks are planning/review only; the ISO,
extracted assets, keys, and proprietary data remain local and ignored.
The texture remediation (17) is now complete/integrated at source `578c8b7`.
The root-owned audio-bank ABI lane is integrated at source `909f3ca`; its
historical fresh run decodes compact bank 28, reaches `LOGO draw`, and
produces the first identifiable game-owned frame. The captured screen was
retained outside Git at
`/private/tmp/acgc-integrated-audio-wave-build/integrated-frame-screen.png`
and recorded at SHA-256
`ce1a124b15d07d7f81edb7ad1ef1548832c7d5bbff21bd46a59de533996129b6`; that
temporary file was lost in the post-pause `/private/tmp` cleanup, so the
recorded hash and evidence documents are the surviving record and
re-verifying the image requires a fresh capture. The
process later exits `139` before clean shutdown, so representative GX/Metal
readback, input, audible audio, save/load, and playability remain open. The
authoritative source has since advanced through `09dd182` to `aea3515`: the
LP64 field-cleanup fix preserves the allocator-owned pointer, and a fresh exact-tip ten-second run
reaches logo action 3 and `[NEOS_OUT]` frame 541; TERM then returns status `0`
within the two-second grace period. This closes the previously reproduced
post-GX invalid-free boundary, but it still has no current-snapshot
pixel/readback claim.
Graph capture (16) and integrated verification (22) are complete/parked. The
post-fix game-frame request is superseded by the root-owned integrated run;
the older client-only successor requests listed below never became durable
tasks or worktrees and remain parked historical intake, not active lanes.
Expensive full links and LLDB launch traces remain serialized. Lanes 185–186
are reviewed and integrated, and lanes 187–188 are complete read-only audits.
Lane 189's direct `GX_TEX_S` and INDEX8/INDEX16 repair is independently
reviewed and integrated, as is lane 193's effective magnification-filter
repair. Lane 194 has completed its read-only Lighting producer audit. Lane 190
is independently reviewed and integrated, and lanes 191–192 completed their
read-only contracts.
Lane 195 completed its raw Channels source handoff; root review found that
`GXSetNumChans` incorrectly erased persistent inactive raw records. Lane 199
repaired that contradiction, and the final tree is integrated as canonical PC
`38343a5eb5` without recording the broken intermediate commit on the canonical
branch.
Lane 196 completed its read-only raw Texture/TLUT ownership audit and froze the
private pointer-free shadow plus synchronous lease boundary. Lane 197 completed
the independent current-tip focused verification matrix with native and
combined ASan/UBSan `17/17` passes; its exact holder-free generated roots are
retired. Lane 198 completed the independent read-only review of the initial
lane-195 candidate; root review supersedes its PASS at the documented
persistence boundary. Lane 200 completed the raw Lighting producer on the M3
Max and is reviewed and integrated as canonical PC `97aebd8a2d`. Lane 201
completed its independent exact post-Channels matrix: native and combined
ASan/UBSan each pass `18/18`, the corrected ABI/syntax probes pass, and Windows
remains at the documented SDL/toolchain boundary. Lane 202 completed its
independent read-only five-file review with `PASS` and is archived. Lane 203
completed the M3 Max raw Texture/TLUT producer. Root review rejected its
initial all-map TLUT invalidation; the same lane repaired that defect as child
commit `698d45d3e`, and the final tree is reviewed and integrated on canonical
`c1/macos-host-launch`. Fresh exact-tip native and combined ASan/UBSan focused
matrices pass `7/7` each. Lane 205 is reviewed and integrated as canonical PC
`b3336504c`; its native and combined ASan/UBSan canonical matrices pass
`13/13`. Lane 204's final two-commit worker range is reviewed and squashed onto
that newer tip as canonical PC `039afce0e`; exact native and combined
ASan/UBSan focused CTest pass `2/2` each and the real production `pc_gx.c`
object compiles. Root's initial malformed-`GXBool` concern was retracted
because `TARGET_PC` defines `GXBool` as C `bool`; the final fixture uses only
valid booleans and checks an out-of-range compare value through the real `u32`
setter surface. Lanes 206–207 completed their read-only audits and are
reviewed/archived under the remote M3 Max `acgc-modern-port` project. No
production worker from that completed batch remains active.
No full link, LLDB launch, or Metal-device run is active. Reviewed commits and
evidence remain available in Git and the evidence docs. Exact lane-204 cleanup
is complete. Lane 208 is reviewed, integrated, and archived as canonical PC
`85b25cb3c`; its initial candidate passed raw-shadow review but root held the
canonical branch until the same task restored decomp's `field == 0` viewport
jitter adjustment and added a focused regression. Lane 209 is reviewed and
integrated as canonical PC `a42da8e155`;
its remote and fresh local native plus combined ASan/UBSan focused CTest pass
`1/1` each. Lane 210 completed its read-only
Geometry-converter audit and is reviewed/archived. Its raw Geometry closure
successor is now dependency-ready because lane 208 released overlapping
`pc_gx.c` ownership. Lane 211 completed its first raw Geometry source handoff
at worker `1730823d45`, but lane 214 independently blocked it on indexed host
mirroring and packed-color FIFO-width/RGBX8 semantics. The same lane 211 branch
completed a narrow child repair at `5679bff656`; lane 215 independently passed
the child, and the reviewed end state is integrated as canonical PC
`b9a9f355`. Lane 212
completed its parallel read-only raw Indirect ownership crosswalk. Lane 213
completed the independent exact-tip matrix with native and combined
ASan/UBSan `21/21` passes. Its same project-owned verification task completed
lane 214's independent read-only review. Lane 216 returned source commit
`5aba10371f`, but lane 218 independently blocked it on strict raw-metadata
validation and missing mandatory fixture cases. Lane 217 completed its
read-only current-tip cumulative-producer audit and found the cumulative gate
still blocked by missing leaf owners/producers. Lane 216 completed its exact
two-file repair as child `5324c8739e`; lane 220 independently passed it, and
the two source commits are integrated as canonical PC `689590cc`. Lanes 219
and 222 completed the portable Texgen/SU ABI source/review pair; worker
`f503fb924` is integrated as canonical PC `590b2bd73` and both tasks are
archived. Lane 221 completed its independent read-only Transform
leaf-producer audit with `READY`; no predecessor raw-owner repair is required.
Lane 222 completed the independent Texgen review. Lane 223 worker `4fde6d94`
passed lane 226's independent review and is integrated as canonical PC
`37ae640d5`; both tasks are archived and generated-root cleanup is complete.
No full link, LLDB, or device run is
active. Lane 224 completed its
read-only TEV audit with `BLOCK`. Lane 225 completed the Alpha/Blend/Depth/Fog
producer topology: Alpha is `READY`, while Blend, Depth, and Fog are `BLOCKED`
on the documented distinct predecessors. Lane 227 worker `dfef13a2` passed
lane 228's immutable independent review and is integrated as canonical PC
`0f896395c`; both tasks are archived. Lane 229 completed its independent
read-only Blend audit with `BLOCK`: the canonical Blend ABI exists, but no
setter-owned raw Blend owner/knownness/invalid state or truthful builder does.
Lane 230 completed its independent read-only Fog audit with `BLOCK`: the PC
host retains no logical range-adjust state and has no truthful raw Fog owner or
producer. Lane 231 completed its current-tip cumulative audit with `BLOCK`:
Texgen/SU, TEV, Blend, Fog, and Indirect still lack truthful leaf inputs, and
there is no atomic all-section assembler/publication boundary. Lane 232
completed the initial Texgen/SU leaf as clean worker `a14aef4179`. Lane 233's
immutable review returned `BLOCK` on one matrix-provenance/mask invariant.
Lane 232 completed the exact two-file repair as clean child `e6f26abde5`; lane
233 independently re-reviewed that child and returned `PASS`. Root imported
the verified source-only bundle, applied both commits one at a time, and
integrated the reviewed end state as canonical PC `c832fb862`. Fresh native
and combined ASan/UBSan focused CTest pass `2/2` each and the production
producer object compiles. Both tasks are complete/archived and no production
worker from that pair is active. Lane 235 completed its independent review of
lane 234 candidate `34da318d4` with `BLOCK`: invalid current-call TEV/Indirect
inputs can mark the raw owner invalid yet still mutate legacy host mirrors, and
the fixture does not cover those invalid domains. Lane 234 returned clean
two-file repaired child `638f91fa2` plus a refreshed verified source-only
bundle. Lane 235's immutable re-review returned `BLOCK` because the existing
legacy raw-TEV fixture still expects malformed S10 input to mutate a legacy
shadow that the production repair now correctly leaves unchanged. Lane 234
returned clean one-file fixture child `62a9f5b23` with both focused fixtures
passing natively and under combined ASan/UBSan. Lane 235's final immutable
re-review returned `PASS`. Root imported the verified final bundle, applied all
three commits one at a time, and integrated canonical PC `62c810e5b`; fresh
exact-tip native and combined ASan/UBSan focused CTest pass `2/2` each. Both
tasks are complete/integrated/archived. Lanes 236 and 237 completed clean
canonical TEV and Indirect leaf handoffs at workers `043d24822` and
`2f6ba5dff`; both are now integrated on `c1/macos-host-launch` (2026-08-17)
as `043d24822`, `b83a6f6e3`, and CMake registration `d50cddb18`, with
exact-tip native and combined ASan/UBSan focused CTest `2/2` each. Lane 238,
the parallel read-only
cumulative snapshot and Apple CPU-boundary audit at the same exact
`62c810e5b` source tip, completed before the 2026-08-15 pause with three
independent `BLOCK` verdicts (see
`docs/evidence/CUMULATIVE-APPLE-AUDIT-62C810E5B-2026-08-15.md`). Lanes 239
and 240, the registered independent immutable CPU/source reviews of the two
candidates, paused mid-verification without final `PASS`/`BLOCK` handoffs
(see `docs/evidence/TEV-INDIRECT-REVIEW-PAUSE-62C810E5B-2026-08-15.md`).
The completed TEV candidate alone changed
`pc/CMakeLists.txt`; the Indirect candidate used a source-direct harness, and
all three review/audit lanes own no production files. No full link, LLDB,
launch, or device work is active.

## Remote M3 Max batch (final pre-pause)

Before the pause, the authorized M3 Max Codex host and SSH path were online
and the source-only remote checkout was used for focused lanes; the latest
integrated local PC tip is `62c810e5b` and decomp remains `09ca8e8b`. Any
remote lane state remaining after the pause and `/private/tmp` cleanup must
be assumed lost. No ISO, extracted assets, keys, or
proprietary data were transferred. The remote Codex app has a saved
`acgc-modern-port` project. Built-in cross-host handoff matching still does not
enumerate it from the local host, so lanes 204–207 were created directly from
that remote project's UI and are registered here by durable task ID before
work. Lane 140 ran
`gpt-5.6-luna` with max reasoning from the exact `565f877e` source-only base
and is now complete/integrated. Its generated roots are retired; its clean
source worktree is deliberately preserved because ignored `assets/` and
`orig/` are present. Lane 141 completed the sole serialized `c973dbee` runtime
gate and exposed the initial V2 base-state predicate as the next fail-closed
tier. Lanes 142–144 are complete: lane 142 is integrated as PC `59d13a98`,
and lanes 143–144 produced read-only architecture evidence. Root-owned lane
145 has also completed its one serialized `59d13a98` link/LLDB trace. Lanes
146–148 completed the read-only alpha, fog/global-count, and Apple status-policy
crosswalks. Lanes 149 and 150 are complete and integrated as PC `820906439`
and `5157ac1cb`; lane 151 completed the read-only cumulative fog contract.
Lanes 152 and 155 are complete and integrated as PC `b5f550ea0` and
`afb1cac3c`; lanes 153 and 154 completed the read-only cumulative-schema and
Apple consumer/encoder audits. Lane 157 is complete and integrated. Lane 156
is integrated as PC `4dbb71065`, and lane 158 completed its read-only producer
audit. Lane 159 completed the read-only Blend/logic contract; lane 160 completed
the independent focused verification matrix; lane 161 is integrated as PC
`216d1e24b`. Lanes 162–163 completed the Alpha/update and TEV contracts; lane
164 completed the Transforms/Texgens provenance audit; lane 165 is integrated
as PC `f2b7ab153`; lane 166 is integrated as PC `037689462`; lane 167 completed
the read-only exact Transforms ABI audit; lane 168 is integrated as PC
`6d1d310c0`; lane 169 completed the read-only Depth/Raster exact contract
audit; lane 170 is integrated as PC `59714a1fd`; lane 171 completed the
read-only exact Channels/Lighting contract audit; lane 172 is integrated as PC
`c736f9686`; lanes 175–176 are complete and integrated as canonical PC
`c3e158398` and `251a010b8`, adding the neutral Transform ABI and setter-owned
raw Depth provenance. Lanes 173–174 returned preserved, non-overlapping first
commits for raw Texgen/SU provenance (`2e3c95dae`) and the neutral Geometry ABI
(`2b394943a`), but independent review found contract blockers in both. Repair
commits `2df84f628` and `56ede5f1f` returned, but independent cross-review found
one observer blocker in Texgen/SU and two selector/padding blockers in Geometry.
Final Geometry repair `8652e233d` passed independent review and is integrated
as canonical PC `910c7f6f52`; exact native and ASan/UBSan canonical matrices
pass `8/8`. Texgen child repair `490c14d72` fixed the separate legacy
dirty-state regression, passed two independent reviews, and is integrated
through canonical PC `1d48691a4f`; exact integrated native and combined
ASan/UBSan raw-state matrices pass `4/4` each. Lanes 177–178
completed the read-only cumulative-producer and Apple canonical-plan
preflights. Lane 179 completed the exact current-tip
native/sanitizer/Windows focused matrix. Lanes 180–181 completed the read-only
Channels/Lighting and Raster implementation preflights. Lane 182 completed,
was archived, and had its exact holder-free roots retired after the current-tip
M3 Max synthetic Metal-device fixture gate. No full link or LLDB run is active.
Lane 183 completed the state-before-geometry temporal-order contract and its
Raster ownership correction. Lane 184 stopped after a bounded partial Indirect
crosswalk rather than duplicating work while project handoff is unresolved;
lane 173 is complete/integrated/archived. Lane 185 reused that project-owned M3
task and protected source worktree for the Depth temporal-ordering repair; its
reviewed worker `a2cbfda07e` is integrated as canonical PC `9f149b6fd9`, with
exact integrated native and combined ASan/UBSan raw-state matrices passing
`4/4`. Lane 186 is independently reviewed and integrated as canonical PC
`324c174ae3`; the exact integrated canonical native and combined ASan/UBSan
matrices pass `9/9`. Lanes 187–188 completed the read-only cumulative-producer
and Apple-plan audits. Lanes 189–192 reused the same four project-owned M3
tasks/worktrees for Geometry raw-batch provenance, the neutral Lighting ABI,
the Texture/TLUT/Dynamic contract, and raw Channels planning. Lane 189 remains
complete and integrated; lanes 190–194 are complete, with lanes 190 and 193
also integrated. Remote workers may not update the umbrella checkout.

- Lane 142 / task `01a00211-7500-7cd3-a5f6-161cfcbff884` — complete,
  integrated, and archived. M3 Max branch
  `c1/lane-v2-base-rejection-reason-m3` advanced `c973dbee` to worker
  `6d5b3c893`; the integration owner cherry-picked the exact three-file change
  as canonical PC `59d13a98`. The unchanged V2 acceptance predicate remains
  authoritative while a bounded classifier names the first rejection tier.
  Remote and exact integrated native plus combined ASan/UBSan focused CTest
  pass `2/2` each (`detect_leaks=0`, no diagnostics). Source/fixture crosswalk
  predicted source-alpha state as `blend`; lane 145 later disproved that as the
  first capped live reason.
  No packet, callback, Metal, pixel, or playability claim follows. Evidence is
  `docs/evidence/V2-BASE-REJECTION-CLASSIFIER-59D13A98-2026-08-14.md`.
- Lane 143 / task `01a00212-fc10-78c0-a39a-70de7beb923a` — complete and
  archived with no source change. The read-only `c973dbee`/`09ca8e8b`
  crosswalk found that V1/V2/V3/V4 are not cumulative and selected a
  deliberately named canonical value-only draw/state ABI plus a separate
  borrowed texture-resource sideband. No build, launch, asset access, Metal,
  pixel, or playability proof occurred. Evidence is
  `docs/evidence/RENDERER-CONTRACT-CONSOLIDATION-C973DBEE-2026-08-14.md`.
- Lane 144 / task `01a00212-f8b5-7c71-9557-1c5208f87e17` — complete and
  archived with no source change. The read-only Apple crosswalk mapped the V2
  validator, typed consumer, provider, observer, and sink boundaries. Ordinary
  V2 has a potential status-policy defect: it is source-reachable toward the
  geometry sink despite
  `V2_EXTENSION_NOT_RENDERED`; provider-backed `CPU_RESOLVED` texture/TEV
  output is deliberately blocked. No live callback, build, launch, device,
  Metal, pixel, or playability proof occurred. Evidence is
  `docs/evidence/APPLE-SINK-REACHABILITY-C973DBEE-2026-08-14.md`.
- Lane 145 / root task `019ff398-2520-7191-ac5c-f3007c49163f` — complete,
  integrated, archived, and cleaned. The read-only runtime verification used
  canonical PC `59d13a98` and decomp `09ca8e8b`, one resumed serial arm64
  `ac_pc` build, and one logged-in-session LLDB launch under
  `/private/tmp/acgc-current-v2-rejection-runtime-59d13a98-build` and
  `/private/tmp/acgc-current-v2-rejection-runtime-59d13a98-logs`. The build
  produced arm64 SHA-256 `0c160340...993a`; the run reached LOGO/NEOS and
  3,529 grouped/internal builder entries. The capped cohort was 18 paired
  `alpha_test` attempts followed by 14 paired `global_count` attempts; packet
  init/validation and every Apple consumer/provider/observer count were zero.
  LLDB's buffered launch line defeated automatic PID discovery, so exact
  validated PID `38037` received TERM and then KILL; no retry or clean-shutdown
  claim follows. Evidence is
  `docs/evidence/CURRENT-V2-REJECTION-RUNTIME-59D13A98-2026-08-14.md`. This does
  not prove a callback, Metal encode/present/readback, pixel, input, audio,
  save, device, or playability gate. Its exact build/log and integrated
  native/sanitizer roots were holder-free and are now absent; source, commits,
  evidence, ISO/assets, and unrelated dirt were preserved.

- Lane 146 / task `01a00250-5adf-7ae3-b348-437a437a0dfe` — complete and
  archived,
  read-only M3 Max crosswalk at PC `59d13a98` and decomp `09ca8e8b`. It owns
  whether nonzero alpha reference bytes are semantically ignored when both
  comparisons are `GX_ALWAYS`, plus the exact fail-closed cases a later
  test-first predicate lane must retain. It proved those refs are dead only for
  `GX_ALWAYS/GX_ALWAYS` plus `GX_AOP_AND`; the live tuple next fails at blend.
  Evidence is `docs/evidence/V2-ALPHA-REFERENCE-SEMANTICS-59D13A98-2026-08-14.md`.
  No edits, build, test, launch, asset access, callback, Metal, pixel, or
  playability claim.
- Lane 147 / task `01a00250-5d82-7a91-9202-636b8478f7f0` — complete and
  archived,
  read-only M3 Max crosswalk at PC `59d13a98` and decomp `09ca8e8b`. It owns
  the observed `global_count` tuple (`chans=1`, `texgens=2`, `tev=2`,
  `ind=0`, `fog=2`), including count-versus-enum classification and the
  narrow renderer-contract successor. It proved the counts are valid and
  `fog=2` is `GX_FOG_PERSP_LIN`, whose semantics are absent from V2. Evidence
  is `docs/evidence/V2-GLOBAL-COUNT-FOG-CROSSWALK-59D13A98-2026-08-14.md`.
  No edits, build, test, launch, asset access, callback, Metal, pixel, or
  playability claim.
- Lane 148 / task `01a00250-4e56-7d20-b951-a9b9fc4f57f4` — complete and
  archived,
  read-only M3 Max audit at PC `59d13a98` and decomp `09ca8e8b`. It owns the
  ordinary-V2 Apple status-policy question: whether a packet marked
  `V2_EXTENSION_NOT_RENDERED` can incorrectly reach the geometry sink while
  the provider-backed `CPU_RESOLVED` texture/TEV path remains separate. No
  edits. It confirmed a CPU status-policy defect: ordinary V2 marked
  `V2_EXTENSION_NOT_RENDERED` can reach the geometry-only sink. Evidence is
  `docs/evidence/APPLE-V2-SINK-STATUS-POLICY-59D13A98-2026-08-14.md`. No build,
  test, launch, asset access, live callback, Metal, pixel, or playability claim.
- Lane 149 / task `01a0025c-acba-7100-8a2d-c3a5ea3ec708` — complete,
  integrated, and archived. Remote branch
  `c1/lane-v2-alpha-ref-normalization-m3` advanced `59d13a98` to reviewed
  `2dcd69c4a`; the integration owner cherry-picked it as canonical PC
  `820906439`. Exactly `pc/src/pc_gx.c` and the focused rejection-reason
  fixture changed. Remote and exact integrated native plus combined ASan/UBSan
  focused CTest pass `1/1` each (`detect_leaks=0`, no diagnostics). Evidence is
  `docs/evidence/V2-ALPHA-REFERENCE-NORMALIZATION-820906439-2026-08-14.md`.
  No full-link, LLDB, callback, Metal, pixel, or playability claim follows.
- Lane 150 / task `01a0025c-9d0d-71d3-9be3-7b01da10cfa2` — complete,
  integrated, and archived. Remote branch `c1/lane-v2-sink-policy-m3`
  advanced `59d13a98` to `a4d90512c`; the integration owner cherry-picked it
  after lane 149 as canonical PC `5157ac1cb`. Exactly the Apple CMake target,
  runtime policy, and V2 runtime-sideband fixture changed. Remote and exact
  integrated native plus combined ASan/UBSan CTest pass `1/1`; production
  syntax compile passes. Evidence is
  `docs/evidence/APPLE-V2-SINK-GUARD-5157AC1CB-2026-08-14.md`. No full-link,
  callback, Metal, pixel, or playability claim follows.
- Lane 151 / task `01a0025c-b5aa-7c73-9002-64ee26c07776` — complete and
  archived read-only. It specified the 80-byte canonical fog value section,
  validation, mask, sideband, ABI/alignment target, ownership split, and CPU
  fixture/device proof boundary. Evidence is
  `docs/evidence/CANONICAL-FOG-STATE-CONTRACT-59D13A98-2026-08-14.md`. No
  source/docs edit, build, test, launch, asset access, callback, Metal, pixel,
  or playability claim occurred in the worker.
- Lane 152 / task `01a00276-84d7-7cc1-b085-cabe0af93e34` — complete,
  integrated, archived, and cleaned. Preserved branch
  `c1/lane-canonical-fog-state-m3` and retired worktree
  `/private/tmp/acgc-lane-canonical-fog-state` started at exact PC
  `5157ac1cb`; decomp is `09ca8e8b`. It owns only new renderer-neutral
  canonical-state header/source, one portable fog fixture, and minimal portable
  CMake registration. It must leave V1–V4, `pc_gx`, Apple runtime, live
  capture, full link, LLDB, Metal, pixels, and playability out of scope. Worker
  `956e0571b` is integrated as canonical PC `b5f550ea0`. Remote and
  exact integrated native plus combined ASan/UBSan focused CTest pass `1/1`
  each. Evidence is
  `docs/evidence/CANONICAL-FOG-STATE-B5F550EA0-2026-08-14.md`. No live
  snapshot, callback, Metal, pixel, or playability claim follows. Remote and
  local generated verification/transfer roots were holder-free and are absent;
  branch, commits, integration, and evidence remain preserved.
- Lane 153 / task `01a00275-9cf6-75b0-9275-f7f7f2338084` — complete,
  archived, and cleaned, read-only M3 Max audit at exact PC `5157ac1cb` and
  decomp `09ca8e8b`. Its retired detached worktree
  `/private/tmp/acgc-lane-cumulative-state-schema-audit` owned the
  fixed-width cumulative GX state schema, section masks, validation,
  sideband-resource boundaries, byte layout, and an implementation order. It
  produced the two-upstream field crosswalk, ABI risks, validation fixtures,
  and implementation order. Its provisional layout was reconciled with the
  newer fog contract into a strict 14-section envelope whose total size remains
  unfrozen. Evidence is
  `docs/evidence/CANONICAL-GX-SCHEMA-CROSSWALK-5157AC1CB-2026-08-14.md`. No
  edit, build, launch, asset access, Metal, pixel, or playability claim. Its
  task, worktree, prompt/event artifacts, and transfer bundle were archived or
  retired after exact holder-free checks; committed evidence remains.
- Lane 154 / task `01a00275-9cf6-7113-8511-5e9a4d18deff` — complete,
  archived, and cleaned, read-only M3 Max audit at exact PC `5157ac1cb` and
  decomp `09ca8e8b`. Detached
  worktree `/private/tmp/acgc-lane-apple-canonical-consumer-audit` owns the
  canonical-state-to-Metal mapping, consumer/encoder boundary, cache
  invalidation rules, first safe CPU source boundary, and later device/pixel
  fixture contract. It found current V4 sink eligibility too permissive and
  selected a cumulative snapshot -> owned sideband -> immutable CPU plan ->
  device encoder architecture. Evidence is
  `docs/evidence/APPLE-CANONICAL-CONSUMER-AUDIT-5157AC1CB-2026-08-14.md`. It
  made no edit, build, launch, or live Metal/rendered-frame claim. Its detached
  worktree and generated prompt/event artifacts were holder-free and are
  absent; committed evidence remains.
- Lane 155 / task `01a00276-84d7-7d83-81e6-28aec4c163d3` — complete,
  integrated, archived, and cleaned. Preserved branch
  `c1/lane-input-trigger-parity-m3` and retired worktree
  `/private/tmp/acgc-lane-input-trigger-parity` started at exact PC
  `5157ac1cb`; decomp is `09ca8e8b`. It owns only `pc/src/pc_pad.c`, the SDL
  input smoke fixture, and minimal CMake registration if required. Its gate is
  restoring decomp-compatible digital L/R semantics for nonzero normalized
  analog trigger values while preserving analog values and digital bindings.
  Worker `047ec5134` is integrated as canonical PC `afb1cac3c`. The exact
  two-file change adds axis-specific normalized-nonzero L/R semantics and a
  deterministic virtual-controller fixture. Remote and exact integrated native
  plus combined ASan/UBSan focused CTest pass `1/1` each; the `_WIN32` host
  probe remains blocked by missing `process.h`. Evidence is
  `docs/evidence/INPUT-TRIGGER-PARITY-AFB1CAC3C-2026-08-14.md`. No physical
  input, full link, LLDB, device, or playability claim follows. Remote and
  local generated verification/transfer roots were holder-free and are absent;
  the branch, commits, source integration, and evidence remain preserved.
- Lane 156 / task `01a00297-d958-7e93-be9a-6d3949f789c7` — complete,
  integrated, archived, and cleaned. Remote branch
  `c1/lane-canonical-envelope-m3` advanced exact PC `b5f550ea0` to worker
  `18ef2fcbb`; the integration owner cherry-picked its exact four-file change
  as canonical PC `4dbb71065`. It adds the 48-byte header, fourteen ordered
  32-byte directory entries, dynamic aligned payload extent, and fail-closed
  metadata validator around the 80-byte fog section. Remote and exact
  integrated native plus combined ASan/UBSan focused CTest pass `2/2` each
  (`detect_leaks=0`, no diagnostics); bounded ABI/syntax probes pass. Evidence
  is `docs/evidence/CANONICAL-GX-ENVELOPE-4DBB71065-2026-08-14.md`. Its exact
  worktree, native/ASan/Windows roots, prompt/events/final, transfer bundle,
  and local integration roots are absent; the worker branch and commits remain
  preserved. No live producer, callback, Metal, pixel, device, or playability
  claim follows.
- Lane 157 / task `01a00297-d95c-7742-8feb-a275b16b4b88` — complete,
  integrated, archived, and cleaned. Preserved remote branch
  `c1/lane-v4-sink-failclosed-m3` advanced exact PC `b5f550ea0` to worker
  `0bda49d23`; the integration owner cherry-picked its two-file change as
  canonical PC `62ef6638d`. V1 remains the only legacy packet eligible for the
  current geometry sink; V2/V3/V4 fail closed until the canonical CPU render
  plan exists. Remote and exact integrated native plus combined ASan/UBSan
  focused CTest pass `1/1` each (`detect_leaks=0`, no diagnostics), the
  production syntax compile passes, and `git diff --check` passes. Evidence is
  `docs/evidence/APPLE-V4-SINK-GUARD-62EF6638D-2026-08-14.md`. No live
  callback, full link, Metal encode/present/readback, pixel, device, or
  playability claim follows. Its exact worktree, native/ASan build roots,
  prompt/event/final artifacts, transfer bundle, and local integration roots
  were holder-free and are absent; worker/canonical branches, commits, and
  evidence remain preserved.
- Lane 158 / task `01a00297-d958-73f2-a850-d79a18e5f763` — complete,
  archived, and cleaned, read-only at exact PC `b5f550ea0` and decomp
  `09ca8e8b`.
  It selects the committed-vertex boundary at the top of
  `pc_gx_flush_vertices()` before legacy handoffs or GL mutation, defines
  synchronous owned texture/TLUT generation rules, and records the missing
  shadow state that still blocks a truthful producer. Evidence is
  `docs/evidence/CANONICAL-SNAPSHOT-PRODUCER-AUDIT-B5F550EA0-2026-08-14.md`.
  Its exact detached worktree and prompt/events/final artifacts are absent.
  No edit, build, launch, asset access, callback, Metal, pixel, or playability
  proof occurred.
- Lane 159 / task `01a0029d-475b-7971-aead-39fe8fc4bc8e` — complete,
  archived, and cleaned, read-only at exact PC `b5f550ea0` and decomp
  `09ca8e8b`.
  It selects the exact reusable V3 four-word Blend/logic record: version 1,
  16 bytes, four-byte aligned, count/capacity 1, modes `0..3`, factors `0..7`,
  and logic operations `0..15`, with no reserved tail or mode-dependent
  normalization. Alpha/update remains `0x0100`; dither/destination alpha remain
  Raster `0x0400`. Evidence is
  `docs/evidence/CANONICAL-BLEND-LOGIC-CONTRACT-B5F550EA0-2026-08-14.md`. No
  Its exact detached worktree and prompt/events/final artifacts are absent.
  No edit, build, launch, asset access, callback, Metal, pixel, or playability
  proof occurred.
- Lane 160 / task `01a0029d-475c-7a31-a6f9-708e60cb4201` — complete,
  archived, and cleaned, verification-only at exact PC `b5f550ea0` and decomp
  `09ca8e8b`. Native and combined ASan/UBSan each pass 44 tests with three
  declared Metal-device skips; final sanitizer logs have no diagnostics
  (`detect_leaks=0`). Bounded Windows host probes pass 4 and are blocked at 5
  by Apple libc++ locale simulation, missing `<process.h>`, and absent i686
  sysroots/toolchains. Exact current PC `4dbb71065` post-envelope/sink native
  and combined ASan/UBSan delta tests pass `3/3` each. Evidence is
  `docs/evidence/CURRENT-FOCUSED-MATRIX-B5F550EA0-2026-08-14.md`. No full link,
  launch, LLDB, Metal device, pixel, Windows runtime, or playability proof
  follows. Its detached worktree, native/ASan/Windows roots,
  prompt/events/final artifacts, and exact local current-delta roots are absent.
- Lane 161 / task `01a002af-5e39-7e40-b83e-86323c7786c6` — complete,
  integrated, archived, and cleaned. Remote branch
  `c1/lane-canonical-blend-m3` advanced exact PC `4dbb71065` to worker
  `a170654b0`; the integration owner cherry-picked its exact four-file change
  as canonical PC `216d1e24b`. It adds the audited version-1 16-byte four-word
  Blend/logic ABI, strict value validator, exact metadata helper, and portable
  fixture without changing common envelope semantics, V1-V4, `pc_gx`, or
  Apple code. Remote focused native/ASan and exact integrated native/ASan
  results pass `1/1` and `3/3` respectively; ABI and bounded `_WIN32` probes
  pass. Its exact worktree, native/ASan/Windows roots, prompt/events/final,
  transfer bundle, and local integration roots are absent; the worker branch
  and commits remain preserved. Evidence is
  `docs/evidence/CANONICAL-BLEND-STATE-216D1E24B-2026-08-14.md`. No live
  snapshot, callback, Metal, pixel, device, or playability claim follows.
- Lane 162 / task `01a002b5-525f-7480-81df-8c9bde594295` — complete,
  archived, and cleaned, read-only at exact PC `4dbb71065` and decomp
  `09ca8e8b`.
  It freezes `0x0100` as a version-1, 32-byte, eight-word Alpha/update section:
  two comparisons/references, operator, color update, alpha update, and
  `z_comp_loc`, with exact bounds and no inactive normalization. It identifies
  PC `GXSetZCompLoc` as the remaining no-op producer gap. Evidence is
  `docs/evidence/CANONICAL-ALPHA-UPDATE-CONTRACT-4DBB71065-2026-08-14.md`.
  Its exact detached worktree and prompt/events/final artifacts are absent. No
  edit, build, launch, asset access, callback, Metal, pixel, device, or
  playability proof occurred.
- Lane 163 / task `01a002b5-525f-7862-aa8c-0e0ccecdf5c2` — complete,
  archived, and cleaned, read-only at exact PC `4dbb71065` and decomp
  `09ca8e8b`.
  It freezes `0x0020` as a version-1, 2560-byte, full 16-stage TEV section with
  exact stage/register/KONST/swap/reference rules, independent of the current
  3-stage shader and 2-stage legacy packet caps. It proves current normalized
  PC floats cannot supply exact signed S10 provenance and selects a narrow raw
  setter-shadow successor. Evidence is
  `docs/evidence/CANONICAL-TEV-CONTRACT-4DBB71065-2026-08-14.md`. Its exact
  detached worktree and prompt/events/final artifacts are absent. No edit,
  build, launch, asset access, callback, Metal, pixel, device, or playability
  proof occurred.
- Lane 164 / task `01a002be-b284-7492-95f3-c3ad066a2906` — complete,
  archived, and cleaned, read-only at exact PC `216d1e24b` and decomp
  `09ca8e8b`.
  It proves Transforms/Texgens cannot yet be produced truthfully: raw
  pre-widescreen projection, matrix domain/type/knownness, texgen
  normalize/post, and manual SU state are missing. It selects serial
  Transform/matrix then Texgen/SU source repairs with all-or-nothing producer
  failure until both are complete. Evidence is
  `docs/evidence/CANONICAL-TRANSFORM-TEXGEN-PROVENANCE-216D1E24B-2026-08-14.md`.
  Its exact detached worktree and prompt/events/final artifacts are absent. No
  edit, build, launch, asset access, callback, Metal, pixel, device, or
  playability proof occurred.
- Lane 165 / task `01a002c2-ce08-7193-ba94-d50aac6913d9` — complete,
  integrated, archived, and cleaned. Remote branch `c1/lane-canonical-alpha-m3`
  advanced exact PC `216d1e24b` to worker `acd12449a`; the integration owner
  cherry-picked its exact four-file change as canonical PC `f2b7ab153`. It
  adds the audited version-1 32-byte eight-word Alpha/update ABI, strict value
  and exact metadata validators, inactive-reference preservation, and a
  portable fixture. Remote native/ASan focused tests pass `1/1`; exact
  integrated native and combined ASan/UBSan canonical-state tests pass `4/4`.
  Its remote worktree, focused roots, prompt/events/final artifacts, transfer
  bundle, and exact local integration roots are absent; the worker branch and
  commits remain preserved. Evidence is
  `docs/evidence/CANONICAL-ALPHA-STATE-F2B7AB153-2026-08-14.md`. No live
  producer, callback, Metal, pixel, device, or playability claim follows;
  `GXSetZCompLoc` remains a separate PC shadow-state gap.
- Lane 166 / task `01a002c6-bb9a-7ed3-8f25-b6bb85d41b76` — complete,
  integrated, and archived. Remote branch `c1/lane-tev-raw-shadow-m3`
  advanced exact PC `216d1e24b` to worker `11cf5db00`; the integration owner
  cherry-picked its exact four-file change as canonical PC `037689462`. It
  adds setter-owned raw PREV/REG0-2 and K0-3 state with explicit unavailable,
  valid, source, and malformed provenance while preserving the float path.
  Remote and exact integrated native plus combined ASan/UBSan focused CTest
  pass `1/1` each; Windows runtime/toolchain proof remains blocked. Evidence is
  `docs/evidence/PC-RAW-TEV-SHADOW-037689462-2026-08-14.md`. No canonical
  section, snapshot, callback, Metal, pixel, device, or playability claim
  follows. Remote native/ASan/Windows roots, docs worktree, transfer bundle,
  and exact local integration roots are absent. The clean source worktree and
  prompt/events/final artifacts remain protected by one live remote holder;
  the branch and commit are preserved and no process was killed.
- Lane 167 / task `01a002cb-26b4-78d1-b01c-1708f6a7b9e5` — complete,
  archived, and cleaned, read-only at exact PC `216d1e24b` and decomp
  `09ca8e8b`. It freezes version-1 `0x0002` as an 888-byte aggregate with raw
  projection, ten position and ten normal matrices, current logical ID, and
  explicit knownness. Texture/post matrix and manual SU state remain solely in
  `0x0008`. Evidence is
  `docs/evidence/CANONICAL-TRANSFORM-CONTRACT-216D1E24B-2026-08-14.md`. No
  edit, build, launch, asset, callback, Metal, pixel, device, or playability
  operation occurred. Its detached source/docs worktrees and prompt/events/
  final artifacts are absent.
- Lane 168 / task `01a002d3-e737-76c1-8349-fc4e003fc0b9` — complete,
  integrated, archived, and cleaned. Remote branch
  `c1/lane-canonical-tev-m3` advanced exact PC `f2b7ab153` to worker
  `4862aa651`; the integration owner cherry-picked its exact four-file change
  as canonical PC `6d1d310c0`. It implements the version-1, section-`0x0020`,
  2,560-byte full 16-stage ABI. Remote focused native and combined ASan/UBSan
  CTest pass `1/1`; exact integrated canonical-state CTest pass `5/5` in both
  configurations. Compare operations retain logical setter arguments rather
  than BP-encoded bits. Evidence is
  `docs/evidence/CANONICAL-TEV-STATE-6D1D310C0-2026-08-14.md`. No cumulative
  producer, Apple/Metal callback, pixel, device, or playability claim follows.
- Lane 169 / task `01a002d6-8511-79d2-afeb-4348ff78a52a` — complete,
  archived, and cleaned, read-only at exact PC `f2b7ab153` and decomp
  `09ca8e8b`. It freezes versioned `0x0200` Depth as 16 bytes and `0x0400`
  Raster/viewport/scissor as 128 bytes, records the current PC no-op/lossy
  setters and knownness gaps, and selects neutral ABI lanes before one serial
  shared shadow owner. Evidence is
  `docs/evidence/CANONICAL-DEPTH-RASTER-CONTRACT-F2B7AB153-2026-08-14.md`.
  No edit, build, launch, callback, Metal, pixel, device, Windows runtime,
  iOS, or playability operation occurred.
- Lane 170 / task `01a002e0-0e90-7a01-8775-b09077214ab6` — complete,
  integrated, and review-clean. Its generated roots are retired; the clean
  source worktree remains protected while remote task holders retain it. Remote branch
  `c1/lane-transform-raw-shadow-m3` advanced exact PC `037689462` through
  `523d34e1d` and repair `4fbdcd620`; the integration owner cherry-picked them
  as canonical PC `4c3aeac40` and `59714a1fd`. The setter-owned shadow retains
  raw pre-widescreen projection, strict position/normal slots, current logical
  ID, knownness, and per-slot unresolved indexed state with exact finite
  immediate repair. Exact integrated native and combined ASan/UBSan Transform
  plus raw-TEV CTest pass `2/2` each. Evidence is
  `docs/evidence/PC-RAW-TRANSFORM-SHADOW-59714A1FD-2026-08-14.md`. No canonical
  `0x0002` producer, full link, LLDB, Metal, pixel, device, or playability claim
  follows.
- Lane 171 / task `01a002e1-540c-7693-b25d-363a1f209dd4` — complete,
  archived, and cleaned, read-only at exact PC `037689462` and decomp
  `09ca8e8b`. It freezes versioned `0x0004` Channels as 136 bytes and `0x0040`
  Lighting as 516 bytes, records exact combined/separate channel semantics,
  final light-object values, cross-section references, PC loss/no-op gaps, and
  the serial repair order. Evidence is
  `docs/evidence/CANONICAL-CHANNELS-LIGHTING-CONTRACT-037689462-2026-08-14.md`.
  No edit, build, launch, callback, Metal, pixel, device, Windows runtime,
  iOS, or playability operation occurred.
- Lane 172 / task `01a002f3-0540-7a61-9873-cfcbc18dcaae` — complete,
  integrated, and review-clean. Its generated roots are retired; the clean
  source worktree remains protected while remote task holders retain it. Remote branch
  `c1/lane-canonical-depth-m3` advanced exact PC `6d1d310c0` to worker and
  canonical PC `c736f9686`. It implements the frozen version-1,
  section-`0x0200`, 16-byte Z-mode ABI and exact envelope metadata validation.
  Remote focused native and combined ASan/UBSan CTest pass `1/1`; exact
  integrated shared canonical matrices pass `6/6` in each configuration.
  Evidence is
  `docs/evidence/CANONICAL-DEPTH-STATE-C736F9686-2026-08-14.md`. No PC setter
  shadow, cumulative producer, full link, LLDB, Metal, pixel, device, or
  playability claim follows.
- Lane 173 / task `01a002f3-0540-7db0-b2ac-052fed62f957` — complete,
  independently reviewed, integrated, and archived. The M3
  Max raw Texgen/SU provenance source/test successor ran in
  `/private/tmp/acgc-lane-pc-texgen-shadow`, branch
  `c1/lane-pc-texgen-shadow-m3`, advancing exact PC `251a010b8` through clean
  worker final `490c14d72`, with decomp oracle `09ca8e8b`. The completed
  corrective audit
  freezes section `0x0008` as the
  exact `0xA40` value contract, including writable ordinary selector `60` and
  post selector `125`; evidence is
  `docs/evidence/CANONICAL-TEXGEN-CONTRACT-6D1D310C0-2026-08-14.md`. The
  successor owns only `pc_gx` raw Texgen, matrix, and manual-SU sidebands, one
  focused fixture, and PC CMake registration. Geometry, portable canonical
  files, Raster `GXEnableTexOffsets`, producer, and Apple files are out of
  scope. Generated native/ASan roots and the temporary bundle are retired. The
  clean source worktree is deliberately preserved because its ignored
  `assets/` and `orig/` paths are protected. No full link, LLDB,
  asset access, callback, Metal, pixel, device, Windows-runtime, iOS, or
  playability claim follows. Commits `2df84f628` and `731b7ee41` repaired
  flush-before-mutation ordering, validation, and the intercepting fixture
  observer. Final child `490c14d72` removes compatibility-mirror mutation from
  raw capture and adds normalize-only, post-matrix-only, and identical-repeat
  regressions. Root integrated the four-commit chain as `ac7734c457`,
  `e5264ecbf8`, `bbb2eaf6df`, and canonical `1d48691a4f`. Exact integrated
  native and combined ASan/UBSan Transform/Depth/TEV/Texgen matrices pass
  `4/4` each; evidence is
  `docs/evidence/PC-RAW-TEXGEN-SU-SHADOW-1D48691A4-2026-08-14.md`. This proves
  CPU raw provenance, temporal ordering, and legacy dirty/equality preservation
  only, not a cumulative producer, runtime, Metal pixel, device, or playability
  gate.
- Lane 174 / task `01a002f3-0540-7361-875e-f9ccf4038788` — complete,
  independently reviewed, and integrated. The M3
  Max neutral Geometry ABI source/test successor runs in
  `/private/tmp/acgc-lane-canonical-geometry`, branch
  `c1/lane-canonical-geometry-m3`, advancing exact PC `251a010b8` to clean
  worker `2b394943a`, with decomp oracle `09ca8e8b`. The completed corrective
  audit freezes section `0x0001` with the
  `0x6B0` prefix, 26 exact descriptors, a section-relative bounded stream, and
  a `0x10000` inclusive size cap; evidence is
  `docs/evidence/CANONICAL-GEOMETRY-CONTRACT-6D1D310C0-2026-08-14.md`. The
  successor owns only a new canonical Geometry header/source/portable fixture
  and portable CMake registration. `pc_gx`, producer, Apple, Texgen, and all
  proprietary inputs are out of scope. Native and ASan roots are
  `/private/tmp/acgc-lane-canonical-geometry-{native,asan}`. No full link,
  LLDB, callback, Metal, pixel, device, Windows-runtime, iOS, or playability
  claim follows. A separate repair commit restored the frozen 48-byte
  header, canonical primitive/color/index ordering, exact integer and VAT
  validation, color canonicality, and bounded stream extent. Repair commit
  `56ede5f1f` was followed by `8652e233d`, which restricts fallback selectors
  to the ordinary domain and validates/accepts only zero final padding. Root
  integrated the chain as `7623f6c77d`, `cd30badb4d`, and canonical
  `910c7f6f52`. Exact integrated native and combined ASan/UBSan canonical
  matrices pass `8/8`; evidence is
  `docs/evidence/CANONICAL-GEOMETRY-STATE-910C7F6F5-2026-08-14.md`. This proves
  only the CPU Geometry ABI/validator, not a producer, runtime, Metal pixel,
  frame, device, or playability gate.
- Lane 175 / task `01a00358-efb4-7d51-b5b7-7fe5801e059a` — complete,
  independently reviewed, and integrated. M3 Max branch
  `c1/lane-canonical-transform-m3` advanced `59714a1fd` to worker
  `caf3ec133`; root integrated it as canonical PC `c3e158398`. The exact
  four-file implementation adds the fixed 888-byte section-`0x0002` neutral
  Transform ABI and strict validator. Integrated native and combined
  ASan/UBSan canonical matrices pass `7/7` each. Evidence is
  `docs/evidence/CANONICAL-TRANSFORM-STATE-C3E158398-2026-08-14.md`. It proves
  only CPU ABI behavior; no producer, full link, callback, Metal, pixel,
  device, or playability claim follows. Its holder-free source worktree,
  generated roots, and transfer bundles are retired; the branch and commits
  remain preserved.
- Lane 176 / task `01a00358-efb5-7f43-b28a-337c0d8ad584` — complete,
  independently reviewed, and integrated. M3 Max branch
  `c1/lane-pc-depth-shadow-m3` advanced `59714a1fd` through worker commits
  `7debdfb79` and ABI repair `3a574f6b4`; root integrated them as canonical PC
  `eeec2301c1` and `251a010b8`. The exact four-file result adds setter-owned
  raw Depth provenance while preserving the typed `GXSetZMode` boundary.
  Integrated native and combined ASan/UBSan raw Depth/Transform/TEV matrices
  pass `3/3` each. Evidence is
  `docs/evidence/PC-RAW-DEPTH-SHADOW-251A010B8-2026-08-14.md`. It proves only
  CPU provenance; no canonical producer, full link, callback, Metal, pixel,
  device, Windows-runtime, or playability claim follows. Its holder-free
  generated roots and transfer bundles are retired. The clean source worktree
  remains protected because remote task processes still hold it; no holder was
  killed, and the branch and commits remain preserved.
- Lane 177 / reused task `01a00297-d958-73f2-a850-d79a18e5f763` — complete
  read-only M3 Max cumulative-producer preflight in detached
  `/private/tmp/acgc-lane-cumulative-producer-preflight` at exact PC
  `251a010b8` and decomp `09ca8e8b`. It updates the earlier `b5f550ea0`
  producer audit into an implementation-ready entry-point, section-readiness,
  all-or-nothing validation, resource-lifetime, and fixture contract using the
  newly frozen Geometry/Texgen and integrated Transform/Depth prerequisites.
  It may not edit, build, link, launch, access assets, or claim callback,
  Metal, pixel, device, or playability proof.
- Lane 178 / reused task `01a00275-9cf6-7113-8511-5e9a4d18deff` — complete
  read-only M3 Max Apple canonical-plan preflight in detached
  `/private/tmp/acgc-lane-apple-canonical-plan-preflight` at exact PC
  `251a010b8` and decomp `09ca8e8b`. It updates the earlier Apple audit into an
  exact immutable CPU-plan, cache/lifetime, state-mapping, fixture, and later
  device-gated encode/present/readback contract. It may not edit, build, link,
  launch, access assets, or infer Metal, pixel, device, or playability proof.
- Lane 179 / reused task `01a0029d-475c-7a31-a6f9-708e60cb4201` — complete
  verification-only M3 Max current-tip matrix in detached
  `/private/tmp/acgc-lane-current-focused-matrix-251a010` at exact PC
  `251a010b8` and decomp `09ca8e8b`. It owns only explicit focused native,
  combined ASan/UBSan, and bounded `_WIN32`/ILP32 targets under unique
  `/private/tmp/acgc-lane-current-focused-matrix-251a010-{native,asan,win}`
  roots. It may not edit source/docs/refs, build full `ac_pc`, launch, use a
  Metal device, or claim pixels, Windows runtime, device behavior, or
  playability.
- Lane 180 / reused task `01a002e1-540c-7693-b25d-363a1f209dd4` — complete
  read-only M3 Max Channels/Lighting implementation preflight in detached
  `/private/tmp/acgc-lane-channels-lighting-preflight` at exact PC
  `251a010b8` and decomp `09ca8e8b`. It converts the frozen 136-byte Channels
  and 516-byte Lighting contracts into exact neutral-ABI and later raw-PC
  ownership plans without overlapping the active portable-CMake or `pc_gx`
  owners. No edit, build, link, launch, asset, Metal, pixel, or playability
  claim is allowed.
- Lane 181 / reused task `01a002d6-8511-79d2-afeb-4348ff78a52a` — complete
  read-only M3 Max Raster implementation preflight in detached
  `/private/tmp/acgc-lane-raster-preflight` at exact PC `251a010b8` and decomp
  `09ca8e8b`. It turns the frozen 128-byte section `0x0400` contract into exact
  neutral-ABI and later raw-PC plans while keeping Raster-owned line/point
  TexCoord-offset masks separate from Texgen/SU bias/cylinder/manual state.
  No edit, build, link, launch, asset, Metal, pixel, or playability claim is
  allowed.
- Lane 182 / reused task `019fff43-def1-7bd2-8e1a-f7e72a6aac5b` — complete,
  archived, and cleaned verification-only M3 Max Metal-device fixture gate in
  the formerly detached
  `/private/tmp/acgc-lane-current-metal-device-fixtures` at exact PC
  `251a010b8` and decomp `09ca8e8b`. It may build and run only explicit
  existing Apple CPU/offline-shader/device encode/readback fixtures under
  `/private/tmp/acgc-lane-current-metal-device-fixtures-{build,asan}`. It
  changed no source/docs/refs and did not link or launch full `ac_pc` or access
  assets. Native passes `9/9`, combined ASan/UBSan CPU fixtures pass `6/6`,
  three offline MSL compilations pass, and the M3 Max offscreen sink completes
  its existing deterministic readback assertions. This is synthetic fixture
  evidence, not a game-owned frame, present, iOS, or playability claim. Evidence
  is `docs/evidence/M3-METAL-DEVICE-FIXTURES-251A010B8-2026-08-14.md`. Its
  exact holder-free worktree and native/ASan roots are absent; refs and evidence
  remain preserved.
- Lane 183 / reused task `01a00297-d958-73f2-a850-d79a18e5f763` — complete
  read-only M3 Max canonical setter-order preflight in detached
  `/private/tmp/acgc-lane-canonical-state-order-preflight`. It compares exact
  canonical PC `251a010b8`, raw Texgen/SU worker `2e3c95dae`, and decomp
  `09ca8e8b` to map every state mutation that occurs before versus after
  `pc_gx_flush_if_begin_complete()`. It owns no source, build, launch, device,
  asset, Metal, pixel, or playability operation. Success unblocks one serial
  post-Texgen state-order repair; it does not authorize that edit. The bounded
  correction confirms `GXEnableTexOffsets` is Raster-owned, the repaired Texgen
  lane covers exactly seven setters, and `GXSetZMode` is the next narrow current
  mutation-before-flush defect; viewport/scissor, Indirect, and resource
  generation remain separate future owners. Evidence is
  `docs/evidence/CANONICAL-SETTER-ORDER-251A010B8-2026-08-14.md`.
- Lane 184 / reused task `01a00297-d958-73f2-a850-d79a18e5f763` — stopped and
  archived after a partial read-only M3 Max canonical Indirect crosswalk at
  exact PC `251a010b8`
  and decomp `09ca8e8b`. It owns no source, branch, build, launch, device,
  asset, Metal, pixel, or playability operation. It freezes the fixed-width
  Indirect layout, matrix/stage/TEV records, enum and bitfield domains,
  knownness, direct-versus-indirect texture-map exclusion, and cross-section
  references. Success unblocks a later neutral ABI lane only after the
  Texture/Dynamic contracts are frozen. The partial result confirms section
  ID `13`/mask `0x1000`, four stages, three physical matrix slots, sixteen TEV
  records, and missing flush-before-mutation in the current PC setters. A
  project-owned restart was not opened because native handoff still returns
  `No matching saved project was found on M3 Max`; no source/build/runtime
  result or downstream claim follows.
- Lane 185 / reused task `01a002f3-0540-7db0-b2ac-052fed62f957` — complete,
  independently reviewed, and integrated. The clean M3 branch
  `c1/lane-depth-flush-order-m3` advanced exact PC `1d48691a4f` to worker
  `a2cbfda07e`; root cherry-picked the exact four-file change as canonical PC
  `9f149b6fd9`. `GXSetZMode` now flushes a completed old batch before changing
  setter-owned raw Depth or legacy effective state. The fixture-only observer
  cannot intercept the normal flush. Exact integrated native and combined
  ASan/UBSan Transform/Depth/TEV/Texgen CTest pass `4/4` each with no sanitizer
  diagnostics (`detect_leaks=0`). Bounded `-m32` syntax passed; missing Windows
  headers/sysroot/toolchain prevent Windows sign-off. The protected remote
  source worktree `/private/tmp/acgc-lane-pc-texgen-shadow` remains because its
  ignored `assets/` and `orig/` paths must not be deleted. All exact local and
  remote generated review/build/bundle paths are retired after holder checks;
  the branch and commits remain. Evidence is
  `docs/evidence/PC-DEPTH-FLUSH-ORDER-9F149B6FD-2026-08-14.md`. No full link,
  launch, renderer, Metal, pixel, device, or playability claim follows.
- Lane 186 / reused task `01a002e1-540c-7693-b25d-363a1f209dd4` — complete,
  independently reviewed, and integrated neutral Channels ABI lane. The clean
  preserved M3 worktree
  `/private/tmp/acgc-lane-channels-lighting-preflight` is on explicit branch
  `c1/lane-canonical-channels-m3` at exact canonical PC `1d48691a4f`; decomp
  remains `09ca8e8b`. It implements only the frozen version-1, section-`0x0004`,
  136-byte pointer-free Channels value ABI and strict validator: exact active
  count/mask, two 64-byte color/alpha-pair records, packed RGBA8 colors,
  boolean/source/light-mask/diffuse/attenuation domains, effective
  `GX_AF_SPEC` diffuse semantics, zero inactive records/reserved fields, and
  exact present/absent envelope metadata. It owns only new
  `include/acgc/gx_canonical_channel_state.h`,
  `src/gx_canonical_channel_state.c`,
  `pc/portable/tests/test_gx_canonical_channel_state.c`, and minimal
  `pc/portable/CMakeLists.txt` registration. `pc_gx`, raw PC state, Lighting,
  Geometry, packet producer, Apple, decomp, full `ac_pc`, LLDB, ISO/assets,
  Metal, pixel, device, and playability are out of scope. References are the
  frozen Channels/Lighting evidence, existing canonical state implementations,
  PC channel state/setters, and decomp `GXLight.c`, `GXInit.c`, `GXEnum.h`, and
  channel callers. Unique roots are
  `/private/tmp/acgc-lane-canonical-channels-{native,asan,win}`. Worker
  `325ecd3625` changes exactly the four owned files; root integrated it as
  canonical PC `324c174ae3`. Independent review passed, and exact integrated
  native plus combined ASan/UBSan canonical CTest pass `9/9` each with no
  sanitizer diagnostics (`detect_leaks=0`). C/C++ ABI, analyzer, diff, and
  bounded `-m32`/Windows-header probes pass; no real Windows
  toolchain/runtime is available. Evidence is
  `docs/evidence/CANONICAL-CHANNELS-STATE-324C174AE-2026-08-14.md`. This proves
  no raw PC Channels producer, runtime, renderer, device, or playability gate.
- Lane 187 / reused task `01a00297-d958-73f2-a850-d79a18e5f763` — complete
  read-only current-tip cumulative-producer readiness audit in clean detached
  `/private/tmp/acgc-lane-cumulative-producer-preflight` at exact PC
  `1d48691a4f` and decomp `09ca8e8b`. It must inventory all fourteen canonical
  sections against their implemented validators and setter-owned raw sources,
  classify exact ready/missing/unknown dependencies after Geometry and
  Texgen/SU integration, verify the all-or-nothing snapshot boundary before
  V1–V4/GL submission. It concludes the next draw-critical source owner is
  immutable Geometry VCD/VAT/array/batch provenance, not a partial cumulative
  packet. Depth ordering and the neutral Channels ABI have since integrated,
  but raw Channels and the other typed/resource dependencies remain open. It
  owns no source, branch, build, test, docs, link, launch, asset, Apple/Metal,
  pixel, device, or playability operation. Evidence is
  `docs/evidence/CANONICAL-PRODUCER-READINESS-1D48691A4-2026-08-14.md`.
- Lane 188 / reused task `01a00275-9cf6-7113-8511-5e9a4d18deff` — complete
  read-only current-tip Apple canonical-plan audit in clean detached
  `/private/tmp/acgc-lane-apple-canonical-plan-preflight` at exact PC
  `1d48691a4f` and decomp `09ca8e8b`. It must reconcile the immutable canonical
  CPU plan, typed consumer/runtime, resource cache/lifetime, geometry/state
  encoder, sink, shader, present, and readback gates against the now-integrated
  Geometry and Texgen/SU prerequisites, with exact file/symbol ownership and
  serial proof order. It finds canonical Geometry schema-ready but not
  producer- or Apple-encoder-ready: cumulative production, typed missing
  sections, stable resource ownership/generations, exact MSL, and the immutable
  Apple CPU plan remain required. It owns no source, branch, build, test,
  device, full link, LLDB, ISO/assets, Metal execution, pixel, iOS, or
  playability claim. Evidence is
  `docs/evidence/APPLE-CANONICAL-PLAN-READINESS-1D48691A4-2026-08-14.md`.
- Lane 189 / reused task `01a002f3-0540-7db0-b2ac-052fed62f957` — complete,
  independently reviewed, and integrated M3 Max Geometry raw-batch lane. The
  first handoff `9ec853b0fb` was blocked on direct `GX_TEX_S` capture and
  INDEX8/INDEX16 API-width mismatches; child repair `401ef1f195` closes both
  findings while preserving the compatibility ABI, legacy host behavior, and
  deliberate sticky-invalid policy. It reused protected worktree
  `/private/tmp/acgc-lane-pc-texgen-shadow`, imports source-only bundle
  `/private/tmp/acgc-canonical-pc-324c174.bundle` (SHA-256
  `7a4a5b3d6b47975456d37bfea522df576a251f1c8b8488a1a5b122cfd5d12c4f`),
  and owns branch `c1/lane-geometry-raw-batch-m3` from exact canonical PC
  `324c174ae3`; decomp remains `09ca8e8b`. It owns only
  `pc/include/pc_gx_internal.h`, `pc/src/pc_gx.c`, a new focused Geometry raw
  fixture, and minimal `pc/CMakeLists.txt`. The gate is immutable VCD/VAT/array
  and completed-batch provenance with direct/index8/index16 semantics,
  old-batch-before-new-state ordering, safe copied lifetime, and fail-closed
  unsupported formats. Portable schemas, cumulative packet/callback, Apple,
  full link, LLDB, assets, Metal, pixel, device, and playability are out of
  scope. Unique roots are `/private/tmp/acgc-lane-geometry-raw-batch-{native,asan,win}`;
  focused and existing raw-state tests ran serially. Worker `9ec853b0fb`
  changes exactly the four owned files; native and combined ASan/UBSan focused
  matrices passed `5/5` each, with no sanitizer diagnostics
  (`detect_leaks=0`). Root cherry-picked the two commits one at a time as
  canonical `b315e57071` then `23c26e520a`; exact integrated native and
  combined ASan/UBSan raw-state matrices pass `5/5` each. Evidence is
  `docs/evidence/PC-RAW-GEOMETRY-BATCH-23C26E520-2026-08-14.md`. This is
  CPU-side provenance evidence and unblocks raw Channels/Lighting ownership
  plus the later pure-C all-or-nothing canonical serializer; it proves no
  callback/Metal/pixel or playability gate.
- Lane 190 / reused task `01a002e1-540c-7693-b25d-363a1f209dd4` — complete,
  independently reviewed, and integrated neutral Lighting ABI lane. It reused
  protected worktree
  `/private/tmp/acgc-lane-channels-lighting-preflight`, branch
  `c1/lane-canonical-lighting-m3`, from exact canonical PC `324c174ae3` and
  decomp `09ca8e8b`. It owns only new canonical Lighting header/source/test and
  minimal `pc/portable/CMakeLists.txt`. The frozen contract is section
  `0x0040`, version 1, 516 bytes, alignment 4, eight 64-byte final light-object
  records, exact loaded mask, zero reserved/unloaded state, finite binary32
  coefficients/position/direction, logical RGBA8, and exact envelope metadata.
  Worker `431eb36735` changes exactly the four owned files; root integrated it
  as canonical PC `43992e7085`. Independent review passed, and exact integrated
  native plus combined ASan/UBSan canonical CTest pass `10/10` each with no
  sanitizer diagnostics (`detect_leaks=0`). Raw PC Lighting, cross-validator,
  producer, Apple, full link, LLDB, assets, device, and playability remain out
  of scope. Evidence is
  `docs/evidence/CANONICAL-LIGHTING-STATE-43992E708-2026-08-14.md`.
- Lane 191 / reused task `01a00297-d958-73f2-a850-d79a18e5f763` — complete
  read-only M3 Max Texture/TLUT plus Dynamic resource-sideband contract audit
  in `/private/tmp/acgc-lane-cumulative-producer-preflight`, detached at exact
  canonical PC `324c174ae3` with decomp `09ca8e8b`. It freezes separate
  pointer-free layouts, logical identities/generations, metadata, invalidation,
  synchronous borrowing versus owned-copy lifetime, and cross-section rules
  without reading resource bytes. It owns no branch, source, build, test, docs,
  launch, asset, Apple/Metal execution, pixel, device, or playability action.
  It freezes Texture section `0x0010` at 1216 bytes and Dynamic section
  `0x2000` at 1600 bytes, stable logical IDs, owner epochs, per-resource
  generations, exact invalidation, and an external synchronous byte lease.
  Success unblocks a neutral Texture/Dynamic ABI lane. Evidence is
  `docs/evidence/CANONICAL-TEXTURE-DYNAMIC-CONTRACT-324C174AE-2026-08-14.md`.
- Lane 192 / reused task `01a00275-9cf6-7113-8511-5e9a4d18deff` — complete
  read-only M3 Max raw Channels producer crosswalk in
  `/private/tmp/acgc-lane-apple-canonical-plan-preflight`, detached at exact
  canonical PC `324c174ae3` with decomp `09ca8e8b`. It maps exact raw structs,
  known/invalid masks, combined/separate and partial-color setter semantics,
  disabled vertex sources, specular effective diffuse behavior, initialization,
  flush ordering, and the future fixture/ownership split. It owns no branch,
  source, build, test, docs, launch, asset, Apple/Metal execution, pixel,
  device, or playability action. It confirms no raw Channels provenance exists
  and freezes per-component knownness, sticky invalidity, combined/separate
  setter behavior, and old-batch ordering. The raw Channels source successor is
  dependency-ready only after Geometry releases `pc_gx` ownership; no refill is
  opened. Evidence is
  `docs/evidence/RAW-CHANNELS-PRODUCER-PLAN-324C174AE-2026-08-14.md`.
- Lane 193 / reused task `01a00297-d958-73f2-a850-d79a18e5f763` — complete,
  independently reviewed, and integrated neutral Texture/TLUT plus Dynamic ABI
  lane. Its first source/test handoff `b8245ad019` passed its focused matrices
  but independent root review found that one shared filter maximum incorrectly
  accepted effective magnification values `2..5`. Repair `096e76c464` splits
  the final logical min (`0..5`) and mag (`0..1`) domains without changing the
  frozen ABI. It reused
  protected
  worktree `/private/tmp/acgc-lane-cumulative-producer-preflight`, imports
  source-only bundle `/private/tmp/acgc-canonical-pc-43992e.bundle` (SHA-256
  `54df26da2f2e943a82a61b2d7e179684b355fce6765c226fce21b2bd3e573890`),
  and owns branch `c1/lane-canonical-texture-dynamic-m3` from exact canonical
  PC `43992e7085`; decomp remains `09ca8e8b`. It owns only new canonical
  Texture and Dynamic header/source pairs, two synthetic portable fixtures,
  and minimal `pc/portable/CMakeLists.txt` registration. It must implement the
  frozen `0x0010`/1216-byte and `0x2000`/1600-byte pointer-free value ABIs,
  strict value/metadata/cross-section validation, explicit little-endian
  fields, stable logical IDs, owner epoch/generation domains, exact byte-size
  overflow checks, zero absent/reserved state, and external-lease metadata
  without accessing bytes. `pc_gx`, `pc_gx_texture`, raw generations/leases,
  cumulative production, Apple, full link, LLDB, assets, Metal, pixel, device,
  and playability are out of scope. Unique roots are
  `/private/tmp/acgc-lane-canonical-texture-dynamic-{native,asan,win}`;
  verification is serial native plus combined ASan/UBSan and bounded
  C/C++/ILP32/Windows syntax. Root cherry-picked the two commits one at a time
  as canonical `cf81b028d9` then `a641e55efb`; exact integrated native and
  combined ASan/UBSan canonical matrices pass `12/12` each with no sanitizer
  diagnostics (`detect_leaks=0`). Evidence is
  `docs/evidence/CANONICAL-TEXTURE-DYNAMIC-A641E55EF-2026-08-14.md`. This
  unblocks a separate raw PC Texture/TLUT state, generation, invalidation, and
  synchronous lease lane, but proves no live resource/callback/Metal/pixel or
  playability gate.
- Lane 194 / reused task `01a002e1-540c-7693-b25d-363a1f209dd4` — complete
  read-only M3 Max raw Lighting producer crosswalk. It reused protected
  worktree `/private/tmp/acgc-lane-channels-lighting-preflight`, verifies and
  detaches read-only to source-only canonical PC `43992e7085`, and crosswalks
  decomp `GXLight.c`/public objects/callers against PC light-object helpers,
  `GXLoadLightObjImm`, `g_gx.lights`, channel masks, shader conversion, and the
  new neutral Lighting ABI. It must freeze exact raw knownness/invalidity,
  RGBA conversion, direction convention, helper semantics, one-hot slot
  validation, flush-before-mutation, initialization, and a deterministic
  fixture/ownership plan. It owns no branch, source, build, test, docs, link,
  LLDB, resource bytes, assets, Apple/Metal execution, pixel, device, or
  playability action. The audit freezes pointer-free per-slot known/invalid
  state, register-to-logical RGBA conversion, final direction semantics,
  immediate versus unresolved indexed loads, channel-reference validation,
  and old-batch-before-mutation ordering. Evidence is
  `docs/evidence/RAW-LIGHTING-PRODUCER-PLAN-43992E708-2026-08-14.md`.
  Success unblocks a raw Lighting source lane only after lane 189 releases
  `pc_gx` ownership.
- Lane 195 / reused task `01a00275-9cf6-7113-8511-5e9a4d18deff` — complete M3 Max
  raw Channels source/test lane at exact canonical PC
  `23c26e520a` and decomp `09ca8e8b`. It may reuse protected clean worktree
  `/private/tmp/acgc-lane-apple-canonical-plan-preflight`, import source-only
  bundle `/private/tmp/acgc-canonical-pc-23c26e.bundle` (SHA-256
  `5732e20f137ff5aa336fb07a65965afde93c269eb7f7390406bf0a7397347fec`),
  and create branch `c1/lane-raw-channels-m3`. Exact ownership is
  `pc/include/pc_gx_internal.h`, new `pc/src/pc_gx_channels_raw.c`, narrow
  calls in `pc/src/pc_gx.c`, one new raw Channels fixture, and minimal
  `pc/CMakeLists.txt`. It must implement the frozen per-component knownness,
  combined/separate control and color semantics, sticky invalidity,
  old-batch-before-mutation order, exact 136-byte serialization, and
  fail-closed malformed domains while preserving legacy GL/Windows behavior.
  Raw Lighting, Texture/TLUT, cumulative packet, Apple, full link, LLDB,
  ISO/assets, Metal, pixel, device, and playability are out of scope. Unique
  roots are `/private/tmp/acgc-lane-raw-channels-{native,asan,win}`. Focused
  native and combined ASan/UBSan serial verification can prove only the CPU raw
  Channels contract. Success releases `pc_gx` for the raw Lighting lane and
  supplies the Channels dependency to the cumulative producer. Worker branch
  `c1/lane-raw-channels-m3` is clean at repaired final `fe4aac5259`; replacement
  source-only bundle `/private/tmp/acgc-lane-195-raw-channels.bundle` has
  SHA-256 `8ce913b763a03de15ccca91a5fab3b7e50af02c0c5a63fa00261aea0722704f5`
  and requires exact base `23c26e520a`. The repaired final tree is integrated
  as canonical PC `38343a5eb5`; native and combined ASan/UBSan focused
  raw-state matrices pass `7/7` each. Evidence is
  `docs/evidence/PC-RAW-CHANNELS-38343A5EB-2026-08-14.md`.
- Lane 196 / reused task `01a00297-d958-73f2-a850-d79a18e5f763` — complete M3 Max
  read-only raw Texture/TLUT ownership audit at exact
  canonical PC `23c26e520a` and decomp `09ca8e8b`. It may reuse protected
  clean worktree `/private/tmp/acgc-lane-cumulative-producer-preflight`, import
  the same verified source-only bundle, and detach read-only to the exact tip.
  It must crosswalk `PCGXTextureSource`, `pc_gx_texture.c` map/TLUT caches,
  generation/invalidation and flush ordering against decomp `GXTexture.c`,
  callers, and the integrated neutral Texture/Dynamic validators. It must
  freeze exact raw structs, known/invalid/generation/owner-epoch rules,
  synchronous lease lifetime, setter ownership, one focused future fixture,
  and non-overlap with lane 195. It owns no source, branch, build, test, docs,
  full link, LLDB, resource-byte/ISO/asset access, Apple/Metal execution,
  pixel, device, or playability action. Success unblocks one bounded raw
  Texture/TLUT source lane after lane 195 releases shared `pc_gx` ownership.
  The audit froze a private pointer-free eight-map/sixteen-TLUT shadow, stable
  image/TLUT IDs, owner-epoch and generation rules, tiled-size derivation, and
  an all-or-nothing synchronous lease at `pc_gx_flush_vertices`. Evidence is
  `docs/evidence/RAW-TEXTURE-TLUT-PRODUCER-PLAN-23C26E520-2026-08-14.md`.
- Lane 197 / reused task `01a002e1-540c-7693-b25d-363a1f209dd4` — complete M3
  Max verification-only lane at exact canonical PC
  `23c26e520a` and decomp `09ca8e8b`. It may reuse protected clean worktree
  `/private/tmp/acgc-lane-channels-lighting-preflight`, import the verified
  `23c26e520a` source-only bundle, and detach read-only to the exact tip. Unique
  roots are `/private/tmp/acgc-lane-current-23c-matrix-{native,asan,win}`. It
  owns no source, branch, docs, or runtime path. The gate is the exact serial
  seventeen-target matrix combining twelve neutral canonical validators with
  the TEV/Transform/Depth/Texgen/Geometry raw fixtures, native and combined
  ASan/UBSan, plus bounded shared-header C/C++/ILP32/Windows syntax probes. No
  full `ac_pc` link, LLDB, resource byte, ISO/asset, Apple/Metal device,
  pixel, or playability operation is allowed. Success proves only the focused
  integrated CPU baseline and supplies an independent regression check before
  lane 195 hands off source. Native and combined ASan/UBSan matrices pass
  `17/17` each with no sanitizer report; C/C++11, ILP32, and bounded Windows
  header probes pass, while a real i686 Windows build remains toolchain-blocked.
  Evidence is
  `docs/evidence/CURRENT-FOCUSED-MATRIX-23C26E520-2026-08-14.md`.
- Lane 198 / reused task `01a002e1-540c-7693-b25d-363a1f209dd4` — complete
  M3 Max read-only independent review of lane 195. It must verify bundle
  `989a4d3b49125098abb4d854bd06a3f59873260cdb54ef9f1c677d5e7bbeacd8`,
  exact parent `23c26e520a`, final `c9eec84b0e`, five-file ownership, both
  upstreams, raw/canonical semantics, legacy Windows/GL preservation, and
  native plus combined ASan/UBSan evidence. It owns no source, branch, docs,
  build, full link, LLDB, resource bytes, Apple/Metal, pixel, device, or
  playability action. It returned PASS for the initial candidate's five-file
  mapping and fail-closed behavior but did not identify the frozen plan's
  persistence contradiction. Root review therefore supersedes that PASS and
  lane 199 remains the required repair before integration.
- Lane 199 / reused task `01a00275-9cf6-7113-8511-5e9a4d18deff` — complete,
  reviewed, and integrated M3 Max source/test repair on
  `c1/lane-raw-channels-m3`, advancing initial `c9eec84b0e` to repaired final
  `fe4aac5259`.
  It owns only `pc/src/pc_gx_channels_raw.c` and the focused Channels fixture.
  `pc_gx_raw_channels_set_num` must preserve inactive controls/colors as the
  original GX register state does; canonical conversion must zero inactive
  output records without requiring the private inactive raw records to be
  zero. The fixture must prove count `2 -> 0 -> 2` reactivation without
  reissuing controls/colors and a valid zero-channel canonical section while
  private state is retained. No other production file, full link, LLDB,
  resource, Apple/Metal, pixel, device, or playability scope is authorized.
  The repair preserves private records across `2 -> 0 -> 1 -> 2`, zeroes only
  inactive canonical output, and passes native plus combined ASan/UBSan
  seven-target matrices. Root integrated the final tree as one canonical
  commit `38343a5eb5`, avoiding the known-broken intermediate history. No
  cumulative packet, full link, LLDB, Metal, pixel, device, or playability
  claim follows.
- Lane 200 / reused project-owned M3 task
  `01a00275-9cf6-7113-8511-5e9a4d18deff` — complete, reviewed, integrated,
  and archive-ready raw Lighting source/test successor. The verified tracked-source-only bundle
  `/private/tmp/acgc-canonical-pc-38343a5.bundle` has SHA-256
  `11f1631915c8e97ae9d48b79ef3132b8083cfc756a2efe1e2b4f1d258fdfa0ce`,
  contains exact canonical PC `38343a5eb5`, and requires base `23c26e520a`.
  The dedicated PC worktree is `/private/tmp/acgc-lane-raw-lighting-m3` on
  branch `c1/lane-raw-lighting-m3` at exact base `38343a5eb5`; decomp remains
  `09ca8e8b`. It owns only `pc/include/pc_gx_internal.h`, a narrow new
  `pc/src/pc_gx_lighting_raw.c`, Lighting setter/load calls in
  `pc/src/pc_gx.c`, one focused raw Lighting fixture, and minimal
  `pc/CMakeLists.txt` registration. The frozen contract is
  `docs/evidence/RAW-LIGHTING-PRODUCER-PLAN-43992E708-2026-08-14.md`.
  Raw Channels, Geometry, Texture/TLUT, the cumulative packet, Apple files,
  umbrella docs/gitlink, full `ac_pc` link, LLDB, ISO/assets, Metal, pixel,
  device, iOS, and playability are out of scope. Unique roots are
  `/private/tmp/acgc-lane-raw-lighting-{native,asan,win}`. Success requires a
  clean worker commit, exact two-upstream crosswalk, focused native and
  combined ASan/UBSan serial results, static probes, and a bounded handoff. The
  clean worker commit is `97aebd8a2d` on `c1/lane-raw-lighting-m3`, based
  directly on `38343a5eb5`; it changes exactly the five authorized files and
  reports native plus combined ASan/UBSan `9/9` each. Root imported a verified
  Git-only bundle with SHA-256
  `6a2ba66a08968c73889ff45aa639856c6629c6a1abf8bcc7d2c266624ab78165`
  into detached local review `/private/tmp/acgc-review-raw-lighting-97a`.
  Independent lane 202 returned `PASS`; root fast-forwarded the exact tree to
  canonical `c1/macos-host-launch` and fresh integrated native plus combined
  ASan/UBSan matrices pass `9/9` each, with both production objects compiling.
  Evidence is
  `docs/evidence/PC-RAW-LIGHTING-97AEBD8A2-2026-08-14.md`. No
  full link, LLDB, callback, Metal, pixel, device, or playability claim follows.
- Lane 201 / reused project-owned M3 task
  `01a002e1-540c-7693-b25d-363a1f209dd4` — complete, reviewed, and archived
  verification-only successor
  at exact canonical PC `38343a5eb5` and decomp `09ca8e8b`. It uses the same
  verified tracked-source-only bundle as lane 200 but owns no source, branch,
  docs, or gitlink. Its separate detached source path is
  `/private/tmp/acgc-lane-current-383-matrix-source`, with unique generated
  roots `/private/tmp/acgc-lane-current-383-matrix-{native,asan,win}`. The
  exact gate is twelve neutral validators plus raw TEV, Transform, Depth,
  Texgen/SU, Geometry, and Channels fixtures. Native and combined ASan/UBSan
  each pass `18/18` serially; the corrected public C/C++11, ILP32, host
  `_WIN32`, and i686 ABI probes pass. The Windows CMake attempt stops before a
  build because host SDL imports Apple framework features, and private PC
  syntax remains toolchain/header blocked. This is not Windows sign-off. Exact
  commands and boundaries are recorded in
  `docs/evidence/CURRENT-FOCUSED-MATRIX-38343A5EB-2026-08-14.md`. No full link,
  LLDB, game/resources,
  Apple/Metal device, pixel, input/audio/save, iOS, or playability action is
  authorized. Its exact source/native/ASan/Windows roots are retired.
- Lane 202 / reused project-owned M3 task
  `01a002e1-540c-7693-b25d-363a1f209dd4` — complete and archived independent read-only review
  of lane 200. It is pinned to PC base `38343a5eb5`, candidate
  `97aebd8a2d`, decomp `09ca8e8b`, and the clean M3 worker path
  `/private/tmp/acgc-lane-raw-lighting-m3`. It owns no source, branch, tests,
  docs, gitlink, build root, or bundle. It must inspect the exact five-file diff
  against the frozen raw-Lighting plan, canonical Channels/Lighting validators,
  the PC legacy GL/Windows path, and decomp `GXLight.c`, `GXInit.c`,
  `GXVerify.c`, public types/enums, and representative callers. It returns
  `PASS` after resolving the actual PC `GXColor` object-byte ABI and finding no
  candidate-owned blocker; lane-200 test results were reported evidence only.
  No build, launch, LLDB, resource access, callback,
  Metal, pixel, device, iOS, Windows sign-off, or playability scope is allowed.
- Lane 203 / reused project-owned M3 task
  `01a00275-9cf6-7113-8511-5e9a4d18deff` — complete, reviewed, integrated,
  and archive-ready M3 Max raw Texture/TLUT source/test successor. The local setup placeholder
  `01a004ae-d74c-7d13-8be7-e8fdfb897318` is archived and is not a worker. The
  exact gate
  is the pointer-free raw map/TLUT owner epoch, per-resource generations,
  mutation/invalidation boundary, canonical Texture/Dynamic conversion, and
  synchronous callback-scoped byte lease frozen in
  `docs/evidence/RAW-TEXTURE-TLUT-PRODUCER-PLAN-23C26E520-2026-08-14.md`.
  It is based on canonical PC `97aebd8a2d` and decomp `09ca8e8b`. Initial
  worker commit `4e6caa0b3e` was held after root review found that TLUT load and
  native-endian conversion dropped unrelated non-indexed image leases. Child
  repair `698d45d3e` decouples legacy source clearing from raw lease lifetime,
  preserves global invalidation at true cache/clear/destroy boundaries, and
  adds exact nondependent-survival/dependent-invalidation assertions. The final
  canonical source is `c1/macos-host-launch` at `698d45d3e`. The owning branch
  is `c1/lane-raw-texture-tlut-m3` in dedicated remote PC worktree
  `/private/tmp/acgc-lane-raw-texture-tlut-m3`, initialized clean at
  `97aebd8a2df935ebfc8d69dfc9419b54d063ddeb` from verified tracked-source-only
  bundle `/private/tmp/acgc-canonical-pc-97aebd8.bundle` (SHA-256
  `bbe76092b9db2d089e68f4bfd3687015a6d4cb3bae7a49c817f6456d1264d360`).
  Owned files are new `pc/include/pc_gx_texture_raw_state.h`, raw texture/TLUT
  state and mutation calls in `pc/src/pc_gx_texture.c`, new
  `pc/src/pc_gx_canonical_snapshot.c`, one narrow producer call in
  `pc/src/pc_gx.c`, one focused
  `pc/tests/pc_gx_texture_dynamic_producer_fixture.c`, and minimal
  `pc/CMakeLists.txt`; only a proven converted-image provenance marker at the
  relevant emu64 call site may be added after an explicit crosswalk. All Apple
  files, cumulative multi-section packet policy, renderer code, unrelated GX
  state, ISO/assets, full `ac_pc` link, LLDB, Metal/device, pixel, iOS, and
  playability are out of scope. Worker roots are
  `/private/tmp/acgc-lane-raw-texture-tlut-{native,asan,win}`. Exact local
  integrated verification roots are
  `/private/tmp/acgc-integrate-raw-texture-tlut-698-{native,asan}`. The mandatory
  two-upstream crosswalk covers PC `pc_gx_internal.h`, `pc_gx_texture.c`,
  `pc_gx.c`, the canonical Texture/Dynamic validators and fixtures, plus
  decomp `GXTexture.c`, `GXInit.c`, public GX enums/structs, and representative
  emu64/JUT/game callers. Focused native and combined ASan/UBSan serial tests,
  C/C++11 and bounded compatibility probes, `git diff --check`, exact refs,
  and a clean handoff pass. Remote and exact integrated native plus combined
  ASan/UBSan focused matrices pass `7/7` each, with leak detection disabled and
  no sanitizer diagnostics. Evidence is
  `docs/evidence/PC-RAW-TEXTURE-TLUT-698D45D3E-2026-08-15.md`. This unblocks a
  separately owned cumulative all-or-nothing snapshot producer; it does not
  prove a full link, live callback, Metal encode/present/readback, pixel,
  device, or playability gate.
- Lane 204 / project-owned M3 task
  `01a004f3-1941-7731-a310-d5ad1f52011b` — complete, reviewed, integrated,
  and archived raw Alpha/ZCompLoc producer lane. Worker branch
  `c1/lane-raw-alpha-zcomp-m3` advanced from canonical PC base `698d45d3e`
  through initial commit `35b1e7a2d` to repaired final `ae5102de3`; root
  squashed the accepted four-file end state onto newer canonical `b3336504c`
  as `039afce0e`. Exact ownership is `pc/CMakeLists.txt`,
  `pc/include/pc_gx_internal.h`, `pc/src/pc_gx.c`, and
  `pc/tests/pc_gx_alpha_raw_shadow_fixture.c`. It adds setter-owned Alpha
  known/invalid provenance, captures `GXSetZCompLoc` with completed-batch
  flush-before-mutation ordering, converts only complete valid state through
  the existing canonical Alpha ABI, and enables/links the builder on the real
  `ac_pc` target. A narrow production-object target prevents fixture-only
  compile-definition success. Root retracted the initial malformed-`GXBool`
  repair request after confirming `TARGET_PC` uses C `bool`; the final fixture
  contains no ABI-mismatched boolean call and instead checks the representable
  out-of-range `GXCompare` domain. Fresh integrated native and combined
  ASan/UBSan focused CTest pass `2/2` each, the production object compiles in
  both roots, no diagnostics were emitted, and leak detection was disabled.
  Evidence is
  `docs/evidence/PC-RAW-ALPHA-ZCOMP-039AFCE0E-2026-08-15.md`. No cumulative
  envelope, full link, runtime, callback, Metal, pixel, device, or playability
  claim follows.
- Lane 205 / project-owned M3 task
  `01a004f3-3ae3-7560-9c9c-e1799056aad6` — complete, reviewed, integrated,
  and archive-ready portable canonical Raster ABI lane. Worker branch
  `c1/lane-canonical-raster-m3` advanced from base `698d45d3e` to clean commit
  `b3336504c`, now fast-forwarded onto canonical `c1/macos-host-launch`. The
  exact four-file delta is new `include/acgc/gx_canonical_raster_state.h`, new
  `src/gx_canonical_raster_state.c`, one portable validator/roundtrip fixture,
  and minimal `pc/portable/CMakeLists.txt` registration. Section `0x0400`,
  version `1`, is exactly 128 bytes/32 words with strict finite viewport,
  scissor, offset, clip, cull, line/point, dither, destination-alpha, field,
  and reserved-zero validation. Fresh integrated native and combined
  ASan/UBSan canonical matrices pass `13/13` each with no diagnostics and leak
  detection disabled. Evidence is
  `docs/evidence/CANONICAL-RASTER-STATE-B3336504C-2026-08-15.md`. This is
  CPU/contract proof only; raw Raster, cumulative production, full link,
  callback, Metal, pixel, device, and playability remain open.
- Lane 206 / project-owned M3 task
  `01a004f2-96c0-79c2-8c20-c9b028bb5018` — complete, reviewed, and
  archive-ready read-only cumulative producer-readiness reconciliation. Its concrete detached source
  path is `/private/tmp/acgc-lane-current-producer-readiness-m3` at PC
  `698d45d3e`; decomp is `09ca8e8b`. It changed nothing and ran no build. The
  audit concludes that a full cumulative producer is not dependency-ready:
  raw owners/converters, portable Texgen/SU and Indirect sections, complete
  Geometry serialization, the all-or-nothing envelope/lease assembler, and
  the Apple complete-envelope consumer remain open. Canonical `b3336504c`
  closes only the audit's portable Raster-ABI row. Evidence is
  `docs/evidence/CURRENT-CUMULATIVE-PRODUCER-READINESS-698D45D3E-2026-08-15.md`;
  no build, launch, callback, Metal, pixel, device, or playability claim.
- Lane 207 / project-owned M3 task
  `01a004f3-5a55-7702-95ec-8acf22b8b806` — complete, reviewed, and
  archive-ready read-only Indirect contract and raw-ownership audit. Its concrete detached source path is
  `/private/tmp/acgc-lane-indirect-contract-m3` at PC `698d45d3e`; decomp
  is `09ca8e8b`. It changed nothing and ran no build. The accepted proposed
  contract uses reserved section ID `13` / mask `0x1000`, version `1`, and one
  248-byte/62-word shared count/order/scale/matrix value record; the nine
  per-stage Indirect fields remain owned by canonical TEV. The smallest next
  source owner is a portable header/source/fixture/CMake lane only. Evidence is
  `docs/evidence/CANONICAL-INDIRECT-CONTRACT-698D45D3E-2026-08-15.md`; no
  build, full link, LLDB, callback, Metal, pixel, device, or playability claim.
- Lane 208 / reused project-owned M3 task
  `01a004f3-3ae3-7560-9c9c-e1799056aad6` — complete, reviewed, integrated,
  and archived raw Raster source/test lane. Worker branch
  `c1/lane-raw-raster-m3` advanced exact base `039afce0e` through initial
  `e5b0b9fc4` and repair `c04ffb385`; the reviewed range was applied onto the
  newer canonical `a42da8e155` tip as `c2b5bd929` plus canonical PC
  `85b25cb3c`. Its exact four-file range adds a setter-owned raw Raster shadow,
  all-or-nothing converter to the existing 128-byte ABI, production-object
  compile target, and focused fixture. Root review held the initial candidate
  because `GXSetViewportJitter(field=0)` still omitted decomp's half-pixel top
  adjustment; the same task repaired it and covered both jitter branches.
  Fresh exact-tip native and combined ASan/UBSan focused CTest pass `2/2`
  each, the production Raster object compiles in both roots, and no sanitizer
  diagnostic is emitted (`detect_leaks=0`). Evidence is
  `docs/evidence/PC-RAW-RASTER-85B25CB3C-2026-08-15.md`. This is CPU/source
  proof only; no envelope, full link, callback, Metal, pixel, device, Windows
  runtime, or playability claim follows.
- Lane 209 / reused project-owned M3 task
  `01a004f3-5a55-7702-95ec-8acf22b8b806` — complete, reviewed, integrated, and
  archived portable canonical Indirect ABI lane. Worker branch
  `c1/lane-canonical-indirect-m3` advanced exact base `039afce0e` to direct
  child `a42da8e155`, now fast-forwarded onto canonical
  `c1/macos-host-launch`. Its exact four-file delta is a new Indirect header,
  validator implementation, focused portable fixture, and minimal portable
  CMake registration. Section ID `13`, mask `0x1000`, version `1`, is exactly
  248 bytes/62 words; validation freezes metadata/layout, values,
  reserved/inactive records, TEV-owned stage/matrix references, optional
  Texture/Texgen dependencies, and the direct/Indirect texture-map collision.
  Remote and fresh local native plus combined ASan/UBSan focused CTest pass
  `1/1` each with no diagnostics (`detect_leaks=0`). Evidence is
  `docs/evidence/CANONICAL-INDIRECT-STATE-A42DA8E15-2026-08-15.md`. Raw
  Indirect ownership/conversion, envelope production, full link, callback,
  Metal, pixel, device, Windows runtime, and playability remain open.
- Lane 210 / reused project-owned M3 task
  `01a004f2-96c0-79c2-8c20-c9b028bb5018` — complete, reviewed, and
  archived read-only Geometry conversion audit at exact PC `039afce0e`
  and decomp `09ca8e8b`. Its detached clean source scope is
  `/private/tmp/acgc-lane-geometry-converter-audit-m3`; it created no branch,
  edit, build, or test root. The completed `PCGXRawGeometry` batch safely
  preserves copied values and generation metadata for a bounded subset, but a
  full canonical producer is not dependency-ready: mid-`GXBegin` setter
  mutation, caller-array lifetime, CLR1/TEX1–7/array/matrix/NBT coverage,
  canonical byte conversion, cross-section dependencies, and completed-copy
  lifetime remain open. The smallest successor first closes raw Geometry in
  `pc_gx_internal.h`, `pc_gx.c`, and the existing raw fixture, but it must wait
  until lane 208 releases overlapping `pc_gx.c` ownership; a later separate
  producer owns only new PC converter files and its fixture. Evidence is
  `docs/evidence/CURRENT-GEOMETRY-CONVERTER-READINESS-039AFCE0E-2026-08-15.md`.
  No build, full link, LLDB, runtime, Metal, pixel, device, or playability claim
  follows.
- Lane 211 / project-owned M3 task
  `01a0055c-6bac-7743-84f8-6ceb8bf0daf4` — complete, reviewed, integrated, and
  archived; first handoff was blocked and repaired by one child.
  The task is visibly nested under
  the remote `acgc-modern-port` project
  and runs `gpt-5.6-luna` with max reasoning. Its Codex umbrella worktree
  `/Users/testtest/.codex/worktrees/5f1b/acgc-modern-port` is a stale detached
  setup snapshot at `ee31f535` with PC gitlink `a53b192`; it is provenance only
  and must not be edited or cited as current source. The authoritative
  source-only bundle `/private/tmp/acgc-canonical-pc-85b25cb.bundle` has
  SHA-256
  `5aa5c6bf21b4e1ed9f254139802a886dc5f649ca78bc2b69f1b8ee106142bc46`.
  The concrete clean source checkout is
  `/private/tmp/acgc-lane-raw-geometry-closure-m3` on explicit branch
  `c1/lane-raw-geometry-closure-m3` at exact PC `85b25cb3c`; the read-only
  decomp oracle is clean `09ca8e8b`. Ownership is limited to raw Geometry
  declarations in `pc/include/pc_gx_internal.h`, raw Geometry/VCD/VAT/array and
  draw-capture ordering in `pc/src/pc_gx.c`, the focused
  `pc/tests/pc_gx_geometry_raw_batch_fixture.c`, and minimal existing
  `pc/CMakeLists.txt` registration. It must freeze mid-`GXBegin` mutation,
  supported attributes, array/completed-copy lifetime, finite/value domains,
  and fail-closed unsupported CLR1/TEX1-7/matrix-array/NBT cases. Unique roots
  are `/private/tmp/acgc-lane-raw-geometry-closure-{native,asan,win}`. Canonical
  Geometry production, the cumulative envelope, Apple/Metal, full `ac_pc`,
  LLDB, launch, device, ISO/assets, and playability are out of scope. Success
  proves CPU/source raw Geometry semantics only and unblocks a separately owned
  canonical Geometry producer. The clean worker branch advanced exact base
  `85b25cb3c` to `1730823d45` in exactly the four owned files. Native focused
  build/CTest and combined ASan/UBSan CTest each pass `1/1`; host syntax probes
  pass, while no real i686 Windows toolchain is installed. The source-only
  handoff bundle has SHA-256
  `4e6ab587db263312c72156536c25e7dceced5ccb9d24b64733d33b0e8d8f7a58`.
  Independent review found two candidate-owned blockers: raw-valid indexed
  non-F32 POS/NRM/TEX0 values do not reach the host mirror, and direct packed
  color entry-point width plus RGBX8's ignored X byte are not preserved. The
  same branch added exactly one child commit `5679bff656` without rewriting
  blocked parent `1730823d45`. The child changes only `pc/src/pc_gx.c` and
  `pc/tests/pc_gx_geometry_raw_batch_fixture.c`; native focused build/CTest and
  combined ASan/UBSan CTest each pass `1/1`, with `detect_leaks=0` and no
  sanitizer diagnostics. It adds typed indexed host decoding with VAT fraction
  scaling, signed normal normalization, finite-F32 checks, shared overflow-safe
  array validation, explicit invalid-position/no-op fallback behavior, RGBX8
  ignored-byte normalization, and strict 2/3/4-byte packed-color API/VAT
  matching. The source-only repair bundle has SHA-256
  `344e76694b94c25f9e29eb9de99f9d136dbb842c72fcafc4760fa8615adb67fc`.
  Lane 215 passed the child, and root integrated the cumulative end state as one
  canonical squash `b9a9f355` so the blocked intermediate is not recorded on
  `c1/macos-host-launch`. Exact-tip native and combined ASan/UBSan focused CTest
  pass `1/1` each; both builds also compile the production Geometry object.
  Evidence is `docs/evidence/RAW-GEOMETRY-REVIEW-1730823D-2026-08-15.md` and
  `docs/evidence/PC-RAW-GEOMETRY-CLOSURE-B9A9F355-2026-08-15.md`.
- Lane 212 / project-owned M3 task
  `01a00562-c9bc-7b70-9d2e-de9232703062` — complete, reviewed, and archived
  read-only raw Indirect ownership/conversion crosswalk. The visible project worktree is
  `/Users/testtest/.codex/worktrees/53c8/acgc-modern-port`; the concrete clean
  source scope is `/private/tmp/acgc-lane-raw-indirect-crosswalk-m3`, detached
  at exact PC `85b25cb3c`, with decomp `09ca8e8b` read-only. It owns the
  reference map for `GXSetNumIndStages`, Indirect order/scale/matrix setters,
  TEV Indirect/direct calls, initialization/callers, mutation ordering,
  known/invalid provenance, and the smallest later raw-producer fixture. It
  must preserve the accepted section-13 shared-state boundary while leaving
  nine per-stage Indirect fields with canonical TEV. It is forbidden to edit,
  build, branch, commit, or overlap lane 211's active `pc_gx.c` ownership. Its
  output is `docs/evidence/RAW-INDIRECT-PRODUCER-READINESS-85B25CB3C-2026-08-15.md`.
  It proves planning/reference readiness only, not implementation, runtime,
  Metal, pixel, device, or playability.
- Lane 213 / project-owned M3 task
  `01a00563-bd2c-7cf0-aa82-d5773a4ccdae` — complete verification-only exact-tip
  matrix. The visible project worktree is
  `/Users/testtest/.codex/worktrees/e9fb/acgc-modern-port`. It reconstructs a
  clean detached source at `/private/tmp/acgc-lane-current-85b-matrix-source`
  from the verified source-only `85b25cb3c` bundle, then uses unique native,
  combined ASan/UBSan, and bounded Windows-probe roots
  `/private/tmp/acgc-lane-current-85b-matrix-{native,asan,win}`. It owns no
  source file and must reproduce the prior focused producer/canonical matrix,
  explicitly list any new exact-tip tests, run serially with
  `detect_leaks=0`, and keep host syntax/ILP32 probes separate from real
  Windows sign-off. Full `ac_pc`, LLDB, launch, device, Metal, pixel,
  input/audio/save, ISO/assets, and playability remain out of scope. Native and
  combined ASan/UBSan serial builds and CTest each pass `21/21` with no
  sanitizer diagnostics (`detect_leaks=0`); public ABI probes pass `8/8` and
  bounded production syntax probes pass `6/6`. Missing i686 headers/toolchain
  and host-SDL CMake features remain Windows blockers, not Windows sign-off.
  Evidence is
  `docs/evidence/CURRENT-FOCUSED-MATRIX-85B25CB3C-2026-08-15.md`. This proves
  only the pre-lane-211 exact-tip CPU/source baseline.
- Lane 214 / reused project-owned M3 verification task
  `01a00563-bd2c-7cf0-aa82-d5773a4ccdae` — complete independent read-only review
  of raw Geometry worker `1730823d45` against base `85b25cb3c` and decomp
  `09ca8e8b`. It must inspect exactly the four lane-211 files and the
  two-upstream crosswalk, with special attention to invalid indexed-position
  fallback, `GXSetArray` size/stride bounds, supported attribute slots,
  matrix/NBT fail-closed behavior, packed-color validation, mid-batch
  invalidation, and fixture-only CMake defines. It owns no edit, branch, build,
  cleanup, full link, LLDB, runtime, Metal, pixel, device, or playability claim.
  It returned `BLOCK`: raw-valid indexed non-F32 scalar data can produce zero
  or stale host values; RGBX8 rejects a valid ignored byte; and the direct
  color wrappers lose 2/3/4-byte FIFO-width provenance. Evidence is
  `docs/evidence/RAW-GEOMETRY-REVIEW-1730823D-2026-08-15.md`. No build or source
  edit occurred.
- Lane 215 / reused project-owned M3 verification task
  `01a00563-bd2c-7cf0-aa82-d5773a4ccdae` — complete independent read-only child
  review, ready to archive. It reused the archived lane-214 task only for review continuity and
  inspects blocked parent `1730823d45` through child `5679bff656` against base
  `85b25cb3c` and decomp `09ca8e8b`. It owns no production edit, branch, build,
  cleanup, full link, LLDB, runtime, Metal, pixel, device, or playability claim.
  The review must prove the two lane-214 blockers are closed without regressing
  overflow-safe indexed reads, VAT scaling/normalization, deferred position
  ordering, packed-color entry-width provenance, RGBX8 ignored-byte semantics,
  unsupported attribute fail-closed behavior, or the legacy host update
  boundary. It returned `PASS`: bundle hash/ancestry/file scope and
  `git diff --check` matched, both lane-214 blockers are closed, no material
  child-owned issue was found, and the reviewer crosswalked the clean canonical
  decomp tree at `09ca8e8b` rather than the stale task worktree's uninitialized
  submodule.
- Lane 216 / reused project-owned M3 Geometry task
  `01a004f2-96c0-79c2-8c20-c9b028bb5018` — complete, reviewed, integrated,
  and archive-ready. Its first handoff returned clean branch
  `c1/lane-canonical-geometry-producer-m3` at `5aba10371f` from base
  `b9a9f355`, changing exactly the four contracted producer/fixture/CMake
  files. Remote native and combined ASan/UBSan focused CTest pass `1/1` each
  after root review caught and the worker repaired direct-source uniqueness,
  indexed array-metadata bounds, and output-size alias atomicity. The protected
  source-only review bundle is
  `/private/tmp/acgc-lane-216-canonical-geometry-producer.bundle`, SHA-256
  `c567f54c51c72664fd38488a65971faccb6ab410543173c38a0ac33f215255f4`.
  This is a CPU/source handoff only and is not accepted or integrated. Lane 218
  found that exact-boolean/tail metadata validation and direct-quad,
  explicit-INDEX16-endian, and output/scratch-overlap fixture proof were still
  missing. The same lane 216 branch now owns only that producer/test repair and
  must return a child commit plus fresh native and combined ASan/UBSan `1/1`
  evidence before a new independent review. It returned clean child
  `5324c8739e` on the same branch, changing only the producer source and focused
  fixture. Fresh native and combined ASan/UBSan CTest pass `1/1` each with no
  sanitizer diagnostics and `detect_leaks=0`; `git diff --check` passes. The
  refreshed protected source-only bundle has SHA-256
  `b78573c42dfa8bda2c1a09e0369539fb16e9da117a09de27673b11611fe7c9b6`.
  Lane 220 returned `PASS`. Root imported the two worker commits one at a time
  as canonical `099a66ad` and `689590cc`, then rebuilt the producer object and
  fixture in fresh native and combined ASan/UBSan roots. Both exact-tip CTest
  runs pass `1/1`; no sanitizer diagnostic was emitted with
  `detect_leaks=0`. Evidence is
  `docs/evidence/CANONICAL-GEOMETRY-PRODUCER-689590CC-2026-08-15.md`.
  The lane was originally registered as an active canonical Geometry producer
  source/test lane. It reuses the completed lane-210 Geometry audit task for
  direct ownership continuity and runs `gpt-5.6-luna` with max reasoning. The
  authoritative source-only bundle is
  `/private/tmp/acgc-canonical-pc-b9a9f35.bundle` with SHA-256
  `019d97d9bbe4a0d22565a8233f052a43399d9d2dd7c0e4471f6f35284668768a`.
  It must create clean source
  `/private/tmp/acgc-lane-canonical-geometry-producer-m3` on explicit branch
  `c1/lane-canonical-geometry-producer-m3` at exact PC `b9a9f355`, with decomp
  `09ca8e8b` read-only. Ownership is limited to new
  `pc/include/pc_gx_geometry_producer.h`, new
  `pc/src/pc_gx_geometry_producer.c`, one new focused producer fixture, and
  minimal `pc/CMakeLists.txt` registration. It may not edit `pc_gx.c`,
  `pc_gx_internal.h`, canonical Geometry ABI/validator files, the cumulative
  envelope, Apple/Metal files, decomp, or any ISO/assets path. The producer must
  consume only an immutable completed raw batch plus explicit dependency
  results, use the frozen canonical decoder/validator APIs, write to caller-owned
  output only after full success, and fail closed on unsupported matrix/NBT,
  CLR1/TEX1-7, malformed metadata, missing dependencies, overflow, or capacity.
  Unique roots are
  `/private/tmp/acgc-lane-canonical-geometry-producer-{native,asan,win}`. Native
  and combined ASan/UBSan focused build/CTest plus bounded syntax probes are the
  only allowed verification. Full `ac_pc`, LLDB, runtime, Metal, pixel, device,
  ISO/assets, Windows sign-off, and playability are out of scope. Success
  unblocks an independent source review and then the all-or-nothing cumulative
  producer owner.
- Lane 217 / reused project-owned M3 review task
  `01a00563-bd2c-7cf0-aa82-d5773a4ccdae` — complete read-only current-tip
  cumulative-producer readiness audit, ready to archive. It reused the lane-215
  task for source-review continuity and ran `gpt-5.6-luna` with max reasoning.
  It must verify the same source-only bundle and inspect detached PC
  `b9a9f355` plus clean decomp `09ca8e8b`; it creates no source branch and owns
  no edit. The gate is to determine, section by section, whether the current
  canonical ABIs, raw owners, leaf producers, dependency results, resource
  lease, and pre-GL publication boundary are sufficient for one atomic
  cumulative envelope after lane 216. It must identify exact missing owners or
  ordering/lifetime blockers, freeze the smallest non-overlapping cumulative
  producer file/symbol contract, and distinguish current evidence from the
  pending Geometry producer. No build, test, source/docs edit, full link, LLDB,
  runtime, Apple/Metal, pixel, device, ISO/assets, or playability work is in
  scope. It returned `BLOCKED`: the strict fourteen-section envelope ABI exists,
  but Texgen/SU lacks a portable ABI and Transform, TEV, Blend, Depth, Fog, and
  Indirect lack complete PC leaf producers; Geometry dependency derivation and
  atomic Texture/Dynamic lease pairing are also absent. Evidence is
  `docs/evidence/CUMULATIVE-PRODUCER-READINESS-B9A9F355-2026-08-15.md`.
- Lane 218 / reused project-owned M3 review task
  `01a004f3-5a55-7702-95ec-8acf22b8b806` — complete independent read-only
  `BLOCK` review of lane 216's exact `b9a9f355..5aba103` candidate. It owns no edit, branch,
  build, test, cleanup, integration, or runtime work. It must verify the bundle
  hash/ancestry/four-file scope; crosswalk the raw completed-batch contract and
  canonical Geometry validators against decomp; review direct/indexed ordering,
  little-endian layout, overflow/capacity checks, dependency validation,
  unsupported-state rejection, and all-or-nothing output semantics; then return
  PASS or exact material findings. It verified bundle/ancestry/four-file scope
  and the core staged serialization, then blocked acceptance because used
  `value_known`/`index_known` bytes were treated as truthy rather than exact
  booleans, direct `value_source_index` and inactive/tail metadata were not
  fully enforced, and the fixture omitted direct-quad, explicit INDEX16 byte,
  and output/scratch overlap cases. Evidence is
  `docs/evidence/CANONICAL-GEOMETRY-PRODUCER-REVIEW-5ABA103-2026-08-15.md`.
  No full link, LLDB, Metal, device, pixel, ISO/assets, Windows sign-off, or
  playability claim is in scope.
- Lane 219 / reused project-owned M3 canonical task
  `01a00563-bd2c-7cf0-aa82-d5773a4ccdae` — complete, independently reviewed,
  integrated, and archived portable Texgen/SU ABI source/test lane on
  `gpt-5.6-luna` with max reasoning. Its dedicated source
  is `/private/tmp/acgc-lane-canonical-texgen-state-m3` on branch
  `c1/lane-canonical-texgen-state-m3` at exact PC `b9a9f355`; decomp
  `09ca8e8b` is read-only. It consumes the frozen ID4 contract and integrated
  raw-owner evidence from two hash-verified source-only control files. Exact
  ownership is new `include/acgc/gx_canonical_texgen_state.h`, new
  `src/gx_canonical_texgen_state.c`, one new portable fixture, and minimal
  `pc/portable/CMakeLists.txt` registration. It may not edit `pc_gx.c`, raw
  state, Geometry, Transform, Raster, Texture/TEV/Indirect, the cumulative
  envelope, Apple/Metal, decomp, or ISO/assets paths. The gate is the frozen
  2,624-byte pointer-free little-endian section, strict record/matrix/SU
  validation, native and combined ASan/UBSan focused tests, bounded syntax
  probes, and one reviewable source commit. It returned clean worker
  `f503fb924d` from base `b9a9f355f7`, integrated as canonical `590b2bd73`;
  native and combined ASan/UBSan focused
  CTest pass `1/1` each with no diagnostics (`detect_leaks=0`), native C11,
  C++11, and `_WIN32` syntax probes pass, and real i686 compilation remains
  blocked by the missing MinGW `string.h`/sysroot. Review bundle
  `/private/tmp/acgc-lane-219-canonical-texgen.bundle` has SHA-256
  `d47b45d486107f21e26cebcc51d512d9a93ff7e66a29c29481a40e73c9d7a5cb`.
  Generated worker/integration roots and both review bundles were retired by
  exact holder-free cleanup; asset-bearing source roots remain preserved. This is
  CPU/ABI evidence only; it cannot prove the later PC leaf producer, callback,
  Metal, pixel, device, Windows runtime, or playability. Fresh exact-integrated
  native and combined ASan/UBSan CTest also pass `1/1` each with no diagnostics.
  Evidence is `docs/evidence/CANONICAL-TEXGEN-SU-590B2BD73-2026-08-15.md`.
- Lane 220 / reused project-owned M3 Geometry review task
  `01a004f3-5a55-7702-95ec-8acf22b8b806` — complete independent read-only
  re-review of exact repaired final `5324c8739e` from base `b9a9f355` and first
  candidate `5aba10371f`. It uses only the hash-verified immutable lane-216
  bundle and detached source `/private/tmp/acgc-lane-220-geometry-producer-review`;
  it may not inspect the live worker or old asset-bearing review source. The
  gate is to prove the prior exact-boolean, direct-source, inactive/tail,
  direct-quad, INDEX16-endian, and buffer-overlap blockers are closed without a
  new correctness, UB, portability, or coverage regression. It owns no edit,
  branch, build, test, cleanup, integration, link, LLDB, runtime, Apple/Metal,
  device/pixel, Windows sign-off, ISO/assets, or playability work. It returned
  `PASS`: the exact repair delta closes every prior raw-domain and fixture gap,
  total scope remains four files, the repair touches only producer/test, and no
  new material blocker was found.
- Lane 221 / reused project-owned M3 Transform task
  `01a004f3-1941-7731-a310-d5ad1f52011b` — complete read-only Transform
  leaf-producer readiness and contract audit on `gpt-5.6-luna` with max
  reasoning. It verifies exact PC `b9a9f355`, decomp `09ca8e8b`, the
  source-only canonical bundle, and four hash-verified Transform contract/raw
  evidence controls, using detached source
  `/private/tmp/acgc-lane-221-transform-producer-audit`. It owns no edit,
  branch, build, test, cleanup, integration, full link, LLDB, runtime,
  Apple/Metal, ISO/assets, device/pixel, Windows sign-off, or playability work.
  The gate is a field-by-field verdict on whether `PCGXRawTransform` can
  truthfully populate the frozen canonical Transform ABI, including projection,
  position/normal slots, current matrix ID, load-range knownness, unresolved
  indexed loads, finite binary32 values, and Geometry/Texgen dependencies. If
  ready, it freezes only the smallest later producer header/source/fixture/CMake
  contract; if blocked, it names the exact predecessor raw-owner repair. It
  returned `READY`: the value-only raw owner supplies every required field,
  knownness bit, unresolved-index guard, and finite-word invariant. The frozen
  successor owns only a new producer header/source, one fixture, and minimal
  `pc/CMakeLists.txt`. Evidence is
  `docs/evidence/TRANSFORM-PRODUCER-READINESS-B9A9F355-2026-08-15.md`.
- Lane 222 / reused project-owned M3 review task
  `01a004f3-5a55-7702-95ec-8acf22b8b806` — complete and archived independent read-only
  review of lane 219 worker `f503fb924d` against base `b9a9f355f7`. It must use
  only the immutable review bundle with SHA-256 `d47b45d4...9d7a5cb`, create a
  detached review source at `/private/tmp/acgc-lane-222-texgen-state-review`,
  verify exact four-file scope and both-upstream provenance, and return `PASS`
  or exact material findings. It owns no edit, branch, build, test, cleanup,
  integration, full link, LLDB, runtime, Apple/Metal, device/pixel, Windows
  sign-off, ISO/assets, or playability work. It returned `PASS`: exact
  four-file scope and ancestry, fixed layout, explicit little-endian codec,
  strict domains/dependencies, destination-preserving fail-closed behavior,
  and focused fixture coverage have no material candidate-owned blocker. Its
  asset-bearing detached review source remains preserved after generated-root
  cleanup.
- Lane 223 / reused project-owned M3 Transform task
  `01a004f3-1941-7731-a310-d5ad1f52011b` — complete, independently reviewed,
  integrated, archived, and generated-root-cleaned source/test successor on `gpt-5.6-luna` with
  max reasoning. It created
  `/private/tmp/acgc-lane-transform-producer-m3` on branch
  `c1/lane-transform-producer-m3` at exact canonical PC `689590cc`, using only
  source bundle `/private/tmp/acgc-canonical-pc-689590cc.bundle` with SHA-256
  `30cd438904f7ebe89394e35e35043208cffc4f67d6a89c31138d1735f48af9de`.
  Ownership is limited to new `pc/include/pc_gx_transform_producer.h`, new
  `pc/src/pc_gx_transform_producer.c`, one focused fixture, and minimal
  `pc/CMakeLists.txt`; `pc_gx.c`, raw/canonical ABIs, Texgen, Geometry,
  cumulative/Apple/Metal, decomp, and ISO/assets are out of scope. Native and
  combined ASan/UBSan focused tests plus bounded syntax probes are the only
  verification; no full link, LLDB, runtime, device, pixel, Windows sign-off,
  or playability claim is authorized. It returned clean worker `4fde6d94ed`
  with exact four-file scope; native and combined ASan/UBSan focused CTest pass
  `2/2` each, the producer object compiles, native C11/C++11 syntax probes pass,
  and real i686 remains blocked by the missing `sys/types.h`/MinGW sysroot.
  Review bundle `/private/tmp/acgc-lane-transform-producer-m3-review.bundle`
  has SHA-256
  `f4c9b0b33de7a8713fe8732ae820a686cf1b851b739a67357855301e25c393e5`.
  Lane 226 returned `PASS`; root cherry-picked the exact change as canonical
  `37ae640d5`, where fresh native and combined ASan/UBSan focused CTest pass
  `2/2` each and the producer object compiles. Evidence is
  `docs/evidence/CANONICAL-TRANSFORM-PRODUCER-37AE640D5-2026-08-15.md`.
  Generated local/remote build and bundle roots are absent after exact cleanup;
  the remote worker/review sources remain preserved because bounded checks found
  `assets`/`orig` entries.
- Lane 224 / reused project-owned M3 audit task
  `01a004f2-96c0-79c2-8c20-c9b028bb5018` — complete independent read-only
  TEV leaf-producer readiness audit at exact canonical PC `689590cc` and
  decomp `09ca8e8b`. It must use the verified source-only bundle and detached
  source `/private/tmp/acgc-lane-224-tev-producer-audit`, crosswalk the
  integrated raw TEV/KONST owner, the 2,560-byte canonical TEV ABI, all logical
  stage/swap/indirect dependencies, and the decomp setters/callers, then return
  `READY` or the exact missing predecessor raw provenance. It owns no edit,
  branch, build, test, cleanup, integration, full link, LLDB, Apple/Metal,
  device/pixel, ISO/assets, Windows sign-off, or playability work. It returned
  `BLOCK`: exact raw PREV/REG/KONST provenance exists, but complete
  stage/active-count/swap and indirect knownness, sticky invalid state,
  source-faithful indirect quantization, flush-before-mutation, and one
  immutable completed snapshot do not. The smallest predecessor owns only raw
  TEV/Indirect state and setter hooks in `pc_gx_internal.h`/`pc_gx.c`, one
  fixture, and minimal CMake. Evidence is
  `docs/evidence/TEV-PRODUCER-READINESS-689590CC-2026-08-15.md`.
- Lane 225 / reused project-owned M3 audit task
  `01a004f3-3ae3-7560-9c9c-e1799056aad6` — complete independent read-only
  Alpha/Blend/Depth/Fog leaf-producer topology audit at exact canonical PC
  `689590cc` and decomp `09ca8e8b`. It must classify each section separately as
  producer-ready or blocked, identify exact raw owner/knownness/ordering gaps,
  and freeze only disjoint later source contracts. It owns no edit, branch,
  build, test, cleanup, integration, full link, LLDB, Apple/Metal, device/pixel,
  ISO/assets, Windows sign-off, or playability work. It found Alpha `READY`,
  Depth blocked only on its canonical converter/API/fixture, Blend blocked on a
  setter-owned raw shadow, and Fog blocked on complete logical value plus
  synchronous range-table capture. Evidence is
  `docs/evidence/PIXEL-LEAF-PRODUCER-TOPOLOGY-689590CC-2026-08-15.md`.
- Lane 226 / reused project-owned M3 review task
  `01a004f2-96c0-79c2-8c20-c9b028bb5018` — complete/archived independent read-only
  review of lane 223 worker `4fde6d94ed` against base `689590cc`. It must use
  only the verified canonical and thin review bundles plus the hash-verified
  readiness control, create detached review source
  `/private/tmp/acgc-lane-226-transform-producer-review`, verify exact four-file
  scope and both-upstream semantics, and return `PASS` or exact material
  findings. It owns no edit, branch, build, test, cleanup, integration, full
  link, LLDB, Apple/Metal, device/pixel, ISO/assets, Windows sign-off, or
  playability work. It returned `PASS`: exact clean provenance, four-file
  ownership, field/domain mapping, destination-preserving fail-closed behavior,
  header portability, and focused coverage have no material blocker.
- Lane 227 / reused project-owned M3 source task
  `01a004f3-3ae3-7560-9c9c-e1799056aad6` — complete, independently reviewed,
  integrated, archived, and generated-root-cleaned Depth leaf-converter
  source/test lane on `gpt-5.6-luna` with max reasoning. It must create remote
  source `/private/tmp/acgc-lane-depth-producer-m3` on branch
  `c1/lane-depth-producer-m3` at exact canonical PC `590b2bd73`, using only
  source bundle `/private/tmp/acgc-canonical-pc-590b2bd.bundle` with SHA-256
  `c5b712caecd66a1262afbfeac5f8651d90c913bcccaf27a9960304c0245157af`.
  Ownership is limited to a new Depth producer header/source, one focused
  fixture, and minimal `pc/CMakeLists.txt`; existing raw/canonical Depth ABIs,
  `pc_gx.c`, `pc_gx_internal.h`, Transform/Texgen/TEV/Blend/Fog, cumulative and
  Apple/Metal code, decomp, and ISO/assets are out of scope. Unique roots are
  `/private/tmp/acgc-lane-depth-producer-native`,
  `/private/tmp/acgc-lane-depth-producer-asan`, and
  `/private/tmp/acgc-lane-depth-producer-win`. Native and combined ASan/UBSan
  focused tests plus production-object/syntax probes are the only verification;
  no full link, LLDB, runtime, device, pixel, Windows sign-off, or playability
  claim is authorized. It returned clean worker
  `dfef13a23ebe021eef29dd46b734b47ad5c2f2e7` with exact four-file scope;
  native and combined ASan/UBSan focused CTest pass `3/3` each, the production
  object builds, native C11/C++11 and `-m32` header probes pass, and `_WIN32`
  remains blocked by missing `process.h` with no Windows sign-off. Review
  bundle `/private/tmp/acgc-lane-227-depth-producer.bundle` has SHA-256
  `c4c6d0e191ec12e89154b1d87a9ba0c7d112c17828461e4351372ca8fafb21bd`.
  Lane 228 returned `PASS`; root cherry-picked the exact change as canonical
  `0f896395c`, where fresh native and combined ASan/UBSan focused CTest pass
  `3/3` each and the producer object compiles. Evidence is
  `docs/evidence/CANONICAL-DEPTH-PRODUCER-0F896395C-2026-08-15.md`. Exact
  local/remote generated roots and worker bundle are absent after cleanup; the
  remote source remains preserved because bounded checks found `assets`/`orig`
  entries. The old canonical bundle remains preserved for recorded provenance.
- Lane 228 / reused project-owned M3 review task
  `01a004f2-96c0-79c2-8c20-c9b028bb5018` — complete/archived independent read-only
  review of lane 227 worker `dfef13a23e` against base `590b2bd73`. It must use
  only canonical bundle `/private/tmp/acgc-canonical-pc-590b2bd.bundle`
  (SHA-256 `c5b712caecd66a1262afbfeac5f8651d90c913bcccaf27a9960304c0245157af`),
  the immutable worker bundle above, and readiness control
  `/private/tmp/acgc-lane-228-depth-readiness.md` (SHA-256
  `1708b17d9d511dab156d6e085290e855b258403d654496b56b5d194feb2843aa`).
  It owns only detached review source
  `/private/tmp/acgc-lane-228-depth-producer-review` and must return `PASS` or
  exact material findings for scope, raw/canonical/decomp mapping, fail-closed
  output preservation, portability, and focused fixture coverage. It owns no
  edit, branch, build, test, cleanup, integration, full link, LLDB,
  Apple/Metal, device/pixel, Windows sign-off, ISO/assets, or playability work.
  It returned `PASS`: immutable provenance, exact four-file ownership,
  raw/canonical/decomp field mapping, truthful raw invalid-history limitation,
  destination-preserving fail-closed behavior, portability, and focused
  coverage have no material blocker. Its detached review source is preserved
  because bounded cleanup checks found `assets`/`orig` entries.
- Lane 229 / reused project-owned M3 audit task
  `01a004f3-1941-7731-a310-d5ad1f52011b` — complete/root-reviewed/archived
  independent read-only
  Blend raw-owner/leaf-producer contract audit at exact canonical PC
  `0f896395c` and decomp `09ca8e8b`. It must use source-only bundle
  `/private/tmp/acgc-canonical-pc-0f89639.bundle` (SHA-256
  `a789027090e9f2ce6f6241932cbc4cb9e6f185bcedb069d27b25049afcd09c6c`),
  verified control `/private/tmp/acgc-lane-229-blend-readiness.md` (SHA-256
  `1708b17d9d511dab156d6e085290e855b258403d654496b56b5d194feb2843aa`),
  and detached source `/private/tmp/acgc-lane-229-blend-audit-m3`. It must map
  PC `GXSetBlendMode` state/knownness/order and the canonical Blend ABI against
  decomp `GXSetBlendMode`, initialization, and callers, then return `READY` or
  the exact smallest raw-owner predecessor. It returned `BLOCK`: current PC
  retains only host/OpenGL Blend values and has no setter-owned raw Blend
  state, knownness, sticky invalid history, or raw-to-canonical builder. The
  smallest successor owns only `pc_gx_internal.h`, `pc_gx.c`, one focused raw
  Blend fixture, and minimal CMake; it cannot overlap Fog or TEV source work.
  Evidence is
  `docs/evidence/BLEND-PRODUCER-READINESS-0F896395C-2026-08-15.md`. It owns no
  edit, branch, build, test, cleanup, link, LLDB, Apple/Metal, device/pixel,
  Windows sign-off, ISO/assets, or playability work.
- Lane 230 / reused project-owned M3 audit task
  `01a004f3-5a55-7702-95ec-8acf22b8b806` — complete/root-reviewed/archived
  independent read-only
  Fog raw-owner/leaf-producer contract audit at exact canonical PC `0f896395c`
  and decomp `09ca8e8b`, using the same canonical bundle, verified control
  `/private/tmp/acgc-lane-230-fog-readiness.md` (SHA-256
  `1708b17d9d511dab156d6e085290e855b258403d654496b56b5d194feb2843aa`),
  and detached source `/private/tmp/acgc-lane-230-fog-audit-m3`. It must map
  logical fog fields, finite-word domains, range-adjust enable/center and all
  ten table entries, setter ordering/knownness, canonical Fog ABI, and decomp
  `GXSetFog`/`GXSetFogRangeAdj`, then return `READY` or the exact smallest
  predecessor. It returned `BLOCK`: `GXSetFog` retains only host state,
  `GXInitFogAdjTable` is a no-op, `GXSetFogRangeAdj` discards all logical
  arguments, and no raw Fog owner/producer exists. The smallest successor owns
  the raw state/setter hooks, a pure producer, two focused fixtures, and minimal
  CMake, while preserving explicit range-center and Fog-enum reference
  differences. Evidence is
  `docs/evidence/FOG-PRODUCER-READINESS-0F896395C-2026-08-15.md`. It owns no
  edit, branch, build, test, cleanup, link, LLDB, Apple/Metal, device/pixel,
  Windows sign-off, ISO/assets, or playability work.
- Lane 231 / reused project-owned M3 audit task
  `01a00563-bd2c-7cf0-aa82-d5773a4ccdae` — complete/root-reviewed/archived
  independent read-only
  current-tip cumulative-producer readiness reconciliation at exact canonical
  PC `0f896395c` and decomp `09ca8e8b`. It must use the canonical bundle,
  prior control `/private/tmp/acgc-lane-231-cumulative-readiness.md` (SHA-256
  `f8cd62e905de36f9aada064ad412ded1a38e50910019f3ca5e9a5dbcc70648b6`),
  and detached source `/private/tmp/acgc-lane-231-cumulative-audit-m3` to
  enumerate every required section/raw owner/leaf producer, immutable resource
  lease, dependency, and atomic publication boundary after the new Transform
  and Depth producers. It returned `BLOCK`: Texgen/SU lacks its PC leaf; TEV,
  Blend, Fog, and Indirect lack complete raw owners/leaves; existing producer
  objects are not all production-linked; Geometry dependency results are not
  atomically derived; and no all-or-nothing lease/publication transaction
  exists. The safe order is Texgen/SU leaf, serialized TEV ownership/leaf,
  serialized Pixel/Raster/Indirect provenance, Geometry dependency builder,
  then the final assembler. Evidence is
  `docs/evidence/CUMULATIVE-PRODUCER-READINESS-0F896395C-2026-08-15.md`. It owns
  no edit, branch, build, test, cleanup, link, LLDB, Apple/Metal, device/pixel,
  Windows sign-off, ISO/assets, or playability work and must return the exact
  remaining blockers and safe integration order.
- Lane 232 / reused project-owned M3 source task
  `01a004f3-3ae3-7560-9c9c-e1799056aad6` — complete/root-reviewed/integrated/archived bounded
  Texgen/SU repair
  raw-to-canonical leaf-producer lane at exact canonical PC `0f896395c` and
  decomp `09ca8e8b`. It must use verified source-only bundle
  `/private/tmp/acgc-canonical-pc-0f89639.bundle` (SHA-256
  `a789027090e9f2ce6f6241932cbc4cb9e6f185bcedb069d27b25049afcd09c6c`),
  create `/private/tmp/acgc-lane-texgen-producer-m3` on branch
  `c1/lane-texgen-producer-m3`, and stop if either is not clean at the exact
  base. Ownership is limited to new `pc_gx_texgen_producer.h/.c`, one new
  focused producer fixture, and minimal `pc/CMakeLists.txt` registration.
  Existing `pc_gx.c`, `pc_gx_internal.h`, canonical ABI/source, every other
  producer, packets, Apple/Metal, decomp, umbrella, ISO/assets, and runtime are
  out of scope. Unique roots are
  `/private/tmp/acgc-lane-texgen-producer-native`,
  `/private/tmp/acgc-lane-texgen-producer-asan`, and
  `/private/tmp/acgc-lane-texgen-producer-win`. It must complete the exact
  two-upstream crosswalk, return one clean source commit, run focused native and
  combined ASan/UBSan tests plus a production-object compile and bounded
  C/C++/ILP32/`_WIN32` probes, and make only CPU/source claims. No full link,
  LLDB, callback, renderer, Metal, pixel, device, Windows sign-off, or
  playability work is authorized. The task verified the bundle and created a
  clean `/private/tmp/acgc-lane-texgen-producer-m3` worktree on
  `c1/lane-texgen-producer-m3` at the exact `0f896395c` base before beginning
  its mandatory two-upstream crosswalk. It returned clean worker
  `a14aef417913f9538d952df867f56a826bb7f124` with exactly the four owned
  files. Native and combined ASan/UBSan focused CTest pass `2/2` each; the
  producer object and native C11/C++11 plus ILP32 probes pass; `_WIN32` remains
  blocked by missing non-Windows headers and is not Windows sign-off. No
  runtime/rendering claim follows. Lane 233 found that inactive immediate and
  indexed-unresolved matrix records can carry impossible attempted-range known
  masks. The same branch must add exact provenance/mask checks plus two
  destination-sentinel negative fixture cases in only the producer source and
  fixture, rerun the focused gates, commit one child, and stop. It returned
  clean child `e6f26abde5327347d43532a5605b11402a3b8330` with exactly that two-file
  delta. Native and combined ASan/UBSan focused CTest pass `2/2` each, the
  producer object builds, native C11/C++11 and ILP32 probes pass, and `_WIN32`
  remains blocked by missing non-Windows headers. Root imported source-only
  bundle SHA-256
  `a4af158d95af70c64ab503b4fd1ed27f459a373f389dd2d4c149ba334dc6465f`,
  preserved the worker branch, and applied the two source commits one at a
  time as canonical `687b48922` then `c832fb862`. Fresh native and combined
  ASan/UBSan focused CTest pass `2/2` each and the production producer object
  compiles. Evidence is
  `docs/evidence/CANONICAL-TEXGEN-PRODUCER-C832FB862-2026-08-15.md`. This is
  CPU/source evidence only; no full link, runtime, callback, Metal, pixel,
  device, Windows, or playability claim follows.
- Lane 233 / reused project-owned M3 review task
  `01a004f2-96c0-79c2-8c20-c9b028bb5018` — complete/root-reviewed/archived
  immutable read-only
  review of lane 232 worker `a14aef4179` against base `0f896395c`. It must use
  the preserved worker source and create only detached review source
  `/private/tmp/acgc-lane-233-texgen-producer-review`; verify exact ancestry,
  four-file ownership, raw/canonical/decomp mapping, destination-preserving
  fail-closed behavior, unresolved indexed/inactive semantics, portability,
  CMake scope, and focused fixture coverage; then return `PASS` or exact
  material findings. It owns no edit, branch, build, test, cleanup,
  integration, full link, LLDB, runtime, Apple/Metal, device/pixel, Windows
  sign-off, ISO/assets, or playability work. It returned `BLOCK`: the converter
  fails to enforce all attempted-range bits for
  immediate provenance and zero attempted-range bits for indexed-unresolved
  provenance, allowing malformed inactive records to publish. Evidence is
  `docs/evidence/TEXGEN-PRODUCER-REVIEW-A14AEF41-2026-08-15.md`.
  The same task re-reviewed repaired child `e6f26abde5` and returned `PASS —
  no material candidate-owned issue remains`. It verified the exact two-file
  repair, direct parent, attempted-range masks, destination-sentinel cases,
  and both-upstream semantics without editing, building, testing, or cleaning.
  The task is archived after the reviewed integration.
- Lane 234 / remote M3 Max task
  `01a00640-960d-7d41-9320-721f26037d8a` — complete, independently reviewed,
  integrated, and archived after one-file test repair following production
  repair of the setter-owned raw TEV/Indirect provenance lane after lane 235's
  independent `BLOCK`. It uses verified complete-
  history source-only bundle `/private/tmp/acgc-canonical-pc-c832fb8.bundle`
  (SHA-256
  `c52633a629d26ec9df65d0613aa03b6c6b4d8150ac6ac41eff4b755927e9b21f`),
  exact PC base `c832fb862`, and decomp `09ca8e8b`. Clean source worktree
  `/private/tmp/acgc-lane-raw-tev-m3` is registered on
  `c1/lane-raw-tev-m3`; original worker commit is `34da318d4` and repaired
  child is clean `638f91fa2`. Its original frozen
  source-only review bundle is
  `/private/tmp/acgc-lane-234-raw-tev-indirect.bundle` (SHA-256
  `cc0635a6916352a0f8bdabee85ad325484359f5636d9b0ed15329cb76ea851d1`);
  refreshed repair bundle `/private/tmp/acgc-lane-234-repair-source.bundle`
  has verified SHA-256
  `46d63167be5ab309216b200bfc2f5b2c15cd37ab1d0c9e456584da5ac06562e9`
  and resolves the branch to `638f91fa2` with complete history.
  Its gate is the smallest pointer-free setter-owned raw owner for active TEV
  count, all 16 logical stages, swap tables, PREV/REG/KONST state, per-stage
  indirect tuples, and indirect order/scale/matrix provenance, with exact
  indirect quantization/scale encoding, per-field knownness, sticky invalidity,
  copied lifetime, and flush-before-mutation. Exclusive production ownership
  is `pc/include/pc_gx_internal.h` plus only the TEV/Indirect setter regions of
  `pc/src/pc_gx.c`; test ownership is one new focused raw-state fixture and
  minimal `pc/CMakeLists.txt`. Canonical ABIs/producers, packets/cumulative
  assembly, other raw owners, Apple/Metal/shaders, decomp, umbrella, ISO/assets,
  full link, LLDB, runtime, device/pixel, Windows sign-off, and playability are
  out of scope. Its two-upstream crosswalk completed; the worker corrected the
  raw `GXSetTevOp` path to decomp semantics while preserving the legacy PC host
  expansion, made matrix knownness explicit for all six coefficients plus the
  encoded scale, and made invalid register/KONST IDs fail closed. Focused
  native and combined ASan/UBSan fixtures pass, the production `pc_gx.c`
  object compiles, native C/C++ and AppleClang `-m32` syntax probes pass, and
  real Windows/i686 proof remains blocked by the missing toolchain and
  `process.h`. Lane 235 found that invalid current calls can still write legacy
  mirrors after the raw validator fails. The completed repair owns only
  `pc/src/pc_gx.c` and
  `pc/tests/pc_gx_tev_indirect_raw_shadow_fixture.c`: raw helpers must report
  current-call validity, invalid calls must return before legacy mutation, and
  a later valid call must retain legacy-PC behavior even after sticky raw
  invalidity. The child adds invalid-domain and legacy-immutability regressions;
  focused native plus combined ASan/UBSan fixtures pass, the production object
  compiles, and `git diff --check` passes. Lane 235 confirmed the production
  repair but found the older legacy raw-TEV fixture still asserts the forbidden
  malformed legacy write. The final repair owns only
  `pc/tests/pc_gx_tev_raw_shadow_fixture.c`: it asserts unchanged legacy
  mirrors, inspect malformed provenance in the new raw owner, preserve the
  later-valid-after-sticky behavior, and keeps the production repair unchanged.
  Clean child `62a9f5b23` of `638f91fa2` changes that fixture only. Both
  focused fixtures pass natively and under combined ASan/UBSan, the production
  object compiles, and `git diff --check` passes. Final source-only bundle
  `/private/tmp/acgc-lane-234-final-source.bundle` has SHA-256
  `dd6b9b22d994acce275fe13c16569552ca042b9079c7e38636bfd970a04a29d5`
  and complete history. Lane 235 returned final independent `PASS`. Root
  preserved worker branch `c1/lane-raw-tev-m3` at `62a9f5b23`, applied the
  three commits individually as canonical `e036cc947`, `6e797744a`, and
  `62c810e5b`, and reran fresh native plus combined ASan/UBSan focused CTest
  `2/2` each. Evidence is
  `docs/evidence/PC-RAW-TEV-INDIRECT-62C810E5B-2026-08-15.md`.
  This is CPU/source evidence only; there is no canonical leaf, callback,
  Metal, pixel, Windows, or playability claim.
- Lane 235 / remote M3 Max task
  `01a00669-46ec-7c50-959c-50dafe702923` — complete final immutable independent
  read-only re-review of test-only child `62a9f5b23`, returning `PASS` and now
  archived. Its initial review of lane
  234 candidate `34da318d4` confirmed exact provenance and bundle hash. It
  returned `BLOCK`: raw validators mark sticky invalidity,
  but multiple enclosing TEV/Indirect setters continue into legacy dirty/mirror
  writes; the fixture covers invalid IDs but not invalid stages, selectors,
  orders, ranges, counts, or null/non-finite matrices and mirror immutability.
  Native and combined ASan/UBSan legacy/new fixtures each pass, so this is a
  source-contract and missing-regression finding rather than a sanitizer
  failure. Unique review roots are
  `/private/tmp/acgc-lane-235-raw-tev-review-{native,asan}`. The re-review uses
  new roots `/private/tmp/acgc-lane-235-repair-review-{native,asan}` and the
  refreshed repair bundle/hash above. The new focused fixture passes natively
  and under combined ASan/UBSan, but the legacy fixture fails at
  `pc_gx_tev_raw_shadow_fixture.c:262` because it still expects malformed S10
  input to update the legacy shadow. The smallest safe repair is test-only; do
  not restore the old source mutation. The final re-review uses fresh roots
  `/private/tmp/acgc-lane-235-final-review-{native,asan}`, owns no source or
  integration, and verified the one-file repair, complete commit chain,
  unchanged production repair, both focused native and sanitizer fixtures, and
  production object compile. No full link, LLDB,
  runtime, Metal, device/pixel,
  Windows sign-off, or playability claim follows.
- Lane 236 / reused project-owned M3 Max task
  `01a00640-960d-7d41-9320-721f26037d8a` — complete/root-review-hold
  source-edit lane for the canonical TEV leaf producer. Setup verified
  source-only bundle
  `/private/tmp/acgc-canonical-pc-62c810e.bundle` at SHA-256
  `7e8c25348f11fdb124e8c5ad75d78b0b4de1d139cd37e435ac535f303e2617e5`,
  exact PC base `62c810e5b`, and clean decomp `09ca8e8b`. Its clean isolated
  source `/private/tmp/acgc-lane-canonical-tev-producer-m3` on
  `c1/lane-canonical-tev-producer-m3` advanced from the exact base to worker
  `043d24822`; roots are
  `/private/tmp/acgc-lane-canonical-tev-producer-{native,asan,win}`. It owns
  only new `pc/include/pc_gx_tev_producer.h`, new
  `pc/src/pc_gx_tev_producer.c`, new
  `pc/tests/pc_gx_tev_producer_fixture.c`, and minimal
  `pc/CMakeLists.txt`. Its PC/decomp crosswalk covers `PCGXRawTevIndirect`,
  the 2,560-byte canonical TEV ABI, the existing depth/Texgen producer pattern,
  `GXTev.c`, `GXBump.c`, `GXInit.c`, and the corresponding public headers. The
  producer must stage locally, require exact active-stage/register/KONST/swap
  provenance, zero inactive/reserved state, validate canonically, and preserve
  every destination byte on failure. Focused serial native plus combined
  ASan/UBSan, producer-object, diff, and bounded syntax evidence is authorized;
  `pc_gx.c`, raw ownership, Indirect files, cumulative assembly, full link,
  LLDB, runtime, Apple/Metal, device/pixel, Windows sign-off, assets, and
  playability are out of scope. Native and combined ASan/UBSan focused CTest
  pass `1/1` each, the production producer object and bounded C/C++/ILP32
  probes pass, and `_WIN32` remains blocked by missing host `process.h`.
  Complete-history bundle
  `/private/tmp/acgc-lane-236-canonical-tev-producer.bundle` had SHA-256
  `ba4d9a1ca72bd18dcffd31eddfd60969d96cb1ef8cb726d4042def6c02372f40`; the
  bundle and lane worktree were lost in the post-pause `/private/tmp`
  cleanup, and the candidate now survives as durable submodule ref
  `c1/archive/cleanup-20260815/canonical-tev-candidate` (`043d24822`),
  mirrored at `acgc-m3-cleanup/canonical-tev`. Resolved 2026-08-17: the
  resumed single-owner review found no blocker and the candidate is
  integrated on `c1/macos-host-launch` (fast-forward to `043d24822`).
- Lane 237 / reused project-owned M3 Max task
  `01a004f3-5a55-7702-95ec-8acf22b8b806` — complete/root-review-hold
  source-edit lane for the canonical Indirect leaf producer. It used the same
  verified bundle and exact PC/decomp bases, and its clean isolated source
  `/private/tmp/acgc-lane-canonical-indirect-producer-m3` on
  `c1/lane-canonical-indirect-producer-m3` advanced from `62c810e5b` to clean
  worker `2f6ba5dff`; roots are
  `/private/tmp/acgc-lane-canonical-indirect-producer-{native,asan,win}`. It
  owns only new `pc/include/pc_gx_indirect_producer.h`, new
  `pc/src/pc_gx_indirect_producer.c`, and new
  `pc/tests/pc_gx_indirect_producer_fixture.c`; it must not edit CMake while
  lane 236 is active. Its PC/decomp crosswalk covers the raw order/scale/matrix
  subset, exact six-coefficient quantization and encoded scale, the 248-byte
  canonical Indirect ABI, existing producer patterns, `GXBump.c`, `GXTev.c`,
  `GXInit.c`, and their public headers. The producer must stage locally, derive
  exact active/matrix masks, copy only complete raw records, zero inactive and
  reserved state, validate canonically, and preserve every destination byte on
  failure. Source-direct native plus combined ASan/UBSan, producer-object,
  diff, and bounded syntax evidence is authorized; TEV-side indirect fields,
  `pc_gx.c`, raw ownership, CMake, cumulative dependency validation, full link,
  LLDB, runtime, Apple/Metal, device/pixel, Windows sign-off, assets, and
  playability are out of scope. Native and combined ASan/UBSan source-direct
  fixtures pass, the production producer object and bounded C/C++/ILP32 probes
  pass, and `_WIN32` remains blocked by the missing Windows SDK `process.h`.
  Complete-history bundle
  `/private/tmp/acgc-lane-237-canonical-indirect-producer.bundle` had SHA-256
  `aaab318c0cbe19e6d52b63107e1431489eb4a1ee6762ecf34a87c072796b30c2`; the
  bundle and lane worktree were lost in the post-pause `/private/tmp`
  cleanup, and the candidate now survives as durable submodule ref
  `c1/archive/cleanup-20260815/canonical-indirect-candidate` (`2f6ba5dff`),
  mirrored at `acgc-m3-cleanup/canonical-indirect`. Resolved 2026-08-17: the
  resumed single-owner review found no blocker and the candidate is
  integrated on `c1/macos-host-launch` as `b83a6f6e3`, with its CMake
  fixture/object registration added separately as `d50cddb18`.
- Lane 238 / reused project-owned M3 Max task
  `01a00563-bd2c-7cf0-aa82-d5773a4ccdae` — complete read-only audit; three
  `BLOCK` verdicts. Setup verified the complete-history source-only bundle
  `/private/tmp/acgc-canonical-pc-62c810e.bundle` at SHA-256
  `7e8c25348f11fdb124e8c5ad75d78b0b4de1d139cd37e435ac535f303e2617e5`,
  exact PC `62c810e5b`, and clean decomp `09ca8e8b`. Its clean detached
  source was `/private/tmp/acgc-lane-238-cumulative-apple-audit-m3` at the
  exact PC tip; it had no branch, files, build/test/log roots, or runtime
  authority. Before the 2026-08-15 pause it returned `BLOCK` independently
  for each of its three gates — the cumulative CPU assembler, the typed Apple
  CPU consumer, and the later serialized live callback trace — naming missing
  Blend/Fog raw owners, complete production/envelope wiring, a Geometry
  dependency-result builder, atomic resource-lease publication, the assembler
  itself, and Apple consumer/registration code as prerequisites. The lane's
  raw final handoff transcript and detached source root were not preserved
  through the post-pause host cleanup; the pause-time record is transcribed
  with that boundary stated in
  `docs/evidence/CUMULATIVE-APPLE-AUDIT-62C810E5B-2026-08-15.md`. No edit,
  build, test, CMake, full link, LLDB, runtime, Metal/device/pixel,
  input/audio/save, iOS, or playability claim was authorized or made.
- Lane 239 / reused project-owned M3 Max task
  `01a00669-46ec-7c50-959c-50dafe702923` — paused partial verification;
  independent immutable review of the lane-237 Indirect producer. Setup
  verified candidate bundle SHA-256
  `aaab318c0cbe19e6d52b63107e1431489eb4a1ee6762ecf34a87c072796b30c2`,
  exact one-commit parentage `62c810e5b` to `2f6ba5dff`, clean decomp
  `09ca8e8b`, and the exact three new-file diff. Before the pause its static
  review, source-direct native and combined ASan/UBSan fixtures, and
  C11/C++11 probes passed without diagnostics; the `-m32`/`_WIN32` probes and
  the final immutable `PASS`/`BLOCK` handoff remain open. Its detached review
  source and unique native/ASan roots under `/private/tmp` were not preserved
  through the post-pause host cleanup; on resume, re-run the review from
  archived candidate ref
  `c1/archive/cleanup-20260815/canonical-indirect-candidate` (`2f6ba5dff`).
  The paused state is recorded in
  `docs/evidence/TEV-INDIRECT-REVIEW-PAUSE-62C810E5B-2026-08-15.md`.
  Resolved 2026-08-17: superseded by the resumed single-owner review, which
  re-ran source review plus source-direct native and combined ASan/UBSan
  fixtures from the archived candidate, found no blocker, and integrated it;
  see `docs/evidence/TEV-INDIRECT-PRODUCER-INTEGRATION-D50CDDB18-2026-08-17.md`.
- Lane 240 / reused project-owned M3 Max task
  `01a004f2-96c0-79c2-8c20-c9b028bb5018` — paused partial verification;
  independent immutable review of the lane-236 TEV producer. Setup verified
  candidate bundle SHA-256
  `ba4d9a1ca72bd18dcffd31eddfd60969d96cb1ef8cb726d4042def6c02372f40`,
  exact one-commit parentage `62c810e5b` to `043d24822`, clean decomp
  `09ca8e8b`, and the exact four-file diff. Before the pause its crosswalk,
  native and combined ASan/UBSan focused fixture/object builds and `1/1`
  CTests, `git diff --check`, and C11/C++11/`-m32` probes passed; the
  `_WIN32` probe stopped at the missing `process.h` sysroot boundary, and the
  final immutable `PASS`/`BLOCK` handoff remains open. Its detached review
  source and unique native/ASan roots under `/private/tmp` were not preserved
  through the post-pause host cleanup; on resume, re-run the review from
  archived candidate ref
  `c1/archive/cleanup-20260815/canonical-tev-candidate` (`043d24822`). The
  paused state is recorded in
  `docs/evidence/TEV-INDIRECT-REVIEW-PAUSE-62C810E5B-2026-08-15.md`.
  Resolved 2026-08-17: superseded by the resumed single-owner review, which
  re-ran the crosswalk checks, focused native and combined ASan/UBSan CTest,
  and production-object compile from the archived candidate, found no
  blocker, and integrated it; see
  `docs/evidence/TEV-INDIRECT-PRODUCER-INTEGRATION-D50CDDB18-2026-08-17.md`.

The remote Codex project assignment records place tasks 156–176 under the
saved M3 `acgc-modern-port` project; the desktop may need a normal project-list
refresh to display the new rows. Their source-only sync bundles contain tracked
Git objects/docs only. No ISO, extracted assets, keys, or proprietary data were
transferred. Lanes 170, 172–176 are individually reviewed and integrated.
Lane 173 is archived after its final dirty-state repair; lane 184 is stopped
rather than duplicated while the M3
saved-project handoff registry is unresolved.
Lanes 177–178 completed read-only without source ownership, lane 179 completed
verification-only, lanes 180–181 completed read-only prerequisite audits, and
lane 182 completed verification-only and is archived/cleaned. Full links and
LLDB launches remain serialized and are not active. Lanes 185–186 are
integrated, lanes 187–188 are complete read-only audits, lane 183 is complete,
and lane 184 is stopped. Lanes 189, 190, 193, 195, and 199 are integrated, and
lanes 191–192, 194, 196–198, and 200–202 are complete. Lane 203 is reviewed
and integrated at canonical PC `698d45d3e`; lane 205 is reviewed and
integrated at canonical PC `b3336504c`; lane 204 is reviewed and integrated at
canonical PC `039afce0e`. Lanes 206–207 are complete, reviewed, and archived
read-only audits. Exact lane-204 cleanup is complete. Lane 209 is reviewed and
integrated as canonical PC `a42da8e155`; lane 208 is reviewed, integrated, and
archived as canonical PC `85b25cb3c`. Lane 210 is complete,
reviewed, and archived; its Geometry raw-closure successor is now
dependency-ready because lane 208 released `pc_gx.c` ownership. Lane 211
completed the narrow same-branch repair of blocked worker `1730823d45` as child
`5679bff656` and is integrated at canonical `b9a9f355`; lane 212 is
complete/archived; lane 213 completed the exact-tip matrix; lane 214 completed
its read-only BLOCK review; and lane 215 completed its independent read-only
PASS review. Lane 216 is integrated as canonical `689590cc`; lane 217 is
complete/blocked at the cumulative readiness gate, lane 218 is complete with
its first source-review `BLOCK`, lane 219 is the active Texgen/SU ABI worker,
and lane 220 is complete with the repaired Geometry `PASS`. No full link, LLDB,
or device run is active. Lane 221 is the active independent read-only Transform
producer audit.
The current
protected worktrees contain ignored assets/orig and must not be deleted or
inspected beyond counts.

Lane 128 / task `019fff43-def1-7bd2-8e1a-f7e72a6aac5b` is complete and archived.
It was created as a same-directory fork so it remained under the
`acgc-modern-port` project on the M3 Max rather than local Recents. Its remote
PC worker `c1/lane-texture-tev-m3` advanced `894ac5f8` to `a6c5e0c8`; the
source-only bundle contained no ISO or extracted assets. The four-file Apple
texture/TLUT/TEV CPU seam is integrated in canonical PC `08c27de5`, with unique
local verification roots under `/private/tmp/acgc-integrated-texture-tev-08c27de5*`.
Native and combined ASan/UBSan focused tests pass `2/2` each. This is a
synthetic CPU resolver/typed-consumer contract only; no full link, LLDB, device,
Metal encode/readback, pixel, input, audio, save, or playability claim exists.
Lane 129 / task `01a000e0-e957-7193-b2f8-23fd0447cdaa` is complete and archived.
It ran as a same-directory remote project task from the source-only synced PC
ref `local-sync/macos-host-launch` at `08c27de5`; no ISO or extracted assets
were transferred. Its clean worktree was `/private/tmp/acgc-lane-runtime-forwarding-m3`
on `c1/lane-runtime-forwarding-m3`; the focused native and combined ASan/UBSan
tests passed `2/2` each. The audit proved that runtime still supplies no
resolved texture/TLUT/sampler sideband: `handoff->texture` is NULL and the V2
callback remains geometry-only. No source change, full link, LLDB, device,
Metal, pixel, input, audio, save, or playability claim exists. Evidence is
`docs/evidence/RUNTIME-TEXTURE-FORWARDING-AUDIT-08C27DE5-2026-08-14.md`.

Lane 130 / task `01a000e5-6aba-7a81-9431-bd22781967f4` is complete and archived.
Its remote worker `c1/lane-v2-texture-runtime-m3` advanced `08c27de5` to
`a10fed8e`; the six-file Apple sideband is integrated in canonical PC
`3c08c7f71`. Native and combined ASan/UBSan focused CTest pass `3/3` each,
serially with no diagnostics. The borrowed sideband now fails closed for an
unbound textured packet, reaches `CPU_RESOLVED` for a bound source, and clears
on shutdown; no live game-owned source is bound yet. No full link, LLDB,
device, Metal, pixel, input, audio, save, or playability claim exists. Evidence
is `docs/evidence/V2-TEXTURE-RUNTIME-SIDEBAND-A10FED8E-2026-08-14.md`.

Lane 131 / task `01a000f0-da9a-77b3-900a-06d627b43a2b` is complete and archived.
It ran read-only from `a10fed8e` in detached worktree
`/private/tmp/acgc-lane-gx-texture-source-audit-m3`; no source files changed and
no build, launch, debugger, or asset access occurred. The audit proved that
only transient image/TLUT pointers and GL/cache metadata exist today; no safe
CPU byte record, sampler state, or generation token reaches the V2 handoff.
Evidence is `docs/evidence/GAME-OWNED-TEXTURE-SOURCE-AUDIT-A10FED8E-2026-08-14.md`.

Lane 132 / task `01a000f5-789c-70a0-851e-e1fdebe391aa` is complete and archived.
The remote worker advanced `a10fed8e` to `d52c6a0f`; the integration owner
cherry-picked its exact five-file source scope onto canonical PC `80e80df`,
then landed test-only follow-up `7c9299755` as final tip `a96f358`.
The per-map CPU texture source record carries host-pointer-safe image/TLUT
metadata, explicit source kind, and generation invalidation across cache,
replacement, fallback, stale, TLUT, and destruction paths. The integrated
native and combined ASan/UBSan focused tests pass `2/2` each with no
diagnostics (`detect_leaks=0`). The V2 handoff fixture now explicitly checks
the sideband-required fail-closed status. No Apple
consumer/runtime binding, full link, LLDB, device, Metal encode/readback,
pixel, input, audio, save, or playability claim is authorized. Evidence is
`docs/evidence/GAME-TEXTURE-SOURCE-RECORD-D52C6A0F-2026-08-14.md`.

Lane 133 / task `01a00127-b749-7021-bb08-a8b1485773df` is complete/integrated/archived.
The remote M3 Max worker `c1/lane-v2-texture-source-binder-m3` advanced
`a96f358` to `08998d0`; the integration owner cherry-picked it as canonical PC
`354f33884`. Its four-file Apple V2 binder synchronously consumes the
`pc_gx_get_v2_texture_source` metadata, validates source/lifetime fields, and
fails closed before any renderer work. Native and combined ASan/UBSan focused
CTest pass `3/3` each with `--parallel 1` and no diagnostics. The worktree was
clean at handoff; exact native/sanitized roots remain listed in the evidence
until holder-free cleanup. No `pc_gx.c`/packet-builder, decomp, full-link, LLDB,
launch, device, Metal, pixel, input, audio, save, ISO, or playability scope.
Evidence is `docs/evidence/APPLE-V2-TEXTURE-SOURCE-BINDER-08998D0-2026-08-14.md`.

Root-owned lane 134 is now a completed launch/trace check at the integrated
`354f33884` tip. Its one serialized full link reached `[4018/4019]` and
produced an arm64 Mach-O in `/private/tmp/acgc-current-v2-texture-binder-runtime`.
The headless shell still has no SDL display, but a logged-in GUI Terminal launch
opened the local GAFE01 disc, mounted COPYDATE/forest archives, reached
NEOS/LOGO/`graph_proc`, and returned after the bounded TERM window. The one
return-safe LLDB trace counted `graph_task_set00=24`, `emu64_taskstart=24`,
`GXBegin=509`, `pc_gx_flush_vertices=509`, and V2 builder entry `508`; the
Apple consumer/provider/observer each remained `0`. This localizes the live
boundary to V2 builder fail-closed before the Apple consumer. No Metal
encode/present, pixel, input, audible audio, save, device, simulator, or
playability claim follows. Evidence is
`docs/evidence/CURRENT-V2-TEXTURE-BINDER-RUNTIME-2026-08-14.md`. The next gate
is one separately owned CPU/source diagnosis of that forwarding boundary, then
a fresh serialized current-tip trace; no ISO or assets may move to the M3 Max
or cloud.

- Lane 116 / task `019fff00-d312-73a0-8396-d94c6618e0b8` — complete pending
  root review. Remote PC worktree `/private/tmp/acgc-lane-gx-v4-channel-diagnostic-m3`
  on `c1/lane-gx-v4-channel-diagnostic-m3`, base `a53b192`, final `e8155c6`.
  The V4-only channel predicate now accepts decomp-compatible disabled
  `GX_SRC_REG`/`GX_SRC_VTX` material sources while retaining enabled/lighting
  rejection; native and combined ASan/UBSan focused tests pass `4/4` each with
  no diagnostics (`detect_leaks=0`). No live callback, Metal, pixel, or
  playability claim; preserve the worktree/branch until integration review.
- Lane 117 / task `019fff16-cacd-7133-9823-15d529e8bb63` is complete with no
  source change: the Apple crosswalk localized the live rejection upstream of
  the consumer; native and combined ASan/UBSan typed-consumer tests passed
  `1/1` each. Its exact remote worktree and focused roots were retired after
  holder-free checks; no Apple/runtime defect or live callback claim follows.
- Lane 118 / task `019fff16-d72e-7703-8721-c81517ebe538` is integrated locally
  as PC `13c0e0cf` from worker `ce06b5b`. Its synthetic V4 handoff fixture and
  minimal CMake registration pass native and combined ASan/UBSan focused tests
  `1/1` each (`detect_leaks=0`, no diagnostics); evidence is
  `docs/evidence/GX-V4-HANDOFF-FIXTURE-13C0E0CF-2026-08-13.md`. The remote
  worktree and focused roots were retired after holder-free checks; no live
  callback, Metal, pixel, or playability claim follows.
- Lanes 119–127 have now completed on the remote M3 Max with non-overlapping
  contracts: sanitizer/Windows
  refresh (`019fff16-e538-7e73-a844-f4e09c18538d`), input trigger audit
  (`019fff16-f4d5-76b1-b3eb-dd7d9bb18512`), mixer/CoreAudio refresh
  (`019fff17-0485-79d1-ab6b-47e1495d97af`), CARD production validation
  (`019fff17-0fe1-7b23-8dd9-b18503b70fe8`), lifecycle/timing audit
  (`019fff17-1964-7822-babf-2120bc78fb6e`), graph terminator fixture
  (`019fff17-22e0-7f12-8c20-2fad9a684892`), texture/TLUT/TEV fixtures
  (`019fff17-2f40-78c1-b2c6-f69c50fc93fb`), Metal state contract audit
  (`019fff17-38e4-7ed3-a2aa-04e48b823c33`), and iOS shared-boundary audit
  (`019fff17-4100-78f1-91c4-0996c40e41b5`). Source lanes must create their
  own PC submodule branches/worktrees; audit lanes are read-only/test-only.
  No lane may claim a full link, LLDB, device, Metal encode/readback, pixel,
  input, audible audio, save/device persistence, simulator, or playability
  gate without separate evidence.

The integration owner has since reviewed lanes 116 and 118 and advanced the
local canonical PC pointer to `13c0e0cf`; lane 116's and lane 118's focused
native and ASan/UBSan gates pass `1/1` each. Lanes 119–127 remain based on the
clean remote `a53b192` snapshot; their commits will be reviewed and rebased or
cherry-picked one at a time after their handoffs.

Current maintenance state: lanes 96, 97, and 98 are complete and archived. Lane
96's first graph task traversed eight inline `G_DL_NOPUSH` continuations to a
clean `G_ENDDL`, returned `0`, and did not reach `GXBegin`; lane 97 then
confirmed a second graph submission and interpreter entry but timed out in the
continuation prefix. Lane 98's one longer bounded run completed that second task
with eight `G_DL` handlers, `G_ENDDL`, and `return_err=0`, `cmds=12`, and
`end_dl=1`; task 2 still had no draw handler, `GXBegin`, or flush. No frame or
Metal claim follows.
Lane 99 completed its read-only current-tip crosswalk but then hit a remote
Codex compaction `404` twice before any source/build/runtime work. Its useful
finding is that live textured/TEV/active state reaches the fail-closed packet
builder rejection before `pc_metal_runtime_observe`; no defect was proven and
no frame or Metal claim follows. The task is archived and no worker is active.
Lane 100 was archived after the same remote Codex compaction `404` occurred
before its worker could produce a handoff. The root-owned continuation then
committed the opt-in diagnostic on `c1/lane-metal-rejection-diagnostic` and
fast-forwarded it into `c1/macos-host-launch` at `8a19f23`. One serialized
arm64 link and one elevated, directly rooted launch produced 64 bounded v2
records: 32 preflight and 32 fail-closed results, with no success. The live
state is standard source-alpha blending plus `GX_TEXMTX0`, both outside the
current v2 contract; this explains the rejection without proving a defect.
The evidence is `docs/evidence/METAL-REJECTION-DIAGNOSTIC-8A19F23-2026-08-13.md`.
No callback, Metal encode/readback, pixel, input, audio, save, device, or
playability claim follows. Lanes 101 and 102 both failed at the remote
compaction `404` boundary before producing a handoff; lane 101's one-file
uncommitted V3 header draft was rejected and reverted, while lane 102 left no
source edit. The root-owned V3 continuation is now integrated at PC `042cbf7`:
it forwards the observed blend/source-alpha/`GX_LO_NOOP`/`GX_TEXMTX0` state
through a separate typed callback, passes the combined V1/V2/V3 focused native
and ASan/UBSan tests `3/3` each, and marks V3 `V3_EXTENSION_NOT_RENDERED`.
No full link, live callback count, Metal encode/readback, pixel, input, audio,
save, device, or playability claim follows; the current-tip runtime count is
complete, and the alpha-update V3 rejection reason is now source-backed. The
next dependency-ready gate is the real Metal state encoder or a separately
authorized current-tip runtime trace, after the focused builder-to-consumer
fixture and Apple consumer boundary have passed their CPU gates. Lanes 104–110
are complete/integrated/archived. Lane 111 has completed its one serialized
runtime attempt and is awaiting exact-path cleanup. Lane 114's read-only
mixer/CoreAudio audit is also complete and awaiting exact-path cleanup. Lane
113's input audit is complete; its temporary root and visible worktree are
absent after archival, but orphaned holders still name the unlinked worktree
and must exit naturally before stale metadata reconciliation. Lane 112's
Save_t/CARD fixture is integrated and its four worker/integration roots have
been retired after holder checks; its preserved worktree still has
  owner-managed holders. The older “no production worker” sentence predates the
remote M3 Max batch above; lanes 116–136 are complete/integrated/archived and
lane 137 is now complete/parked with no source edit because its packet-fit gate
requires packet-validator and Apple-consumer ownership outside that lane. Lane
138 is now complete/integrated/archived after its separate CPU/source contract;
lane 139 completed the serialized runtime trace and lane 140 completed the
focused triangle-batch source gate. Lane 141 completed the only serialized
current-tip full link/LLDB trace; no competing runtime, duplicate, or filler
lane is open. The current portable
verification tip is `c973dbee`, which keeps
resolved V4 texture-map aliases
safe, permits live unencoded alpha/depth/cull state through the V4-only
predicate, and wires the V4 builder into a typed Apple consumer callback after
V2/V3 fail, maps the supported blend/alpha subset, and
keeps V3 texture-matrix state explicitly `NOT_RENDERED` on top of the `dbf6986`
V4 consumer seam. It also adds the reviewed per-map CPU texture source record
and generation/invalidation boundary from lane 132. The integrated six-target
native and combined ASan/UBSan
focused tests are `6/6` each, and direct Apple consumer/sink fixtures are `2/2`
in each matrix; the new opt-in texture/TLUT/TEV resolver is CPU-only and keeps
the typed V2 handoff `NOT_RENDERED` for unsupported or unforwarded state. This
remains CPU/contract and compile coverage only; no live V4 callback, Metal
encode/readback, pixel, device, or playability claim follows.
See `docs/evidence/GX-V4-LIVE-CONSUMER-28EBAC2-2026-08-13.md`,
`docs/evidence/GX-V4-TEXTURE-MAP-ALIAS-83FE50C-2026-08-13.md`, and
`docs/evidence/GX-V4-UNRENDERED-RASTER-46A8AE5-2026-08-13.md`. The Save_t/CARD
recovery fixture remains integrated at `f19c73f`, while the real i686 Windows/PE
boundary remains blocked by the absent toolchain/sysroot.
One serialized current-tip `28ebac2` link reached `[4018/4019]`; its bounded
LLDB launch reached the game graph/GX path and counted
`pc_gx_try_handoff_semantic_packet_v4=558`, but the typed V4 Apple consumer,
prepare path, and `pc_metal_runtime_observe` were all `0`. This is live V4
builder-rejection evidence only, with no callback, Metal encode/readback,
pixel, or playability claim. See
`docs/evidence/CURRENT-V4-LIVE-CONSUMER-RUNTIME-28EBAC2-2026-08-13.md`.
The current-tip `46a8ae5` link also reached `[4018/4019]`, `[LOGO]`, and
`[NEOS_OUT]`; its explicit-return trace counted 542 V4 builder attempts but
zero V4 consumer/prepare/observer hits. The diagnostic cap remained 64
`reason=global_state` records because the classifier still used the old
predicate. The first correction (`adaddfd`) left a duplicated helper check;
integrated PC `a53b192` now aligns the classifier with the relaxed V4 predicate.
The follow-up trace below localizes the repeated game-owned path to the channel
predicate. See
`docs/evidence/CURRENT-V4-UNRENDERED-RASTER-RUNTIME-46A8AE5-2026-08-13.md`.
The corrected current-tip `a53b192` link reached `[4018/4019]`, `[LOGO]`, and
`[NEOS_OUT]`; its trace counted `graph_task_set00=33`,
`emu64_taskstart=33`, `GXBegin=601`, `pc_gx_flush_vertices=601`, and
`pc_gx_try_handoff_semantic_packet_v4=600`. The V4 consumer, prepare path, and
runtime observer stayed at `0`; 33 capped records classify the repeated
one-channel textured path as `channel`, while 31 heterogeneous setup records
remain `global_state`. This is live builder-rejection evidence only. See
`docs/evidence/CURRENT-V4-REJECTION-RUNTIME-A53B192-2026-08-13.md`.
The remote M3 Max audit batch (lanes 119–127) is summarized in
`docs/evidence/REMOTE-M3MAX-AUDIT-BATCH-2026-08-13.md`; all of those exact
worktrees and focused roots were retired after holder-free checks, with no ISO
or extracted asset transfer.
Lane 115 is parked at setup because the requested M3 Max handoff returned
`No matching saved project was found on M3 Max`; it has not edited, built, or
tested locally. No active worker is counted until that remote project is
registered.
Lane 108's one current-tip link reached `[4018/4019]` and its one unprivileged
LLDB launch created a real inferior, reached boot/graph/GX, and recorded
`graph_task_set00=29`, `emu64_taskstart=29`, `GXBegin=532`,
`pc_gx_flush_vertices=532`, and V2/V3 builder entries `531` each. The typed V3
Apple consumer and `pc_metal_runtime_observe` were both `0`; the diagnostic
captured `64/64` `alpha_update_disabled` records (the source cap), with no
other predicate records. This is live builder-rejection evidence, not a
successful packet/callback, Metal, pixel, or playability claim. See
`docs/evidence/CURRENT-V3-REJECTION-RUNTIME-F18E7CD-2026-08-13.md`.
Lane 109 completed the dependency-ready CPU/contract gate: its separately
versioned V4 alpha-state packet/builder preserves the existing V3 ABI and
fail-closed behavior. Integrated native and combined ASan/UBSan focused tests
pass `5/5` each. The lane remains CPU/contract scoped; Apple consumer files are
a separate successor and no fresh runtime/device run is implied. Lane 110 has
now completed its typed Apple consumer/runtime validation seam with native and
combined ASan/UBSan focused CTest `6/6` each; no full link, LLDB, device, Metal,
pixel, or playability claim is authorized. Lane 111's completed runtime attempt
is recorded in `docs/evidence/CURRENT-V4-RUNTIME-DBF6986-2026-08-13.md`; it
owns no source edits and cannot claim Metal encode/readback, pixels, or
playability. Lane 112's integrated change is limited to the production recovery fixture registration; `pc_m_card.c` itself is unchanged. It owns only
one focused fixture. Lane 113's read-only input evidence is recorded
separately, with a narrow analog-trigger fix candidate requiring authorization.
Lane 114's transport-only audio evidence is recorded separately; all focused
roots are unique and must stop at CPU/adapter evidence.
Lane 94
(`019ffca1-c92a-7363-9687-a503d2f2851d`) completed one corrected elevated
LLDB trace from canonical PC `d1e812c`. Explicit-return callbacks continued
through `graph_task_set00` and `emu64_taskstart`; the debugger-owned sentinel
then stopped cleanly, with `GXBegin`, `pc_gx_flush_vertices`, v2 handoff, Apple
consumer, and runtime-observer counts all `0`. It owned no source edits and no
Metal encode/readback/pixel scope. Lane 93
(`019ffc93-5d85-7d53-a6bf-67a5b13305da`) completed one elevated runtime
trace with a durable final breakpoint list. It recorded one
`graph_task_set00` hit, then stopped because the temporary Python callback
omitted an explicit `return`; all downstream zeros are prefix-only. It owned no
source edits and no Metal encode/readback/pixel scope. Lane
92 (`019ffc83-96c2-7ce1-97d9-848fb308a41d`) completed one permitted elevated
current-tip LLDB launch. It created an inferior and reached boot/runtime,
resolving lane 91's pre-inferior `-1` blocker, but the bounded interruption
occurred before LLDB emitted per-symbol counts; no callback hit is inferred.
It owned no source edits and no Metal encode/readback/pixel scope. Lane 91
(`019ffc73-d5c6-78f1-94bb-91ad0d277d1d`) completed one serialized current-tip
arm64 link and one bounded LLDB trace from canonical PC `d1e812c`; the link
passed `4019/4019`, but LLDB failed before creating an inferior with status
`-1 (no such process)` and all breakpoints were zero-hit. It owns no source
edits, no umbrella changes, and no Metal encode/readback/pixel scope. The prior
callback capture lane
`019ffbc7-01e9-7b32-b5b1-f0abaada1b09`, the offscreen Metal sink lane
`019ffbc8-1f2b-7513-9c1c-7ddde5114f97`, the input, mixer/audio, lifecycle,
observer-rejection, and read-only GX v2 contract lanes are complete/archived
with their separate evidence and claim boundaries. The root-owned elevated
current-tip launch reached `graph_proc`/NEOS and `pc_gx_flush_vertices`, then
returned through `graph_proc` with status `0` after bounded SIGTERM; it proves
launch/boot/GX-boundary/clean-return only, not callback or renderer output.
Implementation lane `019ffc34-ab7a-74d0-839e-65cd045a2b01` is
complete/integrated at PC `26da235` from worker `06fa74c`; its fixed-width v2
builder/validator and fail-closed fixtures pass native and ASan/UBSan focused
CTest `3/3` each. Consumer lane `019ffc5d-392e-75e2-a863-a4b9199b11dd` is
complete/integrated at PC `d1e812c` from worker `cd881b7`: a separately typed
v2 callback validates the full packet, preserves v1 dispatch, and reports
`V2_EXTENSION_NOT_RENDERED`. Its native and ASan/UBSan focused CTest runs pass
`4/4` each. Neither lane proves a live game-owned callback, Metal
encode/readback/pixel, device, input, audio, save, or playability gate. See
`docs/evidence/GX-V2-CONSUMER-BOUNDARY-2026-08-13.md`.

The Windows, sanitizer, iOS, and input frame-guard handoffs are complete. Lane
107's exact physical roots and visible worktree have been retired by cleanup;
one source-registry metadata record remains preserved after `Operation not
permitted`, and the two dirty failed-clone directories remain intentionally
untouched. The authoritative PC source is `f19c73f` on
`c1/macos-host-launch`; the umbrella branch is `main` (the local
`c1/apple-port-bootstrap` alias is synchronized to the same tip) plus only
the pre-existing `.codex`/settings edits. The current-tip V3 runtime count is
complete and remains separate from Metal encode/readback/pixel proof: the
one unprivileged launch created an inferior and reached boot, GX, and V3
builder entries, while no V3 consumer or Apple runtime-observer hit. Lane 104's
source-backed reason is `g_gx.alpha_update_enable == 0`; the focused
builder-to-consumer fixture and Apple boundary audit are complete. Lane 109 is
also complete/integrated/archived with the V4 alpha-state contract and focused
native/ASan/UBSan `5/5` results. Lane 110 is complete/integrated/archived;
its typed V4 Apple consumer validation passes native and combined ASan/UBSan
focused CTest `6/6` each. Lane 111 and lane 114 are complete/archived pending
exact-path cleanup; lanes 112–114 are complete/archived pending exact-path
cleanup. Full links and LLDB launches remain serialized.
The graph-capture, GX-to-Metal, save-manager, post-link runtime,
live-target-resolver, and current-tip trace history remains recorded below.
Lane 64 is complete/archived with a separate pre-launch LLDB
command-setting blocker. Lane 65 is complete/archived with live target and GX
boundary evidence. Lane 66 is complete/archived with its source crosswalk and
focused reruns recorded below. Lane 67 is complete/archived with the integrated
opt-in target observer and focused native/ASan/UBSan evidence; its duplicate
setup was stopped before edits. Lane 68 is complete/archived with the first
fresh game-owned target-continuation record; its full link exited 0 with the
terminal `[4012/4013]` progress caveat and one LLDB launch reached LOGO/NEOS
before TERM/grace. GX was not instrumented. Lane 69 is complete/archived: its
fresh full link exited 0, LLDB accepted the generated-bin working directory and
both GX breakpoints, then failed before inferior creation with `status -1` and
`nice(5) failed: operation not permitted`; no retry or GX evidence followed.
No other filler lane is being opened.
The root-owned direct no-`nice` LLDB trace now proves the next GX boundary:
`GXBegin` and `pc_gx_flush_vertices` both hit through `emu64::dl_G_TRIN` and
`graph_task_set00`, while the target observer emitted `F0002000` capacity 1024
with `F0002001`. This remains OpenGL/GX boundary evidence; Metal encode/present
and pixel proof are still open. Lane 70's isolated Metal bridge audit is now
complete and archived.
The completed lane-70 audit found that `ac_pc` never registers or links the
Apple consumer, while the current state gate rejects resident bootstrap
textures and the existing consumer remains a CPU fixture adapter. The
integrated lane-71 source handoff now owns the borrowed packet-consumer bind,
the narrow resident-versus-active texture gate correction, and bounded
callback/status telemetry, while leaving the legacy OpenGL submission path
unchanged. It cannot claim Metal encoding, presentation, pixels, or playability.
The handoff evidence is
`docs/evidence/DARWIN-GX-HANDOFF-REGISTRATION-2026-08-13.md`; the delegated
lane-72 blocker remains historical in
`docs/evidence/LIVE-DARWIN-GX-CALLBACK-RUNTIME-2026-08-13.md`, and the fresh
root-owned launch is recorded in
`docs/evidence/ROOT-LIVE-LAUNCH-2026-08-13.md`.
Mixer/CoreAudio, Metal, GX-prefix,
texture-pointer, texture/TLUT/TEV, runtime-input, filesystem, timing,
Windows, and sanitizer lanes are complete/parked or integrated. The current
game-cleanup invalid-free successor
(`019ffa28-3ef7-7280-923c-5a01bf2eb4c2`) is now complete. The complete graph
capture contract and game GX-to-Metal handoff seam are complete and archived.
The full save-manager restart seam
is integrated at `a7b9dff` and its task is archived. The post-fix GX submission
trace (`019ffa49-4f9c-7da2-a288-5791e5cf5c93`) is complete and archived with
evidence in `docs/evidence/GX-SUBMISSION-TRACE-2026-08-12.md`. The
CARD Save_t reload recovery (`019ffa49-4f44-7b73-a4ab-8c45dc211f14`) is
complete and archived with production evidence. The exact-tip sanitizer refresh
(`019ffa4c-8734-7ac2-99d1-f67a0682be31`) is complete and archived; its
evidence is recorded in `docs/evidence/SANITIZER-REFRESH-2026-08-12.md`. No
other dependency-ready lane is being refilled: live
CoreAudio/Metal devices and the complete game-owned graph capture remain
unavailable, while Windows and iOS are gated by their stated proofs. The
post-audio, arm64 post-texture, WaveTouch, and audio-DMA handoffs remain
complete/archived.
Pinned task `019ff9bd-7f15-7513-8b22-61af13c8a6fe`
(`ACGC Worktree and Thread Cleanup`) owns the separate 30-minute cleanup
heartbeat. Its first pass retired five clean source worktrees and pruned their
stale Git metadata, preserving every branch and commit. It also retired five
clean orphaned umbrella worktrees; the remaining `a828` checkout is dirty and
is explicitly preserved. It archives completed worker tasks but does not touch
active or dirty state. The dated manifest is
`/Users/jk/Desktop/Automations/cleanup-records/2026-08-12-acgc-first-pass.md`.

The resumed workers below have durable task IDs and isolated umbrella
worktrees. Source-edit workers must create the named owning-submodule branch
before editing; read-only/test workers must stay within their declared scope.
The integration owner reviews one handoff at a time, locally merges reviewed
commits into `c1/macos-host-launch` or the umbrella as appropriate, reruns the
smallest focused gate, and updates the gitlink/docs. Only after that review does
the cleanup heartbeat archive the task and retire its worktree/build artifacts.
No worker may self-merge, update the umbrella gitlink, or claim a later gate
from compilation alone.

## Ownership and live state

| # | Lane / visible task ID | Ownership | Worktree / branch | State |
| --- | --- | --- | --- | --- |
| 1 | DVD aligned-read semantics — `019ff8aa-6e31-7723-bb32-095c7158148b` | `pc_dvd.c`, focused DVD probe | `/private/tmp/acgc-lane-dvd-loader` / `c1/lane-dvd-loader`; source `dfb3f7f`, integrated as `4f77dab` | Complete; fresh run passes `COPYDATE` and reaches `game.c:154` |
| 2 | Launch supervisor — `019ff8d2-a527-7c90-b7c0-f95aef4f5a0e` | Umbrella `script/build_and_run_game.sh` only | `/Users/jk/.codex/worktrees/f2c7/acgc-modern-port`; `c1/lane-launch-supervisor` | Complete; umbrella `e96776d`; TERM grace/KILL fixture passed |
| 3 | Boot trace → graph fault repair — `019ff8d3-06e4-71d3-8708-120d84fa270f` → `019ff8e7-402d-7a31-844a-0afd32918cc1` | Completed LLDB evidence, then source-owned `GAME`/`GRAPH` LP64 callback path | Trace `/Users/jk/.codex/worktrees/6bed/acgc-modern-port`; repair `/private/tmp/acgc-lane-graph-fault` / `c1/lane-graph-fault` | Complete/integrated; source `5086f1d`; reload crosses `game.c:154` to `graph_task_set00`; live packet now captured by lane 4 |
| 4 | First game-owned render submission — `019ff8aa-6e31-7723-bb32-097e85bb2293` → `019ff8ff-51e1-74b0-ad13-1539b72e8937` | Graph/emu64 submission capture | `/private/tmp/acgc-lane-render-capture-v2` / `c1/lane-capture`; live `/Users/jk/.codex/worktrees/5f6a/acgc-modern-port`; source branch `c1/lane-render-live` | Complete/integrated as `10d6ac0`; LLDB callback captured version 1, frame 0, capacity 256, count 8, words `de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000`; run then faults at `pc_gx_texture.c:62` on truncated `0x83bdc0`; no frame claim |
| 5 | GX semantic packet — `019ff8d3-0887-7472-a53a-84c5d7ad105c` | Fixed-width renderer-neutral packet + tests | `/private/tmp/acgc-lane-gx-packet` / `c1/lane-gx-packet` | Complete; source `83fa889`; native/Apple/ASan focused tests passed |
| 6 | Metal geometry/state — `019ff8d3-0c2e-7463-b918-af75f7cb6208` | Apple geometry/state fixtures | `/private/tmp/acgc-lane-metal-state` / `c1/lane-metal-state` | Complete; source `866dd94`; CPU/geometry passed, Metal skipped (no device) |
| 7 | Texture/TLUT/TEV fixtures — `019ff8d3-150c-77f0-b99c-dcbf38645977` | Synthetic texture/palette/combiner fixtures | `/private/tmp/acgc-lane-tev-fixtures` / `c1/lane-tev-fixtures` | Complete; source `ddbb498`; focused native + ASan/UBSan fixture passed |
| 8 | Input snapshot + SDL event smoke — `019ff8aa-743f-7923-8d9b-276421802fa8` | SDL-to-logical keyboard/controller snapshot, PADRead handoff, and event-path tests | `/private/tmp/acgc-lane-input-snapshot` / `c1/lane-input-snapshot` | Complete/parked; source `8b6849f`; native + ASan/UBSan SDL/controller smoke 2/2, keyboard requires OS/human event |
| 9 | Mixer/CoreAudio correctness — `019ff8aa-7959-7342-af84-187dfb2e0a89` | Reconstructed PCM/mixer output proof and NEOS provenance | `/private/tmp/acgc-lane-audio-mixer` / `c1/lane-audio-mixer` | Complete/parked; source `2736838`; RSP/Neos-style provenance to callback passes 1,118 nonzero samples native + ASan; real device/audible gate remains open |
| 10 | Save_t/GCI roundtrip — `019ff8d3-0fe5-7883-8ebb-74eeac6efcb6` | Byte codec and process-restart persistence evidence | `/Users/jk/.codex/worktrees/35f6/acgc-modern-port` / `c1/lane-save-gci` | Complete/parked; umbrella `aeefc15`; canonical/checksum/codec restart pass, arbitrary raw range `0xB6..0xB7` remains blocked |
| 11 | Sandboxed filesystem/atomic saves — `019ff8d3-1b80-7ab0-89b5-28afcf680cef` | Application Support/cache/log/temp-file adapter | `/Users/jk/.codex/worktrees/10c5/acgc-modern-port`; `c1/lane-filesystem-saves` | Complete; umbrella `ee7b814`; synthetic atomic/corruption/isolation probes passed |
| 12 | Timing/retrace/lifecycle — `019ff8d3-1f89-7c23-82fb-150b2f39e37c` | Monotonic time, workers, shutdown/resume | `/Users/jk/.codex/worktrees/cf91/acgc-modern-port`; `c1/lane-timing-lifecycle` | Complete; umbrella `15a081f`; strict + ASan/UBSan repeated trace passed |
| 13 | Windows compatibility audit — `019ff8d3-23c5-75a2-beac-7f7e70c72c08` | Read-only x86/Windows/OpenGL/SDL conditional audit | `/Users/jk/.codex/worktrees/8231/acgc-modern-port` | Complete read-only; scoped to `4f77dab`, no MinGW compiler sign-off |
| 14 | Native + ASan/UBSan matrix — `019ff8d3-2a6f-7610-a9f1-53f237353454` | Focused verification and sanitizer evidence | `/Users/jk/.codex/worktrees/2232/acgc-modern-port`; `c1/lane-verification-matrix` | Complete/parked; umbrella `38f85da`; 32 native + 32 ASan/UBSan targets at exact `858d802`, CoreAudio/Metal skipped as expected |
| 15 | Integration/evidence owner — `019ff398-2520-7191-ac5c-f3007c49163f` | Umbrella docs, roadmap, reviewed commits, source gitlink, launch proof | `/Users/jk/Documents/Projects/acgc-modern-port` / `main` (`c1/apple-port-bootstrap` alias) | Active; only lane allowed to update the umbrella submodule pointer |
| 16 | Graph capture → GX packet — `019ff914-44fc-7801-88f4-ee513fc8e728` | New adapter/test from captured prefix into existing GX contract | `/Users/jk/.codex/worktrees/4a27/acgc-modern-port`; source `/private/tmp/acgc-lane-graph-gx-adapter` / `c1/lane-graph-gx-adapter` | Complete; reviewed `4d2fa4f` and integrated as source `d0ae08d`; 3/3 focused tests passed; observed live prefix still fails closed |
| 17 | LP64 texture handle remediation — `019ff914-9bd9-77f3-8d8b-d72f5c00d587` | `pc_gx_texture.c` and opaque-reference width/lifetime | `/Users/jk/.codex/worktrees/fc81/acgc-modern-port`; source `/private/tmp/acgc-lane-lp64-texture` / `c1/lane-lp64-texture` | Complete/integrated as source `578c8b7`; focused native/ASan/UBSan fixture passes; actual game crosses the texture fault but no frame is claimed |
| 18 | Metal semantic packet consumer — `019ff914-9e34-7181-8903-f8022c82cacf` | Packet-to-state/encoder validation and device-gated fixture | `/Users/jk/.codex/worktrees/da16/acgc-modern-port`; source `/private/tmp/acgc-lane-metal-packet-consumer` / `c1/lane-metal-packet-consumer` | Complete/integrated as `12b4f6e` (lane commit `209e95f`); 9 Apple tests pass and 2 Metal tests skip without a device; no live frame claim |
| 19 | Live graph capture reproducibility — `019ff914-ad3f-7721-82f2-d8985d601ba1` | Two cold-run snapshots and exact fault boundary | `/Users/jk/.codex/worktrees/5edb/acgc-modern-port`; build `/private/tmp/acgc-lane-live-capture-repro-build` | Complete/parked; two cold runs are byte-identical (version 1, frame 0, capacity 256, count 8, same words) and both stop at `pc_gx_texture.c:62` `data=0x83bdc0` before legacy submission; no frame claim |
| 20 | CoreAudio/device and asset-audio successor — `019ff914-a32b-7363-a619-f79e21c75db3` | Real sink gate, then asset-driven NEOS_OUT runtime trace | `/Users/jk/.codex/worktrees/fdc9/acgc-modern-port`; builds `/private/tmp/acgc-lane-coreaudio-device-build` and `/private/tmp/acgc-lane-audio-asset-runtime-build` | Parked/archived under four-lane cap: device subgate complete with declared skip `77` (`kAudioDevicePropertyDeviceIsAlive`, `560947818`); no audible claim |
| 21 | Save_t raw-wire forensic → codec fix — `019ff914-a86e-7793-b0f0-6ce23e8d97a0` | `time_limit` width/endianness evidence, then `pc_save_bswap.c` repair | `/Users/jk/.codex/worktrees/e9ef/acgc-modern-port`; builds `/private/tmp/acgc-lane-save-wire-forensic-build` and `/private/tmp/acgc-lane-save-wire-fix-build`; source successor `/private/tmp/acgc-lane-save-wire-fix` / `c1/lane-save-wire-fix` | Parked/archived under four-lane cap; forensic result retained: effective 16-bit bitfield at `+0x02`, lost `Save_t +0xB6..+0xB7`, `wire=0xF10E` → `roundtrip=0x0000`; no codec edit integrated |
| 22 | Integrated sanitizer matrix — `019ff914-b322-7e10-876e-c942a45aef4a` | Native and ASan/UBSan at current source HEAD, including texture fixture | `/Users/jk/.codex/worktrees/44e8/acgc-modern-port`; builds `/private/tmp/acgc-lane-integrated-native-12b4f6e` and `/private/tmp/acgc-lane-integrated-sanitizer-12b4f6e` | Complete/parked at `12b4f6e`; 34/34 registered tests passed with 3 expected skips in each matrix; 11 recoverable `aflags_c` UBSan findings remain; focused adapter rerun at `d0ae08d` passed 3/3 in `/private/tmp/acgc-lane-integrated-adapter-d0ae08d` |
| 23 | Windows compatibility post-capture audit — `019ff914-b7c7-75d2-ad4c-d94032e35b12` | `_WIN32`/x86/OpenGL/SDL conditional audit after `10d6ac0` | `/Users/jk/.codex/worktrees/d9c5/acgc-modern-port`; build `/private/tmp/acgc-lane-windows-audit-build` | Complete/parked; strict `_WIN32` graph seam compile/test passes; no source regression found; native Windows/x86 toolchain remains unavailable |
| 24 | Pre-render texture fault fixture — `019ff914-bfa0-7d31-8228-247292e5cad1` | Isolated regression fixture for 32-bit texture-object truncation | `/Users/jk/.codex/worktrees/52c7/acgc-modern-port`; source `/private/tmp/acgc-lane-texture-fault-fixture` / `c1/lane-texture-fault-fixture` | Complete/integrated as `07a5447`; native arm64 fixture records full pointer → opaque handle → low-word truncation and intentional `EXPECTED_FAILURE`; remediation remains lane 17 |
| 25 | macOS host input/window lifecycle gate — `019ff914-c6fa-7812-bed5-8939ef4fa58e` | Init/poll/focus-resume/termination plus exact input handoff | `/Users/jk/.codex/worktrees/24c0/acgc-modern-port`; planned source `/private/tmp/acgc-lane-macos-host-lifecycle` / `c1/lane-macos-host-lifecycle` | Parked/archived under four-lane cap; prior lifecycle evidence remains integrated |
| 26 | Post-fix game frame runtime — client `client-new-thread:1b48103c-9b76-4caf-8598-686e392653c3` | Fresh actual-game arm64 run after texture remediation, packet/frame boundary | No separate worktree activated; root integration owner used `/private/tmp/acgc-integrated-audio-wave-build` | Superseded by root-owned integrated run; first identifiable game-owned frame captured, later `rc=139`; no duplicate full link |
| 27 | Audio-bank ABI repair — root-owned continuation | `src/static/jaudio_NES/internal/system.c`, `channel.c`, fixed-width bank decoder and focused fixtures | `/private/tmp/acgc-lane-audio-lp64` / `c1/lane-audio-lp64`; lane commit `5974764`, integrated on `c1/macos-host-launch` as source `909f3ca`; build `/private/tmp/acgc-integrated-audio-wave-build` | Integrated bounded fix; `ac_pc` full link `rc=0`, audio fixture 1/1, emu64 native 3/3, ASan/UBSan 3/3; bank 28 decodes (`3376` bytes), `[LOGO] draw` appears, and the integrated screenshot passes the game-frame gate; later `rc=139` keeps clean shutdown and post-frame stability open |
| 28 | Frame evidence packaging — `019ff9a0-f9be-73a0-a452-02a309e5baa5` | Umbrella parser/report only; current-source binding and fail-closed submit/encode/present/readback labels | `/Users/jk/.codex/worktrees/4efd/acgc-modern-port` / `c1/lane-frame-evidence`; integrated umbrella `adc1d6e` | Complete/integrated; self-test passes; exact clean `909f3ca` rerun returns `NOT_CLAIMED`, explicitly rejecting historical graph prefixes, fixture output, and a standalone screenshot as a full frame chain |
| 29 | Frame evidence harness — `019ff9a0-e9ed-78d3-8d4e-b7c617270b16` | Umbrella `scripts/probes/` only; bounded launch/boot/packet/present/frame classifier | `/Users/jk/.codex/worktrees/5e48/acgc-modern-port` / `c1/lane-frame-evidence` | Complete/integrated as umbrella `1d4d44b`; `bash -n`, ShellCheck, classifier tests, and fail-closed dry-run pass; no source, ISO, or frame claim |
| 30 | Audio-DMA LP64 fix — `019ff9a1-00c9-7fa3-815f-e282eb7ad2e9` | `src/static/jaudio_NES/internal/system.c` only; preserve native audio pointers at the DMA boundary | `/private/tmp/acgc-lane-audio-lp64` / `c1/lane-audio-lp64`; lane `304f055`, authoritative `724a18d` | Complete/integrated; serialized `ac_pc` link passes; fresh LLDB reaches `Nas_FastCopy` with native `DestAdd=0x10084c5e0`, avoids `_platform_memmove`/`EXC_BAD_ACCESS`, and stops intentionally at the first breakpoint |
| 31 | Fresh integrated post-frame run/trace — root-owned evidence continuation | Exact `724a18d` runtime, LOGO/NEOS markers, and bounded LLDB submission-entry trace; no source edits | `/private/tmp/acgc-integrated-audio-wave-build`; logs `/private/tmp/acgc-integrated-audio-724-run.log` and `/private/tmp/acgc-integrated-audio-724-lldb.log` | Complete bounded check; ten-second run reaches LOGO action 3 and NEOS frame 541; LLDB stops at `GXBegin`/`pc_gx_commit_pending_and_flush` (`pc_gx.c:253`); TERM wait status `139`; no Metal/pixel claim and no worker refill |
| 32 | Post-GXBegin termination — `019ffa0f-2a8d-7c43-9295-2389e7c2a02b` | Prior source edit scope was `host.c`, `game_runtime.c`, `pc_main.c`; successor owns the actual game-cleanup path | `/Users/jk/.codex/worktrees/b94a/acgc-modern-port`; source `/private/tmp/acgc-lane-post-gx-termination/source` / `c1/lane-post-gx-termination` (retired) | Complete/parked; 4011/4011 build and 10-second LOGO/NEOS liveness pass; TERM reproduces `rc=139` at `__osFree_NoLock → mFM_Field_dt:1370 → play_cleanup → game_dt`; no in-scope source fix or commit; no clean-shutdown/frame claim |
| 33 | Texture pointer runtime boundary — `019ffa11-aad0-7383-90f3-a6caedbf2a8f` | `pc_gx_texture.c` plus one focused fixture; native pointer/opaque-reference width contract | `/Users/jk/.codex/worktrees/93b0/acgc-modern-port`; source `/private/tmp/acgc-lane-texture-pointer-runtime` / `c1/lane-texture-pointer-runtime` (retired) | Complete/parked; no new commit because existing fix `578c8b7` is already in `724a18d`; native, ASan, and bounded LLDB round-trip recover the full above-4-GiB pointer; no renderer/readback claim |
| 34 | Metal live-frame consumer — `019ffa11-c6ee-7ef2-86fa-6bbe53e64b2d` | Apple packet consumer and geometry encoder only; device/present/readback gate | `/Users/jk/.codex/worktrees/60e4/acgc-modern-port`; source `/private/tmp/acgc-lane-metal-live-consumer` / `c1/lane-metal-live-consumer` (retired) | Complete/parked; CPU packet/geometry/renderer contracts pass; Metal tests skip `77` because `MTLCreateSystemDefaultDevice()` is unavailable; no encode/present/readback/pixel claim; no source changes |
| 35 | Live GX prefix decoder — `019ffa12-60bf-71d3-9531-ed47364e6ff7` | `pc_gbi_runtime.c` and focused decoder fixture; fail closed on incomplete 8-word capture | `/Users/jk/.codex/worktrees/81c4/acgc-modern-port`; source `/private/tmp/acgc-lane-gx-prefix-decoder` / `c1/lane-gx-prefix-decoder` (retired) | Complete/integrated at source `57d16bd`; fixture-only `DE010000`/`F0002000` contract; native 6/6 and sanitizer 5/5 pass; traversal sanitizer retains pre-existing `emu64.c:6078` `aflags_c` blocker; live capture remains incomplete and no draw is claimed |
| 36 | Live texture/TLUT/TEV evidence — `019ffa12-66ef-7d81-89a8-3ddae2063b97` | Apple texture/TEV fixtures and classifier only; no live-readback claim | `/Users/jk/.codex/worktrees/5c10/acgc-modern-port`; source `/private/tmp/acgc-lane-texture-tev-fixtures-20260812/source` / `c1/lane-texture-tev-fixtures-20260812` (retired) | Complete/integrated at source `ad0576a`; I8 first/last-texel fixture added; native and ASan/UBSan fixture PASS; no live texture upload, Metal readback, or game-frame claim |
| 37 | Runtime input proof — `019ffa12-6965-7a30-acc8-3f9123337a2e` | `pc_pad.c`, `pc_keybindings.c`, focused OS/controller event proof | `/Users/jk/.codex/worktrees/ecaf/acgc-modern-port`; source `/private/tmp/acgc-lane-host-input-worktree` / `c1/host-input-pad-read` (retired) | Complete/integrated at source `305b223`; bounded host mode adds OS-level keyboard → SDL → PADRead proof; native and ASan/UBSan focused 2/2; physical controller remains skipped without a device; no game-frame/audio claim |
| 38 | Mixer/CoreAudio sink — `019ffa12-7330-7820-b006-0b7058cf8af9` | `pc_audio.c`, `pc_audio_bank.c`; mixer-to-sink and exact device skip boundary | `/Users/jk/.codex/worktrees/a058/acgc-modern-port`; source `/private/tmp/acgc-lane-mixer-coreaudio/worktree` / `c1/lane-mixer-coreaudio` | Complete/parked; native 3/3 and ASan/UBSan software mixer/NEOS/bank fixtures pass; CoreAudio probe preserves skip `77` (`AudioDeviceGetProperty…560947818`), so device cadence/audibility remain unproven; no source changes |
| 39 | Save_t/GCI restart — `019ffa12-775d-7593-9b68-702d9e0501b0` | `pc_save_bswap.c`, `pc_card.c`; wire/checksum/restart roundtrip only | `/private/tmp/acgc-lane-save-t-gci-codec` (retired); source `c1/lane-save-t-gci-codec` | Complete; integrated at source `d1575f0`; native and ASan/UBSan codec/checksum/restart plus CARD adapter pass; raw `Save_t 0xB6..0xB7` preserved; production `pc_m_card.c` atomic/reload/corruption recovery remains open |
| 40 | Sandboxed filesystem/atomic-save evidence — `019ffa12-7f97-7113-8934-617a264394af` | Umbrella probes/evidence only; Application Support/temp/atomic replacement | `/Users/jk/.codex/worktrees/7f63/acgc-modern-port`; umbrella branch `c1/save-path-evidence` (retired) | Complete/integrated at umbrella `bb9aa02`; synthetic path/isolation/atomic-recovery probe 3/3 passes; no Save_t/GCI wire or sandbox-entitlement claim |
| 41 | Timing/retrace/lifecycle audit — `019ffa12-8092-7cd0-a5d9-9ff1904d821b` | Read-only `pc_os.c`, `pc_vi.c`, `game_runtime.c`; ranked status-139 handoff | `/Users/jk/.codex/worktrees/bb46/acgc-modern-port` (retired) | Complete/parked; game-runtime probe native and ASan/UBSan pass; bounded full-port trace stops at SDL init, so TERM/worker causality and clean shutdown remain unproven |
| 42 | Windows compatibility audit — `019ffa12-87a8-78b0-924a-feab35389797` | Read-only `_WIN32`/x86/OpenGL/SDL conditionals and toolchain probe | `/Users/jk/.codex/worktrees/3266/acgc-modern-port` (retired) | Complete/parked; portable native and ASan/UBSan 18/18 pass; MinGW i686/PE/Windows SDL toolchain unavailable, so no Windows compile/link/launch sign-off |
| 43 | Current native + ASan/UBSan matrix — `019ffa12-8a7e-76b0-9503-2f4394249e43` | Exact-tip focused test matrix; unique sanitizer build roots | `/Users/jk/.codex/worktrees/dc19/acgc-modern-port` (retired); provenance `03f1854e` / `c1/lane-sanitizer-724` | Complete/parked; native, ASan, and UBSan each 38 passed/3 expected skips/0 failures; no full link, device, or playability claim |
| 44 | ac-decomp GAFE01 toolchain audit — `019ffa12-929c-73e3-b706-a4f76c78a270` | Read-only configure/build/extraction boundary and Wine/Metrowerks blocker | `/Users/jk/.codex/worktrees/90c1/acgc-modern-port` (retired); retry logs `/private/tmp/acgc-lane-acdecomp-audit-retry` (retired) | Complete/parked; `python3 configure.py` generates Ninja, but `ninja -j1` stops at missing `orig/GAFE01_00/files/foresta.rel.szs`; no Wine/Metrowerks, extraction, native build, or runtime claim; GAFE01 config/build metadata match both upstreams |
| 45 | iOS shared-boundary readiness — `019ffa12-9809-7c21-b1e2-67f4f7bd52c5` | Read-only portable/Apple boundary map; iOS remains gated by macOS proof | `/Users/jk/.codex/worktrees/b09c/acgc-modern-port` (retired); branch `c1/ios-shared-boundary-readiness` | Complete/parked; integrated handoff `plans/IOS-SHARED-BOUNDARY-READINESS.md` (`d303b7f`); portable 18/18 and Apple 10 plus 2 Metal skips, ASan/UBSan same, serialized 4,011/4,011 audit link; no game-loop, live Metal pixel, input, audio, save, lifecycle, simulator, device, or playability claim |
| 46 | Game cleanup invalid-free successor — `019ffa28-3ef7-7280-923c-5a01bf2eb4c2` | `src/game/m_field_make.c`, `src/game/m_play.c`, `src/graph.c`, `src/static/libc64/__osMalloc.c`; exact TERM/allocator fault | `/private/tmp/acgc-lane-game-cleanup-invalid-free/source` (retired); `c1/lane-game-cleanup-invalid-free` | Complete/integrated at source `09dd182`; `mFM_MakeField` now uses `zelda_malloc_align` without a `u32` round-trip; native, ASan/UBSan, and UBSan fixture passes; exact integrated 4,011/4,011 arm64 build passes; 10-second LOGO/NEOS run and TERM grace return status `0`; no Metal/pixel/input/audio/save/playability claim |
| 47 | Production CARD Save_t reload recovery — `019ffa49-4f44-7b73-a4ab-8c45dc211f14` | `pc/src/pc_m_card.c` plus focused `pc/tests/` restart/corruption fixture only; production atomic write/restart/reload gate | `/private/tmp/acgc-lane-card-save-recovery/source` (retired); `c1/lane-card-save-recovery` preserved at `9e3bb99`; build root retired | Complete/integrated at source `5548570`; native and ASan+UBSan production fixture pass; validates checksum/identity, embedded-backup recovery, restart reload, and prior-generation `.bak1` fallback; full game save-manager/device/playability claims remain open |
| 48 | Post-fix game-owned GX submission trace — `019ffa49-4f9c-7da2-a288-5791e5cf5c93` | Read-only `graph_task_set00` → emu64/GX → `pc_gx` handoff and packet/terminator boundary | `/Users/jk/.codex/worktrees/1a7c/acgc-modern-port` (retired); isolated root `/private/tmp/acgc-lane-postfix-gx-submission` (retired) | Complete/archived; evidence is pinned to source `09dd182` and decomp `09ca8e8b`; live prefix remains incomplete (8/256 words, no terminator), stable OpenGL handoff reaches `pc_gx_flush_vertices`; Metal consumer skip `77`; no Metal/pixel/input/audio/save/simulator/device/playability claim |
| 49 | Exact-tip native + ASan/UBSan refresh — `019ffa4c-8734-7ac2-99d1-f67a0682be31` | Read-only focused matrix at source `09dd182`, including field-cleanup fixture and portable/Apple contracts | `/Users/jk/.codex/worktrees/b872/acgc-modern-port` (retired); build/log root `/private/tmp/acgc-lane-sanitizer-refresh-20260812` (retired) | Complete/archived; Luna Max/max; native 36/3/0 and ASan 36/3/0; UBSan 35/3/1 with the unchanged 11-site `aflags_c` issue; no frame, input, audio, save, simulator, device, or playability claim |
| 50 | Complete game-owned graph capture contract — `019ffa71-2a81-7821-b333-7072a7cfb941` | `include/acgc/graph_submission.h`, `src/graph_submission.c`, `src/graph.c`, focused capture tests; complete-list/terminator gate | `/private/tmp/acgc-lane-complete-graph-capture/source` (retired); `c1/lane-complete-graph-capture` preserved at `1d1cd8f`; build roots retired after review | Complete/integrated at source `6e4aded` (current tip `9cf9b3f`); native and ASan/UBSan focused tests pass; observed live prefix is `PREFIX_ONLY`, so no draw/frame claim |
| 51 | Game GX-to-Metal handoff seam — `019ffa71-2a81-7821-b333-70541a9193f4` | `pc/src/pc_gx.c`, `pc/apple/src/metal_packet_consumer.c`, focused Apple/PC tests; fail-closed optional Metal handoff | `/private/tmp/acgc-lane-gx-metal-handoff/source` (retired); `c1/lane-gx-metal-handoff` preserved at `26bcc02`; build roots retired after review | Complete/integrated at source `e22cbc5` plus `9cf9b3f`; native and ASan/UBSan handoff pass, Apple CPU contracts pass, Metal device checks skip `77`; no live encode/present/pixel claim |
| 52 | Full game save-manager restart gate — `019ffa71-2b0b-7170-9364-d468ea35c57b` | `pc/src/pc_m_card.c` plus focused mCD_SaveHome_bg request/restart tests; connect production slot recovery to game-owned orchestration | `/private/tmp/acgc-lane-full-save-manager/source` (retired); `c1/lane-full-save-manager` preserved at `0465f54`; build root retired | Complete/integrated at source `a7b9dff`; native and ASan/UBSan restart/recovery PASS; proves one game-owned request seam, not full CARD state/device/playability |
| 53 | Post-link graph runtime trace → exact-tip runtime successor — `019ffa9b-2ac8-7332-ab68-8ba731696cd8` | One serialized full `ac_pc` link and bounded arm64 launch/LLDB trace at current `02a003e`; no source edits | Canonical source only; build `/private/tmp/acgc-lane-exact-tip-runtime-build`; logs `/private/tmp/acgc-lane-exact-tip-runtime-logs`; no branch | Complete/archived after review; boot and game-owned graph path reached, root classified `INDIRECT` (`8/256`), no target resolution or frame claim; evidence `docs/evidence/POST-LINK-GRAPH-RUNTIME-02A003E-2026-08-13.md` |
| 54 | Live GX-to-Metal callback wiring — `019ffa9b-2ac8-7332-ab68-8b8a6a71bda9` | `pc/src/pc_gx.c`, Apple packet-consumer header/source, focused callback tests; optional handoff reachability | `/private/tmp/acgc-lane-live-gx-metal/source` (retire after review); `c1/lane-live-gx-metal` preserved at `1dec37f`; focused roots listed in evidence | Complete/integrated at source `ac39d04`; native and ASan/UBSan CPU contracts pass, device tests skip `77`; no live game encode/present/pixel claim |
| 55 | Save_t raw-wire losslessness — `019ffa9b-2dde-7d83-9b26-55dc271cac37` | `pc/src/pc_save_bswap.c` plus focused wire fixtures; preserve exact GCI semantics or stop test-only | `/private/tmp/acgc-lane-save-wire-lossless/source` (retire after review); `c1/lane-save-wire-lossless` preserved at `315f040`; build `/private/tmp/acgc-lane-save-wire-lossless-build` | Complete/integrated at source `d0e64f5`; test-only forensic coverage proves pre-fix `0xF10E→0x0000` and current native/ASan/UBSan roundtrip PASS; no full game persistence claim |
| 56 | Running-game input trace — `019ffa9b-2ea7-7741-87eb-9fd0c3e88557` | Read-only current-tip SDL/PADRead snapshot observation with one bounded OS-event attempt | `/Users/jk/.codex/worktrees/f19d/acgc-modern-port` (archive); logs `/private/tmp/acgc-lane-runtime-input` (retire after evidence); no source branch | Complete/parked; live SDL/PADRead boundary observed, OS event unavailable and no state transition; no running-game input claim |
| 57 | Current Windows regression audit — `019ffa9b-34a6-7813-a48c-2e8c43dcccdc` | Read-only `_WIN32`/x86/OpenGL/SDL audit for graph/GX changes at `9cf9b3f` | `/Users/jk/.codex/worktrees/18c7/acgc-modern-port` (archive); logs `/private/tmp/acgc-lane-windows-current` (retire after evidence); no source branch | Complete/parked; C/syntax probes pass with no regression, real i686 Windows targets blocked by missing sysroot/MinGW; no Windows sign-off |
| 58 | Activate graph capture runtime hook — `019ffaad-ca28-7c62-bd0f-018d6d82d6d3` | Read-only bounded runtime with exact graph-capture switch; distinguish disabled hook from incomplete live prefix | `/Users/jk/.codex/worktrees/41ac/acgc-modern-port` (retire after review); logs `/private/tmp/acgc-lane-graph-capture-activation`; no source branch | Complete/parked; `ACGC_GRAPH_CAPTURE=1` enabled the hook and emitted one cleanly terminated `8/256` prefix; no resolved indirect target, complete packet, or frame claim |
| 59 | GBI indirect target audit → graph-target source/test successor — `019ffaad-ca28-7c62-bd0f-0176ceb55e52` | Source/test owner for live F-handle resolution, target-capacity traversal, and exact terminator proof; prior audit remains in evidence | `/private/tmp/acgc-lane-graph-indirect-target/source` (retire after review); branch `c1/lane-graph-indirect-target` preserved at `e501d4b`; integrated PC `71a7012`; build roots `/private/tmp/acgc-integrate-graph-target-71a7012-native` and `-asan` | Complete/integrated; focused native and ASan/UBSan tests pass `3/3` each; no live complete-list or frame claim |
| 60 | Game-owned save caller audit → runtime save/restart successor — `019ffaad-cd2e-7ec3-8848-f0d409c6969c` | Source/test owner for restart caller → GCI marker → fresh-process reload gate; prior audit remains in evidence | `/private/tmp/acgc-lane-game-save-runtime/source` (retire after review); branch `c1/lane-game-save-runtime` preserved at `fcc3e7d`; integrated PC `02a003e`; build `/private/tmp/acgc-integrate-save-runtime-02a003e`; no umbrella edits | Complete/integrated; production caller-driven native and combined ASan/UBSan fixture PASS; no full device/playability claim |
| 61 | Sanitizer refresh ac39d04 — `019ffaad-cd4e-75d1-9e66-fdba9881de79` | Focused native + ASan/UBSan callback/save/graph matrix; unique build roots | `/Users/jk/.codex/worktrees/4ce5/acgc-modern-port` (retire after review); builds `/private/tmp/acgc-lane-sanitizer-ac39d04-native` and `/private/tmp/acgc-lane-sanitizer-ac39d04-asan`; no source branch | Complete/parked; 3 passes + 2 declared Metal-device skips per matrix, 0 failures; no sanitizer diagnostics or runtime-gate claim |
| 62 | Live indirect graph target resolver — `019ffae5-a0c2-7140-b30a-2c33c2eeba89` | `src/static/libforest/emu64/emu64.c` `dl_G_DL` observer plus focused target-capture fixture; explicit capacity/terminator and stale-handle gate | `/private/tmp/acgc-lane-live-target-resolver/source` / `c1/lane-live-target-resolver`; builds `/private/tmp/acgc-lane-live-target-resolver-build` and logs `/private/tmp/acgc-lane-live-target-resolver-logs` (retire after review) | Complete/integrated at source `aea3515`; native and ASan/UBSan focused CTest `3/3` each; live fixture resolves `F0002000` to 1024-word `new0`, terminator index 10, stale-handle fail-closed; no game launch/frame claim; evidence `docs/evidence/LIVE-GRAPH-TARGET-RESOLVER-2026-08-13.md` |
| 63 | Current-tip live target runtime trace — `019ffafc-8480-7ba0-a1a7-497f9db415ef` | One serialized full `ac_pc` link and bounded arm64 LLDB launch at PC `aea3515`; target capture/terminator/termination evidence only | Canonical source only; build `/private/tmp/acgc-lane-current-target-runtime-build`; logs `/private/tmp/acgc-lane-current-target-runtime-logs`; no source branch | Complete/archived; `4,013/4,013` link passed, but launch ran from the delegated worktree and exited before graph boot on missing relative shaders; no retry, target/frame/pixel/playability claim; evidence `docs/evidence/CURRENT-TIP-LIVE-TARGET-RUNTIME-2026-08-13.md` |
| 64 | Correctly rooted current-tip runtime successor — `019ffb13-9e1b-7441-ade3-04b6cbfd9508` | One serialized current-tip arm64 build-or-reuse check and exactly one LLDB launch from generated `bin` so relative shaders resolve; target/terminator/termination evidence only | Canonical source only; build `/private/tmp/acgc-lane-correct-rooted-runtime-build`; logs `/private/tmp/acgc-lane-correct-rooted-runtime-logs`; no source branch | Complete/archived; `4,013/4,013` link passed, but LLDB rejected unsupported `target.process.working-dir` before `run`; no inferior, no graph/target/frame/pixel/playability claim; evidence `docs/evidence/CORRECT-ROOTED-RUNTIME-2026-08-13.md` |
| 65 | Valid-LLDB current-tip runtime successor — `019ffb25-df74-7811-88ef-ed54f688841f` | One serialized current-tip arm64 build-or-reuse check and exactly one LLDB launch using independently verified `target.launch-working-dir`; target/terminator/termination evidence only | Canonical source only; build `/private/tmp/acgc-lane-valid-lldb-runtime-build`; logs `/private/tmp/acgc-lane-valid-lldb-runtime-logs`; no source branch | Complete/archived; `4,013/4,013` link passed; live `F0002000` target call (`capacity=1024`) and GX/PC boundaries reached, but no `DF000000,00000000` terminator appeared and TERM ended the run; no complete frame/pixel/playability claim; evidence `docs/evidence/VALID-LLDB-LIVE-TARGET-RUNTIME-2026-08-13.md` |
| 66 | Live target terminator forensic — `019ffb3a-b7e3-73e1-80e5-0891c749daba` | Read-only crosswalk of live `F0002000` pointer/capacity versus `sys_dynamic.new0` fixture span; optional focused probe only, no full link/launch | Canonical source audit; worktree `/Users/jk/.codex/worktrees/431d/acgc-modern-port`; focused root `/private/tmp/acgc-lane-live-target-terminator-forensic`; owns `emu64.c`, `graph.c`, `graph_submission.c`, and graph-target fixtures only | Complete/archived; live capacity `1024` proves `new0[0]`; `new0` is a continuation arena whose local bytes branch to `F0002001`, while the fixture’s terminator is synthetic; live target callback is unset; focused native/ASan/UBSan reruns pass; evidence `docs/evidence/LIVE-TARGET-TERMINATOR-FORENSIC-2026-08-13.md` |
| 67 | Opt-in live target observer — `019ffb49-326e-78e2-8ec8-eb0cadb94fbe` | Source/test owner for installing the existing target-capture callback under `ACGC_GRAPH_CAPTURE=1`, with off-by-default coverage; no full link/launch | Isolated worktree `/Users/jk/.codex/worktrees/cd32/acgc-modern-port/upstream/ACGC-PC-Port` (retire after review); branch `c1/lane-live-target-observer` at `f25d717`; integrated PC `36910c8`; focused root `/private/tmp/acgc-integrate-live-target-observer` | Complete/archived; only `pc/src/pc_main.c` changed; host object compile and existing live-target fixture pass native and combined ASan/UBSan `1/1` each; no full link, live target record, complete-list, Metal, pixel, input, audio, save/load, device, or playability claim; evidence `docs/evidence/LIVE-TARGET-OBSERVER-2026-08-13.md` |
| 68 | Live target observer runtime trace — `019ffb59-b04f-7322-a8ca-0a46c67321a0` | One serialized arm64 `ac_pc` link and exactly one LLDB launch at integrated PC `36910c8`; seek game-owned `[GRAPH_TARGET_CAPTURE]` and `F0002001` continuation evidence only | Isolated worktree `/Users/jk/.codex/worktrees/0378/acgc-modern-port`; detached source worktree at integrated `36910c8`; build `/private/tmp/acgc-lane-live-target-observer-runtime-build`; logs `/private/tmp/acgc-lane-live-target-observer-runtime-logs`; no source edits | Complete/archived; configure/build exit `0`, terminal `[4012/4013]` progress caveat; fresh target record `F0002000`, capacity `1024`, `INDIRECT`, no local terminator, words contain `F0002001`; LOGO/NEOS reached, TERM/grace no KILL; GX unobserved; no full-list/Metal/pixel/input/audio/save/device/playability claim; evidence `docs/evidence/LIVE-TARGET-OBSERVER-RUNTIME-2026-08-13.md` |
| 69 | Live GX boundary runtime trace — `019ffb68-3324-7a80-a69d-fc9359687355` | One read-only LLDB launch with pre-run breakpoints at GXBegin and pc_gx_flush_vertices, retaining the target observer record; no source edits | Isolated worktree `/Users/jk/.codex/worktrees/8197/acgc-modern-port` (retire); source `/private/tmp/acgc-lane-live-gx-boundary-runtime-source` (retire); build `/private/tmp/acgc-lane-live-gx-boundary-runtime-build` (retire); logs `/private/tmp/acgc-lane-live-gx-boundary-runtime-logs` (retire); no source branch | Complete/archived; build exit 0 with terminal `[4012/4013]`, LLDB setup accepted both symbols but launch failed before an inferior with `status -1` plus unprivileged `nice(5)`; no boot, breakpoint, GX, Metal, pixel, or playability claim; evidence `docs/evidence/LIVE-GX-BOUNDARY-RUNTIME-2026-08-13.md` |
| 70 | Metal bridge architecture audit — `019ffb8b-728b-7c93-9d3a-fc9222eb26fe` | Read-only crosswalk from game-owned `pc_gx_flush_vertices` to existing Apple semantic packet/Metal consumer; no source edits, builds, or launches | Worktree `/Users/jk/.codex/worktrees/4513/acgc-modern-port` already absent; no build/log root | Complete/archived; proves the registration/build gap, resident-texture gate issue, and CPU-only consumer boundary; no frame or playability claim |
| 71 | Darwin GX handoff registration — `019ffb94-738f-70c3-9344-a194b74022af` | Apple-only `AcgcMetalPacketConsumerHandoffContext` registration, narrow resident-versus-active texture gate correction in `pc_gx.c`, bounded callback/status telemetry, and focused fixture; no shader, decomp, or Windows changes | Worker worktree absent after cleanup; source branch `c1/lane-darwin-gx-registration` at `9174404b`; integrated canonical source `54b840c`; focused roots retired | Complete/integrated; native and ASan/UBSan focused CTest `1/1` each; no full link, live callback, Metal encode/present/pixel, or playability claim |
| 72 | Live Apple GX callback observation — `019ffba9-3c9b-7713-82a4-ae102ad4715b` | Read-only current-tip full link plus exactly one no-`nice` LLDB launch; breakpoint on `pc_metal_runtime_observe` and `pc_gx_flush_vertices`; no source edits | Worktree `/Users/jk/.codex/worktrees/a240/acgc-modern-port` already absent; build/log roots retired after review | Complete/archived; link `0`, arm64 Mach-O, LLDB pre-inferior `nice(5)` failure with zero breakpoint hits; callback reachability inconclusive; no Metal encode/present/pixel/playability claim; evidence `docs/evidence/LIVE-DARWIN-GX-CALLBACK-RUNTIME-2026-08-13.md` |
| 73 | Current Apple GX callback hit capture — `019ffbc7-01e9-7b32-b5b1-f0abaada1b09` | Read-only current-tip full link and exactly one generated-bin LLDB launch with one-shot explicit hit logging for `pc_metal_runtime_observe`, GXBegin, flush, target, and graph symbols | Worktree `/Users/jk/.codex/worktrees/7842/acgc-modern-port` (retired); build/log roots retired; no source branch | Complete/archived; both launch attempts stopped before runtime, zero explicit hits; evidence `docs/evidence/LIVE-APPLE-GX-CALLBACK-2026-08-13.md`; no callback/frame/Metal claim |
| 74 | Offscreen Metal packet sink — `019ffbc8-1f2b-7513-9c1c-7ddde5114f97` | Source-edit lane for an Apple-only offscreen MTLDevice/command-buffer/readback consumer of the existing semantic packet; focused CPU/device-gated tests only | Worktree `/Users/jk/.codex/worktrees/002a/acgc-modern-port` (retire); owning PC branch `c1/lane-offscreen-metal-sink` at `d7facdd`; integrated canonical source `54b840c`; focused roots `/private/tmp/acgc-integrate-metal-sink-54b840c` and `...-apple` | Complete/integrated; worker CPU contract and integrated handoff CTest pass, device sink skip `77`; no live callback, game-owned encode/readback, pixel, or playability claim; evidence `docs/evidence/OFFSCREEN-METAL-SINK-2026-08-13.md` |
| 75 | Input snapshot boundary — `019ffbcc-904f-7673-bc6a-1b137c550997` | Read-only crosswalk and focused probe for SDL/keyboard/controller to a stable game-owned PAD snapshot; no source edits or full link | Worktree `/Users/jk/.codex/worktrees/3f1d/acgc-modern-port` (retire); focused root `/private/tmp/acgc-lane-input-boundary` (retire); no branch | Complete/archived; per-frame guard and virtual-controller stability pass, synthetic keyboard remains inconclusive; evidence `docs/evidence/INPUT-SNAPSHOT-BOUNDARY-2026-08-13.md`; no human-input/playability claim |
| 76 | Mixer/CoreAudio boundary — `019ffbcc-904f-7673-bc6a-1b309e9dd560` | Read-only native + ASan/UBSan mixer/bank probes and smallest CoreAudio/device gate; no source edits or full link | Worktree `/Users/jk/.codex/worktrees/7d30/acgc-modern-port` (retire); roots `/private/tmp/acgc-lane-audio-proof` and `...-asan` (retire); no branch | Complete/archived; software mixer/NEOS/DMA and direct callback pass, CoreAudio/device skip `77`; evidence `docs/evidence/MIXER-COREAUDIO-BOUNDARY-2026-08-13.md`; no audible-output claim |
| 77 | Save_t restart gate — `019ffbcc-9406-7a23-9847-2f19196bdad0` | Read-only focused codec, atomic recovery, production caller, and fresh-process reload verification; no source edits or full link | Worktree `/Users/jk/.codex/worktrees/7419/acgc-modern-port` (retire); roots `/private/tmp/acgc-lane-save-proof` and `...-asan` (retire); no branch | Complete/archived; codec, atomic/corruption recovery, and game-owned restart/reload fixture pass native + ASan/UBSan; physical CARD/device/new-game/playability remain open; evidence `docs/evidence/SAVE-T-RESTART-GATE-2026-08-13.md` |
| 78 | Timing/lifecycle/shutdown audit — `019ffbcc-9477-7333-9214-73b6f08f344b` | Read-only focused retrace/thread/TERM/KILL audit; no source edits, ISO access, or full link | Worktree `/Users/jk/.codex/worktrees/e1e5/acgc-modern-port` (retire); root `/private/tmp/acgc-lane-lifecycle-proof` (retire); no branch | Complete/archived; synthetic contract and isolated audio worker pass, integrated thread/reset teardown remains open; evidence `docs/evidence/LIFECYCLE-SHUTDOWN-AUDIT-2026-08-13.md`; no playability claim |
| 79 | Windows compatibility audit — `019ffbd0-b850-74b0-a0fd-cedcbd90db47` | Read-only `_WIN32`/x86/OpenGL/SDL regression audit against current Apple changes; no source edits, ISO access, or full link | Worktree `/Users/jk/.codex/worktrees/628f/acgc-modern-port` (retire after review); focused root `/private/tmp/acgc-lane-windows-audit` (retire after review); no branch | Complete/archived; portable 20/20 and host `-m32 -D_WIN32` probes pass; real i686 MinGW/sysroot remains unavailable; evidence `docs/evidence/WINDOWS-X86-AUDIT-2026-08-13.md`; no Windows sign-off |
| 80 | Native + ASan/UBSan verification matrix — `019ffbd0-ba29-78e2-aad5-93f34b8bdf73` | Read-only focused sanitizer matrix for graph/GX/Save_t/cleanup/audio/portable/Apple packet contracts; no source edits, ISO access, or full link | Worktree `/Users/jk/.codex/worktrees/ea1e/acgc-modern-port` (retire after review); roots `/private/tmp/acgc-lane-sanitizer-matrix-native` and `/private/tmp/acgc-lane-sanitizer-matrix-asan` (retire after review); no branch | Complete/archived; pinned to `f4cb491`, not current-tip; 10/12 portable sanitizer tests pass, two share the pre-existing `aflags_c` UBSan issue; evidence `docs/evidence/SANITIZER-MATRIX-F4CB491-2026-08-13.md`; no launch/frame claim |
| 81 | iOS shared-boundary readiness audit — `019ffbd0-bc94-7ff1-baf1-e5689164d53a` | Read-only audit of portable/core, Apple bridge, lifecycle, and existing iOS evidence; iOS source remains gated until macOS shared core/renderer proof | Worktree `/Users/jk/.codex/worktrees/b820/acgc-modern-port` (retire after review); focused root `/private/tmp/acgc-lane-ios-readiness` (retire after review); no branch | Complete/archived; portable CTest 20/20; no iOS target, simulator, device, game-owned Metal frame, input, audio, save, lifecycle, or playability claim; evidence `docs/evidence/IOS-SHARED-BOUNDARY-READINESS-2026-08-13.md` |
| 82 | Direct Apple callback hit capture successor — `019ffbd5-53a3-7371-b1a6-19859c9bbf35` | Read-only direct LLDB launch using explicit hit counters; non-duplicate follow-up to lane 73's stop-at-entry failure | Worktree `/Users/jk/.codex/worktrees/a688/acgc-modern-port` (retire); build/log roots retired; no source branch | Complete/archived at pre-sink PC `f4cb491`; graph/target/GX each hit once, Apple callback hit `0`; evidence `docs/evidence/DIRECT-APPLE-GX-CALLBACK-2026-08-13.md`; no Metal/pixel claim |
| 83 | Game-owned input frame-guard fixture — `019ffbda-8005-7b93-83cf-67549d968677` | Source/test successor for `padmgr_RequestPadData()` once-per-frame state preservation; owns `pc/tests/pc_padmgr_frame_guard_fixture.c` and narrow CMake registration only | Source worktree `/private/tmp/acgc-lane-input-frame-guard/source` (retire after review); branch `c1/input-frame-guard` at `799a016`; integrated canonical PC `59aa655`; focused roots `/private/tmp/acgc-integrate-input-frame-guard-59aa655-native` and `...-asan` | Complete/integrated; native and ASan/UBSan CTest `1/1` each with no diagnostics; no physical input/playability claim; evidence `docs/evidence/INPUT-FRAME-GUARD-2026-08-13.md` |
| 84 | Current integrated Metal callback capture — `019ffbe2-0d6d-74a0-9750-7f5e1e8b4d2e` | Read-only current-tip `59aa655` full link and exactly one direct LLDB launch; capture game-owned callback/sink status separately from GX/OpenGL | Worktree `/Users/jk/.codex/worktrees/73d6/acgc-modern-port` (retire after review); build `/private/tmp/acgc-lane-current-sink-callback-build`; logs `/private/tmp/acgc-lane-current-sink-callback-logs`; no source branch | Complete/archived; graph target and `GXBegin` each hit once, `pc_gx_flush_vertices` and `pc_metal_runtime_observe` hit zero; sink shader compile failed before encode/readback; evidence `docs/evidence/CURRENT-INTEGRATED-METAL-CALLBACK-2026-08-13.md`; no Metal/pixel/playability claim |
| 85 | Metal sink shader compile fix — `019ffbf9-eee6-7e12-bc8c-5b6f68c58c5f` | Source-edit lane owning only `pc/apple/src/metal_sink.m` and narrowly necessary sink regression coverage; reproduce/fix the MSL reserved-identifier failure without a full link | Source worktree `/private/tmp/acgc-lane-metal-sink-shader-fix-source` (retire after review); branch `c1/lane-metal-sink-shader-fix` at `5db1d28`; integrated canonical PC `a8f3a8f`; roots `/private/tmp/acgc-lane-metal-sink-shader-fix` and `...-asan` (retire after review) | Complete/integrated; pre-fix parser failure reproduced, post-fix offline MSL produces AIR, focused sink CTest/device gate passes with skip `77`; evidence `docs/evidence/METAL-SINK-SHADER-FIX-2026-08-13.md`; no live callback/pixel/playability claim |
| 86 | Current Metal sink runtime after shader fix — `019ffc03-b830-70f2-bce2-6cc32a436c29` | Read-only current-tip `a8f3a8f` full link and exactly one bounded direct LLDB launch; capture callback/encode/readback separately from GX/OpenGL | Worktree `/Users/jk/.codex/worktrees/cf4f/acgc-modern-port` (retire after review); build `/private/tmp/acgc-lane-current-sink-runtime-a8f3a8f`; logs `/private/tmp/acgc-lane-current-sink-runtime-a8f3a8f-logs`; no source branch | Complete/archived; graph target, `GXBegin`, and `pc_gx_flush_vertices` each hit once; `pc_metal_runtime_observe` hit zero; no Metal encode/readback/pixel/playability claim; evidence `docs/evidence/CURRENT-METAL-SINK-RUNTIME-A8F3A8F-2026-08-13.md` |
| 87 | GX observer rejection-path audit — `019ffc19-bff8-77a3-8c05-9e57d2a04bc2` | Source/test lane for `pc/src/pc_gx.c` observer invocation and semantic rejection reason; focused fixture/CMake only if a narrow bug is proven | Source worktree `/private/tmp/acgc-lane-gx-observer-rejection` (retire after review); branch `c1/lane-gx-observer-rejection` at `a8f3a8f`; roots `/private/tmp/acgc-lane-gx-observer-rejection-build` and `...-asan` (retire after review); no source commit | Complete/archived; no edit warranted; native and ASan/UBSan focused CTest `1/1` each; callback registration healthy, live zero explained by fail-closed semantic rejection; evidence `docs/evidence/GX-OBSERVER-REJECTION-AUDIT-2026-08-13.md`; no live callback/Metal/pixel/playability claim |
| 88 | GX v2 packet contract map — `019ffc28-3c56-70a2-a0d7-60b8e16dfda2` | Read-only two-upstream crosswalk for the smallest fixed-width TEV/texture/channel extension beyond v1; focused existing tests only, no production edits or live launch | Worktree `/Users/jk/.codex/worktrees/24b3/acgc-modern-port` (retire after review); scratch `/private/tmp/acgc-lane-gx-v2-contract` (retire after review); no source branch | Complete/archived; no edit or live launch; maps channel/texture-generator/two-stage-TEV state needed for a deliberate packet extension; evidence `docs/evidence/GX-V2-PACKET-CONTRACT-MAP-2026-08-13.md`; no live callback/Metal/pixel/playability claim |
| 89 | Implement bounded GX v2 packet — `019ffc34-ab7a-74d0-839e-65cd045a2b01` | Source lane for versioned fixed-width channel/texture-generator/two-stage-TEV packet state and narrow `pc_gx` construction; owns only packet headers/source, `pc_gx.c`, focused tests/CMake | Worktree and focused roots retired by cleanup; branch `c1/lane-gx-v2-packet` at `06fa74c`; integrated canonical PC `26da235`; umbrella evidence preserved | Complete/integrated; native and ASan/UBSan focused CTest `3/3` each; v2 remains fixture-only until a version-aware consumer exists; no live callback, Metal encode/readback/pixel, device, input/audio/save, or playability claim; evidence `docs/evidence/GX-V2-PACKET-IMPLEMENTATION-2026-08-13.md` |
| 90 | Version-aware GX v2 consumer boundary — `019ffc5d-392e-75e2-a863-a4b9199b11dd` | Source lane for a separately typed/version-checked v2 callback and Apple consumer boundary; preserve v1 dispatch, consume bounded values only, and prove v2 acceptance/rejection with focused tests | Worktree and exact focused roots retired by cleanup; branch `c1/lane-versioned-gx-v2-consumer` at worker `cd881b7`; integrated canonical PC `d1e812c`; umbrella evidence preserved | Complete/integrated; native and ASan/UBSan focused CTest `4/4` each with no diagnostics; v2 reports `V2_EXTENSION_NOT_RENDERED`; no full link, live callback, Metal encode/readback/pixel, device, input/audio/save, or playability claim; evidence `docs/evidence/GX-V2-CONSUMER-BOUNDARY-2026-08-13.md` |
| 91 | Live GX v2 callback reachability trace — `019ffc73-d5c6-78f1-94bb-91ad0d277d1d` | Read-only one-link/one-LLDB current-tip trace at canonical PC `d1e812c`; measure `pc_gx_flush_vertices` → v2 callback reachability and keep callback, Metal, pixel, and playability claims separate | Worktree and exact build/log roots retired after review; canonical source `c1/macos-host-launch` at `d1e812c`; evidence `docs/evidence/LIVE-GX-V2-CALLBACK-REACHABILITY-2026-08-13.md`; no source branch or edits | Complete/archived; link passed `4019/4019`, but LLDB failed before boot with `status -1 (no such process)` and every requested breakpoint hit `0`; no callback, frame, Metal encode/readback/pixel, device, input/audio/save, or playability claim |
| 92 | Elevated GX v2 callback launch retry — `019ffc83-96c2-7ce1-97d9-848fb308a41d` | Read-only one permitted elevated LLDB launch against canonical PC `d1e812c`; resolve the lane-91 pre-inferior status `-1` blocker and capture explicit v2 callback hit counts only if an inferior exists | Worktree and exact build/log roots retired after review; canonical source `c1/macos-host-launch` at `d1e812c`; evidence `docs/evidence/ELEVATED-GX-V2-LAUNCH-2026-08-13.md`; no source branch or edits | Complete/archived; elevated launch created an inferior and reached boot/runtime; outer interrupt preceded per-symbol breakpoint list, so counts are not emitted and no callback/GX/frame/Metal/pixel/playability claim follows; exact-PID TERM `rc=0`, KILL not needed |
| 93 | Durable GX v2 breakpoint-count trace — `019ffc93-5d85-7d53-a6bf-67a5b13305da` | Read-only one elevated LLDB trace at canonical PC `d1e812c`; persist per-symbol graph/GX/v2/Apple breakpoint counts while keeping the debugger alive through bounded inferior cleanup | Worktree and exact build/log roots retired after review; canonical source `c1/macos-host-launch` at `d1e812c`; evidence `docs/evidence/DURABLE-GX-V2-BREAKPOINT-COUNTS-2026-08-13.md`; no source branch or edits | Complete/archived; `graph_task_set00=1`, all downstream counts `0` only because the temporary Python callback omitted an explicit return and stopped at the prefix; no downstream callback/GX/frame/Metal/pixel/playability claim; exact inferior SIGKILL status `9`, wrapper `0` |
| 94 | Correct GX v2 trace callback control — `019ffca1-c92a-7363-9687-a503d2f2851d` | Read-only one elevated LLDB trace from canonical PC `d1e812c`; correct the temporary Python breakpoint callbacks to explicitly return `False`, preserve durable hit lines, and capture downstream graph/GX/v2/Apple counts | Worktree and exact build/log roots retired after review; canonical source `c1/macos-host-launch` at `d1e812c`; evidence `docs/evidence/CORRECTED-GX-V2-CALLBACK-TRACE-2026-08-13.md`; no source branch or edits | Complete/archived; `graph_task_set00=1`, `emu64_taskstart=1`, and GX/v2/Apple counts `0`; sentinel stopped after the graph task; no GX callback, frame, Metal, pixel, device, input/audio/save, or playability claim |
| 95 | Audit graph task to GX submission gap — `019ffcb0-760c-7b43-a690-f190dd5352f7` | Read-only two-upstream crosswalk for `graph_task_set00` → `emu64_taskstart` → `GXBegin`/`pc_gx_flush_vertices`; explain lane-94’s bounded zero GX counts and identify the smallest next gate | Worktree `/Users/jk/.codex/worktrees/680c/acgc-modern-port` (retire after review); canonical source `c1/macos-host-launch` at `d1e812c`; no build/log roots, ISO, launch, or source branch | Complete/archived; no queue is indicated by source; command/continuation condition remains open; evidence `docs/evidence/GRAPH-TASK-TO-GX-GAP-2026-08-13.md`; no source, launch, Metal encode/readback/pixel, device, input/audio/save, or playability claim |
| 96 | Trace emu64 continuation to GX draw — `019ffcc1-d77b-7a42-b0ec-54ac72f1a30e` | Read-only one-link/one-LLDB current-tip trace; instrument `emu64_taskstart_r`, command dispatch, `dl_G_DL`, `dl_G_ENDDL`, and `GXBegin` to classify the zero-GX boundary | Worktree `/Users/jk/.codex/worktrees/9474/acgc-modern-port` and roots `/private/tmp/acgc-lane-emu64-continuation-trace-build` / `/private/tmp/acgc-lane-emu64-continuation-trace-logs` (retire after review); canonical source `c1/macos-host-launch` at `d1e812c`; no source branch | Complete/archived; link `[4018/4019]` passed; first task had 8 `G_DL_NOPUSH`, 1 `G_ENDDL`, return `0`, `GXBegin=0`, `FrameCansel=0`, `err_count=0`; pointer-field diagnostics excluded; evidence `docs/evidence/EMU64-CONTINUATION-NO-DRAW-2026-08-13.md`; no Metal encode/readback/pixel, input/audio/save, device, or playability claim |
| 97 | Trace subsequent graph task progression — `019ffcd6-49fb-7f20-abb7-967008d7fe17` | Read-only one-link/one-LLDB current-tip trace for later `graph_task_set00`/`graph_draw_finish`/`graph_submit_task` activity after the lane-96 clean no-draw task; classify any later GXBegin reachability | Worktree `/Users/jk/.codex/worktrees/7008/acgc-modern-port` and roots `/private/tmp/acgc-lane-subsequent-graph-task-build` / `/private/tmp/acgc-lane-subsequent-graph-task-logs` (retire after review); canonical source `c1/macos-host-launch` at `d1e812c`; no source branch | Complete/archived; link `[4018/4019]` passed; graph submission/task entry each hit twice; task 2 reached 8 dispatches and a `G_DL` prefix but timed out before `G_ENDDL`/return; draw handlers and `GXBegin` 0; evidence `docs/evidence/SUBSEQUENT-GRAPH-TASK-PROGRESSION-2026-08-13.md`; no Metal encode/readback/pixel, input/audio/save, device, or playability claim |
| 98 | Complete second graph task continuation — `019ffcea-aceb-7f10-8aba-7fc61a98896d` | Read-only one-link/one-LLDB current-tip trace with a 30-second bound; extend task-2 `F0004000` continuation to `G_ENDDL` or a draw/GXBegin boundary | Lane worktree already absent; run snapshot `5b89680`; build/log roots retired by the cleanup lane; no source branch | Complete/archived; task 2 reached `F0004000`–`F0004007`, `G_ENDDL`, and return `0` with `cmds=12`, `end_dl=1`; draw handlers, `GXBegin`, and flush were `0` for task 2; later-task hits excluded; evidence `docs/evidence/SECOND-GRAPH-TASK-COMPLETION-2026-08-13.md`; no Metal encode/readback/pixel, input/audio/save, device, or playability claim |
| 99 | Current Metal-frame bridge audit/implementation — `019ffd05-6144-77a0-8a55-f1bb4092654d` | Bounded crosswalk for why live textured/TEV state is rejected before `pc_metal_runtime_observe`; source edit only if a concrete defect is proven | Worktree retired with the task; base umbrella `05c7ce8`, PC `d1e812c`, decomp `09ca8e8b`; no build/runtime roots created | Complete/archived with infrastructure failure after setup; read-only finding only, no source/build/runtime/Metal/pixel claim; no defect proven |
| 100 | Metal packet rejection predicate audit — `019ffd08-10ff-77b1-8bc4-bd91a84902e9` | Test-only/read-only reproduction of fail-closed packet-builder behavior for textured/TEV/active state; native plus ASan/UBSan focused tests; no worker full link/LLDB; root continuation owns only opt-in diagnostic instrumentation | Worker task retired after remote compaction failure; diagnostic branch `c1/lane-metal-rejection-diagnostic` fast-forwarded into canonical `c1/macos-host-launch` at `8a19f23`; decomp `09ca8e8b`; exact roots `/private/tmp/acgc-metal-rejection-trace-build` and `/private/tmp/acgc-metal-rejection-trace-logs` | Complete/archived; focused native and ASan/UBSan v2 handoff tests `1/1` each; one elevated launch emitted 32 preflight + 32 fail records; live alpha-blend/TEXMTX0 state is outside current v2 contract; no callback/Metal/pixel/playability claim; evidence `docs/evidence/METAL-REJECTION-DIAGNOSTIC-8A19F23-2026-08-13.md` |
| 101 | Live blend/texture-matrix GX packet extension — `019ffd19-3a91-7ba2-b6db-c7535d5143ce` | Source-edit lane for the smallest versioned packet/Apple consumer extension covering the observed `GX_BM_BLEND` + `GX_TEXMTX0` state; preserve v1 and legacy OpenGL | Worktree `/Users/jk/.codex/worktrees/fb3c/acgc-modern-port` and source `/private/tmp/acgc-lane-gx-live-blend-texmatrix-source`; branch `c1/lane-gx-live-blend-texmatrix` returned clean to base `8a19f23`; decomp `09ca8e8b` | Rejected/archived after two remote compaction `404` failures; one uncommitted header-only draft was reverted; no source commit, build, test, full link, LLDB, callback, Metal, pixel, or playability result |
| 102 | Live blend/texture-matrix GX packet extension retry — `019ffd20-e35d-7121-84b0-1589246e8e3c` | Fresh source-edit retry for the smallest versioned packet/Apple consumer extension covering `GX_BM_BLEND`, source-alpha factors, raw `GX_LO_NOOP=5`, and `GX_TEXMTX0`; preserve v1/OpenGL | Worktree `/Users/jk/.codex/worktrees/7c0b/acgc-modern-port` and source `/private/tmp/acgc-lane-gx-live-blend-texmatrix-source`; branch `c1/lane-gx-live-blend-texmatrix` clean at `8a19f23`; decomp `09ca8e8b` | Rejected/archived after remote compaction `404` before source edit; no build, test, full link, LLDB, runtime, or claim |
| 103 | Root-owned GX v3 state handoff and current-tip runtime — root continuation | Integrated source extension for the observed blend/source-alpha/`GX_LO_NOOP`/`GX_TEXMTX0` state; preserve V1/OpenGL and keep V3 non-rendering; one serialized current-tip link and bounded callback-entry trace | Source branch `c1/lane-gx-v3-direct` at `141a746`; integrated canonical PC `042cbf7`; source and runtime roots retired/absent after review (`/private/tmp/acgc-lane-gx-v3-direct-source`, `/private/tmp/acgc-current-v3-runtime-build`, `/private/tmp/acgc-current-v3-runtime-logs`); native/ASan roots also retired; | Complete/integrated; combined V1/V2/V3 focused CTest `3/3` native and `3/3` ASan/UBSan with no diagnostics; current arm64 `ac_pc` link completed and elevated trace reached graph/GX/V3 builder entries (`549`), but V3 consumer and `pc_metal_runtime_observe` were `0`; V3 remains `V3_EXTENSION_NOT_RENDERED`; no successful callback, Metal encode/readback/pixel, or playability claim; evidence `docs/evidence/GX-V3-STATE-HANDOFF-042CBF7-2026-08-13.md` and `docs/evidence/GX-V3-CURRENT-TIP-RUNTIME-042CBF7-2026-08-13.md` |
| 104 | V3 fail-closed rejection reason — `019ffd46-3012-7460-b435-2afff25993c0` | Source-edit diagnostic for the exact predicate(s) rejecting live V3 state after builder entry; native plus ASan/UBSan focused checks only; no full link, LLDB, or Metal work | Source branch `c1/lane-gx-v3-rejection-reason` at `c689a731`; integrated canonical PC `c1/macos-host-launch` at `add2d6f`; lane roots `/private/tmp/acgc-lane-gx-v3-rejection/native` and `/private/tmp/acgc-lane-gx-v3-rejection-asan` retained for review; decomp `09ca8e8b`; visible task worktree `/Users/jk/.codex/worktrees/d3d7/acgc-modern-port` is stale detached and protected until cleanup | Complete/integrated; `g_gx.alpha_update_enable == 0` is the source-backed V3 fail-closed reason; opt-in `ACGC_METAL_V3_REJECTION_TRACE=1` Darwin diagnostic capped at 64 records; integrated native and ASan/UBSan focused CTest `3/3` each with no diagnostics (leak detection disabled); no fixture/CMake, full link, LLDB, callback, Metal encode/readback/pixel, input, audio, save, device, or playability claim; evidence `docs/evidence/GX-V3-REJECTION-ALPHA-UPDATE-ADD2D6F-2026-08-13.md` |
| 105 | V3 Apple consumer/runtime boundary audit — `019ffd51-9466-75e3-b9f9-c27b43bda87f` | Read-only crosswalk for why the typed V3 handoff does not reach the Apple consumer or runtime observer; no full link, LLDB, or device work | Audit source worktree `/private/tmp/acgc-lane-gx-v3-apple-consumer/pc` on `c1/lane-gx-v3-apple-consumer-audit` at `042cbf7`; exact focused roots `/private/tmp/acgc-lane-gx-v3-apple-consumer-native` and `/private/tmp/acgc-lane-gx-v3-apple-consumer-asan`; no source changes; decomp `09ca8e8b` | Complete/archived; native and ASan/UBSan V3 CPU fixture `1/1` each; consumer/runtime registration compiled but was not executed because it initializes the Metal sink; `549 → 0 → 0` localizes upstream of Apple consumer; no callback, Metal encode/readback/pixel, or playability claim; evidence `docs/evidence/GX-V3-APPLE-CONSUMER-AUDIT-2026-08-13.md` |
| 106 | Focused V3 builder-to-consumer fixture — `019ffd51-9466-75e3-b9f9-c29b09289e91` | Synthetic live-like V3 builder/typed-handoff fixture that distinguishes builder rejection from consumer acceptance/rejection and records the alpha-update/write-mask reason; no full link, LLDB, or device work | Source branch `c1/lane-gx-v3-consumer-fixture` at `51ef7e4`; integrated canonical PC `c1/macos-host-launch` at `f18e7cd`; exact integrated roots `/private/tmp/acgc-integrate-v3-consumer-f18e7cd-native` and `/private/tmp/acgc-integrate-v3-consumer-f18e7cd-asan`; worker roots `/private/tmp/acgc-lane-gx-v3-consumer-fixture-native` and `/private/tmp/acgc-lane-gx-v3-consumer-fixture-asan` retained for review; decomp `09ca8e8b` | Complete/integrated; native and ASan/UBSan focused CTest `2/2` each on the integrated snapshot; disabled alpha writes reject before V3 callback, enabled writes build/consume with `V3_EXTENSION_NOT_RENDERED`, malformed packet rejection and V1 seam remain separate; no live callback, Metal encode/readback/pixel, or playability claim; evidence `docs/evidence/GX-V3-BUILDER-CONSUMER-FIXTURE-F18E7CD-2026-08-13.md` |
| 107 | Integrated sanitizer and Windows compatibility matrix — `019ffd51-94de-78a3-b583-89cd9d008e40` | Verification-only native/ASan/UBSan and available `_WIN32`/host probes on current PC `f18e7cd`; record unavailable i686 MinGW/sysroot toolchains exactly; no source edits or full link | Canonical PC `c1/macos-host-launch` at `f18e7cd`; decomp `09ca8e8b`; lane roots and visible worktree retired by cleanup; exact stale source metadata `/Users/jk/Documents/Projects/acgc-modern-port/.git/modules/upstream/ACGC-PC-Port/worktrees/ACGC-PC-Port` remains due `Operation not permitted`; dirty failed clones `/private/tmp/acgc-lane-gx-v3-sanitizer-windows-failed-pc` and `...-failed-decomp` are preserved | Complete/archived; focused native CTest `7/7` and combined ASan/UBSan `7/7` with no diagnostics; packet/adapter and C/static-GBI `_WIN32`/ILP32 probes pass, C++ host macro caveat, `pc_gx.c` stops at missing `process.h`, real GNU/MSVC probes stop at missing `string.h`; no i686/PE/runtime/Metal/pixel/playability claim; evidence `docs/evidence/SANITIZER-WINDOWS-CURRENT-F18E7CD-2026-08-13.md` |
| 108 | Current-tip V3 rejection runtime trace — `019ffd6d-46b9-7aa1-97d9-9e66a19ef45c` | Read-only one serialized `ac_pc` link and one bounded LLDB launch at PC `f18e7cd`; enable `ACGC_METAL_V3_REJECTION_TRACE=1` and count graph/GX/V3 builder, Apple consumer, runtime observer, and alpha-update rejection records | Visible task worktree `/Users/jk/.codex/worktrees/1d58/acgc-modern-port`; canonical populated PC `/Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port` at `c1/macos-host-launch` `f18e7cd`; decomp `09ca8e8b`; unique roots `/private/tmp/acgc-lane-current-v3-rejection-runtime-build` and `/private/tmp/acgc-lane-current-v3-rejection-runtime-logs` retained for exact cleanup after review | Complete/archived; link `[4018/4019]` passed and the real inferior reached boot/graph/GX; counts were graph/emu64 `29`, GX/flush `532`, V2/V3 builder `531`, Apple consumer/observer `0`; diagnostic cap recorded `64/64` `alpha_update_disabled`; no callback, Metal encode/readback/pixel, input/audio/save/device, simulator, natural-shutdown, or playability claim; evidence `docs/evidence/CURRENT-V3-REJECTION-RUNTIME-F18E7CD-2026-08-13.md` |
| 109 | V3 alpha-state packet contract — `019ffd84-42ae-72b2-8be3-d3d18d29577c` | Source-edit lane for the smallest reference-faithful versioned packet/builder representation of live `alpha_update_enable == 0`; preserve existing V1/V2/V3 ABI and fail-closed behavior; focused CPU tests only | Visible task worktree `/Users/jk/.codex/worktrees/9941/acgc-modern-port` and source `/private/tmp/acgc-lane-gx-alpha-state/source` are absent after cleanup; branch `c1/lane-gx-alpha-state` remains at `6ef4df7`, based on `f18e7cd`; `/private/tmp/acgc-lane-gx-alpha-state-native`, `-asan`, and empty parent remain preserved because exact metadata removal returned `Operation not permitted` at `.git/modules/upstream/ACGC-PC-Port/worktrees/source`; integrated canonical PC `c1/macos-host-launch` at `4fc6f00`; no Apple consumer/runtime ownership | Complete/integrated/archived; V3 remains `4968` bytes and V4 is `4972` bytes with explicit alpha-write state; native and combined ASan/UBSan focused CTest `5/5` each with no diagnostics; no full link, LLDB, Apple consumer, live callback, Metal encode/readback/pixel, input/audio/save/device, or playability claim; evidence `docs/evidence/GX-V4-ALPHA-STATE-4FC6F00-2026-08-13.md`; stale metadata is preserved for approved owner cleanup only |
| 110 | V4 Apple consumer/validation seam — `019ffd9e-1fb9-7153-bf9b-2d7dea3f3eed` | Source-edit lane for the smallest typed V4 consumer/runtime validation seam; preserve V1/V2/V3 dispatch, OpenGL behavior, and fail-closed malformed/unsupported state; focused CPU tests only | Visible umbrella worktree `/Users/jk/.codex/worktrees/6756/acgc-modern-port` is detached at setup snapshot `3a4c0e2` (provenance only); worker branch `c1/lane-gx-v4-consumer` at `63b772e` based on `4fc6f00`; integrated canonical PC `c1/macos-host-launch` at `dbf6986`; decomp `09ca8e8b`; worker roots `/private/tmp/acgc-lane-gx-v4-consumer-native-4fc6f00` and `-asan-4fc6f00`, integrated roots `/private/tmp/acgc-integrate-v4-consumer-dbf6986-native` and `-asan` (retire after review); owns only `pc/apple/include/acgc/metal_packet_consumer.h`, `pc/apple/src/metal_packet_consumer.c`, `pc/apple/src/pc_metal_runtime.c`, `pc/tests/pc_gx_semantic_v4_consumer_fixture.c`, and minimal `pc/CMakeLists.txt` registration; no `pc_gx.c` or packet-builder ownership | Complete/integrated/archived; native and combined ASan/UBSan focused CTest `6/6` each with no diagnostics beyond known compiler warnings; V4 accepts explicit alpha-write `0/1`, marks V3/V4 state extensions `NOT_RENDERED`, and rejects malformed state; no full link, LLDB, device, live callback, Metal encode/readback, pixel, input/audio/save, or playability claim; evidence `docs/evidence/GX-V4-APPLE-CONSUMER-DBF6986-2026-08-13.md` |
| 111 | Current-tip V4 builder-to-consumer runtime reachability — `019ffdb2-129d-7900-98f5-837ffe100fbc` | Read-only one serialized arm64 `ac_pc` link and one bounded no-nice LLDB launch at canonical PC `dbf6986`; count graph/GX/V3/V4 builder, typed V3/V4 consumer, prepare, and runtime-observer symbols with explicit return-safe callbacks | Lane worktree `/Users/jk/.codex/worktrees/d952/acgc-modern-port`; canonical PC `dbf6986` at run time; decomp `09ca8e8b`; exact roots `/private/tmp/acgc-lane-current-v4-runtime-build` and `/private/tmp/acgc-lane-current-v4-runtime-logs` protected for cleanup | Complete/archived pending exact-path cleanup; link `[4019/4019]` and one real boot/NEOS launch passed, but the callback stopped at `graph_task_set00` with `SBBreakpoint.GetName` `AttributeError`; downstream explicit counts are zero only within that stopped trace, and static crosswalk shows V4 is not live-wired; no callback, Metal encode/readback, pixel, input/audio/save/device, simulator, or playability claim; evidence `docs/evidence/CURRENT-V4-RUNTIME-DBF6986-2026-08-13.md` |
| 112 | Production Save_t/CARD recovery — `019ffdba-e4f1-71d1-82fd-573f767a436b` | Source-edit lane for the two-upstream Save_t/GCI checksum and main/backup recovery seam; own only `pc/src/pc_m_card.c`, one focused recovery fixture, and minimal registration; no full link/LLDB/device | Worker branch `c1/lane-card-production-recovery` `3d3204e`; integrated canonical PC `c1/macos-host-launch` `f19c73f`; decomp `09ca8e8b`; worker and integrated roots retired after holder checks; preserved worktree `/Users/jk/.codex/worktrees/6e5b/acgc-modern-port` retains owner-managed holders | Complete/integrated/archived; only CMake registration and fixture temp-root naming changed, `pc_m_card.c` unchanged; integrated native and combined ASan/UBSan focused CTest `1/1` each with no diagnostics; no full link/LLDB/physical CARD/device/persistence/playability claim; evidence `docs/evidence/SAVE-CARD-PRODUCTION-RECOVERY-F19C73F-2026-08-13.md` |
| 113 | Input snapshot boundary audit — `019ffdba-e4ee-72c3-ad9a-5f9d77153f34` | Read-only/test-only characterization of per-frame `PCInputSnapshot`, controller/keyboard mapping, and game-owned frame guard; no source/CMake edits, full link, LLDB, physical input, or playability | Visible worktree `/Users/jk/.codex/worktrees/8a82/acgc-modern-port` and exact root `/private/tmp/acgc-lane-input-runtime-boundary-XTPXKu` are absent after archival; eight surviving holders still name the unlinked worktree CWD and must exit naturally; canonical PC `dbf6986` at test time; decomp `09ca8e8b` | Complete/archived; native and combined ASan/UBSan focused tests `3/3` each with no diagnostics; double-`PADRead` is stable, while sub-threshold analog L/R reproduces `PADStatus` `(88,88)` but game-owned `now.button=0x0000` versus decomp `0x0030`; no source edit or physical-input/device/playability claim; evidence `docs/evidence/INPUT-BOUNDARY-AUDIT-DBF6986-2026-08-13.md`; stale metadata reconciliation remains held until the holders exit, and a separately authorized test-first fix lane is required |
| 114 | Mixer/DMA/CoreAudio boundary audit — `019ffdba-e4f1-71d1-82fd-57561a66e50a` | Read-only verification of the JAudio mixer/DMA/NEOS-to-Apple sink boundary; no source edits, full link, LLDB, ISO/assets, or audible-device claim | Visible worktree `/Users/jk/.codex/worktrees/0705/acgc-modern-port`; tested at PC `dbf6986`, current canonical PC `f19c73f`; decomp `09ca8e8b`; exact roots `/private/tmp/acgc-lane-mixer-coreaudio-current-native-VDoxjP` and `/private/tmp/acgc-lane-mixer-coreaudio-current-sanitizer-4WmGA1` | Complete/archived pending exact-path cleanup; native and ASan/UBSan CMake audio sets `4/4` pass, including software mixer/DAC/callback, NEOS/RSP, high-address DMA, and pointer probes; CoreAudio opened 32 kHz stereo/512 with zero underruns/overruns but producer was silent, so no audible-audio claim; evidence `docs/evidence/MIXER-COREAUDIO-AUDIT-DBF6986-2026-08-13.md` |
| 115 | V4 live channel rejection diagnostic — `019ffe12-2fe1-7ea2-aad2-26736c85fcd6` | Remote-focused source/test lane for `pc_gx_v2_channel_state_is_supported()` and the repeated live one-channel V4 rejection; source edit only if the two-upstream crosswalk proves a defect; no Apple consumer/runtime, packet-header, full-link, LLDB, ISO/assets, Metal, pixel, or playability scope | Visible task worktree `/Users/jk/.codex/worktrees/3526/acgc-modern-port` detached at umbrella `189b7b4`; PC source `/private/tmp/acgc-lane-gx-v4-channel-diagnostic-3526` on `c1/lane-gx-v4-channel-diagnostic` at `a53b192`; decomp `09ca8e8b`; no build roots or source diff | Parked/setup-blocked: Codex could not hand off because no matching saved `acgc-modern-port` project exists on M3 Max; task returned idle without edits/tests. Preserve worktree/branch until the remote project is registered; no local lane is active |
| 116 | V4 disabled-channel predicate diagnostic — `019fff00-d312-73a0-8396-d94c6618e0b8` | Remote M3 Max source lane for the decomp-compatible disabled `GX_SRC_REG`/`GX_SRC_VTX` material-channel case; own only `pc/src/pc_gx.c` and its focused V4 fixture; no Apple consumer/runtime, full-link, LLDB, ISO/assets, Metal, pixel, or playability scope | Remote branch `c1/lane-gx-v4-channel-diagnostic-m3` at worker `e8155c6`; exact remote worktree and three build roots retired after holder-free checks; local canonical PC `c0f048d6`; decomp `09ca8e8b`; evidence `docs/evidence/GX-V4-CHANNEL-DIAGNOSTIC-C0F048D6-2026-08-13.md` | Complete/integrated/archived; focused native and combined ASan/UBSan gate `1/1` each on the integrated snapshot (worker matrices `4/4` each); no live callback/Metal/pixel/playability claim |
| 117 | V4 Apple consumer/runtime — `019fff16-cacd-7133-9823-15d529e8bb63` | Remote M3 Max source lane; own only Apple V4 consumer/runtime header/source, one focused consumer test, and minimal registration; no `pc_gx.c`/packet-builder or decomp edits | Remote project `/Users/testtest/Documents/Projects/acgc-modern-port`; worker base/final `a53b192` (no source change); exact remote worktree/roots retired after holder-free checks | Complete/archived, no Apple-side defect proven; native and combined ASan/UBSan typed-consumer tests `1/1` each, no diagnostics; no full link, LLDB, live callback, Metal encode/readback, pixel, device, or playability claim |
| 118 | V4 builder-to-consumer fixture — `019fff16-d72e-7703-8721-c81517ebe538` | Remote M3 Max test/source lane; own only `pc/tests/pc_gx_v4_handoff_fixture.c` and minimal CMake registration; no production `pc_gx.c` or Apple consumer/runtime edits | Worker branch `c1/lane-gx-v4-fixture-m3` base `a53b192` → `ce06b5b`; integrated canonical PC `13c0e0cf`; exact remote worktree/roots retired after holder-free checks | Complete/integrated/archived; native and combined ASan/UBSan focused CTest `1/1` each (`detect_leaks=0`, no diagnostics); evidence `docs/evidence/GX-V4-HANDOFF-FIXTURE-13C0E0CF-2026-08-13.md`; synthetic CPU/contract only, no live callback/Metal/pixel/playability claim |
| 119 | Sanitizer and Windows refresh — `019fff16-e538-7e73-a844-f4e09c18538d` | Remote M3 Max read-only verification; own no source; unique native/ASan/Windows roots; record shared `_WIN32`/ILP32 probes separately from missing i686 MinGW/sysroot | Tested remote base `a53b192`; exact native/ASan/Windows roots retired after holder-free checks | Complete/archived; 9/9 focused native and 9/9 combined ASan/UBSan semantic/packet tests plus seven direct probes pass; eight C/portable `_WIN32` probes pass; libc++/fortified-macro and missing i686 MinGW `math.h`/sysroot blockers remain; no Windows sign-off; evidence `docs/evidence/REMOTE-M3MAX-AUDIT-BATCH-2026-08-13.md` |
| 120 | Input trigger audit — `019fff16-f4d5-76b1-b3eb-dd7d9bb18512` | Remote M3 Max read-only/test-only crosswalk of SDL/PAD analog thresholds, decomp button semantics, and double-read stability; no production input edit | Tested remote base `a53b192`; exact native/ASan/fixture roots retired after holder-free checks | Complete/archived; existing input tests `3/3` and boundary fixture `1/1` pass in native and combined ASan/UBSan; PC L/R bit turns on at raw `12801`/analog `100` while decomp PAD threshold is analog `170` (`21760`); repeated reads stable; no physical controller/device/playability claim; evidence `docs/evidence/REMOTE-M3MAX-AUDIT-BATCH-2026-08-13.md` |
| 121 | Mixer/CoreAudio refresh — `019fff17-0485-79d1-ab6b-47e1495d97af` | Remote M3 Max read-only/test-only mixer/DAC/NEOS/RSP/high-address-DMA and CoreAudio boundary verification; no source edit | Tested remote base `a53b192`; exact native/ASan roots retired after holder-free checks | Complete/archived; mixer/NEOS/DMA probes `3/3` native and `3/3` combined ASan/UBSan; CoreAudio opened 32 kHz S16 stereo/512 with 61 callbacks and zero underruns/overruns, but producer was silent; no audible-audio claim; evidence `docs/evidence/REMOTE-M3MAX-AUDIT-BATCH-2026-08-13.md` |
| 122 | CARD production validation — `019fff17-0fe1-7b23-8dd9-b18503b70fe8` | Remote M3 Max source lane; own only `pc/src/pc_m_card.c`, one production validation fixture, and minimal registration; no GX/Apple edits | Worker `c1/lane-card-production-validation-m3` `65bee4f`; integrated canonical PC `96ee5d61`; exact remote worktree/native root retired after holder-free checks | Complete/integrated/archived; full aligned CARD slot checksum/tail preservation fix; native and combined ASan/UBSan focused CTest `2/2` each with no diagnostics; evidence `docs/evidence/CARD-PRODUCTION-VALIDATION-96EE5D61-2026-08-13.md`; no physical CARD/device/persistence/playability claim |
| 123 | Lifecycle timing audit — `019fff17-1964-7822-babf-2120bc78fb6e` | Remote M3 Max read-only/test-only timing, retrace, supervisor TERM grace, KILL fallback, and shutdown ownership audit | Tested remote base `a53b192`; exact native/ASan roots retired after holder-free checks | Complete/archived; five native and five combined ASan/UBSan synthetic lifecycle repetitions pass with trace hash `6e4a5d94e1b0dd80`; retrace callbacks, generic worker/alarm ownership, focus wiring, and signal teardown remain unproven; evidence `docs/evidence/REMOTE-M3MAX-AUDIT-BATCH-2026-08-13.md` |
| 124 | Graph terminator fixture — `019fff17-22e0-7f12-8c20-2fad9a684892` | Remote M3 Max test-only fixture for indirect target resolution and exact `DF000000,0` termination; own only focused test/CMake | Worker `c1/lane-graph-terminator-fixture-m3` `b3c7a9d`; integrated canonical PC `edc323ea`; exact remote worktree/roots retired after holder-free checks | Complete/integrated/archived; standalone portable native and combined ASan/UBSan focused CTest `1/1` each; synthetic COMPLETE/PREFIX_ONLY/UNTERMINATED/MALFORMED only; evidence `docs/evidence/GRAPH-TERMINATOR-FIXTURE-EDC323EA-2026-08-13.md`; no live graph/draw/frame claim |
| 125 | Texture/TLUT/TEV fixtures — `019fff17-2f40-78c1-b2c6-f69c50fc93fb` | Remote M3 Max test-only fixture lane; own only texture/TEV fixture files and minimal CMake; no packet-header, `pc_gx.c`, or Apple edits | Worker `c1/lane-texture-tev-fixtures-m3` `24fbf2f`; integrated canonical PC `894ac5f8`; exact remote worktree/roots retired after holder-free checks | Complete/integrated/archived; native and combined ASan/UBSan focused CTest `1/1` each with no diagnostics; synthetic texture/TLUT/TEV validation only; evidence `docs/evidence/TEXTURE-TEV-FIXTURES-894AC5F8-2026-08-13.md` |
| 126 | Metal state contract audit — `019fff17-38e4-7ed3-a2aa-04e48b823c33` | Remote M3 Max read-only CPU/contract audit of the Metal sink/state encoder seam and GX state mapping; no source/build/link/launch edits | Tested remote base `a53b192`; empty audit root retired after holder-free check | Complete/archived; static crosswalk identifies texture-coordinate/texture-key/TEV state consumption as the next encoder gate; V4 remains `V3_EXTENSION_NOT_RENDERED`; no tests, device/encode/readback/pixel/playability claim; evidence `docs/evidence/REMOTE-M3MAX-AUDIT-BATCH-2026-08-13.md` |
| 127 | iOS shared-boundary audit — `019fff17-4100-78f1-91c4-0996c40e41b5` | Remote M3 Max read-only portable/Apple boundary readiness audit; no iOS target, simulator/device, or source edits | Tested remote base `a53b192`; exact portable/Apple native+ASan roots retired after holder-free checks | Complete/archived; portable `20/20` and Apple CPU-only `7/7` native plus ASan/UBSan; Metal/device tests skipped; unresolved game-systems stub, synthetic triangle host, and missing iOS target/adapters remain; no iOS playability claim; evidence `docs/evidence/REMOTE-M3MAX-AUDIT-BATCH-2026-08-13.md` |
| 128 | Apple texture/TLUT/TEV CPU consumer seam — `019fff43-def1-7bd2-8e1a-f7e72a6aac5b` | Remote M3 Max source lane; own only Apple consumer/runtime header/source, one focused CPU fixture, minimal CMake, and no `pc_gx.c`/packet-builder/decomp/full-link/LLDB/device/Metal/pixel/playability scope | Worker `c1/lane-texture-tev-m3` `a6c5e0c8` based on `894ac5f8`; integrated canonical PC `08c27de5`; focused roots `/private/tmp/acgc-integrated-texture-tev-08c27de5` and `-asan` | Complete/integrated/archived; native and combined ASan/UBSan focused CTest `2/2` each, no diagnostics (`detect_leaks=0`); opt-in CPU-only texture/TLUT/TEV resolver, existing V2 handoff remains `NOT_RENDERED`; evidence `docs/evidence/APPLE-TEXTURE-TEV-CPU-SEAM-A6C5E0C8-2026-08-14.md` |
| 129 | Runtime texture/TLUT/sampler forwarding audit — `01a000e0-e957-7193-b2f8-23fd0447cdaa` | Remote M3 Max read-only/test-only lane; own only the V2 forwarding crosswalk and focused CPU fixtures if a concrete defect is proven; no `pc_gx.c`/packet-builder/decomp/full-link/LLDB/device/Metal/pixel/playability scope | Same-directory remote project task; source-only PC ref `local-sync/macos-host-launch` at `08c27de5`; worktree `/private/tmp/acgc-lane-runtime-forwarding-m3` on `c1/lane-runtime-forwarding-m3`; focused roots `/private/tmp/acgc-lane-runtime-forwarding-m3-build` and `-asan` | Complete/archived; no source change; native and combined ASan/UBSan focused CTest `2/2` each, no UBSan diagnostics (`detect_leaks=0`); runtime texture/TLUT/sampler forwarding gap proven; evidence `docs/evidence/RUNTIME-TEXTURE-FORWARDING-AUDIT-08C27DE5-2026-08-14.md` |
| 130 | V2 texture runtime sideband — `01a000e5-6aba-7a81-9431-bd22781967f4` | Remote M3 Max source lane; own only Apple consumer/runtime sideband headers/sources, one focused fixture, and minimal CMake; preserve V1/V2 geometry and V3/V4 behavior; no `pc_gx.c`/packet-builder/decomp/full-link/LLDB/device/Metal/pixel/playability scope | Worker `c1/lane-v2-texture-runtime-m3` `a10fed8e` based on `08c27de5`; integrated canonical PC `3c08c7f71`; exact worker roots pending cleanup review | Complete/integrated/archived; native and combined ASan/UBSan focused CTest `3/3` each with no diagnostics (`detect_leaks=0`); borrowed V2 sideband/fail-closed status proof only; evidence `docs/evidence/V2-TEXTURE-RUNTIME-SIDEBAND-A10FED8E-2026-08-14.md` |
| 131 | Game-owned texture source availability audit — `01a000f0-da9a-77b3-900a-06d627b43a2b` | Remote M3 Max read-only/test-only crosswalk of `pc_gx_texture.c`, `PCGXState`, V2 builder, current Apple sideband, and decomp GXTexObj/GXTlutObj lifetime; no source edit/build/link/launch | Same-directory remote project task; source tip `a10fed8e`/sideband content; worktree `/private/tmp/acgc-lane-gx-texture-source-audit-m3`; exact logs none | Complete/archived; no source change; static crosswalk proves no safe CPU byte record, sampler state, or generation token reaches V2 handoff; evidence `docs/evidence/GAME-OWNED-TEXTURE-SOURCE-AUDIT-A10FED8E-2026-08-14.md` |
| 132 | Per-map CPU texture source record — `01a000f5-789c-70a0-851e-e1fdebe391aa` | Remote M3 Max source lane; owned only `pc_gx_internal.h`, `pc_gx_texture.c`, `pc_gx.c` metadata accessor, and one focused portable fixture; invalidated cache/replacement/fallback/stale paths; no Apple/packet ABI/Metal/full-link/LLDB/device/pixel/playability scope | Worker `c1/lane-gx-texture-source-record-m3` `d52c6a0f` based on `a10fed8e`; integrated canonical PC `c1/macos-host-launch` `a96f358` with test-only follow-up `7c9299755`; local roots `/private/tmp/acgc-integrated-v2-source-a96f358-native` and `-asan` | Complete/integrated/archived; focused native and combined ASan/UBSan CTest `2/2` each with no diagnostics (`detect_leaks=0`); sideband-required V2 test is deterministic and green; evidence `docs/evidence/GAME-TEXTURE-SOURCE-RECORD-D52C6A0F-2026-08-14.md`; no live source binding/Metal/pixel/playability claim |
| 133 | Apple V2 texture-source binder — `01a00127-b749-7021-bb08-a8b1485773df` | Remote M3 Max source lane; own only `pc/apple/include/acgc/metal_packet_consumer.h`, `pc/apple/src/metal_packet_consumer.c`, `pc/apple/src/pc_metal_runtime.c`, one focused Apple test; no packet-builder/decomp/full-link/LLDB/device/Metal/pixel/playability scope | Worker `c1/lane-v2-texture-source-binder-m3` `08998d0` based on `a96f358`; integrated canonical PC `c1/macos-host-launch` `354f33884`; roots `/private/tmp/acgc-lane-gx-texture-binder-m3/native` and `-asan` | Complete/integrated/archived; native and combined ASan/UBSan focused CTest `3/3` each, serially with no diagnostics (`detect_leaks=0`); borrowed game-owned texture metadata and lifetime checks are CPU-only; evidence `docs/evidence/APPLE-V2-TEXTURE-SOURCE-BINDER-08998D0-2026-08-14.md`; no live callback/Metal/pixel/playability claim |
| 134 | Current-tip V2 binder runtime check — root-owned | One serialized `ac_pc` link and bounded GUI launch/LLDB trace at integrated PC `354f33884`; no source edits; runtime proof only | Build root `/private/tmp/acgc-current-v2-texture-binder-runtime`; local ISO remains ignored and symlink-only | Complete; link `[4018/4019]` passed, GUI launch reached GAFE01/COPYDATE/NEOS/LOGO/`graph_proc`, GX counts recorded, V2 Apple consumer/provider/observer remained `0`; no Metal/pixel/input/audio/save/device/playability claim; evidence `docs/evidence/CURRENT-V2-TEXTURE-BINDER-RUNTIME-2026-08-14.md` |
| 135 | V2 handoff rejection fixture — `01a00165-3830-73a0-a783-481af8df9bbe` | Remote M3 Max test-only fixture; own only `pc/tests/pc_gx_semantic_v2_handoff.c`; no production GX/Apple edits, full link, LLDB, device, Metal, pixel, or playability scope | Worker `c1/lane-v2-rejection-fixture-m3` `88724cdb` based on `354f33884`; source worktree `/private/tmp/acgc-lane-v2-rejection-fixture-m3` preserved because it contains pre-existing `assets/`/`orig/`; generated focused roots retired | Complete/integrated/archived; native and combined ASan/UBSan focused CTest `1/1` each on worker and integrated PC `2b141a753`; no diagnostics; evidence `docs/evidence/V2-HANDOFF-REJECTION-FIXTURE-88724CDB-2026-08-14.md`; CPU/contract only, no live callback/Metal/pixel/playability claim |
| 136 | Current-tip V2 rejection runtime — root-owned | One serialized current-tip `ac_pc` link and one GUI-session LLDB launch at PC `2b141a753`; no source edits; exact local ISO only | Build `/private/tmp/acgc-current-v2-rejection-runtime-2b141a753`; trace `/private/tmp/acgc-current-v2-rejection-runtime-2b141a753-lldb-logs`; generated roots holder-free after review | Complete; link `[4018/4019]` arm64 Mach-O; GUI run reached GAFE01/COPYDATE/forest/Famicom/NEOS/LOGO and graph/GX; `graph_task_set00=26`, `emu64_taskstart=26`, `GXBegin=524`, `pc_gx_flush_vertices=523`, V2 builder `523`, bounded V2 diagnostic `64`; Apple consumer/provider/observer `0`; no TERM/KILL disposition asserted from transient GUI stdout; no Metal/pixel/input/audio/save/device/playability claim; evidence `docs/evidence/CURRENT-V2-REJECTION-RUNTIME-2B141A753-2026-08-14.md` |
| 137 | V2 state-extension diagnostic — `01a0017d-d42d-74f0-846c-f4a97c5d6193` | Remote M3 Max Luna Max/max source/test lane; own only `pc/src/pc_gx.c`, one new V2 state-extension fixture, and minimal CMake registration; preserve V1/V2 fail-closed behavior; no existing handoff-fixture, packet-header/ABI, Apple, decomp, full-link, LLDB, device, Metal, pixel, or playability scope | Branch `c1/lane-v2-state-extension-m3` from PC `2b141a753`; dedicated worktree `/private/tmp/acgc-lane-v2-state-extension-m3` preserved because it contains pre-existing `assets/`/`orig/`; focused roots were absent; decomp `09ca8e8b`; crosswalk `GX_SRC_REG/GX_SRC_VTX` versus the exact V2 validator recorded in `docs/evidence/V2-STATE-EXTENSION-DIAGNOSTIC-2B141A753-2026-08-14.md` | Complete/parked; no source edit or commit, no build/test/runtime result; packet header advertises vertex-source state but the exact validator and Apple consumer do not represent it, so the lane stopped before edits; no callback/Metal/pixel/playability claim |
| 138 | V2 channel-source contract — `01a0018a-cb34-7860-85ac-be8ef4f800cc` | Remote M3 Max Luna Max/max source/test lane launched through the verified remote CLI because the host is not yet registered as a saved Codex project; own only packet header/validator, Apple typed consumer/runtime, one new focused fixture, and minimal CMake; preserve V1/V2 fail-closed behavior; no `pc_gx.c`, existing handoff fixture, decomp, full-link, LLDB, device, Metal, pixel, or playability scope | PC base `2b141a753`; worker branch/worktree `c1/lane-v2-channel-source-contract-m3` / `/private/tmp/acgc-lane-v2-channel-source-contract-m3`; worker commit `112c7cd2`; integrated canonical PC `565f877e`; decomp `09ca8e8b`; exact focused roots retired after review | Complete/integrated/archived; exactly seven owned files; native and combined ASan/UBSan focused CTest `3/3` each with no diagnostics (`detect_leaks=0`); fixed-width V2 ABI unchanged, disabled channel-source contract accepted, unsupported/malformed state fails closed, vertex-source V2 remains `V2_EXTENSION_NOT_RENDERED`; no full link, LLDB, live callback, Metal, pixel, device, or playability claim; evidence `docs/evidence/V2-CHANNEL-SOURCE-CONTRACT-565F877E-2026-08-14.md` |
| 139 | Current-tip V2 channel-contract runtime — root-owned | One serialized native arm64 `ac_pc` link and one bounded logged-in GUI-session LLDB launch at PC `565f877e`; count registration, graph/GX/V2 builder, Apple consumer/provider/observer, and bounded rejection records; no source edit | Build `/private/tmp/acgc-current-v2-channel-runtime-565f877e`; trace `/private/tmp/acgc-current-v2-channel-runtime-565f877e-logs`; local ignored ISO symlink only; decomp `09ca8e8b` | Complete; link `[4018/4019]`, arm64 SHA-256 `d1b7a32817ae6e3b6f78aa1f2245e887e11eb1d87dd3951124621689222d34e4`; GAFE01/COPYDATE/LOGO/NEOS reached; graph/emu64 `26`, GX/flush `510`, V2 builder `509`, typed consumer/provider/observer `0`; 32 bounded rejections were 31 triangle lists with counts divisible by three plus one four-vertex quad, exposing the exact-three-vertex guard as the first live blocker; TERM used, KILL not needed, game absent at postcheck; no packet/Metal/pixel/input/audio/save/device/natural-shutdown/playability claim; evidence `docs/evidence/CURRENT-V2-CHANNEL-RUNTIME-565F877E-2026-08-14.md` |
| 140 | V2 triangle-list batch handoff — `01a001ea-3ea3-7c01-903e-b3c10236b73e` | Remote M3 Max Luna Max/max source/test lane; keep the direct V2 handoff exact-three, add a separate all-or-nothing `GX_TRIANGLES` batch path that preflights every slice before any callback, and emit one three-vertex V2 packet per triangle; preserve V1/V3/V4, legacy GL, Windows behavior, and fail-closed quads/nonmultiples/unsupported state | PC base `565f877e`; worker commits `c7495259` plus review follow-up `c1dbf9fe`; integrated canonical PC `90cb22154` plus final `c973dbee`; preserved branch/worktree `c1/lane-v2-triangle-batch-m3` / `/private/tmp/acgc-lane-v2-triangle-batch-m3`; decomp `09ca8e8b`; remote/local generated roots and temporary bundles retired after holder checks; source worktree retained because ignored `assets/` and `orig/` are present | Complete/integrated/archived; exact three owned files; single triangles use the direct path, grouped triangles prebuild every slice before ordered callbacks, and all failure cases produce zero partial callbacks; remote and integrated native plus combined ASan/UBSan focused CTest `2/2` each with no diagnostics (`detect_leaks=0`); no full link, LLDB, live callback, Apple/Metal/pixel/device/playability claim; evidence `docs/evidence/V2-TRIANGLE-BATCH-HANDOFF-C973DBEE-2026-08-14.md` |
| 141 | Current-tip V2 triangle-batch runtime — root-owned | Exactly one serialized native arm64 `ac_pc` link and one bounded logged-in GUI-session LLDB launch at PC `c973dbee`; count direct/batch V2 builders, typed Apple consumer/prepare/provider/runtime observer, graph/GX, and source-line rejection frontiers; no source edit | Generated build `/private/tmp/acgc-current-v2-triangle-runtime-c973dbee` and trace `/private/tmp/acgc-current-v2-triangle-runtime-c973dbee-logs` were retired after exact holder-free checks; canonical PC `c973dbee`; decomp `09ca8e8b`; local ignored ISO symlink only | Complete/evidence integrated; link `[4018/4019]`, arm64 SHA-256 `69ce23a0917fa19e06e658abfec9c1385df9834228e0a815d13fc6eb08d46b7a`; PIDs LLDB `99278` / game `99306`; GAFE01/COPYDATE/LOGO/NEOS frame 901; graph/emu64 `19`, GX/flush `218`, grouped batch/guard/first-slice/internal builder `213`, base-state-pass and all Apple consumer/provider/observer milestones `0`, V3/V4 fallback `218`; TERM used, KILL not needed, inferior exit `0`; next gate is a test-backed grouped-path base-state rejection classifier; no packet/Metal/pixel/input/audio/save/device/natural-shutdown/playability claim; evidence `docs/evidence/CURRENT-V2-TRIANGLE-RUNTIME-C973DBEE-2026-08-14.md` |
| 142 | V2 base-state rejection reason — `01a00211-7500-7cd3-a5f6-161cfcbff884` | Remote M3 Max source/test lane; classify the exact compound V2 base-state rejection without changing predicate behavior; own only `pc/src/pc_gx.c`, one focused rejection-reason fixture, and minimal CMake registration | Branch `c1/lane-v2-base-rejection-reason-m3` at base `c973dbee`; worktree `/private/tmp/acgc-lane-v2-base-rejection-reason-m3`; native/ASan roots `/private/tmp/acgc-lane-v2-base-rejection-reason-m3-native` and `-asan`; decomp `09ca8e8b` | Active; two-upstream crosswalk and focused implementation/verification in progress; no packet ABI, Apple, full-link, LLDB, ISO/assets, Metal, pixel, device, or playability scope |
| 143 | Renderer semantic contract consolidation — `01a00212-fc10-78c0-a39a-70de7beb923a` | Remote M3 Max read-only audit; crosswalk V2/V3/V4 packet fields against decomp GX producers and Apple consumers, then recommend the smallest coherent end-state contract | Detached worktree `/private/tmp/acgc-lane-renderer-contract-audit-m3` at PC `c973dbee`; decomp `09ca8e8b`; no build/test roots | Active; source crosswalk only, with no edit/build/link/launch/asset/device/Metal/pixel/playability scope |
| 144 | Apple Metal sink reachability audit — `01a00212-f8b5-7c71-9557-1c5208f87e17` | Remote M3 Max read-only audit; map successful V2 packet flow through callback registration, typed preparation, texture provider, runtime observer, and sink submission | Detached worktree `/private/tmp/acgc-lane-apple-sink-audit-m3` at PC `c973dbee`; decomp `09ca8e8b`; no build/test roots | Active; call graph and gate table in progress, with no edit/build/link/launch/asset/live-callback/Metal/pixel/device/playability scope |

## Parked intake (not active)

These bounded successors were requested with Luna Max/max reasoning and distinct
ownership, but their client-only IDs never became durable visible tasks or
isolated worktrees. They are retained as historical roadmap ideas only and are
not counted as active or eligible for refill until a later dependency-ready
request creates a durable task with the full reference-first contract required
by `AGENTS.md`.

| Planned lane | Client task ID | Ownership / first evidence |
| --- | --- | --- |
| Frame evidence harness | `client-new-thread:c510c55b-ce41-4e3a-b731-5044e2408da6` | Umbrella `scripts/probes/` only; fail-closed launch/boot/packet/present/frame labels |
| Arm64 post-texture ABI audit | `client-new-thread:aa0ce132-2742-4577-bca2-5698cbade79c` | Read-only GAME/GRAPH width/range scan; no full link |
| ac-decomp GAFE01 build audit | `client-new-thread:1249787f-4597-4ec3-9dd0-518a28290af4` | Separate `upstream/ac-decomp` revision/configure/toolchain evidence |
| Save_t raw-wire preservation follow-up | `client-new-thread:990b558a-7152-4205-949a-3c2215e113d9` | `pc_save_bswap` and focused wire-roundtrip proof only |
| Windows x86 cross-compile probe | `client-new-thread:1cc25514-49e4-466c-b76a-461c645b8cd4` | Read-only i686/MinGW/strict `_WIN32` availability and compile evidence |
| iOS shared-boundary readiness audit | `client-new-thread:64b5daf8-a303-4428-870f-9f011774ac9f` | Read-only portable vs AppKit/Metal/CoreAudio boundary map; no iOS source |
| Post-texture graph-fault continuation | `client-new-thread:6240fbda-a36c-409f-89b3-66a3878fe6bd` | `src/game.c`/graph ABI only after texture integration; next real arm64 stop |
| Live-prefix decoder contract | `client-new-thread:faa2fa6c-c564-4f4b-9b0b-268c904e9fde` | Fail-closed decoder/packet fixtures for the observed 8-word prefix |
| Metal frame-evidence harness | `client-new-thread:fb45f25e-4bf5-43ae-afc5-e10117d7620f` | Packet/encode/present/readback gate; record no-device result without pixels claim |
| Asset-audio runtime gate | `client-new-thread:f0a79adc-ad4d-4350-bdce-38cdd8c8657b` | NEOS_OUT-to-sink evidence separated from synthetic PCM and audibility |
| Audio DMA LP64 source fix | `client-new-thread:370c3642-5817-47e5-9ec1-6334af650c40` | `system.c` only; reproduce and fix the `0x84c5e0` truncated audio pointer, with one serialized build and runtime trace |
| Audio DMA pointer fixture | `client-new-thread:151827fb-3aa0-476c-ac93-f3ab807b8fb7` | Test-only `pc/tests/pc_audio_dma_pointer_fixture.c`; no production audio edits; native/ASan width regression |
| Post-audio boot trace | `client-new-thread:c1e4496c-1d1a-47f0-8ae3-fadfb3cc1770` | Read-only LLDB evidence after the audio fault boundary; unique logs, no source edits |
| Current sanitizer refresh | `client-new-thread:018acc6f-fec7-4f3b-8795-03627ad5c09b` | Read-only native plus ASan/UBSan at current source tip; unique build roots and serialized full links |
| Runtime save restart gate | `client-new-thread:c00febc3-0362-4c72-a99d-cac119c7e0a2` | Umbrella probe/evidence only for save request → atomic write → restart → reload; preserves raw-wire mismatch |
| Frame evidence packaging | `client-new-thread:890ae77b-685a-4c69-ab22-429c7ddad9a2` | Umbrella `scripts/probes/` and `docs/evidence/` only; fail-closed submit/encode/present/readback labels |
| Raw audio-bank ABI design audit | `client-new-thread:8c52eb22-8ce9-4952-b695-7f7568855f5c` | Read-only wire/native layout map for `Nas_BankOfsToAddr_Inner`; no source edits or full link |
| Audio-bank wire fixture | `client-new-thread:be5c06e2-5d95-4758-b9ba-c607bb5679d6` | Test-only `pc/tests/pc_audio_bank_wire_fixture.c`; synthetic high-address/fail-closed offset cases |
| WaveTouch LP64 wire audit | `client-new-thread:f9c69af2-66c4-4d32-a142-c6b62b79345b` | Read-only `__WaveTouch`/`smzwavetable` width and relocation audit; separate from `system.c` edits |
| ac-decomp audio-bank cross-reference | `client-new-thread:944f3f31-ffe6-456c-8445-412dbfb9df59` | Read-only GAFE01_00 cross-repo schema/build comparison; no upstream edits or asset output |

The Codex-created umbrella worktrees begin detached at umbrella commit
`82732fe` with nested submodules uninitialized. Source-edit lanes therefore use
the explicit source worktrees listed above. No lane should initialize nested
submodules blindly or edit a detached source checkout.

## Evidence already integrated

- `9b1c48f` / `3a6582d` are integrated on `c1/macos-host-launch`; the SDL/CoreAudio
  boundary and CARD host-transfer probes pass, but they do not prove audible
  mixer output or GameCube Save_t/GCI persistence.
- `e5442de` adds the injectable, fixed-width PC input snapshot boundary; its
  focused source test passed. `858d802` now routes the exact final `PADRead`
  handoff through that snapshot and passes native plus ASan/UBSan tests.
- `8b6849f` adds the SDL virtual-controller/event smoke harness. The real
  `PADInit`/`PADRead` controller path passes 2/2 natively and under ASan/UBSan;
  queued keyboard events are delivered but do not alter SDL keyboard state, so
  the input lane is parked pending OS/human keyboard and physical-device proof.
- `e03ffed` adds a pointer-free graph submission capture seam. `10d6ac0` adds
  an opt-in Darwin callback and moves the bounded copy immediately after
  `JW_BeginFrame`, before the legacy emu64 texture setup. The focused legacy
  seam test passes. A fresh LLDB run reaches the callback with version `1`,
  frame `0`, source capacity `256`, count `8`, and the fixed-width words
  `de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000`.
  This is the first live game-owned submission prefix, not a synthetic draw.
- After the capture, the same run stops at `pc_gx_texture.c:62` while
  `tex_content_hash` follows `data=0x83bdc0` from a truncated 32-bit texture
  object. That is the next source-fix gate; no rendered frame is claimed.
- Two cold runs through the ignored ISO symlink reproduce the exact same
  version/frame/capacity/count/word prefix and the same texture fault. This
  makes the capture deterministic evidence, not a one-run debugger artifact.
- The integrated forensic fixture `07a5447` reproduces the same width loss
  without a game launch: `GXInitTexObj` stores only the low 32 bits after the
  opaque GBI handle resolves, and `GXGetTexObjData` returns that truncated
  value. It is an intentional `EXPECTED_FAILURE` invariant, not a fix.
- `5086f1d` reloads `GAME.graph` after the callback that corrupts the local
  callee-saved register. The patched arm64 run reaches the first
  `graph_task_set00` call; it is the prerequisite for the live capture in
  `10d6ac0`, not a rendered-frame claim.
- `83fa889` is the integrated renderer-neutral GX packet contract. It is a
  4,800-byte fixed-width packet with strict malformed-input rejection; native,
  Apple-entrypoint, and ASan/UBSan focused tests pass. It is not live-game
  evidence.
- `866dd94` adds Metal geometry/state fixtures. CPU and existing geometry tests
  pass; the offscreen Metal test is skipped because this host reports no Metal
  device.
- `12b4f6e` adds a bounded GX-packet-to-Metal consumer fixture. It validates
  the existing fixed-width packet, composes transforms, routes material and
  texture/TEV fixture colors, and rejects unsupported topology without
  truncation. The CPU contract passes; the offscreen encoder path skips on this
  host with no Metal device. It is not live-game frame or pixel evidence.
- `d0ae08d` adds the reviewed graph-capture-to-GX handoff adapter. It validates
  capture bounds, refuses empty/incomplete snapshots, invokes only an explicit
  decoder for a complete capture, and re-validates the resulting packet. The
  observed live shape (`de010000,f0002000` plus zero words, count 8/capacity
  256) returns `INCOMPLETE_CAPTURE` without invoking a decoder. From the
  authoritative source checkout, the focused adapter/C/C++ packet suite passed
  `3/3` under `/private/tmp/acgc-integrated-gx-adapter-build`; this is a
  fail-closed seam, not a draw or frame claim.
- The bounded activation run in
  `docs/evidence/GRAPH-CAPTURE-ACTIVATION-2026-08-13.md` proves the
  source-supported `ACGC_GRAPH_CAPTURE=1` switch reaches the live observer and
  emits one `8/256` record before a clean TERM exit. The `DE010000 F0002000`
  shape remains an unresolved indirect edge; no complete list,
  encode/present/readback, or frame claim follows.
- The GBI indirect-target audit in
  `docs/evidence/GBI-INDIRECT-TARGET-AUDIT-2026-08-13.md` maps that edge from
  `sys_dynamic.work` into the separate `sys_dynamic.new0` arena through a
  live PC registry capability. A resolving successor must retain target
  identity/capacity and require `DF000000,0`; the bounded root cannot supply
  those bytes by itself.
- The exact-tip sanitizer refresh in
  `docs/evidence/SANITIZER-REFRESH-AC39D04-2026-08-13.md` passes three focused
  fixtures with two declared Metal-device skips per native and ASan/UBSan
  matrix, with no sanitizer diagnostics; it remains fixture-only evidence.
- The game-owned Save_t/CARD caller audit in
  `docs/evidence/GAME-SAVE-CALLER-AUDIT-2026-08-13.md` identifies the restart
  NPC `aNRST_save` → `mCD_SaveHome_bg(0, ...)` path as the smallest real
  persistence gate. The host recovery fixture remains below that caller
  boundary, so no game-level persistence claim follows.
- `ddbb498` adds fixed-width texture/TLUT/sampler/TEV fixtures, including
  CI14x2 and CMPR reference cases. The integrated Apple fixture test passes;
  no texture upload/readback, shader wiring, or game-renderer evidence is
  claimed.
- `766ad96` adds a synthetic probe through `Jac_VframeWork`,
  `MixInterleaveTrack`, `AIInitDMA`, and the SDL callback. Exact PCM and ring
  drain pass natively and under ASan; no device/audible proof is claimed.
- `2736838` adds the next audio provenance boundary: four real `A_INTERLEAVE`
  command batches pass through the RSP/Neos-style path, triple buffer, DAC
  handoff, and callback with 1,118 nonzero samples in native and ASan runs.
  The follow-up real SDL/CoreAudio probe returns declared skip `77` because
  `kAudioDevicePropertyDeviceIsAlive` reports `560947818`; it does not prove
  asset-driven `NEOS_OUT`, CoreAudio output, or human audio.
- Umbrella evidence commits `15a081f`, `ee7b814`, and `fe21878` record
  synthetic lifecycle, sandboxed atomic-save, and arm64/sanitizer matrix gates.
- Umbrella commits `3b8ed21` and `aeefc15` record Save_t/GCI layout and codec
  evidence: canonical/checksum/codec-only restart passes, but the active layout
  places `time_limit` at `+0x02` and the current repacker drops the low 16 bits
  of the raw unit (`wire=0xF10E -> roundtrip=0x0000`). No canonical wire-zero
  rule is justified; exact GCI envelope length, runtime save-manager restart,
  main/backup recovery, and whole-GCI losslessness remain open.
- Umbrella commit `38f85da` records the current focused matrix at exact
  `858d802`: 32 native and 32 ASan/UBSan targets built; portable 14/14, PC 4
  passed with CoreAudio skipped, Apple 6 passed with Metal skipped, and no
  sanitizer/runtime-error findings. This is snapshot evidence, not full
  `ac_pc` or game-frame proof; the source checkout later advanced to `8b6849f`.
- The Windows audit found no regression in `4f77dab` and preserves the x86
  guards, and the post-capture audit at `10d6ac0` also passes strict `_WIN32`
  graph seam compile/test probes. No MinGW/i686 compiler or Windows sysroot is
  installed, so native Windows/x86 translation and link remain unproven. The
  Apple-only capture logger is redirected unless verbose/profile output is
  enabled; this does not affect Windows behavior.
- `dfb3f7f` is integrated as `4f77dab`: the PC disc-backed DVD host accepts the
  GameCube 32-byte sector-tail transfer for 19-byte `COPYDATE` while rejecting
  malformed ranges. Native and ASan/UBSan focused probes pass.
- A fresh arm64 run against the DVD lane reaches `COPYDATE`, string-table
  completion, `JW_Init2`, `HotStartEntry`, both forest archives, and Famicom
  archive loading, then stops at `EXC_BAD_ACCESS` in `game.c:154` while entering
  `graph_proc`. This is not a rendered-frame proof.
- Source commit `671171c` adds the bounded LP64 audio-bank decoder and fixture,
  widens the remaining launch-critical pointer arithmetic, preserves static
  segmented matrix words, widens the train engineer actor field, and guards
  audio lookup when a bank is marked loaded before its native table exists.
  The authoritative branch builds `ac_pc` successfully at
  `/private/tmp/acgc-lane-audio-lp64-build`; the focused native audio fixture
  passes 1/1, emu64 native tests pass 3/3, and the ASan/UBSan emu64 matrix passes
  3/3 at `/private/tmp/acgc-emu64-sanitize-build`.
- Fresh ignored-ISO arm64 runs now load all ten FST entries, both forest
  archives, Famicom data, the audio banks 2/155/154/153, and the game-owned
  `LOGO draw` path. The pre-guard run stopped in `ProgToVp` at
  `channel.c:406` because bank 28 was marked loaded while its LP64 decode was
  rejected (`3376` bytes); the guard changes this to bounded audio-error logs
  (`instrument_table_null`/`percussion_table_null`). A post-guard bounded run
  survives to `NEOS_OUT frame=1741` before the harness terminates it. This proves
  launch survival through that boundary only; it does not prove a visible frame,
  asset-driven audio, input, save/load, or playability.
- Source lane commit `5974764`, integrated as `909f3ca`, accepts only zero-valued
  truncated percussion tails, maps wire `MEDIUM_CART` wave offsets onto the
  native ARAM base, and adds focused fixtures for both rules. The authoritative
  `ac_pc` build returns `0`; the audio fixture passes `1/1`, and the existing
  native and ASan/UBSan emu64 tests pass `3/3` each. A fresh run from that exact
  source snapshot logs bank-28 decode and `[LOGO] draw`; its captured screen is
  the first identifiable game-owned frame. The run then exits `139`, so no
  clean-shutdown, representative GX/Metal, input, audible-audio, save/load, or
  playability claim follows. The integrated commands were
  `cmake -S pc -B /private/tmp/acgc-integrated-audio-wave-build
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_BUILD_TYPE=Debug`,
  `cmake --build /private/tmp/acgc-integrated-audio-wave-build --target ac_pc
  acgc_pc_audio_bank_wire_fixture --parallel 4`, and
  `ctest --test-dir /private/tmp/acgc-integrated-audio-wave-build
  --output-on-failure -R '^acgc_pc_audio_bank_wire_fixture$'`.
- Umbrella commit `adc1d6e` integrates the frame-evidence parser and report from
  lane `019ff9a0-f9be-73a0-a452-02a309e5baa5`. `PYTHONDONTWRITEBYTECODE=1
  python3 -B scripts/probes/frame_evidence.py --self-test` passes. A rerun
  bound to clean source `909f3ca` returns `NOT_CLAIMED` with explicit missing
  `game_owned_submit`, `game_encode`, `game_present`, `visible_window`, and
  `game_readback` prerequisites; it does not override the separately recorded
  screenshot-based identifiable-frame evidence.
- The completed boot trace resolves the failing arm64 store as
  `strb w8, [x22,#0x474]` for `GRAPH_SET_DOING_POINT(graph, GAME_BGM)` with
  computed bad base `0x100000000`; `graph_task_set00` is never hit. Its next
  source successor owns only `src/game.c`, `include/graph.h`, and directly
  necessary ABI/callback tests on `c1/lane-graph-fault`; `5086f1d` is the
  reviewed one-line reload repair.

## Integration order

Earlier eras' scheduling details remain in the lane entries above. The current
order follows the updated critical path recorded in the README (Phases A–G):

1. ~~Resume lanes 239 and 240 from the archived candidate refs~~ — done
   2026-08-17 by the resumed single-owner review; no blocker found.
2. ~~Integrate TEV first, then Indirect~~ — done 2026-08-17 as `043d24822`,
   `b83a6f6e3`, and CMake registration `d50cddb18`, with exact-tip native and
   combined ASan/UBSan focused CTest `2/2` each.
3. ~~Close the Blend/Fog raw-owner and Geometry dependency-result
   predecessors~~ — done 2026-08-21 through PC PRs #1–#3 at canonical
   `4cbb837e6` with independent reviews and exact-tip focused gates.
4. ~~Register the source-backed Geometry dependency fixture as a reproducible
   focused CMake/CTest gate~~ — done 2026-08-22 through PC PR #4 at canonical
   `f77d5ec86`, with native, combined ASan/UBSan, and exact-merge verification.
5. ~~Integrate atomic Texture/TLUT/Dynamic resource borrowing~~ — done
   2026-08-22 through PC PR #5 at canonical `c91873521`, after three corrective
   commits, final independent PASS, and exact-merge native plus ASan/UBSan
   verification.
6. ~~Integrate the independently accepted all-or-nothing cumulative assembler
   and focused CTest registration~~ — done 2026-08-22 through PC PR #6 at
   canonical `c7ce553d7`, with exact-merge native and ASan/UBSan verification.
7. ~~Integrate the independently accepted pure Apple parser~~ — done 2026-08-22
   through PC PR #7 at canonical `8e55df64e`, with exact-merge native and
   ASan/UBSan verification.
8. ~~Add production `ac_pc` producer and assembler membership~~ — done
   2026-08-22 through PC PR #8 at canonical `52019da76`, with independent
   review, exact-merge native and sanitizer-instrumented object builds, and a
   serialized content-identical candidate-tree full link.
9. ~~Add a lease-owning all-section gatherer~~ — done 2026-08-23 through PC PR
   #13 at canonical `d6a22182b`, with independent review, exact-merge native and
   ASan/UBSan verification, and a serialized exact-tip full link.
10. ~~Add one guarded production flush publication~~ — done 2026-08-23 through
   PC PR #14 at canonical `1c8781d76`, with initial independent BLOCK,
   corrective lifecycle/reentrancy child, final PASS, exact-merge native and
   ASan/UBSan verification, and a serialized exact-tip full link.
11. ~~Add semantic Apple section decoding and an immutable typed CPU plan~~ —
   done 2026-08-23 through PC PR #15 at canonical `2d4bc2b7e`, after an initial
   false-green BLOCK, corrective child, final independent PASS, and exact-merge
   native plus ASan/UBSan parser/plan `2/2`.
12. ~~Add the owned callback-to-plan handoff~~ — done 2026-08-23 through PC PR
   #16 at canonical `a4ee15c1d`, with independent review, exact-merge native
   and ASan/UBSan parser/plan/handoff `3/3`, and a serialized exact-tip full
   link.
13. ~~Repair the LP64 N64 matrix payload and rerun the bounded gather trace~~ —
   done 2026-08-23 through PC PR #20 at canonical `2f944f1ae`; exact-merge
   native and ASan/UBSan GBI tests pass, and the real-process frontier moves
   from Transform to Texgen.
14. ~~Repair the transform raw-shadow fixture dependency closure~~ — done
   2026-08-23 through PC PR #21 at canonical `b18aa8e92`, with independent
   review and exact-merge native plus ASan/UBSan `1/1`.
15. ~~Repair and independently review the live Texgen source failure~~ — done
   2026-08-23 through PC PR #22 at canonical `7636cc1d8`, with exact-merge
   native and ASan/UBSan Texgen raw/producer `2/2`. One serialized post-fix
   trace then passes Transform, Channels, Texgen, and Texture/Dynamic `20/20`,
   fails TEV `20/20`, and publishes no envelope.
16. ~~Expand the Apple canonical Geometry CPU replay path to bounded triangle
   and quad batches~~ — done 2026-08-23 through PC PR #23 at canonical
   `de9a26fee`, with independent source and exact-merge PASS plus fresh native
   and combined ASan/UBSan Apple `8/8`. No live callback, Metal, or pixel proof
   follows.
17. ~~Audit and repair TEV with exactly one production owner, merge one PC PR,
   and verify its exact merge~~ — done 2026-08-23 through PC PR #25 at
   canonical `70a8e23bc`, with independent PASS and exact-merge native plus
   ASan/UBSan raw-shadow/producer `2/2`.
18. ~~Repair the canonical baseline, one-pass Apple Geometry decoding, typed
   live Geometry, logical RGBA fixture, and the exact active Channels mode~~ —
   done through PC PRs #26 and #28–#31, advancing the canonical tip to
   `dabc78208`; every source merge has focused native and ASan/UBSan proof.
19. Select exactly one active-Texgen source owner after the two read-only reviews
   converge, merge and verify its smallest focused correction, update the
   umbrella pointer, then run one bounded serialized trace to the next typed
   section or sink frontier.
20. Replay the reviewed download-manifest and nested-ROM hygiene changes one at
   a time after the live critical-path owner is stable; neither may displace or
   overlap the Texgen production file.
21. iOS implementation remains gated behind proven shared macOS core, renderer,
   input, audio, persistence, and lifecycle behavior.

No lane may push, publish, deploy, install, sign, submit, or redistribute the
ISO, extracted assets, keys, or proprietary game data.
