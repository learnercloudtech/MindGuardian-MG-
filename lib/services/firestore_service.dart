import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_log.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveMoodLog(MoodLog moodLog) async {
    await _db.collection('moodLogs').add({
      'moodScore': moodLog.moodScore,
      'note': moodLog.note,
      'timestamp': moodLog.timestamp.toIso8601String(),
    });
  }
}
