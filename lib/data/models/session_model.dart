/// Enum para estado de la sesión.
enum SessionStatus { pendiente, confirmada, completada, cancelada }

/// Enum para modalidad de la sesión.
enum SessionModality { online, presencial }

/// Modelo de una sesión/clase agendada.
class SessionModel {
  final String id;
  final String tutorId;
  final String tutorNombre;
  final String? tutorFotoUrl;
  final String estudianteId;
  final String estudianteNombre;
  final String materia;
  final DateTime fechaHora;
  final int duracionMinutos;
  final SessionModality modalidad;
  final SessionStatus estado;
  final double precio;
  final String? enlaceVideoconferencia;
  final String? ubicacionPresencial;
  final String? notas;
  final DateTime? fechaCancelacion;
  final String? motivoCancelacion;

  const SessionModel({
    required this.id,
    required this.tutorId,
    required this.tutorNombre,
    this.tutorFotoUrl,
    required this.estudianteId,
    required this.estudianteNombre,
    required this.materia,
    required this.fechaHora,
    this.duracionMinutos = 60,
    required this.modalidad,
    this.estado = SessionStatus.pendiente,
    required this.precio,
    this.enlaceVideoconferencia,
    this.ubicacionPresencial,
    this.notas,
    this.fechaCancelacion,
    this.motivoCancelacion,
  });

  /// Crea una copia con los campos indicados sobreescritos.
  SessionModel copyWith({
    SessionStatus? estado,
    DateTime? fechaCancelacion,
    String? motivoCancelacion,
  }) {
    return SessionModel(
      id: id,
      tutorId: tutorId,
      tutorNombre: tutorNombre,
      tutorFotoUrl: tutorFotoUrl,
      estudianteId: estudianteId,
      estudianteNombre: estudianteNombre,
      materia: materia,
      fechaHora: fechaHora,
      duracionMinutos: duracionMinutos,
      modalidad: modalidad,
      estado: estado ?? this.estado,
      precio: precio,
      enlaceVideoconferencia: enlaceVideoconferencia,
      ubicacionPresencial: ubicacionPresencial,
      notas: notas,
      fechaCancelacion: fechaCancelacion ?? this.fechaCancelacion,
      motivoCancelacion: motivoCancelacion ?? this.motivoCancelacion,
    );
  }

  /// Devuelve el texto del estado.
  String get estadoTexto {
    switch (estado) {
      case SessionStatus.pendiente:
        return 'Pendiente';
      case SessionStatus.confirmada:
        return 'Confirmada';
      case SessionStatus.completada:
        return 'Completada';
      case SessionStatus.cancelada:
        return 'Cancelada';
    }
  }

  /// Devuelve el texto de la modalidad.
  String get modalidadTexto {
    switch (modalidad) {
      case SessionModality.online:
        return 'Online';
      case SessionModality.presencial:
        return 'Presencial';
    }
  }
}
