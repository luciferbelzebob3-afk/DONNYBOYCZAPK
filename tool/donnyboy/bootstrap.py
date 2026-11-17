#!/usr/bin/env python3
"""Complete source was imported in b2611d1; never overwrite subsequent edits."""
from pathlib import Path
import subprocess

if not Path("pubspec.yaml").is_file():
    raise RuntimeError("Chybí zdroj aplikace. Použij kompletní větev dev.")
subprocess.run(["git", "submodule", "sync", "--recursive"], check=True)
subprocess.run(["git", "submodule", "update", "--init", "--recursive"], check=True)
print("Source commit: " + subprocess.check_output(["git", "rev-parse", "HEAD"]).decode().strip())
