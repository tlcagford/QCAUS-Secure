import 'dart:convert';
import 'package:crypto/crypto.dart';

enum AasrEvent { stable, degraded, anomaly, authenticatedRecovery, rejectedRecovery }

class AasrState {
  final int sequence;
  final String stateId;
  final double channelScore;
  final AasrEvent event;
  const AasrState({required this.sequence, required this.stateId, required this.channelScore, required this.event});
}

/// Authenticated Adaptive State Recovery.
/// Channel observations are untrusted; only authenticated session material can
/// authorize a state transition.
class AasrEngine {
  int _sequence = 0;
  String _stateId = 'initial';
  final List<AasrState> history = [];

  AasrState observe(double score) {
    final s = score.clamp(0.0, 1.0);
    final event = s < .30 ? AasrEvent.anomaly : s < .60 ? AasrEvent.degraded : AasrEvent.stable;
    final state = AasrState(sequence: _sequence, stateId: _stateId, channelScore: s, event: event);
    history.add(state);
    return state;
  }

  String authenticatedTransitionToken(String sessionSecret) =>
      sha256.convert(utf8.encode('$sessionSecret|${_sequence + 1}|$_stateId')).toString();

  bool recover({required String sessionSecret, required String token}) {
    if (token != authenticatedTransitionToken(sessionSecret)) {
      history.add(AasrState(sequence: _sequence, stateId: _stateId, channelScore: 0, event: AasrEvent.rejectedRecovery));
      return false;
    }
    _sequence++;
    _stateId = sha256.convert(utf8.encode('$sessionSecret|$_sequence|$_stateId')).toString().substring(0, 16);
    history.add(AasrState(sequence: _sequence, stateId: _stateId, channelScore: 1, event: AasrEvent.authenticatedRecovery));
    return true;
  }
}
