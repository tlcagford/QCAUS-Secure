bootstrap:
	bash tool/bootstrap_store.sh

check:
	flutter pub get
	dart format --output=none --set-exit-if-changed lib test
	flutter analyze
	flutter test

android:
	flutter build appbundle --release --obfuscate --split-debug-info=build/symbols/android

ios:
	flutter build ipa --release --obfuscate --split-debug-info=build/symbols/ios
