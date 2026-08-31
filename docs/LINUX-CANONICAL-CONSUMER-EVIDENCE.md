# Linux CPU Verification of the Apple Canonical Consumer Frontier

Run date: 2026-08-31. Host: Cloud Agent Linux x86_64 (Ubuntu 24.04),
clang 18.1.3 and gcc 13.3.0. No ISO, no Metal, no GPU.

Source pins under test:

- `upstream/ACGC-PC-Port` @ `c7f835f325ea5e061f492213da9ddce5349b269d`
  (branch `c1/macos-host-launch`).
- `upstream/ac-decomp` @ `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c` (oracle).

## Why this exists

The authoritative live frontier is the typed Apple canonical consumer: a
cumulative plan is admitted only while its Texture section is inactive, so a
textured game frame stops with `status 17`
(`ACGC_METAL_PACKET_CONSUMER_CANONICAL_TEXTURE_UNSUPPORTED`) before any sink is
entered. That frontier code and its proven CPU texture-resource staging half
live in `pc/apple`, which is a macOS-only AppKit/Metal CMake target
(`pc/apple/CMakeLists.txt` `FATAL_ERROR` off Apple). On the Linux Cloud Agent
host the full `pc/apple` graph cannot build.

However, the consumer translation unit and its canonical-state dependencies are
renderer-neutral C (`pc/apple/src/metal_packet_consumer.c` includes only
`<math.h>`, `<string.h>`, and its own header; the API contract states no Metal
object or native pointer crosses it). That lets the frontier be verified
continuously on Linux without the macOS host graph.

## Command

```sh
./scripts/verify-apple-canonical-consumer.sh
# compiler override also verified:
CC=gcc ./scripts/verify-apple-canonical-consumer.sh
```

The script compiles the two renderer-neutral `.c` consumer fixtures against the
exact source closure of the `acgc_metal_packet_consumer` static library (the
consumer plus the canonical-state and semantic-packet sources it links in
`pc/apple/CMakeLists.txt`) and runs them. Build output stays under ignored
`local/build/`.

## Result: passed

Both real upstream fixtures build and pass on Linux under clang and gcc:

- `acgc_apple_canonical_plan_consumer_fixture`
  (`pc/apple/tests/test_apple_canonical_plan_consumer.c`): PASS. Its rejection
  matrix pins the frontier directly — an active Texture header
  (`known_map_mask`/`known_map_count = 1`) is rejected with
  `ACGC_METAL_PACKET_CONSUMER_CANONICAL_TEXTURE_UNSUPPORTED`, while the
  supported textureless subset (disabled/AF_NONE channels, exact
  vertex-color-passthrough TEV, two-active Texgen admission-only provenance)
  converts to `ACGC_METAL_PACKET_CONSUMER_OK`.
- `acgc_apple_canonical_texture_resource_consumer_fixture`
  (`pc/apple/tests/test_apple_canonical_texture_resource_consumer.c`): PASS.
  The CPU resource-staging half — lease metadata validation, raw-byte copy,
  base-level decode, and post-copy lease isolation — succeeds and fails closed
  on a late map failure.

This is CPU-only evidence. It does not claim Metal encode/present, pixel
readback, a device, game assets, or playability.

## Frontier characterization (for the source-fix owner)

The admission gate is `canonical_plan_sections_status`, which calls the section
predicates in order and returns at the first failure:

- Predicate: `canonical_plan_texture_is_inactive`
  (`pc/apple/src/metal_packet_consumer.c:1129`).
- Rejection site:
  `pc/apple/src/metal_packet_consumer.c:1791-1792` returns
  `ACGC_METAL_PACKET_CONSUMER_CANONICAL_TEXTURE_UNSUPPORTED`.
- The predicate accepts only a fully zero/inactive Texture section (no known,
  indexed, mipmap, TLUT-present, or required map bits and all records zero).

The CPU resource-staging path that a textured admission would consume already
exists and is proven:
`acgc_metal_packet_consumer_stage_canonical_resources`
(`pc/apple/src/metal_packet_consumer.c:1938`) copies and decodes each required
image/TLUT into value-owned staging while the `PCGXTextureDynamicLease` is
live.

## Two-upstream oracle crosswalk

- `ACGC-PC-Port`: `GXTexObj` is a fixed-width 22-`u32` public ABI on
  `TARGET_PC` (`include/dolphin/gx/GXStruct.h`); the host stores the image
  pointer as a `0xF`-prefixed generational handle via the texture-owned
  registry in `pc/src/pc_gx_texture.c` (the earlier LP64 truncation frontier is
  resolved at this pin).
- `ac-decomp` (oracle): `GXTexObj` is 32 bytes; the texture data address lives
  in `image3` (offset `0x0C`) as a 21-bit `(u32)ptr >> 5` value, read back via
  `(base << 5)`; 32-byte alignment; no address translation
  (`src/static/dolphin/gx/GXTexture.c`). A modern host must preserve those
  guest semantics.

## Remaining production work (macOS/GPU-only; not landed here)

Clearing `status 17` for a real frame is a renderer feature, not a CPU-predicate
relaxation: a textured-plan admission path that binds the already-staged decoded
RGBA to a Metal texture/sampler sink, verified with Metal encode/present and
pixel readback on an Apple device. Loosening `canonical_plan_texture_is_inactive`
without that sink would report a false `OK` for a frame nothing renders, which
the porting charter forbids ("a crash frontier is not by itself a design
specification"). That lane must run on macOS; this Linux host cannot build or
honestly verify it.

## Scope

Umbrella-only change: a reproducible verification script plus this evidence.
No `upstream/` submodule source was modified and no submodule gitlink was moved.
