# QCAUS Secure

**QCAUS Secure v0.1.0** — communications-suite prototype.

The application provides a local prototype UI for:

- Chat
- File-selection workflow
- Calls UI
- Contacts UI
- Security/AASR demonstration
- QCAUS Lab two-field classical DSP demonstration

## Security boundary

The release is **not a production secure messenger and has not been independently audited**.

The current build deliberately does not claim:

- unhackability;
- quantum-secure messaging;
- dark-photon communication;
- FDM communication;
- FTL communication;
- reactionless communication;
- production-grade voice/video calling;
- server-backed chat;
- cloud file transfer.

AASR is an application-layer state-transition guard. It rejects state transitions that are not authorized by the authenticated session token. It does not replace authenticated encryption or identity authentication.

The two-field lab is a classical coherent/DSP model. It is a research demonstration and does not establish a physical dark-sector channel.

## Production cryptography gate

Before any production messaging release, replace the prototype session-key path with an independently reviewed authenticated messaging protocol providing:

1. authenticated identities;
2. a reviewed key schedule/KDF;
3. forward secrecy;
4. post-compromise recovery;
5. replay protection;
6. multi-device key management;
7. secure local key storage;
8. audited protocol implementation;
9. secure update/signing infrastructure;
10. formal threat-model review.

Do not use the prototype raw X25519 path as a production protocol.

## Build

Install Flutter stable and verify:

```text
flutter doctor -v
```

Then:

```text
flutter pub get
dart format lib test
flutter analyze
flutter test
```

Android:

```text
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols/android
```

iOS requires macOS/Xcode:

```text
flutter build ipa --release --obfuscate --split-debug-info=build/symbols/ios
```

For a fresh checkout, use `tool/bootstrap_store.ps1` on Windows for Android setup or `tool/bootstrap_store.sh` on macOS/Linux.

## License

Dual-license research/commercial model. See `LICENSE`.

## Status

Store submission requires final platform builds, signing, privacy/data-safety declarations, screenshots, metadata, and platform review. This repository supplies the source/build gate; it does not contain signing credentials or a pre-signed store binary.


## PUBLIC SECURITY BETA — TRY TO BREAK IT

QCAUS Secure is being developed as a **communications-security architecture research project**, not merely as a messenger application.

The public beta invites independent researchers to inspect the implementation and attack the proposed **Authenticated Adaptive State Recovery (AASR)** architecture. Test MITM modification, replay, downgrade, state rollback, malformed input, recovery, and other failure paths.

**Do not use the beta for sensitive communications.** The current implementation is not independently audited and does not claim to be a production secure messenger or a finished security standard.

See:
- `QCAUS_SECURE_ARCHITECTURE.md`
- `AASR_PROTOCOL_SPEC.md`
- `THREAT_MODEL.md`
- `SECURITY_TESTING.md`
- `SECURITY_RESEARCH_PLAN.md`
- `CONFORMANCE_TEST_PLAN.md`
- `STANDARDIZATION_ROADMAP.md`
