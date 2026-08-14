# Mixer/DMA/CoreAudio boundary audit at `dbf6986`

Lane 114 (`019ffdba-e4f1-71d1-82fd-57561a66e50a`) performed a read-only
two-upstream crosswalk and focused software/adapter verification at PC
`dbf6986` and ac-decomp `09ca8e8b`. It made no source, umbrella, ISO, or asset
changes and did not run a full `ac_pc` link or LLDB.

## Crosswalk

- The decomp oracle routes `Jac_VframeWork` through `MixDsp`/`MixCpu`,
  `Jac_UpdateDAC`, and `AIInitDMA` using the three-buffer JAudio flow.
- The PC port preserves that flow while retaining native `AINativeAddress`
  values at the DMA seam.
- The PC sink consumes the DMA-fed SPSC ring through the SDL/CoreAudio adapter;
  fixed-width audio command records remain separate from native pointer sidecar
  state.

## Focused results

Build/test roots:

- `/private/tmp/acgc-lane-mixer-coreaudio-current-native-VDoxjP`
- `/private/tmp/acgc-lane-mixer-coreaudio-current-sanitizer-4WmGA1`

The native and combined ASan/UBSan CMake audio sets each passed `4/4` with no
sanitizer diagnostics. Software mixer → DAC → callback, synthetic RSP/NEOS →
CPU buffer → DAC, high-address audio-bank bounds, high-address `AIInitDMA`, and
native audio-command pointer sidecar probes all passed. The RSP fixture reported
`1118` nonzero samples.

The host CoreAudio adapter opened `32000 Hz`, stereo, `512`-sample buffers on
the built-in device. Native and sanitizer cadence probes each saw zero
underruns and overruns; the forced `SDL_AUDIODRIVER=coreaudio` path also passed.
The producer was intentionally silent, so no audible-output or recording proof
exists.

## Claim boundary

Proven: source crosswalk, software waveform/transport fixtures, high-address
DMA safety, and host callback cadence. Not proven: non-silent game-owned PCM,
human-audible output, full-game audio, input, save/device persistence, Metal,
pixels, or playability. The next audio gate is an explicitly authorized
asset-backed NEOS path that produces nonzero PCM, followed by a separately
authorized non-silent device acceptance run.
