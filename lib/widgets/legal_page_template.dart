import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  final String title;
  final String content;

  const LegalPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  content,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    child: const Text('Back to Home'),
                    onPressed: () => Navigator.pushNamed(context, '/'),
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