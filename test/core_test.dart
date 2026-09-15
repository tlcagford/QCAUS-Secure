import 'package:flutter_test/flutter_test.dart';
import 'package:qcaus_secure/core/aasr.dart';
import 'package:qcaus_secure/core/two_field_codec.dart';

void main() {
  test('AASR rejects unauthenticated transition', () {
    final engine = AasrEngine(initialToken: 'good');
    final accepted = engine.transition(
      token: 'bad',
      nextPhase: 'RECOVERY_REQUIRED',
      reason: 'test',
    );
    expect(accepted, isFalse);
    expect(engine.state.phase, 'READY');
    expect(engine.events.last.type, 'REJECT');
  });

  test('AASR accepts authenticated transition and recovery', () {
    final engine = AasrEngine(initialToken: 'good');
    expect(
      engine.transition(
        token: 'good',
        nextPhase: 'RECOVERY_REQUIRED',
        reason: 'test',
      ),
      isTrue,
    );
    expect(engine.state.compromised, isTrue);
    expect(engine.recover('good'), isTrue);
    expect(engine.state.phase, 'READY');
    expect(engine.state.compromised, isFalse);
  });

  test('two-field codec round trips BPSK symbols', () {
    const codec = TwoFieldCodec();
    const bits = [0, 1, 0, 1, 1, 0];
    final encoded = codec.encodeBpsk(bits, omega: 0.2);
    final decoded = codec.decodeBpsk(encoded, omega: 0.2);
    expect(decoded, bits);
  });

  test('two-field codec rejects invalid bit', () {
    const codec = TwoFieldCodec();
    expect(
      () => codec.encodeBpsk([0, 2], omega: 0.2),
      throwsArgumentError,
    );
  });
}
