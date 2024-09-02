
class ChatInputState {
  final bool isComposing;
  final bool isSending;
  final int currentHintIndex;

  ChatInputState({
    required this.isComposing,
    required this.isSending,
    required this.currentHintIndex,
  });

  ChatInputState copyWith({
    bool? isComposing,
    bool? isSending,
    int? currentHintIndex,
  }) {
    return ChatInputState(
      isComposing: isComposing ?? this.isComposing,
      isSending: isSending ?? this.isSending,
      currentHintIndex: currentHintIndex ?? this.currentHintIndex,
    );
  }
}