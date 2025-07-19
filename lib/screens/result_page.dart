import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class ResultPage extends StatefulWidget {
  final String websiteUrl;
  const ResultPage({required this.websiteUrl, super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Map<String, dynamic>? aiAnalysis;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAnalysis();
  }

  Future<void> _fetchAnalysis() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
        final response = await http.post(
        Uri.parse('https://https://uxmap-backend.onrender.com/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': widget.websiteUrl}),
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          aiAnalysis = result['ai_analysis'] as Map<String, dynamic>?;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch analysis (${response.statusCode})';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    String copyText = '';

    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      content = Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    } else if (aiAnalysis == null) {
      content = const Center(child: Text('No analysis found.'));
    } else {
      final summary = aiAnalysis!['summary'] ?? '';
      final uxScore = aiAnalysis!['ux_score'];
      final reason = aiAnalysis!['reason'] ?? '';
      final improvements = aiAnalysis!['improvements'] ?? '';

      copyText = [
        if (uxScore != null) 'UX Score: $uxScore/100',
        if (summary.isNotEmpty) 'Summary: $summary',
        if (reason.isNotEmpty) 'Reason: $reason',
        if (improvements.isNotEmpty) 'Improvement Suggestions: $improvements',
      ].join('\n\n');

      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (uxScore != null)
            Text(
              'UX Score: $uxScore/100',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (summary.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(summary, style: const TextStyle(fontSize: 16)),
          ],
          if (reason.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Reason: $reason',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (improvements.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Improvement Suggestions:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(improvements, style: const TextStyle(fontSize: 16)),
          ],
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copy to Clipboard'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: copyText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard!')),
              );
            },
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(child: content),
      ),
    );
  }
}
