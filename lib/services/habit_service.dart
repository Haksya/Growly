import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:growly/models/habit_model.dart';

class HabitService {
  final CollectionReference _habitsCollection = FirebaseFirestore.instance
      .collection('habits');

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  /// 🟩 Tambah habit baru
  Future<void> addHabit(String title) async {
    await _habitsCollection.add({
      'title': title,
      'isDone': false,
      'completedDates': [],
      'ownerId': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 🟥 Hapus habit berdasarkan ID
  Future<void> deleteHabit(String id) async {
    await _habitsCollection.doc(id).delete();
  }

  /// 📡 Ambil daftar habit milik user saat ini
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

  /// 🔄 Toggle status habit (check/uncheck)
  Future<void> toggleHabitStatus(String id, bool isDone) async {
    final docRef = _habitsCollection.doc(id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>? ?? {};

      // Ambil daftar tanggal selesai
      List<String> completedDates = List<String>.from(
        data['completedDates'] ?? [],
      );

      // Format tanggal hari ini (YYYY-MM-DD)
      String today = DateTime.now().toIso8601String().substring(0, 10);

      if (isDone) {
        // Tambahkan tanggal hari ini jika belum ada
        if (!completedDates.contains(today)) {
          completedDates.add(today);
        }
      } else {
        // Hapus tanggal hari ini jika uncheck
        completedDates.remove(today);
      }

      // Update Firestore
      await docRef.update({'completedDates': completedDates, 'isDone': isDone});
    }
  }
}
