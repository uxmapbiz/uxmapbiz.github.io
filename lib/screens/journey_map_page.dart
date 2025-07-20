import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JourneyMapPage extends StatelessWidget {
  final List<dynamic> clickableElements;
  final String websiteUrl;

  const JourneyMapPage({
    required this.clickableElements,
    required this.websiteUrl,
    super.key,
  });

  // Helper for launching URLs
  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Separate promoted and other links
    final promoted = clickableElements.where((e) => e['promoted'] == true).toList();
    final others = clickableElements.where((e) => e['promoted'] != true).toList();

    // Optional: Sort by DOM index (already in backend)
    promoted.sort((a, b) => (a['position']['index'] as int).compareTo(b['position']['index'] as int));
    others.sort((a, b) => (a['position']['index'] as int).compareTo(b['position']['index'] as int));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Map'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            Text(
              websiteUrl,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (promoted.isNotEmpty) ...[
              const Text(
                'Main Navigation',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueAccent),
              ),
              const SizedBox(height: 8),
              ...promoted.map((item) => ListTile(
                    leading: const Icon(Icons.star, color: Colors.orange),
                    title: Text(item['text'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    subtitle: item['href'] != null ? Text(item['href']) : null,
                    trailing: Text(item['type']),
                    onTap: () => _launchUrl(item['href']),
                  )),
              const Divider(),
            ],
            if (others.isNotEmpty) ...[
              const Text(
                'Other Clickable Elements',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              ...others.map((item) => ListTile(
                    title: Text(item['text']),
                    subtitle: item['href'] != null ? Text(item['href'], style: const TextStyle(color: Colors.blue)) : null,
                    trailing: Text(item['type']),
                    onTap: () => _launchUrl(item['href']),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
