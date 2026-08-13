# Save-path failure-injection evidence

Status: local umbrella probe complete; no upstream source changes.

This lane establishes the filesystem contract needed before `Save_t` restart
integration. It is intentionally limited to synthetic records and path
mechanics. It does not read an ISO, extracted game data, a GCI, or a real save.

## Upstream crosswalk

The source references below were inspected read-only from the integration
checkout because this evidence worktree has empty, uninitialized submodule
directories. The umbrella anchor is `04d21b8` (`Correct cleanup worktree
count`). The two source references are:

| Reference | Filesystem/save assumption | Porting consequence |
| --- | --- | --- |
| `upstream/ACGC-PC-Port` at `724a18ddcebec039ec393b98e4f0c37fda879d66` (`Preserve LP64 audio DMA addresses`) | `pc/src/pc_card.c:95-140` maps channel 0/1 to cwd-relative `save/card_a` and `save/card_b`, creates those directories at `CARDInit`, and opens individual files. `pc/src/pc_m_card.c:46-57` and `:644-777` use `DobutsunomoriP_MURA.gci`, a sibling `.tmp`, `.bak1..3`, and a legacy flat `save/` path. | The future host must resolve a namespaced writable data root before calling the CARD-shaped adapter. Cwd-relative `save/` is an upstream assumption, not the macOS application-data contract. |
| `upstream/ACGC-PC-Port` at the same reference | `pc/src/pc_m_card.c:298-445` writes a synthetic-to-the-port GCI-shaped file through a temporary sibling, rotates backups, then calls `rename`; read/load at `:723-777` checks the primary, then other GCI files, the temp, and backups. | The filesystem lane can prove staging, same-directory replacement, and recovery ordering without claiming the bytes are a valid `Save_t` or GCI. |
| `upstream/ac-decomp` at `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c` (`Revise README`) | `include/m_card.h:17-25,72-83,128-135` defines a logical CARD file set and `mCD_SAVE_DATA_OFS`; `src/game/m_card.c:1526-1548` describes one `DobutsunomoriP_MURA` file containing main, main-backup, misc, mail, original, and diary segments; `:1758-1778` computes segment offsets; `:1986-2007` reads/writes through CARD-shaped operations. | The decomp’s save model is a logical memory-card file and internal segments, not a host path. The macOS adapter must preserve that logical model while supplying safe host paths. |
| `upstream/ac-decomp` at the same reference | `include/dolphin/dvd.h:87-106` carries DVD boot/FST position, length, and address; `src/static/dolphin/dvd/fstload.c:20-85` reads the FST from the disc boot information. | DVD/FST is a separate read-only disc boundary. It is not a cache, log, temp, or save path and is excluded from this probe. |

The PC implementation’s `.tmp`/`.bak` files and the decomp’s main/main-backup
CARD segments are related recovery concerns, but they are not byte-compatible
formats. Raw-wire mismatch remains a separate lane.

## Probe contract

`save_path_failure_injection.py` creates exactly one unique root below
`/private/tmp` and uses only small synthetic records. Every generated path is
contained below that root:

| Category | Synthetic macOS-shaped location |
| --- | --- |
| Application Support | `<fixture>/instance-a/home/Library/Application Support/com.acgc.modern-port.probe` |
| Cache | `<fixture>/instance-a/home/Library/Caches/com.acgc.modern-port.probe` |
| Logs | `<fixture>/instance-a/home/Library/Logs/com.acgc.modern-port.probe` |
| Temporary | `<fixture>/instance-a/system-temp/com.acgc.modern-port.probe` |
| Save transaction | `Application Support/.../Saves/slot-0/fixture-record.bin` |

The save transaction stage is a sibling of the target (`fixture-record.bin.tmp`)
so the final `os.replace` is a same-directory namespace operation. The
system-temporary category is used only for an isolated scratch artifact; it is
not used for the atomic save stage.

The bounded checks are:

1. Path layout: all four data categories and the synthetic save directory are
   bundle-scoped and contained by the fixture root.
2. Isolation: two synthetic process roots write the same relative marker path
   without observing or overwriting one another.
3. Atomic replace: a failure injected after temp-file `fsync` leaves the
   published target unchanged; a successful same-directory `os.replace`
   publishes the complete replacement and keeps a valid backup.
4. Corruption recovery: a deliberately invalid primary recovers from a valid
   backup; a valid orphan temp is promoted only when the primary is invalid.

The probe has a fixed three-check sequence, a 1 MiB record read/write cap, no
network access, no subprocesses, and no access to `local/`, `roms/`, ISO files,
or extracted assets. Its `finally` block removes only the exact unique fixture
root it created.

## Reproduction and observed result

Run from the umbrella root:

```sh
sh scripts/run_save_path_probe.sh
```

The observed run on 2026-08-12 completed with the following result shape; the
fixture path is intentionally ephemeral and is not committed:

```text
fixture_root=/private/tmp/acgc-lane-save-path-<unique>
PASS path-layout
PASS isolation
PASS atomic-replace-and-failure-injection
sanitizer=not-applicable (pure Python synthetic fixture)
RESULT PASS checks=3
cleanup=removed
```

The command proves a local Python filesystem probe only. No C sanitizer was
run because this lane adds no C code and does not build either upstream.

## Evidence boundary and successor

Proven here:

- namespaced Application Support, cache, log, and temporary roots can be
  exercised without touching real user data;
- a same-directory staged replacement preserves the old published bytes until
  the namespace switch and leaves a valid backup;
- bounded recovery can distinguish a valid primary, valid orphan temp, and
  valid backup from corrupted synthetic bytes;
- two process-shaped roots remain isolated.

Not proven here:

- `Save_t` layout, byte swapping, checksum semantics, GCI headers, CARD wire
  behavior, or the raw-wire mismatch between PC and GameCube representations;
- game save/load, restart integration, launch, rendering, audio, or device
  behavior;
- actual `FileManager`/sandbox entitlements or user-facing macOS app acceptance.

The successor is the integration owner on `c1/macos-host-launch`: review this
umbrella commit, locally merge it, rerun the focused probe, and then connect
the proven path policy to the `Save_t` restart adapter. Do not update the
umbrella gitlinks in this lane.
