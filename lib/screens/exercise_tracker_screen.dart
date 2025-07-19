import 'package:flutter/material.dart';

class ExerciseTrackerScreen extends StatefulWidget {
  const ExerciseTrackerScreen({Key? key}) : super(key: key);

  @override
  _ExerciseTrackerScreenState createState() => _ExerciseTrackerScreenState();
}

class _ExerciseTrackerScreenState extends State<ExerciseTrackerScreen> {
  final List<String> _activities = ["🏃 Run", "🧘 Yoga", "🚴 Cycle", "💪 Weights", "🕺 Dance"];
  final Set<String> _selectedActivities = {};
  String _moodAfterWorkout = "";

  void _logActivity(String activity) {
    setState(() {
      if (_selectedActivities.contains(activity)) {
        _selectedActivities.remove(activity);
      } else {
        _selectedActivities.add(activity);
      }
    });
  }

  void _submitMoodLog() {
    if (_selectedActivities.isNotEmpty && _moodAfterWorkout.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("💚 Logged: ${_selectedActivities.join(', ')} | Mood: $_moodAfterWorkout"),
      ));
      setState(() {
        _selectedActivities.clear();
        _moodAfterWorkout = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exercise Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Select Today's Activities 🏋️‍♂️",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: _activities.map((activity) {
                final selected = _selectedActivities.contains(activity);
                return ChoiceChip(
                  label: Text(activity),
                  selected: selected,
                  onSelected: (_) => _logActivity(activity),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              "How do you feel after exercising? 😌",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              onChanged: (value) => _moodAfterWorkout = value,
              decoration: const InputDecoration(
                hintText: "e.g. Relaxed, Energetic, Clear-headed",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitMoodLog,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("Log Today’s Workout"),
            ),
            const Spacer(),
            const Text(
              "“Movement is medicine — track your power.” 💚",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
