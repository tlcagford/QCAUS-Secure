import 'dart:math' as math;

/// Classical two-field coherent-signal/DSP demonstration.
///
/// The two channels are represented as phase-coded symbols. The cross-term
/// demonstrates the toy interference expression:
///   rho = |psi_L|^2 + |psi_D|^2 + 2 Omega Re(psi_L psi_D*)
///
/// This implementation does NOT establish physical dark-photon/FDM coupling,
/// entanglement, FTL communication, or reactionless communication.
class TwoFieldCodec {
  const TwoFieldCodec();

  List<double> encodeBpsk(
    List<int> bits, {
    double omega = 0.20,
  }) {
    if (omega < 0 || omega > 1) {
      throw ArgumentError('omega must be between 0 and 1');
    }
    return bits.map((bit) {
      if (bit != 0 && bit != 1) {
        throw ArgumentError('bits must contain only 0 or 1');
      }
      final phase = bit == 0 ? 0.0 : math.pi;
      return 1.0 + 1.0 + 2.0 * omega * math.cos(phase);
    }).toList();
  }

  List<int> decodeBpsk(
    List<double> received, {
    double omega = 0.20,
  }) {
    if (omega <= 0) {
      throw ArgumentError('omega must be positive for decoding');
    }
    final low = 2.0 - 2.0 * omega;
    final high = 2.0 + 2.0 * omega;
    final midpoint = (low + high) / 2.0;
    return received.map((value) => value < midpoint ? 1 : 0).toList();
  }
}
