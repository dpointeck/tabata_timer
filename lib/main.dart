import 'package:flutter/material.dart';
import './theme/custom_theme.dart';
import './services/storage_service.dart';
import './services/audio_service.dart';
import './screens/workout_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final audioService = AudioService();

  runApp(MyApp(
    storageService: storageService,
    audioService: audioService,
  ));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final AudioService audioService;

  const MyApp({
    Key? key,
    required this.storageService,
    required this.audioService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabata Timer',
      debugShowCheckedModeBanner: false,
      darkTheme: CustomTheme.darkTheme(context),
      themeMode: ThemeMode.dark,
      home: WorkoutListScreen(
        storageService: storageService,
        audioService: audioService,
      ),
    );
  }
}
