# Windows/x86 compatibility audit

Date: 2026-08-13 HST

This was a read-only audit of `upstream/ACGC-PC-Port` at `f4cb491`
(`c1/macos-host-launch`) against `upstream/ac-decomp` at `09ca8e8b`.
The later Apple-only sink and input-fixture commits were not part of the
audit snapshot. No source, umbrella documentation, gitlink, ISO, or asset was
changed, and no full `ac_pc` link or Windows runtime was attempted.

## Result

No Windows/x86 regression was found by static inspection or the available
focused probes. Portable tests passed `20/20`, and Apple Clang compile-only
probes using `-m32 -D_WIN32` passed. Those probes are ILP32 simulation only;
they do not produce a PE executable and do not establish Windows runtime
compatibility.

The real MSYS2 MinGW i686 gate remains blocked on this arm64 macOS host. The
documented `i686-w64-mingw32-gcc`, `i686-w64-mingw32-g++`,
`i686-w64-mingw32-windres`, MinGW Makefiles generator, Windows sysroot, Wine,
and Wibo wrappers were unavailable. A synthetic Windows configure reached the
first target compile and stopped because the target `string.h`/sysroot was
missing. No Windows sign-off follows.

## Cross-repository scope

The PC build references `build_pc.sh`, `pc/CMakeLists.txt`, and
`cmake/Toolchain-mingw32.cmake`; the decomp reference was used for the exact
`GAFE01_00` revision/config metadata only. The Apple changes under review are
guarded by `APPLE`/`__APPLE__`; the existing SDL/OpenGL and `_WIN32` branches
remain the Windows path. The audit also checked the Windows resource, SDL,
OpenGL, `winmm`, `imm32`, `version`, `setupapi`, PE-export, CRT file-offset,
and directory-enumeration surfaces.

## Verification boundary

The strongest positive evidence is the portable `20/20` test run and the
dependency-free `_WIN32`/ILP32 compile probes. The following remain open:

- a real MSYS2 i686 configure, compile, resource compile, and link;
- execution on Windows with the documented SDL2/OpenGL runtime;
- Windows input/audio/save behavior and playability;
- regression testing of the later current PC tip beyond the isolated Apple
  and fixture-only additions.

The exact lane scratch report, including command output and toolchain probes,
was `/private/tmp/acgc-lane-windows-audit/WINDOWS-X86-AUDIT.md` before review.
