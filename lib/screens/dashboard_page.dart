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
   if (currentUrl == null) {
    return HomePage(onWebsiteSubmitted: _onWebsiteSubmitted);
    }

  Widget mainContent;
  if (selectedIndex == 0) {
    mainContent = JourneyMapPage(websiteUrl: currentUrl!);
  } else if (selectedIndex == 1) {
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
