# Texture/TLUT/TEV packet fixtures — integrated 894ac5f8

Date: 2026-08-13 (Honolulu)

## Scope and provenance

The remote M3 Max fixture lane started from PC
`a53b192247aab2c4f6e58b1f2dda41efdf8d1cad` on
`c1/lane-texture-tev-fixtures-m3` and returned
`24fbf2f65a051e04955aef8708f05131a4a6a9e0`. The integration owner
cherry-picked it onto canonical `c1/macos-host-launch`, producing `894ac5f8`.
The exact owned files are `pc/tests/pc_gx_texture_tev_packet_fixture.c` and
minimal `pc/CMakeLists.txt` registration. The ac-decomp reference was `master`
at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

## Two-upstream crosswalk

The fixture exercises the PC V2 texture-generator/TLUT and TEV validators
(`v2_texture_generator_is_valid`, `v2_texture_format_uses_tlut`, and
`v2_tev_stage_is_valid`). Decomp counterparts are the generic GX APIs
`GXSetNumTexGens`, `GXSetTexCoordGen2`, `GXInitTexObj`, `GXInitTexObjCI`,
`GXInitTlutObj`, `GXLoadTlut`, `GXSetTev*`, `GXSetTevOrder`, and
`GXSetNumTevStages`, with representative CI/TLUT and one-/two-stage callers in
`emu64.c` and `JUTResFont.cpp`. No decomp semantic-packet counterpart exists;
indirect GX APIs are also outside this fixture's V2 packet proof.

## Verification

On integrated PC `894ac5f8`, with unique ignored roots:

```text
cmake -S upstream/ACGC-PC-Port/pc -B /private/tmp/acgc-integrated-texture-tev-894ac5f8-native -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
cmake --build /private/tmp/acgc-integrated-texture-tev-894ac5f8-native --target acgc_pc_gx_texture_tev_packet_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrated-texture-tev-894ac5f8-native --output-on-failure --parallel 1 -R '^acgc_pc_gx_texture_tev_packet_fixture$'
```

Native result: `1/1` passed. The same target was rebuilt with combined
`-fsanitize=address,undefined -fno-omit-frame-pointer` in
`/private/tmp/acgc-integrated-texture-tev-894ac5f8-asan` and run with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; sanitizer result: `1/1`
passed with no diagnostics. Leak detection is disabled on this Apple runtime;
`git diff --check` passed.

## Evidence boundary

This proves synthetic CPU texture/TLUT/TEV packet validation only. It does not
prove live callbacks, Metal encoding/presentation, texture upload, a rendered
frame, pixel readback, device behavior, input, audio, save/device persistence,
simulator, or playability. The remote source worktree and focused roots are
retired only after holder-free checks; branch and commit remain preserved. No
ISO, ROM, or extracted asset was accessed or transferred.
