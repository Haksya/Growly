import 'package:flutter/material.dart';
import 'package:growly/models/habit_model.dart';
import 'package:growly/screen/add_habit_screen.dart';
import 'package:growly/screen/habit_history_screen.dart';
import 'package:growly/services/habit_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitService habitService = HabitService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddHabitScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HabitHistoryScreen()),
              );
            },
          ),
        ],
      ),

      // 🔁 Stream untuk update data realtime dari Firestore
      body: StreamBuilder<List<Habit>>(
        stream: habitService.getHabits(),
        builder: (context, snapshot) {
          // ⏳ Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Jika tidak ada data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No habit data'));
          }

          // ✅ Data tersedia
          final habits = snapshot.data!;
          final totalHabits = habits.length;
          final completedHabits = habits
              .where((habit) => habit.isDone)
              .toList()
              .length;

          final progress = totalHabits == 0
              ? 0.0
              : completedHabits / totalHabits.toDouble();

          return Column(
            children: [
              // 🔹 Progress Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),

              // 🔸 Daftar Habit
              Expanded(
                child: ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];

                    return CheckboxListTile(
                      title: Text(habit.title),
                      subtitle: Text(
                        habit.calculateStreak() >= 5
                            ? "🔥🔥🔥 Streak: ${habit.calculateStreak()} hari "
                            : "🔥 Streak: ${habit.calculateStreak()} hari ",
                      ),
                      value: habit.isDone,
                      onChanged: (value) {
                        habitService.toggleHabitStatus(habit.id, value!);
                      },
                      secondary: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          habitService.deleteHabit(habit.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
