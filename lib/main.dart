import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/result_page.dart'; // <-- Needed for the routes table

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
      initialRoute: '/',
      routes: {
        '/': (context) => const UXMapHomePage(),
        '/result': (context) => const ResultPage(),
      },
    );
  }
}
