import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout.dart';

class StorageService {
  static const String _workoutsBoxName = 'workouts';
  late Box<Workout> _workoutsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WorkoutAdapter());
    _workoutsBox = await Hive.openBox<Workout>(_workoutsBoxName);
  }

  Future<void> saveWorkout(Workout workout) async {
    workout.updatedAt = DateTime.now();
    await _workoutsBox.put(workout.id, workout);
  }

  Future<void> deleteWorkout(String id) async {
    await _workoutsBox.delete(id);
  }

  Workout? getWorkout(String id) {
    return _workoutsBox.get(id);
  }

  List<Workout> getAllWorkouts() {
    return _workoutsBox.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> close() async {
    await _workoutsBox.close();
  }
}
