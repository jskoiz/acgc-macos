# Token-scoped Texture/TLUT snapshot lease at `c91873521`

Date: 2026-08-22 (Pacific/Honolulu)

## Scope and pinned references

This record covers the reviewed Texture/TLUT/Dynamic borrow transaction and
its focused exact-merge verification.

- Umbrella integration base: `84b6bede5e02c6177f4d73c42bac0bd586a1d626`
- PC source base: `f77d5ec8696c90d8beedea622110260d65369177`
- Integrated PC commits: `00d06cc20336a18f8f9c0642db4082bd0374b50a`,
  `168d713baadc5935344c9ba4d593e379c5e9a03d`, and
  `f140aa1860a5ef55db838b751e8bdbc018ceba3a`
- Final PC source tip: `c91873521474057cb5faea8867a92a8122ff3e16`
- Decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- PC integration branch: `c1/macos-host-launch`

No ISO, extracted asset, key, proprietary data, full `ac_pc` link, LLDB, GUI,
Metal, device, or playability lane was used for this integration.

## Hosted source integration

[PC PR #5](https://github.com/jskoiz/ACGC-PC-Port/pull/5), “Require
token-scoped Texture/TLUT snapshot leases,” merged the reviewed three-commit
chain into `c1/macos-host-launch` as
`c91873521474057cb5faea8867a92a8122ff3e16`.

The hosted diff contains exactly these five files:

- `pc/include/pc_gx_texture_raw_state.h`
- `pc/src/pc_gx.c`
- `pc/src/pc_gx_canonical_snapshot.c`
- `pc/src/pc_gx_texture.c`
- `pc/tests/pc_gx_texture_dynamic_producer_fixture.c`

The diff is 854 insertions and 24 deletions. The repository has no GitHub
workflow files, so this PR had no hosted CI result. Local focused proof and the
hosted merge are therefore recorded separately.

## Contract integrated

The final API requires the caller to begin one borrow with a zero-initialized
`PCGXTextureRawBorrow`, keep that exact token address active while reading the
returned Texture/TLUT lease, revalidate the pointer-free raw capture and every
selected resource, then end the same token. Copying a token does not transfer
release authority, a token cannot be reused, and a second borrow cannot enter
while one is active.

`pc_gx_build_texture_dynamic_snapshot_borrowed` no longer begins and ends a
hidden local borrow. It accepts an already-active caller token and returns the
canonical Texture and Dynamic values, a pointer-free raw capture, and the
matching pointer-bearing lease without retaining any of them. All outputs are
staged and remain unchanged on failure.

The existing synchronous callback wrapper owns its token for the full callback,
revalidates immediately afterward, and then releases it. Guarded raw Texture,
TLUT, callback-registration, and known `GXCopyTex` mutation paths fail closed
while borrowed. The supported contract is single-threaded and synchronous;
arbitrary direct writes through a borrowed byte pointer and concurrent mutation
are explicitly outside the contract, and no lease pointer may survive release.

The independent final review returned PASS with no P0, P1, or P2 findings after
the original candidate was corrected for exact-token release authority,
mutation coverage, and the unsafe public auto-borrowing builder lifetime.

## Two-upstream crosswalk

The PC host/Windows oracle provides the ownership and publication boundary:

- `pc/include/pc_gx_texture_raw_state.h` defines pointer-free raw Texture/TLUT
  state, the pointer-bearing dynamic lease, the caller-owned borrow token, and
  the explicit borrowed builder contract.
- `pc/src/pc_gx_texture.c` owns raw state, generations/epochs, resource leases,
  exact-token acquisition/release/revalidation, and guarded mutation paths.
- `pc/src/pc_gx_canonical_snapshot.c` builds canonical Texture/Dynamic values
  during an active borrow and owns the synchronous callback transaction.
- `pc/src/pc_gx.c` rejects the known copy-to-texture write path while the
  transaction is borrowed.
- `pc/tests/pc_gx_texture_dynamic_producer_fixture.c` covers valid publication,
  copied/stale/wrong-token release, nested borrow rejection, guarded writers,
  callback re-entry, output immutability, and generation/address revalidation.

The decomp oracle grounds guest Texture/TLUT behavior in
`src/static/dolphin/gx/GXTexture.c` and its callers, including texture object
initialization/loading, TLUT loading, invalidation, and copy-texture paths.
The token, generation/epoch sideband, host pointer lease, and callback
transaction are host ownership mechanisms and have no direct decomp
counterpart.

## Focused verification

The integration owner first repeated the native and combined ASan/UBSan target
gate on the reviewed pre-merge integration snapshot. After PR merge, a detached
worktree at exact `c91873521` received fresh native and sanitizer build roots.

Native exact-merge gate:

```sh
cmake -S pc -B /private/tmp/acgc-merged-260-native -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build /private/tmp/acgc-merged-260-native \
  --target acgc_pc_gx_texture_dynamic_producer_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-merged-260-native -N \
  -R '^acgc_pc_gx_texture_dynamic_producer_fixture$'
ctest --test-dir /private/tmp/acgc-merged-260-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_texture_dynamic_producer_fixture$'
```

Discovery found exactly one test and execution passed `1/1`.

Combined ASan/UBSan exact-merge gate:

```sh
cmake -S pc -B /private/tmp/acgc-merged-260-asan-ubsan -G Ninja \
  -DPC_DARWIN_COMPILE_AUDIT=ON -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-merged-260-asan-ubsan \
  --target acgc_pc_gx_texture_dynamic_producer_fixture --parallel 1
ctest --test-dir /private/tmp/acgc-merged-260-asan-ubsan -N \
  -R '^acgc_pc_gx_texture_dynamic_producer_fixture$'
ctest --test-dir /private/tmp/acgc-merged-260-asan-ubsan \
  --output-on-failure --parallel 1 \
  -R '^acgc_pc_gx_texture_dynamic_producer_fixture$'
```

Discovery found exactly one test and execution passed `1/1` in 0.08 seconds,
with no ASan or UBSan finding. Existing decomp-header and unsupported-warning
diagnostics remained compile warnings rather than sanitizer or test failures.

## Evidence boundary and next blocker

This proves the reviewed source contract, focused fixture behavior, hosted
source merge, and exact-merge native plus combined ASan/UBSan execution. It does
not prove a full production `ac_pc` link, a cumulative fourteen-section
assembler, flush publication, callback delivery from a cumulative gatherer,
Metal encode/present/readback, a pixel, input, audio, save/reload, lifecycle,
iOS, or playability.

The next dependency-ready source integration is the independently reviewed
pure cumulative envelope assembler and its focused CMake/CTest gate. Production
producer membership, live gathering, flush invocation, and the typed Apple CPU
consumer remain later serialized lanes.
