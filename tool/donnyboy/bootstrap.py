#!/usr/bin/env python3
"""Import pinned upstream once; apply explicit fork changes; commit to dev."""
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

UPSTREAM = "388331c619fabe01a19a4149d58b72d2888f722b"
def run(*args):
    subprocess.run(args, check=True)

root = Path.cwd()
overlay = json.loads((root / "tool/donnyboy/overlay.json").read_text())
parser = (root / "tool/donnyboy/donny_parser.dart.txt").read_text()
importing = not (root / "pubspec.yaml").exists()
if importing:
    paths = subprocess.check_output(["git", "ls-files", "-z"]).decode().split("\0")
    saved = {p: (root / p).read_bytes() for p in paths if p}
    run("git", "fetch", "https://github.com/DarkFlippers/qUnleashed.git", UPSTREAM)
    run("git", "read-tree", UPSTREAM)
    run("git", "checkout-index", "-a", "-f")
    # Never import upstream deployment, translation, or publishing automations.
    run("git", "rm", "-r", "-f", ".github/workflows")
    shutil.copyfile("README.md", "README.upstream.md")
    for p, content in saved.items():
        target = root / p
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content)
    run("git", "submodule", "sync", "--recursive")
    run("git", "submodule", "update", "--init", "--recursive")

def replace(path, before, after):
    target = root / path
    value = target.read_text()
    if after in value:
        return
    if before not in value:
        raise RuntimeError(f"Patch no longer matches {path}: {before[:100]}")
    target.write_text(value.replace(before, after, 1))

if importing:
    for p, content in overlay.items():
        target = root / p
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(content)
    replace("lib/app/app.dart", "import 'shell.dart';", "import 'shell.dart';\nimport '../pages/about/page.dart';")
    replace("lib/app/app.dart", "onGenerateTitle: (context) => context.l10n.appTitle,", "onGenerateTitle: (context) => 'DonnyBoy',")
    replace("lib/app/app.dart", "home: AppShell(client: widget.client),", "home: AboutPage(devicePage: AppShell(client: widget.client)),")
    replace("android/app/build.gradle.kts", 'applicationId = "com.darkflippers.qunleashed"', 'applicationId = "cz.nqlsh.donnyboy"')
    replace("android/app/build.gradle.kts", '    id("com.google.gms.google-services")', '    // DonnyBoy preview has no Firebase project; no Google Services config.')
    replace("android/app/src/main/res/values/strings.xml", ">qUnleashed<", ">DonnyBoy<")
    replace("lib/pages/devices/firmware/directory.dart",
            "  'ofw' => OfwParser.instance,",
            "  'donnyboy' => DonnyBoyParser.instance,\n  'ofw' => OfwParser.instance,")
    target = root / "lib/pages/devices/firmware/directory.dart"
    target.write_text(target.read_text() + parser)
    replace("lib/components/config.dart", "    firmwares: [",
        """    firmwares: [
      FirmwareEntry(
        name: 'DONNY BOY CZ',
        shortName: 'donnyboy',
        icon: 'cfw.png',
        matchKeywords: ['donny', 'donnyboy', 'donnyboycz'],
        colors: FirmwareColors(
          primary: Color(0xFFFF9700),
          secondary: Color(0xFFCC5F00),
          tertiary: Color(0xFFFFB347),
        ),
      ),""")
    # Deliberately offline push configuration: never impersonate upstream's FCM project.
    target = root / "lib/services/notifications/firebase_options.dart"
    target.write_text("""// DonnyBoy preview intentionally ships without FCM configuration.
// PushService catches this and reports push as unavailable. Local BLE
// connection notifications use the existing local notification service.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();
  static FirebaseOptions get currentPlatform =>
      throw UnsupportedError('DonnyBoy preview: push není nakonfigurovaný.');
}
""")
    # Track the explicit no-FCM implementation; upstream ignores generated config.
    run("git", "add", "-f", str(target.relative_to(root)))
    run("git", "config", "user.name", "DonnyBoy CI")
    run("git", "config", "user.email", "donnyboy-ci@users.noreply.github.com")
    run("git", "add", "-A")
    run("git", "commit", "-m", "Importovat qUnleashed a přidat DonnyBoy UI, firmware feed a testy")
    # Non-forced push refuses a concurrent update instead of overwriting work.
    run("git", "push", "origin", "HEAD:dev")
else:
    run("git", "submodule", "update", "--init", "--recursive")
print("DonnyBoy source ready at " + subprocess.check_output(["git", "rev-parse", "HEAD"]).decode().strip())
