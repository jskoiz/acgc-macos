# ACGC Modern Port Guidance

## Repository boundaries

- Treat `upstream/ACGC-PC-Port` and `upstream/ac-decomp` as separate upstream
  histories represented by Git submodules.
- Do not vendor, flatten, or rewrite either upstream history.
- Put umbrella documentation, reproducible scripts, and cross-repository evidence
  in this repository. Put source changes in the owning submodule on an explicit
  topic branch.
- Never commit, upload, publish, or redistribute the ISO or extracted proprietary
  game assets. Keep them under `local/`, which is ignored by Git.

## Porting posture

- Target modern macOS first as the desktop proving ground, then iOS using shared
  portable game logic and narrow platform adapters.
- Preserve deterministic game behavior while isolating renderer, windowing,
  input, audio, filesystem/save, timing, and lifecycle dependencies.
- Prefer a native Metal-capable rendering path for Apple platforms. Do not treat
  deprecated desktop OpenGL 3.3 as an iOS solution.
- Keep upstream Windows behavior working unless a scoped porting decision says
  otherwise. Avoid compatibility shims that permanently duplicate architecture.
- Do not claim a platform works from compilation alone. Separate build, launch,
  rendered-frame, input, audio, save/load, and device proof.

## Git and verification

- Before editing, verify the umbrella root, active submodule, branch, status, and
  current diff. Never edit a detached submodule HEAD.
- Use focused branches and reviewable commits in the owning repository, then
  update the umbrella submodule pointer only after verification.
- Keep generated extraction, build, cache, and log output outside Git.
