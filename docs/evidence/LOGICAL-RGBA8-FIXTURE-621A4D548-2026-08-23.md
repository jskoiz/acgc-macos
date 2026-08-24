# Logical RGBA8 fixture correction — PC `621a4d548`

## Outcome

PC [PR #30](https://github.com/jskoiz/ACGC-PC-Port/pull/30),
`Correct canonical Geometry color expectations`, merged into
`c1/macos-host-launch` as
`621a4d548b0f6f82004c44654713751461dff3c9`.

- PC first parent:
  `d40ca1c2caeedf4ebf1ef0315d211cc88dee2c34`
- Reviewed source commit:
  `b716a46db23d28ff325f1a614ba3f0c84d39dae1`
- Decomp/original-behavior oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The exact first-parent merge diff changes only
`pc/apple/tests/test_apple_canonical_plan.c`, replacing two stale expected
values (`+2/-2`). Production source is unchanged. `git diff --check` passes,
the repository has no `.github/workflows` path, and PR #30 reported no hosted
checks. No paid hosted Apple runner was configured or triggered.

## Corrected expectation

The fixture writes final canonical logical RGBA8 words `0x11223344` and
`0x55667788` with `value_encoding == 1`. The Apple canonical-plan path consumes
that encoding directly; applying the raw GX RGBA8 decoder again would produce
the stale byte-swapped expectations `0x44332211` and `0x88776655`.

PC canonical Geometry production already performs the one required raw-to-
canonical conversion. The decomp `GXVert`/`GXAttr` oracle confirms the source
FIFO/channel ordering and `CLR0`/`CLR1` RGBA8 format mapping. The two-line test
correction therefore removes a second decode from the expectation only; it does
not alter production decoding or renderer behavior.

The source patch has the same stable patch identity as the independently
reviewed pre-replay candidate. Two independent read-only reviews found no P0,
P1, or P2 issue.

## Exact-merge focused verification

Preserved detached, clean source worktree:

`/private/tmp/acgc-geometry-color-621-review.UqfOZ0/worktree`

at exact merge `621a4d548b0f6f82004c44654713751461dff3c9`.

Fresh authoritative roots:

- native PC:
  `/private/tmp/acgc-geometry-color-621-review.UqfOZ0/native-pc`
- native Apple:
  `/private/tmp/acgc-geometry-color-621-review.UqfOZ0/native-apple`
- combined ASan/UBSan PC:
  `/private/tmp/acgc-geometry-color-621-review.UqfOZ0/asan-ubsan-pc-final`
- combined ASan/UBSan Apple:
  `/private/tmp/acgc-geometry-color-621-review.UqfOZ0/asan-ubsan-apple-final`

Every build used `--parallel 1`. Every anchored discovery found exactly one
test, followed by serialized CTest execution with `--output-on-failure`.

Results:

- native PC source-backed round trip, Test #39: `1/1` passed;
- native Apple canonical plan, Test #2: `1/1` passed;
- combined ASan/UBSan PC source-backed round trip, Test #39: `1/1` passed in
  0.07 seconds;
- combined ASan/UBSan Apple canonical plan, Test #2: `1/1` passed in 0.04
  seconds; and
- no AddressSanitizer, UndefinedBehaviorSanitizer, or runtime-error diagnostic.

The authoritative sanitizer PC configure includes
`PC_DARWIN_COMPILE_AUDIT=ON`; a preliminary root that omitted that required
option stopped at the expected 32-bit guard and is not counted as evidence.

## Verification-runner boundary

The corrected umbrella verification-runner candidate remains unintegrated.
Its earlier exact-`6c5a626d9` execution correctly exposed these stale
expectations rather than reporting a false green matrix. The runner must now be
replayed from the new umbrella tip, pin exact PC `621a4d548`, and pass its whole
native plus combined-sanitizer matrix before independent review and integration.

## Proof boundary and next gate

Proved:

- exact PR #30 parentage, one-file test-only scope, and merge;
- the already-canonical logical RGBA8 expectation contract; and
- exact-merge native plus combined ASan/UBSan focused fixture execution.

Not proved:

- a full `ac_pc` link or process launch at `621a4d548`;
- the live active-Texgen field values predicted by the source-backed fixture;
- a canonical sink call, Metal encode, present, readback, pixels, device
  behavior, input, audio, save/reload, iOS, or playability.

The next critical-path gate is one serialized exact-`621a4d548` full link and
bounded real-process trace. It must capture the active Texgen record, ordinary
and post matrices, SU state, Texture/TEV consumption predicates, and the next
typed result before selecting the sole Texgen source owner.
