import 'dart:io';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:anecdotal/widgets/voice_recorder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';

class VoiceChatScreen extends StatefulWidget {
  @override
  _VoiceChatScreenState createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  String _responseText = '';
  bool _isLoading = false;

  Future<void> _handleAudioStop(String path) async {
    setState(() {
      _isLoading = true;
      _responseText = 'Processing audio...';
    });

    try {
      final response = await GeminiService.analyzeAudio(
        audios: [File(path)],
        prompt: "Analyze the content of this audio and provide a summary.",
      );

      if (response != null) {
        setState(() {
          _responseText = 'Summary: ${response['summary']}\n\n'
              'Insights: ${response['insights']?.join(', ')}\n\n'
              'Recommendations: ${response['recommendations']?.join(', ')}';
        });
      } else {
        setState(() {
          _responseText = 'Failed to analyze audio.';
        });
      }
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    // Clean up the audio file
    File(path).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Chat with Gemini')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(_responseText),
            ),
          ),
          const MySpinKitWaveSpinner(
            size: 50,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Recorder(
              onStop: _handleAudioStop,
              onStart: () => setState(() => _responseText = 'Recording...'),
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
        ],
      ),
    );
  }
}
