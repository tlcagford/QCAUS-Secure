# Store gate

Before uploading the first public build:

## Android

- [ ] `com.qcaus.secure` is registered in Play Console.
- [ ] Generated project has `compileSdk = 36` and `targetSdk = 36`.
- [ ] Release upload key is stored outside Git.
- [ ] Play App Signing is enabled.
- [ ] AAB builds successfully.
- [ ] Internal testing track passes on physical devices.
- [ ] Privacy policy URL is live.
- [ ] Data Safety form matches the exact binary.
- [ ] Content rating is completed.
- [ ] Store screenshots show the actual submitted build.
- [ ] No claim says "unhackable", "unbreakable", or "quantum encrypted" without an implemented and reviewed basis.

## iOS

- [ ] Bundle ID is `com.qcaus.secure`.
- [ ] Distribution signing is configured on macOS/Xcode.
- [ ] IPA builds successfully.
- [ ] App Store Connect encryption/export-compliance questions are completed.
- [ ] Privacy policy URL is live.
- [ ] App Privacy answers match the exact binary.
- [ ] Screenshots show the actual submitted build.
- [ ] Review notes explain that the current release is a local prototype and does not require a network account.

## Product security gate

The store packaging stage does **not** make the application a production secure messenger.

Before enabling Internet messaging, complete the production protocol layer:

1. reviewed authenticated messaging protocol;
2. identity verification and key binding;
3. proper KDF/ratchet;
4. forward secrecy;
5. post-compromise recovery;
6. replay/order protection;
7. multi-device key management;
8. secure key storage;
9. encrypted resumable file transport;
10. independent security review.
