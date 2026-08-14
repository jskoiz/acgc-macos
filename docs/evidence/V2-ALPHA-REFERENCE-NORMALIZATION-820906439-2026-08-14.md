# V2 alpha-reference normalization at `820906439`

## Provenance and ownership

Remote M3 Max lane 149 (`01a0025c-acba-7100-8a2d-c3a5ea3ec708`) started from
ACGC-PC-Port `59d13a98e06c4a67c67b5936f5257a6ff82c0d7a` on branch
`c1/lane-v2-alpha-ref-normalization-m3`. Its reviewed source commit is
`2dcd69c4a9aebe584e15a939b09492158b9a3978`; the integration owner
cherry-picked it as canonical `c1/macos-host-launch`
`8209064395fab33236abaa57d44d2cb2888ca5cf`. The ac-decomp reference was
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

The exact source delta is:

- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_v2_rejection_reason_fixture.c`

No CMake, packet/header ABI, Apple, shader, decomp, V1, V3, or V4 file changed.
The remote handoff SHA-256 is
`1bd126166a4d5717814264828f4e76f2c89ff73aacae31af61326b60e0a9fb52`.

## Behavior

V2 now treats `alpha_ref0/1` as semantically dead only when both comparisons
are `GX_ALWAYS` and the operator is `GX_AOP_AND`. The stored GX state is not
mutated. Active comparisons and unsupported operators remain fail-closed, and
the rejection classifier uses the same helper as the acceptance predicate.

The focused fixture proves:

1. `GX_ALWAYS/GX_ALWAYS`, `GX_AOP_AND`, refs `8/144` is supported and builds,
   while the stored refs stay unchanged;
2. an active comparator in either position still reports `alpha_test`;
3. `GX_AOP_OR` and `GX_AOP_XOR` still report `alpha_test`; and
4. the live ref values no longer mask a later unsupported blend tuple, which
   reports `blend`.

This does not make the observed runtime draw renderable; blend, depth,
alpha-update, cull, and the independent fog-bearing cohort remain separate
contract gates.

## Verification

The M3 Max worker configured and built only
`acgc_pc_gx_semantic_v2_rejection_reason_tests` from unique native and combined
ASan/UBSan roots. Native CTest passed `1/1`; combined ASan/UBSan CTest passed
`1/1` with `detect_leaks=0` and no sanitizer diagnostics. `git diff --check`
passed. The build emitted the known `INT_MIN` redefinition and unsupported
`-Wno-builtin-declaration-mismatch` AppleClang warnings.

The integration owner repeated the exact target from canonical `820906439`:

- `/private/tmp/acgc-integrate-v2-alpha-820906439-native`: `1/1` pass;
- `/private/tmp/acgc-integrate-v2-alpha-820906439-asan`: combined ASan/UBSan
  `1/1` pass with `detect_leaks=0` and no sanitizer diagnostics.

## Evidence boundary and next gate

This proves a CPU predicate/classifier correction only. It does not prove a
full `ac_pc` link, live packet or callback, Metal encode/present/readback,
pixel, device, or playability gate. Lane 150 independently owns the V2 Apple
sink-status guard; lane 151 owns the cumulative fog/state contract. A later
serialized runtime trace may verify that the first live cohort advances from
`alpha_test` to `blend`, but it must remain separate from Metal pixel proof.
