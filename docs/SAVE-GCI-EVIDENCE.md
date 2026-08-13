# Save_t/GCI serialization evidence

This lane is intentionally limited to the GameCube `Save_t` byte codec and a
process-restart file roundtrip. It does not modify either upstream submodule,
the CARD host adapter, the ISO, or extracted assets, and it does not link the
full PC runtime.

## Inputs and boundaries

The inspected source snapshots are:

| Source | Snapshot | Relevant evidence |
| --- | --- | --- |
| PC port | `4f77dab413e4fe29264cfc68b0f7fac1ade74d01` baseline | `pc/src/pc_save_bswap.c`, `pc/include/pc_save_bswap.h`, and the GCI portions of `pc/src/pc_m_card.c` |
| Matching decomp | `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c` | `include/m_common_data.h`, `include/m_card.h`, and the original `src/game/m_card.c` save definitions |
| Existing CARD host boundary | `3a6582d0` is the owning host-transfer change immediately before the inspected PC-port `4f77dab` tip | `pc/src/pc_card.c` and `pc/tests/test_pc_card.c` remain out of this lane |

The umbrella submodules remain uninitialized in the lane worktree. The proof
script therefore accepts explicit read-only source roots and requires the
requested `4f77dab` commit to be an ancestor with all codec/GCI paths unchanged
after that boundary. It pins the matching decomp commit exactly before
compiling. The observed run used the already-populated sibling source roots:

```sh
ACGC_PC_PORT_ROOT=/Users/jk/Documents/Projects/acgc-modern-port/upstream/ACGC-PC-Port \
ACGC_DECOMP_ROOT=/Users/jk/Documents/Projects/acgc-modern-port/upstream/ac-decomp \
./scripts/verify-save-gci.sh
```

The populated PC source checkout advanced while this lane was running, but
each probe run verified that `pc_save_bswap.c`, its header, the GCI manager, and
the dependent save headers were byte-for-byte unchanged from `4f77dab` before
the probe ran; the script prints the exact source `HEAD` used for each run.

All generated objects, logs, and temporary save bytes are under
`/private/tmp/acgc-lane-save-gci-build`; no ISO or proprietary asset is read.

## Format contract established by the source

The decompilation records these fixed offsets in `Save_t`:

- `Save_t` occupies `0x242A0` bytes.
- The sector-aligned `Save` union occupies `0x26000` bytes.
- `mCD_LAND_SAVE_SIZE` is `0x72000` bytes; the GCI `CARDDir` header is `0x40` bytes.
- The main save starts at GCI file-data offset `0x26000`.
- The aligned backup starts at `0x4C000` (`0x26000 + sizeof(Save)`).
- The GCI file-data sector size is `0x2000`, so the complete file is `0x72040` bytes including the header.

The probe compiles these sizes and representative `Save_t` offsets as static
assertions against the inspected PC-port headers. It also checks the save-tail
padding ends exactly at `0x242A0`; this prevents silently treating the aligned
`0x26000` union padding as part of the typed `Save_t` codec.

## Codec proof

`pc_save_bswap.c` is compiled as one isolated object and linked to the focused
probe. The probe supplies only the diagnostic `OSReport` symbol; it does not
link `pc_m_card.c`, `pc_card.c`, SDL, or the game.

The probe uses two complete `Save_t`-sized BE byte buffers: a high-entropy
noncanonical fixture to expose reserved-padding loss, and a canonical fixture
with zeroed compiler allocation padding plus nonzero documented opaque ranges.
The canonical fixture then:

1. encodes a known BE `scene_no` (`0x11223344`) and `copy_protect` (`0xA1B2`);
2. computes and writes the BE two's-complement checksum using
   `pc_checksum_be`, and checks the complete BE u16 sum closes to zero;
3. starts a fresh process to run `PC_BSWAP_FROM_BE`;
4. checks the known scalars in native little-endian form and checks six
   documented opaque/padding ranges byte-for-byte;
5. starts a second fresh process to run `PC_BSWAP_TO_BE`; and
6. compares all `0x242A0` bytes with the original fixture.

The checksum vector `00 01 00 02` produces `0xFFFD`. The full-save checksum is
computed with the checksum field zeroed and then written as BE; calling the
helper again with that old checksum returns the same checksum. This proves the
byte-order and arithmetic contract of the current helper, not a hardware or
Dolphin oracle.

The observed output contains four passing bounded checks plus one explicit
blocker:

```text
save_gci_noncanonical_padding_preservation: BLOCKED offset=0xB6 canonical=0x00
save_gci_geometry: PASS ...
save_gci_checksum: PASS ...
save_gci_endian_unknown_bytes: PASS ...
save_gci_process_restart_roundtrip: PASS ...
```

The canonical fixture deliberately zeros compiler allocation-unit padding while
putting nonzero data into documented opaque byte ranges. For that fixture, the
process boundary proves that the typed codec's byte result can be written,
closed, reopened by a new process, and reconstructed without changing the
fixture bytes. A separate high-entropy fixture demonstrates that the current
codec canonicalizes the two-byte padding at `0xB6` to zero. Therefore the
roundtrip proof is conditional on canonical reserved/padding bytes; it is not
an arbitrary-byte or whole-GCI losslessness claim.

## Preservation and adapter boundary

The codec preserves the documented opaque bytes it does not visit because it
swaps known fields in an existing byte buffer; the probe verifies those gaps
and the canonical full roundtrip. Compiler allocation-unit padding is a
separate precondition, as the explicit blocker above shows. This assumption
applies only to the `Save_t`-sized buffer. It does not yet establish lossless
preservation of an entire GCI file:

- `pc_save_write_gci_to` starts a fresh zeroed `0x72000` file-data buffer and
  reconstructs the comment, ARAM blocks, main save, and backup. Unknown bytes
  outside those reconstructed regions are therefore not a preservation claim.
- The current read path reads the fixed `0x72000` data area after the header but
  does not enforce an exact file length before doing so. Geometry is proven by
  constants; malformed/trailing GCI acceptance remains a reader-validation
  gap.
- The Card-B fallback currently validates the main/backup land ID after
  conversion, but this probe does not claim checksum-validated main/backup
  selection or game-level recovery behavior.
- The existing `pc_card.c` temporary-directory transfer test proves host file
  create/read/write/reopen behavior only. It remains separate from this codec
  proof and is not rerun by this script.

The safe adapter handoff is consequently: first expose an explicit bounded
`Save_t` BE codec contract, then add a GCI envelope codec that owns exact header,
data, main/backup, and checksum bounds, and only then connect those byte buffers
to the already-tested CARD host transfers. Do not treat the current host CARD
file roundtrip or this codec roundtrip as proof of a playable game's save/load
path.

## Remaining acceptance gates

Still open after this bounded lane:

1. A real, user-authorized GCI fixture must be read through the exact envelope
   layout and checksum rules; this lane intentionally does not read the ISO or
   extracted proprietary data.
2. The runtime save manager must be exercised across a full process restart,
   including save construction, atomic replacement, main/backup selection, and
   reload into the game state.
3. A GameCube/Dolphin or equivalent independent oracle must confirm that the
   serialized header, endian fields, checksums, and unknown-byte choices are
   accepted by the target format.
4. Only after those gates should the CARD host adapter be described as carrying
   game-level Save_t/GCI persistence.
