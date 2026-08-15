# Canonical GX Texture/TLUT and Dynamic value ABIs

Date: 2026-08-14

## Provenance

- ACGC-PC-Port worker base: `43992e708572e325f525d3ccdbec7a84793d352d`
- M3 Max worker branch: `c1/lane-canonical-texture-dynamic-m3`
- Initial worker commit: `b8245ad01917f07d5faaf9616dfb35fd25363be0`
- Reviewed filter-domain repair: `096e76c4642137a98df12a608fd3b79804bea947`
- Canonical integration branch: `c1/macos-host-launch`
- Initial canonical integration: `cf81b028d90d0dcf05fdb69bd66b2a353c8f2782`
- Final canonical integration: `a641e55efb1d5141f12df425605e3e66522a710a`
- ac-decomp oracle: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`
- Repaired source-only bundle SHA-256:
  `353f70e61e3d309a9d7f5c978e2f4f392d1a840e56dce6e46997eb354451eb57`

The M3 Max worker commit was imported through a source-only Git bundle and
reviewed in isolated local worktrees. Independent review rejected the initial
candidate because it accepted impossible effective magnification-filter
values `2..5`; the child repair split the final logical minification and
magnification domains before either commit was integrated. The integration
owner cherry-picked the two reviewed commits one at a time onto the canonical
PC branch. No ISO, extracted asset, key, or proprietary game-data path was
read, copied, or added to Git.

## Exact change

The integrated source change owns exactly:

- new `include/acgc/gx_canonical_texture_state.h`;
- new `include/acgc/gx_canonical_dynamic_state.h`;
- new `src/gx_canonical_texture_state.c`;
- new `src/gx_canonical_dynamic_state.c`;
- new `pc/portable/tests/test_gx_canonical_texture_state.c`;
- new `pc/portable/tests/test_gx_canonical_dynamic_state.c`; and
- minimal `pc/portable/CMakeLists.txt` library/test registration.

It implements two fixed-width, pointer-free value contracts:

- Texture section ID `5`, mask `0x0010`, version `1`, size `1216`, header
  `64`, eight records of `144` bytes, and alignment `4`; and
- Dynamic section ID `14`, mask `0x2000`, version `1`, size `1600`, header
  `64`, twenty-four records of `64` bytes, and alignment `4`.

The Texture contract represents eight map slots with stable logical image and
TLUT identities, owner epochs, generations, tiled byte extents, dimensions,
format, wrap, LOD/filter, anisotropy, and indexed-palette metadata. The Dynamic
contract represents eight image and sixteen TLUT resources with availability,
lifetime, generation, owner epoch, byte extent, and synchronous external-lease
metadata. Neither contract carries a host pointer, GL name, resource byte, or
cache hash.

Validation fails closed on non-exact envelope metadata, reserved or inactive
state, invalid map/TLUT identities, generation or owner-epoch mismatch,
unavailable required resources, byte-size overflow, invalid tiled mip extents,
and malformed cross-section masks. Arbitrary valid TLUT slots are mapped by
logical ID rather than by map index. Effective minification values are exactly
`0..5`; effective magnification values are exactly `0..1`. This matches the
decomp normalization rather than preserving impossible caller enum values.

## Two-upstream crosswalk

- `upstream/ac-decomp/src/static/dolphin/gx/GXTexture.c` defines tiled image
  sizing, mip iteration, `GXTexObj`/`GXTlutObj` setup, 32-byte TLUT alignment,
  and TLUT loading. `GXInitTexObjLOD` stores magnification as
  `(mag_filt == GX_LINEAR) ? 1 : 0` while retaining the six effective
  minification states.
- `upstream/ACGC-PC-Port/pc/include/pc_gx_internal.h` and
  `pc/src/pc_gx_texture.c` define the current eight-map metadata, sixteen TLUT
  slots, source sizing, invalidation, generation, and flush-before-clear
  behavior. Existing `GXTexObj`, `GXTlutObj`, borrowed pointers, and GL
  resources remain outside the neutral ABI.
- Dynamic has no one-to-one upstream struct. It is the explicit pointer-free
  sideband projection of the resource ownership and lifetime facts needed by a
  later synchronous renderer-neutral handoff.

Raw PC Texture/TLUT provenance, generation/invalidation capture, synchronous
lease acquisition, cumulative packet production, and the Apple resource
consumer remain separately owned gates.

## Verification

Independent review passed `git diff --check`, fixed-size ABI and offset probes,
`clang --analyze`, C11 and C++11 header probes, bounded `-m32` syntax, and the
available `i686-pc-windows-msvc` C/header syntax probes. A real Windows
linker/runtime was not available.

Fresh exact-integrated commands:

```sh
cmake -S pc/portable \
  -B /private/tmp/acgc-integrate-texture-dynamic-a641-native \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON
