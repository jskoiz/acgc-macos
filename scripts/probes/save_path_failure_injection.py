#!/usr/bin/env python3
"""Bounded, synthetic filesystem probe for the modern Apple host lane.

This probe deliberately does not import either upstream project and never
opens the repository's local disc or extracted assets.  It creates one unique
fixture root below /private/tmp, exercises only small synthetic records, and
removes that root before returning.
"""

from __future__ import annotations

import hashlib
import os
from pathlib import Path
import shutil
import tempfile
from dataclasses import dataclass
from typing import Callable, List, Optional, Tuple


MAX_RECORD_BYTES = 1024 * 1024
FIXTURE_PREFIX = "acgc-lane-save-path-"
BUNDLE_ID = "com.acgc.modern-port.probe"
MAGIC = b"ACGC-PATH-PROBE-RECORD\0"
FAIL_AFTER_TEMP_FSYNC = "after-temp-fsync"


class ProbeError(RuntimeError):
    """A failed filesystem contract assertion."""


class InjectedFailure(RuntimeError):
    """A deterministic crash/failure point used by the probe."""


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ProbeError(message)


def assert_within(path: Path, root: Path) -> None:
    resolved_path = path.resolve()
    resolved_root = root.resolve()
    try:
        common = Path(os.path.commonpath((str(resolved_path), str(resolved_root))))
    except ValueError as exc:
        raise ProbeError("fixture paths are on different volumes") from exc
    require(common == resolved_root, f"path escaped fixture root: {path}")


def fsync_directory(directory: Path) -> None:
    """Persist directory-entry changes needed by the rename contract."""

    flags = os.O_RDONLY
    if hasattr(os, "O_DIRECTORY"):
        flags |= os.O_DIRECTORY
    fd = os.open(str(directory), flags)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def write_fsync(path: Path, data: bytes) -> None:
    require(len(data) <= MAX_RECORD_BYTES, f"fixture payload too large: {path}")
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("wb") as handle:
        handle.write(data)
        handle.flush()
        os.fsync(handle.fileno())


def read_bounded(path: Path) -> bytes:
    with path.open("rb") as handle:
        data = handle.read(MAX_RECORD_BYTES + 1)
    require(len(data) <= MAX_RECORD_BYTES, f"fixture payload too large: {path}")
    return data


def remove_fixture_file(path: Path) -> None:
    if path.exists() or path.is_symlink():
        path.unlink()
        fsync_directory(path.parent)


def make_record(label: str) -> bytes:
    require(label.isascii() and label and len(label) <= 64, "invalid synthetic label")
    payload = f"synthetic fixture record: {label}\n".encode("ascii")
    digest = hashlib.sha256(payload).digest()
    return MAGIC + len(payload).to_bytes(4, "big") + digest + payload


def decode_record(data: bytes) -> Optional[bytes]:
    header_size = len(MAGIC) + 4 + hashlib.sha256().digest_size
    if len(data) < header_size or not data.startswith(MAGIC):
        return None
    payload_size_start = len(MAGIC)
    payload_size_end = payload_size_start + 4
    payload_size = int.from_bytes(data[payload_size_start:payload_size_end], "big")
    digest_start = payload_size_end
    digest_end = digest_start + hashlib.sha256().digest_size
    payload = data[digest_end:]
    if payload_size != len(payload):
        return None
    if hashlib.sha256(payload).digest() != data[digest_start:digest_end]:
        return None
    return payload


def valid_record(path: Path) -> Optional[bytes]:
    try:
        return decode_record(read_bounded(path))
    except (OSError, ProbeError):
        return None


@dataclass(frozen=True)
class Namespace:
    """Synthetic stand-in for one process's macOS data roots."""

    root: Path
    bundle_id: str = BUNDLE_ID

    @property
    def home(self) -> Path:
        return self.root / "home"

    @property
    def system_temp(self) -> Path:
        return self.root / "system-temp"

    @property
    def application_support(self) -> Path:
        return self.home / "Library" / "Application Support" / self.bundle_id

    @property
    def cache(self) -> Path:
        return self.home / "Library" / "Caches" / self.bundle_id

    @property
    def logs(self) -> Path:
        return self.home / "Library" / "Logs" / self.bundle_id

    @property
    def temporary(self) -> Path:
        return self.system_temp / self.bundle_id

    @property
    def save_directory(self) -> Path:
        return self.application_support / "Saves" / "slot-0"

    @property
    def record(self) -> Path:
        return self.save_directory / "fixture-record.bin"

    @property
    def directory_roots(self) -> Tuple[Path, ...]:
        return (
            self.application_support,
            self.cache,
            self.logs,
            self.temporary,
            self.save_directory,
        )

    def ensure(self) -> None:
        for directory in self.directory_roots:
            directory.mkdir(parents=True, exist_ok=True)
            assert_within(directory, self.root)


