# Live Metal packet-rejection diagnostic

Date: 2026-08-13 HST

This is one bounded, root-owned diagnostic against the exact integrated PC
source `8a19f23` on `c1/macos-host-launch` (the opt-in trace was developed on
`c1/lane-metal-rejection-diagnostic` and fast-forwarded after review). The
decomp reference was `09ca8e8b` on `master`. Umbrella documentation started at
`794daa7`. The ISO remained at its ignored local path and was only symlinked
into the ignored build tree; no ISO or extracted asset was copied, printed, or
tracked.

## Build and launch

One serialized arm64 `ac_pc` link ran with Ninja `-j1` in
`/private/tmp/acgc-metal-rejection-trace-build` and completed successfully
(`4008/4009` followed by the final link/copy step), producing an arm64
Mach-O. The exact integrated source was rebuilt after the fast-forward and the
same target completed with exit `0`.

The normal shell launch was blocked before inferior creation by the known
`nice(5) failed: operation not permitted` host restriction. One elevated,
directly rooted launch then created a real game process from the generated
`bin` directory. It reached GAFE01 boot, audio initialization, LOGO actions,
and `[NEOS_OUT]` frames. The run was intentionally interrupted after the
bounded diagnostic window; this is not normal-shutdown proof.

## Rejection records

The opt-in `ACGC_METAL_REJECTION_TRACE=1` diagnostic emitted 64 records before
its bound: 32 preflight records (`result=-1`) and 32 failed packet builds
(`result=0`), with zero successful v2 packet builds. The retained log is:

`/private/tmp/acgc-metal-rejection-trace-logs/elevated-launch.log`

Representative live state from the first records:

```text
num_chans=1 num_tex_gens=1 num_tev_stages=1 num_ind_stages=0 fog=0
alpha=7/7/0 blend=1/4/5/5 texgen0=1/4/30/125 tex0=2/64/64/8 known=1
```

Using the Dolphin GX enum values in the same source tree, that is one channel,
one texture generator, one TEV stage, a resolved 64x64 texture, standard
source-alpha blending (`GX_BM_BLEND`, `GX_BL_SRCALPHA`,
`GX_BL_INVSRCALPHA`, `GX_LO_SET`), and `GX_TEXMTX0` (`30`) with
`GX_PTIDENTITY` (`125`). The v2 state gate in `pc/src/pc_gx.c` intentionally
requires `GX_BM_NONE`/`ONE`/`ZERO`/`CLEAR` and `GX_IDENTITY` (`60`) for the
current packet contract. Therefore the live rejection is explained by
unsupported blend and texture-matrix semantics; it is not evidence of a
pointer fault or a safe case that should be admitted by relaxing the gate.

The v2 callback/Metal observer remains downstream of packet preparation, so no
live Apple consumer callback was observed in this run.

## Focused verification

After the source fast-forward, the focused v2 handoff test was rebuilt and
passed natively:

```text
ctest --test-dir /private/tmp/acgc-lane-metal-rejection-audit \
  --output-on-failure -R acgc_pc_gx_semantic_v2_handoff_tests
1/1 passed
```

The same focused test passed under the lane's ASan/UBSan configuration with
`ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1`:

```text
ctest --test-dir /private/tmp/acgc-lane-metal-rejection-audit-asan \
  --output-on-failure -R acgc_pc_gx_semantic_v2_handoff_tests
1/1 passed
```

No sanitizer diagnostics were emitted. The full game run proves boot and the
GX/OpenGL submission boundary only. It does not prove a complete display list,
Metal encode/present, pixel readback, input, audible audio, Save_t/device
persistence, simulator/device behavior, or playability.

## Next bounded lane

The next implementation question is a versioned packet/consumer extension for
the observed blend and texture-matrix state, crosswalked against the
`ac-decomp` GX calls before editing. The current v1/v2 fail-closed contract and
the legacy Windows/OpenGL path remain unchanged until that extension has a
focused fixture and an Apple-device encode/readback proof.
