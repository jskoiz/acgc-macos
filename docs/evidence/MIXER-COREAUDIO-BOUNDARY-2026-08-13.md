# Mixer/CoreAudio boundary — 2026-08-13

Lane 76 (`019ffbcc-904f-7673-bc6a-1b309e9dd560`) performed a read-only audit
against PC `f4cb491` and standalone decomp reference `09ca8e8`. The PC tree's
adapted `src/static/jaudio_NES` sources were the translation units for the
focused probes; the standalone decomp tree was cross-checked but not compiled
as the PC probe source.

## Focused results

Native and ASan/UBSan runs passed for:

- mixer → DAC → direct SDL callback PCM;
- PC RSP/NEOS → Cpubuf → DAC → direct callback (1,118/1,120 samples
  nonzero);
- LP64 high-address audio-bank wire/bounds handling;
- high-address `AIInitDMA`/ring-bound handling;
- native RSP command-sidecar pointer registration and fail-closed missing
  pointer behavior.

The CoreAudio/device probe returned explicit skip `77`. SDL reported no live
CoreAudio device, and `system_profiler SPAudioDataType` listed no devices. The
same skip was reproduced with `SDL_AUDIODRIVER=coreaudio`.

## Boundary

The evidence proves software waveform production and direct callback transport,
not a host audio callback cadence or audible output. It does not prove
asset-backed NEOS playback, a full `ac_pc` launch, or device audio. No source,
umbrella docs/gitlinks, ISO, or assets were changed by the lane.

Relevant PC paths are `pc/src/pc_audio.c`, `pc/src/pc_audio_bank.c`,
`src/static/jaudio_NES/internal/aictrl.c`, `cpubuf.c`, `neosthread.c`, and
`audiothread.c`. DMA is implemented in `pc/src/pc_audio.c`; there is no
separate `pc_audio_dma*` file.

Unique lane roots, to retire only after review, were:

```text
/private/tmp/acgc-lane-audio-proof
/private/tmp/acgc-lane-audio-proof-asan
```
