/// Authenticated Adaptive State Recovery (AASR).
///
/// AASR is an application-layer state-transition guard. Observations are
/// untrusted. A state transition is accepted only when its authorization token
/// matches the locally authenticated session token. This is not a replacement
/// for authenticated encryption, identity binding, or a reviewed messaging
/// protocol.
class AasrEvent {
  final String type;
  final String detail;
  final DateTime timestamp;

  const AasrEvent({
    required this.type,
    required this.detail,
    required this.timestamp,
  });
}

class AasrState {
  final String phase;
  final int epoch;
  final bool compromised;

  const AasrState({
    required this.phase,
    required this.epoch,
    required this.compromised,
  });

  AasrState copyWith({
    String? phase,
    int? epoch,
    bool? compromised,
  }) =>
      AasrState(
        phase: phase ?? this.phase,
        epoch: epoch ?? this.epoch,
        compromised: compromised ?? this.compromised,
      );
}

class AasrEngine {
  String _authenticatedToken;
  AasrState _state;
  final List<AasrEvent> events = [];

  AasrEngine({String initialToken = 'demo-auth-token'})
      : _authenticatedToken = initialToken,
        _state = const AasrState(
          phase: 'READY',
          epoch: 0,
          compromised: false,
        );

  AasrState get state => _state;

  String get authenticatedToken => _authenticatedToken;

  void observe(String detail) {
    events.add(AasrEvent(
      type: 'OBSERVE',
      detail: detail,
      timestamp: DateTime.now().toUtc(),
    ));
  }

  bool authenticatedTransitionToken(String token) => token == _authenticatedToken;

  bool transition({
    required String token,
    required String nextPhase,
    required String reason,
  }) {
    if (!authenticatedTransitionToken(token)) {
      events.add(AasrEvent(
        type: 'REJECT',
        detail: 'Unauthenticated state transition rejected: $reason',
        timestamp: DateTime.now().toUtc(),
      ));
      return false;
    }

    _state = _state.copyWith(
      phase: nextPhase,
      epoch: _state.epoch + 1,
      compromised: nextPhase == 'RECOVERY_REQUIRED',
    );
    events.add(AasrEvent(
      type: 'ACCEPT',
      detail: '$nextPhase: $reason',
      timestamp: DateTime.now().toUtc(),
    ));
    return true;
  }

  void rotateSessionToken(String newToken) {
    if (newToken.trim().isEmpty) {
      throw ArgumentError('Session token cannot be empty');
    }
    _authenticatedToken = newToken;
    _state = _state.copyWith(
      phase: 'READY',
      epoch: _state.epoch + 1,
      compromised: false,
    );
    events.add(AasrEvent(
      type: 'TOKEN_ROTATE',
      detail: 'Authenticated session token rotated',
      timestamp: DateTime.now().toUtc(),
    ));
  }

  bool recover(String token) => transition(
        token: token,
        nextPhase: 'READY',
        reason: 'Authenticated recovery',
      );
}
