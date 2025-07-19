import 'package:flutter/material.dart';
import '../services/granite_service.dart';
import 'crisis_alert_screen.dart'; // 🚨 Alert route

class EmotionAgentScreen extends StatefulWidget {
  const EmotionAgentScreen({super.key});

  @override
  State<EmotionAgentScreen> createState() => _EmotionAgentScreenState();
}

class _EmotionAgentScreenState extends State<EmotionAgentScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  Future<void> _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': userText});
      _controller.clear();
      _isTyping = true;
    });

    final aiResponse = await GraniteService().getAgentResponse(userText);

    setState(() {
      _messages.add(aiResponse);
      _isTyping = false;
    });

    if ((aiResponse['riskScore'] as int? ?? 0) > 85) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CrisisAlertScreen()),
      );
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isUser = msg['role'] == 'user';
    final bubbleColor = isUser ? Colors.deepPurple.shade100 : Colors.grey.shade200;
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final emotion = msg['emotion'];

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(msg['text'], style: const TextStyle(fontSize: 15)),
            if (emotion != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Emotion: $emotion',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindGuardian AI'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, index) {
                if (_isTyping && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: const [
                          SizedBox(width: 12),
                          Text('🧠', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 6),
                          Text('MindGuardian is typing...'),
                        ],
                      ),
                    ),
                  );
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your thoughts...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: theme.colorScheme.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
