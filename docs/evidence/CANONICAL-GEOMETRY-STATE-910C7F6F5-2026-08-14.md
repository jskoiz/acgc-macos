# Canonical Geometry state integration evidence

Date: 2026-08-14

Lane: 174 / `01a002f3-0540-7361-875e-f9ccf4038788`

PC base: `251a010b8d6167d7dd90042934d8491d1c96b040`

Worker final: `8652e233da5519e831575fb12342f8b0e9102364`

Integrated PC final: `910c7f6f52` on `c1/macos-host-launch`

Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Integrated change

The integration owner reviewed and cherry-picked the worker chain one commit
at a time:

- `2b394943a9` — add the canonical Geometry section validator;
- `56ede5f1ff` — repair the fixed ABI and value validation; and
- `8652e233da` — reject post-Texgen fallback selectors and accept only zero
  final stream padding.

The integrated commits became `7623f6c77d`, `cd30badb4d`, and `910c7f6f52`.
The exact source scope is:

- `include/acgc/gx_canonical_geometry_state.h`;
- `src/gx_canonical_geometry_state.c`;
- `pc/portable/tests/test_gx_canonical_geometry_state.c`; and
- `pc/portable/CMakeLists.txt`.

The fixed-width section has a `0x30` header, 26 `0x40` descriptors, a `0x6B0`
prefix, and a bounded section-relative stream. Validation covers VTXFMT
`0..7`, exact VCD/VAT metadata, logical matrix IDs, canonical integer/color
values, finite binary32 values, overflow-safe extents, index bounds and
first-use remapping, zero reserved fields, zero alignment gaps, and zero final
padding. Geometry texture selectors accept only known ordinary IDs
`30,33,...,60`; post IDs `64...121` and `125` fail closed.

## Reference crosswalk

The PC port's `pc/src/pc_gx.c` retains primitive, VTXFMT, and committed-vertex
state but does not yet retain complete VCD/VAT provenance for a cumulative
producer. The two upstream `GXEnum.h` copies preserve the same `GX_VA_*`,
`GXAttrType`, component-count/type, position-matrix, and texture-matrix
domains. The decomp oracle in `src/static/dolphin/gx/GXAttr.c` supplies the
VCD/VAT width, NRM/NBT exclusivity, count/type/fraction, and attribute rules;
`GXGeometry.c` supplies the eight-VTXFMT and `GXBegin` contract.

## Independent review and exact integrated verification

An independent Luna Max/max review returned PASS with no candidate-owned
finding. It separately ran the focused Geometry test natively and under
combined ASan/UBSan, a C++11 header ABI probe, `clang --analyze`, and
`git diff --check`.

The integration owner then configured fresh roots on exact integrated PC
`910c7f6f52`:

```sh
cmake -S upstream/ACGC-PC-Port/pc/portable \
  -B /private/tmp/acgc-integrate-geometry-910c7f6-native \
  -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-geometry-910c7f6-native \
  --target acgc_gx_canonical_fog_state_tests \
           acgc_gx_canonical_envelope_tests \
           acgc_gx_canonical_blend_state_tests \
           acgc_gx_canonical_alpha_state_tests \
           acgc_gx_canonical_transform_state_tests \
           acgc_gx_canonical_geometry_state_tests \
           acgc_gx_canonical_depth_state_tests \
           acgc_gx_canonical_tev_state_tests --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-geometry-910c7f6-native \
  -R '^acgc_gx_canonical_(fog_state|envelope|blend_state|alpha_state|transform_state|geometry_state|depth_state|tev_state)_tests$' \
  --output-on-failure --parallel 1
```

Native CTest passed `8/8`. The same targets and CTest expression passed `8/8`
in `/private/tmp/acgc-integrate-geometry-910c7f6-asan` with combined
`-fsanitize=address,undefined`,
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1`, and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; no sanitizer diagnostic was
emitted. Leak detection was disabled, so this is not a leak-free claim.

## Evidence boundary

This proves the pointer-free CPU Geometry ABI and strict validator on the
integrated snapshot. It does not supply the missing PC VCD/VAT/run-metadata
producer, a cumulative canonical packet, Apple consumption, a full `ac_pc`
link, LLDB/runtime reachability, Metal encode/present/readback, a game-owned
pixel or frame, device behavior, or playability.
