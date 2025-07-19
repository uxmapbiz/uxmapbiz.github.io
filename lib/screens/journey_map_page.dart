import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
            : MenuTree(
                node: rootNode!,
                onExpand: (MenuNode node) async {
                  if (node.children == null) {
                    final children = await fetchMenus(node.url);
                    setState(() {
                      node.children = children;
                    });
                  }
                },
              ),
      ),
    );
  }
}

class MenuTree extends StatelessWidget {
  final MenuNode node;
  final Future<void> Function(MenuNode node) onExpand;

  const MenuTree({required this.node, required this.onExpand, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(node.title),
      children: node.children == null
          ? [
              ListTile(
                title: const Text('Load submenus...'),
                onTap: () => onExpand(node),
              )
            ]
          : node.children!
              .map((child) => MenuTree(node: child, onExpand: onExpand))
              .toList(),
    );
  }
}
