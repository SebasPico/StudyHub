import 'user_model.dart';

/// Modelo de perfil de estudiante.
class StudentModel extends UserModel {
  final List<String> materiasInteres;
  final int clasesTomadas;

  const StudentModel({
    required super.id,
    required super.nombre,
    required super.correo,
    super.fotoUrl,
    super.telefono,
    super.ubicacion,
    required super.fechaRegistro,
    super.verificado,
    this.materiasInteres = const [],
    this.clasesTomadas = 0,
  }) : super(rol: UserRole.estudiante);
}
