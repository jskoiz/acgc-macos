# Canonical Depth and Raster contracts at `f2b7ab153`

Date: 2026-08-14

## Provenance and scope

- Read-only M3 Max task: `01a002d6-8511-79d2-afeb-4348ff78a52a`
- PC snapshot: `f2b7ab153aaeef037cc1fca3ecdc98acbf50ad82`
- Decomp snapshot: `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`

The task changed no source or documentation, ran no build or launch, and did
not access the ISO or extracted assets. It cross-walked `GXPixel.c`,
`GXGeometry.c`, `GXTransform.c`, `GXInit.c`, `GXTev.c`, `GXFrameBuf.c`, and
`GXEnum.h` against the PC state and setter implementation.

## Frozen Depth contract

Section ID 10 / mask `0x0200` is version 1, 16 bytes, aligned to four bytes,
with directory count/capacity `1/1`. Its four words are:

1. `z_compare_enable`, GXBool `0..1`;
2. `z_compare_func`, GXCompare `0..7`;
3. `z_update_enable`, GXBool `0..1`; and
4. one zero reserved word.

The compare function remains an exact logical value even when comparison is
disabled. `GXSetZCompLoc` stays in Alpha; Z texture, pixel format, copy depth,
and fog are explicitly outside this section.

The PC already retains the three logical values, but the future canonical
shadow must add strict bounds and knownness and must never derive canonical
state from the OpenGL fallback for an unknown compare function.

## Frozen Raster contract

Section ID 11 / mask `0x0400` is version 1, 128 bytes, aligned to four bytes,
with directory count/capacity `1/1`. Its 32 words retain:

- six finite binary32 viewport argument bit patterns;
- four logical scissor `u32` values;
- two signed scissor-box offsets;
- clip and cull modes;
- co-planar state;
- raw line/point sizes and texture offsets;
- eight-bit line/point texcoord-enable masks;
- dither and destination-alpha state;
- field mode, half-aspect-ratio, and odd/even field masks; and
- four zero reserved words.

Validation follows the decomp assertions: scissor origins and exclusive right/
bottom sums are below 1706; zero width/height remain valid; scissor-box offsets
are `-342..1705`; booleans, cull/clip/offset enums, masks, destination alpha,
finite viewport words, and reserved values are exact and fail closed.

The PC currently loses or host-mutates several required values: viewport jitter
ignores the field adjustment, scissor-box/clip/co-planar/dither/destination-
alpha/field/offset hooks are missing or no-ops, raw line/point parameters are
discarded, and the model-viewer cull override can replace the logical caller
value. Host-scaled/y-flipped viewport and scissor state is not canonical.

## Selected implementation order

1. Add and validate the neutral Depth section and fixture.
2. Add and validate the neutral Raster section and fixture.
3. Use one serial PC shadow owner for the overlapping `pc_gx` setter region,
   repairing Depth before Raster and keeping logical state separate from GL.
4. Add one focused PC shadow fixture and fail closed while any required value
   remains unknown.
5. Join the sections only in the later cumulative producer, before legacy
   handoffs and OpenGL mutation.

Z texture, pixel/copy state, fog-range adjustment, VCD/VAT, and other missing
sections remain separately owned. The producer policy may require Depth and
Raster together or allow independent presence; this audit does not decide it.

## Evidence boundary

This freezes two value-only source contracts and the non-overlapping repair
order. It does not implement either section or prove a packet, callback, Metal
encode/present/readback, pixel, device, Windows runtime, iOS, or playability.
