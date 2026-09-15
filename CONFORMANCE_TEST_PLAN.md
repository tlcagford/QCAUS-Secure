# QCAUS Secure Conformance Test Plan

## Required categories

| ID | Test | Expected |
|---|---|---|
| AASR-001 | valid authenticated transition | accept |
| AASR-002 | altered authorization | reject |
| AASR-003 | replayed transition | reject |
| AASR-004 | stale counter | reject |
| AASR-005 | wrong session ID | reject |
| AASR-006 | wrong transcript/context | reject |
| AASR-007 | unauthorized downgrade | reject |
| AASR-008 | malformed transition | reject safely |
| AASR-009 | state rollback | reject/detect |
| AASR-010 | experimental input attempts authorization | reject |

## Future protocol tests

- identity verification;
- authenticated key establishment;
- transcript binding;
- AEAD integrity;
- nonce discipline;
- forward secrecy;
- post-compromise recovery;
- multi-device synchronization;
- key rotation;
- version negotiation.

## Interoperability

Publish canonical test vectors with:

- input;
- expected encoding;
- expected authentication result;
- expected state;
- expected rejection reason.

A conforming implementation must pass both positive and negative vectors.
