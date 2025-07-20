import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/side_nav.dart';
import 'home_page.dart';
import 'journey_map_page.dart';
import 'result_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0; // 0: Journey Map, 1: Results
  String? currentUrl;

  List<dynamic>? clickableElements; // <-- new
  dynamic aiAnalysis; // <-- new
  bool loading = false;
  String? errorMessage;

  // Callback from HomePage when a website is submitted
  Future<void> _onWebsiteSubmitted(String url) async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://uxmap-backend.onrender.com/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          currentUrl = url;
          clickableElements = data['clickable_elements'];
          aiAnalysis = data['ai_analysis'];
          selectedIndex = 0; // Show journey map first
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to analyze website';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        loading = false;
      });
    }
  }

@override
Widget build(BuildContext context) {
  if (currentUrl == null) {
    return HomePage(onWebsiteSubmitted: _onWebsiteSubmitted);
  }

  Widget mainContent;
  if (selectedIndex == 2 || currentUrl == null) {
    // HomePage: always show this if "Home" icon selected or no current URL
    mainContent = HomePage(onWebsiteSubmitted: _onWebsiteSubmitted);
  } else if (selectedIndex == 0) {
    mainContent = JourneyMapPage(
      websiteUrl: currentUrl!,
      clickableElements: clickableElements ?? [],
    );
  } else if (selectedIndex == 1) {
    mainContent = ResultPage(
      websiteUrl: currentUrl!,
      aiAnalysis: aiAnalysis,
    );
  } else {
    mainContent = const Center(child: Text('Unknown page'));
  }

    return Scaffold(
      body: Row(
        children: [
          SideNav(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int idx) {
              setState(() {
                selectedIndex = idx;
                if (idx == 2) {
                // Home button pressed: clear everything for new search
                currentUrl = null;
                clickableElements = null;
                aiAnalysis = null;
                errorMessage = null;
                loading = false;
                }
              });
            },
          ),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
