# Input snapshot boundary audit at `dbf6986`

Lane 113 (`019ffdba-e4ee-72c3-ad9a-5f9d77153f34`) was a read-only/test-only
crosswalk of the PC input snapshot, SDL controller/keyboard mapping, and the
game-owned frame guard against ac-decomp. It made no production or CMake edits,
ran no full link or LLDB launch, and made no physical-input or playability
claim.

## References and tests

- PC at test time: `c1/macos-host-launch` `dbf6986dc9ca570f157434936ddfd09d176978e6`.
- Decomp oracle: `master` `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c`.
- Exact isolated root: `/private/tmp/acgc-lane-input-runtime-boundary-XTPXKu`.
- Native focused input/frame-guard CTest: `3/3` passed.
- Combined ASan/UBSan focused CTest: `3/3` passed with no diagnostics.

The existing PC path samples SDL state into the fixed-width `PCInputSnapshot`,
converts it to `PADStatus`, and then applies the game-owned once-per-frame
`pc_frame_counter` guard in `padmgr_RequestPadData()`. The C-stick `±29`
conversion matches the decomp `contreaddata.c` path and is not a defect. A
synthetic SDL key event does not alter `SDL_GetKeyboardState`, so keyboard state
remains an OS/human-input gate.

Two synchronous virtual-controller `PADRead()` calls without an event pump were
byte-identical:

```text
DOUBLE_PADREAD mask1=0x80000000 mask2=0x80000000 identical=1 buttons=0x0160 stick=(64,0) triggers=(206,225)
```

This is only a synthetic same-call stability result; it is not physical input
or persistent cross-frame proof.

## Concrete narrow mismatch

An end-to-end synthetic sub-threshold trigger probe produced:

```text
SDL_SUBTHRESH_PADREAD channel=0x80000000 buttons=0x0000 triggers=(88,88)
SDL_SUBTHRESH_GAME_PAD now=0x0000 decomp_expected=0x0030
analog trigger path mismatch confirmed: SDL analog L/R reaches PADStatus but not game-owned BUTTON_L/R
```

The PC path sets GC digital L/R only above `PC_PAD_AXIS_PRESS=12800`, and the
game-owned conversion consumes those digital bits. The decomp oracle's
`contreaddata.c` sets `BUTTON_L/R` when the corresponding analog trigger is
nonzero, even without the digital bit. Thus a partial analog press reaches
`PADStatus` but is dropped before `pad_t.now.button`.

This justifies a separately authorized, test-first source-fix lane. No fix was
applied here; the next lane must define the desired PC/Windows contract, add a
sub-threshold regression fixture, and preserve existing keyboard and Windows
behavior.

## Claim boundary

Proven: source crosswalk, native/sanitizer focused tests, synthetic controller
mapping, same-call snapshot stability, and the narrow analog-trigger mismatch.
Not proven: physical keyboard/controller input, simulator/device input, a full
game input loop, audio, save/device persistence, Metal, pixels, or playability.
No successor lane was opened automatically.
