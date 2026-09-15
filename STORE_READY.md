# QCAUS Secure — Store-ready baseline

This repository is prepared for the Android/iOS store packaging stage.

## Included

- Flutter application source and tests.
- Android/iOS native-project bootstrap scripts.
- Store release runbook.
- Google Play and Apple listing drafts.
- Privacy policy and account-deletion web pages.
- GitHub Pages deployment.
- GitHub Actions test and release-validation workflows.
- Android signing helper using environment secrets.
- Launcher icon source/configuration.
- Security model and disclosure policy.
- Dual license.

## Deliberately excluded

- Android signing keys.
- Apple signing certificates/profiles.
- App Store Connect API private keys.
- Production backend credentials.

Those remain outside source control.

## Current product status

The application is still a local prototype. It should not be marketed as a production Internet messenger until a real backend, authenticated identity system, reviewed messaging protocol, secure key storage, and production voice/video transport are implemented and tested.

## Bootstrap

Windows:

```powershell
.\tool\bootstrap_store.ps1
```

macOS/Linux:

```bash
bash tool/bootstrap_store.sh
```

Then:

```bash
flutter pub get
flutter analyze
flutter test
```

## Android

Google Play requires new apps and updates to target Android 16 / API 36 or higher beginning August 31, 2026.

After release signing is configured:

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols/android
```

## iOS

On macOS/Xcode:

```bash
flutter build ipa --release --obfuscate --split-debug-info=build/symbols/ios
```

Complete App Store Connect encryption/export compliance for the cryptography used by the submitted binary.

## Privacy site

The Pages workflow publishes:

- `/privacy.html`
- `/account-deletion.html`

Expected project-pages URL:

`https://tlcagford.github.io/QCAUS-Secure/`

Enable GitHub Pages using the GitHub Actions source if it is not already enabled for the repository.
