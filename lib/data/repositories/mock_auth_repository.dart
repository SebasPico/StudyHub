import '../mock/mock_data.dart';
import '../models/auth_session_model.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Implementacion mock de autenticacion lista para sustituirse por API real.
class MockAuthRepository implements AuthRepository {
  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final emailLower = email.trim().toLowerCase();

    if (emailLower == 'admin@studyhub.com') {
      return const AuthSessionModel(
        role: UserRole.administrador,
        userId: 'admin1',
        userName: 'Administrador',
      );
    }

    final tutor = MockData.tutores
        .where((t) => t.correo.toLowerCase() == emailLower)
        .firstOrNull;
    if (tutor != null) {
      return AuthSessionModel(
        role: UserRole.tutor,
        userId: tutor.id,
        userName: tutor.nombre,
        userPhoto: tutor.fotoUrl,
        userLocation: tutor.ubicacion ?? '',
        userPhone: tutor.telefono ?? '',
      );
    }

    final student = MockData.estudianteActual;
    return AuthSessionModel(
      role: UserRole.estudiante,
      userId: student.id,
      userName: student.nombre,
      userPhoto: student.fotoUrl,
      userLocation: student.ubicacion ?? '',
      userPhone: student.telefono ?? '',
    );
  }

  @override
  Future<AuthSessionModel> register({
    required String nombre,
    required String email,
    required UserRole rol,
    required String password,
  }) async {
    return AuthSessionModel(
      role: rol == UserRole.tutor ? UserRole.tutor : UserRole.estudiante,
      userId: rol == UserRole.tutor ? 't_new' : 'e_new',
      userName: nombre,
    );
  }
}
