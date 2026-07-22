#!@PYTHON@
from __future__ import annotations

import importlib.util
import sys
from pathlib import Path


BUNDLED_CORE = Path("@PANDORAGH_CORE@")


def bundled_core_path() -> Path:
    if BUNDLED_CORE.is_file():
        return BUNDLED_CORE

    script_path = Path(sys.argv[0]).absolute()
    candidates = [
        script_path.parent.parent / "share" / "pandoragh" / "pandoragh_core.py",
        script_path.resolve().parent.parent / "share" / "pandoragh" / "pandoragh_core.py",
    ]
    for candidate in candidates:
        if candidate.is_file():
            return candidate
    raise RuntimeError("Unable to locate bundled pandoragh core")


def load_core():
    core_path = bundled_core_path()
    spec = importlib.util.spec_from_file_location("pandoragh_core", core_path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Unable to load bundled pandoragh core: {core_path}")

    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def main(argv: list[str]) -> int:
    module = load_core()
    return module.main(argv)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
