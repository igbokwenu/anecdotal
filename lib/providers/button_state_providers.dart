// file: lib/notifiers/chat_input_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_input_state.dart';


final chatInputProvider =
    StateNotifierProvider<ChatInputNotifier, ChatInputState>(
        (ref) => ChatInputNotifier());

class ChatInputNotifier extends StateNotifier<ChatInputState> {
  ChatInputNotifier()
      : super(ChatInputState(
          isComposing: false,
          isSending: false,
          currentHintIndex: 0,
        ));

  void setIsComposing(bool value) {
    state = state.copyWith(isComposing: value);
  }

  void setIsSending(bool value) {
    state = state.copyWith(isSending: value);
  }

  void updateHintIndex() {
    state = state.copyWith(
        currentHintIndex: (state.currentHintIndex + 1) % chatHints.length);
  }

  static const List<String> chatHints = [
    'I am feeling very weak...',
    "I can't concentrate...",
    "How do I start treatment...",
    "What binder is most effective...",
    "I feel like I can't breathe properly...",
    "After starting treatment, my symptoms got worse...",
    "My family does not believe that I am sick...",
  ];
}