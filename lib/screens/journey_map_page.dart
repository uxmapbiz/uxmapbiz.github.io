import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/download_helper.dart'; // Use your helpers folder

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
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort by 'rank' if available
    final sorted = [...clickableElements];
    sorted.sort((a, b) => (a['rank'] as int).compareTo(b['rank'] as int));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Map'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download Excel',
            onPressed: () => downloadExcel(context, websiteUrl),
          ),
        ],
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
            if (sorted.isEmpty)
              const Text('No clickable elements found.'),
            ...sorted.map(
              (item) => ListTile(
                leading: Text(
                  '${item['rank']}.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                title: Text(item['text']),
                subtitle: item['href'] != null
                    ? Text(
                        item['href'],
                        style: const TextStyle(color: Colors.blue),
                      )
                    : null,
                trailing: Text(item['type']),
                onTap: () => _launchUrl(item['href']),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download as Excel'),
                onPressed: () => downloadExcel(context, websiteUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
