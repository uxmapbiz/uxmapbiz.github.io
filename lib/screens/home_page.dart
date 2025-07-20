import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Future<void> Function(String url) onWebsiteSubmitted;
  const HomePage({required this.onWebsiteSubmitted, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    setState(() { _isLoading = true; });
    await widget.onWebsiteSubmitted(url);
    setState(() { _isLoading = false; });
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
                  onSubmitted: (_) => _submit(),
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: 160,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _submit,
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
