$ErrorActionPreference = "Stop"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw "Flutter is required."
}

flutter create --platforms=android,ios --org com.qcaus --project-name qcaus_secure .

$gradleFiles = @("android/app/build.gradle.kts", "android/app/build.gradle")
foreach ($file in $gradleFiles) {
  if (Test-Path $file) {
    $s = Get-Content $file -Raw
    $s = $s -replace "compileSdk = flutter.compileSdkVersion", "compileSdk = 36"
    $s = $s -replace "targetSdk = flutter.targetSdkVersion", "targetSdk = 36"
    $s = $s -replace "minSdk = flutter.minSdkVersion", "minSdk = 24"
    $s = $s -replace "com.qcaus.qcaus_secure", "com.qcaus.secure"
    Set-Content $file $s
  }
}

$plist = "ios/Runner/Info.plist"
if (Test-Path $plist) {
  $s = Get-Content $plist -Raw
  if ($s -notmatch "ITSAppUsesNonExemptEncryption") {
    $s = $s -replace "</dict>", "  <key>ITSAppUsesNonExemptEncryption</key>`n  <true/>`n</dict>"
    Set-Content $plist $s
  }
}

flutter pub get
dart run flutter_launcher_icons
Write-Host "Bootstrap complete. Run flutter analyze and flutter test next."
