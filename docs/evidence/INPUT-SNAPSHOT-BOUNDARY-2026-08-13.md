# Input snapshot boundary — 2026-08-13

Lane 75 (`019ffbcc-904f-7673-bc6a-1b137c550997`) audited the integrated PC
source `f4cb491` against decomp reference `09ca8e8b` without source changes,
full link, ISO access, or launch.

## Source boundary

`pc_platform_poll_events()` drains SDL events from `pc_main.c`; `VIWaitForRetrace()`
calls it before the next frame and advances `pc_frame_counter` after pacing.
`pc_pad.c` samples keyboard, mouse, and controller state into the fixed-width
`PCInputSnapshot` from `pc_input_snapshot.h`, then maps channel 0 to
`PADStatus`. The PC fork's `src/padmgr.c` converts this into game-owned pad
state and skips subsequent requests when `last_request_frame` equals
`pc_frame_counter`; `src/game.c` consumes that state via
`padmgr_RequestPadData(this->pads, 1)`. The decomp `m_controller.c` is a
downstream stick consumer, not the SDL sampling boundary.

The host wrapper can perform two synchronous `PADRead()` calls in one update,
so stability currently depends on no event pump occurring between them. The
normal frame ordering makes that coherent, but a persistent SDL snapshot object
is not yet proven.

## Focused results

The existing input snapshot and SDL smoke tests passed `2/2`. A temporary
out-of-tree virtual-controller probe also passed: two synchronous `PADRead()`
samples without an intervening event pump matched exactly (`mask=0x80000000`,
`buttons=0x0100`, `stick=(64,0)`). An `SDL_PushEvent` keyboard test correctly
did not change `SDL_GetKeyboardState`; OS/human keyboard input therefore
remains a separate gate.

## Remaining closing fixture

A focused `padmgr_RequestPadData()` test should hold `pc_frame_counter` at `N`,
call the request twice with deterministic input, assert the second call does
not re-update game-owned `now/on/off/last`, then advance to `N+1`, change input,
and assert the expected transition. This would close the exact game-owned
per-frame guard without claiming physical-device input or playability.

No Windows native compile, launch, or controller proof was performed; the
existing Windows audit remains a source-level/toolchain assessment.
