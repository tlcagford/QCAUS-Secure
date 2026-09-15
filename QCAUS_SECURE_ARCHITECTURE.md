# QCAUS Secure Communications Architecture Specification

**Version:** 0.1  
**Status:** Research / public security beta specification  
**Project:** QCAUS Secure  
**Author:** Tony E. Ford / QCAUS  
**License:** See `LICENSE`

## 1. Purpose

QCAUS Secure proposes a communications-security architecture in which **authenticated cryptographic state controls security-critical adaptive state transitions**. The reference implementation is a research prototype, not a claim of a finished or independently certified security standard.

The immediate objective is to make the architecture independently implementable, testable, auditable, and attackable by outside researchers.

The long-term objective is standardization only if the design survives independent cryptographic review, implementation by independent parties, interoperability testing, and sustained public security analysis.

## 2. Design principles

1. **Cryptography is the primary security boundary.**
2. **Channel observations are untrusted input.**
3. **Authenticated state is authoritative.**
4. **Adaptive behavior must not silently downgrade security.**
5. **Failure is fail-closed for security-critical transitions.**
6. **Experimental signal/physics layers never override cryptographic authorization.**
7. **Security claims must be testable and falsifiable.**
8. **No component is considered secure merely because it is novel.**
9. **The reference application is not the protocol specification.**
10. **Independent implementations are required before any standardization claim.**

## 3. Threat model

QCAUS Secure considers an active network adversary capable of:

- observing, delaying, dropping, duplicating, reordering, and modifying packets;
- attempting man-in-the-middle substitution;
- replaying previously valid messages;
- attempting downgrade or capability confusion;
- injecting malformed state-transition data;
- inducing reconnects and recovery attempts;
- compromising a device after a session has been established;
- obtaining previously exposed application metadata;
- attempting local state corruption where platform permissions permit it.

The architecture does **not** assume that an endpoint is secure merely because transport encryption is enabled.

Out of scope for the reference beta:

- attacks against third-party infrastructure;
- unauthorized access to systems that do not belong to the tester;
- denial-of-service against public services;
- malware distribution;
- exploitation of unrelated products.

## 4. Security goals

A conforming implementation should provide, subject to its selected cryptographic protocol:

- authenticated peer identity;
- confidentiality of protected application content;
- integrity/authenticity of protected messages;
- replay resistance;
- downgrade resistance;
- forward secrecy;
- post-compromise recovery where supported by the selected protocol;
- explicit device/session state;
- authenticated recovery transitions;
- auditable failure behavior;
- cryptographic agility without silent weakening.

## 5. Trust boundaries

### Trusted security inputs

- locally protected long-term identity keys;
- authenticated protocol transcripts;
- verified key-establishment outputs;
- cryptographically authenticated state-transition authorization;
- locally enforced monotonic/session counters.

### Untrusted inputs

- network packets before authentication;
- peer-supplied capability claims before authentication;
- timing observations;
- signal-quality measurements;
- reconstructed/decoded experimental data;
- user-visible network status;
- adaptive channel suggestions.

An adaptive measurement may recommend a transition. It cannot authorize that transition.

## 6. AASR: Authenticated Adaptive State Recovery

AASR means **Authenticated Adaptive State Recovery**.

The architectural rule is:

> An observed condition may propose a state transition, but only authenticated protocol state can authorize it.

Conceptual state machine:

```text
                 +------------------+
                 |      INIT        |
                 +---------+--------+
                           |
                           v
                 +------------------+
                 | AUTHENTICATING   |
                 +--------+---------+
                          |
                    authenticated
                          v
                 +------------------+
                 |     ACTIVE       |
                 +---+----------+---+
                     |          |
          adaptation |          | failure
                     v          v
              +------+---+  +---+----------+
              | ADAPTING |  | RECOVERING   |
              +------+---+  +---+----------+
                     |          |
             authorized         | authenticated
               transition       | recovery
                     |          |
                     +----+-----+
                          |
                          v
                 +------------------+
                 |     ACTIVE       |
                 +------------------+

Any unauthorized transition -> REJECT / FAIL CLOSED
```

### AASR transition invariant

For a security-sensitive transition `S -> S'`:

`authorize(S, S', authenticated_context) == true`

must be required before committing `S'`.

A channel observation alone must never satisfy the authorization predicate.

