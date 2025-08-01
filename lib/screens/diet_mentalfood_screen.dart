import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/mental_meal.dart';
import '../services/nova_service.dart';

class DietMentalFoodScreen extends StatefulWidget {
  const DietMentalFoodScreen({super.key});

  @override
  State<DietMentalFoodScreen> createState() => _DietMentalFoodScreenState();
}

class _DietMentalFoodScreenState extends State<DietMentalFoodScreen> {
  late Box<MentalMeal> _mealBox;
  final TextEditingController _foodController = TextEditingController();
  String _selectedMood = 'Neutral';

  String agentReply = '';
  String emotion = '';
  List<String> recommendations = [];
  bool isLoading = false;

  final List<String> _moods = ['Energized', 'Calm', 'Sluggish', 'Neutral'];

  @override
  void initState() {
    super.initState();
    _openMealBox();
  }

  Future<void> _openMealBox() async {
    _mealBox = Hive.isBoxOpen('mentalMeals')
        ? Hive.box<MentalMeal>('mentalMeals')
        : await Hive.openBox<MentalMeal>('mentalMeals');
    setState(() {});
  }

  Future<void> _addEntry() async {
    final food = _foodController.text.trim();
    if (food.isEmpty) return;

    final newMeal = MentalMeal(
      food: food,
      mood: _selectedMood,
      timestamp: DateTime.now(),
    );

    _mealBox.add(newMeal);
    _foodController.clear();
    setState(() {
      _selectedMood = 'Neutral';
      agentReply = '';
      emotion = '';
      recommendations = [];
      isLoading = true;
    });

    final prompt =
        "User ate '$food' and feels $_selectedMood after it. Suggest mood-balancing foods and emotional support.";

    try {
      final result = await NovaService().invokeNovaResponder(
        prompt: prompt,
        userId: 'rocket001',
        sessionId: 'diet-mental-food',
      );

      setState(() {
        agentReply = result['text'] ?? 'Let’s explore how food affects your mind.';
        emotion = result['emotion'] ?? 'unknown';
        recommendations = result['recommendations'] is List
            ? List<String>.from(result['recommendations'])
            : <String>[];
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged "$food" with mood "$_selectedMood" ✅')),
      );
    } catch (e) {
      print("❌ Nova fetch failed: $e");
      setState(() {
        isLoading = false;
        agentReply = 'Agent unavailable. Try again later.';
      });
    }
  }

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Meals'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Log what you ate and how it made you feel 🧠🍽️'),
            const SizedBox(height: 12),
            TextField(
              controller: _foodController,
              decoration: const InputDecoration(
                labelText: 'Food or drink',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addEntry(),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedMood,
              items: _moods
                  .map((mood) => DropdownMenuItem(
                value: mood,
                child: Text(mood),
              ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedMood = val ?? 'Neutral'),
              decoration: const InputDecoration(
                labelText: 'Mood after eating',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _addEntry,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Log Meal', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const CircularProgressIndicator()
            else if (agentReply.isNotEmpty)
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.green.shade50,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🧠 AI Suggestions', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Emotion: $emotion'),
                          const SizedBox(height: 6),
                          Text(agentReply),
                          const SizedBox(height: 8),
                          if (recommendations.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Recommended Foods:',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                ...recommendations.map((f) => Text('• $f'))
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 8),
            Expanded(
              flex: 3,
              child: _mealBox.isEmpty
                  ? const Center(child: Text('No meals logged yet.'))
                  : ListView.builder(
                itemCount: _mealBox.length,
                itemBuilder: (_, index) {
                  final meal = _mealBox.getAt(index);
                  if (meal == null) return const SizedBox.shrink();
                  final time =
                      '${meal.timestamp.hour}:${meal.timestamp.minute.toString().padLeft(2, '0')}';
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(meal.food),
                      subtitle: Text('Mood: ${meal.mood}'),
                      trailing: Text(time, style: const TextStyle(fontSize: 12)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
