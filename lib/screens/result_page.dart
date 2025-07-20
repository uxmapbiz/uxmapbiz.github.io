import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultPage extends StatelessWidget {
  final String websiteUrl;
  final Map<String, dynamic>? aiAnalysis; // <-- now required

  const ResultPage({
    required this.websiteUrl,
    required this.aiAnalysis,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String copyText = '';

    Widget content;
    if (aiAnalysis == null) {
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
          Text(
            websiteUrl,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 16),
          ),
          if (uxScore != null) ...[
            const SizedBox(height: 10),
            Text(
              'UX Score: $uxScore/100',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
          if (summary.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(summary, style: const TextStyle(fontSize: 17)),
          ],
          if (reason.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Reason: $reason',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ],
          if (improvements.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text(
              'Improvement Suggestions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(improvements, style: const TextStyle(fontSize: 16)),
          ],
          const SizedBox(height: 28),
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
