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
                      // 🌈 Mood Summary Row
                      Row(
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.note.isEmpty ? 'No note' : log.note,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${log.timestamp.toLocal()}'.split('.')[0],
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Text('${log.moodScore}/10'),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 🧠 Granite Insight Section
                      if (log.agentReply != null && log.agentReply!.isNotEmpty) ...[
                        Divider(),
                        Text('🧠 Emotional Insight', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text('Emotion: ${log.emotion ?? 'unknown'}'),
                        const SizedBox(height: 4),
                        Text('Agent Response: ${log.agentReply}'),
                        const SizedBox(height: 6),
                        if ((log.riskScore ?? 0) > 85)
                          Text(
                            '⚠️ High stress detected. Consider seeking support.',
                            style: const TextStyle(color: Colors.red),
                          ),
                        if ((log.riskScore ?? 0) <= 85 && (log.riskScore ?? 0) > 60)
                          Text(
                            '🔶 Moderate stress noted. Keep monitoring your mood.',
                            style: const TextStyle(color: Colors.orange),
                          ),
                        const SizedBox(height: 6),
                        if (log.recommendations != null && log.recommendations!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Suggestions:'),
                              ...log.recommendations!.map((s) => Text('• $s')),
                            ],
                          ),
                      ],
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
