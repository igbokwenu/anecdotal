class ChatInputState {
  final bool isComposing;
  final bool isSending;
  final int currentHintIndex;
  final bool isProcessingAudio;
  final bool isListeningToAudio;
  final bool isAnalyzing;

  ChatInputState({
    required this.isComposing,
    required this.isSending,
    required this.currentHintIndex,
    required this.isProcessingAudio,
     required this.isListeningToAudio, 
     required this.isAnalyzing,
  });

  ChatInputState copyWith({
    bool? isComposing,
    bool? isSending,
    int? currentHintIndex,
    bool? isProcessingAudio,
    bool? isListeningToAudio,
    bool? isAnalyzing,
  }) {
    return ChatInputState(
      isComposing: isComposing ?? this.isComposing,
      isSending: isSending ?? this.isSending,
      currentHintIndex: currentHintIndex ?? this.currentHintIndex,
      isProcessingAudio: isProcessingAudio ?? this.isProcessingAudio,
      isListeningToAudio: isListeningToAudio ?? this.isListeningToAudio,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
    );
  }
}


/*

To use this method for other buttons or UI elements in the future:

Extend the ChatInputState class to include new state variables for your buttons.
Add new methods in the ChatInputNotifier class to update these state variables.
In your widget, use ref.watch(chatInputProvider) to access the current state and ref.read(chatInputProvider.notifier) to call methods that update the state.

For example, if you want to add a new button that toggles between two states:

Update the ChatInputState:

class ChatInputState {
  // ... existing properties
  final bool isNewButtonActive;

  ChatInputState({
    // ... existing parameters
    required this.isNewButtonActive,
  });

  // Update copyWith method
}

Add a method to ChatInputNotifier:

class ChatInputNotifier extends StateNotifier<ChatInputState> {
  // ... existing methods

  void toggleNewButton() {
    state = state.copyWith(isNewButtonActive: !state.isNewButtonActive);
  }
}

Use the new state in your widget:
IconButton(
  icon: Icon(
    chatInputState.isNewButtonActive ? Icons.check : Icons.close,
    color: Theme.of(context).colorScheme.secondary,
  ),
  onPressed: () => ref.read(chatInputProvider.notifier).toggleNewButton(),
)
*/