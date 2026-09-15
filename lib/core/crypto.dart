import 'dart:convert';
import 'package:cryptography/cryptography.dart';

/// Standard cryptographic primitives used only by the prototype.
///
/// IMPORTANT:
/// deriveSessionKey exposes the raw X25519 shared secret for research/tests.
/// It MUST NOT be used as a production messaging key schedule. Production
/// QCAUS Secure must integrate an independently reviewed authenticated
/// messaging protocol with a proper KDF/ratchet, identity binding, replay
/// protection, forward secrecy, post-compromise recovery, and multi-device
/// key management.
class QcausCrypto {
  static final aead = Chacha20.poly1305Aead();

  static Future<SimpleKeyPair> newExchangeKeyPair() =>
      X25519().newKeyPair();

  static Future<SecretKey> deriveSessionKey(
    SimpleKeyPair local,
    SimplePublicKey remote,
  ) =>
      X25519().sharedSecretKey(
        keyPair: local,
        remotePublicKey: remote,
      );

  static Future<SecretBox> encrypt(
    String text,
    SecretKey key, {
    List<int> aad = const [],
  }) =>
      aead.encrypt(
        utf8.encode(text),
        secretKey: key,
        aad: aad,
      );

  static Future<String> decrypt(
    SecretBox box,
    SecretKey key, {
    List<int> aad = const [],
  }) async =>
      utf8.decode(
        await aead.decrypt(box, secretKey: key, aad: aad),
      );
}
