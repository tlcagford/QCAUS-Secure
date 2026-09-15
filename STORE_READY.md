# Store-ready build gate

This repository is prepared as a **store-build source baseline**, not as a
pre-signed production binary.

## Required before submission

- [ ] Run `flutter pub get`
- [ ] Run `dart format lib test`
- [ ] Run `flutter analyze`
- [ ] Run `flutter test`
- [ ] Generate Android native project with API 36+
- [ ] Configure Android release signing outside git
- [ ] Build and inspect signed AAB
- [ ] Build iOS on macOS/Xcode
- [ ] Complete Apple export-compliance questionnaire
- [ ] Complete Google Play Data Safety form
- [ ] Publish privacy policy
- [ ] Prepare screenshots and store metadata
- [ ] Confirm all declared permissions match the exact binary
- [ ] Complete an independent security review before claiming production security

## Current product scope

The current application is local/prototype software. It does not create a
server account and does not provide production network messaging.
