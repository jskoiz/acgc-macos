# Running-game input boundary (2026-08-13)

This read-only lane used the retained exact arm64 binary built from PC source
`9cf9b3f` with decomp reference `09ca8e8b`. The authoritative source now
includes the unrelated test-only Save_t commit `d0e64f5`; no input source was
changed. Logs are recorded under `/private/tmp/acgc-lane-runtime-input`.

## Observed boundary

LLDB launched the real game and stopped at both the SDL event pump and the
game-owned PAD snapshot handoff:

```text
ACGC_SDL_EVENT_BOUNDARY marker=SDL_PollEvent stop=observed breakpoint=1
ACGC_PAD_SNAPSHOT_BOUNDARY marker=PADRead source=pc_pad.c:164 stop=observed breakpoint=2
ACGC_PAD_CALLSTACK PADRead->JUTGamePad::read->padmgr_UpdatePC->padmgr_RequestPadData->game_get_controller
ACGC_PAD_SNAPSHOT buttons=0x0000 stick_x=0 stick_y=0 substick_x=0 substick_y=0 trigger_left=0 trigger_right=0
```

The one OS-event attempt reached only its preparation marker. No keydown or
keyup was posted, and the sampled Space scancode remained `value=0`:

```text
ACGC_OS_EVENT_MARKER prepare_only=1 activation=absent keydown_posted=absent keyup_posted=absent
ACGC_RUNTIME_INPUT_RESULT attempt=1 classification=LIVE_PAD_BOUNDARY_OBSERVED_OS_EVENT_UNAVAILABLE
```

The LLDB run was explicitly closed; no event-sender process remained.

## Crosswalk and boundary

The PC path is `pc_main.c:174` → `SDL_PollEvent`, `pc_pad.c:55` →
`SDL_GetKeyboardState`/controller sampling, and `pc_pad.c:164` → fixed-width
`PCInputSnapshot`/channel-0 `PADStatus`. The decomp side continues through
`JUTGamePad::read`, `PADRead`, `JW_getPadStatus`, and the controller status
consumers. The event path is therefore live and game-owned, but no state
transition was observed in this attempt.

## Evidence boundary

This proves the running game reaches the SDL/PADRead snapshot boundary. It
does not prove keyboard/controller input changes in the game, physical-device
input, a rendered frame, audio, save/load, simulator/device behavior, or
playability. A future input lane needs an authorized, observable OS or
physical-controller event and a changed in-game snapshot.
