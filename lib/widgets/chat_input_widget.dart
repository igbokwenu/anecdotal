import 'dart:async';
import 'package:flutter/material.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSend;

  const ChatInputWidget({super.key, required this.onSend});

  @override
  ChatInputWidgetState createState() => ChatInputWidgetState();
}

class ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;
  late Timer _timer;
  int _currentHintIndex = 0;

  final List<String> _hints = [
    'I am feeling very weak...',
    "I can't concentrate...",
    "How do I start treatment...",
    "What binder is most effective...",
    "I feel like I can't breathe properly...",
    "After starting treatment, my symptoms got worse..."
        "My family does not believe that I am sick..."
    // Add more hints if needed
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentHintIndex = (_currentHintIndex + 1) % _hints.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    widget.onSend(text);
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Theme.of(context).hintColor.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: _isComposing ? _handleSubmitted : null,
              decoration: InputDecoration(
                hintText: _hints[_currentHintIndex],
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.auto_awesome,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send,
                color: Theme.of(context).colorScheme.secondary),
            onPressed:
                _isComposing ? () => _handleSubmitted(_controller.text) : null,
          ),
        ],
      ),
    );
  }
}
