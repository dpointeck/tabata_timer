enum TimerStatus {
  idle,
  countdown,
  work,
  rest,
  paused,
  completed,
}

class TimerState {
  final TimerStatus status;
  final int currentRound;
  final int remainingSeconds;
  final int totalRounds;

  const TimerState({
    required this.status,
    required this.currentRound,
    required this.remainingSeconds,
    required this.totalRounds,
  });

  TimerState copyWith({
    TimerStatus? status,
    int? currentRound,
    int? remainingSeconds,
    int? totalRounds,
  }) {
    return TimerState(
      status: status ?? this.status,
      currentRound: currentRound ?? this.currentRound,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalRounds: totalRounds ?? this.totalRounds,
    );
  }

  String get statusLabel {
    switch (status) {
      case TimerStatus.idle:
        return 'READY';
      case TimerStatus.countdown:
        return 'GET READY';
      case TimerStatus.work:
        return 'WORK';
      case TimerStatus.rest:
        return 'REST';
      case TimerStatus.paused:
        return 'PAUSED';
      case TimerStatus.completed:
        return 'COMPLETED';
    }
  }
}
