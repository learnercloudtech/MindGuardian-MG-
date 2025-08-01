import 'package:flutter/material.dart';
import '../services/nova_service.dart';
import 'clinician_contact_screen.dart';

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

    try {
      final response = await NovaService().invokeNovaResponder(
        prompt: userText,
        userId: 'rocket001',
        sessionId: 'emotion-agent-screen',
        wrapPrompt: true,
      );

      final agentReply = {
        'role': 'agent',
        'text': response['text'],
        'emotion': response['emotion'],
        'riskScore': response['riskScore'],
        'recommendations': response['recommendations'],
      };

      setState(() {
        _messages.add(agentReply);
        _isTyping = false;
      });

      final riskScore = agentReply['riskScore'] as int? ?? 0;
      if (riskScore >= 4) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClinicianContactScreen()),
          );
        });
      }
    } catch (e) {
      print("❌ Nova fetch failed: $e");
      setState(() {
        _messages.add({
          'role': 'agent',
          'text': 'MindGuardian is unavailable. Please try again later.',
          'emotion': 'unknown',
          'riskScore': 0,
          'recommendations': [],
        });
        _isTyping = false;
      });
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isUser = msg['role'] == 'user';
    final bubbleColor = isUser ? Colors.deepPurple[100] : Colors.grey[200];
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;

    final emotion = msg['emotion'] ?? 'unknown';
    final riskScore = msg['riskScore']?.toString() ?? '0';
    final recommendations = msg['recommendations'] as List<dynamic>? ?? [];

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
            Text(msg['text'] ?? '', style: const TextStyle(fontSize: 15)),
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Emotion: $emotion | Risk Score: $riskScore',
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            if (recommendations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Suggestions:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    ...recommendations.map((s) => Text('• $s',
                        style: const TextStyle(fontSize: 12))),
                  ],
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
