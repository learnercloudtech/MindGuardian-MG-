import 'dart:convert';
import 'package:http/http.dart' as http;

class GraniteClient {
  final String endpoint = 'http://localhost:11434/api/generate';

  Future<String> queryAgent(String prompt) async {
    try {
      print("🌀 Granite query: $prompt");

      final response = await http
          .post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': 'granite3.1-dense:2b',
          'prompt': prompt,
        }),
      )
          .timeout(const Duration(seconds: 10));

      print("📡 Granite status: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("📩 Granite body: ${response.body}");

        try {
          final data = jsonDecode(response.body);
          final reply = data['response'] ?? 'No response';
          print("🧠 Parsed reply: $reply");
          return reply;
        } catch (e) {
          print("❌ JSON decode failed: $e");
          return 'Agent responded, but response was unreadable.';
        }
      } else {
        print("⚠️ Granite returned error status: ${response.statusCode}");
        return 'Agent failed to respond properly.';
      }
    } catch (e) {
      print("❌ Granite connection error: $e");
      return 'Granite agent is unreachable. Try again later.';
    }
  }
}
