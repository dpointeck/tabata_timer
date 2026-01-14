import 'dart:async';
import '../models/workout.dart';
import '../models/timer_state.dart';
import '../services/audio_service.dart';

class TimerController {
  final Workout workout;
  final AudioService audioService;

  final StreamController<TimerState> _stateController =
      StreamController<TimerState>.broadcast();
  Stream<TimerState> get stateStream => _stateController.stream;

  Timer? _ticker;
  TimerState _currentState = const TimerState(
    status: TimerStatus.idle,
    currentRound: 0,
    remainingSeconds: 0,
    totalRounds: 0,
  );

  TimerController({
    required this.workout,
    required this.audioService,
  });

  TimerState get currentState => _currentState;

  void start() {
    _currentState = TimerState(
      status: TimerStatus.countdown,
      currentRound: 1,
      remainingSeconds: 3,
      totalRounds: workout.rounds,
    );
    _stateController.add(_currentState);
    audioService.playSound(SoundType.countdown);
    _startTicker();
  }

  void pause() {
    if (_currentState.status == TimerStatus.work ||
        _currentState.status == TimerStatus.rest) {
      _ticker?.cancel();
      _currentState = _currentState.copyWith(status: TimerStatus.paused);
      _stateController.add(_currentState);
    }
  }

  void resume() {
    if (_currentState.status == TimerStatus.paused) {
      final previousStatus = _currentState.remainingSeconds > 0
          ? (_currentState.currentRound <= workout.rounds
              ? TimerStatus.work
              : TimerStatus.rest)
          : TimerStatus.work;
      _currentState = _currentState.copyWith(status: previousStatus);
      _stateController.add(_currentState);
      _startTicker();
    }
  }

  void stop() {
    _ticker?.cancel();
    _currentState = TimerState(
      status: TimerStatus.idle,
      currentRound: 0,
      remainingSeconds: 0,
      totalRounds: workout.rounds,
    );
    _stateController.add(_currentState);
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _tick() {
    switch (_currentState.status) {
      case TimerStatus.countdown:
        _decrementTime();
        if (_currentState.remainingSeconds > 0) {
          audioService.playSound(SoundType.countdown);
        } else {
          _transitionToWork();
        }
        break;

      case TimerStatus.work:
        if (_currentState.remainingSeconds > 0) {
          _decrementTime();
        }
        if (_currentState.remainingSeconds == 0) {
          audioService.playSound(SoundType.workComplete);
          _transitionToRest();
        } else if (_currentState.remainingSeconds <= 3) {
          audioService.playSound(SoundType.countdown);
        }
        break;

      case TimerStatus.rest:
        if (_currentState.remainingSeconds > 0) {
          _decrementTime();
        }
        if (_currentState.remainingSeconds == 0) {
          audioService.playSound(SoundType.restComplete);
          if (_currentState.currentRound < _currentState.totalRounds) {
            _nextRound();
          } else {
            _completeWorkout();
          }
        } else if (_currentState.remainingSeconds <= 3) {
          audioService.playSound(SoundType.countdown);
        }
        break;

      case TimerStatus.completed:
        _ticker?.cancel();
        break;

      case TimerStatus.paused:
      case TimerStatus.idle:
        break;
    }
  }

  void _transitionToWork() {
    _currentState = _currentState.copyWith(
      status: TimerStatus.work,
      remainingSeconds: workout.workDuration,
    );
    _stateController.add(_currentState);
  }

  void _transitionToRest() {
    _currentState = _currentState.copyWith(
      status: TimerStatus.rest,
      remainingSeconds: workout.restDuration,
    );
    _stateController.add(_currentState);
  }

  void _nextRound() {
    _currentState = _currentState.copyWith(
      status: TimerStatus.work,
      currentRound: _currentState.currentRound + 1,
      remainingSeconds: workout.workDuration,
    );
    _stateController.add(_currentState);
  }

  void _completeWorkout() {
    _ticker?.cancel();
    _currentState = _currentState.copyWith(
      status: TimerStatus.completed,
      remainingSeconds: 0,
    );
    _stateController.add(_currentState);
    audioService.playSound(SoundType.workoutComplete);
  }

  void _decrementTime() {
    _currentState = _currentState.copyWith(
      remainingSeconds: _currentState.remainingSeconds - 1,
    );
    _stateController.add(_currentState);
  }

  void dispose() {
    _ticker?.cancel();
    _stateController.close();
  }
}
