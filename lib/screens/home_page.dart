import 'package:flutter/material.dart';
import '../services/analyzer_service.dart';

class UXMapHomePage extends StatefulWidget {
  const UXMapHomePage({super.key});

  @override
  State<UXMapHomePage> createState() => _UXMapHomePageState();
}

class _UXMapHomePageState extends State<UXMapHomePage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _analyzeWebsite() async {
    setState(() => _isLoading = true);

    final url = _urlController.text.trim();
    try {
      final result = await AnalyzerService.analyze(url);

      if (!mounted) return; // <--- Add this check!

      Navigator.pushNamed(context, '/result', arguments: result);
    } catch (e) {
      // Handle error, optionally show dialog
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
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
