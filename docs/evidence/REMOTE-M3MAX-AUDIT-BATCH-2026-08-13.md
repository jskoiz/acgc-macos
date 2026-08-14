# Remote M3 Max audit batch — lanes 119–127

Date: 2026-08-13 (Honolulu)

These nine lanes ran on the registered remote M3 Max source snapshot: umbrella
`ee31f535f61d4ad8690ecf7e53b2ab6c0b66b281`, PC
`a53b192247aab2c4f6e58b1f2dda41efdf8d1cad`, and ac-decomp
`09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`. The remote umbrella, PC, and
decomp checkouts were clean at lane start and end. No lane accessed or moved
the ISO, ROMs, extracted assets, keys, or proprietary data. All completed
worktrees and focused roots listed on the board were retired only after
holder-free checks; source branches and reviewed commits remain preserved.

## Results

| Lane | Result | Evidence boundary / next gate |
|---|---|---|
| 119 sanitizer/Windows | Native semantic/packet matrix `9/9`; combined ASan/UBSan `9/9`; seven direct probes returned `0`; eight C/portable `_WIN32` probes passed. Apple libc++ locale/fortified `bcopy`/`bzero` caveats and the true i686 probe's missing MinGW `math.h`/sysroot remain. | Shared host probes are not Windows sign-off. A real i686 MinGW/sysroot is required before PE/runtime proof. |
| 120 input trigger | Existing focused input tests `3/3` plus synthetic boundary fixture `1/1`, native and combined ASan/UBSan. PC L/R bits activate at raw `12801` (analog `100`) while decomp's PAD threshold is analog `170` (raw `21760`); repeated samples are stable. | Concrete PAD threshold parity mismatch, but no production edit. A separately authorized source/test lane must choose the compatibility policy; no physical controller/device/playability proof. |
| 121 mixer/CoreAudio | Mixer/NEOS/DMA probes `3/3` native and `3/3` combined ASan/UBSan. CoreAudio opened 32 kHz S16 stereo/512, 61 callbacks, zero underruns/overruns; producer was silent. | Software/host boundary only. No audible game-audio claim; next gate is a real game-state PCM provenance harness. |
| 122 CARD | Source commit `65bee4f` integrated as PC `96ee5d61`: full aligned CARD slot checksum/tail preservation. Restart/corruption fixtures `2/2` native and `2/2` combined ASan/UBSan. | Production wire/fixture proof only. Physical CARD, device persistence, and full-game reload remain open. |
| 123 lifecycle | Five native and five combined ASan/UBSan synthetic repetitions pass with trace hash `6e4a5d94e1b0dd80`. | Retrace callbacks, generic worker/alarm ownership, focus wiring, signal teardown, and normal game shutdown remain unproven. |
| 124 graph terminator | Source commit `b3c7a9d` integrated as PC `edc323ea`; standalone portable fixture `1/1` native and `1/1` combined ASan/UBSan. Synthetic `COMPLETE`, `PREFIX_ONLY`, `UNTERMINATED`, and `MALFORMED` cases pass. | Bounded classifier semantics only; no live graph traversal, draw, frame, Metal, or pixel proof. |
| 125 texture/TLUT/TEV | Source commit `24fbf2f` integrated as PC `894ac5f8`; focused native and combined ASan/UBSan CTest `1/1` each. | Synthetic packet validation only; no live texture upload, TEV execution, Metal, frame, or pixel proof. |
| 126 Metal state contract | Read-only static crosswalk; no tests or source changes. Transform/color and bounded blend/depth/raster fixtures are mapped, while shader/consumer texture-coordinate, texture-key, texture-matrix, and TEV state remain unconsumed. | Keep V4 `V3_EXTENSION_NOT_RENDERED`. The next state-encoder lane must consume that state or preserve the explicit non-rendered boundary. |
| 127 iOS readiness | Portable CTest `20/20` and Apple CPU-only boundary `7/7` in native and combined ASan/UBSan. Metal/device tests were skipped by contract. | Apple host still stops at `AcgcMacosUnresolvedGameSystemsStub`, uses a synthetic triangle, and has no UIKit/GameController/AVAudio/CADisplayLink target or live game adapters. No iOS playability claim. |

## Overall state

The remote arrangement is functioning as intended for source, fixture, audit,
and verification work without disturbing the local desktop. The integrated
local PC tip is now `894ac5f8`; the source/fixture commits are reviewed one at
a time, while expensive full links and LLDB launches remain serialized and
have not been started by this batch. The next dependency-ready implementation
gate is the Apple texture/TEV/state encoder contract; only after that CPU
contract is proven should a separately authorized current-tip runtime trace or
device-gated Metal readback be considered.

No result in this batch proves a rendered game-owned frame, Metal encode or
present, pixel readback, physical input, audible game audio, device save/load,
simulator behavior, or human playability.
