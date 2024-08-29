import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ResizableMicIcon extends StatefulWidget {
  final double size;
  final Color iconColor;

  const ResizableMicIcon({
    super.key,
    this.size = 24.0,
    this.iconColor = Colors.black,
  });

  @override
  _ResizableMicIconState createState() => _ResizableMicIconState();
}

class _ResizableMicIconState extends State<ResizableMicIcon> {
  bool _isListening = false;

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleListening,
      child: _isListening
          ? Pulse(
              infinite: true,
              child: Icon(
                Icons.mic_none,
                color: widget.iconColor,
                size: widget.size,
              ),
            )
          : Icon(
              Icons.mic,
              color: widget.iconColor,
              size: widget.size,
            ),
    );
  }
}

class MicrophoneIconWidget extends StatefulWidget {
  final double size;
  final Function()? onTap;

  const MicrophoneIconWidget({
    super.key,
    this.size = 24.0,
    this.onTap,
  });

  @override
  _MicrophoneIconWidgetState createState() => _MicrophoneIconWidgetState();
}

class _MicrophoneIconWidgetState extends State<MicrophoneIconWidget> {
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
