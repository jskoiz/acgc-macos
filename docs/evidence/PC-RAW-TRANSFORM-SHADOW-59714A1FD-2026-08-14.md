# PC raw Transform shadow at `59714a1fd`

Date: 2026-08-14

Remote task: `01a002e0-0e90-7a01-8775-b09077214ab6`

References:

- Remote base: `037689462eaa08b1f08c24748276a0c82bf169c5`
- Remote commits: `523d34e1da6b438358bc9735abf756ad46628cd7`
  and `4fbdcd620091b044f4bb2d24b647f3207fde9165`
- Integrated PC commits: `4c3aeac40f` and `59714a1fd8`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Integrated source

The two reviewed commits change only:

- `pc/include/pc_gx_internal.h`
- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_transform_raw_shadow_fixture.c`
- `pc/CMakeLists.txt`

The setter-owned sideband retains the original pre-widescreen projection type
and six GX-consumed binary32 words, ten exact position 3x4 slots, ten exact
normal 3x3 slots, the current logical position-matrix ID, and explicit
knownness. Logical matrix IDs accept only `0,3,...,27`; host renderer `/3`
mapping and existing OpenGL behavior remain separate and unchanged. Immediate
setters update the raw state before existing equality/early-return paths.

`GXSetProjectionv` is represented from its decomp-defined type-plus-six-word
input. The PC port has no guest-memory owner capable of resolving indexed
matrix loads, so an indexed load zeroes and marks only its exact position or
normal slot unknown. A later finite immediate setter repairs only that exact
slot; malformed, nonfinite, and unrelated unresolved slots remain fail-closed.
This is current-state provenance rather than a permanently sticky call-history
flag.

## Verification

The M3 Max lane reported the focused Transform fixture `1/1` native and `1/1`
under combined ASan/UBSan, plus the existing raw-TEV regression `1/1`. The
available host could not provide a real MinGW/i686 toolchain; no Windows
runtime sign-off follows.

After cherry-picking the reviewed two-commit series onto canonical Depth tip
`c736f9686`, the integration owner ran:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-transform-59714-native \
  -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON \
  -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-transform-59714-native \
  --target acgc_pc_gx_transform_raw_shadow_fixture \
           acgc_pc_gx_tev_raw_shadow_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-transform-59714-native \
  -R '^acgc_pc_gx_(transform|tev)_raw_shadow_fixture$' \
  --output-on-failure --parallel 1
```

Result: `2/2` passed. The same matrix passed `2/2` in
`/private/tmp/acgc-integrate-transform-59714-asan` with combined ASan/UBSan,
leak detection disabled, and no sanitizer diagnostic. AppleClang emitted only
the already-known unsupported `-Wno-builtin-declaration-mismatch` option and
SDK/decomp `INT_MIN` redefinition warnings.

## Evidence boundary

This proves setter-owned CPU Transform provenance and fail-closed indexed-slot
repair behavior only. The frozen canonical `0x0002` value ABI is still not
implemented or produced, and no cumulative snapshot, Apple consumer, full
`ac_pc` link, LLDB trace, Metal encode/present/readback, pixel, device,
Windows runtime, or playability claim follows. Texture/post matrices and
manual SU state remain owned by the separate `0x0008` Texgen contract.