def assert_layout(namespace: Namespace, fixture_root: Path) -> None:
    namespace.ensure()
    require(namespace.application_support.name == namespace.bundle_id, "support root is not bundle-scoped")
    require(namespace.cache.name == namespace.bundle_id, "cache root is not bundle-scoped")
    require(namespace.logs.name == namespace.bundle_id, "log root is not bundle-scoped")
    require(namespace.temporary.name == namespace.bundle_id, "temporary root is not bundle-scoped")
    category_roots = (
        namespace.application_support,
        namespace.cache,
        namespace.logs,
        namespace.temporary,
    )
    require(len({directory.resolve() for directory in category_roots}) == len(category_roots),
            "Application Support/cache/log/temp roots overlap")
    for directory in namespace.directory_roots:
        require(directory.is_dir(), f"missing directory: {directory}")
        assert_within(directory, namespace.root)
        assert_within(directory, fixture_root)


def write_path_artifacts(namespace: Namespace) -> None:
    artifacts = (
        (namespace.application_support / "probe-settings.json", b'{"synthetic":true}\n'),
        (namespace.cache / "fixture-cache.bin", b"synthetic cache\n"),
        (namespace.logs / "probe.log", b"synthetic log\n"),
        (namespace.temporary / "fixture-scratch.bin", b"synthetic temporary data\n"),
    )
    for path, data in artifacts:
        write_fsync(path, data)
        assert_within(path, namespace.root)
    require((namespace.cache / "probe-settings.json").exists() is False, "support/cache roots overlap")
    require((namespace.logs / "probe-settings.json").exists() is False, "support/log roots overlap")
    require((namespace.temporary / "probe-settings.json").exists() is False, "support/temp roots overlap")


def stage_path(target: Path) -> Path:
    return target.with_name(target.name + ".tmp")


def backup_path(target: Path) -> Path:
    return target.with_name(target.name + ".bak1")


def recovery_stage_path(target: Path) -> Path:
    return target.with_name(target.name + ".recovery.tmp")


def atomic_replace(target: Path, data: bytes, failure_point: Optional[str] = None) -> None:
    """Stage and replace in one directory, with a bounded failure hook.

    The target is kept in place while the staged bytes and the backup copy are
    flushed.  os.replace() is then used for the same-directory namespace
    switch.  The helper is intentionally independent of the game's GCI or
    Save_t format.
    """

    stage = stage_path(target)
    backup = backup_path(target)
    require(stage.parent == target.parent, "atomic stage is not a sibling of target")
    require(not stage.exists(), f"unexpected pre-existing stage: {stage}")
    write_fsync(stage, data)
    fsync_directory(stage.parent)

    if failure_point == FAIL_AFTER_TEMP_FSYNC:
        raise InjectedFailure("injected failure after staged record fsync")

    if target.exists():
        previous = read_bounded(target)
        write_fsync(backup, previous)
        fsync_directory(backup.parent)

    os.replace(stage, target)
    fsync_directory(target.parent)


def recover_record(target: Path) -> Tuple[str, bytes]:
    """Recover a synthetic record from primary, orphan temp, or backup."""

    primary = valid_record(target)
    temp = stage_path(target)
    backup = backup_path(target)

    if primary is not None:
        # A valid primary wins over an orphaned candidate from an interrupted
        # write.  The known stale stage is safe to remove inside this fixture.
        remove_fixture_file(temp)
        return "primary", primary

    staged = valid_record(temp)
    if staged is not None:
        os.replace(temp, target)
        fsync_directory(target.parent)
        return "temp", staged

    # A bad stage must not block a valid backup from restoring the primary.
    remove_fixture_file(temp)
    backed_up_raw: Optional[bytes]
    try:
        backed_up_raw = read_bounded(backup)
    except (OSError, ProbeError):
        backed_up_raw = None
    backed_up = decode_record(backed_up_raw) if backed_up_raw is not None else None
    if backed_up is not None and backed_up_raw is not None:
        recovery_stage = recovery_stage_path(target)
        require(not recovery_stage.exists(), "unexpected pre-existing recovery stage")
        write_fsync(recovery_stage, backed_up_raw)
        fsync_directory(recovery_stage.parent)
        os.replace(recovery_stage, target)
        fsync_directory(target.parent)
        return "backup", backed_up

    raise ProbeError("no valid synthetic record available for recovery")


def test_path_layout(namespace: Namespace, fixture_root: Path) -> None:
    assert_layout(namespace, fixture_root)
    write_path_artifacts(namespace)
    require(valid_record(namespace.record) is None, "path-layout test unexpectedly found a save record")


