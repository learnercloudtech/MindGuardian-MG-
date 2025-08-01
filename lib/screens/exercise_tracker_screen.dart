import 'package:flutter/material.dart';
import '../services/nova_service.dart';

class ExerciseTrackerScreen extends StatefulWidget {
  const ExerciseTrackerScreen({super.key});

  @override
  State<ExerciseTrackerScreen> createState() => _ExerciseTrackerScreenState();
}

class _ExerciseTrackerScreenState extends State<ExerciseTrackerScreen> {
  final List<String> _activities = ["🏃 Run", "🧘 Yoga", "🚴 Cycle", "💪 Weights", "🕺 Dance"];
  final Set<String> _selectedActivities = {};
  String _moodAfterWorkout = "";
  bool _isSubmitting = false;

  // Nova response
  String agentReply = '';
  String emotion = '';
  int riskScore = 0;
  List<String> recommendations = [];

  final String userId = "rocket-user"; // You can replace this with your UID logic
  final String sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  void _logActivity(String activity) {
    setState(() {
      _selectedActivities.contains(activity)
          ? _selectedActivities.remove(activity)
          : _selectedActivities.add(activity);
    });
  }

  Future<void> _submitMoodLog() async {
    if (_selectedActivities.isEmpty || _moodAfterWorkout.isEmpty) return;

    setState(() {
      _isSubmitting = true;
      agentReply = '';
      emotion = '';
      riskScore = 0;
      recommendations = [];
    });

    final prompt =
        "User completed ${_selectedActivities.join(', ')}. They feel $_moodAfterWorkout now. Offer emotional reflection and recovery tips.";

    try {
      final result = await NovaService().invokeNovaResponder(
        prompt: prompt,
        userId: userId,
        sessionId: sessionId,
      );

      setState(() {
        agentReply = result['text'] ?? 'Thanks for staying active today! 🌿';
        emotion = result['emotion'] ?? 'unknown';
        riskScore = result['riskScore'] is int
            ? result['riskScore']
            : int.tryParse(result['riskScore']?.toString() ?? '0') ?? 0;
        recommendations = result['recommendations'] ?? <String>[];
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("💚 Logged: ${_selectedActivities.join(', ')} | Mood: $_moodAfterWorkout"),
      ));

      if (riskScore > 85) _showStressDialog();
    } catch (e) {
      print("❌ Nova fetch failed: $e");
      setState(() {
        agentReply = 'Nova insights unavailable. Please try again later.';
        emotion = 'unknown';
        riskScore = 0;
        recommendations = [];
      });
    }

    setState(() {
      _selectedActivities.clear();
      _moodAfterWorkout = '';
      _isSubmitting = false;
    });
  }

  void _showStressDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('⚠️ Elevated Stress Detected'),
        content: const Text(
          'Your emotional response shows elevated stress.\nWant to check in with a wellness coach?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add support resource link
            },
            child: const Text('Get Support'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _selectedActivities.isNotEmpty && _moodAfterWorkout.isNotEmpty;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise Tracker"),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Today's Activities 🏋️‍♂️",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _activities.map((activity) {
                final selected = _selectedActivities.contains(activity);
                return ChoiceChip(
                  label: Text(activity),
                  selected: selected,
                  onSelected: (_) => _logActivity(activity),
                  selectedColor: Colors.green.shade200,
                  backgroundColor: Colors.grey.shade200,
                  elevation: selected ? 4 : 0,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text("How do you feel after exercising? 😌",
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            TextField(
              maxLines: null,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              onChanged: (value) => setState(() => _moodAfterWorkout = value),
              decoration: const InputDecoration(
                hintText: "e.g. Relaxed, Energized, Clear-headed",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isReady && !_isSubmitting ? _submitMoodLog : null,
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              label: const Text("Log Today’s Workout", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: isReady ? Colors.green.shade700 : Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),
            if (agentReply.isNotEmpty)
              Card(
                color: Colors.teal.shade50,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🧠 Nova Wellness Insight',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Emotion: $emotion'),
                      const SizedBox(height: 4),
                      Text(agentReply),
                      const SizedBox(height: 4),
                      Text('Risk Score: $riskScore'),
                      if (recommendations.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Recovery Suggestions:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...recommendations.map((s) => Text('• $s')),
                      ]
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text("“Movement is medicine — track your power.” 💚",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
