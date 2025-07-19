import 'package:flutter/material.dart';
import 'mood_tracker_screen.dart';
import 'journal_screen.dart';
// Later: import 'emotion_agent_screen.dart';
// Later: import 'academic_support_screen.dart';
// Later: import 'timed_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _navigate(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindGuardian'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'What do you want to nurture today?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildSectionCard(
              context,
              icon: Icons.self_improvement,
              title: 'Emotional Assistance',
              subtitle: 'Track moods, journal thoughts, talk to AI',
              screen: const MoodTrackerScreen(), // Later: use EmotionAgentScreen
            ),
            _buildSectionCard(
              context,
              icon: Icons.fitness_center,
              title: 'Personal Management',
              subtitle: 'Timetable, meals, exercise log',
              screen: const Scaffold(
                body: Center(child: Text('Coming soon...')),
              ),
            ),
            _buildSectionCard(
              context,
              icon: Icons.school,
              title: 'Educational Support',
              subtitle: 'Avoid stress, fight procrastination, study better',
              screen: const Scaffold(
                body: Center(child: Text('Coming soon...')),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _navigate(context, const JournalScreen()),
              icon: const Icon(Icons.book),
              label: const Text('View Mood Journal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Widget screen,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => _navigate(context, screen),
      ),
    );
  }
}
