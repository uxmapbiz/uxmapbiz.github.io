import 'package:flutter/material.dart';
import '../services/analyzer_service.dart';

class UXMapHomePage extends StatefulWidget {
  const UXMapHomePage({super.key});

  @override
  State<UXMapHomePage> createState() => _UXMapHomePageState();
}

class _UXMapHomePageState extends State<UXMapHomePage> {
  final TextEditingController _urlController = TextEditingController();
  

  Future<void> _analyzeWebsite() async {
    final url = _urlController.text.trim();
    final result = await AnalyzerService.analyze(url);

  if (!mounted) return; 
  
  // Navigate to ResultPage and pass the result
  Navigator.pushNamed(
    context,
    '/result',
    arguments: result, // You can also pass a Map if you have more complex data
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'UX Map AI',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: 'Enter a website URL',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 20.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 160,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _analyzeWebsite,
                    child: const Text('Analyze'),
                  ),
                ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
