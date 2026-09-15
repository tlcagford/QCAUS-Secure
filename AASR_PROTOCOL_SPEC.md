# AASR Protocol Draft

**Authenticated Adaptive State Recovery — QCAUS Secure v0.1**

## Status

Research protocol draft. Not a production cryptographic protocol and not a security certification.

## 1. Core rule

AASR separates **observation** from **authorization**.

`Observation -> Proposal -> Authentication/Authorization -> State Commit`

Never:

`Observation -> State Commit`

## 2. Transition object

A conceptual transition record contains:

```text
protocol_version
session_id
current_state
proposed_state
transition_counter
capability_set
policy_version
transcript_hash
transition_nonce
authenticated_authorization
```

The exact wire encoding is intentionally left for the protocol specification phase.

## 3. Required checks

Before accepting a transition:

1. Parse safely.
2. Validate protocol version.
3. Validate session binding.
4. Validate current state.
5. Validate counter/replay window.
6. Validate transcript/context hash.
7. Validate capabilities against policy.
8. Authenticate the authorization material.
9. Enforce downgrade policy.
10. Commit atomically.
11. Persist state.

Any failed security check results in rejection.

## 4. State categories

Recommended logical states:

- `INIT`
- `AUTHENTICATING`
- `ACTIVE`
- `ADAPTING`
- `RECOVERING`
- `REJECTED`
- `CLOSED`

`REJECTED` is terminal for the attempted transition, not necessarily the entire user account.

## 5. Security properties

AASR is intended to enforce:

### Authenticity
Only authorized protocol state can authorize a security transition.

### Integrity
Modified transition material is rejected.

### Freshness
Stale/replayed transition material is rejected.

### Context binding
A transition from one session/context cannot be transplanted into another.

### Policy monotonicity
Adaptive behavior cannot silently weaken the security policy.

### Fail closed
Ambiguous authorization is rejection, not fallback.

## 6. Adversarial examples

### MITM modification

Attacker changes:

`ACTIVE -> ADAPTING`

Authorization no longer matches the authenticated context.

**Expected result:** reject.

### Replay

Attacker replays a previously valid recovery transition.

Counter/context is stale.

**Expected result:** reject.

### Downgrade

Attacker removes stronger capabilities from negotiation.

Authenticated policy detects the mismatch.

**Expected result:** reject.

### Cross-session transplant

Attacker copies a valid transition from session A into session B.

Session binding/transcript hash differs.

**Expected result:** reject.

### Lost connectivity

The network disappears.

A client may enter a local recovery candidate state, but cannot authorize a new security state merely because connectivity was lost.

**Expected result:** wait for authenticated recovery or fail closed.

## 7. Relationship to encryption

AASR does not replace authenticated encryption.

The production stack should conceptually be:

`Identity -> Key Establishment -> Secure Session -> Authenticated State -> Adaptive Transport`

not:

`Adaptive Transport -> Security`

## 8. Formalization target

The next research version should express the transition function as:

`δ(S, E, A) -> S'`

where:

- `S` = current authenticated state;
- `E` = observed event;
- `A` = authenticated authorization;
- `S'` = next state.

Safety property:

`if authorize(S,E,A) = false, then δ(S,E,A) != S'`

for every security-sensitive `S'`.

