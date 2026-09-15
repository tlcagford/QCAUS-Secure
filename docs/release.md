# Release Procedure

## Windows / Android

```powershell
flutter doctor -v
.\tool\bootstrap_store.ps1
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols/android
```

Expected unsigned/local release artifact:

`build/app/outputs/bundle/release/app-release.aab`

Configure signing separately with environment variables documented in
`tool/configure_android_signing.py`.

## macOS / iOS

```bash
flutter doctor -v
./tool/bootstrap_store.sh
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter build ipa --release --obfuscate --split-debug-info=build/symbols/ios
```

iOS distribution requires Apple signing credentials, certificates/profiles,
App Store Connect configuration, and Xcode/macOS.

## Do not commit

- keystores
- `key.properties`
- provisioning profiles
- certificates/private keys
- API secrets
- generated release artifacts
