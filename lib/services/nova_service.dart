import 'dart:convert';
import 'package:http/http.dart' as http;

class NovaService {
  static const String _endpoint =
      'https://ahmmzng3d8.execute-api.ap-southeast-2.amazonaws.com/NovaResponder';

  Future<Map<String, dynamic>> invokeNovaResponder({
    required String prompt,
    required String userId,
    required String sessionId,
    bool wrapPrompt = true,
  }) async {
    try {
      final formattedPrompt = wrapPrompt
          ? "User message:\n$prompt\nProvide empathetic support, detect emotional risk, and suggest actions."
          : prompt;

      final payload = {
        'prompt': formattedPrompt,
        'user_id': userId,
        'session_id': sessionId,
      };

      print("📦 Sending payload to Nova:");
      print(jsonEncode(payload));

      final response = await http.post(
        Uri.parse(_endpoint),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        print("🧠 Nova raw response: $json");

        // ✅ Updated to match actual key in Nova response
        final reply = json['conversational_reply'] ?? "...";
        final emotion = json['emotion'] ?? json['sentiment'] ?? "unknown";
        final riskScore = json['riskScore'] ?? json['risk_score'] ?? 0;

        final recommendations = (json['recommendations'] is List)
            ? List<String>.from(json['recommendations'])
            : <String>[];

        return {
          'role': 'agent',
          'text': reply,
          'emotion': emotion,
          'riskScore': riskScore,
          'recommendations': recommendations,
        };
      } else {
        print('❌ Nova response failed: ${response.statusCode}');
        print('📨 Server error body: ${response.body}');
        return _fallbackReply();
      }
    } catch (e) {
      print('NovaService error: $e');
      return _fallbackReply();
    }
  }

  Map<String, dynamic> _fallbackReply() {
    return {
      'role': 'agent',
      'text': "I'm here for you, even if I don't have the perfect words yet.",
      'emotion': "unknown",
      'riskScore': 0,
      'recommendations': [],
    };
  }
}
