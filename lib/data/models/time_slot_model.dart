/// Modelo de bloque horario disponible del tutor.
class TimeSlotModel {
  final String id;
  final String tutorId;
  final int diaSemana; // 1=Lunes, 7=Domingo
  final String horaInicio; // Formato "HH:mm"
  final String horaFin;
  final bool disponible;

  const TimeSlotModel({
    required this.id,
    required this.tutorId,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
    this.disponible = true,
  });

  /// Devuelve el nombre del día.
  String get nombreDia {
    const dias = {
      1: 'Lunes',
      2: 'Martes',
      3: 'Miércoles',
      4: 'Jueves',
      5: 'Viernes',
      6: 'Sábado',
      7: 'Domingo',
    };
    return dias[diaSemana] ?? '';
  }
}
