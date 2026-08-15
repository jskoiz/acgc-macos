# TEV producer readiness at `689590cc`

## Provenance

Lane 224 was a read-only M3 Max audit of `ACGC-PC-Port`
`689590cc9696daeae55e73f5bf749c28317b6693` and clean `ac-decomp`
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The source-only PC bundle matched
SHA-256 `30cd438904f7ebe89394e35e35043208cffc4f67d6a89c31138d1735f48af9de`.
The corrected documentation-only control archive matched SHA-256
`c65d0b5bab12c660b1a16f907745a2e913df806153b97b472a03c480adec6edc`
before extraction. Older remote umbrella snapshots were explicitly disregarded.
No source, build, test, integration, runtime, or asset mutation occurred.

## Verdict

`BLOCK`. The fixed 2,560-byte canonical TEV ABI and validator are complete,
but the current PC state cannot populate the entire section deterministically
or fail closed.

Available source-faithful state:

- exact raw PREV/REG0-2 S10 values, source, validity, and malformed state;
- exact widened K0-K3 components and validity; and
- host fields for logical stage operations, inputs, outputs, order, selectors,
  swaps, and indirect tuples.

Missing producer prerequisites:

1. Active TEV stage count and every active logical-stage field lack complete
   setter-owned knownness, sticky invalid state, generation, and immutable
   completed-state lifetime.
2. Swap-table state lacks raw knownness/invalidity, and the PC reset values for
   tables 1-3 do not establish the distinct decomp `GXInit` defaults.
3. Per-stage indirect tuples lack domain/knownness checks and
   flush-before-mutation.
4. Indirect order, scales, and matrices lack pointer-free raw provenance. The
   PC host floats cannot safely reconstruct decomp's guest quantization and
   encoded scale values.
5. No one-boundary dependency join validates the TEV references to Texture,
   Texgen, Channels, and Indirect state.
6. `GXSetTevOp` expansion for later stages differs from decomp and does not
   retain original mode provenance; existing three-stage shader consumers
   cannot be treated as the sixteen-stage canonical source.

## Frozen predecessor contract

The smallest predecessor lane owns only:

- raw TEV stage/active-count/swap/indirect declarations in
  `pc/include/pc_gx_internal.h`;
- the corresponding TEV and indirect setter hooks in `pc/src/pc_gx.c`, with
  exact value capture and flush-before-mutation;
- one focused raw-state fixture; and
- minimal `pc/CMakeLists.txt` registration.

It must retain exact indirect matrix quantization and scale encoding, use
per-field knownness and sticky invalid provenance, copy all input data, and
publish a synchronous immutable snapshot. It must not edit canonical ABIs,
shader/Apple/Metal consumers, packets, the cumulative envelope, decomp, or
runtime wiring.

After that repair, a separate producer may own new TEV producer header/source
and fixture files, consume a const raw snapshot plus validated canonical
dependencies, build a local candidate, and publish only after standalone and
cross-section validation.

## Evidence boundary

This is source-contract evidence only. It does not prove an implementation,
canonical TEV packet, callback, full link, runtime, Metal encode/present/readback,
pixel, input, audio, save, simulator, device, Windows runtime, or playability.
