# QCAUS Secure Standardization Roadmap

## Stage 0 — Research architecture

Deliver:

- architecture specification;
- threat model;
- AASR state machine;
- reference implementation;
- public beta;
- attack harness.

## Stage 1 — Protocol draft

Deliver:

- exact wire format;
- identity model;
- key lifecycle;
- authenticated state transitions;
- replay semantics;
- downgrade rules;
- versioning;
- test vectors.

## Stage 2 — Independent implementation

At least one implementation must be developed independently of the reference implementation.

## Stage 3 — Security review

Commission or obtain independent review.

Review should cover:

- cryptographic construction;
- protocol composition;
- state machine;
- recovery;
- downgrade resistance;
- implementation security.

## Stage 4 — Interoperability

Demonstrate two implementations communicating using only the published specification.

## Stage 5 — Public scrutiny

Run an extended public review and vulnerability disclosure program.

## Stage 6 — Candidate standard

Only at this stage should QCAUS describe the protocol as a candidate standard.

## Governance requirement

A future standard must define:

- version control;
- change control;
- security advisory process;
- compatibility policy;
- test-vector maintenance;
- responsible disclosure;
- independent review expectations.

The goal is not to force adoption. The goal is to produce a specification that others can independently evaluate and implement.
