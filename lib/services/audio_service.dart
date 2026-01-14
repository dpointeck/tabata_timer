import 'package:audioplayers/audioplayers.dart';

enum SoundType {
  workComplete,
  restComplete,
  workoutComplete,
  countdown,
}

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSound(SoundType type) async {
    try {
      late AssetSource source;

      switch (type) {
        case SoundType.workComplete:
          source = AssetSource('sounds/work_done.mp3');
          break;
        case SoundType.restComplete:
          source = AssetSource('sounds/rest_done.mp3');
          break;
        case SoundType.workoutComplete:
          source = AssetSource('sounds/workout_done.mp3');
          break;
        case SoundType.countdown:
          source = AssetSource('sounds/beep.mp3');
          break;
      }

      await _player.play(source);
    } catch (e) {
      // Gracefully handle missing or invalid sound files
      // ignore: avoid_print
      print('Audio playback error: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
