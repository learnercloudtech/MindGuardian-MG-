import 'package:flutter/material.dart';
import '../services/nova_service.dart';

class StudyBuddyAIScreen extends StatefulWidget {
  const StudyBuddyAIScreen({super.key});

  @override
  State<StudyBuddyAIScreen> createState() => _StudyBuddyAIScreenState();
}

class _StudyBuddyAIScreenState extends State<StudyBuddyAIScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _response = "";
  bool _isLoading = false;
  String _selectedSubject = "Biology";

  final List<String> _subjects = [
    "Biology",
    "Physics",
    "Math",
    "History",
    "Chemistry",
  ];

  Future<void> _getAgentExplanation() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = "";
    });

    final composedPrompt = "Subject: $_selectedSubject\nTopic: $prompt";

    try {
      final result = await NovaService().invokeNovaResponder(
        prompt: composedPrompt,
        userId: 'rocket001',
        sessionId: 'study-buddy-ai',
      );

      setState(() {
        _response = result['text'] ?? "🤖 Nova didn’t return a reply this time.";
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Nova fetch error: $e");
      setState(() {
        _response = "Agent is unavailable. Please try again later.";
        _isLoading = false;
      });
    }
  }

  void _saveToJournal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved to Study Journal ✏️")),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Buddy AI"),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select Subject 🧠", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _selectedSubject,
                  items: _subjects.map((subject) => DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedSubject = val ?? "Biology"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _promptController,
                  decoration: const InputDecoration(
                    labelText: "Ask a question or topic",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _getAgentExplanation(),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _getAgentExplanation,
                  icon: const Icon(Icons.lightbulb, color: Colors.white),
                  label: const Text("Get Explanation", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade600,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _response.isEmpty
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                child: Card(
                  color: Colors.blue.shade50,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_response, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: _saveToJournal,
                          icon: const Icon(Icons.bookmark_add_outlined),
                          label: const Text("Save to Study Journal"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