def test_isolation(fixture_root: Path) -> None:
    first = Namespace(fixture_root / "instance-a")
    second = Namespace(fixture_root / "instance-b")
    assert_layout(first, fixture_root)
    assert_layout(second, fixture_root)

    first_marker = first.application_support / "isolation-marker.bin"
    second_marker = second.application_support / "isolation-marker.bin"
    write_fsync(first_marker, b"instance-a\n")
    write_fsync(second_marker, b"instance-b\n")
    require(first_marker != second_marker, "isolated namespaces resolved to one path")
    require(read_bounded(first_marker) == b"instance-a\n", "instance-a marker changed")
    require(read_bounded(second_marker) == b"instance-b\n", "instance-b marker changed")
    require(first_marker.relative_to(first.root) == second_marker.relative_to(second.root),
            "isolation test did not exercise the same relative path")


def test_atomic_and_recovery(namespace: Namespace) -> None:
    target = namespace.record
    baseline = make_record("baseline")
    replacement = make_record("replacement")
    from_temp = make_record("from-temp")

    atomic_replace(target, baseline)
    require(valid_record(target) == baseline[len(MAGIC) + 4 + hashlib.sha256().digest_size:],
            "initial synthetic record is invalid")

    injected = False
    try:
        atomic_replace(target, replacement, FAIL_AFTER_TEMP_FSYNC)
    except InjectedFailure:
        injected = True
    require(injected, "failure injection did not fire")
    require(read_bounded(target) == baseline, "target changed before atomic namespace replace")
    require(valid_record(stage_path(target)) == replacement[len(MAGIC) + 4 + hashlib.sha256().digest_size:],
            "staged candidate was not durable/valid")

    source, recovered = recover_record(target)
    require(source == "primary", f"valid primary lost to orphan candidate: {source}")
    require(recovered == baseline[len(MAGIC) + 4 + hashlib.sha256().digest_size:],
            "primary recovery changed the current record")
    require(not stage_path(target).exists(), "stale temp stage was not cleaned")

    atomic_replace(target, replacement)
    require(valid_record(target) == replacement[len(MAGIC) + 4 + hashlib.sha256().digest_size:],
            "successful atomic replace did not publish replacement")
    require(valid_record(backup_path(target)) == baseline[len(MAGIC) + 4 + hashlib.sha256().digest_size:],
            "successful replace did not preserve a valid backup")

    write_fsync(target, b"corrupted synthetic primary\n")
    require(valid_record(target) is None, "corruption injection did not invalidate primary")
    source, recovered = recover_record(target)
    require(source == "backup", f"corrupt primary did not recover from backup: {source}")
    require(recovered == baseline[len(MAGIC) + 4 + hashlib.sha256().digest_size:],
            "backup recovery returned the wrong synthetic record")
    require(valid_record(target) == recovered, "backup recovery did not restore primary")
    require(valid_record(backup_path(target)) == recovered, "backup was damaged during recovery")

    injected = False
    try:
        atomic_replace(target, from_temp, FAIL_AFTER_TEMP_FSYNC)
    except InjectedFailure:
        injected = True
    require(injected, "second failure injection did not fire")
    write_fsync(target, b"corrupted primary with valid orphan temp\n")
    source, recovered = recover_record(target)
    require(source == "temp", f"valid orphan temp was not promoted: {source}")
    require(recovered == from_temp[len(MAGIC) + 4 + hashlib.sha256().digest_size:],
            "orphan temp recovery returned the wrong synthetic record")
    require(not stage_path(target).exists(), "promoted temp stage still exists")


def run_probe(fixture_root: Path) -> int:
    first = Namespace(fixture_root / "instance-a")
    checks: List[Tuple[str, Callable[[], None]]] = [
        ("path-layout", lambda: test_path_layout(first, fixture_root)),
        ("isolation", lambda: test_isolation(fixture_root)),
        ("atomic-replace-and-failure-injection", lambda: test_atomic_and_recovery(first)),
    ]
    for name, check in checks:
        check()
        print(f"PASS {name}")
    print("sanitizer=not-applicable (pure Python synthetic fixture)")
    print(f"RESULT PASS checks={len(checks)}")
    return 0


def main() -> int:
    fixture_root = Path(tempfile.mkdtemp(prefix=FIXTURE_PREFIX, dir="/private/tmp")).resolve()
    print(f"fixture_root={fixture_root}")
    exit_code = 1
    try:
        require(fixture_root.parent == Path("/private/tmp"), "fixture root escaped /private/tmp")
        exit_code = run_probe(fixture_root)
    except Exception as exc:
        print(f"RESULT FAIL {type(exc).__name__}: {exc}")
    finally:
        shutil.rmtree(fixture_root)
        print("cleanup=removed")
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
