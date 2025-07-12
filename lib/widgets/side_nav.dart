import 'package:flutter/material.dart';

class SideNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const SideNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.green[100], // Light green background
      child: NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.selected,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.map),
            label: Text('User Map Journey'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.analytics),
            label: Text('UX Score & Results'),
          ),
          // Home button removed!
        ],
      ),
    ); // <--- closes Container
  }     // <--- closes build method
}       // <--- closes SideNav class
