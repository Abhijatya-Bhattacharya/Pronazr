import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:proanzr/models/chat_message.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  // IMPORTANT: Replace with your computer's local IP address
  static const String _baseUrl = "http://172.20.10.5:8000/api";

  Stream<String> sendMessage({
    required String prompt,
    required bool useInternet,
    required String model,
    List<ChatMessage> conversationHistory = const [],
    PlatformFile? file,
  }) async* {
    try {
      // Build conversation history for better context
      String contextualPrompt = prompt;
      if (conversationHistory.isNotEmpty) {
        final recentHistory = conversationHistory
            .where((msg) => !msg.isLoading)
            .toList()
            .reversed
            .take(6) // Last 3 exchanges (6 messages)
            .toList()
            .reversed
            .map(
              (msg) =>
                  '${msg.author == MessageAuthor.user ? "Human" : "Assistant"}: ${msg.text}',
            )
            .join('\n');
        contextualPrompt = '$recentHistory\nHuman: $prompt';
      }

      final formData = FormData.fromMap({
        'prompt': contextualPrompt,
        'use_internet': useInternet,
        'model': model,
        if (file != null)
          'file': MultipartFile.fromBytes(file.bytes!, filename: file.name),
      });

      debugPrint('API Debug: Sending request with use_internet = $useInternet');

      final response = await _dio.post(
        '$_baseUrl/chat',
        data: formData,
        options: Options(responseType: ResponseType.stream),
      );

      if (response.statusCode == 200) {
        final stream = (response.data as ResponseBody).stream;
        await for (var chunk in stream) {
          // Assuming the stream sends bytes that are UTF-8 encoded strings
          yield String.fromCharCodes(chunk);
        }
      } else {
        throw Exception('Failed to send message: ${response.statusMessage}');
      }
    } catch (e) {
      // Use debugPrint instead of print for better production practices
      debugPrint('ApiService Error: $e');
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
