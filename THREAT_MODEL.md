# QCAUS Secure Threat Model

## Attacker capabilities

The network attacker may:

- read metadata visible to the network;
- delay packets;
- reorder packets;
- duplicate packets;
- drop packets;
- modify packets;
- inject packets;
- attempt identity substitution;
- replay previously observed valid messages;
- attempt downgrade;
- trigger reconnect/recovery paths;
- provide malformed input.

A stronger endpoint attacker may:

- obtain application-local data;
- attempt rollback of local state;
- observe application behavior;
- compromise a device after key establishment.

## Assets

- long-term identity keys;
- session keys;
- protected messages;
- files;
- authenticated session state;
- transition counters;
- recovery material;
- user identity verification state.

## Security boundaries

The following are security boundaries:

1. identity key storage;
2. authenticated key establishment;
3. session key derivation;
4. authenticated encryption;
5. replay protection;
6. state-transition authorization;
7. persistent state integrity.

## Non-goals

QCAUS Secure v0.1 does not claim:

- anonymous communication;
- traffic-analysis resistance;
- protection against a fully compromised endpoint;
- protection against malicious operating systems;
- guaranteed metadata secrecy;
- resistance to every side channel;
- cryptographic certification;
- quantum resistance unless a specific PQ construction is enabled and independently reviewed.

## Abuse boundary

Security testers must test only systems and accounts they are authorized to test. Public-beta testing must not include attacks on unrelated infrastructure, service providers, or other users.
