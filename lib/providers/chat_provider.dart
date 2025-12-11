import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:proanzr/api/api_service.dart';
import 'package:proanzr/models/chat_message.dart';
import 'package:uuid/uuid.dart';

// Available LLM models
const List<String> availableModels = [
  'llama3:latest',
  'llama3:8b',
  'deepseek-r1:14b',
  'mistral:latest',
];

// Selected model provider
final selectedModelProvider = StateProvider<String>(
  (ref) => availableModels.first,
);

final apiServiceProvider = Provider((ref) => ApiService());

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((
  ref,
) {
  return ChatNotifier(ref.watch(apiServiceProvider));
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final ApiService _apiService;
  final Uuid _uuid = const Uuid();

  ChatNotifier(this._apiService) : super([]);

  Future<void> sendMessage({
    required String prompt,
    required bool useInternet,
    required String model,
    PlatformFile? file,
  }) async {
    print('ChatProvider Debug: useInternet = $useInternet');

    // Add user message to state
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      author: MessageAuthor.user,
      text: prompt,
      timestamp: DateTime.now(),
      attachedFile: file,
    );
    state = [...state, userMessage];

    // Add a loading bot message
    final botMessageId = _uuid.v4();
    final loadingMessage = ChatMessage(
      id: botMessageId,
      author: MessageAuthor.bot,
      text: "...",
      timestamp: DateTime.now(),
      isLoading: true,
    );
    state = [...state, loadingMessage];

    try {
      final stream = _apiService.sendMessage(
        prompt: prompt,
        useInternet: useInternet,
        model: model,
        conversationHistory: state, // Pass current conversation history
        file: file,
      );

      String responseText = "";
      await for (final chunk in stream) {
        responseText += chunk;
        state = [
          for (final msg in state)
            if (msg.id == botMessageId)
              ChatMessage(
                id: msg.id,
                author: MessageAuthor.bot,
                text: responseText,
                timestamp: msg.timestamp,
                isLoading: true, // Still loading until stream is done
              )
            else
              msg,
        ];
      }

      // Finalize bot message
      state = [
        for (final msg in state)
          if (msg.id == botMessageId)
            ChatMessage(
              id: msg.id,
              author: MessageAuthor.bot,
              text: responseText,
              timestamp: msg.timestamp,
              isLoading: false, // Done loading
            )
          else
            msg,
      ];
    } catch (e) {
      // Handle error
      state = [
        for (final msg in state)
          if (msg.id == botMessageId)
            ChatMessage(
              id: msg.id,
              author: MessageAuthor.bot,
              text: "Sorry, I ran into an error: $e",
              timestamp: DateTime.now(),
              isLoading: false,
            )
          else
            msg,
      ];
    }
  }
}
