$ErrorActionPreference = "Stop"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw "Flutter is required and must be on PATH."
}

$platforms = "android,ios"
if ($args -contains "--android-only") { $platforms = "android" }
if ($args -contains "--ios-only") { $platforms = "ios" }

flutter create --platforms=$platforms --org com.qcaus --project-name qcaus_secure .

if (Test-Path "android") {
  Get-ChildItem android -Recurse -File |
    Where-Object { $_.Extension -in ".kt",".java",".gradle",".kts" -or $_.Name -eq "AndroidManifest.xml" } |
    ForEach-Object {
      $p = $_.FullName
      $s = Get-Content $p -Raw
      $s = $s.Replace("com.qcaus.qcaus_secure","com.qcaus.secure")
      Set-Content -Path $p -Value $s -NoNewline
    }
}

if (Test-Path "android\app\build.gradle.kts") {
  $p = "android\app\build.gradle.kts"
  $s = Get-Content $p -Raw
  $s = $s.Replace("compileSdk = flutter.compileSdkVersion","compileSdk = 36")
  $s = $s.Replace("targetSdk = flutter.targetSdkVersion","targetSdk = 36")
  $s = $s.Replace("minSdk = flutter.minSdkVersion","minSdk = 24")
  Set-Content -Path $p -Value $s -NoNewline
} elseif (Test-Path "android\app\build.gradle") {
  $p = "android\app\build.gradle"
  $s = Get-Content $p -Raw
  $s = $s.Replace("compileSdkVersion flutter.compileSdkVersion","compileSdkVersion 36")
  $s = $s.Replace("targetSdkVersion flutter.targetSdkVersion","targetSdkVersion 36")
  $s = $s.Replace("minSdkVersion flutter.minSdkVersion","minSdkVersion 24")
  Set-Content -Path $p -Value $s -NoNewline
}

if (Test-Path "ios\Runner.xcodeproj\project.pbxproj") {
  $p = "ios\Runner.xcodeproj\project.pbxproj"
  $s = Get-Content $p -Raw
  $s = $s.Replace("com.qcaus.qcaus_secure","com.qcaus.secure")
  Set-Content -Path $p -Value $s -NoNewline
}

if (Test-Path "ios\Runner\Info.plist") {
  $p = "ios\Runner\Info.plist"
  $s = Get-Content $p -Raw
  if ($s -notmatch "ITSAppUsesNonExemptEncryption") {
    $s = $s.Replace("</dict>", "  <key>ITSAppUsesNonExemptEncryption</key>`n  <true/>`n</dict>")
    Set-Content -Path $p -Value $s -NoNewline
  }
}

flutter pub get
dart run flutter_launcher_icons

Write-Host "Store bootstrap complete. Review generated native projects before signing."
