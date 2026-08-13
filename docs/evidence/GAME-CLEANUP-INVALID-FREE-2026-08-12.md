# Game Cleanup LP64 Invalid-Free Evidence

This record closes the post-GX termination fault boundary without claiming a
rendered frame, audible audio, input, save/reload, device, or playability gate.
The source fix is in the owning `upstream/ACGC-PC-Port` history; this file is
umbrella evidence only.

## Source and crosswalk

- PC-port base: `c1/macos-host-launch` at `d1575f0`.
- Worker branch and commit: `c1/lane-game-cleanup-invalid-free` at `5f56b88`.
- Integrated PC-port tip: `c1/macos-host-launch` at `09dd182`.
- Decomp oracle: `upstream/ac-decomp` `master` at `09ca8e8b`.
- Worker-owned source paths: `src/game/m_field_make.c` and
  `pc/tests/m_field_cleanup_invalid_free_fixture.c`.
- The related call chain is `mFM_MakeField` → `mFM_Field_dt` →
  `play_cleanup` → `game_dt` → `graph_proc`. The decomp allocator oracle is
  `src/static/libc64/__osMalloc.c`; the PC-port caller previously rounded each
  allocation through guest-width `u32` before later freeing it.

The worker reproduced the pre-fix arm64 fault in
`__osFree_NoLock` → `zelda_free` → `mFM_Field_dt:1370` during TERM cleanup.
The fix requests 16-byte alignment through `zelda_malloc_align` and retains
the allocator-returned pointer, removing the `u32` round-trip. The focused
fixture records the legacy truncation and checks that the allocator accepts its
exact aligned return value.

## Exact integrated verification

All commands below ran from the umbrella checkout after cherry-picking the
worker commit into `upstream/ACGC-PC-Port` at `09dd182`. Full links were
serialized; generated output remained under `/private/tmp`.

```sh
cmake -S upstream/ACGC-PC-Port/pc \
  -B /private/tmp/acgc-integrate-game-cleanup-09dd182 \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-integrate-game-cleanup-09dd182 \
  --target ac_pc --parallel 1
```

Result: `100% Built target ac_pc`; the arm64 Mach-O link covered the full
4,011-object target. The bounded supervisor then launched that exact binary
through the ignored local ISO symlink, reached `[LOGO]` action 3 and
`[NEOS_OUT]` frame 541, remained alive for ten seconds, and returned
`INTEGRATED_WAIT_STATUS=0` after `SIGTERM` within the two-second grace period.

The focused fixture was compiled from the same integrated source with Apple
Clang and the real `src/static/libc64/__osMalloc.c` allocator. The exact
compile/run sequence was:

```sh
src=/Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port
root=/private/tmp/acgc-integrate-game-cleanup-09dd182/fixture
flags=(-std=c11 -O2 -fno-strict-aliasing -fwrapv -DVERSION=0 \
  -DTARGET_PC -DPC_DARWIN_COMPILE_AUDIT=1 -D_LANGUAGE_C -Dnullptr=NULL \
  -I"$src/include" -I"$src/pc/include" -I"$src/pc/portable/include" \
  -I"$src/pc/lib/glad/include" -I"$src/pc/lib/fixnes")
/usr/bin/clang "${flags[@]}" \
  "$src/pc/tests/m_field_cleanup_invalid_free_fixture.c" \
  "$src/src/static/libc64/__osMalloc.c" -o "$root/native"
"$root/native"
/usr/bin/clang "${flags[@]}" -fsanitize=address,undefined \
  -fno-omit-frame-pointer \
  "$src/pc/tests/m_field_cleanup_invalid_free_fixture.c" \
  "$src/src/static/libc64/__osMalloc.c" -o "$root/asan-ubsan"
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1 \
  UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 "$root/asan-ubsan"
/usr/bin/clang "${flags[@]}" -fsanitize=undefined \
  -fno-omit-frame-pointer \
  "$src/pc/tests/m_field_cleanup_invalid_free_fixture.c" \
  "$src/src/static/libc64/__osMalloc.c" -o "$root/ubsan"
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 "$root/ubsan"
```

Results: native `PASS`, ASan+UBSan `PASS`, UBSan `PASS`. The worker's separate
`detect_leaks=1` probe reported Apple's unsupported leak detector; that
toolchain limitation is not a product failure.

## Evidence boundary and next gate

This closes the reproduced invalid-free and proves bounded launch plus clean
TERM cleanup at `09dd182`. It does not prove Metal encode/present or pixel
readback, running-game input, reconstructed mixer-to-CoreAudio audibility,
Save_t/GCI restart persistence, simulator/device behavior, or human
playability. The next useful lane is the first game-owned GX-to-Metal
submission/encode/present/readback proof; no additional worker is opened until
that dependency is concrete.
