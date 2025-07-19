import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/mood_log.dart';
import '../services/firestore_service.dart';
import '../services/granite_service.dart';
import '../widgets/emoji_slider.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  double _moodValue = 5.0;
  final TextEditingController _noteController = TextEditingController();

  String agentReply = '';
  String emotion = '';
  int riskScore = 0;
  List<String> suggestions = [];

  Future<void> _saveMoodLog() async {
    final message = _noteController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a note before logging.')),
      );
      return;
    }

    try {
      final granite = GraniteService();
      final result = await granite.getAgentResponse(message);

      final moodLog = MoodLog(
        moodScore: _moodValue.toInt(),
        note: message,
        timestamp: DateTime.now(),
        agentReply: result['text'],
        emotion: result['emotion'],
        riskScore: result['riskScore'],
        recommendations: List<String>.from(
          result['recommendations'] is List ? result['recommendations'] : <String>[],
        ),
      );

      final box = Hive.isBoxOpen('moodLogs')
          ? Hive.box<MoodLog>('moodLogs')
          : await Hive.openBox<MoodLog>('moodLogs');
      await box.add(moodLog);
      print("💾 MoodLog saved locally");

      await FirestoreService().saveMoodLog(moodLog);
      print("☁️ MoodLog synced to Firestore");

      setState(() {
        agentReply = moodLog.agentReply ?? '';
        emotion = moodLog.emotion ?? '';
        riskScore = moodLog.riskScore ?? 0;
        suggestions = moodLog.recommendations ?? [];
        _moodValue = 5.0;
        _noteController.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mood logged, synced, and processed!')),
        );

        if (riskScore > 85) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('⚠️ Elevated Stress Detected'),
              content: const Text(
                'Your emotional score indicates heightened stress.\nWould you like to connect with a wellness coach or clinician?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Later'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Navigate to support page or open referral link
                  },
                  child: const Text('Get Support'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print("❌ Granite error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Agent is unavailable. Try again later.")),
        );
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('How are you feeling today?', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            EmojiSlider(
              value: _moodValue,
              onChanged: (val) => setState(() => _moodValue = val),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Add a note (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveMoodLog,
              icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
              label: const Text('Log & Get Suggestions', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 32),
            if (agentReply.isNotEmpty)
              Card(
                color: Colors.blue.shade50,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🧠 Emotional Analysis', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Emotion: $emotion'),
                      Text('Agent Response: $agentReply'),
                      Text('Suggestions: ${suggestions.isNotEmpty ? suggestions.join(", ") : "None"}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
