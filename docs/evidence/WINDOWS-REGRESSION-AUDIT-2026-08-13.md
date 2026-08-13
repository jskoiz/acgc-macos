# Windows/x86 regression audit after graph/GX changes (2026-08-13)

This read-only audit is bound to PC source `c1/macos-host-launch` at `9cf9b3f`
and decomp `master` at `09ca8e8b`. The authoritative PC source later advanced
to `d0e64f5` with a test-only Save_t fixture; no Windows-related source was
changed by that commit. Unique logs are under
`/private/tmp/acgc-lane-windows-current/run.DvRwfU`.

## Toolchain boundary

| Check | Result |
| --- | --- |
| Apple Clang `-D_WIN32` strict graph syntax | Pass |
| Apple Clang `-m32 -D_WIN32` syntax and preprocessor | Pass; `_WIN32=1`, `UINTPTR_MAX=4294967295` |
| `clang -target i686-w64-windows-gnu` | Blocked: no Windows sysroot (`string.h` missing) |
| `clang -target i686-pc-windows-msvc` | Blocked: no Windows sysroot (`string.h` missing) |
| MinGW i686 compiler/resource tools | Not installed |

The local `-m32` result is an Apple-toolchain ABI simulation, not Windows
compile/link proof. SDL2 `2.32.10` and CMake `4.3.3` are available locally.

## Regression crosswalk

- `6e4aded` confines graph classification to the fixed-width submission API,
  classifier, graph call site, and seam tests; Windows/OpenGL/SDL paths are
  unchanged. It requires an exact `G_ENDDL` pair and fails closed for indirect,
  malformed, oversized, or unterminated sources.
- `e22cbc5` adds an optional packet observer before the existing OpenGL flush;
  Windows CMake still selects the normal PC/OpenGL path.
- `9cf9b3f` only renames an embedded Metal fixture shader local (`vertex` to
  `geometry_vertex`); it has no Windows/OpenGL/SDL behavior.

The optional GX handoff emits only explicitly supported packets and leaves the
OpenGL fallback untouched. Its Apple device portion remains a separate skip
`77` on this host.

## Focused checks

- `_WIN32` C-only portable probes: 3/3 passed.
- `_WIN32` static GBI compile probes: passed.
- Native comparison suite: 4/4 passed.
- Graph seam test: passed, including indirect-list rejection and legacy
  fallback routing.
- GX semantic handoff test: passed and reports the GL fallback untouched.

One host-only caveat: applying `_WIN32` to all C++ tests on macOS exposes
libc++ locale macro differences. The C-only compatibility probes pass, and the
same C++ tests pass without the artificial host `_WIN32` define.

## Evidence boundary

No source/docs/branch/submodule/ISO changes, full link, launch, or LLDB session
were performed. No Windows regression was found in the requested source diff,
but native Windows/x86 compile, link, launch, and device behavior remain
unproven until a real MinGW/i686 compiler and Windows sysroot are available.
