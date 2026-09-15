# QCAUS Secure Security Model — v0.1.0

## Security boundary

QCAUS Secure v0.1.0 is a local engineering prototype. It is **not** a production secure-messaging protocol and has not been independently security audited.

The production security boundary must be a mature, independently reviewed authenticated end-to-end messaging protocol. QCAUS research components must never weaken that protocol.

## AASR

**Authenticated Adaptive State Recovery (AASR)** treats channel observations as untrusted.

A channel anomaly may trigger a recovery attempt, but an observed packet, timing change, route change, or peer assertion cannot authorize a new cryptographic state. A state transition must be authenticated using already-established session material.

If authentication fails, recovery fails closed.

## QCAUS two-field layer

The current Lab implements a classical coherent two-field signal model using relative phase Δφ and coherence Ω. It is a research/DSP model.

It does not demonstrate:

- dark-photon communication;
- FDM communication;
- faster-than-light communication;
- reactionless communication or propulsion;
- invisibility or perfect stealth.

## Production requirements before public secure-messaging launch

1. Authenticated identity establishment.
2. Proper KDF and ratchet/key schedule.
3. Forward secrecy.
4. Post-compromise recovery.
5. Replay protection and message ordering.
6. Multi-device identity/key management.
7. Secure local key storage.
8. Encrypted attachment chunking and resumable transfer.
9. Push notification design that does not expose message plaintext.
10. Independent security review and penetration testing.
11. Reproducible release builds and protected signing keys.

## Threat-model language

Use:

- "designed for MITM resistance";
- "authenticated state recovery";
- "end-to-end encryption" only when the deployed network protocol actually provides it;
- "independently auditable" only after an audit is completed.

Do not use:

- "unhackable";
- "unbreakable";
- "quantum encrypted" unless a specific, implemented and reviewed PQC/QKD mechanism supports the claim.
