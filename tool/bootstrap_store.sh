#!/usr/bin/env bash
set -euo pipefail

command -v flutter >/dev/null || { echo "Flutter is required."; exit 1; }

flutter create --platforms=android,ios --org com.qcaus --project-name qcaus_secure .

python3 - <<'PY'
from pathlib import Path

p = Path("android/app/build.gradle.kts")
if p.exists():
    s = p.read_text()
    s = s.replace("compileSdk = flutter.compileSdkVersion", "compileSdk = 36")
    s = s.replace("targetSdk = flutter.targetSdkVersion", "targetSdk = 36")
    s = s.replace("minSdk = flutter.minSdkVersion", "minSdk = 24")
    p.write_text(s)

for p in [Path("android/app/build.gradle"), Path("android/app/build.gradle.kts")]:
    if p.exists():
        s = p.read_text().replace("com.qcaus.qcaus_secure", "com.qcaus.secure")
        p.write_text(s)

plist = Path("ios/Runner/Info.plist")
if plist.exists():
    s = plist.read_text()
    if "ITSAppUsesNonExemptEncryption" not in s:
        s = s.replace("</dict>", "  <key>ITSAppUsesNonExemptEncryption</key>\n  <true/>\n</dict>")
        plist.write_text(s)
PY

flutter pub get
dart run flutter_launcher_icons
echo "Bootstrap complete. Run flutter analyze and flutter test next."
