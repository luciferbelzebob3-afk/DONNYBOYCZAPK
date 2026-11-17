#!/usr/bin/env python3
"""Validate portable plugin files and archive exactly one plugin."""
import json
from pathlib import Path
import zipfile

root = Path("plugins/donnyboy-android-devkit")
manifest = json.loads((root / "plugin.json").read_text())
assert manifest["$schema"] == "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json"
assert manifest["name"] == root.name
skills = sorted((root / "skills").glob("*/SKILL.md"))
assert len(skills) == 3
for skill in skills:
    text = skill.read_text()
    assert text.startswith("---\n")
    assert "name: " + skill.parent.name in text.split("---")[1]
    assert "description: " in text.split("---")[1]
    assert len(skill.read_bytes()) < 1024 * 1024
files = sorted(p for p in root.rglob("*") if p.is_file())
assert all(not p.is_symlink() for p in files)
Path("dist").mkdir(exist_ok=True)
target = Path("dist/donnyboy-android-devkit.zip")
with zipfile.ZipFile(target, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    for file in files:
        archive.write(file, file.relative_to(root.parent))
with zipfile.ZipFile(target) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(files)
    json.loads(archive.read(root.name + "/plugin.json"))
print(f"Validated {len(skills)} skills and {len(files)} files: {target}")
