import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MicrophoneIconWidget extends StatefulWidget {
  final double size;
  final Function()? onTap;

  const MicrophoneIconWidget({
    super.key,
    this.size = 24.0,
    this.onTap,
  });

  @override
  MicrophoneIconWidgetState createState() => MicrophoneIconWidgetState();
}

class MicrophoneIconWidgetState extends State<MicrophoneIconWidget> {
  bool _isListening = false;

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleListening,
      child: SizedBox(
        width: widget.size * 2,
        height: widget.size * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isListening)
              SpinKitRipple(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                size: widget.size * 2,
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
                  size: widget.size,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
