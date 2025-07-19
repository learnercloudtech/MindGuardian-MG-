import 'dart:convert';
import 'package:http/http.dart' as http;

class GraniteService {
  // You can override this via --dart-define=GRANITE_URL
  final String _endpoint = const String.fromEnvironment(
    'GRANITE_URL',
    defaultValue: 'https://ab15280f6831.ngrok-free.app/granite',
  );

  Future<Map<String, dynamic>> getAgentResponse(String userInput) async {
    print("🌀 Sending prompt to Granite: $userInput");

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': userInput}),
      ).timeout(const Duration(seconds: 12));

      print("📡 Granite status: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("📩 Granite raw response: ${response.body}");

        final Map<String, dynamic> data = jsonDecode(response.body);

        final agentText = data['agentReply'];
        final emotionValue = data['emotion'];
        final score = data['riskScore'];
        final rawRecommendations = data['recommendations'];

        print("🧠 Parsed: reply='$agentText', emotion='$emotionValue', score=$score");

        return {
          'role': 'agent',
          'text': agentText is String && agentText.isNotEmpty
              ? agentText
              : 'Thanks for sharing. How are you feeling now?',
          'emotion': emotionValue is String && emotionValue.isNotEmpty
              ? emotionValue
              : 'unknown',
          'riskScore': score is int ? score : 0,
          'recommendations': rawRecommendations is List
              ? List<String>.from(rawRecommendations)
              : <String>[],
        };
      } else {
        print("⚠️ Granite returned non-200 status: ${response.statusCode}");
        return _errorFallback();
      }
    } catch (e) {
      print("❌ Granite fetch failed: $e");
      return _errorFallback();
    }
  }

  Map<String, dynamic> _errorFallback() {
    return {
      'role': 'agent',
      'text': 'Hmm, something went wrong. Can you try again?',
      'emotion': 'unknown',
      'riskScore': 0,
      'recommendations': [],
    };
  }
}
