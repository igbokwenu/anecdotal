import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:flutter/material.dart';

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
                future: GeminiService.sendTextPrompt(
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
