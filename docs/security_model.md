# Security Model

## Current threat model

Treat channel observations as untrusted.

AASR only permits a state transition when it carries the locally authenticated
session authorization token. A modified transition must fail closed.

## What AASR does

- Separates observation from authorization.
- Rejects an unauthorized transition.
- Records a local event for audit/debugging.
- Supports an authenticated recovery transition.

## What AASR does not do

AASR does not by itself provide:

- encryption;
- identity authentication;
- forward secrecy;
- post-compromise recovery;
- secure messaging;
- quantum resistance;
- protection against a compromised endpoint.

## Two-field research layer

The QCAUS Lab models a classical coherent two-field signal with a cross-term.
It is intentionally labeled as a DSP/physics research model. It must not be
used as evidence that a dark-photon or FDM communications channel exists.

## Production gate

A production secure messenger needs an independently reviewed authenticated
messaging protocol, secure key schedule, identity binding, replay protection,
forward secrecy, post-compromise recovery, secure storage, and a complete
endpoint threat model.
