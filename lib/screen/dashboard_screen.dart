import 'package:flutter/material.dart';
import 'package:growly/models/habit_model.dart';
import 'package:growly/screen/add_habit_screen.dart';
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return const AddHabitScreen();
                  },
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),

      body: StreamBuilder<List<Habit>>(
        stream: habitService.getHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('no data'));
          }

          final habits = snapshot.data!;

          int totalhabits = habits.length;
          int completedhabits = habits
              .where((habit) => habit.isDone)
              .toList()
              .length;
          double progress = totalhabits == 0
              ? 0
              : completedhabits / totalhabits;

          if (habits.isEmpty) {
            return const Center(child: Text('no habit data'));
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return CheckboxListTile(
                      title: Text(habit.title),
                      value: habit.isDone,
                      onChanged: (value) {
                        HabitService().toogleHabitStatus(
                          habit.id,
                          habit.isDone,
                        );
                      },
                      secondary: IconButton(
                        onPressed: () {
                          HabitService().deleteHabit(habit.id);
                        },
                        icon: const Icon(Icons.delete),
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
