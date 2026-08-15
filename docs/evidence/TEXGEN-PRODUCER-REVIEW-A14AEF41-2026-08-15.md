# Texgen/SU producer review of `a14aef4179`

## Provenance

- Candidate: `c1/lane-texgen-producer-m3` at
  `a14aef417913f9538d952df867f56a826bb7f124`.
- Exact parent: `0f896395c84bdcb238ccd0f8ac3c85632d7a8ede`.
- Canonical bundle SHA-256:
  `a789027090e9f2ce6f6241932cbc4cb9e6f185bcedb069d27b25049afcd09c6c`.
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Independent read-only M3 Max task:
  `01a004f2-96c0-79c2-8c20-c9b028bb5018`.
- Detached review source:
  `/private/tmp/acgc-lane-233-texgen-producer-review`, clean at the exact
  candidate tip.

The reviewer verified exact ancestry, a clean worker, `git diff --check`, and
the exact four-file scope. It did not edit, build, test, clean, or integrate.

## Result: `BLOCK`

`pc_gx_texgen_matrix_record_is_valid()` does not enforce the raw owner's exact
relationship between matrix provenance and the attempted-range known-word
mask.

The setter-owned raw contract is:

- an immediate load sets every bit in its attempted 8- or 12-word range; and
- an indexed-unresolved load clears every bit in its attempted range and
  zeroes those words.

The candidate rejects an indexed-unresolved range only when that range is
fully known. It can therefore accept malformed inactive snapshots containing
either an immediate range with a missing known bit or an unresolved range with
partial known bits. Active generator dependencies normally fail later, but an
inactive malformed record can be published into canonical state. That violates
the required fail-closed raw-provenance boundary.

The canonical ABI intentionally has no provenance field and permits inactive
partial matrix records, so it cannot repair or infer the missing raw invariant.

## Exact same-lane repair

The existing worker branch must change only:

- `pc/src/pc_gx_texgen_producer.c`; and
- `pc/tests/pc_gx_texgen_producer_fixture.c`.

For the attempted range only, immediate provenance must require all mask bits
set and indexed-unresolved provenance must require every mask bit clear. Tail
bits outside a 2x4 attempted range remain permitted. The fixture must add two
inactive negative cases—immediate/missing-bit and unresolved/partial-bit—and
prove the destination sentinel remains unchanged.

The repaired child must rerun the focused native and combined ASan/UBSan tests,
the producer-object target, `git diff --check`, and the bounded portability
probes. It must not alter the API, CMake, raw owner, canonical ABI, decomp,
runtime, or any other producer.

## Evidence boundary

This is a source-only CPU review. It proves no build, sanitizer, production
link, callback, runtime, renderer, Metal encode/present/readback, pixel,
device, Windows runtime, or playability state.
