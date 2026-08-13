# Save_t raw-wire losslessness boundary (2026-08-13)

This evidence is bound to authoritative `upstream/ACGC-PC-Port`
`c1/macos-host-launch` commit `d0e64f5`, a clean cherry-pick of lane commit
`315f040` from `c1/lane-save-wire-lossless`; the matching decomp reference is
`upstream/ac-decomp` `09ca8e8b`.

## Finding

The production repair is already present in ancestor `d1575f0`: the PC codec
re-packs only the 16-bit `mQst_base_c` bitfield at bytes `+0x00..+0x01`, so
`lbRTC_time_c.time_limit` at `+0x02..+0x03` is not overwritten. The lane adds
test-only forensic coverage, not a second wire format. Its modeled pre-fix
32-bit repack maps the representative wire bytes `0xF1 0x0E` to `0x00 0x00`;
the current codec preserves `0xF10E` through BE→LE→BE and process restart.

The crosswalk matches the decomp declarations: `mQst_base_c.time_limit` starts
at `+0x02`, `Save_t` retains its documented wire size, and the PC GCI adapter
uses a 64-byte envelope with main/backup slots at `0x26000`/`0x4C000`.

## Exact verification

The lane and integrated source trees have identical tree ID
`6da764754764b5218d59bf3655e25c0d49a4df26`. Reusing the focused binaries built
from that exact tree:

```text
/private/tmp/acgc-lane-save-wire-lossless-build/native/pc_save_bswap_roundtrip
```

Result: `Save_t codec/checksum/restart round-trip: PASS`, exit `0`.

```text
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1:abort_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
/private/tmp/acgc-lane-save-wire-lossless-build/asan-ubsan/pc_save_bswap_roundtrip
```

Result: the same PASS, exit `0`. Leak detection is disabled because the Apple
runtime does not support LeakSanitizer in this focused lane.

## Evidence boundary

This proves the raw field is preserved by the current codec and makes the old
loss explicit. It does not prove full game startup/save-manager orchestration,
physical-card or device persistence, exact whole-GCI losslessness beyond the
covered field, or playability.
