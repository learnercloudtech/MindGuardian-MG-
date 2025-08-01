import 'package:flutter/material.dart';
import 'mood_tracker_screen.dart';
import 'emotion_agent_screen.dart';
import 'diet_mentalfood_screen.dart';
import 'study_buddy_ai_screen.dart';
import 'journal_screen.dart';
import 'academic_support_screen.dart';
import 'exercise_tracker_screen.dart';
import 'clinician_contact_screen.dart';
import 'day_planner_screen.dart';
import 'timetable_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _navigate(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindGuardian'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              title: 'Mood & Emotional Support',
              subtitle: 'Track mood, talk to AI, reflect and recover',
              screen: const MoodTrackerScreen(),
            ),
            _buildSectionCard(
              context,
              icon: Icons.chat_bubble_outline,
              title: 'MindGuardian Agent',
              subtitle: 'Talk about how you feel — live agent replies',
              screen: const EmotionAgentScreen(),
            ),
            _buildSectionCard(
              context,
              icon: Icons.restaurant_menu,
              title: 'Diet & Mental Meals',
              subtitle: 'Log meals and get mood-based food advice',
              screen: const DietMentalFoodScreen(),
            ),
            _buildSectionCard(
              context,
              icon: Icons.school_outlined,
              title: 'Study Buddy AI',
              subtitle: 'Ask questions, learn deeply, save responses',
              screen: const StudyBuddyAIScreen(),
            ),
            _buildSectionCard(
              context,
              icon: Icons.menu_book,
              title: 'Academic Support',
              subtitle: 'Fight procrastination, stay productive',
              screen: const AcademicSupportScreen(),
            ),
            _buildSectionCard(
              context,
              icon: Icons.fitness_center,
              title: 'Exercise Tracker',
              subtitle: 'Log workouts, track energy flow',
              screen: const ExerciseTrackerScreen(),
            ),
            _buildSectionCard(
              context,
              icon: Icons.calendar_month,
              title: 'Day Planner',
              subtitle: 'Plan your goals and daily routine',
              screen: DayPlannerScreen(day: DateTime.now()),
            ),
            _buildSectionCard(
              context,
              icon: Icons.schedule,
              title: 'Timetable',
              subtitle: 'Manage academic or work slots',
              screen: const TimetableScreen(),
            ),
            _buildSectionCard(
              context,
              icon: Icons.local_hospital,
              title: 'Clinician Contact',
              subtitle: 'Reach out to professionals when you need help',
              screen: const ClinicianContactScreen(
                name: 'Support Team',
                phone: '+91-9876543210',
                email: 'support@mindguardian.ai',
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
