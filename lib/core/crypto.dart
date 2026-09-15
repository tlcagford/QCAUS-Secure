import 'dart:convert';
import 'package:cryptography/cryptography.dart';

/// Standard cryptographic primitives for the prototype.
/// Production deployment must use an independently reviewed messaging protocol.
class QcausCrypto {
  static final aead = Chacha20.poly1305Aead();

  static Future<SimpleKeyPair> newExchangeKeyPair() => X25519().newKeyPair();

  static Future<SecretKey> deriveSessionKey(SimpleKeyPair local, SimplePublicKey remote) =>
      X25519().sharedSecretKey(keyPair: local, remotePublicKey: remote);

  static Future<SecretBox> encrypt(String text, SecretKey key, {List<int> aad = const []}) =>
      aead.encrypt(utf8.encode(text), secretKey: key, aad: aad);

  static Future<String> decrypt(SecretBox box, SecretKey key, {List<int> aad = const []}) async =>
      utf8.decode(await aead.decrypt(box, secretKey: key, aad: aad));
}
