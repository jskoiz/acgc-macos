# Exact-`586cf7a6` cumulative resource trace — 2026-08-24

## Outcome

One serialized real-process attempt from the exact clean PC merge
`586cf7a616cd38149c911bd4bc8fb2f1de638de4` passed all fourteen canonical
producers, staged the live Texture/TLUT resources while the borrow was active,
revalidated and ended the borrow, assembled and published a 14,104-byte
cumulative envelope, and built the value-owned Apple plan. The Apple runtime
observed a valid same-attempt resource stage and a `PLAN_PUBLISHED` handoff.

The public typed consumer then returned status `17`,
`CANONICAL_TEXTURE_UNSUPPORTED`. The canonical sink was not entered. This is
the same public typed frontier as the prior exact-`9860ebc5c` attempt, but the
new trace proves that exact-`586cf7a6` production resource staging and callback
ownership execute successfully in a real inferior before that rejection.

No producer failed and no missing phase or structured trace error was recorded.
The next gate is therefore the exact typed Texture admission predicate, not
another producer investigation. This evidence does not prove a sink call,
Texture/TEV rendering, Metal encode or present, readback, pixels, device
behavior, or playability.

## Exact revisions and artifact

- Umbrella base at trace time:
  `039a5317ab2a1d5c119e6fb15321b7b3626de395`.
- PC source and target branch tip:
  `586cf7a616cd38149c911bd4bc8fb2f1de638de4`.
- PC merge parents:
  `d472c6bd32443015b0db8e285e1070b4f60539ee` and
  `024206d3697ea5c77e3f3b036f749a773f0204bf`.
