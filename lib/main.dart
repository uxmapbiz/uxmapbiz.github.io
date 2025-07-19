import 'package:flutter/material.dart';
import 'screens/dashboard_page.dart';

void main() {
  runApp(const UXMapApp());
}

class UXMapApp extends StatelessWidget {
  const UXMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UX Map AI',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const DashboardPage(),
    );
  }
}
