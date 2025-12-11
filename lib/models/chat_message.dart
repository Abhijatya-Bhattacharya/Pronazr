import 'package:file_picker/file_picker.dart';

enum MessageAuthor { user, bot }

class ChatMessage {
  final String id;
  final MessageAuthor author;
  final String text;
  final DateTime timestamp;
  final bool isLoading;
  final PlatformFile? attachedFile; // To show the name of the uploaded file

  ChatMessage({
    required this.id,
    required this.author,
    required this.text,
    required this.timestamp,
    this.isLoading = false,
    this.attachedFile,
  });
}