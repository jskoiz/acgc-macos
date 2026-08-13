# GX observer rejection-path audit

Date: 2026-08-13 HST

This was a bounded source/test audit at PC `a8f3a8f` and decomp `09ca8e8b`.
The lane made no source or test edit and did not run a full link or second live
launch.

## Finding

The zero `pc_metal_runtime_observe` count in the exact post-fix runtime is not
a registration bug. `pc_gx_try_handoff_semantic_vertices()` returns before the
consumer/runtime callback when `pc_gx_build_semantic_packet()` fails. The
builder intentionally rejects incomplete/out-of-range captures, in-progress
or pending vertices, count mismatches, more than 128 vertices, unsupported
semantic state, primitive/count mismatches, unsupported primitives, and packet
validation failures.

The exact semantic-state gate rejects non-pass-through TEV, active texture or
indirect state, nonzero channel count, fog, non-default alpha compare, an
invalid current matrix, or enabled lighting channels. The decomp `emu64_init`
and fallback combine path configure two texture generators, two TEV stages, and
richer textured state, which lies outside the current pointer-free v1 packet
contract. The correct behavior is fail-closed; making the observer
unconditional would erase the safety boundary.

## Callback health and verification

The focused fixture proves both sides of the boundary: a supported synthetic
triangle reaches the registered callback, while incomplete/unsupported state
is rejected before callback invocation and the legacy OpenGL path remains
unconditional. Native configure/build/CTest passed `1/1`. The same target under
combined ASan/UBSan passed `1/1` and direct execution passed with
`detect_leaks=0`, `halt_on_error=1`, and no diagnostics.

Relevant crosswalks:

- PC `pc/src/pc_gx.c` packet builder and semantic gate;
- PC `pc/apple/src/pc_metal_runtime.c` observer registration/status;
- PC `pc/apple/src/metal_packet_consumer.c` supported-topology behavior;
- decomp `src/graph.c` frame/task scheduling;
- decomp `src/static/libforest/emu64/emu64.c` GX initialization, combine, and
  triangle emission;
- decomp `src/static/dolphin/gx/GXInit.c` original GX defaults.

Exact focused roots used by the lane:

- `/private/tmp/acgc-lane-gx-observer-rejection`
- `/private/tmp/acgc-lane-gx-observer-rejection-build`
- `/private/tmp/acgc-lane-gx-observer-rejection-asan`

This proves CPU packet construction, semantic rejection, callback registration,
and sanitizer cleanliness only. It does not prove a live callback, Metal
encode/readback/pixel, device rendering, input, audio, save/load, or
playability. The next implementation decision is a deliberate extension of
the packet contract for the emu64 TEV/texture/lighting state, not an
unconditional observer call.
