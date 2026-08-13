# macOS filesystem and atomic-save adapter

Run date: 2026-08-12. This is an umbrella-owned host adapter/probe. It does not
initialize, build, link, or modify either upstream submodule, and it does not
read, copy, extract, or package the local ISO.

## Contract

The macOS host supplies the bundle's `Contents/Resources` directory. The
adapter derives the three writable roots from the sandbox/container home using
Apple's conventional layout:

```text
<bundle>/Contents/Resources/                   immutable game resources
<home>/Library/Application Support/<bundle-id> persistent user data and saves
<home>/Library/Caches/<bundle-id>              disposable generated data
<home>/Library/Logs/<bundle-id>                diagnostic logs
```

`CFFIXED_USER_HOME` is accepted for deterministic local verification and falls
back to `HOME`; a production host should supply the bundle resource path from
its bundle object and let the sandbox determine the home. The adapter creates
only the three writable roots, with mode `0700`. Files written by the adapter
use mode `0600`.

Resource paths are resolvable for reads but the write API rejects the resource
role before opening a file. Relative paths reject absolute paths, empty
components, `.`/`..`, control characters, and traversal. Save slots are a
single restricted component and are always placed below
`Application Support/saves/`.

The save envelope is deliberately not a GameCube format:

```text
4 bytes  magic ACGS
2 bytes  little-endian envelope version
2 bytes  little-endian header size
4 bytes  little-endian opaque payload length
4 bytes  little-endian CRC-32 of the opaque payload
n bytes  opaque payload supplied by the future Save_t/GCI codec
```

The adapter verifies the envelope size, magic, version, header size, maximum
payload bound, and CRC before exposing payload bytes. It does not interpret or
claim to serialize `Save_t`, GCI, CARD, or any game-level save record.

## Atomic commit behavior

Each commit writes a `mkstemp` file in the destination directory, applies mode
`0600`, writes all bytes, calls `fsync`, calls macOS `F_FULLFSYNC`, closes the
file, renames the temporary file over the destination, and calls `fsync` on the
containing directory. If a pre-rename step fails, the temporary file is
removed. A successful commit therefore has same-filesystem rename semantics and
leaves no adapter-created temporary file. A directory-sync failure after rename
is reported as an I/O failure; the adapter does not pretend that the commit was
fully durable.

This is crash-consistent adapter behavior, not a power-loss or crash-injection
proof. The probe verifies the durability calls through its report structure,
replacement visibility, no-temp residue, and a fresh read of the committed
record. A real game save/reload and process-restart gate remain separate.

## Reproducible proof

Run from the umbrella checkout:

```sh
./scripts/verify-filesystem-save.sh
```

The same probe can be rebuilt with AddressSanitizer and UndefinedBehaviorSanitizer:

```sh
./scripts/verify-filesystem-save.sh --asan
```

Both modes use the same ignored lane root by default and create a fresh
`run.XXXXXX` fixture directory for each invocation.

The default build and run root is the unique ignored path
`/private/tmp/acgc-lane-filesystem-build`. Override it only when a separate
isolated temp root is needed:

```sh
ACGC_FILESYSTEM_BUILD_DIR=/private/tmp/acgc-lane-filesystem-build-alt \
  ./scripts/verify-filesystem-save.sh
```

The probe creates a synthetic `.iso` sentinel containing no proprietary bytes,
then asserts that the lane contains exactly that one sentinel and no matching
file under Application Support, Caches, or Logs. It also proves:

- distinct bundle-resource, Application Support, cache, and log roots;
- private directory/file modes and role-specific writes;
- bundle-resource write rejection;
- parent/absolute path and invalid save-slot rejection;
- first-save round trip and atomic replacement round trip;
- data `fsync`, macOS `F_FULLFSYNC`, rename, and containing-directory `fsync`;
- no successful-save temporary-file residue;
- unrenamed temp artifacts do not replace the committed save;
- checksum corruption and truncation are rejected;
- undersized read buffers fail closed.

The probe is intentionally independent of the full runtime, the ISO, SDL,
OpenGL, Metal, Save_t/GCI codec, CARD implementation, and source submodule
state.

## iOS remaining work

This lane proves only the macOS host-side role and atomic-write contract. iOS
still needs a UIKit/scene host to provide the bundle resource URL and container
directories, file protection appropriate to the save policy, lifecycle-aware
flush/background handling, interruption and termination behavior, and a
Simulator proof followed by separately authorized physical-device evidence.
The shared game core must still supply real Save_t/GCI bytes, and a process
restart plus game-level save/reload proof must be added before claiming iOS
persistence or playability.
