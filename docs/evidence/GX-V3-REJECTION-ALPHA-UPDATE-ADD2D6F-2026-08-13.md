# GX V3 rejection: alpha-update gate

Date: 2026-08-13  
Lane: 104 (`019ffd46-3012-7460-b435-2afff25993c0`)  
PC base: `042cbf75fc136725769786443b40a1fd3ad82a7a`  
PC handoff: `c689a7318d5b8c6bb47bf492cd6376359044b768`  
Integrated PC: `add2d6f3b771744613fa91bfa52b43bf90be6d95`  
Decomp reference: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

## Finding

`pc_gx_flush_vertices()` reaches the V3 path after the V2 state gate rejects
the live blend/texture-matrix state. The V3 state predicate then fails closed
when `g_gx.alpha_update_enable == 0`, before the typed V3 callback is invoked.
The decomp initialization at `src/static/libforest/emu64/emu64.c:619` calls
`GXSetAlphaUpdate(GX_FALSE)`, matching the observed live state. The downstream
Apple consumer and `pc_metal_runtime_observe()` therefore remain at zero; this
is a builder rejection boundary, not evidence that the callback or Metal sink
ran.

The handoff adds only an opt-in Darwin compile-audit trace in
`pc/src/pc_gx.c`. Setting `ACGC_METAL_V3_REJECTION_TRACE=1` emits at most 64
records, labels the alpha-update predicate, and reports surrounding V3 state.
It does not alter the default path or Windows behavior.

## Cross-repository references

- PC `pc/src/pc_gx.c`: V2/V3 state gates, V3 builder, and callback dispatch.
- PC `pc/apple/src/metal_packet_consumer.c`: typed consumer is downstream of
  successful V3 builder output.
- PC `pc/apple/src/pc_metal_runtime.c`: runtime observer is downstream of the
  consumer preparation boundary.
- Decomp `src/static/libforest/emu64/emu64.c:619`: alpha updates are disabled
  during initialization.

## Verification

On the integrated `add2d6f` source snapshot:

```sh
cmake -S pc -B /private/tmp/acgc-integrate-v3-rejection-add2d6f-native \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-v3-rejection-add2d6f-native \
  --target acgc_pc_gx_semantic_handoff_tests \
           acgc_pc_gx_semantic_v2_handoff_tests \
           acgc_pc_gx_semantic_v3_handoff_tests -j1
ctest --test-dir /private/tmp/acgc-integrate-v3-rejection-add2d6f-native \
  --output-on-failure -R 'acgc_pc_gx_semantic_(handoff|v2_handoff|v3_handoff)_tests'
```

Native result: `3/3` passed. The same focused targets were rebuilt with
`-fsanitize=address,undefined -fno-omit-frame-pointer` and passed `3/3` under
`ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`.
No sanitizer diagnostics were emitted. Because leak detection was disabled,
this is not a leak-free claim.

The lane did not run a full `ac_pc` link, LLDB launch, Metal device test, or
runtime callback. There is no game-owned Metal encode/present/readback, pixel,
input, audio, save/device, simulator, or playability evidence. The separate
builder-to-consumer fixture lane owns the alpha-toggle test that remains next.
