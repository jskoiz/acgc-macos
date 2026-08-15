# Canonical Geometry producer review at `5aba103`

## Provenance

- PC base: `b9a9f355f7d62c14109f711691d8c8fa51ceb7f8`
- reviewed candidate: `5aba10371f2d7bedd3293c2ba64d66bff3ec1cb7`
- candidate bundle SHA-256:
  `c567f54c51c72664fd38488a65971faccb6ab410543173c38a0ac33f215255f4`
- decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- independent task: `01a004f3-5a55-7702-95ec-8acf22b8b806`

The bundle was complete, the candidate was exactly one commit after the stated
base, the detached review tree was clean, `git diff --check` passed, and only
the four contracted Geometry producer/header/fixture/CMake files changed. The
review did not inspect proprietary data or the live worker checkout.

## Verdict

`BLOCK` pending a narrow same-branch repair.

The staged, pointer-free producer design and explicit little-endian canonical
serialization were otherwise consistent with the PC raw batch, the canonical
Geometry validators, and the decomp GX domains. The candidate correctly used
caller-owned scratch, ran standalone and dependency validation before publish,
and left output unchanged on the covered failures.

Material gaps:

1. Used `value_known` and `index_known` bytes were accepted when nonzero rather
   than required to equal exactly one.
2. Direct records did not require the raw producer's
   `value_source_index == 0` invariant, and inactive/unused record tails were
   not fully checked for the zero state established by the raw batch owner.
3. The fixture had a direct triangle and an indexed quad, but no direct-quad
   positive; it did not explicitly assert INDEX16 little-endian bytes; and it
   did not test exact or partial output/scratch overlap while preserving output
   bytes and `output_size`.

The repair remains owned by lane 216 in
`pc/src/pc_gx_geometry_producer.c` and
`pc/tests/pc_gx_geometry_producer_fixture.c`. It must not overconstrain VAT or
array metadata legitimately copied for inactive VCD slots by
`pc_gx_raw_geometry_begin_batch`.

## Evidence boundary

This is an independent read-only CPU/source-contract review. The worker's
reported native and combined ASan/UBSan `1/1` results were not rerun by the
reviewer. Nothing here proves a full link, launch, runtime callback, Metal
encode/present, pixel readback, device behavior, Windows execution, or
playability.
