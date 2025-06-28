import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyzerService {
  static Future<Map<String, dynamic>> analyze(String url) async {
    if (url.isEmpty) {
      // You can return a map with an error message for consistency
      return {"ai_analysis": "Please enter a website URL."};
    }

    const backendApi = 'https://uxmap-backend.onrender.com/analyze';


    final response = await http.post(
      Uri.parse(backendApi),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url}),
    );

    if (response.statusCode == 200) {
      // Parse and return the JSON map
      return jsonDecode(response.body);
    } else {
      // Return error in the same structure
      return {"ai_analysis": "Error: ${response.reasonPhrase}\n${response.body}"};
    }
  }
}