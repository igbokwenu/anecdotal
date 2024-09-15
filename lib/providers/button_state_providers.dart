import 'dart:async';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_input_state.dart';

final chatInputProvider =
    StateNotifierProvider<ChatInputNotifier, ChatInputState>(
        (ref) => ChatInputNotifier());

class ChatInputNotifier extends StateNotifier<ChatInputState> {
  Timer? _analyzingTimer;

  ChatInputNotifier()
      : super(ChatInputState(
          isComposing: false,
          isSending: false,
          currentHintIndex: 0,
          isProcessingAudio: false,
          isListeningToAudio: false,
          isAnalyzing: false,
        ));

  void setIsAnalyzing(bool value) {
    if (value) {
      // Start the timer to reset isAnalyzing after 40 seconds
      _analyzingTimer?.cancel(); // Cancel any previous timer
      _analyzingTimer = Timer(const Duration(seconds: 60), () {
        if (state.isAnalyzing) {
          state = state.copyWith(isAnalyzing: false);
          MyReusableFunctions.showCustomToast(
              description: "Time out. Something went wrong 🥲");
        }
      });
    } else {
      // Cancel the timer if isAnalyzing is set to false manually
      _analyzingTimer?.cancel();
    }

    state = state.copyWith(isAnalyzing: value);
  }

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

  void setIsProcessingAudio(bool value) {
    state = state.copyWith(isProcessingAudio: value);
  }

  void setIsListeningToAudio(bool value) {
    state = state.copyWith(isListeningToAudio: value);
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
