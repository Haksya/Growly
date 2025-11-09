import 'package:flutter/material.dart';
import 'package:growly/models/habit_model.dart';
import 'package:growly/services/habit_service.dart';

class HabitHistoryScreen extends StatelessWidget {
  const HabitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitService habitService = HabitService();

    return Scaffold(
      appBar: AppBar(title: Text('habit History'), centerTitle: true),
      body: StreamBuilder<List<Habit>>(
        stream: habitService.getHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          final habits = snapshot.data!;

          if (habits.isEmpty) {
            return const Center(child: Text('No habit data'));
          }

          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return ExpansionTile(
                title: Text(habit.title),
                children: habit.completedDates.map((date) {
                  return ListTile(
                    title: Text(date),
                    leading: Icon(Icons.check_circle, color: Colors.green),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
