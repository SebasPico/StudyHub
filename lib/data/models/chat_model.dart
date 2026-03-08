/// Modelo de un mensaje de chat.
class ChatMessage {
  final String id;
  final String emisorId;
  final String receptorId;
  final String contenido;
  final DateTime fecha;
  final bool leido;

  const ChatMessage({
    required this.id,
    required this.emisorId,
    required this.receptorId,
    required this.contenido,
    required this.fecha,
    this.leido = false,
  });
}

/// Modelo de una conversación.
class ConversationModel {
  final String id;
  final String otroUsuarioId;
  final String otroUsuarioNombre;
  final String? otroUsuarioFotoUrl;
  final String ultimoMensaje;
  final DateTime fechaUltimoMensaje;
  final int mensajesNoLeidos;

  const ConversationModel({
    required this.id,
    required this.otroUsuarioId,
    required this.otroUsuarioNombre,
    this.otroUsuarioFotoUrl,
    required this.ultimoMensaje,
    required this.fechaUltimoMensaje,
    this.mensajesNoLeidos = 0,
  });
}
