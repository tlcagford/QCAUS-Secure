# QCAUS Secure v0.1.0

QCAUS Secure is a Flutter communications-suite prototype covering Chat, Files,
Calls, Contacts, Security/AASR, and the QCAUS research lab.

## Store-ready baseline

This repository includes native-platform bootstrap scripts, Android/iOS CI
validation, privacy/legal pages, store listing drafts, launcher icon
configuration, release/security documentation, and the dual license.

Run `tool/bootstrap_store.ps1` on Windows or
`bash tool/bootstrap_store.sh` on macOS/Linux to generate the Flutter-native
Android/iOS platform projects.

## Security boundary

**AASR — Authenticated Adaptive State Recovery** treats channel observations as
untrusted. A state transition must be authenticated by established session
material. Failed authentication rejects recovery.

The current crypto file contains standard primitives for prototype testing.
The raw X25519 shared secret is not a production key schedule.

Production QCAUS Secure must use an independently reviewed authenticated
messaging protocol with identity binding, forward secrecy, post-compromise
recovery, replay protection, multi-device key management, and secure local
key storage.

## Research scope

The two-field codec is a classical coherent signal/DSP model. It does not
demonstrate dark-photon/FDM communication, faster-than-light communication,
reactionless communication, or any other unverified physical effect.

## Current release status

This is not an independently security-audited production messenger.
Network chat, production voice/video, and cloud file transfer are not included
in this local prototype.

## License

Academic/non-commercial/personal use with attribution is permitted. Commercial,
enterprise, governmental, SaaS, resale, or paid-product use requires a
separate written license. See LICENSE.
