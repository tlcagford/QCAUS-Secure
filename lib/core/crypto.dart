import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

/// Cryptographic primitives used only as a prototype/test harness.
///
/// IMPORTANT:
/// The raw X25519 shared secret is never treated as a production message key.
/// Production deployment must use a reviewed authenticated messaging protocol
/// with identity binding, HKDF/KDF domain separation, forward secrecy,
/// replay protection, post-compromise recovery, multi-device key management,
/// and secure local key storage.
class QcausCrypto {
  static final _x25519 = X25519();
  static final _aead = Chacha20.poly1305Aead();

  static Future<SimpleKeyPair> generateX25519KeyPair() =>
      _x25519.newKeyPair();

  static Future<SimplePublicKey> publicKey(SimpleKeyPair keyPair) =>
      keyPair.extractPublicKey();

  static Future<SecretKey> derivePrototypeSecret(
    SimpleKeyPair localKeyPair,
    SimplePublicKey remotePublicKey,
  ) =>
      _x25519.sharedSecretKey(
        keyPair: localKeyPair,
        remotePublicKey: remotePublicKey,
      );

  /// Explicitly named prototype KDF. This is intentionally not presented as
  /// a complete production session-key schedule.
  static Future<SecretKey> derivePrototypeSessionKey(
    SecretKey sharedSecret, {
    List<int> context = const <int>[],
  }) async {
    final bytes = await sharedSecret.extractBytes();
    final data = <int>[
      ...utf8.encode('QCAUS-Secure prototype session v0.1'),
      ...context,
      ...bytes,
    ];
    final digest = Sha256().hashSync(data);
    return SecretKey(digest.bytes);
  }

  static Future<SecretBox> encrypt(
    List<int> plaintext,
    SecretKey key, {
    List<int> aad = const <int>[],
  }) =>
      _aead.encrypt(
        plaintext,
        secretKey: key,
        aad: aad,
      );

  static Future<List<int>> decrypt(
    SecretBox box,
    SecretKey key, {
    List<int> aad = const <int>[],
  }) =>
      _aead.decrypt(
        box,
        secretKey: key,
        aad: aad,
      );

  static String toBase64(List<int> bytes) => base64Encode(bytes);
  static Uint8List fromBase64(String value) => base64Decode(value);
}
