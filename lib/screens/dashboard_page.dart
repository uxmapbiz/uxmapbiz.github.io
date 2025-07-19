import 'package:flutter/material.dart';
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
  int selectedIndex = 0;     // 0: Journey Map, 1: Results (update if you add more)
  String? currentUrl;        // Website being analyzed

  // Callback from HomePage when a website is submitted
  void _onWebsiteSubmitted(String url) {
    setState(() {
      currentUrl = url;
      selectedIndex = 0; // Go to Journey Map after search
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;

    if (currentUrl == null) {
      // Show search page if no website has been entered
      mainContent = HomePage(onWebsiteSubmitted: _onWebsiteSubmitted);
    } else if (selectedIndex == 0) {
      // Show journey map for the selected website
      mainContent = JourneyMapPage(websiteUrl: currentUrl!);
    } else if (selectedIndex == 1) {
      // Show results for the selected website
      mainContent = ResultPage(websiteUrl: currentUrl!);
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
              });
            },
          ),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
