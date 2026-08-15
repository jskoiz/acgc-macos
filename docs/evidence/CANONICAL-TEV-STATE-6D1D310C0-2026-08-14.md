# Canonical TEV state at `6d1d310c0`

Date: 2026-08-14

## Provenance

- Canonical PC commit: `6d1d310c0dd13778a44944e0371379fc30b1b24a`
- Reviewed worker commit: `4862aa651f4dd12ca7fb16e0201bd3ad73965001`
- Worker branch: `c1/lane-canonical-tev-m3`
- Worker base: `f2b7ab153aaeef037cc1fca3ecdc98acbf50ad82`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Remote task: `01a002d3-e737-76c1-8349-fc4e003fc0b9`

The integration owner independently reviewed the four-file source delta and
cross-checked the TEV enum domains and setter behavior against the populated
`ac-decomp` checkout before cherry-picking it onto the canonical PC branch.

## Result

The portable CPU contract now implements section ID 6 / mask `0x0020` as a
fixed 2,560-byte value section:

- a 64-byte header;
- sixteen 144-byte logical stage records;
- four 16-byte signed-S10 PREV/REG0-2 records;
- four 16-byte widened-u8 KONST records; and
- four 16-byte swap-table records.

The ABI uses fixed-width words, has static size/offset/alignment assertions,
requires exact version/count/capacity/offset metadata, rejects selector and
indirect-matrix holes, requires zero inactive and reserved records, and bounds
all GX values against the decomp enums. The common envelope remains unchanged.

Compare operations preserve the logical arguments passed to
`GXSetTevColorOp` and `GXSetTevAlphaOp`. They are not a byte-for-byte BP
register image: the decomp's later BP encoding ignores caller bias/scale for
compare operations and derives the packed compare bits from the operation.
Any producer or renderer transform must keep this distinction explicit.

Cross-section relationships between TEV texture/texgen/channel/indirect
references and the other canonical sections remain the responsibility of the
future cumulative snapshot validator. This section validator proves only the
standalone value domain and exact section metadata.

## Exact source delta

- `include/acgc/gx_canonical_tev_state.h`
- `src/gx_canonical_tev_state.c`
- `pc/portable/tests/test_gx_canonical_tev_state.c`
- `pc/portable/CMakeLists.txt`

No `pc_gx`, legacy V1-V4 packet, Apple/Metal, shader, decomp, or runtime source
changed in this lane.

## Verification

The remote worker reported focused native and combined ASan/UBSan CTest `1/1`
passes, plus C and C++ `_WIN32` syntax/ABI probes. The integration owner then
used fresh local roots on the exact canonical commit:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-integrate-canonical-tev-6d1d310-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-canonical-tev-6d1d310-native \
  --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-canonical-tev-6d1d310-native \
  -R '^acgc_gx_canonical_(fog_state|envelope|blend_state|alpha_state|tev_state)_tests$' \
  --output-on-failure --parallel 1
```

Native passes `5/5`. The same exact matrix passes `5/5` under combined
AddressSanitizer and UndefinedBehaviorSanitizer with
`ASAN_OPTIONS=detect_leaks=0` and `UBSAN_OPTIONS=halt_on_error=1`; no sanitizer
diagnostic was emitted. Leak detection was disabled, so this is not leak-free
proof. Existing unrelated AppleClang warnings remain outside this lane.

## Evidence boundary

This proves only the portable TEV CPU ABI, validator, and fixture on the
integrated source snapshot. The independently integrated PC raw TEV shadow is
a prerequisite, but no cumulative producer joins the two yet. There is no
live canonical packet, callback, Apple consumption, Metal encode, present,
readback, pixel, input, audio, save/reload, device, iOS, Windows runtime, or
playability proof.
