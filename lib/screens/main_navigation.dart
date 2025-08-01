import 'package:flutter/material.dart';

// Import your screens
import 'mood_tracker_screen.dart';
import 'emotion_agent_screen.dart';
import 'diet_mentalfood_screen.dart';
import 'exercise_tracker_screen.dart';
import 'academic_support_screen.dart';
import 'study_buddy_ai_screen.dart';
import 'crisis_alert_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    "Mood",
    "Agent",
    "Diet",
    "Exercise",
    "Study",
    "Buddy",
    "Crisis",
  ];

  static final List<Widget> _screens = [
    const MoodTrackerScreen(),
    const EmotionAgentScreen(),
    const DietMentalFoodScreen(),
    const ExerciseTrackerScreen(),
    const AcademicSupportScreen(),
    const StudyBuddyAIScreen(),
    const CrisisAlertScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MindGuardian • ${_titles[_selectedIndex]}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: "Mood"),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: "Agent"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Diet"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Exercise"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Study"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Buddy"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Crisis"),
        ],
      ),
    );
  }
}
