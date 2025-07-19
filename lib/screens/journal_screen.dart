import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/mood_log.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<MoodLog>('moodLogs');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Journal'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<MoodLog> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No mood logs yet.'));
          }

          final logs = box.values.toList().reversed;

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs.elementAt(index);
              final emoji = _emojiForScore(log.moodScore);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.blue.shade50,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🧠 Basic Mood Info
                      Row(
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log.note.isEmpty ? 'No note' : log.note,
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('${log.timestamp.toLocal()}'.split('.')[0],
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text('${log.moodScore}/10'),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 🧠 Agent Intelligence Section
                      if (log.agentReply != null && log.agentReply!.isNotEmpty) ...[
                        Divider(),
                        Text('🧠 Emotional Insight', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text('Emotion: ${log.emotion ?? 'N/A'}'),
                        Text('Agent says: ${log.agentReply}'),
                        if ((log.riskScore ?? 0) > 85)
                          Text('⚠️ High stress detected. Consider seeking support.',
                              style: const TextStyle(color: Colors.red)),
                        if (log.recommendations != null && log.recommendations!.isNotEmpty)
                          Text('Suggestions: ${log.recommendations!.join(", ")}'),
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _emojiForScore(int score) {
    const emojis = {
      1: '😢', 2: '😞', 3: '😟', 4: '😐', 5: '🙂',
      6: '😊', 7: '😁', 8: '😄', 9: '😃', 10: '🤩',
    };
    return emojis[score] ?? '🙂';
  }
}
