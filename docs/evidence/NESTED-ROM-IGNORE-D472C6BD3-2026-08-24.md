# Nested local-ROM ignore policy

Date: 2026-08-24

## Outcome

PC PR #34 merged a narrow repository-hygiene correction as
`d472c6bd32443015b0db8e285e1070b4f60539ee`. It preserves the twelve direct
mixed-case disc-image rules from PR #27, adds recursive ISO/GCM/CISO coverage
beneath lowercase `rom` directories, and registers a deterministic Python
fixture that uses dummy path strings only.

The candidate and exact merge each pass all five focused tests. Read-only
tracked-file inspection finds zero ISO, GCM, or CISO paths. No proprietary
image was opened, read, hashed, staged, moved, deleted, copied, or published.

This is ignore-policy and tracked-path proof. It is not asset-content,
history-rewrite, packaging, loader, runtime, renderer, Metal, pixel, device, or
playability proof.

## Immutable references

- Umbrella base: `1a8f666e15c1e595673ba2b44cdcb0d6a11f44e5`.
- PC merge: `d472c6bd32443015b0db8e285e1070b4f60539ee`.
- PC first parent: `07929bf6af57f486d4f263a584282d4804d8b495`.
- Reviewed candidate: `6e52b8f852e399f0ded24887b6c80bc79059760f`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- PC PR: [#34, Ignore nested local ROM disc images](https://github.com/jskoiz/ACGC-PC-Port/pull/34).

The merge has exactly the stated parents. Its first-parent diff is exactly:

```text
M .gitignore
A tools/tests/test_disc_ignore.py
```

The diff is `+126/-0`: three ignore lines and a 123-line fixture. Candidate and
merge trees are byte-identical for the changed paths, `git diff --check`
passes, and no production, CMake, workflow, or asset path changed.

## Policy contract

The three new rules cover mixed-case file extensions recursively beneath a
lowercase directory named `rom`:

```gitignore
**/rom/**/*.[iI][sS][oO]
**/rom/**/*.[gG][cC][mM]
**/rom/**/*.[cC][iI][sS][oO]
```

The fixture verifies:

- the direct PR #27 rules and the three recursive rules remain present;
- root, direct, and nested mixed-case ISO/GCM/CISO examples are ignored;
- a temporary synthetic Git repository proves the new rules independently of
  broader existing build-output rules;
- a non-`rom` negative path is rejected by that rule-only policy;
- the real `pc/build32/bin/not-rom/game.iso` control is owned by the existing
  `build32/` rule, not by a new recursive `rom` rule; and
- cached tracked paths contain no ISO, GCM, or CISO file.

Uppercase directory names such as `ROM` are outside this explicitly lowercase
directory contract. The rules do not ignore unrelated source or configuration
files merely because they appear below a directory named `rom`.

## Two-upstream crosswalk

The PC host repository owns the staging policy:

- `.gitignore` contains the existing direct root, `rom/`, `pc/rom/`, and
  `orig/` rules plus the new recursive rules;
- `README.md` and `build_pc.sh` document a normal local image location below
  `pc/build32/bin/rom/`; and
- `tools/tests/test_disc_ignore.py` owns the synthetic path-only fixture and
  cached tracked-file assertion.

The pinned decomp repository documents the source disc under
`orig/GAFE01_00` and retains its own local-original ignore policy. It has no
counterpart for the PC port's host-side nested `rom` staging convention. The
absence is expected and explicitly bounded here.

## Candidate and exact-merge proof

Candidate worktree:

```text
/private/tmp/acgc-lane-nested-rom-ignore-079
```

Exact-merge source:

```text
/private/tmp/acgc-nested-rom-merge-d472-source
```

The focused command on both reviewed states is:

```sh
PYTHONPATH=. python3 -m unittest tools.tests.test_disc_ignore
```

Both runs report:

```text
Ran 5 tests
OK
```

The exact-merge path attribution additionally resolves representative
`nested/rom/deeper/Game.ISO`, `.gCm`, and `.CiSo` strings to the three new
rules, while the tracked-file scan reports `tracked_disc_images=[]`.

An independent immutable candidate review and a separate exact-merge review
both returned PASS with no P0/P1. The exact-merge review correctly did not
claim ASan/UBSan evidence: sanitizers cannot instrument Git ignore matching or
Python policy assertions in a meaningful way.

## Synchronized C regression runner

The umbrella runner pin advances to exact PC `d472c6bd3` and is executed from
the clean detached merge source as:

```sh
scripts/verify-canonical-pipeline.zsh \
  --pc-root /private/tmp/acgc-nested-rom-merge-d472-source \
  --build-root /private/tmp/acgc-canonical-pipeline-d472-umbrella
```

The fresh matrix discovers and passes:

- native PC source-backed round trip: `1/1`;
- native Apple CPU fixtures: `4/4`;
- combined ASan/UBSan PC round trip: `1/1`; and
- combined ASan/UBSan Apple CPU fixtures: `4/4`.

These C gates prove only that the current source snapshot retains the selected
canonical CPU regression surface. They do not add proof to the ignore-policy
behavior, and they do not build or launch `ac_pc`.

## Hosted and proof boundary

The PC merge tree has no `.github/workflows` entries. PR #34 reports no hosted
checks or reviews, so no paid Apple workflow ran. Local fixture proof and
hosted state remain separate claims.

PC `d472c6bd3` changes no executable production source. The latest full-link
and process evidence therefore remains exact PC `9860ebc5c`: all fourteen
producers, gather, publication, Apple plan, Geometry, Channels, and Texgen pass
before public typed status 17, `CANONICAL_TEXTURE_UNSUPPORTED`; no sink call
occurs.

This evidence proves the two-path merge identity, recursive lowercase-`rom`
mixed-case path behavior, deterministic failure propagation, zero tracked disc
images, and current-tip selected CPU non-interference. It does not prove a real
disc's staging behavior or contents, deletion or history removal, downloads,
packaging, loader behavior, a current-tip full link or launch, Texture resource
consumption, Metal, pixels, device behavior, or playability.
