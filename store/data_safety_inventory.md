# Store Data Safety Inventory — v0.1.0

This document describes the **current local prototype** only. The Play Console Data Safety form and Apple privacy nutrition labels must be completed from the exact binaries and SDK behavior submitted to each store.

## Current prototype behavior

### Data created by the app

- Chat text entered by the user is held in the current app session.
- A selected file may be read by the file-picker workflow to display its name and size.
- AASR test state is held in memory.
- QCAUS Lab values are held in memory.

### Network transmission

The current prototype does not implement a QCAUS network backend for chat, calls, or file transfer.

### Account

The current prototype does not create a network account.

### Advertising / analytics

No advertising SDK or analytics SDK is included in the prototype dependency list.

### Contacts

The current prototype displays a sample contact and does not require broad device-contact access.

### Microphone / camera

The current prototype does not implement live voice/video capture and therefore should not request microphone/camera permissions.

## Before a network release

Rebuild this inventory against the actual production services. Document:

- account identifiers;
- phone/email authentication;
- public identity keys;
- encrypted message metadata;
- encrypted attachments;
- push-token handling;
- call signaling;
- WebRTC metadata;
- crash reporting;
- analytics, if any;
- retention periods;
- deletion behavior;
- third-party processors.

Do not submit a Data Safety declaration based on this document alone.
