import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';


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
      child: _isListening
          ? Pulse(
              infinite: true,
              duration: const Duration(milliseconds: 2000),
              child: Icon(
                Icons.mic,
                color: Theme.of(context).colorScheme.secondary,
                size: widget.size,
              ),
            )
          : Icon(
              Icons.mic_none,
              color: Theme.of(context).iconTheme.color,
              size: widget.size,
            ),
    );
  }
}
