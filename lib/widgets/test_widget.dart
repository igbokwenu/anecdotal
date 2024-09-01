import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:flutter/material.dart';

class GeminiResponseScreen extends StatelessWidget {
  final Map<String, dynamic> response;

  const GeminiResponseScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gemini AI Response"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Summary", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(response['summary']),
            const SizedBox(height: 16),
            Text("Insights", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...List<Widget>.from(response['insights'].map((insight) => Text("• $insight"))),
            const SizedBox(height: 16),
            Text("Recommendations", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...List<Widget>.from(response['recommendations'].map((recommendation) => Text("• $recommendation"))),
            const SizedBox(height: 16),
            Text("Suggestions", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...List<Widget>.from(response['suggestions'].map((suggestion) => Text("• $suggestion"))),
          ],
        ),
      ),
    );
  }
}


class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Service Example')),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              FutureBuilder<String?>(
                future: GeminiService.sendTextPromptWithoutJson(
                    message:
                        "Can you analyze images and tell when an image has water damage that can lead to growth of mold and other toxins that can be a health hazard"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text('Response: ${snapshot.data}');
                  } else {
                    return const Text('No response received.');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
