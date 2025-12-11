import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatProvider);
    final selectedModel = ref.watch(selectedModelProvider);
    final availableModels = [
      'llama3:latest',
      'llama3:8b',
      'deepseek-r1:14b',
      'mistral:latest',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'PROANZR',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 24,
            fontFamily: 'Inter',
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: DropdownButton<String>(
              value: selectedModel,
              underline: SizedBox(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
              items: availableModels.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_getModelEmoji(model)),
                      SizedBox(width: 8),
                      Text(_getModelDisplayName(model)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newModel) {
                if (newModel != null) {
                  ref.read(selectedModelProvider.notifier).state = newModel;
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Semantics(
              label: 'Chat conversation',
              child: messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      key: const ValueKey('chat_list'),
                      padding: EdgeInsets.all(20),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return RepaintBoundary(
                          key: ValueKey('repaint_${message.id}'),
                          child: _buildNeoBrutalistChatBubble(message),
                        );
                      },
                    ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black, width: 3)),
            ),
            child: MessageInputBar(
              key: const ValueKey('message_input'),
              onSend: (message, includeHistory, file) {
                print(
                  'Debug: Sending message with useInternet = $includeHistory',
                );
                ref
                    .read(chatProvider.notifier)
                    .sendMessage(
                      prompt: message,
                      useInternet: includeHistory,
                      model: selectedModel,
                      file: file,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: Center(
              child: Text(
                'AI',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          Text(
            'START CONVERSATION',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Inter',
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Type a message to begin chatting',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeoBrutalistChatBubble(ChatMessage message) {
    bool isUser = message.author == MessageAuthor.user;
    return Container(
      key: ValueKey(message.id),
      margin: EdgeInsets.only(
        left: isUser ? 60 : 0,
        right: isUser ? 0 : 60,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Center(
                child: Text(
                  'AI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isUser ? Colors.black : Colors.white,
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 16),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Center(
                child: Text(
                  'U',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getModelEmoji(String model) {
    if (model.contains('llama')) return '🦙';
    if (model.contains('gemma')) return '🔮';
    if (model.contains('mistral')) return '🌪️';
    if (model.contains('deepseek')) return '🧠';
    return '🤖';
  }

  String _getModelDisplayName(String model) {
    if (model == 'llama3:latest') return 'LLAMA 3';
    if (model == 'llama3:8b') return 'LLAMA 3 8B';
    if (model == 'deepseek-r1:14b') return 'DEEPSEEK R1';
    if (model == 'mistral:latest') return 'MISTRAL';
    return model.toUpperCase();
  }
}

class MessageInputBar extends StatefulWidget {
  final Function(String, bool, PlatformFile?) onSend;

  const MessageInputBar({super.key, required this.onSend});

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _includeHistory = false; // Default to false to make it more obvious
  PlatformFile? _selectedFile;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty || _selectedFile != null) {
      widget.onSend(text, _includeHistory, _selectedFile);
      _controller.clear();
      setState(() {
        _selectedFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedFile != null) _buildFilePreview(),
          Row(
            children: [
              // File attachment button
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Icon(Icons.attach_file, color: Colors.black, size: 22),
                ),
              ),
              SizedBox(width: 16),

              // Text input field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      hintText: _includeHistory
                          ? 'Ask anything (Internet enabled 🌐)...'
                          : 'Type your message...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Send button
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Icon(Icons.send, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Controls row with toggles
          Row(
            children: [
              // Include history toggle
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _includeHistory = !_includeHistory;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _includeHistory ? Colors.black : Colors.white,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _includeHistory ? '🌐' : '✗',
                          style: TextStyle(
                            color: _includeHistory
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'INTERNET SEARCH',
                            style: TextStyle(
                              color: _includeHistory
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreview() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: Icon(Icons.description, color: Colors.white, size: 18),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              _selectedFile!.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: _removeFile,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
