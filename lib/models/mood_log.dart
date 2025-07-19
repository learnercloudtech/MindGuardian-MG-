import 'package:hive/hive.dart';

part 'mood_log.g.dart'; // Required for Hive type adapter

@HiveType(typeId: 0)
class MoodLog extends HiveObject {
  @HiveField(0)
  final int moodScore;

  @HiveField(1)
  final String note;

  @HiveField(2)
  final DateTime timestamp;

  // 🧠 Granite Emotional Agent Fields
  @HiveField(3)
  final String? emotion;

  @HiveField(4)
  final String? agentReply;

  @HiveField(5)
  final int? riskScore;

  @HiveField(6)
  final List<String>? recommendations;

  MoodLog({
    required this.moodScore,
    required this.note,
    required this.timestamp,
    this.emotion,
    this.agentReply,
    this.riskScore,
    this.recommendations,
  });
}
