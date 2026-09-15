# QCAUS Secure Public Security Beta

## TRY TO BREAK IT

QCAUS Secure is being released as a **security research beta**, not as a finished secure messenger.

The purpose of this release is to invite researchers, developers, cryptographers, students, and security testers to find weaknesses.

**Do not use the beta for sensitive or safety-critical communications.**

## What to test

### AASR

- Modify transition inputs.
- Replay valid transitions.
- Change counters.
- Change session identifiers.
- Change transcript/context data.
- Attempt unauthorized recovery.
- Attempt downgrade.
- Force repeated reconnects.
- Attempt state rollback.

Expected result: security-sensitive unauthorized transitions are rejected.

### Cryptographic boundary

- Verify that unauthenticated data cannot authorize state.
- Test malformed ciphertext handling.
- Test invalid authentication tags.
- Test nonce/sequence misuse handling.
- Review key lifecycle assumptions.

### Application

- Fuzz parsers.
- Test malformed files.
- Test oversized inputs.
- Test unexpected navigation/state sequences.
- Test local persistence corruption.
- Test crash/restart behavior.

## What not to test

Do not:

- attack systems you do not own or have authorization to test;
- conduct denial-of-service against public services;
- target unrelated users;
- distribute malware;
- attempt physical harm;
- publish private information obtained during testing.

## Reporting

Report security issues to:

**tlcagford@gmail.com**

Include:

- affected version/commit;
- platform;
- exact reproduction steps;
- expected behavior;
- observed behavior;
- security impact;
- proof-of-concept where safe;
- logs or screenshots with secrets removed.

Do not include private keys, passwords, recovery secrets, or personal data.

## Severity guidance

### Critical
Remote compromise of the cryptographic boundary, authentication bypass, or unauthorized access to protected content.

### High
Reliable MITM, downgrade, replay, state-transition authorization bypass, or significant key compromise.

### Medium
Security-relevant denial of service, state corruption, or limited information disclosure.

### Low
Hardening issue, usability/security warning problem, or defense-in-depth weakness.

## Research standard

A successful attack is valuable. The project is explicitly seeking negative results.

A vulnerability report should not be treated as an adversarial act; it is part of the research process.
