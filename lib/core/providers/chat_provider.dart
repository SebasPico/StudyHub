import 'package:flutter/foundation.dart';
import '../../data/models/chat_model.dart';
import '../services/studyhub_local_backend.dart';

/// Gestión reactiva de conversaciones y mensajes de chat.
class ChatProvider extends ChangeNotifier {
  final StudyHubLocalBackend _backend;
  late List<ConversationModel> _conversations;
  late Map<String, List<ChatMessage>> _messages;

  ChatProvider({StudyHubLocalBackend? backend})
      : _backend = backend ?? StudyHubLocalBackend.instance {
    _conversations = List<ConversationModel>.from(_backend.conversations);
    _messages = _backend.messagesByConversation;
    _backend.addListener(_syncFromBackend);
  }

  void _syncFromBackend() {
    _conversations = List<ConversationModel>.from(_backend.conversations);
    _messages = _backend.messagesByConversation;
    notifyListeners();
  }

  List<ConversationModel> get conversations =>
      List.unmodifiable(_conversations);

  /// Devuelve mensajes para una conversación (por ID de conv o ID de usuario).
  List<ChatMessage> messagesFor(String conversationId) {
    if (_messages.containsKey(conversationId)) {
      return List.unmodifiable(_messages[conversationId]!);
    }
    // Fallback: buscar por ID del otro usuario
    final conv = _conversations
        .cast<ConversationModel?>()
        .firstWhere((c) => c!.otroUsuarioId == conversationId,
            orElse: () => null);
    if (conv != null && _messages.containsKey(conv.id)) {
      return List.unmodifiable(_messages[conv.id]!);
    }
    return const [];
  }

  /// Resuelve a qué clave de _messages corresponde el ID dado.
  String _resolveKey(String conversationOrUserId) {
    if (_messages.containsKey(conversationOrUserId)) {
      return conversationOrUserId;
    }
    final conv = _conversations
        .cast<ConversationModel?>()
        .firstWhere((c) => c!.otroUsuarioId == conversationOrUserId,
            orElse: () => null);
    return conv?.id ?? conversationOrUserId;
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String text,
    String? receiverName,
    String? receiverPhoto,
  }) async {
    await _backend.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      receiverName: receiverName,
      receiverPhoto: receiverPhoto,
    );
    _syncFromBackend();
  }

  Future<void> markAsRead(String conversationId) async {
    await _backend.markAsRead(conversationId);
    _syncFromBackend();
  }

  @override
  void dispose() {
    _backend.removeListener(_syncFromBackend);
    super.dispose();
  }
}
