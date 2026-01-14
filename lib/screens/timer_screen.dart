import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/timer_state.dart';
import '../controllers/timer_controller.dart';
import '../services/audio_service.dart';
import '../theme/palette.dart';

class TimerScreen extends StatefulWidget {
  final Workout workout;
  final AudioService audioService;

  const TimerScreen({
    Key? key,
    required this.workout,
    required this.audioService,
  }) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late TimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TimerController(
      workout: widget.workout,
      audioService: widget.audioService,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor(TimerStatus status) {
    switch (status) {
      case TimerStatus.work:
        return Palette.yellow500;
      case TimerStatus.rest:
        return Colors.cyan;
      case TimerStatus.countdown:
        return Palette.yellow500;
      case TimerStatus.completed:
        return Colors.green;
      case TimerStatus.paused:
        return Colors.orange;
      case TimerStatus.idle:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: StreamBuilder<TimerState>(
        stream: _controller.stateStream,
        initialData: _controller.currentState,
        builder: (context, snapshot) {
          final state = snapshot.data!;
          final statusColor = _getStatusColor(state.status);

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          state.statusLabel,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Palette.almostBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        state.remainingSeconds.toString(),
                        style: TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (state.status != TimerStatus.idle &&
                          state.status != TimerStatus.countdown)
                        Text(
                          'Round ${state.currentRound}/${state.totalRounds}',
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 24),
                      if (state.status != TimerStatus.idle &&
                          state.status != TimerStatus.countdown)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: LinearProgressIndicator(
                            value: state.totalRounds > 0
                                ? state.currentRound / state.totalRounds
                                : 0,
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              statusColor,
                            ),
                            minHeight: 8,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (state.status == TimerStatus.idle)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _controller.start,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.yellow500,
                            foregroundColor: Palette.almostBlack,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Start'),
                        ),
                      ),
                    if (state.status == TimerStatus.work ||
                        state.status == TimerStatus.rest ||
                        state.status == TimerStatus.countdown)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _controller.pause,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Pause'),
                        ),
                      ),
                    if (state.status == TimerStatus.paused)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _controller.resume,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Resume'),
                        ),
                      ),
                    const SizedBox(width: 16),
                    if (state.status != TimerStatus.idle)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.stop();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Stop'),
                        ),
                      ),
                    if (state.status == TimerStatus.completed)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.yellow500,
                            foregroundColor: Palette.almostBlack,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Done'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