### Recovery

Recovery must:

1. authenticate the session/peer according to the selected protocol;
2. validate transcript/context binding;
3. reject stale or replayed transition material;
4. reject capability downgrade;
5. advance state monotonically;
6. persist the resulting state safely.

## 7. Cryptographic protocol boundary

The current prototype's raw X25519-derived value is explicitly **not a production session-key schedule**.

A production implementation must use an independently reviewed protocol or a protocol construction whose complete security properties are reviewed. The architecture should support:

- authenticated key agreement;
- a KDF such as HKDF where appropriate;
- AEAD;
- explicit transcript/context binding;
- nonce/sequence management;
- replay protection;
- ratcheting;
- identity binding;
- forward secrecy;
- post-compromise recovery;
- multi-device key management;
- secure platform key storage.

Do not invent a new cipher, KDF, signature scheme, or ratchet merely to make QCAUS novel.

## 8. Downgrade resistance

Negotiation must be monotonic with respect to declared security policy.

A peer must not be able to force:

`stronger_policy -> weaker_policy`

without explicit authenticated policy authorization.

Unsupported algorithms should produce a visible negotiation failure rather than an automatic fallback to an insecure alternative.

## 9. Identity model

The architecture separates:

- **person/account identity**
- **device identity**
- **session identity**

A device key should be independently verifiable. Identity changes should be visible and should invalidate assumptions that depend on the old identity state.

The eventual protocol should define key verification UX and safety-number/key-fingerprint behavior separately from the cryptographic primitives.

## 10. Replay protection

Every authenticated message or transition must have replay-detection semantics.

Acceptable mechanisms may include:

- monotonic counters;
- authenticated sequence numbers;
- bounded replay windows;
- transcript binding;
- protocol-specific ratchet state.

A message that is cryptographically valid but stale must still be rejected.

## 11. Experimental QCAUS layers

The two-field codec, photon/dark-photon research, FDM models, spectral processing, and related experimental components are **not security authorities**.

They may be used as:

- signal-processing experiments;
- channel simulations;
- research instrumentation;
- future research extensions.

They must not:

- authorize cryptographic state transitions;
- generate claims of FTL communication;
- replace encryption;
- replace authentication;
- be presented as demonstrated dark-photon communication.

The system must remain secure when those experimental components are disabled.

## 12. Security invariants

A test suite should continuously assert:

- unauthenticated transition => rejected;
- altered transition token => rejected;
- stale transition => rejected;
- replayed transition => rejected;
- downgrade without authorization => rejected;
- invalid authentication => rejected;
- experimental layer disabled => cryptographic security boundary unchanged;
- malformed input => no crash-driven security bypass;
- local state rollback => detected or safely rejected;
- session context mismatch => rejected.

## 13. Interoperability

A future QCAUS Secure standard should publish:

- canonical message formats;
- canonical encodings;
- protocol state diagrams;
- test vectors;
- negative test vectors;
- error semantics;
- version negotiation rules;
- capability negotiation rules;
- conformance profiles.

Two independent implementations should be able to establish and protect a session without sharing application code.

## 14. Standardization path

QCAUS Secure should not call itself a security standard at v0.1.

Proposed maturity:

- **v0.1 — Architecture / public beta**
- **v0.2 — Protocol draft + test vectors**
- **v0.3 — Independent implementation**
- **v0.4 — External cryptographic review**
- **v0.5 — Interoperability / conformance testing**
- **v1.0 — Candidate protocol specification**
- **Post-v1.0 — Standards-track submission or industry consortium process**

## 15. Security claim policy

Preferred:

> “QCAUS Secure proposes an authenticated adaptive communications-security architecture.”

Avoid:

> “unhackable”  
> “military-grade” without a specific verified basis  
> “quantum-proof” without a defined cryptographic construction  
> “proven secure” before independent review  
> “new standard” before adoption

## 16. Open research questions

The public beta should explicitly solicit research on:

- whether AASR provides meaningful security beyond conventional authenticated session state;
- formal verification of the state machine;
- downgrade and recovery edge cases;
- multi-device state synchronization;
- compromise and recovery semantics;
- usability of identity-change warnings;
- cryptographic agility;
- formal composition with existing E2EE protocols;
- side-channel and local-storage risks;
- whether experimental adaptive signal layers create any new attack surface.

