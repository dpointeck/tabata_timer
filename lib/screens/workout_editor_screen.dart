import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/storage_service.dart';
import '../theme/palette.dart';
import '../widgets/styled_button.dart';

class WorkoutEditorScreen extends StatefulWidget {
  final Workout? workout;
  final StorageService storageService;

  const WorkoutEditorScreen({
    Key? key,
    this.workout,
    required this.storageService,
  }) : super(key: key);

  @override
  State<WorkoutEditorScreen> createState() => _WorkoutEditorScreenState();
}

class _WorkoutEditorScreenState extends State<WorkoutEditorScreen> {
  late TextEditingController _nameController;
  late int _workDuration;
  late int _restDuration;
  late int _rounds;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.workout?.name ?? '',
    );
    _workDuration = widget.workout?.workDuration ?? 20;
    _restDuration = widget.workout?.restDuration ?? 10;
    _rounds = widget.workout?.rounds ?? 8;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveWorkout() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a workout name')),
      );
      return;
    }

    final now = DateTime.now();
    final workout = Workout(
      id: widget.workout?.id ?? now.millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      workDuration: _workDuration,
      restDuration: _restDuration,
      rounds: _rounds,
      createdAt: widget.workout?.createdAt ?? now,
      updatedAt: now,
    );

    widget.storageService.saveWorkout(workout);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout == null ? 'New Workout' : 'Edit Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveWorkout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            _buildDurationPicker(
              label: 'Work',
              value: _workDuration,
              color: Palette.yellow500,
              onIncrement: () {
                setState(() {
                  _workDuration++;
                });
              },
              onDecrement: () {
                if (_workDuration > 1) {
                  setState(() {
                    _workDuration--;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            _buildDurationPicker(
              label: 'Rest',
              value: _restDuration,
              color: Colors.cyan,
              onIncrement: () {
                setState(() {
                  _restDuration++;
                });
              },
              onDecrement: () {
                if (_restDuration > 1) {
                  setState(() {
                    _restDuration--;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            _buildDurationPicker(
              label: 'Rounds',
              value: _rounds,
              color: Palette.yellow500,
              unit: '',
              onIncrement: () {
                setState(() {
                  _rounds++;
                });
              },
              onDecrement: () {
                if (_rounds > 1) {
                  setState(() {
                    _rounds--;
                  });
                }
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.yellow500,
                foregroundColor: Palette.almostBlack,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Save Workout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationPicker({
    required String label,
    required int value,
    required Color color,
    String unit = 'sec',
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 24, color: color),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledButton(
              text: "-",
              onPressed: onDecrement,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.0,
                    color: color,
                  ),
                ),
                if (unit.isNotEmpty)
                  Text(
                    unit,
                    style: TextStyle(
                      height: 2.0,
                      color: color,
                    ),
                  ),
              ],
            ),
            StyledButton(
              text: "+",
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}
