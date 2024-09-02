import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Recorder extends StatefulWidget {
  final Function(String path) onStop;
  final VoidCallback? onStart;

  const Recorder({
    Key? key,
    required this.onStop,
    this.onStart,
  }) : super(key: key);

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  late final AudioRecorder _audioRecorder;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<RecordState>? _recordSub;
  String? _currentRecordingPath;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _stop();
    } else {
      await _start();
    }
    setState(() {
      _isListening = !_isListening;
    });
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav';
        _currentRecordingPath = path.join(directory.path, fileName);

        widget.onStart?.call();
        await _audioRecorder.start(
          RecordConfig(encoder: AudioEncoder.wav),
          path: _currentRecordingPath!,
        );
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();
    if (path != null) {
      widget.onStop(path);
      _currentRecordingPath = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleListening,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isListening)
              SpinKitRipple(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                size: 60,
              ),
            Center(
              child: Pulse(
                infinite: _isListening,
                duration: const Duration(milliseconds: 2000),
                child: Icon(
                  _isListening ? Icons.stop_circle_rounded : Icons.mic_none,
                  color: _isListening
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).iconTheme.color,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recordSub?.cancel();
    _audioRecorder.dispose();
    if (_currentRecordingPath != null) {
      File(_currentRecordingPath!).delete().catchError((error) {
        print('Error deleting audio file: $error');
      });
    }
    super.dispose();
  }
}
