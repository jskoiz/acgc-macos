# CARD production save validation — integrated 96ee5d61

Date: 2026-08-13 (Honolulu)

## Scope and provenance

The remote M3 Max CARD lane started from PC `a53b192247aab2c4f6e58b1f2dda41efdf8d1cad`
on `c1/lane-card-production-validation-m3` and returned
`65bee4f5dd16f21b466c0a90d09f83ab69974d89`. The integration owner reviewed the
three owned files and cherry-picked that commit onto canonical
`c1/macos-host-launch`, producing `96ee5d61`:

- `pc/src/pc_m_card.c`
- `pc/tests/pc_m_card_production_validation_fixture.c`
- `pc/CMakeLists.txt`

The ac-decomp reference was `master` at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.

## Two-upstream crosswalk

The PC port distinguishes the `Save_t` logical payload (`0x242A`) from the
`Save` CARD slot (`0x26000`). Before this lane it copied/checksummed only the
logical payload while validating the full slot and discarded the aligned tail
on load (`pc/src/pc_m_card.c`). The decomp's `mCD_SaveHome_bg_set_data`, load,
and repair paths checksum and copy the full `sizeof(Save)` slot
(`src/game/m_card.c:3316-3358,3817-3828,4880-4891`), using
`mFRm_ReturnCheckSum`/`mFRm_GetFlatCheckSum` in `src/game/m_flashrom.c:110-143`.

The fix preserves the full aligned slot and raw tail bytes, while applying
byte swapping only to the `Save_t` portion. Existing restart/corruption paths
remain covered.

## Verification

On integrated PC `96ee5d61`, using unique ignored roots:

```text
cmake -S upstream/ACGC-PC-Port/pc -B /private/tmp/acgc-integrated-card-96ee5d61-native -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 -DBUILD_TESTING=ON -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
cmake --build /private/tmp/acgc-integrated-card-96ee5d61-native --target acgc_pc_m_card_restart_corruption_fixture acgc_pc_m_card_production_validation_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-integrated-card-96ee5d61-native --output-on-failure --parallel 1 -R '^acgc_pc_m_card_(restart_corruption|production_validation)_fixture$'
```

Native focused result: `2/2` passed. The same two targets were rebuilt with
combined `-fsanitize=address,undefined -fno-omit-frame-pointer` in
`/private/tmp/acgc-integrated-card-96ee5d61-asan` and run serially with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; sanitizer result: `2/2`
passed with no ASan/UBSan diagnostics. Leak detection is disabled on this
Apple runtime, so no leak-free claim is made. `git diff --check` passed.

## Evidence boundary

This proves the production CARD save wire/tail transformation and synthetic
restart/corruption fixture behavior. It does not prove physical CARD hardware,
device persistence, full game launch, full `ac_pc` link, LLDB, Metal, pixels,
input, audible audio, simulator, or playability. The remote source worktree
and focused roots are retired only after holder-free checks; branch and commit
remain preserved. No ISO, ROM, or extracted asset was accessed or transferred.
