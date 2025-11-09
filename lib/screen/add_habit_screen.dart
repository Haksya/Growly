import 'package:flutter/material.dart';
import 'package:growly/services/habit_service.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _titleController = TextEditingController();
  final HabitService _habitService = HabitService();

  Future<void> _saveHabit() async {
    final title = _titleController.text;
    if (title.isEmpty) return;

    await _habitService.addHabit(title);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Habit'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Habit Title'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _saveHabit,
              child: const Text('Save Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
