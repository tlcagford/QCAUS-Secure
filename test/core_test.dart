import 'package:flutter_test/flutter_test.dart';
import 'package:qcaus_secure/core/aasr.dart';
import 'package:qcaus_secure/core/two_field_codec.dart';

void main() {
  test('two-field symbols decode', () {
    expect(TwoFieldCodec.decode(TwoFieldCodec.encodeBit(0)), 0);
    expect(TwoFieldCodec.decode(TwoFieldCodec.encodeBit(1)), 1);
  });
  test('AASR authenticates recovery', () {
    final e = AasrEngine();
    final token = e.authenticatedTransitionToken('secret');
    expect(e.recover(sessionSecret: 'secret', token: token), isTrue);
    expect(e.recover(sessionSecret: 'secret', token: 'bad'), isFalse);
  });
}
