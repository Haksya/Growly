class Habit {
  final String id;
  final String title;
  final bool isDone;
  final List<String> completedDates;
  final String? ownerId; // optional

  Habit({
    required this.id,
    required this.title,
    required this.isDone,
    required this.completedDates,
    this.ownerId,
  });

  factory Habit.fromMap(Map<String, dynamic> data, String documentId) {
    return Habit(
      id: documentId,
      title: data['title'] as String,
      isDone: data['isDone'] as bool,
      completedDates: List<String>.from(data['completedDates'] ?? []),
      ownerId: data['ownerId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'completedDates': completedDates,
      'ownerId': ownerId,
    };
  }

  Habit copyWith({
    String? id,
    String? title,
    bool? isDone,
    List<String>? completedDates,
    String? ownerId,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      completedDates: completedDates ?? this.completedDates,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  int calculateStreak() {
    if (completedDates.isEmpty) return 0;

    List<DateTime> dates =
        completedDates.map((dateStr) => DateTime.parse(dateStr)).toList()
          ..sort((a, b) => b.compareTo(a)); // Sort descending

    int streak = 0;
    DateTime today = DateTime.now();
    for (var date in dates) {
      if (date.difference(today).inDays == 0 ||
          date.difference(today).inDays == -streak) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
