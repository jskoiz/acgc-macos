# PC Depth flush-order repair

Date: 2026-08-14

## Provenance

- ACGC-PC-Port base: `1d48691a4fc5f672951d02815723672b2928602e`
- M3 Max worker branch: `c1/lane-depth-flush-order-m3`
- M3 Max worker commit: `a2cbfda07e8ccf952037306dde54ace26f28d64f`
- Canonical integration branch: `c1/macos-host-launch`
- Canonical integration commit: `9f149b6fd99947795e9ba806a61359176e4517f1`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Source-only worker bundle SHA-256:
  `de2f34795e33a139a0dbdcc8f2ee8520b6617093ddb611ee6d419a8e7713774c`

The worker and integrated commits have the same parent and source tree. The
integration owner reviewed and cherry-picked the worker commit locally. No ISO,
extracted asset, key, or proprietary game-data path was read, copied, or added
to Git.

## Exact change

The commit changes exactly four ACGC-PC-Port files:

- `pc/CMakeLists.txt`
- `pc/include/pc_gx_internal.h`
- `pc/src/pc_gx.c`
- `pc/tests/pc_gx_depth_raw_shadow_fixture.c`

`GXSetZMode` now calls `pc_gx_flush_if_begin_complete()` before either the
setter-owned raw Depth shadow or the legacy effective `z_*` state changes. A
completed old batch therefore observes the old raw and effective Depth state at
the existing synchronous `pc_gx_flush_vertices()` boundary. After that flush,
the new raw triple is captured, the legacy equality fast path is preserved, and
a changed effective triple still sets `PC_GX_DIRTY_DEPTH`.

The added observer is compiled only into
`acgc_pc_gx_depth_raw_shadow_fixture`. It returns `void`, cannot cancel the
flush, runs immediately before the normal packet/OpenGL snapshot work, and is
not present in the other raw-state fixture targets.

The focused regression proves:

- the observer sees the old raw and effective Depth triple;
- the normal flush continues;
- the new raw and effective triple is installed afterward;
- a changed value dirties Depth while an exact repeat does not;
- nonzero `GXBool` values retain the existing effective normalization;
- malformed compare-function provenance still fails closed without replacing
  the prior legacy host value; and
- Transform, TEV, and Texgen raw shadows remain untouched.

## Two-upstream crosswalk

- PC host behavior and the repaired ordering:
  `pc/src/pc_gx.c`, `GXSetZMode`, `pc_gx_raw_depth_store`,
  `pc_gx_flush_if_begin_complete`, and `pc_gx_flush_vertices`.
- PC value layout and test boundary:
  `pc/include/pc_gx_internal.h`, `PCGXRawDepth`, and
  `pc/tests/pc_gx_depth_raw_shadow_fixture.c`.
- Original game semantics:
  ac-decomp `src/static/dolphin/gx/GXPixel.c`, `GXSetZMode`, which writes
  compare-enable, compare-function, and update-enable at the GX command
  boundary.

No ac-decomp edit is required. The observer has no decomp counterpart; it is a
test-only way to inspect the existing synchronous PC flush boundary.

## Review and integrated verification

An independent Luna Max/max review returned PASS with no candidate-owned
finding. It confirmed temporal ordering, fixture non-interception, malformed
input behavior, ABI/static probes, and the absence of unrelated setter or
OpenGL changes. `git diff --check` also passed.

The integration owner then configured fresh roots on exact canonical PC
`9f149b6fd9`:

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-depth-9f149b6-native \
  -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-depth-9f149b6-native \
  --target acgc_pc_gx_transform_raw_shadow_fixture \
           acgc_pc_gx_depth_raw_shadow_fixture \
           acgc_pc_gx_tev_raw_shadow_fixture \
           acgc_pc_gx_texgen_raw_shadow_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrate-depth-9f149b6-native \
  -R '^acgc_pc_gx_(transform|depth|tev|texgen)_raw_shadow_fixture$' \
  --output-on-failure --no-tests=error --parallel 1
```

Native CTest passed `4/4`. The same targets and expression passed `4/4` in
`/private/tmp/acgc-integrate-depth-9f149b6-asan` with combined
`-fsanitize=address,undefined`,
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1`, and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. No sanitizer diagnostic was
emitted. Leak detection was disabled, so this is not a leak-free claim.

Diagnostics were limited to the known experimental Darwin compile-frontier
warning, the decomp/SDK `INT_MIN` macro redefinition, and AppleClang's existing
unsupported `-Wno-builtin-declaration-mismatch` warning.

The M3 lane also passed bounded `-m32` syntax checks. `_WIN32` and a real
Windows runtime remain blocked by the absent Windows headers, sysroot, and
MinGW toolchain, so this is not Windows sign-off.

## Evidence boundary

This proves source ordering, old-versus-new Depth snapshot separation,
setter-owned raw/effective behavior, fixture-only observation, native execution,
and combined ASan/UBSan execution on the integrated snapshot. It does not prove
a full `ac_pc` link, game launch, live cumulative producer, Apple callback,
OpenGL visual output, Metal encode/present/readback, a game-owned pixel or
frame, input, audio, save/reload, device behavior, Windows runtime, iOS, or
playability.
