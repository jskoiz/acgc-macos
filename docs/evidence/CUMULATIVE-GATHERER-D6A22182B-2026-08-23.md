# Cumulative GX gatherer integration at `d6a22182b`

Date: 2026-08-23 (Pacific/Honolulu)

## Result

PASS for the bounded gatherer milestone. PC PR
[#13](https://github.com/jskoiz/ACGC-PC-Port/pull/13) merged the independently
reviewed Lane 305 source commit `ac4237eec9e16217fcba0a49ad9838fe4b097a60`
onto canonical base `670d7128fbb2295d266c175e1f7bedecc6f6b39c` as
`d6a22182b2aebdab5da06e3b874788097af0f010`.

The exact merge snapshot passes the focused gatherer gate in fresh native and
combined ASan/UBSan trees and completes a serialized production `ac_pc` link.
This proves production compilation and link availability plus the focused
value/ownership contract. It does not prove invocation from
`pc_gx_flush_vertices`, legacy GL execution, process launch, Apple/Metal
consumption, a pixel, a device, or playability.

## Exact source scope

The merge changes exactly four PC-port paths, with 1,029 insertions and no
deletions:

- `pc/CMakeLists.txt`
- `pc/include/pc_gx_cumulative_gatherer.h`
- `pc/src/pc_gx_cumulative_gatherer.c`
- `pc/tests/pc_gx_cumulative_gatherer_fixture.c`

The source is part of the existing unconditional `acgc_pc_gx_production`
OBJECT target. No `pc_gx.c` flush call, Apple parser/consumer, renderer, or
Metal file changes in this merge.

## Contract proved by the focused fixture

`pc_gx_cumulative_snapshot_gather` consumes a caller-supplied completed raw
Geometry batch and caller-owned `PCGXCumulativeSnapshotStorage`. It:

1. derives canonical Transform, Channels, Texgen, Lighting, Geometry, Texture,
   TEV, Blend, Alpha, Depth, Raster, Fog, Indirect, and Dynamic state;
2. holds one exact Texture/TLUT borrow across Texture/Dynamic construction,
   explicit encoding, final revalidation, envelope assembly, and the
   synchronous callback;
3. explicitly little-endian encodes all fourteen sections in canonical ID
   order;
4. assembles one pointer-free envelope with the existing 76,092-byte maximum;
5. publishes only through a registered envelope-only callback; and
6. ends the exact borrow token on every post-acquire exit path.

The reusable caller-owned storage is approximately 213 KiB and avoids heap and
large-stack ownership. Registration, clearing, and nested gather attempts fail
closed during the active borrow. Failed Geometry/producer/encoder/borrow/
assembly paths do not publish and preserve the previously committed envelope
metadata. The callback is synchronous and must copy bytes it wants to retain.

The focused fixture prints this boundary:

> production raw builders, explicit little-endian encoders, fourteen-section
> assembly, synchronous envelope-only callback, registration fail-closed
> behavior, Geometry failure immutability, and Texture/TLUT borrow cleanup/reuse;
> no flush insertion, legacy GL, renderer, Metal, device, or playability claim

## Independent review and integration

Lane 308 reviewed the immutable candidate and returned PASS with no P0/P1
blocker. It checked all fourteen section encodings, Geometry dependency order,
one-borrow lifetime, callback-time fail-closed operations, cleanup/reuse, and
failure immutability. A non-blocking documentation note remains: under the
documented exact-token, single-threaded guarded-API contract, ending the token
after the callback is deterministic because the callback never receives the
token or resource pointers.

PR #13 had no hosted status checks and the PC repository has no GitHub Actions
workflow at this tip. The integration owner verified the remote canonical branch
points to the merge commit before running post-merge gates.

## Exact post-merge verification

Source worktree:

```text
/private/tmp/acgc-integrator-gatherer-merged
HEAD d6a22182b2aebdab5da06e3b874788097af0f010
detached and clean
```

Native root:

```text
/private/tmp/acgc-gatherer-merged-native-20260823
```

Combined ASan/UBSan root:

```text
/private/tmp/acgc-gatherer-merged-asan-ubsan-20260823
```

Both caches record the exact source directory
`/private/tmp/acgc-integrator-gatherer-merged/pc`, `BUILD_TESTING=ON`,
`PC_DARWIN_COMPILE_AUDIT=ON`, and Debug configuration. The sanitizer root adds
AddressSanitizer and UndefinedBehaviorSanitizer compile/link flags with frame
pointers.

Commands:

```text
cmake -S /private/tmp/acgc-integrator-gatherer-merged/pc \
  -B /private/tmp/acgc-gatherer-merged-native-20260823 \
  -G Ninja -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug

cmake --build /private/tmp/acgc-gatherer-merged-native-20260823 \
  --target acgc_pc_gx_cumulative_gatherer_fixture --parallel 1

ctest --test-dir /private/tmp/acgc-gatherer-merged-native-20260823 -N \
  -R '^acgc_pc_gx_cumulative_gatherer_fixture$'

ctest --test-dir /private/tmp/acgc-gatherer-merged-native-20260823 \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_cumulative_gatherer_fixture$'
```

Native result: exactly one discovered test (`#37`), `1/1` passed in 0.01
seconds.

The sanitizer configure used:

```text
-DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer -O1'
-DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer -O1'
-DCMAKE_OBJC_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer -O1'
-DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
-DCMAKE_SHARED_LINKER_FLAGS='-fsanitize=address,undefined'
```

The same focused target and exact CTest regex were then run with
`ASAN_OPTIONS=detect_leaks=0:halt_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`.

Sanitizer result: exactly one discovered test (`#37`), `1/1` passed in 0.09
seconds. `LastTest.log` contains no AddressSanitizer,
UndefinedBehaviorSanitizer, runtime-error, ERROR, or FAILED diagnostic. Leak
detection was disabled, so this is not a leak-freedom claim.

Production link:

```text
cmake --build /private/tmp/acgc-gatherer-merged-native-20260823 \
  --target ac_pc --parallel 1
```

The serialized build exited zero after its 4,025-item Ninja plan and linked
`bin/AnimalCrossing`. `file` reports a 64-bit arm64 Mach-O executable; its exact
size is 15,213,680 bytes. `nm -gU` finds both
`_pc_gx_cumulative_snapshot_gather` and
`_pc_gx_cumulative_snapshot_assemble`. The only final-link diagnostic was the
existing warning that `__DATA,__common` alignment was reduced from `0x8000` to
the Mach-O segment maximum `0x4000`.

The Xcode hygiene dry-run reported 651 candidates, 0 KiB potential cleanup, and
0 errors. It was read-only; nothing was deleted.

## Two-upstream crosswalk

Host/Windows oracle and implementation:

- `pc/src/pc_gx_cumulative_gatherer.c` and its public header own the new pure
  CPU gather/publication contract.
- `pc/src/pc_gx_cumulative_snapshot.c` owns the existing immutable envelope
  assembler.
- `pc/src/pc_gx_texture.c`, `pc/src/pc_gx_canonical_snapshot.c`, and
  `pc/include/pc_gx_texture_raw_state.h` own the exact-token Texture/TLUT
  borrow and snapshot lifetime.
- raw owners, standalone producers, and explicit encoders supply the fourteen
  section values; `pc/CMakeLists.txt` is the production membership authority.
- `pc/src/pc_gx.c` still only captures completed Geometry and invokes the older
  Texture/Dynamic-only publication at the flush boundary. It does not call the
  cumulative gatherer at this tip.

Original behavior and wire/layout oracle remains exact decomp commit
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. Relevant GX behavior is in
`GXAttr.c`, `GXGeometry.c`, `GXVert.c`, `GXTransform.c`, `GXLight.c`,
`GXTexture.c`, `GXTev.c`, `GXPixel.c`, and `GXBump.c`, with their corresponding
headers and game callers. The host cumulative envelope, exact-token resource
lease, callback, gatherer, and CMake topology have no direct decomp counterpart.

## Proof boundary and next gate

Proved:

- exact PR merge and four-path source scope;
- production-object compilation and final executable symbol resolution;
- all-section production, explicit encoding, one-borrow assembly, synchronous
  callback, failure immutability, and cleanup/reuse in the focused fixture;
- exact native and combined ASan/UBSan focused execution.

Not proved:

- a call from `pc_gx_flush_vertices` or a real `GXBegin`/`GXEnd` flush fixture;
- execution of the unchanged legacy GL continuation;
- process launch, Apple parsing/typed plan, Metal encode/present/readback,
  pixels, input, audio, save/load, lifecycle, iOS, device, or playability.

Lane 309 returned READY for the smallest successor: one source-edit lane owning
only `pc/src/pc_gx.c`, a real source-backed cumulative flush fixture, and its
CMake gate. It must attempt one gather immediately after completed Geometry
capture, remove the older live Texture/Dynamic-only flush publication, ignore
gather failure for rendering control flow, and preserve all existing observer,
semantic, profiler, and legacy GL ordering. Lane 310 owns that bounded gate.
