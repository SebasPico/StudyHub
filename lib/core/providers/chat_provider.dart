import 'package:flutter/foundation.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/chat_model.dart';

/// Gestión reactiva de conversaciones y mensajes de chat.
class ChatProvider extends ChangeNotifier {
  final List<ConversationModel> _conversations;
  final Map<String, List<ChatMessage>> _messages;

  ChatProvider()
      : _conversations = List<ConversationModel>.from(MockData.conversaciones),
        _messages = {
          'c1': List<ChatMessage>.from(MockData.mensajesChat),
          'c2': [],
          'c3': [],
        };

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

  void sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String text,
    String? receiverName,
    String? receiverPhoto,
  }) {
    final key = _resolveKey(conversationId);

    _messages.putIfAbsent(key, () => []);
    _messages[key]!.add(ChatMessage(
      id: 'm${_messages[key]!.length + 1}',
      emisorId: senderId,
      receptorId: receiverId,
      contenido: text,
      fecha: DateTime.now(),
      leido: false,
    ));

    // Actualizar o crear conversación
    final convIdx = _conversations.indexWhere((c) => c.id == key);
    if (convIdx != -1) {
      final c = _conversations[convIdx];
      _conversations[convIdx] = ConversationModel(
        id: c.id,
        otroUsuarioId: c.otroUsuarioId,
        otroUsuarioNombre: c.otroUsuarioNombre,
        otroUsuarioFotoUrl: c.otroUsuarioFotoUrl,
        ultimoMensaje: text,
        fechaUltimoMensaje: DateTime.now(),
        mensajesNoLeidos: 0,
      );
    } else {
      // Nueva conversación (abierta desde el perfil del tutor)
      _conversations.insert(
        0,
        ConversationModel(
          id: key,
          otroUsuarioId: receiverId,
          otroUsuarioNombre: receiverName ?? 'Tutor',
          otroUsuarioFotoUrl: receiverPhoto,
          ultimoMensaje: text,
          fechaUltimoMensaje: DateTime.now(),
          mensajesNoLeidos: 0,
        ),
      );
    }

    notifyListeners();
  }

  void markAsRead(String conversationId) {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx == -1 || _conversations[idx].mensajesNoLeidos == 0) return;
    final c = _conversations[idx];
    _conversations[idx] = ConversationModel(
      id: c.id,
      otroUsuarioId: c.otroUsuarioId,
      otroUsuarioNombre: c.otroUsuarioNombre,
      otroUsuarioFotoUrl: c.otroUsuarioFotoUrl,
      ultimoMensaje: c.ultimoMensaje,
      fechaUltimoMensaje: c.fechaUltimoMensaje,
      mensajesNoLeidos: 0,
    );
    notifyListeners();
  }
}
