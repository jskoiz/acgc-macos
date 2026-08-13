#!/usr/bin/env python3
"""Parse ACGC runtime evidence without launching or building the game.

This probe is deliberately evidence-only.  It accepts logs and, when a future
runtime emits the strict ``[ACGC_EVIDENCE]`` records, an explicitly named
readback artifact.  It never treats a heartbeat, a renderer fixture, a
command-buffer word, or a graph prefix as a visible game frame.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Sequence, Tuple


DEFAULT_OUTPUT_DIR = Path("/private/tmp/acgc-lane-frame-evidence-build")
SCHEMA_VERSION = "acgc-frame-evidence/v1"

EVENT_RE = re.compile(r"\[ACGC_EVIDENCE\]\s+(?P<body>.*)$")
GRAPH_CAPTURE_RE = re.compile(
    r"\[GRAPH_CAPTURE\]\s+"
    r"version=(?P<version>[0-9]+)\s+"
    r"frame=(?P<frame>[0-9]+)\s+"
    r"source_capacity=(?P<source_capacity>[0-9]+)\s+"
    r"captured=(?P<captured>[0-9]+)\s+"
    r"words=(?P<words>[0-9a-fA-F,]+)"
)
KV_RE = re.compile(r"(?P<key>[A-Za-z0-9_.-]+)=(?P<value>[^\s]+)")
NEOS_RE = re.compile(r"\[NEOS_OUT\]\s+frame=(?P<frame>[0-9]+)")
PROCESS_LAUNCHED_RE = re.compile(r"Process\s+[0-9]+\s+launched:.*AnimalCrossing")
SUPERVISOR_LAUNCH_RE = re.compile(r"Actual game process launch gate passed:")

NO_DEVICE_PATTERNS = (
    re.compile(r"SKIP\s*\(no macOS Metal device available\)", re.IGNORECASE),
    re.compile(r"no system Metal device was available", re.IGNORECASE),
    re.compile(r"no macOS Metal device available", re.IGNORECASE),
    re.compile(r"MTLCreateSystemDefaultDevice.*(?:nil|NULL|unavailable)", re.IGNORECASE),
    re.compile(r"Metal device unavailable", re.IGNORECASE),
)
NO_WINDOW_PATTERNS = (
    re.compile(r"SDL_Init failed:.*did not add any displays", re.IGNORECASE),
    re.compile(r"(?:no|without a)\s+window\b", re.IGNORECASE),
    re.compile(r"window\s+(?:unavailable|not created|missing)", re.IGNORECASE),
    re.compile(r"drawable unavailable", re.IGNORECASE),
)
FATAL_RUNTIME_PATTERNS = (
    re.compile(r"EXC_BAD_ACCESS", re.IGNORECASE),
    re.compile(r"SIGSEGV", re.IGNORECASE),
    re.compile(r"Abort trap", re.IGNORECASE),
    re.compile(r"segmentation fault", re.IGNORECASE),
    re.compile(r"process exited before the .* launch gate", re.IGNORECASE),
)
FIXTURE_PASS_PATTERNS = (
    re.compile(r"Metal geometry fixture command-buffer verification PASSED:", re.IGNORECASE),
    re.compile(r"Metal packet consumer: CPU packet/state/fixture contract PASS;", re.IGNORECASE),
)
FIXTURE_CPU_PACKET_PATTERNS = (
    re.compile(r"renderer fixture tests: PASS .*no Metal or game rendering", re.IGNORECASE),
    re.compile(r"renderer geometry tests: PASS \(fixed-width triangle packet\)", re.IGNORECASE),
)
BOOT_MARKERS = (
    "[PC] boot: calling sound_initial...",
    "[PC] boot: calling initial_menu_init...",
    "[PC] boot: calling dvderr_init...",
    "[PC] boot: calling sound_initial2...",
    "[PC] boot: loading COPYDATE...",
    "[PC] boot: entering HotStartEntry loop",
)


@dataclass
class EvidenceInput:
    path: Path
    role: str
    raw: bytes
    lines: List[str]
    sha256: str
    mtime: str

    @classmethod
    def load(cls, path: Path, role: str) -> "EvidenceInput":
        raw = path.read_bytes()
        text = raw.decode("utf-8", errors="replace")
        mtime = datetime.fromtimestamp(path.stat().st_mtime, timezone.utc).isoformat()
        return cls(
            path=path.resolve(),
            role=role,
            raw=raw,
            lines=text.splitlines(),
            sha256=hashlib.sha256(raw).hexdigest(),
            mtime=mtime,
        )

    def matches(self, pattern: re.Pattern[str], limit: int = 20) -> List[Tuple[int, str]]:
        matches: List[Tuple[int, str]] = []
        for number, line in enumerate(self.lines, start=1):
            if pattern.search(line):
                matches.append((number, line.strip()))
                if len(matches) >= limit:
                    break
        return matches

    def contains(self, text: str) -> List[Tuple[int, str]]:
        matches: List[Tuple[int, str]] = []
        for number, line in enumerate(self.lines, start=1):
            if text in line:
                matches.append((number, line.strip()))
        return matches


@dataclass
class EvidenceEvent:
    stage: str
    status: str
    fields: Dict[str, str]
    source: EvidenceInput
    line: int
    text: str
    legacy: bool = False

    def field(self, name: str, default: Optional[str] = None) -> Optional[str]:
        return self.fields.get(name, default)

    def as_dict(self) -> Dict[str, Any]:
        return {
            "stage": self.stage,
            "status": self.status,
            "fields": dict(self.fields),
            "source": str(self.source.path),
            "role": self.source.role,
            "line": self.line,
            "text": self.text,
            "legacy": self.legacy,
        }


def command_output(args: Sequence[str], cwd: Path) -> Optional[str]:
    try:
        result = subprocess.run(
            list(args),
            cwd=str(cwd),
            check=False,
            capture_output=True,
            text=True,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    if result.returncode != 0:
        return None
    return result.stdout.strip()


def git_source_info(source_dir: Optional[Path], expected_revision: Optional[str]) -> Dict[str, Any]:
    if source_dir is None:
        return {
            "path": None,
            "available": False,
            "authority": "UNVERIFIED_NO_SOURCE_DIR",
        }
    source_dir = source_dir.resolve()
    info: Dict[str, Any] = {
        "path": str(source_dir),
        "available": source_dir.is_dir(),
        "expected_revision": expected_revision,
    }
    if not source_dir.is_dir():
        info["authority"] = "UNVERIFIED_SOURCE_DIR_MISSING"
        return info

    head = command_output(["git", "rev-parse", "HEAD"], source_dir)
    branch = command_output(["git", "branch", "--show-current"], source_dir)
    tree = command_output(["git", "rev-parse", "HEAD^{tree}"], source_dir)
    status = command_output(["git", "status", "--porcelain=v1"], source_dir)
    info.update(
        {
            "head": head,
            "branch": branch or "(detached)",
            "tree": tree,
            "clean": status == "",
            "dirty_file_count": len(status.splitlines()) if status else 0,
        }
    )

    expected_commit = None
    expected_tree = None
    if expected_revision:
        expected_commit = command_output(["git", "rev-parse", expected_revision], source_dir)
        expected_tree = command_output(["git", "rev-parse", f"{expected_revision}^{{tree}}"], source_dir)
    info["expected_commit"] = expected_commit
    info["expected_tree"] = expected_tree
    head_matches = bool(head and expected_commit and head == expected_commit)
    tree_matches = bool(tree and expected_tree and tree == expected_tree)
    info["head_matches_expected"] = head_matches
    info["tree_matches_expected"] = tree_matches
    if expected_revision is None:
        info["authority"] = "SOURCE_CAPTURED_NO_EXPECTED_REVISION"
    elif head_matches and info["clean"]:
        info["authority"] = "EXACT_CLEAN"
    elif tree_matches and not info["clean"]:
        info["authority"] = "TREE_MATCH_DIRTY"
    elif head_matches:
        info["authority"] = "COMMIT_MATCH_DIRTY"
    else:
        info["authority"] = "MISMATCH_OR_UNRESOLVED"
    return info


def parse_events(source: EvidenceInput) -> List[EvidenceEvent]:
    events: List[EvidenceEvent] = []
    for number, raw_line in enumerate(source.lines, start=1):
        line = raw_line.strip()
        marker = EVENT_RE.search(line)
        if marker:
            fields = {match.group("key"): match.group("value") for match in KV_RE.finditer(marker.group("body"))}
            stage = fields.get("stage")
            status = fields.get("status")
            if stage and status:
                events.append(
                    EvidenceEvent(
                        stage=stage,
                        status=status.lower(),
                        fields=fields,
                        source=source,
                        line=number,
                        text=line,
                    )
                )

        graph_marker = GRAPH_CAPTURE_RE.search(line)
        if graph_marker and source.role in {"runtime", "historical_runtime"}:
            captured = int(graph_marker.group("captured"))
            words = graph_marker.group("words").split(",")
            fields = {
                "stage": "game_owned_submit",
                "status": "observed",
                "owner": "game",
                "kind": "graph",
                "frame": graph_marker.group("frame"),
                "version": graph_marker.group("version"),
                "source_capacity": graph_marker.group("source_capacity"),
                "captured": str(captured),
                "word_count": str(len(words)),
                "complete": "0",
                "reason": "legacy_graph_capture_prefix_has_no_complete_flag",
            }
            events.append(
                EvidenceEvent(
                    stage="game_owned_submit",
                    status="observed",
                    fields=fields,
                    source=source,
                    line=number,
                    text=line,
                    legacy=True,
                )
            )
    return events


def first_match(inputs: Iterable[EvidenceInput], patterns: Sequence[re.Pattern[str]]) -> Optional[Dict[str, Any]]:
    for source in inputs:
        for pattern in patterns:
            matches = source.matches(pattern, limit=1)
            if matches:
                line, text = matches[0]
                return {"source": str(source.path), "role": source.role, "line": line, "text": text}
    return None


def all_matches(inputs: Iterable[EvidenceInput], patterns: Sequence[re.Pattern[str]], limit: int = 12) -> List[Dict[str, Any]]:
    found: List[Dict[str, Any]] = []
    seen: set[Tuple[str, int, str]] = set()
    for source in inputs:
        for pattern in patterns:
            for line, text in source.matches(pattern, limit=limit):
                key = (str(source.path), line, text)
                if key in seen:
                    continue
                seen.add(key)
                found.append({"source": str(source.path), "role": source.role, "line": line, "text": text})
                if len(found) >= limit:
                    return found
    return found


def excerpts_for_markers(source: EvidenceInput, markers: Sequence[str], limit: int = 8) -> List[Dict[str, Any]]:
    excerpts: List[Dict[str, Any]] = []
    for number, line in enumerate(source.lines, start=1):
        if any(marker in line for marker in markers):
            excerpts.append({"source": str(source.path), "role": source.role, "line": number, "text": line.strip()})
            if len(excerpts) >= limit:
                break
    return excerpts


def gate(
    name: str,
    status: str,
    authority: str,
    notes: str,
    evidence: Optional[Sequence[Dict[str, Any]]] = None,
    **extra: Any,
) -> Dict[str, Any]:
    result: Dict[str, Any] = {
        "name": name,
        "status": status,
        "authority": authority,
        "notes": notes,
        "evidence": list(evidence or []),
    }
    result.update(extra)
    return result


def event_status(events: Sequence[EvidenceEvent], stage: str, owner: Optional[str] = None) -> List[EvidenceEvent]:
    return [
        event
        for event in events
        if event.stage == stage and (owner is None or event.field("owner") == owner)
    ]


def event_evidence(events: Sequence[EvidenceEvent], limit: int = 8) -> List[Dict[str, Any]]:
    return [
        {"source": str(event.source.path), "role": event.source.role, "line": event.line, "text": event.text}
        for event in events[:limit]
    ]


def normalized_pass(events: Sequence[EvidenceEvent], stage: str, owner: Optional[str] = None) -> List[EvidenceEvent]:
    return [event for event in event_status(events, stage, owner) if event.status in {"pass", "passed"}]


def validate_readback_event(event: EvidenceEvent, allowed_artifacts: Sequence[Path]) -> Tuple[str, str, Dict[str, Any]]:
    fields = event.fields
    required = ("frame", "surface", "width", "height", "bytes", "format", "sha256", "artifact")
    missing = [key for key in required if not fields.get(key)]
    if missing:
        return (
            "UNPROVEN_READBACK_ARTIFACT",
            f"readback marker is missing required fields: {', '.join(missing)}",
            {},
        )
    if fields.get("surface") != "window":
        return (
            "UNPROVEN_NOT_VISIBLE_SURFACE",
            f"readback surface={fields.get('surface')} is not an explicitly visible window surface",
            {},
        )
    try:
        expected_bytes = int(fields["bytes"])
        width = int(fields["width"])
        height = int(fields["height"])
    except ValueError:
        return ("FAIL_INVALID_READBACK", "readback dimensions or byte count are not integers", {})
    expected_hash = fields["sha256"].lower()
    if expected_bytes <= 0 or width <= 0 or height <= 0 or not re.fullmatch(r"[0-9a-f]{64}", expected_hash):
        return ("FAIL_INVALID_READBACK", "readback dimensions, byte count, or sha256 are invalid", {})
    artifact = Path(fields["artifact"]).expanduser()
    if not artifact.is_absolute():
        artifact = (Path.cwd() / artifact).resolve()
    if allowed_artifacts and artifact not in {path.resolve() for path in allowed_artifacts}:
        return ("FAIL_UNDECLARED_READBACK", "readback artifact was not supplied with --readback-artifact", {})
    if not artifact.is_file():
        return ("FAIL_READBACK_ARTIFACT_MISSING", f"readback artifact is missing: {artifact}", {"artifact": str(artifact)})
    actual_bytes = artifact.stat().st_size
    actual_hash = hashlib.sha256(artifact.read_bytes()).hexdigest()
    if actual_bytes != expected_bytes or actual_hash != expected_hash:
        return (
            "FAIL_READBACK_ARTIFACT_MISMATCH",
            f"readback artifact bytes/hash mismatch: expected {expected_bytes}/{expected_hash}, got {actual_bytes}/{actual_hash}",
            {"artifact": str(artifact), "actual_bytes": actual_bytes, "actual_sha256": actual_hash},
        )
    return (
        "PASS",
        "window-surface readback artifact exists and matches the runtime marker",
        {"artifact": str(artifact), "bytes": actual_bytes, "sha256": actual_hash, "width": width, "height": height},
    )


def evaluate(
    inputs: Sequence[EvidenceInput],
    runtime_source: Dict[str, Any],
    renderer_source: Dict[str, Any],
    allowed_artifacts: Sequence[Path],
) -> Dict[str, Any]:
    runtime_inputs = [source for source in inputs if source.role == "runtime"]
    renderer_inputs = [source for source in inputs if source.role == "renderer_fixture"]
    historical_inputs = [source for source in inputs if source.role == "historical_runtime"]
    current_events = [event for source in runtime_inputs for event in parse_events(source)]
    renderer_events = [event for source in renderer_inputs for event in parse_events(source)]
    historical_events = [event for source in historical_inputs for event in parse_events(source)]

    neos_matches = all_matches(runtime_inputs, [NEOS_RE], limit=1000)
    neos_frames: List[int] = []
    for item in neos_matches:
        match = NEOS_RE.search(item["text"])
        if match:
            neos_frames.append(int(match.group("frame")))
    fatal_matches = all_matches(runtime_inputs, FATAL_RUNTIME_PATTERNS, limit=8)
    supervisor_match = first_match(runtime_inputs, [SUPERVISOR_LAUNCH_RE])
    process_match = first_match(runtime_inputs, [PROCESS_LAUNCHED_RE])

    if supervisor_match:
        launch_gate = gate(
            "launch_survival",
            "PASS",
            "authoritative_runtime_log",
            "the bounded game-process launch supervisor emitted its success marker",
            [supervisor_match],
            exact_supervisor_gate=True,
        )
    elif neos_frames and not fatal_matches:
        launch_gate = gate(
            "launch_survival",
            "OBSERVED",
            "authoritative_runtime_log",
            f"runtime heartbeats reached frame {max(neos_frames)}; no bounded supervisor marker is present",
            neos_matches[:2] + neos_matches[-2:],
            exact_supervisor_gate=False,
            first_runtime_frame=min(neos_frames),
            last_runtime_frame=max(neos_frames),
        )
    elif process_match:
        launch_gate = gate(
            "launch_survival",
            "OBSERVED",
            "authoritative_runtime_log",
            "LLDB recorded process launch, but sustained runtime evidence is absent",
            [process_match],
            exact_supervisor_gate=False,
        )
    elif fatal_matches:
        launch_gate = gate(
            "launch_survival",
            "FAIL",
            "authoritative_runtime_log",
            "runtime log contains a fatal/early-exit marker before a sustained launch gate",
            fatal_matches,
            exact_supervisor_gate=False,
        )
    else:
        launch_gate = gate(
            "launch_survival",
            "UNPROVEN",
            "none",
            "no runtime log or accepted launch marker was supplied",
            [],
            exact_supervisor_gate=False,
        )

    boot_evidence: List[Dict[str, Any]] = []
    boot_count = 0
    for source in runtime_inputs:
        for marker in BOOT_MARKERS:
            matches = source.contains(marker)
            if matches:
                boot_count += 1
                line, text = matches[0]
                boot_evidence.append(
                    {"source": str(source.path), "role": source.role, "line": line, "text": text}
                )
    explicit_boot = normalized_pass(current_events, "boot", owner="game")
    if explicit_boot:
        boot_gate = gate(
            "boot",
            "PASS",
            "authoritative_runtime_log",
            "strict game-owned boot event was emitted",
            event_evidence(explicit_boot),
        )
    elif boot_count >= 2:
        boot_gate = gate(
            "boot",
            "PASS",
            "authoritative_runtime_log",
            f"{boot_count} accepted boot milestones were observed",
            boot_evidence,
            milestone_count=boot_count,
        )
    else:
        boot_gate = gate(
            "boot",
            "UNPROVEN",
            "none",
            "fewer than two accepted game boot milestones were observed",
            boot_evidence,
            milestone_count=boot_count,
        )

    submit_events = event_status(current_events, "game_owned_submit", owner="game")
    complete_submit = [
        event
        for event in submit_events
        if event.status in {"pass", "passed"} and event.field("kind") == "graph" and event.field("complete") == "1"
    ]
    incomplete_submit = [
        event
        for event in submit_events
        if (event.legacy or event.field("kind") == "graph") and event.status in {"observed", "pass", "passed"}
    ]
    failed_submit = [event for event in submit_events if event.status in {"fail", "failed"}]
    if complete_submit:
        submit_gate = gate(
            "game_owned_submit",
            "PASS",
            "authoritative_runtime_log",
            "complete game-owned graph submission marker observed",
            event_evidence(complete_submit),
            frames=sorted({event.field("frame") for event in complete_submit if event.field("frame")}),
        )
    elif incomplete_submit:
        submit_gate = gate(
            "game_owned_submit",
            "OBSERVED_INCOMPLETE",
            "authoritative_runtime_log",
            "a game-owned graph capture/prefix was observed, but it is not marked complete and cannot seed a frame claim",
            event_evidence(incomplete_submit),
            frames=sorted({event.field("frame") for event in incomplete_submit if event.field("frame")}),
        )
    elif failed_submit:
        submit_gate = gate(
            "game_owned_submit",
            "FAIL",
            "authoritative_runtime_log",
            "the runtime explicitly rejected the game-owned graph submission",
            event_evidence(failed_submit),
        )
    else:
        submit_gate = gate(
            "game_owned_submit",
            "UNPROVEN",
            "none",
            "NEOS_OUT heartbeats, LOGO draw, GBI pointer notices, and shader output are not graph-submission evidence",
            [],
        )

    packet_events = event_status(current_events, "renderer_packet", owner="renderer")
    game_origin_packets = [
        event
        for event in packet_events
        if event.status in {"pass", "passed"} and event.field("origin") == "game"
    ]
    packet_passes = [event for event in packet_events if event.status in {"pass", "passed"}]
    if game_origin_packets:
        packet_gate = gate(
            "renderer_packet",
            "PASS",
            "runtime_renderer_boundary",
            "renderer-owned packet is explicitly bound to a game origin",
            event_evidence(game_origin_packets),
        )
    elif packet_passes:
        packet_gate = gate(
            "renderer_packet",
            "OBSERVED_UNBOUND",
            "runtime_renderer_boundary",
            "renderer packet marker exists, but it is not bound to a game-owned submit",
            event_evidence(packet_passes),
        )
    elif any(pattern_match for pattern_match in all_matches(renderer_inputs, FIXTURE_CPU_PACKET_PATTERNS, limit=4)):
        packet_gate = gate(
            "renderer_packet",
            "OBSERVED_FIXTURE",
            "renderer_fixture_log",
            "synthetic renderer packet/geometry fixture passed; this is not a game-owned packet",
            all_matches(renderer_inputs, FIXTURE_CPU_PACKET_PATTERNS, limit=4),
        )
    else:
        packet_gate = gate(
            "renderer_packet",
            "UNPROVEN",
            "none",
            "no strict renderer-packet marker bound to the current runtime was supplied",
            [],
        )

    encode_events = normalized_pass(current_events, "encode", owner="game_renderer")
    present_events = normalized_pass(current_events, "present", owner="game_renderer")
    if encode_events:
        encode_gate = gate(
            "game_encode",
            "PASS",
            "runtime_renderer_boundary",
            "strict game-renderer encode marker observed",
            event_evidence(encode_events),
        )
    else:
        encode_gate = gate(
            "game_encode",
            "UNPROVEN",
            "none",
            "no game-owned encode marker was emitted; renderer fixture compilation is not encode proof",
            [],
        )
    if present_events:
        present_gate = gate(
            "game_present",
            "PASS",
            "runtime_renderer_boundary",
            "strict game-renderer present marker observed",
            event_evidence(present_events),
        )
    else:
        present_gate = gate(
            "game_present",
            "UNPROVEN",
            "none",
            "no game-owned present marker was emitted; a fixture present is not a game present",
            [],
        )

    no_device = all_matches(renderer_inputs, NO_DEVICE_PATTERNS, limit=8)
    if no_device:
        fixture_gate = gate(
            "renderer_fixture_device",
            "SKIP_NO_DEVICE",
            "renderer_fixture_log",
            "Metal device-dependent fixture explicitly skipped because no macOS Metal device was available",
            no_device,
        )
    elif any(pattern_match for pattern_match in all_matches(renderer_inputs, FIXTURE_PASS_PATTERNS, limit=4)):
        fixture_gate = gate(
            "renderer_fixture_device",
            "PASS_FIXTURE",
            "renderer_fixture_log",
            "renderer fixture emitted a completion marker; it remains synthetic and not game-owned",
            all_matches(renderer_inputs, FIXTURE_PASS_PATTERNS, limit=4),
        )
    else:
        fixture_gate = gate(
            "renderer_fixture_device",
            "UNPROVEN",
            "none",
            "no renderer fixture device result was supplied",
            [],
        )

    window_passes = [
        event
        for event in normalized_pass(current_events, "window", owner="game")
        if event.field("window") == "visible" or event.field("surface") == "window"
    ]
    explicit_window_skips = [event for event in event_status(current_events, "window") if event.status in {"skip", "skipped"}]
    no_window = all_matches(runtime_inputs, NO_WINDOW_PATTERNS, limit=8)
    if window_passes:
        window_gate = gate(
            "visible_window",
            "PASS",
            "authoritative_runtime_log",
            "runtime explicitly identified a visible game window",
            event_evidence(window_passes),
        )
    elif explicit_window_skips or no_window:
        window_gate = gate(
            "visible_window",
            "SKIP_NO_WINDOW",
            "authoritative_runtime_log",
            "runtime explicitly recorded that a window/display/drawable was unavailable",
            event_evidence(explicit_window_skips) + no_window,
        )
    else:
        window_gate = gate(
            "visible_window",
            "SKIP_NO_WINDOW_EVIDENCE",
            "none",
            "no explicit visible-window marker was supplied; fullscreen=0, shader output, swap timing, and process logs do not prove a visible window",
            [],
        )

    readback_events = normalized_pass(current_events, "readback", owner="game_renderer")
    readback_candidates: List[Dict[str, Any]] = []
    valid_readbacks: List[EvidenceEvent] = []
    readback_failure: Optional[Tuple[str, str, Dict[str, Any]]] = None
    for event in readback_events:
        status, note, details = validate_readback_event(event, allowed_artifacts)
        readback_candidates.append({"event": event.as_dict(), "validation_status": status, "note": note, **details})
        if status == "PASS":
            valid_readbacks.append(event)
        elif readback_failure is None:
            readback_failure = (status, note, details)
    if valid_readbacks:
        readback_gate = gate(
            "game_readback",
            "PASS",
            "runtime_renderer_boundary",
            "window-surface readback was validated against an explicitly supplied artifact",
            event_evidence(valid_readbacks),
            candidates=readback_candidates,
        )
    elif readback_failure:
        readback_gate = gate(
            "game_readback",
            readback_failure[0],
            "runtime_renderer_boundary",
            readback_failure[1],
            event_evidence(readback_events),
            candidates=readback_candidates,
        )
    elif window_gate["status"] in {"SKIP_NO_WINDOW", "SKIP_NO_WINDOW_EVIDENCE"}:
        readback_gate = gate(
            "game_readback",
            "SKIP_NO_WINDOW_EVIDENCE",
            "none",
            "readback cannot be claimed without a visible-window gate",
            [],
        )
    else:
        readback_gate = gate(
            "game_readback",
            "UNPROVEN",
            "none",
            "no strict game-owned readback marker and artifact were supplied",
            [],
        )

    current_gates = [
        launch_gate,
        boot_gate,
        submit_gate,
        packet_gate,
        encode_gate,
        present_gate,
        window_gate,
        fixture_gate,
        readback_gate,
    ]

    # A first frame is intentionally a derived claim, never an interpretation
    # of a single log line.  Every edge must be explicit and share one frame.
    complete_submit_by_frame = {
        event.field("frame"): event
        for event in complete_submit
        if event.field("frame")
    }
    packet_by_frame = {
        event.field("frame"): event
        for event in game_origin_packets
        if event.field("frame")
    }
    encode_by_frame = {
        event.field("frame"): event
        for event in encode_events
        if event.field("frame")
    }
    present_by_frame = {
        event.field("frame"): event
        for event in present_events
        if event.field("frame")
    }
    readback_by_frame = {
        event.field("frame"): event
        for event in valid_readbacks
        if event.field("frame")
    }
    common_frames = sorted(
        set(complete_submit_by_frame)
        & set(packet_by_frame)
        & set(encode_by_frame)
        & set(present_by_frame)
        & set(readback_by_frame)
    )
    first_frame: Dict[str, Any]
    if common_frames and window_gate["status"] == "PASS":
        frame = common_frames[0]
        first_frame = {
            "status": "PASS",
            "frame": int(frame),
            "claim": "first_game_owned_visible_frame",
            "reason": "all game-submit, renderer-packet, encode, present, visible-window, and readback prerequisites share this frame",
        }
    else:
        missing = []
        prerequisite_map = {
            "game_owned_submit": bool(complete_submit_by_frame),
            "renderer_packet": bool(packet_by_frame),
            "game_encode": bool(encode_by_frame),
            "game_present": bool(present_by_frame),
            "visible_window": window_gate["status"] == "PASS",
            "game_readback": bool(readback_by_frame),
        }
        missing.extend(name for name, present in prerequisite_map.items() if not present)
        first_frame = {
            "status": "NOT_CLAIMED",
            "frame": None,
            "claim": None,
            "reason": "fail-closed: prerequisites are absent, incomplete, or not bound to one frame",
            "missing_prerequisites": missing,
        }

    guardrails = [
        {
            "name": "heartbeat_is_not_game_submit",
            "status": "PASS" if neos_frames and not complete_submit else "CHECK",
            "note": "NEOS_OUT frame counters are retained as runtime survival evidence only",
        },
        {
            "name": "renderer_fixture_is_not_game_frame",
            "status": "PASS" if fixture_gate["status"] in {"SKIP_NO_DEVICE", "PASS_FIXTURE", "UNPROVEN"} and first_frame["status"] != "PASS" else "CHECK",
            "note": "fixture/device output cannot satisfy the game-owned frame chain",
        },
        {
            "name": "no_readback_no_first_frame",
            "status": "PASS" if first_frame["status"] != "PASS" and readback_gate["status"] != "PASS" else "CHECK",
            "note": "the derived first-frame claim requires a validated game-owned readback artifact",
        },
    ]

    historical_summary = {
        "input_count": len(historical_inputs),
        "events": [event.as_dict() for event in historical_events],
        "note": "historical runtime events are never joined to the current post-audio frame chain",
    }
    return {
        "schema": SCHEMA_VERSION,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "gates": {item["name"]: item for item in current_gates},
        "first_frame": first_frame,
        "guardrails": guardrails,
        "historical": historical_summary,
        "runtime_frames": {
            "count": len(neos_frames),
            "first": min(neos_frames) if neos_frames else None,
            "last": max(neos_frames) if neos_frames else None,
        },
        "runtime_source": runtime_source,
        "renderer_source": renderer_source,
        "parsed_events": [event.as_dict() for event in current_events + renderer_events],
    }


def input_summary(source: EvidenceInput) -> Dict[str, Any]:
    return {
        "role": source.role,
        "path": str(source.path),
        "bytes": len(source.raw),
        "sha256": source.sha256,
        "mtime_utc": source.mtime,
    }


def markdown_escape(value: Any) -> str:
    return str(value).replace("|", "\\|").replace("\n", " ")


def render_markdown(report: Dict[str, Any], inputs: Sequence[EvidenceInput], output_dir: Path) -> str:
    lines = [
        "# ACGC frame evidence gate",
        "",
        "This is a parser-only, fail-closed report. It does not build, launch,",
        "link, initialize a device, copy an ISO, or copy extracted game assets.",
        "A first frame is claimed only when one complete game-owned graph submit,",
        "one game-origin renderer packet, encode, present, visible-window marker,",
        "and validated window-surface readback all share one frame index.",
        "",
        f"Generated: `{report['generated_at']}`",
        f"Output root: `{output_dir}`",
        "",
        "## Result",
        "",
        f"`first_game_owned_visible_frame`: **{report['first_frame']['status']}**",
    ]
    if report["first_frame"].get("frame") is not None:
        lines.append(f"Frame: `{report['first_frame']['frame']}`")
    else:
        lines.append("No first game-owned visible frame is claimed.")
    lines.extend(
        [
            "",
            "## Gate labels",
            "",
            "| Gate | Status | Authority | Evidence boundary |",
            "| --- | --- | --- | --- |",
        ]
    )
    for name, item in report["gates"].items():
        lines.append(
            f"| `{markdown_escape(name)}` | **{markdown_escape(item['status'])}** | "
            f"`{markdown_escape(item['authority'])}` | {markdown_escape(item['notes'])} |"
        )
    lines.extend(["", "## Exact input artifacts", "", "Inputs were read in place; none were copied into tracked paths.", ""])
    lines.extend(
        [
            "| Role | Path | Bytes | SHA-256 | Mtime UTC |",
            "| --- | --- | ---: | --- | --- |",
        ]
    )
    for source in inputs:
        lines.append(
            f"| `{markdown_escape(source.role)}` | `{markdown_escape(source.path)}` | {len(source.raw)} | "
            f"`{source.sha256}` | `{source.mtime}` |"
        )

    lines.extend(["", "## Selected exact evidence", ""])
    selected: List[Dict[str, Any]] = []
    for item in report["gates"].values():
        selected.extend(item.get("evidence", []))
    seen: set[Tuple[str, int, str]] = set()
    if not selected:
        lines.append("No accepted marker lines were supplied.")
    else:
        for evidence in selected:
            key = (str(evidence.get("source")), int(evidence.get("line", 0)), str(evidence.get("text")))
            if key in seen:
                continue
            seen.add(key)
            lines.append(
                f"- `{markdown_escape(evidence.get('source'))}:{evidence.get('line')}` "
                f"({markdown_escape(evidence.get('role'))}): `{markdown_escape(evidence.get('text'))}`"
            )

    lines.extend(["", "## Source binding", ""])
    for label, source in (("Runtime", report["runtime_source"]), ("Renderer fixture", report["renderer_source"])):
        if not source.get("path"):
            lines.append(f"- {label}: no source checkout supplied; authority is `{source.get('authority')}`.")
            continue
        lines.append(
            f"- {label}: `{source.get('path')}`, HEAD `{source.get('head')}`, "
            f"branch `{source.get('branch')}`, clean `{source.get('clean')}`, "
            f"expected `{source.get('expected_revision')}`, authority `{source.get('authority')}`."
        )
        if source.get("tree_matches_expected") and source.get("authority") == "TREE_MATCH_DIRTY":
            lines.append("  The committed tree matches the expected revision, but the checkout was dirty; this is not an exact clean-source sign-off.")
        elif source.get("authority") == "MISMATCH_OR_UNRESOLVED":
            lines.append("  The current checkout does not match the expected revision/tree; source-to-log binding is unresolved and cannot support a stronger claim.")

    lines.extend(["", "## Historical separation", ""])
    historical_events = report["historical"].get("events", [])
    lines.append("Historical runtime inputs are retained for context only; they are never joined to current post-audio gates or a first-frame claim.")
    if historical_events:
        for event in historical_events:
            lines.append(
                f"- `{markdown_escape(event.get('source'))}:{event.get('line')}` "
                f"({markdown_escape(event.get('role'))}): `{markdown_escape(event.get('text'))}` "
                f"→ `{markdown_escape(event.get('stage'))}` `{markdown_escape(event.get('status'))}` "
                "(legacy/incomplete unless a strict complete marker is present)"
            )
    else:
        lines.append("No accepted historical markers were supplied.")

    lines.extend(
        [
            "",
            "## Separation rules",
            "",
            "- `NEOS_OUT` heartbeats and a `LOGO draw` line prove runtime progress/draw-path observation only.",
            "- `[GRAPH_CAPTURE]` is accepted as a game-owned graph prefix, but the legacy form is incomplete unless a strict marker says `complete=1`.",
            "- Renderer packet/geometry fixtures are renderer evidence. They are never joined to a game frame unless a strict marker binds `origin=game` and a shared frame index.",
            "- A command-buffer completion or present fixture does not prove a game-owned visible pixel.",
            "- Missing Metal hardware and missing/undocumented windows are emitted as explicit skips; they do not become passes by inference.",
            "",
            "## Guardrails",
            "",
        ]
    )
    for guardrail in report["guardrails"]:
        lines.append(f"- `{guardrail['name']}`: **{guardrail['status']}** — {guardrail['note']}")

    lines.extend(
        [
            "",
            "## Reproduction",
            "",
            "The probe reads the supplied logs and writes only JSON/Markdown below the unique temp output root:",
            "",
            "```sh",
            "python3 scripts/probes/frame_evidence.py \\",
            "  --runtime-log /path/to/authoritative-runtime.log \\",
            "  --renderer-log /path/to/renderer-fixture.log \\",
            "  --runtime-source-dir /path/to/source \\",
            "  --runtime-source-revision <expected-commit> \\",
            f"  --output-dir {output_dir}",
            "```",
            "",
            "Use `--require-first-frame` when a caller needs a nonzero exit until the full chain is actually captured.",
        ]
    )
    return "\n".join(lines) + "\n"


def build_inputs(args: argparse.Namespace) -> List[EvidenceInput]:
    specs: List[Tuple[str, str]] = []
    specs.extend((path, "runtime") for path in args.runtime_log)
    specs.extend((path, "renderer_fixture") for path in args.renderer_log)
    specs.extend((path, "historical_runtime") for path in args.historical_runtime_log)
    inputs: List[EvidenceInput] = []
    for raw_path, role in specs:
        path = Path(raw_path).expanduser()
        if not path.is_file():
            raise ValueError(f"input log does not exist or is not a regular file: {path}")
        inputs.append(EvidenceInput.load(path, role))
    return inputs


def run_self_test() -> int:
    output_dir = DEFAULT_OUTPUT_DIR / "self-test"
    output_dir.mkdir(parents=True, exist_ok=True)
    artifact = output_dir / "readback.bin"
    artifact_bytes = b"pixel"
    artifact.write_bytes(artifact_bytes)
    artifact_hash = hashlib.sha256(artifact_bytes).hexdigest()
    positive_text = "\n".join(
        [
            "[ACGC_EVIDENCE] stage=launch status=pass owner=game",
            "[ACGC_EVIDENCE] stage=boot status=pass owner=game",
            "[ACGC_EVIDENCE] stage=window status=pass owner=game window=visible",
            "[ACGC_EVIDENCE] stage=game_owned_submit status=pass owner=game kind=graph frame=7 complete=1 submit_id=sub7",
            "[ACGC_EVIDENCE] stage=renderer_packet status=pass owner=renderer origin=game frame=7 packet_id=pkt7 submit_id=sub7",
            "[ACGC_EVIDENCE] stage=encode status=pass owner=game_renderer frame=7 packet_id=pkt7 command_buffer=cb7",
            "[ACGC_EVIDENCE] stage=present status=pass owner=game_renderer frame=7 command_buffer=cb7 surface=window",
            f"[ACGC_EVIDENCE] stage=readback status=pass owner=game_renderer frame=7 surface=window width=1 height=1 bytes=5 format=raw sha256={artifact_hash} artifact={artifact}",
        ]
    ).encode()
    negative_text = "\n".join(
        [
            "[NEOS_OUT] frame=1741 tasks=60 peak=0",
            "[LOGO] draw: action=0 pad_connected=1",
            "[GRAPH_CAPTURE] version=1 frame=0 source_capacity=256 captured=8 words=de010000,f0002000,00000000,00000000,00000000,00000000,00000000,00000000",
            "Metal packet consumer: CPU packet/state/fixture contract PASS; SKIP (no macOS Metal device available)",
            "SDL_Init failed: The video driver did not add any displays",
        ]
    ).encode()
    positive_path = output_dir / "positive.log"
    negative_path = output_dir / "negative.log"
    positive_path.write_bytes(positive_text)
    negative_path.write_bytes(negative_text)
    positive_input = EvidenceInput.load(positive_path, "runtime")
    negative_input = EvidenceInput.load(negative_path, "runtime")
    fixture_input = EvidenceInput.load(negative_path, "renderer_fixture")
    historical_input = EvidenceInput.load(negative_path, "historical_runtime")

    positive_report = evaluate(
        [positive_input],
        {"authority": "SELF_TEST"},
        {"authority": "SELF_TEST"},
        [artifact],
    )
    if positive_report["first_frame"]["status"] != "PASS" or positive_report["first_frame"]["frame"] != 7:
        print("SELF_TEST_FAIL: positive full-chain fixture did not claim frame 7", file=sys.stderr)
        return 1

    negative_report = evaluate(
        [negative_input, fixture_input, historical_input],
        {"authority": "SELF_TEST"},
        {"authority": "SELF_TEST"},
        [],
    )
    if negative_report["first_frame"]["status"] == "PASS":
        print("SELF_TEST_FAIL: heartbeat/graph-prefix/no-device fixture claimed a frame", file=sys.stderr)
        return 1
    if negative_report["gates"]["game_owned_submit"]["status"] != "OBSERVED_INCOMPLETE":
        print("SELF_TEST_FAIL: legacy graph prefix was not labelled incomplete", file=sys.stderr)
        return 1
    if negative_report["gates"]["renderer_fixture_device"]["status"] != "SKIP_NO_DEVICE":
        print("SELF_TEST_FAIL: no-device fixture was not labelled explicitly", file=sys.stderr)
        return 1
    if negative_report["gates"]["visible_window"]["status"] != "SKIP_NO_WINDOW":
        print("SELF_TEST_FAIL: no-window fixture was not labelled explicitly", file=sys.stderr)
        return 1
    if negative_report["gates"]["game_encode"]["status"] == "PASS":
        print("SELF_TEST_FAIL: renderer fixture was mistaken for game encode", file=sys.stderr)
        return 1
    if not negative_report["historical"]["events"]:
        print("SELF_TEST_FAIL: historical graph prefix was not retained separately", file=sys.stderr)
        return 1
    if negative_report["first_frame"]["status"] == "PASS":
        print("SELF_TEST_FAIL: historical evidence was joined to the current frame chain", file=sys.stderr)
        return 1
    print("frame_evidence self-test: PASS (positive chain and fail-closed negative labels)")
    return 0


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Parse ACGC launch/boot/submit/encode/present/readback evidence without building or launching."
    )
    parser.add_argument("--runtime-log", action="append", default=[], help="authoritative current runtime log (repeatable)")
    parser.add_argument("--renderer-log", action="append", default=[], help="renderer/device fixture log (repeatable)")
    parser.add_argument("--historical-runtime-log", action="append", default=[], help="historical runtime log; never joined to current gates")
    parser.add_argument("--runtime-source-dir", help="source checkout used to produce the current runtime log")
    parser.add_argument("--runtime-source-revision", help="expected revision for --runtime-source-dir")
    parser.add_argument("--renderer-source-dir", help="source checkout used for renderer fixture logs")
    parser.add_argument("--renderer-source-revision", help="expected revision for --renderer-source-dir")
    parser.add_argument("--readback-artifact", action="append", default=[], help="explicit allowed readback artifact (repeatable)")
    parser.add_argument("--output-dir", default=str(DEFAULT_OUTPUT_DIR), help="unique temp output directory")
    parser.add_argument("--stem", default="frame-evidence", help="output filename stem")
    parser.add_argument("--require-first-frame", action="store_true", help="return 2 unless a complete first frame is proven")
    parser.add_argument("--self-test", action="store_true", help="run parser guardrail self-tests")
    return parser.parse_args(argv)


def main(argv: Sequence[str]) -> int:
    args = parse_args(argv)
    if args.self_test:
        return run_self_test()
    if not args.runtime_log and not args.renderer_log and not args.historical_runtime_log:
        print("error: supply at least one log or use --self-test", file=sys.stderr)
        return 2
    try:
        inputs = build_inputs(args)
    except (OSError, ValueError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 2

    output_dir = Path(args.output_dir).expanduser()
    try:
        output_dir.mkdir(parents=True, exist_ok=True)
    except OSError as error:
        print(f"error: cannot create output directory {output_dir}: {error}", file=sys.stderr)
        return 2

    runtime_source = git_source_info(
        Path(args.runtime_source_dir) if args.runtime_source_dir else None,
        args.runtime_source_revision,
    )
    renderer_source = git_source_info(
        Path(args.renderer_source_dir) if args.renderer_source_dir else None,
        args.renderer_source_revision,
    )
    allowed_artifacts = [Path(path).expanduser().resolve() for path in args.readback_artifact]
    report = evaluate(inputs, runtime_source, renderer_source, allowed_artifacts)
    report["inputs"] = [input_summary(source) for source in inputs]
    report["probe"] = {
        "cwd": str(Path.cwd()),
        "output_dir": str(output_dir.resolve()),
        "build_or_launch_performed": False,
        "iso_or_assets_copied": False,
        "allowed_readback_artifacts": [str(path) for path in allowed_artifacts],
    }

    json_path = output_dir / f"{args.stem}.json"
    markdown_path = output_dir / f"{args.stem}.md"
    json_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    markdown_path.write_text(render_markdown(report, inputs, output_dir.resolve()), encoding="utf-8")

    print(f"frame_evidence: {report['first_frame']['status']}")
    for name, item in report["gates"].items():
        print(f"{name}: {item['status']}")
    print(f"json: {json_path}")
    print(f"markdown: {markdown_path}")
    if args.require_first_frame and report["first_frame"]["status"] != "PASS":
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
