import 'dart:math';

class TwoFieldSymbol {
  final double phase, omega, crossTerm;
  const TwoFieldSymbol({required this.phase, required this.omega, required this.crossTerm});
}

/// Classical coherent two-field research codec:
/// rho = |psi_t|² + |psi_d|² + 2 Omega Re(psi_t* psi_d exp(i DeltaPhi)).
class TwoFieldCodec {
  static TwoFieldSymbol encodeBit(int bit, {double omega = .35}) {
    if (bit != 0 && bit != 1) throw ArgumentError('bit must be 0 or 1');
    if (omega < 0 || omega > 1) throw ArgumentError('omega must be in [0,1]');
    final phase = bit == 0 ? 0.0 : pi;
    return TwoFieldSymbol(phase: phase, omega: omega, crossTerm: 2 * omega * cos(phase));
  }
  static int decode(TwoFieldSymbol symbol) => symbol.crossTerm >= 0 ? 0 : 1;
}
