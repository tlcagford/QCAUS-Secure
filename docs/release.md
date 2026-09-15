# QCAUS Secure Store Release Runbook

## 1. Prerequisites

### Android / Google Play

- Flutter stable SDK.
- Android Studio and Android SDK.
- JDK supplied by the current Flutter/Android toolchain.
- Google Play Console developer account.
- Unique application ID: `com.qcaus.secure`.
- Release upload keystore stored outside Git.
- Google Play App Signing enabled.

### iOS / App Store

- macOS.
- Current Xcode supported by App Store Connect.
- Apple Developer Program membership.
- App Store Connect app record using bundle ID `com.qcaus.secure`.
- Distribution signing configured.
- Export-compliance determination completed for the cryptography used by the app.

## 2. Bootstrap native projects

Windows PowerShell:

```powershell
.\tool\bootstrap_store.ps1
```

macOS/Linux:

```bash
bash tool/bootstrap_store.sh
```

The bootstrap script creates the Flutter Android/iOS platform projects, applies the QCAUS application identifiers, configures the launcher icon, and runs dependency resolution.

## 3. Validate

```bash
flutter doctor -v
flutter pub get
dart format lib test
flutter analyze
flutter test
```

## 4. Android release

Google Play currently requires new apps and updates to target Android 16 / API 36 or higher beginning August 31, 2026.

Create an upload keystore outside the repository. Never commit it.

Configure release signing with `tool/configure_android_signing.py` and the required environment variables, then:

```bash
flutter clean
flutter pub get
dart run flutter_launcher_icons
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols/android
```

Artifact:

`build/app/outputs/bundle/release/app-release.aab`

Upload the AAB to an internal testing track first. Complete the Play Console Data safety, content rating, privacy policy, and app-access declarations before production release.

## 5. iOS release

On macOS:

```bash
flutter clean
flutter pub get
dart run flutter_launcher_icons
flutter build ipa --release --obfuscate --split-debug-info=build/symbols/ios
```

Flutter creates the archive under `build/ios/archive/` and the IPA under `build/ios/ipa/`.

Upload the IPA using Transporter, Xcode, or App Store Connect upload tooling.

## 6. Store metadata

Use:

- `store/google_play_listing.md`
- `store/app_store_listing.md`
- `store/data_safety_inventory.md`

Do not claim network messaging, E2E encryption, voice/video transport, or account creation as implemented until those functions actually exist in the deployed backend.

## 7. Signing secrets

Never put these in Git:

- Android `.jks` / `.keystore`;
- `android/key.properties`;
- Apple distribution certificates;
- Apple provisioning profiles;
- App Store Connect private API keys;
- passwords;
- signing tokens.

## 8. Versioning

Current version:

`0.1.0+1`

Every new store upload needs a higher build number.
