import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MenuNode {
  final String title;
  final String url;
  List<MenuNode>? children;

  MenuNode({required this.title, required this.url, this.children});
}

class JourneyMapPage extends StatefulWidget {
  final String websiteUrl;
  const JourneyMapPage({required this.websiteUrl, super.key});

  @override
  State<JourneyMapPage> createState() => _JourneyMapPageState();
}

class _JourneyMapPageState extends State<JourneyMapPage> {
  MenuNode? rootNode;

  Future<List<MenuNode>> fetchMenus(String url) async {
    final response = await http.post(
      Uri.parse('https://your-backend-url/crawl_menus'), // <-- Set your backend URL here
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final menus = data['menus'] as List;
      return menus
          .map((item) => MenuNode(title: item['title'], url: item['url']))
          .toList();
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<void> _loadRootMenus(String url) async {
    final children = await fetchMenus(url);
    setState(() {
      rootNode = MenuNode(title: url, url: url, children: children);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRootMenus(widget.websiteUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journey Map')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: rootNode == null
            ? const Center(child: CircularProgressIndicator())
            : MenuTree(node: rootNode!),
              ),
      );
  }
}

class MenuTree extends StatelessWidget {
  final MenuNode node;

  const MenuTree({required this.node, super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {
    // Show title as heading, then list children as clickable tiles
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          node.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (node.children == null || node.children!.isEmpty)
          const Text('No menus found.')
        else
          ...node.children!.map(
            (child) => ListTile(
              title: Text(child.title),
              subtitle: Text(child.url, style: const TextStyle(color: Colors.blue)),
              onTap: () => _launchUrl(child.url),
            ),
          ),
      ],
    );
  }
}
