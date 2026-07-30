#!/usr/bin/env @PYTHON@
from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path


PIPEASIO_REGISTER = Path("@PIPEASIO_REGISTER@")
WINE = Path("@WINE@")
PIPEASIO_REGISTRY_KEY = r"HKLM\Software\ASIO\PipeASIO"
PIPEASIO_REGISTRY_CLSID = "{2D3CA9E2-1193-4C5D-B5FD-38798F3DC074}"
DEFAULT_STEAM_ROOTS = [
    Path.home() / ".local/share/Steam",
    Path.home() / ".steam/steam",
    Path.home() / ".var/app/com.valvesoftware.Steam/data/Steam",
]


def eprint(message: str) -> None:
    print(message, file=sys.stderr)


def canonical(path: Path) -> Path:
    return path.expanduser().resolve(strict=False)


def parse_library_folders(vdf: Path) -> list[Path]:
    try:
        text = vdf.read_text(encoding="utf-8", errors="replace")
    except OSError as exc:
        eprint(f"pipeasio: could not read {vdf}: {exc}")
        return []

    libraries: list[Path] = []
    for match in re.finditer(r'^\s*"path"\s+"([^"]+)"', text, re.MULTILINE):
        libraries.append(Path(match.group(1)))
    return libraries


def steam_roots() -> list[Path]:
    raw_roots = list(DEFAULT_STEAM_ROOTS)
    extra_roots = os.environ.get("STEAM_ROOTS", "")
    if extra_roots:
        raw_roots.extend(Path(item) for item in extra_roots.split(os.pathsep) if item)

    roots: list[Path] = []
    seen: set[Path] = set()
    for root in raw_roots:
        root = canonical(root)
        if root in seen:
            continue
        seen.add(root)
        roots.append(root)
    return roots


def library_paths() -> list[Path]:
    libraries: list[Path] = []
    seen: set[Path] = set()

    for steam_root in steam_roots():
        candidates = [steam_root]
        vdf = steam_root / "steamapps" / "libraryfolders.vdf"
        if vdf.is_file():
            candidates.extend(parse_library_folders(vdf))

        for path in candidates:
            path = canonical(path)
            if path in seen:
                continue
            seen.add(path)
            compatdata = path / "steamapps" / "compatdata"
            if compatdata.is_dir():
                libraries.append(path)

    return libraries


def prefixes() -> list[Path]:
    found: list[Path] = []
    seen: set[Path] = set()

    for library in library_paths():
        compatdata = library / "steamapps" / "compatdata"
        for appdir in sorted(compatdata.iterdir(), key=lambda path: path.name):
            if not appdir.is_dir() or not appdir.name.isdigit():
                continue
            prefix = canonical(appdir / "pfx")
            if not prefix.is_dir() or prefix in seen:
                continue
            seen.add(prefix)
            found.append(prefix)

    return found


def prefix_is_registered(prefix: Path) -> bool:
    env = os.environ.copy()
    env["WINEPREFIX"] = str(prefix)

    try:
        result = subprocess.run(
            [
                str(WINE),
                "reg",
                "query",
                PIPEASIO_REGISTRY_KEY,
                "/v",
                "CLSID",
            ],
            env=env,
            check=False,
            capture_output=True,
            text=True,
        )
    except OSError as exc:
        eprint(f"pipeasio: could not query registry for {prefix}: {exc}")
        return False

    if result.returncode != 0:
        return False

    output = f"{result.stdout}\n{result.stderr}".lower()
    return PIPEASIO_REGISTRY_CLSID.lower() in output


def register_prefix(prefix: Path) -> bool:
    eprint(f"pipeasio: registering {prefix}")
    env = os.environ.copy()
    env["WINEPREFIX"] = str(prefix)

    try:
        subprocess.run([str(PIPEASIO_REGISTER)], env=env, check=True)
    except subprocess.CalledProcessError as exc:
        eprint(f"pipeasio: failed to register {prefix} (exit {exc.returncode})")
        return False
    return True


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Register PipeASIO in the Steam Proton prefixes on this system."
    )
    parser.add_argument(
        "--skip-registered",
        action="store_true",
        help="Skip prefixes that already have PipeASIO registered.",
    )
    args = parser.parse_args()

    if not PIPEASIO_REGISTER.is_file():
        eprint(f"pipeasio: missing {PIPEASIO_REGISTER}")
        return 1

    steam_prefixes = prefixes()
    if not steam_prefixes:
        eprint("pipeasio: no existing Steam Proton prefixes found")
        return 0

    registered = 0
    failed = 0
    skipped = 0
    for prefix in steam_prefixes:
        if args.skip_registered and prefix_is_registered(prefix):
            skipped += 1
            eprint(f"pipeasio: already registered in {prefix}, skipping")
            continue

        if register_prefix(prefix):
            registered += 1
        else:
            failed += 1

    eprint(f"pipeasio: registered {registered} Steam prefixes")
    if skipped:
        eprint(f"pipeasio: skipped {skipped} already registered prefix(es)")
    if failed:
        eprint(f"pipeasio: {failed} prefix(es) failed, see messages above")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
