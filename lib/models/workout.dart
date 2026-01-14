import 'package:hive/hive.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int workDuration;

  @HiveField(3)
  late int restDuration;

  @HiveField(4)
  late int rounds;

  @HiveField(5)
  late DateTime createdAt;

  @HiveField(6)
  late DateTime updatedAt;

  Workout({
    required this.id,
    required this.name,
    required this.workDuration,
    required this.restDuration,
    required this.rounds,
    required this.createdAt,
    required this.updatedAt,
  });

  int get totalDuration => (workDuration + restDuration) * rounds;

  String get formattedDuration {
    final minutes = totalDuration ~/ 60;
    final seconds = totalDuration % 60;
    return '${minutes}m ${seconds}s';
  }
}
