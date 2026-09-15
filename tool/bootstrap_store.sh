#!/usr/bin/env bash
set -euo pipefail

ANDROID=1
IOS=1
if [[ "${1:-}" == "--android-only" ]]; then IOS=0; fi
if [[ "${1:-}" == "--ios-only" ]]; then ANDROID=0; fi

command -v flutter >/dev/null 2>&1 || { echo "Flutter is required."; exit 1; }

platforms=""
[[ "$ANDROID" == "1" ]] && platforms="${platforms}android,"
[[ "$IOS" == "1" ]] && platforms="${platforms}ios,"
platforms="${platforms%,}"

flutter create --platforms="${platforms}" --org com.qcaus --project-name qcaus_secure .

if [[ -d android ]]; then
  find android -type f \( -name '*.kt' -o -name '*.java' -o -name '*.gradle' -o -name '*.gradle.kts' -o -name 'AndroidManifest.xml' \) -print0 |
    xargs -0 sed -i.bak 's/com\.qcaus\.qcaus_secure/com.qcaus.secure/g'
  find android -name '*.bak' -delete

  if [[ -f android/app/build.gradle.kts ]]; then
    python3 - <<'PY'
from pathlib import Path
p = Path("android/app/build.gradle.kts")
s = p.read_text()
s = s.replace("compileSdk = flutter.compileSdkVersion", "compileSdk = 36")
s = s.replace("targetSdk = flutter.targetSdkVersion", "targetSdk = 36")
s = s.replace("minSdk = flutter.minSdkVersion", "minSdk = 24")
p.write_text(s)
PY
  elif [[ -f android/app/build.gradle ]]; then
    python3 - <<'PY'
from pathlib import Path
p = Path("android/app/build.gradle")
s = p.read_text()
s = s.replace("compileSdkVersion flutter.compileSdkVersion", "compileSdkVersion 36")
s = s.replace("targetSdkVersion flutter.targetSdkVersion", "targetSdkVersion 36")
s = s.replace("minSdkVersion flutter.minSdkVersion", "minSdkVersion 24")
p.write_text(s)
PY
  fi
fi

if [[ -f ios/Runner.xcodeproj/project.pbxproj ]]; then
  sed -i.bak 's/com\.qcaus\.qcaus_secure/com.qcaus.secure/g' ios/Runner.xcodeproj/project.pbxproj
  rm -f ios/Runner.xcodeproj/project.pbxproj.bak
fi

if [[ -f ios/Runner/Info.plist ]]; then
  python3 - <<'PY'
from pathlib import Path
p = Path("ios/Runner/Info.plist")
s = p.read_text()
key = "<key>ITSAppUsesNonExemptEncryption</key>"
if key not in s:
    marker = "</dict>"
    s = s.replace(marker, "  <key>ITSAppUsesNonExemptEncryption</key>\n  <true/>\n" + marker, 1)
p.write_text(s)
PY
fi

flutter pub get
dart run flutter_launcher_icons

echo "Store bootstrap complete. Review generated native projects before signing."