- Decomp oracle:
  `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Exact clean detached source:
  `/private/tmp/acgc-integrator-texture-586cf7a`.
- Fresh full-link root:
  `/private/tmp/acgc-texture-586-full-link.Ypdn9l`.
- Runtime root:
  `/private/tmp/acgc-texture-586-runtime.CLc6Jj`.
- Retained trace root:
  `/private/tmp/acgc-texgen-586-trace-harness-v3.c3V2Jd`.

The full target was configured from the exact source with Ninja, Debug,
`PC_DARWIN_COMPILE_AUDIT=ON`, and `BUILD_TESTING=OFF`, then built serially. The
4,078-step build and final link passed. The linked artifact is:

- Mach-O 64-bit executable, arm64;
- 15,538,896 bytes;
- SHA-256
  `19f74c32ab747108aec09bcc3d364df8d255f260d12ec30a9b684155987ba46a`;
- UUID `7C6C84A5-39E5-3F8F-98A5-71F80618377F`.

This artifact identity was rechecked directly after the run. Full link proves
compilation and symbol resolution only; the bounded trace below is the separate
process proof.

## Immutable prelaunch gates

The first harness drafts were stopped before launch by independent review. The
final v3 harness closed their P1 findings before the one-shot budget was spent.
Its final immutable prelaunch review passed with no P0/P1/P2 finding and made no
source, harness, build, runtime, or asset mutation.

A separate exact-source/DWARF/Mach-O ABI audit also passed before launch. It
confirmed that all 26 required symbols resolved exactly once in the exact
binary, the arm64 argument and return-register capture matched the compiled
function signatures, callback ordering matched the exact source, and the
expected terminal public status was 17 with no sink entry. This was a static
readiness gate, not a runtime result.

## One-shot command and wrapper boundary

Exactly one command was authorized and run:

```sh
zsh /private/tmp/acgc-texgen-586-trace-harness-v3.c3V2Jd/run-trace.zsh --run
```

The LLDB-controlled in-process trace completed its one permitted attempt,
emitted its summary, killed the stopped inferior, and emitted a cleanup event.
After LLDB returned, the shell wrapper exited `1` at line 531 because it assigns
to zsh's read-only special parameter `status`:

```text
run-trace.zsh:531: read-only variable: status
```

That post-LLDB wrapper defect is not reported as a clean harness exit and does
not erase the already-emitted in-process events. It also does not authorize a
retry. The exact launched harness and retained logs remain unmodified; the
attempt was not rerun.

Independent immutable post-run review therefore classified the in-process
metadata trace as PASS, with P0 and P2 clear, but the overall harness invocation
as FAIL/P1 because its wrapper status propagation is false-negative. The P1 is
confined to the post-LLDB shell assignment; it is not upgraded into an
in-process trace failure or silently waived as a passing harness gate.

## In-process result

`events.log` contains 62 contiguous schema-1 events, sequence 1 through 62,
for one source ref, one UUID, one inferior PID, one owner thread, and attempt ID
1. It records no `trace_error`, no missing phase, no first producer failure, and
an empty structured error list.

All producers returned `1`, exactly once and in the expected order:

1. Transform;
2. Channels;
3. Texgen;
4. Texture/Dynamic;
5. TEV;
6. Lighting;
7. Blend;
8. Alpha;
9. Depth;
10. Raster;
11. Fog;
12. Geometry dependencies;
13. Geometry; and
14. Indirect.

The Texture borrow transaction then records:

- Texture-builder revalidation `1`;
- gather pre-resource revalidation `1`;
- resource-stage return `1`, valid and pending for attempt ID 1;
- gather post-resource revalidation `1`;
- borrow-end return `1`; and
- the pointer-free plan callback only after `borrow_active=false`.

The resource event records metadata only: image and decoded-image masks are
`255`, the TLUT mask is `32768`, eight bounded image copies and eight bounded
base-level RGBA decodes have nonzero byte sizes, and the selected TLUT copy is
32 bytes. No resource payload, address, or proprietary asset content is
recorded in this evidence.

After borrow release, the pointer-free plan callback returned plan status `0`,
`OK`, with a valid pending plan. The gatherer returned `1` with publication,
attempt reset returned `1`, notification returned `1`, and callback dispatch
was recorded. The Apple observer then saw:

- handoff result `2`, `PLAN_PUBLISHED`;
- a present plan;
- valid and pending resource state;
- matching attempt ownership;
- typed consumer status `17`, `CANONICAL_TEXTURE_UNSUPPORTED`;
- runtime winner `0`;
- no canonical sink entry; and
- resource pending state cleared on return.

The attempt summary uses stop reason `cumulative_published`. That means the
bounded stop condition was satisfied by a real cumulative publication; it does
not mean a renderer submission succeeded.

## Process cleanup

LLDB reported the process stopped after the attempt and then issued
`process kill`. The inferior exited with status 9. The final trace event records
`no_inferior=true` and process state `exited`. Direct post-run lookup of exact
LLDB PID `62318` and inferior PID `62373` returned no rows. No watchdog log was
created.

This proves exact-PID absence after forced LLDB cleanup. It is not a natural or
graceful application shutdown claim.

## Two-upstream crosswalk

The PC host implementation owns the live chain in
`pc/src/pc_gx_cumulative_gatherer.c`, `pc/src/pc_gx.c`,
`pc/apple/src/apple_canonical_plan.c`,
`pc/apple/src/metal_packet_consumer.c`, and
`pc/apple/src/pc_metal_runtime.c`. Texture/TLUT lease and raw-resource ownership
are in `pc/include/pc_gx_texture_raw_state.h`, `pc/src/pc_gx_texture.c`, and
`pc/src/pc_gx_canonical_snapshot.c`.

The original-behavior oracle remains decomp `include/dolphin/gx/GXTexture.h`
and `src/static/dolphin/gx/GXTexture.c` for Texture/TLUT object, load, and
invalidate semantics; `GXTev.h`/`GXTev.c` for TEV stages and alpha inputs; and
`GXBump.h`/`GXBump.c` for indirect texture state. The PC borrow token,
cumulative envelope, Apple value plan, resource-stage ownership, callback
arbitration, and typed status enum are host boundaries with no direct decomp
counterpart.

## Proof boundary and successor

This gate proves an exact-`586cf7a6` arm64 full link and one bounded
real-process attempt through all producers, resource staging, lease
revalidation/release, cumulative publication, Apple plan construction, and the
public typed Texture rejection. It separately records forced exact-PID cleanup
and the post-LLDB zsh wrapper defect.

It does not prove general Texture decoding, TEV evaluation, a canonical sink
call, Metal command encoding, presentation, readback, pixels, input, audio,
save/reload, lifecycle correctness, device behavior, or playability. The
immediate useful successor is one read-only predicate/root-cause audit, followed
by exactly one source owner for the smallest source-faithful typed Texture fix
and focused native plus ASan/UBSan fixture. Duplicate Texture investigations
must remain stopped.
