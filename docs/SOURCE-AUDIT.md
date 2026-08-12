# Source, Revision, Licensing, and Toolchain Audit

Snapshot: 2026-08-11, macOS arm64. This is an engineering provenance record,
not legal advice and not permission to redistribute third-party material.

## Repository truth

| Repository | Branch at audit | Recorded commit | Origin |
| --- | --- | --- | --- |
| Umbrella | `c1/apple-port-bootstrap` | parent `1456933eaa1efc34f91adff0fc1dacfb905b2459` | local project |
| ACGC-PC-Port | `c1/macos-portable-disc-core` | `e826aca36ba71a1848ebe3c44d40ab506eb2c04d`, based on `4099d246c927e75b4fd342ca13f4ac4395c55af5` (`v0.9.3-playtest`) | `https://github.com/flyngmt/ACGC-PC-Port.git` |
| ac-decomp | `master` | `09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c` | `https://github.com/ACreTeam/ac-decomp.git` |

The submodules have no nested `.gitmodules` at these commits. The documented
recursive initialization step for `ac-decomp` is therefore a no-op at this pin.
No source edit was made in `ac-decomp`.

## Supported revision

Both upstream READMEs list `GAFE01_00` as the USA revision 0 build. Their
`config/GAFE01_00/build.sha1` files are identical and require:

```text
2AE8F56E7791D37E165BD5900921F2269F9515BF  build/GAFE01_00/static.dol
C59D278AD8542BB05D6CBB632F60A0DB05BEF203  build/GAFE01_00/foresta/foresta.rel
```

The user-owned input exists only at
`local/roms/Animal Crossing (USA).iso`, is ignored by the umbrella repository,
and has the approved SHA-256:

```text
a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d
```

DTK accepted that image. The ignored extracted original `main.dol` and raw REL
match the two expected SHA-1 values above. The new portable Yaz0 decoder also
decoded the compressed REL directly from the image to the expected REL SHA-1.
That compressed temporary verification copy was removed afterward.

These checks establish compatibility with the pinned `GAFE01_00` workflows.
They do not establish a matching reconstructed build or a playable port.

## Licensing and provenance

| Source | Top-level declaration | Engineering consequence |
| --- | --- | --- |
| `ac-decomp` | CC0 1.0 | The project dedicates its own decompilation work as described by its LICENSE. |
| ACGC-PC-Port decomp content | CC0 1.0 | Retains the upstream decomp declaration. |
| ACGC-PC-Port `TARGET_PC` additions | MIT | The PC host additions are declared MIT. |
| bundled FixNES | MIT | Its upstream component is declared MIT. |

The source trees also contain third-party SDK-style headers and notices; for
example, `include/PR/ultratypes.h` carries an SGI proprietary notice. The
top-level licenses must not be read as clearing every bundled notice, Nintendo
brand, or proprietary game asset. A distribution decision requires a separate
file-level provenance and trademark review. The ISO, extracted assets, keys,
and proprietary game data are out of scope for Git and distribution.

## Local toolchain

- macOS 26.5.1 (25F80), Darwin 25.5.0, arm64
- Xcode developer directory: `/Applications/Xcode.app/Contents/Developer`
- AppleClang 21.0.0
- macOS SDK 26.5; iPhoneOS SDK 26.5
- Python 3.14.6
- Ninja 1.13.2
- CMake 4.3.3
- SDL2 2.32.10 from `pkg-config`, arm64
- Wine/Wine64: absent

No compiler, dependency, or runtime was installed during this audit.
