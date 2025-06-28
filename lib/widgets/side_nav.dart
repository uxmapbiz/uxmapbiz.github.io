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
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        onDestinationSelected(index);
        if (index == 2) {
          // Go home if "Go Home" is selected
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      },
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
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Go Home'),
        ),
      ],
    );
  }
}
