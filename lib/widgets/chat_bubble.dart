import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:proanzr/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.author == MessageAuthor.user;
    final isLoading = message.isLoading;

    return Container(
      margin: EdgeInsets.only(
        left: isUser ? 40 : 16,
        right: isUser ? 16 : 40,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser ? null : const Color(0xFF374151),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                        : const Color(0xFF000000).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.attachedFile != null)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            message.attachedFile!.name.endsWith('.pdf')
                                ? Icons.picture_as_pdf
                                : Icons.description,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              message.attachedFile!.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    child: isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isUser
                                        ? Colors.white
                                        : const Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'AI is thinking...',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isUser
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : Colors.white.withValues(alpha: 0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        : MarkdownBody(
                            data: message.text,
                            selectable: true,
                            styleSheet: MarkdownStyleSheet.fromTheme(theme)
                                .copyWith(
                                  p: theme.textTheme.bodyLarge?.copyWith(
                                    color: isUser
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.95),
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                  code: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                    backgroundColor: Colors.black.withValues(
                                      alpha: 0.2,
                                    ),
                                    color: isUser
                                        ? Colors.white.withValues(alpha: 0.9)
                                        : const Color(0xFF6366F1),
                                  ),
                                  codeblockDecoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                ),
                          ),
                  ),

                  // Timestamp
                  if (!isLoading)
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 8,
                      ),
                      child: Text(
                        _formatTimestamp(message.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isUser
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.white.withValues(alpha: 0.5),
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF374151),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF6366F1),
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
