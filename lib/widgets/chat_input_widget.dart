import 'dart:async';
import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatInputWidget extends ConsumerStatefulWidget {
  final Function(String) onSend;

  const ChatInputWidget({super.key, required this.onSend});

  @override
  ConsumerState<ChatInputWidget> createState() => ChatInputWidgetState();
}

class ChatInputWidgetState extends ConsumerState<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      ref.read(chatInputProvider.notifier).updateHintIndex();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) async {
    if (text.isNotEmpty) {
      // Dismiss the keyboard
      FocusScope.of(context).unfocus();

      ref.read(chatInputProvider.notifier).setIsSending(true);
      await widget.onSend(text);
      ref.read(chatInputProvider.notifier).setIsSending(false);
      _controller.clear();
      ref.read(chatInputProvider.notifier).setIsComposing(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatInputState = ref.watch(chatInputProvider);

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
                ref
                    .read(chatInputProvider.notifier)
                    .setIsComposing(text.isNotEmpty);
              },
              onSubmitted:
                  chatInputState.isComposing && !chatInputState.isSending
                      ? _handleSubmitted
                      : null,
              enabled: !chatInputState.isSending,
              decoration: InputDecoration(
                hintText: ChatInputNotifier
                    .chatHints[chatInputState.currentHintIndex],
                hintStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.auto_awesome,
                ),
              ),
            ),
          ),
          IconButton(
            icon: chatInputState.isSending
                ? MySpinKitWaveSpinner(
                    size: 40,
                  )
                : Icon(Icons.send,
                    color: Theme.of(context).colorScheme.secondary),
            onPressed: chatInputState.isComposing && !chatInputState.isSending
                ? () => _handleSubmitted(_controller.text)
                : null,
          ),
        ],
      ),
    );
  }
}
