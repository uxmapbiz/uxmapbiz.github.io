import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyzerService {
  static Future<String> analyze(String url) async {
    if (url.isEmpty) return "Please enter a website URL.";

    const backendApi = 'https://uxmap-backend.onrender.com/analyze';


    try {
      final response = await http.post(
        Uri.parse(backendApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      if (response.statusCode != 200) {
        return "Analysis failed: ${response.body}";
      }

      final data = jsonDecode(response.body);
      final elements = data['clickable_elements'] ?? [];
      final aiAnalysis = data['ai_analysis'] ?? '';

      // You can format this however you want!
      String elementList = elements.isEmpty
          ? "No clickable elements found."
          : elements.map((e) => e.toString()).join('\n');

      return "Clickable Elements:\n$elementList\n\nAI Analysis:\n$aiAnalysis";
    } catch (e) {
      return "Error: $e";
    }
  }
}