cmake --build /private/tmp/acgc-integrate-texture-dynamic-a641-native \
  --parallel 4 \
  --target acgc_gx_canonical_envelope_tests \
           acgc_gx_canonical_fog_state_tests \
           acgc_gx_canonical_blend_state_tests \
           acgc_gx_canonical_alpha_state_tests \
           acgc_gx_canonical_transform_state_tests \
           acgc_gx_canonical_geometry_state_tests \
           acgc_gx_canonical_depth_state_tests \
           acgc_gx_canonical_tev_state_tests \
           acgc_gx_canonical_channel_state_tests \
           acgc_gx_canonical_lighting_state_tests \
           acgc_gx_canonical_dynamic_state_tests \
           acgc_gx_canonical_texture_state_tests
ctest --test-dir /private/tmp/acgc-integrate-texture-dynamic-a641-native \
  --output-on-failure --parallel 1 \
  -R '^acgc_gx_(canonical_envelope|canonical_fog_state|canonical_blend_state|canonical_alpha_state|canonical_transform_state|canonical_geometry_state|canonical_depth_state|canonical_tev_state|canonical_channel_state|canonical_lighting_state|canonical_dynamic_state|canonical_texture_state)_tests$'
```

Result: native canonical matrix `12/12` passed.

```sh
cmake -S pc/portable \
  -B /private/tmp/acgc-integrate-texture-dynamic-a641-asan \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBUILD_TESTING=ON \
  -DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer' \
  -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'
cmake --build /private/tmp/acgc-integrate-texture-dynamic-a641-asan \
  --parallel 4 \
  --target acgc_gx_canonical_envelope_tests \
           acgc_gx_canonical_fog_state_tests \
           acgc_gx_canonical_blend_state_tests \
           acgc_gx_canonical_alpha_state_tests \
           acgc_gx_canonical_transform_state_tests \
           acgc_gx_canonical_geometry_state_tests \
           acgc_gx_canonical_depth_state_tests \
           acgc_gx_canonical_tev_state_tests \
           acgc_gx_canonical_channel_state_tests \
           acgc_gx_canonical_lighting_state_tests \
           acgc_gx_canonical_dynamic_state_tests \
           acgc_gx_canonical_texture_state_tests
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
  ctest --test-dir /private/tmp/acgc-integrate-texture-dynamic-a641-asan \
  --output-on-failure --parallel 1 \
  -R '^acgc_gx_(canonical_envelope|canonical_fog_state|canonical_blend_state|canonical_alpha_state|canonical_transform_state|canonical_geometry_state|canonical_depth_state|canonical_tev_state|canonical_channel_state|canonical_lighting_state|canonical_dynamic_state|canonical_texture_state)_tests$'
```

Result: combined ASan/UBSan canonical matrix `12/12` passed with no sanitizer
diagnostic. `detect_leaks=0`, so this is not leak-check evidence.

## Claim boundary

This proves the renderer-neutral Texture/TLUT and Dynamic layouts, validators,
cross-section resource rules, additive integration, focused native execution,
and combined ASan/UBSan execution. It does not prove a raw PC resource
producer, live cumulative packet, callback, full `ac_pc` link, launch, Windows
runtime, resource-byte access, OpenGL/Metal encoding, present, readback, pixel,
device, or playability gate.
