import 'package:flutter/material.dart';
import '../widgets/side_nav.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Expect a Map (from backend API JSON)
    final result = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    Widget content;
    switch (_selectedIndex) {
      case 0:
        content = const Text(
          'User Map Journey (to be designed)',
          style: TextStyle(fontSize: 20),
        );
        break;
      case 1:
        // Only show summary, NOT elements
        final summary = result?['summary'] ?? '';
        content = Text(
          summary.isNotEmpty
              ? summary
              : 'No UX analysis result to display.',
          style: const TextStyle(fontSize: 16),
        );
        break;
      default:
        content = const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Result')),
      body: Row(
        children: [
          SideNav(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              if (index != 2) {
                setState(() => _selectedIndex = index);
              }
              // index 2 is handled in SideNav to go home
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
