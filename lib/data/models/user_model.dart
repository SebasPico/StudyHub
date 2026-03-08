/// Enum para roles de usuario.
enum UserRole { estudiante, tutor, administrador }

/// Modelo base de usuario.
class UserModel {
  final String id;
  final String nombre;
  final String correo;
  final String? fotoUrl;
  final String? telefono;
  final String? ubicacion;
  final UserRole rol;
  final DateTime fechaRegistro;
  final bool verificado;

  const UserModel({
    required this.id,
    required this.nombre,
    required this.correo,
    this.fotoUrl,
    this.telefono,
    this.ubicacion,
    required this.rol,
    required this.fechaRegistro,
    this.verificado = false,
  });
}
