import 'package:flutter/material.dart';

class StudyBuddyAIScreen extends StatefulWidget {
  const StudyBuddyAIScreen({Key? key}) : super(key: key);

  @override
  _StudyBuddyAIScreenState createState() => _StudyBuddyAIScreenState();
}

class _StudyBuddyAIScreenState extends State<StudyBuddyAIScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _response = "";
  String _selectedSubject = "Biology";

  final List<String> _subjects = [
    "Biology",
    "Physics",
    "Math",
    "History",
    "Chemistry"
  ];

  void _mockAgentReply() {
    final prompt = _promptController.text.trim().toLowerCase();


    String agentText = "🤖 Granite agent is thinking...";
    switch (_selectedSubject) {
      case "Biology":
        agentText =
        "🔬 Agent Reply:\nPhotosynthesis is the process by which green plants convert sunlight into energy. 🌱";
        break;
      case "Physics":
        agentText =
        "⚛️ Agent Reply:\nNewton’s First Law states that an object at rest stays at rest unless acted upon by an external force. 🚀";
        break;
      case "Math":
        agentText =
        "🧮 Agent Reply:\nThe quadratic formula helps solve equations of the form ax² + bx + c = 0. It’s given by: x = (-b ± √(b²-4ac)) / 2a 📐";
        break;
      case "History":
        agentText =
        "📜 Agent Reply:\nThe French Revolution began in 1789 and marked a shift toward democratic ideals and away from monarchy. ⚔️";
        break;
      case "Chemistry":
        agentText =
        "🧪 Agent Reply:\nAn acid has a pH less than 7 and can donate a proton (H⁺). Bases have a pH above 7 and accept protons. 🔥";
        break;
      default:
        agentText =
        "🤔 Agent Reply:\nHmm, I’m still training on this topic. Can you try rephrasing or selecting a supported subject?";
    }

    setState(() {
      _response = agentText;
    });
  }

  void _saveToJournal() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Saved to Study Journal ✏️"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Study Buddy AI")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Select Subject 🧠",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedSubject,
              items: _subjects
                  .map((subject) => DropdownMenuItem(
                value: subject,
                child: Text(subject),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSubject = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: "Ask a question or topic",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _mockAgentReply,
              child: const Text("Get Explanation"),
            ),
            const SizedBox(height: 16),
            if (_response.isNotEmpty)
              Card(
                color: Colors.blue.shade50,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _response,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            if (_response.isNotEmpty)
              TextButton.icon(
                onPressed: _saveToJournal,
                icon: const Icon(Icons.bookmark_add_outlined),
                label: const Text("Save to Study Journal"),
              ),
          ],
        ),
      ),
    );
  }
}
