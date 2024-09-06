import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/widgets/voice_recorder_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isRecording = false;
  String? _audioFilePath;
  Map<String, dynamic>? _extractedInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Anecdotal')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Anecdotal! To help us provide the best care for you, could you please tell us a bit about yourself and any health concerns you\'re currently experiencing? Feel free to include your name, where you\'re from, and any symptoms you\'ve been noticing. Don\'t worry if you\'re not sure about medical terms – just describe how you\'re feeling in your own words.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20),
            Center(
              child: Recorder(
                onStart: _startRecording,
                onStop: _stopRecording,
              ),
            ),
            SizedBox(height: 20),
            if (_extractedInfo != null) ...[
              Text('Extracted Information:',
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              _buildInfoCard('Name',
                  '${_extractedInfo!['firstName']} ${_extractedInfo!['lastName']}'),
              _buildInfoCard('Gender', _extractedInfo?['gender'] ?? ''),
              _buildInfoCard('Known Symptoms',
                  _extractedInfo!['knownSymptoms']?.join(', ') ?? ''),
              _buildInfoCard('Unknown Symptoms',
                  _extractedInfo!['unknownSymptoms']?.join(', ') ?? ''),
              _buildInfoCard('Location',
                  '${_extractedInfo!['country'] ?? ''} ${_extractedInfo?['state'] ?? ''}'),
              _buildInfoCard('Recommendations',
                  _extractedInfo!['recommendations']?.join(', ') ?? ''),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(content),
          ],
        ),
      ),
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _extractedInfo = null;
    });
  }

  Future<void> _stopRecording(String audioPath) async {
    setState(() {
      _isRecording = false;
      _audioFilePath = audioPath;
    });

    // Process the audio file
    await _processAudio();
  }

  Future<void> _processAudio() async {
    if (_audioFilePath != null) {
      final result = await GeminiService.analyzeAudioForHome(
        audios: [File(_audioFilePath!)],
        prompt:
            "Analyze the provided audio and extract the following information...", // Use the prompt we created earlier
      );

      setState(() {
        _extractedInfo = result;
      });
    }
  }
}
