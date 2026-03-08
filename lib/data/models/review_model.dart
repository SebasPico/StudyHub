/// Modelo de reseña/calificación.
class ReviewModel {
  final String id;
  final String sesionId;
  final String tutorId;
  final String estudianteId;
  final String estudianteNombre;
  final String? estudianteFotoUrl;
  final double calificacion;
  final String comentario;
  final DateTime fecha;

  const ReviewModel({
    required this.id,
    required this.sesionId,
    required this.tutorId,
    required this.estudianteId,
    required this.estudianteNombre,
    this.estudianteFotoUrl,
    required this.calificacion,
    this.comentario = '',
    required this.fecha,
  });
}
