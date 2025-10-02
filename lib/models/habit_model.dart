class Habit {
  final String id;
  final String title;
  final bool isDone;
  final String? ownerId; // optional

  Habit({
    required this.id,
    required this.title,
    required this.isDone,
    this.ownerId,
  });

  factory Habit.fromMap(Map<String, dynamic> map, String documentId) {
    return Habit(
      id: documentId,
      title: map['title'] as String,
      isDone: map['isDone'] as bool,
      ownerId: map['ownerId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'isDone': isDone, 'ownerId': ownerId};
  }

  Habit copyWith({String? id, String? title, bool? isDone, String? ownerId}) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
