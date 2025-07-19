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
  const MainNavigation({Key? key}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<String> _titles = [
    "Mood",
    "Agent",
    "Diet",
    "Exercise",
    "Study",
    "Buddy",
    "Crisis",
  ];

  static final List<Widget Function()> _screenBuilders = [
        () => const MoodTrackerScreen(),
        () => const EmotionAgentScreen(),
        () => const DietMentalFoodScreen(),
        () => const ExerciseTrackerScreen(),
        () => const AcademicSupportScreen(),
        () => const StudyBuddyAIScreen(),
        () => const CrisisAlertScreen(),
  ];

  void _onTabSelected(int index) {
    print("📲 Tab selected: ${_titles[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _loadScreenSafely(int index) {
    try {
      print("🔍 Attempting to load: ${_titles[index]}");
      return _screenBuilders[index]();
    } catch (e) {
      print("❌ Error rendering screen [$index]: $e");
      return Center(
        child: Text(
          "Failed to load ${_titles[index]} screen.\nPlease check logs.",
          style: const TextStyle(fontSize: 16, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🧭 Building MainNavigation with active tab: ${_titles[_selectedIndex]}");

    return Scaffold(
      appBar: AppBar(
        title: Text("MindGuardian • ${_titles[_selectedIndex]}"),
      ),
      body: _loadScreenSafely(_selectedIndex),
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
