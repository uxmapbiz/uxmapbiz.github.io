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
      color: const Color.fromARGB(255, 3, 255, 99),
      child: NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.map),
            label: Text('User Map Journey'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.analytics),
            label: Text('UX Score & Results'),
          ),
        ],
      ),
    ); 
  }     
}  
