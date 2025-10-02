import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:growly/models/habit_model.dart';

class HabitService {
  final CollectionReference _habitsCollection = FirebaseFirestore.instance
      .collection('habits');

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> addHabit(String title) async {
    await _habitsCollection.add({
      'title': title,
      'isDone': false,
      'ownerId': _uid, // <- penting: tandai pemilik dokumen
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteHabit(String id) async {
    await _habitsCollection.doc(id).delete();
  }

  // hanya ambil dokumen milik user ini
  Stream<List<Habit>> getHabits() {
    return _habitsCollection
        .where('ownerId', isEqualTo: _uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    Habit.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();
        });
  }

  Future<void> toogleHabitStatus(String id, bool isDone) async {
    await _habitsCollection.doc(id).update({'isDone': !isDone});
  }
}
