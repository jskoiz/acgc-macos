# Exact-tip sanitizer refresh (2026-08-12)

This evidence records the read-only verification lane run against the exact
authoritative source tip `ACGC-PC-Port` `c1/macos-host-launch`
`09dd1827b845cd311ee0c79df2d25ac8c855e35c`. The reference decomp checkout was
`ac-decomp` `master` `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. Both source
checkouts were clean before and after the run. The temporary source/build/log
root was `/private/tmp/acgc-lane-sanitizer-refresh-20260812`; it was retired
after review and no ISO or proprietary asset was copied, extracted, or changed.

## Results

`P/S/F` means passed/skipped/failed. The field-cleanup allocator fixture is
listed separately; the native-PC row includes the selected ARAM, platform-link,
and texture-pointer probes.

| Lane | Field fixture | Portable | Apple | Native PC | Aggregate |
| --- | ---: | ---: | ---: | ---: | ---: |
| Native | 1/0/0 | 18/0/0 | 7/2/0 | 10/1/0 | 36/3/0 |
| ASan | 1/0/0 | 18/0/0 | 7/2/0 | 10/1/0 | 36/3/0 |
| UBSan | 1/0/0 | 17/0/1 | 7/2/0 | 10/1/0 | 35/3/1 |

All nine selected CMake configure/build invocations completed with exit 0.
The field fixture printed `preserved=1` in native, ASan, and UBSan runs.

The two Metal scopes returned the declared skip `77` after their CPU contracts
passed because no macOS Metal device was available. The CoreAudio probe returned
the declared skip `77` because the device-alive property was unavailable. No
Metal encode/present/pixel, audible audio, input, save/load, simulator, device,
or playability claim follows.

## UBSan boundary

The sole fail-stop UBSan test is the pre-existing `aflags_c` object-width issue
in `src/static/libforest/emu64/emu64.c:6078:14`. The file is unchanged between
the parent and `09dd182`; `git blame` attributes the line to the older `5fb5dee`
commit. A recover-mode diagnostic run reports the same pre-existing condition at
11 call sites (4636, 4652, 4735, 4751, 4753, 4757, 5282, 6078, 6079, 6088,
6093). This is not a regression in the LP64 field-cleanup fix.

The first standalone fixture compile also failed because its command omitted
`-Ipc/portable/include`; the exact diagnostic was `fatal error:
'acgc/gbi_runtime.h' file not found`. Adding the missing include path corrected
the command. Initial unfiltered Apple/PC CTest invocations likewise reported
unbuilt inherited portable registrations; scope-specific regexes then produced
the counts above. These are harness/command issues, not product failures.

This lane performed no source edit, commit, merge, launch, full `ac_pc` link, or
LLDB run.
